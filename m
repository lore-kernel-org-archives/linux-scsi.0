Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D53EC7EE30
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCAXHb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCAXH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:29 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1313E532BD
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:28 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id c3so11966687qtc.8
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUFfC/BQFxsF2xQOSvo1rTHxeOp4p0RpbXqkeMxYikg=;
        b=gbxZATYbrsIs5bNL/rrKPGjRrMPzUo5xLVpfESgfZNy0l3bJSFgCJi8Cv6VuFXAF5V
         fhV2feWACoftff0VZFHi5mVZcgZtVKte1E7rjD/huUQulxiTl/jRfxBOH1XAz90YRJ9P
         hWzjCAYmgsf+zFNAPMQ67LoicLtnQOtPUiWVIjWasePjzJihgBL3AWOZxVnMq5W9ykx/
         7kxs9dLGAyiaLRH2fzvlA2oNwuc7DoP5CLTTyk8oEpaP0lw6QyiPxHp+gxmuxJha9dBa
         vEtDqXPQ8I9nTT52M8EGG+/qsEg+NWWInIZxPKyCwIiigDTzbkNALiVkqX0SmiPlp/Lm
         v5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUFfC/BQFxsF2xQOSvo1rTHxeOp4p0RpbXqkeMxYikg=;
        b=rXmyIpmrq8porLREWsHsl77tz0yumxUK/+cCyRTLZ3Zc/lg005du02LWD62DSQQkfH
         +fv9fMYtSId8zrSU9sDbuqTG/njpsrCR/C0pEIW9M2HUrG9Rr6me8yndtSAsJeMOTa+u
         iRKdUO/oG88LV3ZalD5Mmli0SquO9yoY5SJ9yhnIlK7j4eqEuwHiXf7tSeqwbATqUONG
         mskvaCKvJb7qfBJ12zZistBvjVMC8Rbe4YsQ+eSqbaGry5W7Zp+5hZc1DBFrhfMLTIUk
         qpyKIhcCLVl4/w7i1ZKKOmUC6o++5okBVGm0zRAqnagS/ZbJVKVw+K7m9YvIYCcg4+DR
         2NQQ==
X-Gm-Message-State: AO0yUKU9UFsyB8dYFRa6anz3UTngLJBBwEezQe5DCE3qSeiN2Al2vhs6
        45eaMO0b7DIdKU7GfIOdSvXzppNkcyU=
X-Google-Smtp-Source: AK7set9i9wv/LnYxc7bw8LkLFQEndwi+lKIrXB40Jx1Iwl0h5PlsbpUxYW8BXCED5W/CDJwUjppqZA==
X-Received: by 2002:a05:622a:1448:b0:3bf:bfde:91bd with SMTP id v8-20020a05622a144800b003bfbfde91bdmr16189215qtx.5.1677712047024;
        Wed, 01 Mar 2023 15:07:27 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:26 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/10] lpfc: Skip waiting for register ready bits when in unrecoverable state
Date:   Wed,  1 Mar 2023 15:16:23 -0800
Message-Id: <20230301231626.9621-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During tolerance tests that force an HBA to become unresponsive, rmmod
hangs resulting in the inability to remove the driver.

The lpfc_pci_remove_one_s4 routine attempts to submit a clean up mailbox
command via the lpfc_sli4_post_sync_mbox routine, but ends up waiting
forever for a mailbox register to set its ready bit.  Because the HBA is
in an unrecoverable and unresponsive state, the ready bit will never be
set.

Create a new routine called lpfc_sli4_unrecoverable_port, which checks
a port status register's error notification bits.

Use the lpfc_sli4_unrecoverable_port routine in ready bit check routines
to early return error if port is deemed unrecoverable.

Also, when the lpfc_handle_eratt_s4 handler detects an unrecoverable
state, call the lpfc_sli4_offline_eratt routine to kick off flushing
outstanding I/O.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  6 ++++++
 drivers/scsi/lpfc/lpfc_init.c |  5 ++---
 drivers/scsi/lpfc/lpfc_nvme.c |  4 +++-
 drivers/scsi/lpfc/lpfc_sli.c  | 20 +++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli4.h | 19 +++++++++++++++++++
 5 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 22f2e046e8eb..ddbc54e8bcfd 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1644,6 +1644,12 @@ lpfc_sli4_pdev_status_reg_wait(struct lpfc_hba *phba)
 	    !bf_get(lpfc_sliport_status_err, &portstat_reg))
 		return -EPERM;
 
