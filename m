Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BDBC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 19:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239931AbiGHTiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 15:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239170AbiGHTiV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 15:38:21 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0592771BC3
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 12:38:20 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d5so17093006plo.12
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2022 12:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=cU3zz7z+eNjk70WbOm9wJUOb55JtJPLPaHY61KfX8VY=;
        b=gKjVP82Ypx+48CCeARs3L8+ql+DP30Txa6xvE9PkczXOhNSr8SPvsxvosviQle/cKU
         hIYWdcXK+6OqTo2xXaNp+MN97sVP+WOjwdLzLDh7yEs6W6SDJWzN6mesyM9DyTGfWQL3
         WbMphzqaezuBHN8pEfr00xJhkYwr10aTIDfaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=cU3zz7z+eNjk70WbOm9wJUOb55JtJPLPaHY61KfX8VY=;
        b=Wp01khfFGGoJfjKGIIbnT1IJpUndTDU5koVdNKCjZY3DSuZBUg4kf8lo3GcSHe3AX2
         /Y7+ffOOK8nsJKN7eWLRbRewM81IyinNxz7KT5Ke4d2eXudYrDBLF0pQBFbJkONRtnd9
         7uEZqq7Fc6vaJYea1KaTOAbAeIN6eEuV/ERTLWdpYuQlrN87ux+xSjWRw0moCaiMRL0h
         SPxx650oAyZk6G0fc2gcpSEHLXwyufis4jcfNWjzG+pojoZankZ6+0H2k6mOLy1qsSNb
         6HEq3P7+6u8pBfokccY7J8R7KRzaC+s0FO34mAH/Jk8I2FW9O1dPtaaIq6LaWhJ33sNx
         9rVg==
X-Gm-Message-State: AJIora/CmLu8OKD0YEghXGNvLvdrdNYsEQ1vKRAPBhL5Mli7+JRK2I1V
        CV1veNXqSbceu0XdZbf6SfjIpDR5tKYkYbhG3CDZc+TzZcAqSW/EoGorqv+kKSJXXHdIz9h8eos
        ELKQ9+sebwa7Idpfqh72HPMGM4FEO58jKKEX7IeznRSGAj8JUVumQJPA4Du5Ezzb9WSAgEBeu24
        gPQGdmyXh9qyY=
X-Google-Smtp-Source: AGRyM1swx96NlPiDV9B1orKZ4/ef2APGhqYCwSKrT6eTiRXqf5DZMVbWyqCrE8RuLQs5zfs5d5RJGw==
X-Received: by 2002:a17:902:d50e:b0:16c:1664:81e5 with SMTP id b14-20020a170902d50e00b0016c166481e5mr5329300plg.149.1657309098958;
        Fri, 08 Jul 2022 12:38:18 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i16-20020a170902c95000b0015e8d4eb20dsm14256484pla.87.2022.07.08.12.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 12:38:18 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 2/2] mpi3mr: Reduce VD queue depth on detecting the throttling
Date:   Sat,  9 Jul 2022 01:20:20 +0530
Message-Id: <20220708195020.8323-3-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
References: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000285a1205e35058af"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000285a1205e35058af
Content-Transfer-Encoding: 8bit

