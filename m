From: akpm@linux-foundation.org
Subject: [patch 19/26] mpt2sas: fix &&/|| confusion in _scsih_sas_device_status_change_event()
Date: Thu, 11 Mar 2010 14:09:52 -0800
Message-ID: <201003112209.o2BM9qRC013670@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758401Ab0CKWJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:09:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, Eric.moore@lsi.com, James.Bottomley@suse.de, kashyap.desai@lsi.com

From: Roel Kluin <roel.kluin@gmail.com>

Even if the ReasonCode is not INTERNAL_DEVICE_RESET nor CMP_DEVICE_RESET
this still evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Acked-by: Eric Moore <Eric.moore@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_scsih.c~mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c~mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event
+++ a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4519,10 +4519,10 @@ _scsih_sas_device_status_change_event(st
 		     event_data);
 #endif
 
-	if (!(event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
-	   event_data->ReasonCode ==
-	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
+	if (event_data->ReasonCode !=
+	      MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
+	    event_data->ReasonCode !=
+	      MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET)
 		return;
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
_
