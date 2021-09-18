Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20FDC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE62F60F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344462AbhIRAJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:15 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:33407 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344539AbhIRAJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:05 -0400
Received: by mail-pl1-f169.google.com with SMTP id t4so7275466plo.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=202mhrDsFbNknUxGfyMQxHiXtLoD17AkVH2wvE+4AJE=;
        b=5qfhEqnIqZBQjh2Rin/ONVvKEGRTHLsItMbNq/FRXe722G/1V9Y2iJDAqsUHOlPWF0
         Pzz7bBUXS7BruhKX7Tu8mmWJcIZMv+kBixP7tvPW64Nzb+Fmsm9CoFtIDLSY2zchHZ3F
         c7zaY+v3hFRJEXfG87owQKrk9Vvn5pJqi+7ulUl7QQ1Llv6y8AGIVP2hvFaO3dvGk8NG
         gSocNfx9VN0ghBwpbpa6yZIXdJ2RevYiqQRdP/xUGOrCHMjK1WOA+08/9dJhO8k0MNH+
         HwZvfDMHAVb9CNx+wYjYVfKkNlq/r50h1mZqV0vjNdKIyQXRHV/2hlIMM3VygNVgPGD6
         q4Iw==
X-Gm-Message-State: AOAM531EgNqRvtcLwF8L1JMlaiAqsPG+fN77epGfuJa8QP5lW+Rwz0KS
        Mq2Yiw6D4/waYKI+vO+y/Es=
X-Google-Smtp-Source: ABdhPJxd1eiciGveT0Ecgq8reKEcWz4EyKodg+rullm9/medIo7OMTJ3oH/KFvCWOo09X+KEPT3gyg==
X-Received: by 2002:a17:90a:bc8d:: with SMTP id x13mr15231244pjr.9.1631923662064;
        Fri, 17 Sep 2021 17:07:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 52/84] mpt3sas: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:35 -0700
Message-Id: <20210918000607.450448-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
 
