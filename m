From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 04/14] cxlflash: Avoid command room violation
Date: Tue, 15 Nov 2016 17:14:25 -0600
Message-ID: <1479251665-22816-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36297 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030207AbcKOXOf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:14:35 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFNE7aq076931
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:14:35 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26r77vjhft-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:14:34 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 16:14:34 -0700
In-Reply-To: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

During test, a command room violation interrupt is occasionally seen
for the master context when the CXL flash devices are stressed.

After studying the code, there could be gaps in the way command room
value is being cached in cxlflash. When the cached command room is zero
the thread attempting to send becomes burdened with updating the cached
value with the actual value from the AFU. Today, this is handled with
an atomic set operation of the raw value read. Following the atomic
update, the thread proceeds to send.

This behavior is incorrect on two counts:

   - The update fails to take into account the current thread and its
     consumption of one of the hardware commands.

   - The update does not take into account other threads also atomically
     updating. Per design, a worker thread updates the cached value when
     a send thread times out. By not performing an atomic compare/exchange,
     the cached value can be incorrectly clobbered.

To correct these issues, the runtime updates of the cached command room
are updated to use atomic64_cmpxchg() and the send routine is updated to
take into account the current thread consuming a hardware command.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6d33d8c..1a32e8b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -322,9 +322,10 @@ static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
 	if (!newval) {
 		do {
 			room = readq_be(&afu->host_map->cmd_room);
-			atomic64_set(&afu->room, room);
-			if (room)
-				goto write_ioarrin;
+			if (room) {
+				atomic64_cmpxchg(&afu->room, 0, room);
+				goto retry;
+			}
 			udelay(1 << nretry);
 		} while (nretry++ < MC_ROOM_RETRY_CNT);
 
@@ -346,7 +347,6 @@ static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
 		goto no_room;
 	}
 
-write_ioarrin:
 	writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
 out:
 	pr_devel("%s: cmd=%p len=%d ea=%p rc=%d\n", __func__, cmd,
@@ -2409,6 +2409,7 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
 	int port;
+	u64 room;
 	ulong lock_flags;
 
 	/* Avoid MMIO if the device has failed */
@@ -2437,8 +2438,11 @@ static void cxlflash_worker_thread(struct work_struct *work)
 	}
 
 	if (afu->read_room) {
-		atomic64_set(&afu->room, readq_be(&afu->host_map->cmd_room));
-		afu->read_room = false;
+		room = readq_be(&afu->host_map->cmd_room);
+		if (room) {
+			atomic64_cmpxchg(&afu->room, 0, room);
+			afu->read_room = false;
+		}
 	}
 
 	spin_unlock_irqrestore(cfg->host->host_lock, lock_flags);
-- 
2.1.0

