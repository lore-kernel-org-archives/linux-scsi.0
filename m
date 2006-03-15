From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] lpfc: Fix timer related panic
Date: Wed, 15 Mar 2006 14:12:39 -0800
Message-ID: <1142460759.28540.8.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:62630 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751680AbWCOWMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 17:12:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a re-send of a patch I sent out a couple months ago.  It fixes a
panic in the timeout handler when I have lots of devices being
configured.

Signed-of-by: Mark Haverkamp <markh@osdl.org>

---

Applies to scsi-misc-2.6

--- scsi-misc-2.6.orig/drivers/scsi/lpfc/lpfc_els.c	2006-03-13 13:28:18.000000000 -0800
+++ scsi-misc-2.6/drivers/scsi/lpfc/lpfc_els.c	2006-03-15 14:00:38.000000000 -0800
@@ -3270,8 +3270,7 @@
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

