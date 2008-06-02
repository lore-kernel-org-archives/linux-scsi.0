From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [Fwd: linux-next: scsi build failure]
Date: Mon, 02 Jun 2008 09:21:44 -0500
Message-ID: <1212416504.3369.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40590 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801AbYFBOVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 10:21:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 7084C87FF
	for <linux-scsi@vger.kernel.org>; Mon,  2 Jun 2008 09:21:46 -0500 (CDT)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kv0To9zN-ETS for <linux-scsi@vger.kernel.org>;
	Mon,  2 Jun 2008 09:21:45 -0500 (CDT)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 404CF7F13
	for <linux-scsi@vger.kernel.org>; Mon,  2 Jun 2008 09:21:45 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

-------- Forwarded Message --------
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, Sathya Prakash <sathya.prakash@lsi.com>,
Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Subject: linux-next: scsi build failure
Date: Mon, 2 Jun 2008 15:07:42 +1000

Hi James,

Today's linux-next build (x86_64 allmodconfig) failed like this:

In file included from drivers/message/fusion/mptscsih.c:66:
drivers/message/fusion/mptbase.h:715: error: 'KOBJ_NAME_LEN' undeclared here (not in a function)
In file included from drivers/message/fusion/mptbase.c:67:
drivers/message/fusion/mptbase.h:715: error: 'KOBJ_NAME_LEN' undeclared here (not in a function)

This is caused by commit 6146eaf4fb31588ecc72ab3c52c6b1f3e7602a7c
("[SCSI] mpt fusion : Adding FAULT Reset polling work") adding a usage of
KOBJ_NAME_LEN while commit 242d02fdc8d1764117a2e5fefd9e57b84d21bf40
("driver core: remove KOBJ_NAME_LEN define") from the driver-core tree
has removed it.  The change in that latter commit is to replace all
usages with 20, so I applied the following patch.  Something like this
could be integrated into the former commit.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

>From 0975add46554364e3943e56b8e6a4800e38bb9e9 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 2 Jun 2008 15:06:02 +1000
Subject: [PATCH] scsi: fix fallout from KOBJ_NAME_LEN removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/message/fusion/mptbase.c |    2 +-
 drivers/message/fusion/mptbase.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d18a707..a758110 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1670,7 +1670,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
 	spin_lock_init(&ioc->fault_reset_work_lock);
 
-	snprintf(ioc->reset_work_q_name, KOBJ_NAME_LEN, "mpt_poll_%d", ioc->id);
+	snprintf(ioc->reset_work_q_name, sizeof(ioc->reset_work_q_name), "mpt_poll_%d", ioc->id);
 	ioc->reset_work_q =
 		create_singlethread_workqueue(ioc->reset_work_q_name);
 	if (!ioc->reset_work_q) {
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 94ab8f1..dff048c 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -712,7 +712,7 @@ typedef struct _MPT_ADAPTER
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
 
-	char			 reset_work_q_name[KOBJ_NAME_LEN];
+	char			 reset_work_q_name[20];
 	struct workqueue_struct *reset_work_q;
 	struct delayed_work	 fault_reset_work;
 	spinlock_t		 fault_reset_work_lock;

