Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E37CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77A1760FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347177AbhI2WJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:26 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:45592 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347155AbhI2WJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:21 -0400
Received: by mail-pj1-f50.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so3131390pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=202mhrDsFbNknUxGfyMQxHiXtLoD17AkVH2wvE+4AJE=;
        b=rCfG4DzGu+jnDZOKO5OTxNdXX4loCW2ioxvtA+/4bnCNyHHRy3zjlgDzPSPQ7ZAvLD
         N2NilmiqW6BjAmbjjCIy/IWC1SaEJB5PnejV6SnXXaAFHDoPq9Q7nXRbw6rRF9iS8pAJ
         MJEp52CDdCHNsscKycArtFq++sPzwMq795OfQUbwGOUAHVE1gwQUOTmjPQIN6JFYeYYg
         d3Se1GD7M6rBw/T61G5XEfGyB/y4SiLNKjT5nM1dxjlCbNaCV1gJLk/8UvpswN0EhfO4
         vuzC0rRxdzMY1yWnGsyr9/vbIN8KbEpyUFiA1BrnnskcS4Ep74BpUUfGDx1BRkkBPrfv
         1DBA==
X-Gm-Message-State: AOAM530JDCJSbf6y2oeIRqsNoG5nJ3gKCUxKGJXJOdQ4zCJZAF+OBFiG
        7XWovcWR0BNtSX4rMLECPKw=
X-Google-Smtp-Source: ABdhPJzRXsGer7czbZsW//REKK4fMwQbGpBKX1F0WQr9O8MSVfXdY7JbJRZdFy2GXdtF2mKLuUAnQQ==
X-Received: by 2002:a17:902:854c:b0:13a:519c:67ea with SMTP id d12-20020a170902854c00b0013a519c67eamr762163plo.82.1632953259777;
        Wed, 29 Sep 2021 15:07:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 52/84] mpt3sas: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:28 -0700
Message-Id: <20210929220600.3509089-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2f82b1e629af..ca4e91f09fca 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3314,7 +3314,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 		sdev_printk(KERN_INFO, scmd->device,
 		    "device been deleted! scmd(0x%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
 	}
@@ -3390,7 +3390,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		sdev_printk(KERN_INFO, scmd->device,
 		    "device been deleted! scmd(0x%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
 	}
@@ -3470,7 +3470,7 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 		starget_printk(KERN_INFO, starget,
 		    "target been deleted! scmd(0x%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		r = SUCCESS;
 		goto out;
 	}
@@ -5030,7 +5030,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 			scmd->result = DID_NO_CONNECT << 16;
 		else
 			scmd->result = DID_RESET << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 	}
 	dtmprintk(ioc, ioc_info(ioc, "completing %d cmds\n", count));
 }
@@ -5139,13 +5139,13 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
 	if (!(_scsih_allow_scmd_to_device(ioc, scmd))) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
@@ -5155,7 +5155,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	handle = sas_target_priv_data->handle;
 	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE) {
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	}
 
@@ -5166,7 +5166,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	} else if (sas_target_priv_data->deleted) {
 		/* device has been deleted */
 		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		scsi_done(scmd);
 		return 0;
 	} else if (sas_target_priv_data->tm_busy ||
 		   sas_device_priv_data->block) {
@@ -5909,7 +5909,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 
 	scsi_dma_unmap(scmd);
 	mpt3sas_base_free_smid(ioc, smid);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	return 0;
 }
 
