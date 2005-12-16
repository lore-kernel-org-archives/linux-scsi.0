From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] lpfc:   Timer fix
Date: Fri, 16 Dec 2005 13:16:53 -0800
Message-ID: <1134767813.5539.18.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:59789 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932447AbVLPVQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2005 16:16:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James,

I've been doing some testing with the lpfc driver and started running
into some BUG_ON problems using add_timer in lpfc_els_timeout_handler.
I'm not certain, but I think that the add_timer call should be a
mod_timer.
Please take a look.

Signed-of-by: Mark Haverkamp <markh@osdl.org>

---

Index: scsi-misc-2.6/drivers/scsi/lpfc/lpfc_els.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/lpfc/lpfc_els.c	2005-12-16 13:14:37.000000000 -0800
+++ scsi-misc-2.6/drivers/scsi/lpfc/lpfc_els.c	2005-12-16 13:14:53.000000000 -0800
@@ -2935,8 +2935,7 @@
 			lpfc_sli_release_iocbq(phba, piocb);
 	}
 	if (phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt) {
-		phba->els_tmofunc.expires = jiffies + HZ * timeout;
-		add_timer(&phba->els_tmofunc);
+		mod_timer(&phba->els_tmofunc, jiffies + HZ * timeout);
 	}
 	spin_unlock_irq(phba->host->host_lock);
 }

-- 
Mark Haverkamp <markh@osdl.org>

