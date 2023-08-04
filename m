Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662DDC001DF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 10:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjHDKoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 06:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjHDKn7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 06:43:59 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2604A49C6
        for <linux-scsi@vger.kernel.org>; Fri,  4 Aug 2023 03:43:58 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bc411e9d17so11205925ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2023 03:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1691145837; x=1691750637;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DdZ/8NDXE2QNPpCDlSUHpDy4KOUOU90D1ZhSGkylsqc=;
        b=MNZImPK2E9NmziCqz4V4cQMhpncmD8FMVBKE32KFbh4pUzNd7tspHi3F8nPDbuHhE0
         lNiQ+Is9pE890HstoKOb/yn8sPbPZPUC1/Ts5L4ND1qNYhgjKCy9EfMkTLkEJtVn6gZu
         42Up1xpSXX8R5WZCVj2RZIDknRbbKhp42A1XU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691145837; x=1691750637;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DdZ/8NDXE2QNPpCDlSUHpDy4KOUOU90D1ZhSGkylsqc=;
        b=GjvTodzrZdKFL7CXd9lXEP9vLn7x3vRGmrvsoWIQBge2tG7dhH36SEr7ofKiUAbtUC
         VKcGGo906rICCkyVCpwc6AmEsrZGnD2mNDQH8s05SKuGXWwU0DlTaJeaYeW2fLvZSdxp
         J3nkWrJK/qpoznhwceKt8inOVxSQCFT0y5GyFd1UhNJH0Pf8wUYmTFHERC5NjGYGbEqS
         1cy9eG2IzAUePJvP8kXiLqK6bxy7hi5Z9uKdWUAnL5TiY8l/2YDwCzXHcqQ4wXzZ+HCJ
         kBZe3qc1ytlahHvDYiYsqPqIQhb6tDR/z8Kx9+CYlIKhVchzZ6EnGMBtLDVs1JJRkuq2
         2tSQ==
X-Gm-Message-State: AOJu0YxmoX2242TG0EZkVKdqK5fP2zTyqcdjVkK5GbbBcVAbO8P1Kp7E
        5EaVP5GlD+78iqhsjcmZSsrHA6vlPEqQbQjXfX2IA3YrSsJz1Jgkx0XabZFd0y5snie3eRZ9Q+w
        LDMhkIcRADrkSxmlhUlXqt0SywOmou/aAt5fhpGAvwpY0USRf6HKXPLPKNPTAD2FkIRJLH5KHnM
        0Cm9/fn2uXHQ==
X-Google-Smtp-Source: AGHT+IHS9UkQWlnWvaz8kRzKylU7nRpcAFfF0pI+29ID4KXyMWU2kdp60z0riO9JG0V5Wtsr4E0YqA==
X-Received: by 2002:a17:902:ab5c:b0:1bc:2bd:8520 with SMTP id ij28-20020a170902ab5c00b001bc02bd8520mr1319960plb.6.1691145837079;
        Fri, 04 Aug 2023 03:43:57 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id jb15-20020a170903258f00b001bb988ac243sm1424463plb.297.2023.08.04.03.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 03:43:56 -0700 (PDT)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v3 3/6] mpi3mr: Add support for more than 1MB I/O
Date:   Fri,  4 Aug 2023 16:12:45 +0530
Message-Id: <20230804104248.118924-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230804104248.118924-1-ranjan.kumar@broadcom.com>
References: <20230804104248.118924-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e7c7d70602169247"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e7c7d70602169247
Content-Transfer-Encoding: 8bit

The driver is enhanced to get the maximum data length per I/O
request from  IOC Facts data and report that to the upper layers.
If the IOC facts data is not reported then the default I/O size
of 1MB is reported to the OS.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  8 ++++++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 29 ++++++++++++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_os.c | 24 ++++++++++++++++++++----
 3 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0afb687402e1..fd3619775739 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -66,11 +66,12 @@ extern atomic64_t event_counter;
 #define MPI3MR_NAME_LENGTH	32
 #define IOCNAME			"%s: "
 
