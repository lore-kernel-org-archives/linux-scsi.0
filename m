Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D194C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234E560E73
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhIUSsE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhIUSrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 14:47:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B945C061575
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:19 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v2so19401plp.8
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IRwb8F1kCJPVehyeKNF1oxDYX0cEfGAXG2qxbJN1ryQ=;
        b=CaG1p+byNuhCwQCSl2CPLJ8I9BnzsOt0yZ6amW/AuG0rfuoGIFIHFcN/bR1oeZuoFU
         4/GdWaYxGgirXBT6SBYrKfJEUyT4T7oF/YAfJxQ7t4cXF98WJPH4B4lEg8vvz//0BOb0
         SeOGaqGrJdbA5TruGTzGVnQ7DhUDHE21yKH0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IRwb8F1kCJPVehyeKNF1oxDYX0cEfGAXG2qxbJN1ryQ=;
        b=gPxL1axMfztZVLZ09BVICUEPUT6NEjBgX/TKTa1/FZ29sCcxR+nwWgkb6fMhP1+aQb
         VPTQjQXHyD00EDhH17ChCglAc5LUy9882j0ZSOh41WJbwTsCXOTAWWrB9xBYHsBtpYJK
         qmoTe4QMPXNIDDmq5GNwx79d8fsa7Jx9hNxCt0/y/fuF+BHDaVHqjLLg0XpMQR84YFPT
         k9n8pXQ6cvyhkHLNn74TBRP11dpeHLwYjMf+hL2nuzmJNn/NNbl3kNrKRHmVnxqCgw89
         pl8ItbvNxhePH2BbGNpH4PERnITdF1oCXb8AlU3M0WgArO0bvudUJ1YIVYSiADLRzmYY
         fKOg==
X-Gm-Message-State: AOAM531kmFolnPSOtlPwgqXRLhi1mUQbguTC85L3PbvMhzCaFIIl+dW8
        Bj0pwYYTBipOH7bASCi9rBtC/e9WH3sWWy1AINXgX6qB2FNfTJpKPg34APUEjMeVj7Kq4Qt8EMJ
        VFuoKQPDTr1WHQ2KMXX/25/1GerMCAU/akRIzWU088x/mwYzCyZSH2DJlmfHgkkXkEMw5+EhJGn
        xgQIgLGtIa
X-Google-Smtp-Source: ABdhPJyoE5xGhGCdVrAdaucjA20s/VkOw2O/zrQqc6hYF1rA5tD2KSJ/T/Nx0w164MTxCX4WQaEJrg==
X-Received: by 2002:a17:902:a38b:b0:138:d329:27ac with SMTP id x11-20020a170902a38b00b00138d32927acmr28553126pla.7.1632249978720;
        Tue, 21 Sep 2021 11:46:18 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f144sm18258897pfa.24.2021.09.21.11.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:46:18 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 4/7] mpi3mr: misc changes and use __builtin_return_address for debug
Date:   Wed, 22 Sep 2021 00:15:57 +0530
Message-Id: <20210921184600.64427-5-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210921184600.64427-1-kashyap.desai@broadcom.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003186cf05cc85d068"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003186cf05cc85d068

No Functional changes.

Some minor variable name changes.
Use __builtin_return_address in some of the functions which are called
from multiple callers. Doing this we can avoid multiple debug prints.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  4 ++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 29 +++++++++++++++++------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 5ae73927590c..391708c72563 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -121,7 +121,7 @@ extern int prot_mask;
 
 /* Definitions for Event replies and sense buffer allocated per controller */
 #define MPI3MR_NUM_EVT_REPLIES	64
-#define MPI3MR_SENSEBUF_SZ	256
+#define MPI3MR_SENSE_BUF_SZ	256
 #define MPI3MR_SENSEBUF_FACTOR	3
 #define MPI3MR_CHAINBUF_FACTOR	3
 #define MPI3MR_CHAINBUFDIX_FACTOR	2
