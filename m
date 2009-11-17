From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas : missing initialization of scsih_cmds is included
Date: Tue, 17 Nov 2009 13:16:37 +0530
Message-ID: <20091117074622.GA20953@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57891 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752488AbZKQIMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 03:12:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Internal command scsih_cmds init is included in mpt2sas_base_attach.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6422e25..89d0240 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3583,6 +3583,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->transport_cmds.mutex);
 
+	/* scsih internal command bits */
+	ioc->scsih_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
+	ioc->scsih_cmds.status = MPT2_CMD_NOT_USED;
+	mutex_init(&ioc->scsih_cmds.mutex);
+
 	/* task management internal command bits */
 	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
