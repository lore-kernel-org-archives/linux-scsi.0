Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF2EC2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A220F2075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KO8yQqs+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfLZLOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:14:09 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38273 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:14:09 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so5840039wmc.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HUPW7dTIJd5dx8e8PvasG3KKW15zGvMXfk5c3ymw0oo=;
        b=KO8yQqs+s73fMOLUUSNjubsP/RFTiNhC3k/LBTNHzmQ1QrVbhZJeAu5NxckQR/lphZ
         NNcEhDt5ISALQbuL7oPenYvHxg7+XJcFVtwFRAOJ+t7gPn9/3DlayT/4IE6377IxIT9k
         CCxMsVuB2JNHFkDK5s0WN2YNM944ILvrknT3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HUPW7dTIJd5dx8e8PvasG3KKW15zGvMXfk5c3ymw0oo=;
        b=L0guFexiH96eK7im5IbH58fU5acMUm3ngsQSoBiMSPhZAiAclxisb+u4eXEcPKt0iA
         DOTwm2toUjN+UrIhpWNnEspV2Z8hiF3uck5t9pSEpgDhrhrtTNbGgdpFmKrO6M1bK+WF
         E6HY4kwXbYlBxCYLgqgl0vZ765il+ljp+KcILg5Bo63CEVQHERnNPc5bhvfOcRxgHLUB
         dkHKiX7WWeFwAa9+pzQJkdUWxSLZp5LiMTeGm57/a0Y+YfiPPrIvUpVG2bHx+dRszNrT
         JqTfCK7tfhARZ8CUp9VPsAgsA3Zevig80LpRPoDI3RAvGW2eP5se/NYvTMJa19KqqDFr
         YJ3A==
X-Gm-Message-State: APjAAAVfwdDKXyfI0634DQsFpquecTTh+oAFFnbnoqwux7yTDtwnUOHV
        TAmH65AvxnTrGT1Fz1Kxebu4Cj/MLFNjyg9XLCS8GcA47j5MTE+D+6uwY2phMgj5nbDN6mi67dy
        J3zBGZ798KjkJe5ZT5vlp+PsjnmMSMFmYHtIE+iw7Pya/ztfOAlRzP96KMZbeq1VUicKEG1EY2u
        CCk333XMQf
X-Google-Smtp-Source: APXvYqwS/SnzJ4fP/QK8c6n5oRM42TRbap5irwX70VkWNKdQlcga2uXdX1wjI8ujEx2tgaijaz8KPA==
X-Received: by 2002:a1c:e007:: with SMTP id x7mr12913799wmg.3.1577358845597;
        Thu, 26 Dec 2019 03:14:05 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:14:04 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 06/10] mpt3sas: print in which path firmware fault occurred
