Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DC9C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 10:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C517613AE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 10:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhEUK2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 06:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbhEUK2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 06:28:15 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5F5C061344
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 03:26:39 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t193so13887429pgb.4
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 03:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=waNV9PVJcbTauYUXA29dlti8zAFpgrilSBbhkgG4yEM=;
        b=OULdCrrBKx5YjtHWJpt6HKVEtUZ86/6XoZ/cWQVng7sfWZbUIl1G0Ad4qGq2ijbOPX
         DNBUH4fe15AIOaLWLYsDTsqgfCEwl03erloRXrQWZ6x7Xz1l0Ql6O4oEuYkkXge2677k
         0/KDW9IyLxHQmMgm/cW95uOikJNaNT0b3FcLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=waNV9PVJcbTauYUXA29dlti8zAFpgrilSBbhkgG4yEM=;
        b=rspbP3PVNaOwlDwlhV6NFPzCKMiVL7JsyFBi00nSBkwZ0JOFoyu9YjN2RpMHTeUFKD
         ADQQ2eXxTMyiSs31btxqlC6UNxVAkcHDsu3yCaRcZxjHiUZ+A21pbygW+mAAvuRCGOWC
         tF4/uHfo45kTmF8e11rhwupTEVxN818kK6R6eT7d9p2poPoPqbq14AtiSGmZLrL01l6j
         rFqIGHHky/n6TtAuPIl9ubfs2EyDH3CWeYS3oBYbhY3BCATH5V/pf+kpcXRZ16iaxxRQ
         hjcNAvE7tQ1qlQC23tEFS3IguZA97Gk70NHhh/Gr/dV7vVBYQgJmOXZmTVMKWBa/OVEW
         SeNg==
X-Gm-Message-State: AOAM5337vGhckS+4HVNBF2Y1AurR+cfX/z7CVp3kmvFoDb/oiCGfuNJi
        RfVcZSWmWOwW7X085Plz8IDDYwPOQrgD+aKMN0D2NZX1syniUWm/Y6+IDjmx5hp/NH3wzWtE/1E
        nnGkD7F+xQXCe7Lma3+92hlcJCv6MrdWbywSjuT03XTm2tVE08lmT35V0LyDRmR814fN8I4BQlW
        ligdZSiokUwbzw7bw=
X-Google-Smtp-Source: ABdhPJxRT06WYWMzy6IgpnaksRNyLtsXRIBd5TMzRaIN8b1hE5q3P0HV45w38p43aqDT1WXCjpD+cg==
X-Received: by 2002:a63:e114:: with SMTP id z20mr9145887pgh.207.1621592798700;
        Fri, 21 May 2021 03:26:38 -0700 (PDT)
Received: from dhcp-10-123-20-83.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j3sm4197858pfe.98.2021.05.21.03.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 03:26:38 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 3/5] megaraid_sas: Early detection of VD deletion through RaidMap update
Date:   Fri, 21 May 2021 15:55:46 +0530
Message-Id: <20210521102548.11156-4-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210521102548.11156-1-chandrakanth.patil@broadcom.com>
References: <20210521102548.11156-1-chandrakanth.patil@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c43fd005c2d47e3a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c43fd005c2d47e3a

Consider in a case, when a VD is deleted and the targetID of
that VD is assigned to a newly created VD. If the sequence of
deletion/addition of VD happens very quickly, there is a possibility
that second event(VD add) occurs even before the driver processes the
first event(VD delete).
As event processing is done in deferred context the device list
remains same(but targetID is re-used) so driver will not learn the
VD deletion/additon and IOs meant for older VD will be directed to
new VD which may lead to data corruption.

In new design, driver will detect the deleted VD as soon as possible
based on the RaidMap update and blocks further IOs to that device.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 12 ++++
 drivers/scsi/megaraid/megaraid_sas_base.c | 83 ++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fp.c   |  6 +-
 3 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index b5a765b73c76..a43b67299b08 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2262,6 +2262,15 @@ enum MR_PERF_MODE {
 		 (mode) == MR_LATENCY_PERF_MODE ? "Latency" : \
 		 "Unknown")
 