Reduce the VD queue depth on detecting the throttling condition.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  10 +++
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   4 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 123 ++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6bb3311..0935b2e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -436,6 +436,10 @@ struct mpi3mr_intr_info {
  * struct mpi3mr_throttle_group_info - Throttle group info
  *
  * @io_divert: Flag indicates io divert is on or off for the TG
+ * @need_qd_reduction: Flag to indicate QD reduction is needed
+ * @qd_reduction: Queue Depth reduction in units of 10%
+ * @fw_qd: QueueDepth value reported by the firmware
+ * @modified_qd: Modified QueueDepth value due to throttling
  * @id: Throttle Group ID.
  * @high: High limit to turn on throttling in 512 byte blocks
  * @low: Low limit to turn off throttling in 512 byte blocks
@@ -443,6 +447,10 @@ struct mpi3mr_intr_info {
  */
 struct mpi3mr_throttle_group_info {
 	u8 io_divert;
+	u8 need_qd_reduction;
+	u8 qd_reduction;
+	u16 fw_qd;
+	u16 modified_qd;
 	u16 id;
 	u32 high;
 	u32 low;
@@ -486,6 +494,7 @@ struct tgt_dev_pcie {
  * cached from firmware given data
  *
  * @state: State of the VD
+ * @tg_qd_reduction: Queue Depth reduction in units of 10%
  * @tg_id: VDs throttle group ID
  * @high: High limit to turn on throttling in 512 byte blocks
  * @low: Low limit to turn off throttling in 512 byte blocks
@@ -493,6 +502,7 @@ struct tgt_dev_pcie {
  */
 struct tgt_dev_vd {
 	u8 state;
+	u8 tg_qd_reduction;
 	u16 tg_id;
 	u32 tg_high;
 	u32 tg_low;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index ab79374..6e39f79 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4077,9 +4077,13 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		tg = mrioc->throttle_groups;
 		for (i = 0; i < mrioc->num_io_throttle_group; i++, tg++) {
 			tg->id = 0;
+			tg->fw_qd = 0;
+			tg->modified_qd = 0;
 			tg->io_divert = 0;
+			tg->need_qd_reduction = 0;
 			tg->high = 0;
 			tg->low = 0;
+			tg->qd_reduction = 0;
 			atomic_set(&tg->pend_large_data_sz, 0);
 		}
 	}
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e1ccb5f..6e36229 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -38,6 +38,8 @@ MODULE_PARM_DESC(logging_level,
 static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
 	struct mpi3mr_drv_cmd *cmdparam, u32 event_ctx);
 
+#define MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION	(0xFFFF)
+
 /**
  * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
  * @mrioc: Adapter instance reference
@@ -354,6 +356,50 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 	}
 }
 
+/**
+ * mpi3mr_queue_qd_reduction_event -Queue TG QD reduction event
+ * @mrioc: Adapter instance reference
+ * @tg: Throttle group information pointer
+ *
+ * Accessor to queue on synthetically generated driver event to
+ * the event worker thread, the driver event will be used to
+ * reduce the QD of all VDs in the TG from the worker thread.
+ *
+ * Return: None.
+ */
+static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_throttle_group_info *tg)
+{
+	struct mpi3mr_fwevt *fwevt;
+	u16 sz = sizeof(struct mpi3mr_throttle_group_info *);
+
+	/*
+	 * If the QD reduction event is already queued due to throttle and if
+	 * the QD is not restored through device info change event
+	 * then dont queue further reduction events
+	 */
+	if (tg->fw_qd != tg->modified_qd)
+		return;
+
+	fwevt = mpi3mr_alloc_fwevt(sz);
+	if (!fwevt) {
+		ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
+		return;
+	}
+	*(__le64 *)fwevt->event_data = (__le64)tg;
+	fwevt->mrioc = mrioc;
+	fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
+	fwevt->send_ack = 0;
+	fwevt->process_evt = 1;
+	fwevt->evt_ctx = 0;
+	fwevt->event_data_size = sz;
+	tg->modified_qd = max_t(u16, (tg->fw_qd * tg->qd_reduction) / 10, 8);
+
+	dprint_event_bh(mrioc, "qd reduction event queued for tg_id(%d)\n",
+	    tg->id);
+	mpi3mr_fwevt_add_to_list(mrioc, fwevt);
+}
+
 /**
  * mpi3mr_invalidate_devhandles -Invalidate device handles
  * @mrioc: Adapter instance reference
@@ -880,6 +926,7 @@ static int mpi3mr_change_queue_depth(struct scsi_device *sdev,
 	else if (!q_depth)
 		q_depth = MPI3MR_DEFAULT_SDEV_QD;
 	retval = scsi_change_queue_depth(sdev, q_depth);
+	sdev->max_queue_depth = sdev->queue_depth;
 
 	return retval;
 }
@@ -1100,6 +1147,11 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 			tg->id = vdinf_io_throttle_group;
 			tg->high = tgtdev->dev_spec.vd_inf.tg_high;
 			tg->low = tgtdev->dev_spec.vd_inf.tg_low;
+			tg->qd_reduction =
+			    tgtdev->dev_spec.vd_inf.tg_qd_reduction;
+			if (is_added == true)
+				tg->fw_qd = tgtdev->q_depth;
+			tg->modified_qd = tgtdev->q_depth;
 		}
 		tgtdev->dev_spec.vd_inf.tg = tg;
 		if (scsi_tgt_priv_data)
@@ -1493,6 +1545,60 @@ static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
 	    fwevt->event_data_size);
 }
 
+/**
+ * mpi3mr_update_sdev_qd - Update SCSI device queue depath
+ * @sdev: SCSI device reference
+ * @data: Queue depth reference
+ *
+ * This is an iterator function called for each SCSI device in a
+ * target to update the QD of each SCSI device.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_update_sdev_qd(struct scsi_device *sdev, void *data)
+{
+	u16 *q_depth = (u16 *)data;
+
+	scsi_change_queue_depth(sdev, (int)*q_depth);
+	sdev->max_queue_depth = sdev->queue_depth;
+}
+
+/**
+ * mpi3mr_set_qd_for_all_vd_in_tg -set QD for TG VDs
+ * @mrioc: Adapter instance reference
+ * @tg: Throttle group information pointer
+ *
+ * Accessor to reduce QD for each device associated with the
+ * given throttle group.
+ *
+ * Return: None.
+ */
+static void mpi3mr_set_qd_for_all_vd_in_tg(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_throttle_group_info *tg)
+{
+	unsigned long flags;
+	struct mpi3mr_tgt_dev *tgtdev;
+	struct mpi3mr_stgt_priv_data *tgt_priv;
+
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
+		if (tgtdev->starget && tgtdev->starget->hostdata) {
+			tgt_priv = tgtdev->starget->hostdata;
+			if (tgt_priv->throttle_group == tg) {
+				dprint_event_bh(mrioc,
+				    "updating qd due to throttling for persist_id(%d) original_qd(%d), reduced_qd (%d)\n",
+				    tgt_priv->perst_id, tgtdev->q_depth,
+				    tg->modified_qd);
+				starget_for_each_device(tgtdev->starget,
+				    (void *)&tg->modified_qd,
+				    mpi3mr_update_sdev_qd);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+}
+
 /**
  * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
  * @mrioc: Adapter instance reference
@@ -1550,6 +1656,21 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 		mpi3mr_logdata_evt_bh(mrioc, fwevt);
 		break;
 	}
+	case MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION:
+	{
+		struct mpi3mr_throttle_group_info *tg;
+
+		tg = (struct mpi3mr_throttle_group_info *)
+		    (*(__le64 *)fwevt->event_data);
+		dprint_event_bh(mrioc,
+		    "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
+		    tg->id, tg->need_qd_reduction);
+		if (tg->need_qd_reduction) {
+			mpi3mr_set_qd_for_all_vd_in_tg(mrioc, tg);
+			tg->need_qd_reduction = 0;
+		}
+		break;
+	}
 	default:
 		break;
 	}
@@ -4234,8 +4355,10 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 			    mrioc->io_throttle_high) ||
 			    (tg_pend_data_len >= tg->high))) {
 				tg->io_divert = 1;
+				tg->need_qd_reduction = 1;
 				mpi3mr_set_io_divert_for_all_vd_in_tg(mrioc,
 				    tg, 1);
+				mpi3mr_queue_qd_reduction_event(mrioc, tg);
 			}
 		} else {
 			ioc_pend_data_len = atomic_add_return(data_len_blks,
-- 
2.27.0


--000000000000285a1205e35058af
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPbtVJkrTWUC2f7Q0Vv1
A52Vy/C7pYtGCxzJonLdJ/aMMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcwODE5MzgxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC1LykS5fHuSHZeXDns+nHB1N86OpbdI5oHjHqc
OQIx7pTCPmij47eonDxTx/woVX389it0MaIeWrmGOI5PDA3G8JK8tDJjGuCfWU0oM2ZfnCsSDjRB
BbVmEXYnY6EAzyPYKTfAk9UADPbCjsmJsD9hmwl6iqIqBPwYF11ky9BO3TQIqMSagftGfo+2i+VG
/k1k/LFA6dVEGKQUpn24vn+3m5hDrI8duzfMo/OzRAMkeX8ljvYSB1w2/kzcU7CmTqM1eJM5rVpF
ibNVLi3u160AhU7oSFSXAp7c8URz018jnQX64lEIwnrsjJbu3T6ID3FElcgtNuKgaxCyPpLzvRUc
--000000000000285a1205e35058af--
