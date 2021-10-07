Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46078C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FD2961108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242418AbhJGUc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:59 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:35821 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242220AbhJGUc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:56 -0400
Received: by mail-pf1-f175.google.com with SMTP id c29so6328698pfp.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=202mhrDsFbNknUxGfyMQxHiXtLoD17AkVH2wvE+4AJE=;
        b=zqerFC0FaZpUMIDr0LVuCHLzfyUle8JU8bSmqdVqASNsVP6N0rg97ZI45LjkLbeVGw
         mPXtNC46OkBxvs1QT33vdNpszGm+5e6MjdtF6PhMvvt7k0U/NMPp6UBNCdI8hQQseXZx
         LVDxQBo3C7oYirqYH8EHhMRLOQWHqRGfMZoeG7+CgLaY4wLTXzJXdZVLb1tWr2v85Rsn
         Afde2jbiGypXdtEiGRbgLjmFhPIuXzzHiCS4lq8HRnWzjHvVh6bcdH9H0cEgmpcy198B
         cb7mpVIJudCEhSaVdFa4+rQS+bh85mGTQHVc7aKC0lq/tUsKHG26FyEVq3geMOVZYtvn
         DnZw==
X-Gm-Message-State: AOAM531IgRnPzTkd7DaQ3aocarm0IuNdV5k5NDxBwC9/qW9zZsTIiAY9
        yYeOaBoZsNMB25Jpi50MofU=
X-Google-Smtp-Source: ABdhPJx7vt0Z2jAoLRcGWCH+xRau/GqITskkLDd6LJO0uclvgIHWduW6ZnGnuO9OpXyDwWh60SqCSA==
X-Received: by 2002:a63:4d20:: with SMTP id a32mr1353900pgb.247.1633638661959;
        Thu, 07 Oct 2021 13:31:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 52/88] mpt3sas: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:47 -0700
Message-Id: <20211007202923.2174984-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
 
