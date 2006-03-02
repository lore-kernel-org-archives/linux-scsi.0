From: Konstantin Khorenko <khorenko@sw.ru>
Subject: [patch scsi] cciss: make fair timeouts during initialization
Date: Thu, 02 Mar 2006 10:10:53 +0300
Message-ID: <44069A7D.4030201@sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070502030508090406070502"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:41096 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1751405AbWCBHLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 02:11:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Vasily Averin <vvs@sw.ru>, linux-scsi@vger.kernel.org, iss_storagedev@hp.com, devel@openvz.org, Kirill Korotaev <dev@sw.ru>

This is a multi-part message in MIME format.
--------------070502030508090406070502
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patch makes fair initialization timeouts in cciss driver.

Signed-off-by: Konstantin Khorenko <khorenko@sw.ru>

-----------------------------------
cciss driver has following code for timeouts during board initialization:
        ...
        for(i=0;i<MAX_CONFIG_WAIT;i++) {
                ...
                set_current_state(TASK_INTERRUPTIBLE);
                schedule_timeout(10);
        }
        ...

We compile cciss driver into the kernel and thus at the kernel boot
schedule_timeout() returns very quickly and resulted timeouts became
insufficient for correct board initialization.
Particularly, we often got following error:
--
HP CISS Driver (v 2.6.8)
cciss: Device 0x46 has been found at bus 6 dev 1 func 0
cciss: unable to get board into simple mode
cciss: probe of 0000:06:01.0 failed with error -1
--

The patch is designed to make fair initialization timeouts.

----------
Hope, you'll check this changes and find them usefull. :)
Kernel with patch was compiled and tested on two nodes.
This patch is against mainstream 2.6.16-rc5 kernel.

-- 
Best regards,

Konstantin Khorenko,
SWsoft, Inc.

--------------070502030508090406070502
Content-Type: text/plain;
 name="diff-cciss-fair-init-timeouts"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-cciss-fair-init-timeouts"

--- ./drivers/block/cciss.c.16-rc5	2006-03-01 11:13:03.000000000 +0300
+++ ./drivers/block/cciss.c	2006-03-02 09:30:38.000000000 +0300
@@ -1893,7 +1893,7 @@ static unsigned long pollcomplete(int ct
 	for (i = 20 * HZ; i > 0; i--) {
 		done = hba[ctlr]->access.command_completed(hba[ctlr]);
 		if (done == FIFO_EMPTY)
-			schedule_timeout_uninterruptible(1);
+			msleep(1);
 		else
 			return (done);
 	}
@@ -2817,8 +2817,7 @@ static int cciss_pci_init(ctlr_info_t *c
 		scratchpad = readl(c->vaddr + SA5_SCRATCHPAD_OFFSET);
 		if (scratchpad == CCISS_FIRMWARE_READY)
 			break;
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10); /* wait 100ms */
+		msleep(100); /* wait 100ms */
 	}
 	if (scratchpad != CCISS_FIRMWARE_READY) {
 		printk(KERN_WARNING "cciss: Board not ready.  Timed out.\n");
@@ -2903,8 +2902,7 @@ static int cciss_pci_init(ctlr_info_t *c
 		if (!(readl(c->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(10);
+		msleep(10);
 	}	
 
 #ifdef CCISS_DEBUG
#
# Patch makes fair initialization timeouts in cciss driver.
#
# Signed-off-by: Konstantin Khorenko <khorenko@sw.ru>

--------------070502030508090406070502--