Date:   Thu, 26 Dec 2019 06:13:29 -0500
Message-Id: <20191226111333.26131-7-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When Firmware fault occurs then print in which path
firmware fault has occurred, which will be useful
while debugging the firmware fault issues.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 26 +++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  8 ++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  8 ++++----
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0ffbe37..4bc57c1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -672,7 +672,7 @@ _base_fault_reset_work(struct work_struct *work)
 		timeout /= (FAULT_POLLING_INTERVAL/1000);
 
 		if (ioc->ioc_coredump_loop == 0) {
-			mpt3sas_base_coredump_info(ioc,
+			mpt3sas_print_coredump_info(ioc,
 			    doorbell & MPI2_DOORBELL_DATA_MASK);
 			/* do not accept any IOs and disable the interrupts */
 			spin_lock_irqsave(
@@ -711,11 +711,11 @@ _base_fault_reset_work(struct work_struct *work)
 			 __func__, rc == 0 ? "success" : "failed");
 		doorbell = mpt3sas_base_get_iocstate(ioc, 0);
 		if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
-			mpt3sas_base_fault_info(ioc, doorbell &
+			mpt3sas_print_fault_code(ioc, doorbell &
 			    MPI2_DOORBELL_DATA_MASK);
 		} else if ((doorbell & MPI2_IOC_STATE_MASK) ==
 		    MPI2_IOC_STATE_COREDUMP)
-			mpt3sas_base_coredump_info(ioc, doorbell &
+			mpt3sas_print_coredump_info(ioc, doorbell &
 			    MPI2_DOORBELL_DATA_MASK);
 		if (rc && (doorbell & MPI2_IOC_STATE_MASK) !=
 		    MPI2_IOC_STATE_OPERATIONAL)
@@ -864,11 +864,11 @@ mpt3sas_halt_firmware(struct MPT3SAS_ADAPTER *ioc)
 
 	doorbell = ioc->base_readl(&ioc->chip->Doorbell);
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
-		mpt3sas_base_fault_info(ioc, doorbell &
+		mpt3sas_print_fault_code(ioc, doorbell &
 		    MPI2_DOORBELL_DATA_MASK);
 	} else if ((doorbell & MPI2_IOC_STATE_MASK) ==
 	    MPI2_IOC_STATE_COREDUMP) {
-		mpt3sas_base_coredump_info(ioc, doorbell &
+		mpt3sas_print_coredump_info(ioc, doorbell &
 		    MPI2_DOORBELL_DATA_MASK);
 	} else {
 		writel(0xC0FFEE00, &ioc->chip->Doorbell);
@@ -3306,12 +3306,12 @@ _base_check_for_fault_and_issue_reset(struct MPT3SAS_ADAPTER *ioc)
 	dhsprintk(ioc, pr_info("%s: ioc_state(0x%08x)\n", __func__, ioc_state));
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
-		mpt3sas_base_fault_info(ioc, ioc_state &
+		mpt3sas_print_fault_code(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
 		rc = _base_diag_reset(ioc);
 	} else if ((ioc_state & MPI2_IOC_STATE_MASK) ==
 	    MPI2_IOC_STATE_COREDUMP) {
-		mpt3sas_base_coredump_info(ioc, ioc_state &
+		mpt3sas_print_coredump_info(ioc, ioc_state &
 		     MPI2_DOORBELL_DATA_MASK);
 		mpt3sas_base_wait_for_coredump_completion(ioc, __func__);
 		rc = _base_diag_reset(ioc);
@@ -5656,12 +5656,12 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout)
 			doorbell = ioc->base_readl(&ioc->chip->Doorbell);
 			if ((doorbell & MPI2_IOC_STATE_MASK) ==
 			    MPI2_IOC_STATE_FAULT) {
-				mpt3sas_base_fault_info(ioc , doorbell);
+				mpt3sas_print_fault_code(ioc, doorbell);
 				return -EFAULT;
 			}
 			if ((doorbell & MPI2_IOC_STATE_MASK) ==
 			    MPI2_IOC_STATE_COREDUMP) {
-				mpt3sas_base_coredump_info(ioc, doorbell);
+				mpt3sas_print_coredump_info(ioc, doorbell);
 				return -EFAULT;
 			}
 		} else if (int_status == 0xFFFFFFFF)
@@ -5763,7 +5763,7 @@ _base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int timeout)
 		    ioc->fault_reset_work_q == NULL)) {
 			spin_unlock_irqrestore(
 			    &ioc->ioc_reset_in_progress_lock, flags);
-			mpt3sas_base_coredump_info(ioc, ioc_state);
+			mpt3sas_print_coredump_info(ioc, ioc_state);
 			mpt3sas_base_wait_for_coredump_completion(ioc,
 			    __func__);
 			spin_lock_irqsave(
@@ -6164,7 +6164,7 @@ _base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	}
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
-		mpt3sas_base_fault_info(ioc, ioc_state &
+		mpt3sas_print_fault_code(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
 		goto issue_diag_reset;
 	} else if ((ioc_state & MPI2_IOC_STATE_MASK) ==
@@ -6858,7 +6858,7 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 	}
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
-		mpt3sas_base_fault_info(ioc, ioc_state &
+		mpt3sas_print_fault_code(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
 		goto issue_diag_reset;
 	}
@@ -6872,7 +6872,7 @@ _base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 		 * reset state without copying the FW logs to coredump region.
 		 */
 		if (ioc->ioc_coredump_loop != MPT3SAS_COREDUMP_LOOP_DONE) {
-			mpt3sas_base_coredump_info(ioc, ioc_state &
+			mpt3sas_print_coredump_info(ioc, ioc_state &
 			    MPI2_DOORBELL_DATA_MASK);
 			mpt3sas_base_wait_for_coredump_completion(ioc,
 			    __func__);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index cfd12d2..9a097c0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1547,7 +1547,15 @@ void *mpt3sas_base_get_reply_virt_addr(struct MPT3SAS_ADAPTER *ioc,
 u32 mpt3sas_base_get_iocstate(struct MPT3SAS_ADAPTER *ioc, int cooked);
 
 void mpt3sas_base_fault_info(struct MPT3SAS_ADAPTER *ioc , u16 fault_code);
+#define mpt3sas_print_fault_code(ioc, fault_code) \
+do { pr_err("%s fault info from func: %s\n", ioc->name, __func__); \
+	mpt3sas_base_fault_info(ioc, fault_code); } while (0)
+
 void mpt3sas_base_coredump_info(struct MPT3SAS_ADAPTER *ioc, u16 fault_code);
+#define mpt3sas_print_coredump_info(ioc, fault_code) \
+do { pr_err("%s fault info from func: %s\n", ioc->name, __func__); \
+	mpt3sas_base_coredump_info(ioc, fault_code); } while (0)
+
 int mpt3sas_base_wait_for_coredump_completion(struct MPT3SAS_ADAPTER *ioc,
 		const char *caller);
 int mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2c4b5c0..ec80eed 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2747,13 +2747,13 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 	}
 
 	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
-		mpt3sas_base_fault_info(ioc, ioc_state &
+		mpt3sas_print_fault_code(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
 		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 		return (!rc) ? SUCCESS : FAILED;
 	} else if ((ioc_state & MPI2_IOC_STATE_MASK) ==
 	    MPI2_IOC_STATE_COREDUMP) {
-		mpt3sas_base_coredump_info(ioc, ioc_state &
+		mpt3sas_print_coredump_info(ioc, ioc_state &
 		    MPI2_DOORBELL_DATA_MASK);
 		rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 		return (!rc) ? SUCCESS : FAILED;
@@ -4547,11 +4547,11 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 			doorbell = mpt3sas_base_get_iocstate(ioc, 0);
 			if ((doorbell & MPI2_IOC_STATE_MASK) ==
 			    MPI2_IOC_STATE_FAULT) {
-				mpt3sas_base_fault_info(ioc,
+				mpt3sas_print_fault_code(ioc,
 				    doorbell & MPI2_DOORBELL_DATA_MASK);
 			} else if ((doorbell & MPI2_IOC_STATE_MASK) ==
 			    MPI2_IOC_STATE_COREDUMP) {
-				mpt3sas_base_coredump_info(ioc,
+				mpt3sas_print_coredump_info(ioc,
 				    doorbell & MPI2_DOORBELL_DATA_MASK);
 			}
 		}
-- 
2.18.1

