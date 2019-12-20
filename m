Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11642C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC04924679
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="P8rWQM9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLTKco (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:32:44 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41045 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKco (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 05:32:44 -0500
Received: by mail-pf1-f193.google.com with SMTP id w62so4961575pfw.8
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 02:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q+4nDYHuh33FktiO9xWg/5r3myOzwoRZwqGp1xotEcs=;
        b=P8rWQM9d+c5Qsr7WqWqgxlatltHOc5ybO7te70RtHkhJvKhb79/CR6qnlVUbUZLdif
         qHQso84bwx82EVfsnKrMFgeg0TaBJS/ZjYC4nfLTn6CzoeMqwl0eSnMG+6ThH7EWotAW
         TJKfs3IH2kG83irdKpJkQ9/GYt6bD7PY8rplo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q+4nDYHuh33FktiO9xWg/5r3myOzwoRZwqGp1xotEcs=;
        b=Kd+EshlnT9cFGz5rAApulsQRyrHMjRvWLqxwQvAp9Rn6kJcqh++uubwRWB7IHh4Jvh
         iwFGX21vKPISZI5zKInMsF+SPUp6R9E4TjHAO4bLBcjc7RVQgeEuM+ok9vPJJyVScdKx
         3oHIPDm4mtb8rCONaT20++JLO+wjgWdtTAxK5rpch3TDq0dF/Fpo/qmZ09ChWDH/hanb
         1sfATuph8mUHCNdaMyreyPO6SXdpSve8+H2L2xmfgilpfw203qZCu+niiNilruSuOVBD
         EtTVKNwlVbweHMXTipXHTH4I+nG40sGYwgfprFdc32BmsxBzX9SeIoPkBvqHBTAPPY+H
         Hpyw==
X-Gm-Message-State: APjAAAW2A5exWmztGU0KTUi6UE1Sn1xeru4vSOVNc6XYx/9I1gqVU95U
        Fbn5eGY5cmHkreK6YiNpRS+hh2U8IsEc0aQjaFYP2ZFW9UR22Dzp/wgCl6cuJVeppTBuzx6Npnp
        MsLkN83+8KloRx6vZ+8uhFNkAzp3GX62H/8Z3vZCS32fHz3xb8aqH9trIlu+9D4HLdadEVmy0GM
        aXUUIbosWEIwyEpCTxMw==
X-Google-Smtp-Source: APXvYqzUpgMzZI8kvfqdtn8shoZEC3PTNsC02Iws58zfR4IN4Dfa8IiQ3UeRwMgMx6370OUxtnNu9Q==
X-Received: by 2002:a62:5214:: with SMTP id g20mr13487090pfb.101.1576837961439;
        Fri, 20 Dec 2019 02:32:41 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 200sm12185364pfz.121.2019.12.20.02.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:32:40 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 06/10] mpt3sas: print in which path firmware fault occurred
Date:   Fri, 20 Dec 2019 05:32:06 -0500
Message-Id: <20191220103210.43631-7-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When Firmware fault occurs then print in which path
firmware fault has occurred, which will be useful
while debugging the firmware fault issues.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
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

