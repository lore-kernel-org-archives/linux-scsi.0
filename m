Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F4CC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 03:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B05764DB2
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 03:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhBDDfL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 22:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhBDDfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 22:35:08 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93A7C0613ED
        for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2021 19:34:27 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t25so1198747pga.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Feb 2021 19:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=H0BpDSyLPTMyxsXDDwMjaNG0OvkrFKuhl95HsUw2fNU=;
        b=GQ/LW2cEsk0stFJZmzeQnW4FvgY1+K3Wm8uMcYTf+ttivdvEelV93lANrFE3GlMVUo
         s1Qd2YLEMVhjGdJ9AT84Bc0xuu6d96N6G81XZJhSAJQi2++JNUT1iBY23vaMiLLly9dl
         eZPqK8X1FsQ7as4juWQEiMjJXr2ZDBvcHd1ZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=H0BpDSyLPTMyxsXDDwMjaNG0OvkrFKuhl95HsUw2fNU=;
        b=UTAJrEMQx7Kap/xDIZlDOxaNdnYofLUQ75XPY4b0Y78hPhZehj6Zf6JoHbHPYikmIA
         V3wLqzO/c7YUnypEuERSE7zF5lOiIaujjlQwO/gpHetxzTW4VNWGSXi1KI76ivgk3Gdm
         FSKJ5njXhhWLQGoJicXaptfsaTLTySFY6CGKEQMs0d7axYC+rW1YobpDgyPQaYi7HIwK
         WqnYnzIRAAMxtk3sEdoyCotItpWU9Hv8nFZY74RQJaaUfjmBxqtPUCfO6+IuvuPVOzod
         CH+VLa5/BEPmw8OhHp+8X2f5iYd6IB5jE9N2ifaW14c87iy4QGyF+LZmuBiI3WiXNxjm
         vvng==
X-Gm-Message-State: AOAM530gK+4yGtDsGfAhpdZ2rWAG9IvkQuDnS8Lg1TobCLy3kLMTuNwD
        2MRtRdIIunFsWqR55rwjXtqgAw==
X-Google-Smtp-Source: ABdhPJxpUEMLA1n51X3WQKgGKz6WLszKdAl0hBGaWiFJJhRh5lCSKIKv3CgxgP3bzp0WURe8CchL5Q==
X-Received: by 2002:a05:6a00:158c:b029:1bd:ea8:6d6d with SMTP id u12-20020a056a00158cb02901bd0ea86d6dmr6201350pfk.16.1612409666714;
        Wed, 03 Feb 2021 19:34:26 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x184sm4180808pfb.199.2021.02.03.19.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 19:34:25 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 1/2] mpt3sas: Additional Diagnostic Buffer Query IOCTL interface.
Date:   Thu,  4 Feb 2021 09:07:23 +0530
Message-Id: <20210204033724.1345-2-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210204033724.1345-1-suganath-prabu.subramani@broadcom.com>
References: <20210204033724.1345-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000076d5e105ba7a610e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000076d5e105ba7a610e
Content-Transfer-Encoding: 8bit

When a host trace buffer is released, applications never know for what
reason the buffer is released. So add a new IOCTL MPT3ADDNLDIAGQUERY to
provide the trigger information due to which the diag buffer is released.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  5 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h         | 47 +++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          | 67 ++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          | 22 +++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  2 +
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c | 38 +++++++++++-
 6 files changed, 177 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6e23dc3..70aab90 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8174,8 +8174,11 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
 		if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT ||
 		    (ioc_state & MPI2_IOC_STATE_MASK) ==