+	/* There is no point to wait if the port is in an unrecoverable
+	 * state.
+	 */
+	if (lpfc_sli4_unrecoverable_port(&portstat_reg))
+		return -EIO;
+
 	/* wait for the SLI port firmware ready after firmware reset */
 	for (i = 0; i < LPFC_FW_RESET_MAXIMUM_WAIT_10MS_CNT; i++) {
 		msleep(10);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 75737088d011..5b30e71dc926 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2147,7 +2147,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		/* fall through for not able to recover */
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3152 Unrecoverable error\n");
-		phba->link_state = LPFC_HBA_ERROR;
+		lpfc_sli4_offline_eratt(phba);
 		break;
 	case LPFC_SLI_INTF_IF_TYPE_1:
 	default:
@@ -9566,8 +9566,7 @@ lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 			/* Final checks.  The port status should be clean. */
 			if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
 				&reg_data.word0) ||
-				(bf_get(lpfc_sliport_status_err, &reg_data) &&
-				 !bf_get(lpfc_sliport_status_rn, &reg_data))) {
+				lpfc_sli4_unrecoverable_port(&reg_data)) {
 				phba->work_status[0] =
 					readl(phba->sli4_hba.u.if_type2.
 					      ERR1regaddr);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 152245f7cacc..ae3207e73113 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2265,6 +2265,7 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 			}
 			if (!vport->localport ||
 			    test_bit(HBA_PCI_ERR, &vport->phba->bit_flags) ||
+			    phba->link_state == LPFC_HBA_ERROR ||
 			    vport->load_flag & FC_UNLOADING)
 				return;
 
@@ -2630,7 +2631,8 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * return values is ignored.  The upcall is a courtesy to the
 		 * transport.
 		 */
-		if (vport->load_flag & FC_UNLOADING)
+		if (vport->load_flag & FC_UNLOADING ||
+		    unlikely(vport->phba->link_state == LPFC_HBA_ERROR))
 			(void)nvme_fc_set_remoteport_devloss(remoteport, 0);
 
 		ret = nvme_fc_unregister_remoteport(remoteport);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c8b4632e3dd4..b4917db6e532 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9895,7 +9895,8 @@ lpfc_sli4_async_mbox_unblock(struct lpfc_hba *phba)
  * port for twice the regular mailbox command timeout value.
  *
  *      0 - no timeout on waiting for bootstrap mailbox register ready.
- *      MBXERR_ERROR - wait for bootstrap mailbox register timed out.
+ *      MBXERR_ERROR - wait for bootstrap mailbox register timed out or port
+ *                     is in an unrecoverable state.
  **/
 static int
 lpfc_sli4_wait_bmbx_ready(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
@@ -9903,6 +9904,23 @@ lpfc_sli4_wait_bmbx_ready(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint32_t db_ready;
 	unsigned long timeout;
 	struct lpfc_register bmbx_reg;
+	struct lpfc_register portstat_reg = {-1};
+
+	/* Sanity check - there is no point to wait if the port is in an
+	 * unrecoverable state.
+	 */
+	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
+	    LPFC_SLI_INTF_IF_TYPE_2) {
+		if (lpfc_readl(phba->sli4_hba.u.if_type2.STATUSregaddr,
+			       &portstat_reg.word0) ||
+		    lpfc_sli4_unrecoverable_port(&portstat_reg)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"3858 Skipping bmbx ready because "
+					"Port Status x%x\n",
+					portstat_reg.word0);
+			return MBXERR_ERROR;
+		}
+	}
 
 	timeout = msecs_to_jiffies(lpfc_mbox_tmo_val(phba, mboxq)
 				   * 1000) + jiffies;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 3b62c4032c31..2a0864e6d7cd 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1180,3 +1180,22 @@ static inline void *lpfc_sli4_qe(struct lpfc_queue *q, uint16_t idx)
 	return q->q_pgs[idx / q->entry_cnt_per_pg] +
 		(q->entry_size * (idx % q->entry_cnt_per_pg));
 }
+
+/**
+ * lpfc_sli4_unrecoverable_port - Check ERR and RN bits in portstat_reg
+ * @portstat_reg: portstat_reg pointer containing portstat_reg contents
+ *
+ * Description:
+ * Use only for SLI4 interface type-2 or later.  If ERR is set && RN is 0, then
+ * port is deemed unrecoverable.
+ *
+ * Returns:
+ * true		- ERR && !RN
+ * false	- otherwise
+ */
+static inline bool
+lpfc_sli4_unrecoverable_port(struct lpfc_register *portstat_reg)
+{
+	return bf_get(lpfc_sliport_status_err, portstat_reg) &&
+	       !bf_get(lpfc_sliport_status_rn, portstat_reg);
+}
-- 
2.38.0