-#define MPI3MR_MAX_SECTORS	2048
+#define MPI3MR_DEFAULT_MAX_IO_SIZE	(1 * 1024 * 1024)
 
 /* Definitions for internal SGL and Chain SGL buffers */
 #define MPI3MR_PAGE_SIZE_4K		4096
-#define MPI3MR_SG_DEPTH		(MPI3MR_PAGE_SIZE_4K / sizeof(struct mpi3_sge_common))
+#define MPI3MR_DEFAULT_SGL_ENTRIES	256
+#define MPI3MR_MAX_SGL_ENTRIES		2048
 
 /* Definitions for MAX values for shost */
 #define MPI3MR_MAX_CMDS_LUN	128
@@ -323,6 +324,7 @@ struct mpi3mr_ioc_facts {
 	u16 max_perids;
 	u16 max_pds;
 	u16 max_sasexpanders;
+	u32 max_data_length;
 	u16 max_sasinitiators;
 	u16 max_enclosures;
 	u16 max_pcie_switches;
@@ -959,6 +961,7 @@ struct scmd_priv {
  * @stop_drv_processing: Stop all command processing
  * @device_refresh_on: Don't process the events until devices are refreshed
  * @max_host_ios: Maximum host I/O count
+ * @max_sgl_entries: Max SGL entries per I/O
  * @chain_buf_count: Chain buffer count
  * @chain_buf_pool: Chain buffer pool
  * @chain_sgl_list: Chain SGL list
@@ -1129,6 +1132,7 @@ struct mpi3mr_ioc {
 	u16 max_host_ios;
 	spinlock_t tgtdev_lock;
 	struct list_head tgtdev_list;
+	u16 max_sgl_entries;
 
 	u32 chain_buf_count;
 	struct dma_pool *chain_buf_pool;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 11b78d4a87a0..f039f1d98647 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1163,6 +1163,12 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 		return -EPERM;
 	}
 
+	if (mrioc->shost->max_sectors != (mrioc->facts.max_data_length / 512))
+		ioc_err(mrioc, "Warning: The maximum data transfer length\n"
+			    "\tchanged after reset: previous(%d), new(%d),\n"
+			    "the driver cannot change this at run time\n",
+			    mrioc->shost->max_sectors * 512, mrioc->facts.max_data_length);
+
 	if ((mrioc->sas_transport_enabled) && (mrioc->facts.ioc_capabilities &
 	    MPI3_IOCFACTS_CAPABILITY_MULTIPATH_ENABLED))
 		ioc_err(mrioc,
@@ -2856,6 +2862,7 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	    le16_to_cpu(facts_data->max_pcie_switches);
 	mrioc->facts.max_sasexpanders =
 	    le16_to_cpu(facts_data->max_sas_expanders);
+	mrioc->facts.max_data_length = le16_to_cpu(facts_data->max_data_length);
 	mrioc->facts.max_sasinitiators =
 	    le16_to_cpu(facts_data->max_sas_initiators);
 	mrioc->facts.max_enclosures = le16_to_cpu(facts_data->max_enclosures);
@@ -2893,13 +2900,18 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.io_throttle_high =
 	    le16_to_cpu(facts_data->io_throttle_high);
 
+	if (mrioc->facts.max_data_length ==
+	    MPI3_IOCFACTS_MAX_DATA_LENGTH_NOT_REPORTED)
+		mrioc->facts.max_data_length = MPI3MR_DEFAULT_MAX_IO_SIZE;
+	else
+		mrioc->facts.max_data_length *= MPI3MR_PAGE_SIZE_4K;
 	/* Store in 512b block count */
 	if (mrioc->facts.io_throttle_data_length)
 		mrioc->io_throttle_data_length =
 		    (mrioc->facts.io_throttle_data_length * 2 * 4);
 	else
 		/* set the length to 1MB + 1K to disable throttle */
-		mrioc->io_throttle_data_length = MPI3MR_MAX_SECTORS + 2;
+		mrioc->io_throttle_data_length = (mrioc->facts.max_data_length / 512) + 2;
 
 	mrioc->io_throttle_high = (mrioc->facts.io_throttle_high * 2 * 1024);
 	mrioc->io_throttle_low = (mrioc->facts.io_throttle_low * 2 * 1024);
@@ -2914,9 +2926,9 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	ioc_info(mrioc, "SGEModMask 0x%x SGEModVal 0x%x SGEModShift 0x%x ",
 	    mrioc->facts.sge_mod_mask, mrioc->facts.sge_mod_value,
 	    mrioc->facts.sge_mod_shift);
-	ioc_info(mrioc, "DMA mask %d InitialPE status 0x%x\n",
+	ioc_info(mrioc, "DMA mask %d InitialPE status 0x%x max_data_len (%d)\n",
 	    mrioc->facts.dma_mask, (facts_flags &
-	    MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK));
+	    MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK), mrioc->facts.max_data_length);
 	ioc_info(mrioc,
 	    "max_dev_per_throttle_group(%d), max_throttle_groups(%d)\n",
 	    mrioc->facts.max_dev_per_tg, mrioc->facts.max_io_throttle_group);
@@ -3414,7 +3426,14 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->chain_sgl_list)
 		goto out_failed;
 
-	sz = MPI3MR_PAGE_SIZE_4K;
+	if (mrioc->max_sgl_entries > (mrioc->facts.max_data_length /
+		MPI3MR_PAGE_SIZE_4K))
+		mrioc->max_sgl_entries = mrioc->facts.max_data_length /
+			MPI3MR_PAGE_SIZE_4K;
+	sz = mrioc->max_sgl_entries * sizeof(struct mpi3_sge_common);
+	ioc_info(mrioc, "number of sgl entries=%d chain buffer size=%dKB\n",
+			mrioc->max_sgl_entries, sz/1024);
+
 	mrioc->chain_buf_pool = dma_pool_create("chain_buf pool",
 	    &mrioc->pdev->dev, sz, 16, 0);
 	if (!mrioc->chain_buf_pool) {
@@ -3813,7 +3832,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	}
 
 	mrioc->max_host_ios = mrioc->facts.max_reqs - MPI3MR_INTERNAL_CMDS_RESVD;
-
+	mrioc->shost->max_sectors = mrioc->facts.max_data_length / 512;
 	mrioc->num_io_throttle_group = mrioc->facts.max_io_throttle_group;
 	atomic_set(&mrioc->pend_large_data_sz, 0);
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d627355303d7..b19b624d0e97 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -33,6 +33,12 @@ static int logging_level;
 module_param(logging_level, int, 0);
 MODULE_PARM_DESC(logging_level,
 	" bits for enabling additional logging info (default=0)");
+static int max_sgl_entries = MPI3MR_DEFAULT_SGL_ENTRIES;
+module_param(max_sgl_entries, int, 0444);
+MODULE_PARM_DESC(max_sgl_entries,
+	"Preferred max number of SG entries to be used for a single I/O\n"
+	"The actual value will be determined by the driver\n"
+	"(Minimum=256, Maximum=2048, default=256)");
 
 /* Forward declarations*/
 static void mpi3mr_send_event_ack(struct mpi3mr_ioc *mrioc, u8 event,
@@ -3413,7 +3419,7 @@ static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
 		    scsi_bufflen(scmd));
 		return -ENOMEM;
 	}
