From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] Use msleep() instead of schedule_timeout
Date: Tue, 8 Dec 2009 14:02:45 -0800
Message-ID: <20091208140245.e654805c.akpm@linux-foundation.org>
References: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
	<20091208213812.23493.20587.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966481AbZLHWDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2009 17:03:10 -0500
In-Reply-To: <20091208213812.23493.20587.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

On Tue, 08 Dec 2009 15:38:12 -0600
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> Use msleep() instead of schedule_timeout

msleep() does set_current_state() itself.


--- a/drivers/scsi/hpsa.c~hpsa-use-msleep-instead-of-schedule_timeout-fix
+++ a/drivers/scsi/hpsa.c
@@ -1949,7 +1949,6 @@ static int wait_for_device_to_become_rea
 		/* Wait for a bit.  do this first, because if we send
 		 * the TUR right away, the reset will just abort it.
 		 */
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(1000 * waittime);
 		count++;
 
@@ -2838,7 +2837,6 @@ static __devinit int hpsa_message(struct
 		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
 		if (HPSA_TAG_DISCARD_ERROR_BITS(tag) == paddr32)
 			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(HPSA_MSG_SEND_RETRY_INTERVAL_MSECS);
 	}
 
@@ -2952,7 +2950,6 @@ static __devinit int hpsa_hard_reset_con
 	pmcsr |= PCI_D3hot;
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
-	set_current_state(TASK_UNINTERRUPTIBLE);
 	msleep(500);
 
 	/* enter the D0 power management state */
@@ -2960,7 +2957,6 @@ static __devinit int hpsa_hard_reset_con
 	pmcsr |= PCI_D0;
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
-	set_current_state(TASK_UNINTERRUPTIBLE);
 	msleep(500);
 
 	/* Restore the PCI configuration space.  The Open CISS
@@ -3187,7 +3183,6 @@ static int hpsa_pci_init(struct ctlr_inf
 		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 		if (scratchpad == HPSA_FIRMWARE_READY)
 			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
 	if (scratchpad != HPSA_FIRMWARE_READY) {
@@ -3262,7 +3257,6 @@ static int hpsa_pci_init(struct ctlr_inf
 		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(10);
 	}
 
@@ -3302,7 +3296,6 @@ static int __devinit hpsa_init_one(struc
 
 		/* Some devices (notably the HP Smart Array 5i Controller)
 		   need a little pause here */
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
 		/* Now try to get the controller to respond to a no-op */
diff -puN drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout-fix drivers/scsi/hpsa.h
_