@@ -263,7 +263,7 @@ struct mpi3mr_ioc_facts {
 	u16 max_vds;
 	u16 max_hpds;
 	u16 max_advhpds;
-	u16 max_raidpds;
+	u16 max_raid_pds;
 	u16 min_devhandle;
 	u16 max_devhandle;
 	u16 max_op_req_q;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 337cbb3ffaaa..7da07fe71cfe 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1220,7 +1220,9 @@ int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 	u8 *areq_entry;
 
 	if (mrioc->unrecoverable) {
-		ioc_err(mrioc, "%s : Unrecoverable controller\n", __func__);
+		ioc_err(mrioc, "%ps %s error: Unrecoverable controller\n",
+				 __builtin_return_address(0),
+				 __func__);
 		return -EFAULT;
 	}
 
@@ -1230,12 +1232,16 @@ int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 	max_entries = mrioc->num_admin_req;
 	if ((areq_ci == (areq_pi + 1)) || ((!areq_ci) &&
 	    (areq_pi == (max_entries - 1)))) {
-		ioc_err(mrioc, "AdminReqQ full condition detected\n");
+		ioc_err(mrioc, "%ps %s error: AdminReqQ full\n",
+				 __builtin_return_address(0),
+				 __func__);
 		retval = -EAGAIN;
 		goto out;
 	}
 	if (!ignore_reset && mrioc->reset_in_progress) {
-		ioc_err(mrioc, "AdminReqQ submit reset in progress\n");
+		ioc_err(mrioc, "%ps %s error: AdminReqQ reset in progress\n",
+				 __builtin_return_address(0),
+				 __func__);
 		retval = -EAGAIN;
 		goto out;
 	}
@@ -2384,7 +2390,7 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.max_vds = le16_to_cpu(facts_data->max_vds);
 	mrioc->facts.max_hpds = le16_to_cpu(facts_data->max_host_pds);
 	mrioc->facts.max_advhpds = le16_to_cpu(facts_data->max_adv_host_pds);
-	mrioc->facts.max_raidpds = le16_to_cpu(facts_data->max_raid_pds);
+	mrioc->facts.max_raid_pds = le16_to_cpu(facts_data->max_raid_pds);
 	mrioc->facts.max_nvme = le16_to_cpu(facts_data->max_nvme);
 	mrioc->facts.max_pcie_switches =
 	    le16_to_cpu(facts_data->max_pcie_switches);
@@ -2421,10 +2427,9 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	    mrioc->facts.ioc_num, mrioc->facts.max_op_req_q,
 	    mrioc->facts.max_op_reply_q, mrioc->facts.max_devhandle);
 	ioc_info(mrioc,
-	    "maxreqs(%d), mindh(%d) maxPDs(%d) maxvectors(%d) maxperids(%d)\n",
+	    "maxreqs(%d), mindh(%d) maxvectors(%d) maxperids(%d)\n",
 	    mrioc->facts.max_reqs, mrioc->facts.min_devhandle,
-	    mrioc->facts.max_pds, mrioc->facts.max_msix_vectors,
-	    mrioc->facts.max_perids);
+	    mrioc->facts.max_msix_vectors, mrioc->facts.max_perids);
 	ioc_info(mrioc, "SGEModMask 0x%x SGEModVal 0x%x SGEModShift 0x%x ",
 	    mrioc->facts.sge_mod_mask, mrioc->facts.sge_mod_value,
 	    mrioc->facts.sge_mod_shift);
@@ -2527,7 +2532,7 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 		goto out_failed;
 
 	/* sense buffer pool,  4 byte align */
-	sz = mrioc->num_sense_bufs * MPI3MR_SENSEBUF_SZ;
+	sz = mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ;
 	mrioc->sense_buf_pool = dma_pool_create("sense_buf pool",
 	    &mrioc->pdev->dev, sz, 4, 0);
 	if (!mrioc->sense_buf_pool) {
@@ -2563,10 +2568,10 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	    "reply_free_q pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB), reply_dma(0x%llx)\n",
 	    mrioc->reply_free_q, mrioc->reply_free_qsz, 8, (sz / 1024),
 	    (unsigned long long)mrioc->reply_free_q_dma);