-	if (sges_left > MPI3MR_SG_DEPTH) {
+	if (sges_left > mrioc->max_sgl_entries) {
 		sdev_printk(KERN_ERR, scmd->device,
 		    "scsi_dma_map returned unsupported sge count %d!\n",
 		    sges_left);
@@ -4818,10 +4824,10 @@ static const struct scsi_host_template mpi3mr_driver_template = {
 	.no_write_same			= 1,
 	.can_queue			= 1,
 	.this_id			= -1,
-	.sg_tablesize			= MPI3MR_SG_DEPTH,
+	.sg_tablesize			= MPI3MR_DEFAULT_SGL_ENTRIES,
 	/* max xfer supported is 1M (2K in 512 byte sized sectors)
 	 */
-	.max_sectors			= 2048,
+	.max_sectors			= (MPI3MR_DEFAULT_MAX_IO_SIZE / 512),
 	.cmd_per_lun			= MPI3MR_MAX_CMDS_LUN,
 	.max_segment_size		= 0xffffffff,
 	.track_queue_depth		= 1,
@@ -5004,6 +5010,16 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mrioc->pdev = pdev;
 	mrioc->stop_bsgs = 1;
 
+	mrioc->max_sgl_entries = max_sgl_entries;
+	if (max_sgl_entries > MPI3MR_MAX_SGL_ENTRIES)
+		mrioc->max_sgl_entries = MPI3MR_MAX_SGL_ENTRIES;
+	else if (max_sgl_entries < MPI3MR_DEFAULT_SGL_ENTRIES)
+		mrioc->max_sgl_entries = MPI3MR_DEFAULT_SGL_ENTRIES;
+	else {
+		mrioc->max_sgl_entries /= MPI3MR_DEFAULT_SGL_ENTRIES;
+		mrioc->max_sgl_entries *= MPI3MR_DEFAULT_SGL_ENTRIES;
+	}
+
 	/* init shost parameters */
 	shost->max_cmd_len = MPI3MR_MAX_CDB_LENGTH;
 	shost->max_lun = -1;
@@ -5068,7 +5084,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		shost->nr_maps = 3;
 
 	shost->can_queue = mrioc->max_host_ios;
-	shost->sg_tablesize = MPI3MR_SG_DEPTH;
+	shost->sg_tablesize = mrioc->max_sgl_entries;
 	shost->max_id = mrioc->facts.max_perids + 1;
 
 	retval = scsi_add_host(shost, &pdev->dev);
-- 
2.31.1


--000000000000e7c7d70602169247
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDExX4+q15YXlYbDuOzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjExMTQxMjAzMThaFw0yNTExMTQxMjAzMThaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFJhbmphbiBLdW1hcjEoMCYGCSqGSIb3DQEJ
ARYZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOgccBnKTcRY5ViAG6iAGKWZ8pjYBaC0yPSOnu903VijdPFPnRdvshVcVxr6QvmlBCzKJaet
zZlOdDzH9Sh5FfHxwia1H790mce+cjggA6koNdslP25m4SfoAUcvLxNk1koVjbyxvNPG40Mlg8f8
Dp9JubCHz3kEFHjItKFkpS8CHMR1Hx4Cnws434zD/pz1TMUmYyq1kma0Vi8YPVlwkaHgq4J/9Lw/
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIxQn1b4WX3o6Mg66W0pPYJ110EqaA0m
fGaH56/SyjS2MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDgw
NDEwNDM1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCxALt3oRxL2e8eIAZ1Z8kVg22lyXGCkQvrJSsEu9iDuS618y80
rZkSGr/04bHeI5CO3/sxPCD8pQ1rq7G/b0v6fjRR5uT2/o2zhUwKcvvAoyIcAhiOL9SBB05aoJSC
xDx+YGBBX1/Erf4MIomJYwBfDP2Sy0Pi2JNGx30dWFjgUWNuN9jbkbUJVJkUjtIPZ1L90Zr6HQ6n
fbN6Z6petAWnroyff6CBAixjdxKp2axo42H2PsRfzDDlOasJOhvOgNpDinVSVG8GvehthuBE7Xay
/QWujRinsZ+JlPXa9o/e5ixpIqxZUJU5fx5YLzwA8MCHgJ1tIWUYibP+Crk7u3JJ
--000000000000e7c7d70602169247--