+enum MEGASAS_LD_TARGET_ID_STATUS {
+	LD_TARGET_ID_INITIAL,
+	LD_TARGET_ID_ACTIVE,
+	LD_TARGET_ID_DELETED,
+};
+
+#define MEGASAS_TARGET_ID(sdev)						\
+	(((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id)
+
 struct megasas_instance {
 
 	unsigned int *reply_map;
@@ -2326,6 +2335,9 @@ struct megasas_instance {
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
 	struct megasas_pd_list          local_pd_list[MEGASAS_MAX_PD];
 	u8 ld_ids[MEGASAS_MAX_LD_IDS];
+	u8 ld_tgtid_status[MEGASAS_MAX_LD_IDS];
+	u8 ld_ids_prev[MEGASAS_MAX_LD_IDS];
+	u8 ld_ids_from_raidmap[MEGASAS_MAX_LD_IDS];
 	s8 init_id;
 
 	u16 max_num_sge;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 35b2137e0d1a..9cb167069ec8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -141,6 +141,8 @@ static int megasas_register_aen(struct megasas_instance *instance,
 				u32 seq_num, u32 class_locale_word);
 static void megasas_get_pd_info(struct megasas_instance *instance,
 				struct scsi_device *sdev);
+static void
+megasas_set_ld_removed_by_fw(struct megasas_instance *instance);
 
 /*
  * PCI ID table for all supported controllers
@@ -436,6 +438,12 @@ megasas_decode_evt(struct megasas_instance *instance)
 			(class_locale.members.locale),
 			format_class(class_locale.members.class),
 			evt_detail->description);
+
+	if (megasas_dbg_lvl & LD_PD_DEBUG)
+		dev_info(&instance->pdev->dev,
+			 "evt_detail.args.ld.target_id/index %d/%d\n",
+			 evt_detail->args.ld.target_id, evt_detail->args.ld.ld_index);
+
 }
 
 /*
@@ -1779,6 +1787,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
 	struct megasas_instance *instance;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
+	u32 ld_tgt_id;
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
@@ -1805,17 +1814,21 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		}
 	}
 
-	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
+	mr_device_priv_data = scmd->device->hostdata;
+	if (!mr_device_priv_data ||
+	    (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
 	}
 
-	mr_device_priv_data = scmd->device->hostdata;
-	if (!mr_device_priv_data) {
-		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
-		return 0;
+	if (MEGASAS_IS_LOGICAL(scmd->device)) {
+		ld_tgt_id = MEGASAS_TARGET_ID(scmd->device);
+		if (instance->ld_tgtid_status[ld_tgt_id] == LD_TARGET_ID_DELETED) {
+			scmd->result = DID_NO_CONNECT << 16;
+			scmd->scsi_done(scmd);
+			return 0;
+		}
 	}
 
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL)
@@ -2095,7 +2108,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 
 static int megasas_slave_alloc(struct scsi_device *sdev)
 {
-	u16 pd_index = 0;
+	u16 pd_index = 0, ld_tgt_id;
 	struct megasas_instance *instance ;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
@@ -2120,6 +2133,14 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 					GFP_KERNEL);
 	if (!mr_device_priv_data)
 		return -ENOMEM;
+
+	if (MEGASAS_IS_LOGICAL(sdev)) {
+		ld_tgt_id = MEGASAS_TARGET_ID(sdev);
+		instance->ld_tgtid_status[ld_tgt_id] = LD_TARGET_ID_ACTIVE;
+		if (megasas_dbg_lvl & LD_PD_DEBUG)
+			sdev_printk(KERN_INFO, sdev, "LD target ID %d created.\n", ld_tgt_id);
+	}
+
 	sdev->hostdata = mr_device_priv_data;
 
 	atomic_set(&mr_device_priv_data->r1_ldio_hint,
@@ -2129,6 +2150,19 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 
 static void megasas_slave_destroy(struct scsi_device *sdev)
 {
+	u16 ld_tgt_id;
+	struct megasas_instance *instance;
+
+	instance = megasas_lookup_instance(sdev->host->host_no);
+
+	if (MEGASAS_IS_LOGICAL(sdev)) {
+		ld_tgt_id = MEGASAS_TARGET_ID(sdev);
+		instance->ld_tgtid_status[ld_tgt_id] = LD_TARGET_ID_DELETED;
+		if (megasas_dbg_lvl & LD_PD_DEBUG)
+			sdev_printk(KERN_INFO, sdev,
+				    "LD target ID %d removed from OS stack\n", ld_tgt_id);
+	}
+
 	kfree(sdev->hostdata);
 	sdev->hostdata = NULL;
 }
@@ -3525,6 +3559,22 @@ megasas_complete_abort(struct megasas_instance *instance,
 	}
 }
 
+static void
+megasas_set_ld_removed_by_fw(struct megasas_instance *instance)
+{
+	uint i;
+
+	for (i = 0; (i < MEGASAS_MAX_LD_IDS); i++) {
+		if (instance->ld_ids_prev[i] != 0xff &&
+		    instance->ld_ids_from_raidmap[i] == 0xff) {
+			if (megasas_dbg_lvl & LD_PD_DEBUG)
+				dev_info(&instance->pdev->dev,
+					 "LD target ID %d removed from RAID map\n", i);
+			instance->ld_tgtid_status[i] = LD_TARGET_ID_DELETED;
+		}
+	}
+}
+
 /**
  * megasas_complete_cmd -	Completes a command
  * @instance:			Adapter soft state
@@ -3687,9 +3737,13 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				fusion->fast_path_io = 0;
 			}
 
+			if (instance->adapter_type >= INVADER_SERIES)
+				megasas_set_ld_removed_by_fw(instance);
+
 			megasas_sync_map_info(instance);
 			spin_unlock_irqrestore(instance->host->host_lock,
 					       flags);
+
 			break;
 		}
 		if (opcode == MR_DCMD_CTRL_EVENT_GET_INFO ||
@@ -8831,8 +8885,10 @@ megasas_aen_polling(struct work_struct *work)
 	union megasas_evt_class_locale class_locale;
 	int event_type = 0;
 	u32 seq_num;
+	u16 ld_target_id;
 	int error;
 	u8  dcmd_ret = DCMD_SUCCESS;
+	struct scsi_device *sdev1;
 
 	if (!instance) {
 		printk(KERN_ERR "invalid instance!\n");
@@ -8855,12 +8911,23 @@ megasas_aen_polling(struct work_struct *work)
 			break;
 
 		case MR_EVT_LD_OFFLINE:
-		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_LD_DELETED:
+			ld_target_id = instance->evt_detail->args.ld.target_id;
+			sdev1 = scsi_device_lookup(instance->host,
+						   MEGASAS_MAX_PD_CHANNELS +
+						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
+						   (ld_target_id - MEGASAS_MAX_DEV_PER_CHANNEL),
+						   0);
+			if (sdev1)
+				megasas_remove_scsi_device(sdev1);
+
+			event_type = SCAN_VD_CHANNEL;
+			break;
 		case MR_EVT_LD_CREATED:
 			event_type = SCAN_VD_CHANNEL;
 			break;
 
+		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
 		case MR_EVT_FOREIGN_CFG_IMPORTED:
 		case MR_EVT_LD_STATE_CHANGE:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index b6c08d620033..83f69c33b01a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -349,6 +349,10 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 
 	num_lds = le16_to_cpu(drv_map->raidMap.ldCount);
 
+	memcpy(instance->ld_ids_prev,
+	       instance->ld_ids_from_raidmap,
+	       sizeof(instance->ld_ids_from_raidmap));
+	memset(instance->ld_ids_from_raidmap, 0xff, MEGASAS_MAX_LD_IDS);
 	/*Convert Raid capability values to CPU arch */
 	for (i = 0; (num_lds > 0) && (i < MAX_LOGICAL_DRIVES_EXT); i++) {
 		ld = MR_TargetIdToLdGet(i, drv_map);
@@ -359,7 +363,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 
 		raid = MR_LdRaidGet(ld, drv_map);
 		le32_to_cpus((u32 *)&raid->capability);
-
+		instance->ld_ids_from_raidmap[i] = i;
 		num_lds--;
 	}
 
-- 
2.18.1


--000000000000c43fd005c2d47e3a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDEsToCXmVAGrOZU9LzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjM4MDJaFw0yMjA5MTUxMTIzMzVaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAN17vAiN630Miz8/OedJKuauChEmiA4b0QYvWMA5eDpaTmonlWoaIrq6
FEwzCFLCgTpToIzUShYM1O6fu/b6Zdy1Jvdccbj7u7mSXWF+rKJu5yg2g38x2XxWsy+/4rwqi9ix
BSrtpRGbpSxMsfxuEvtMbzZCeC4SitvLhFIMMHgUJ9E8pxXV7c0/ub5jxd/3nIOeIDoTOqJgSn40
aBqT0QvScYPWy42jL2D449cgE9PMNQy1mrSwerDqgTTgZJM4gAW7ta1nFP8cNbLJNYn3ZFEhJnOw
pXRVGaqlwpA1hmodBANNyhMlODsRuxNuqmNzINouAr/YlO2bdzlu+VTWz0MCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
KHtkFTCJhYaNrtTlVnhO7+Z49xswDQYJKoZIhvcNAQELBQADggEBAB695p3nxrHwDBiZuUyc4kSq
1o3jGWXYdAgZoVOXcGSn0FFSuBT4bkoZNRXvN4AZGh7n5XjtEzGQjn++xALKCRF6K3yFfhAqsrHx
66xXjz8VYmD4J4p+TzVo8GP7si+9xJO/AW4f0FMCQ3vJdruH1PMHZYYuHFHcgyDY5CagijMkFJtD
Zpnb0pToIvDm+Ur3N2MiX3nSNdXYjeMdwB0OAs05pMciX6VfrXagLKEdSRHtOo/W/JA7fToB0eJS
Ky1ZxnSRQGTL4yIIMw43kd0GQyTIM6KyMy8uprn32g7HcYJf07P/tjC196OWjB5Qr7dSv3vtjU8N
2J0Xc13/AGfXSZ8xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxLE6Al5lQBqzmVPS8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIO3JZGON
Yqx9cBdD0nGKp4xt1NOV1BYLRbxkN9cCiQbTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIxMDUyMTEwMjYzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA3GP9hd1lYIUuys5ZA1T8lCCjg
JkkNQMIrV3o++wuiSnh+Hl7Uv0HNLyvnz0OPtAyEj4wvzmX/PpL5sU2FUAXZ7Z2a411Vqnbx3SMT
RYbnxIcTd9cT7On1AKuA3NXH7gB4lQbYraXRvlvKaeunEd/C2tKU58F4b39MSp8M9d8DvZe4ia4x
5+VQa1dgPLBIFb15rYalXE4Np+iwZs0pFgt2dIC5cHYsJlNv0mvkf8Y8IFehPMoOVkYnxYWxmwoo
8UQ/MMIfG/Ug6SK6XJdAHmQIo1oD3+YiENZagkhylxiLFGxKYUCaRfeR3TMv1qTsFnrE7NPnSZQP
DpMGoQ098GAC
--000000000000c43fd005c2d47e3a--