-	sz = mrioc->num_sense_bufs * MPI3MR_SENSEBUF_SZ;
+	sz = mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ;
 	ioc_info(mrioc,
 	    "sense_buf pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB), sense_dma(0x%llx)\n",
-	    mrioc->sense_buf, mrioc->num_sense_bufs, MPI3MR_SENSEBUF_SZ,
+	    mrioc->sense_buf, mrioc->num_sense_bufs, MPI3MR_SENSE_BUF_SZ,
 	    (sz / 1024), (unsigned long long)mrioc->sense_buf_dma);
 	sz = mrioc->sense_buf_q_sz * 8;
 	ioc_info(mrioc,
@@ -2582,7 +2587,7 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 
 	/* initialize Sense Buffer Queue */
 	for (i = 0, phy_addr = mrioc->sense_buf_dma;
-	    i < mrioc->num_sense_bufs; i++, phy_addr += MPI3MR_SENSEBUF_SZ)
+	    i < mrioc->num_sense_bufs; i++, phy_addr += MPI3MR_SENSE_BUF_SZ)
 		mrioc->sense_buf_q[i] = cpu_to_le64(phy_addr);
 	mrioc->sense_buf_q[i] = cpu_to_le64(0);
 	return retval;
@@ -2649,7 +2654,7 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 	iocinit_req.reply_free_queue_depth = cpu_to_le16(mrioc->reply_free_qsz);
 	iocinit_req.reply_free_queue_address =
 	    cpu_to_le64(mrioc->reply_free_q_dma);
-	iocinit_req.sense_buffer_length = cpu_to_le16(MPI3MR_SENSEBUF_SZ);
+	iocinit_req.sense_buffer_length = cpu_to_le16(MPI3MR_SENSE_BUF_SZ);
 	iocinit_req.sense_buffer_free_queue_depth =
 	    cpu_to_le16(mrioc->sense_buf_q_sz);
 	iocinit_req.sense_buffer_free_queue_address =
-- 
2.18.1


--0000000000003186cf05cc85d068
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQcAYJKoZIhvcNAQcCoIIQYTCCEF0CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3HMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
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
XzCCBU8wggQ3oAMCAQICDHA7TgNc55htm2viYDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjU2MDJaFw0yMjA5MTUxMTQ1MTZaMIGQ
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFjAUBgNVBAMTDUthc2h5YXAgRGVzYWkxKTAnBgkqhkiG9w0B
CQEWGmthc2h5YXAuZGVzYWlAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzPAzyHBqFL/1u7ttl86wZrWK3vYcqFH+GBe0laKvAGOuEkaHijHa8iH+9GA8FUv1cdWF
WY3c3BGA+omJGYc4eHLEyKowuLRWvjV3MEjGBG7NIVoIaTkH4R+6Xs1P4/9EmUA0WI881B3pTv5W
nHG54/aqGUDSRDyWVhK7TLqJQkkiYKB0kH0GkB/UfmU/pmCaV68w5J6l4vz/TG23hWJmTg1lW5mu
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPp3PgyzdcD0xf02q+qA9UjOWkxX
3NmrBWcgJVUqmdaRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDkyMTE4NDYxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBFLrY4QZDwTcEN1UtgTWxd4xOmnNrl3jTwhh1NsIEG19Gs
BicSMiujmhpmDwArfaEd7P1JNigaAFT+DTCQOuonx4r6WEyW9mHGSNqEhHrxTF5OEMv5K51H8OKi
jATyQTuQsEwJsOLNK5A6NhQ1Gwt7i7Xfh+1x1e9qTTZLKoVhlbKnYAJFcQCsZljGuUqH9C3Zj0ny
pyKjQejOU9/Govi7NGwfW5+ImZKwrZSscDJguF7TEdEBzcAecgwqSmiW6hA7S52zyopj/cYXdkh1
FnOtYckVLKA1n+DpZiU5A7zFYc3U2sSi8KzWR2pULCyt8LnOxtyfZ3Kq/3PFVd/8/gU7
--0000000000003186cf05cc85d068--