-		    MPI2_IOC_STATE_COREDUMP)
+		    MPI2_IOC_STATE_COREDUMP) {
 			is_fault = 1;
+			ioc->htb_rel.trigger_info_dwords[1] =
+			    (ioc_state & MPI2_DOORBELL_DATA_MASK);
+		}
 	}
 	_base_pre_reset_handler(ioc);
 	mpt3sas_wait_for_commands_to_complete(ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 2def7a3..39388bf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1073,6 +1073,50 @@ struct hba_port {
 
 #define MULTIPATH_DISABLED_PORT_ID     0xFF
 
+/**
+ * struct htb_rel_query - diagnostic buffer release reason
+ * @unique_id - unique id associated with this buffer.
+ * @buffer_rel_condition - Release condition ioctl/sysfs/reset
+ * @reserved
+ * @trigger_type - Master/Event/scsi/MPI
+ * @trigger_info_dwords - Data Correspondig to trigger type
+ */
+struct htb_rel_query {
+	u16	buffer_rel_condition;
+	u16	reserved;
+	u32	trigger_type;
+	u32	trigger_info_dwords[2];
+};
+
+/* Buffer_rel_condition bit fields */
+
+/* Bit 0 - Diag Buffer not Released */
+#define MPT3_DIAG_BUFFER_NOT_RELEASED	(0x00)
+/* Bit 0 - Diag Buffer Released */
+#define MPT3_DIAG_BUFFER_RELEASED	(0x01)
+
+/*
+ * Bit 1 - Diag Buffer Released by IOCTL,
+ * This bit is valid only if Bit 0 is one
+ */
+#define MPT3_DIAG_BUFFER_REL_IOCTL	(0x02 | MPT3_DIAG_BUFFER_RELEASED)
+
+/*
+ * Bit 2 - Diag Buffer Released by Trigger,
+ * This bit is valid only if Bit 0 is one
+ */
+#define MPT3_DIAG_BUFFER_REL_TRIGGER	(0x04 | MPT3_DIAG_BUFFER_RELEASED)
+
+/*
+ * Bit 3 - Diag Buffer Released by SysFs,
+ * This bit is valid only if Bit 0 is one
+ */
+#define MPT3_DIAG_BUFFER_REL_SYSFS	(0x08 | MPT3_DIAG_BUFFER_RELEASED)
+
+/* DIAG RESET Master trigger flags */
+#define MPT_DIAG_RESET_ISSUED_BY_DRIVER 0x00000000
+#define MPT_DIAG_RESET_ISSUED_BY_USER	0x00000001
+
 typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
 /**
  * struct MPT3SAS_ADAPTER - per adapter struct
@@ -1529,6 +1573,8 @@ struct MPT3SAS_ADAPTER {
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
 	u32		ring_buffer_offset;
 	u32		ring_buffer_sz;
+	struct htb_rel_query htb_rel;
+	u8 reset_from_user;
 	u8		is_warpdrive;
 	u8		is_mcpu_endpoint;
 	u8		hide_ir_msg;
@@ -1565,6 +1611,7 @@ struct mpt3sas_debugfs_buffer {
 };
 
 #define MPT_DRV_SUPPORT_BITMAP_MEMMOVE 0x00000001
+#define MPT_DRV_SUPPORT_BITMAP_ADDNLQUERY	0x00000002
 
 typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index c8a0ce1..44f9a05 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -479,6 +479,8 @@ void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 		ioc_info(ioc,
 		    "%s: Releasing the trace buffer due to adapter reset.",
 		    __func__);
+		ioc->htb_rel.buffer_rel_condition =
+		    MPT3_DIAG_BUFFER_REL_TRIGGER;
 		mpt3sas_send_diag_release(ioc, i, &issue_reset);
 	}
 }
@@ -1334,6 +1336,7 @@ _ctl_do_reset(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	dctlprintk(ioc, ioc_info(ioc, "%s: enter\n",
 				 __func__));
 
+	ioc->reset_from_user = 1;
 	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	ioc_info(ioc,
 	    "Ioctl: host reset: %s\n", ((!retval) ? "SUCCESS" : "FAILED"));
@@ -1687,6 +1690,9 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	request_data = ioc->diag_buffer[buffer_type];
 	request_data_sz = diag_register->requested_buffer_size;
 	ioc->unique_id[buffer_type] = diag_register->unique_id;
+	/* Reset ioc variables used for additional query commands */
+	ioc->reset_from_user = 0;
+	memset(&ioc->htb_rel, 0, sizeof(struct htb_rel_query));
 	ioc->diag_buffer_status[buffer_type] &=
 	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
 	memcpy(ioc->product_specific[buffer_type],
@@ -2469,7 +2475,61 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	return rc;
 }
 
+/**
+ * _ctl_addnl_diag_query - query relevant info associated with diag buffers
+ * @ioc: per adapter object
+ * @arg: user space buffer containing ioctl content
+ *
+ * The application will send only unique_id.  Driver will
+ * inspect unique_id first, if valid, fill the details related to cause
+ * for diag buffer release.
+ */
+static long
+_ctl_addnl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
+{
+	struct mpt3_addnl_diag_query karg;
+	u32 buffer_type = 0;
 
+	if (copy_from_user(&karg, arg, sizeof(karg))) {
+		pr_err("%s: failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return -EFAULT;
+	}
+	dctlprintk(ioc, ioc_info(ioc, "%s\n",  __func__));
+	if (karg.unique_id == 0) {
+		ioc_err(ioc, "%s: unique_id is(0x%08x)\n",
+		    __func__, karg.unique_id);
+		return -EPERM;
+	}
+	buffer_type = _ctl_diag_get_bufftype(ioc, karg.unique_id);
+	if (buffer_type == MPT3_DIAG_UID_NOT_FOUND) {
+		ioc_err(ioc, "%s: buffer with unique_id(0x%08x) not found\n",
+		    __func__, karg.unique_id);
+		return -EPERM;
+	}
+	memset(&karg.buffer_rel_condition, 0, sizeof(struct htb_rel_query));
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
+		ioc_info(ioc, "%s: buffer_type(0x%02x) is not registered\n",
+		    __func__, buffer_type);
+		goto out;
+	}
+	if ((ioc->diag_buffer_status[buffer_type] &
+	    MPT3_DIAG_BUFFER_IS_RELEASED) == 0) {
+		ioc_err(ioc, "%s: buffer_type(0x%02x) is not released\n",
+		    __func__, buffer_type);
+		return -EPERM;
+	}
+	memcpy(&karg.buffer_rel_condition, &ioc->htb_rel,
+	    sizeof(struct  htb_rel_query));
+out:
+	if (copy_to_user(arg, &karg, sizeof(struct mpt3_addnl_diag_query))) {
+		ioc_err(ioc, "%s: unable to write mpt3_addnl_diag_query data @ %p\n",
+		    __func__, arg);
+		return -EFAULT;
+	}
+	return 0;
+}
 
 #ifdef CONFIG_COMPAT
 /**
@@ -2533,7 +2593,7 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 	struct MPT3SAS_ADAPTER *ioc;
 	struct mpt3_ioctl_header ioctl_header;
 	enum block_state state;
-	long ret = -EINVAL;
+	long ret = -ENOIOCTLCMD;
 
 	/* get IOCTL header */
 	if (copy_from_user(&ioctl_header, (char __user *)arg,
@@ -2643,6 +2703,10 @@ _ctl_ioctl_main(struct file *file, unsigned int cmd, void __user *arg,
 		if (_IOC_SIZE(cmd) == sizeof(struct mpt3_diag_read_buffer))
 			ret = _ctl_diag_read_buffer(ioc, arg);
 		break;
+	case MPT3ADDNLDIAGQUERY:
+		if (_IOC_SIZE(cmd) == sizeof(struct mpt3_addnl_diag_query))
+			ret = _ctl_addnl_diag_query(ioc, arg);
+		break;
 	default:
 		dctlprintk(ioc,
 			   ioc_info(ioc, "unsupported ioctl opcode(0x%08x)\n",
@@ -3425,6 +3489,7 @@ host_trace_buffer_enable_store(struct device *cdev,
 		    MPT3_DIAG_BUFFER_IS_RELEASED))
 			goto out;
 		ioc_info(ioc, "releasing host trace buffer\n");
+		ioc->htb_rel.buffer_rel_condition = MPT3_DIAG_BUFFER_REL_SYSFS;
 		mpt3sas_send_diag_release(ioc, MPI2_DIAG_BUF_TYPE_TRACE,
 		    &issue_reset);
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index 0f7aa4d..d2ccdaf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -94,6 +94,8 @@
 	struct mpt3_diag_query)
 #define MPT3DIAGREADBUFFER _IOWR(MPT3_MAGIC_NUMBER, 30, \
 	struct mpt3_diag_read_buffer)
+#define MPT3ADDNLDIAGQUERY _IOWR(MPT3_MAGIC_NUMBER, 32, \
+	struct mpt3_addnl_diag_query)
 
 /* Trace Buffer default UniqueId */
 #define MPT2DIAGBUFFUNIQUEID (0x07075900)
@@ -430,4 +432,24 @@ struct mpt3_diag_read_buffer {
 	uint32_t diagnostic_data[1];
 };
 
+/**
+ * struct mpt3_addnl_diag_query - diagnostic buffer release reason
+ * @hdr - generic header
+ * @unique_id - unique id associated with this buffer.
+ * @buffer_rel_condition - Release condition ioctl/sysfs/reset
+ * @reserved1
+ * @trigger_type - Master/Event/scsi/MPI
+ * @trigger_info_dwords - Data Correspondig to trigger type
+ * @reserved2
+ */
+struct mpt3_addnl_diag_query {
+	struct mpt3_ioctl_header hdr;
+	uint32_t unique_id;
+	uint16_t buffer_rel_condition;
+	uint16_t reserved1;
+	uint32_t trigger_type;
+	uint32_t trigger_info_dwords[2];
+	uint32_t reserved2[2];
+};
+
 #endif /* MPT3SAS_CTL_H_INCLUDED */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c8b09a8..5317aea 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11922,6 +11922,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * Enable MEMORY MOVE support flag.
 	 */
 	ioc->drv_support_bitmap |= MPT_DRV_SUPPORT_BITMAP_MEMMOVE;
+	/* Enable ADDITIONAL QUERY support flag. */
+	ioc->drv_support_bitmap |= MPT_DRV_SUPPORT_BITMAP_ADDNLQUERY;
 
 	ioc->enable_sdev_max_qd = enable_sdev_max_qd;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index 8ec9bab..d9b7d0e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -132,6 +132,35 @@ mpt3sas_process_trigger_data(struct MPT3SAS_ADAPTER *ioc,
 		    &issue_reset);
 	}
 
+	ioc->htb_rel.buffer_rel_condition = MPT3_DIAG_BUFFER_REL_TRIGGER;
+	if (event_data) {
+		ioc->htb_rel.trigger_type = event_data->trigger_type;
+		switch (event_data->trigger_type) {
+		case MPT3SAS_TRIGGER_SCSI:
+			memcpy(&ioc->htb_rel.trigger_info_dwords,
+			    &event_data->u.scsi,
+			    sizeof(struct SL_WH_SCSI_TRIGGER_T));
+			break;
+		case MPT3SAS_TRIGGER_MPI:
+			memcpy(&ioc->htb_rel.trigger_info_dwords,
+			    &event_data->u.mpi,
+			    sizeof(struct SL_WH_MPI_TRIGGER_T));
+			break;
+		case MPT3SAS_TRIGGER_MASTER:
+			ioc->htb_rel.trigger_info_dwords[0] =
+			    event_data->u.master.MasterData;
+			break;
+		case MPT3SAS_TRIGGER_EVENT:
+			memcpy(&ioc->htb_rel.trigger_info_dwords,
+			    &event_data->u.event,
+			    sizeof(struct SL_WH_EVENT_TRIGGER_T));
+			break;
+		default:
+			ioc_err(ioc, "%d - Is not a valid Trigger type\n",
+			    event_data->trigger_type);
+			break;
+		}
+	}
 	_mpt3sas_raise_sigio(ioc, event_data);
 
 	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: exit\n",
@@ -201,9 +230,14 @@ mpt3sas_trigger_master(struct MPT3SAS_ADAPTER *ioc, u32 trigger_bitmask)
 	event_data.u.master.MasterData = trigger_bitmask;
 
 	if (trigger_bitmask & MASTER_TRIGGER_FW_FAULT ||
-	    trigger_bitmask & MASTER_TRIGGER_ADAPTER_RESET)
+	    trigger_bitmask & MASTER_TRIGGER_ADAPTER_RESET) {
+		ioc->htb_rel.trigger_type = MPT3SAS_TRIGGER_MASTER;
+		ioc->htb_rel.trigger_info_dwords[0] = trigger_bitmask;
+		if (ioc->reset_from_user)
+			ioc->htb_rel.trigger_info_dwords[1] =
+			    MPT_DIAG_RESET_ISSUED_BY_USER;
 		_mpt3sas_raise_sigio(ioc, &event_data);
-	else
+	} else
 		mpt3sas_send_trigger_data_event(ioc, &event_data);
 
  out:
-- 
2.27.0


--00000000000076d5e105ba7a610e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgAM0133DON6QD8PZWzLJes7L3cyKPPyJAr8eC4gqh
4qswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEwMjA0MDMzNDI3
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAEph9Q+53uMehoCJGshZDlpmhtjwRPU6DWlIbItwHi7ZKNvDgeLUXJzFXJVt
3eYf6wQkvhfCYSTu4Saqe5y+Y2eeHWJIgW88U2/SSuUYY9TUH3QIK8JmdmxThoBKDgjwICrjfwkc
+JxiREB3phTPaax4h2O3nT1JQur/auydvrhjl1I6aJgifyKDod+1hCzhUF+sub3dHIx8Uz2mX0A/
nT4Ld2gvpDmISCKY2eg9bbb+uGG7MDuGMq9fyDh9Y4zM7SPOXvGddLyqxnDUrbtMb17O30/YP2hB
BBicKiTMuFTg/bcJkncD6EdU27A4UVqmBAajsqDEBuneNJilxTZ3D/E=
--00000000000076d5e105ba7a610e--
