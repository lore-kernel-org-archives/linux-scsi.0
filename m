Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613AFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 26 May 2022 17:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347040AbiEZRCW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 May 2022 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241138AbiEZRCV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 May 2022 13:02:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D8E2CDF8
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2022 10:02:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id qe5-20020a17090b4f8500b001e26126abccso810700pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2022 10:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=yJDq5hM8f418dXRMEODCQdwy1k0fWBpn+oMHS+HGiJA=;
        b=Syh+u0gY/qzqI6nVkehrPEROhrLxKONHGGkcsgLiWEqbhoIXZ1W+HW3Fg/PJWIM4JR
         uk6H6Za74t81bOH/OElk2t9P3/ymTilGuDFHjkqn2kCXSHCo/ak+E+MTNSwtVJ94i2lU
         mc2+TsVOn62tV/+E1f03p3UGpuRHwaG7eCSrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=yJDq5hM8f418dXRMEODCQdwy1k0fWBpn+oMHS+HGiJA=;
        b=cyrrunWdzRxkw9dBaXKBg5POJ6ji4L2l+JXQC7bMY8BHuDnI7lOQ9urLuschOPBlm3
         lfcvaRiXZkP7CHvUlCvF4/cXDHkJH0u34mmG4UWHZGC7FZbS6Ejrhs1P3AhiahdILuBi
         OEm7ec3m8RA//U6XrEQ9KZt2x8ShB/ml3naHNoqyhmWWKT52lIAykbW5QDTov10oDn1Z
         UPAlot5lPUayDaG28RKBh5jGtas0ZXmaRSROs3GpWhKfUZDNitykquahPvpleMiN5V5B
         E0TZWQ8VkTFodSfCAXQteTy07xh/w5n0bu2fZnCUKlhrlLzXN24UW47rdITwWKRepUpI
         SsJQ==
X-Gm-Message-State: AOAM532eorVSloAfOZvpl6wgq9IwwnvU1EhQJtEKXCnlQNf9x3KZaNFe
        TN2zVT/EpxxXZ/JapBYxnmXSJv0jl400pYDXbsCN5BDZEoWR7C6wPIPxd0rHwV7oS1iDP4JwYmg
        vysvM3qOVVBZoRPYp6DWDQE38lbV21FBgtPsp9xbg5awGK51dc6I6TH6B8k+DTnzdXoMw6NlWon
        rIy2tCQSI=
X-Google-Smtp-Source: ABdhPJydV9uH2o70DC+vPVj9Z1d7PJ+c8hVgugowehS+BCE+UL1/AbB9K8/3g59bWFmctfFI5yqceA==
X-Received: by 2002:a17:903:40d0:b0:163:62a5:3356 with SMTP id t16-20020a17090340d000b0016362a53356mr7566235pld.146.1653584538885;
        Thu, 26 May 2022 10:02:18 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h4-20020a17090a3d0400b001df5dea7d4bsm3957712pjc.43.2022.05.26.10.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:02:18 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] mpi3mr: rework mrioc->bsg_device model to fix up smatch warnings
Date:   Thu, 26 May 2022 13:01:57 -0400
Message-Id: <20220526170157.58274-1-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000132b3105dfed27c7"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000132b3105dfed27c7
Content-Transfer-Encoding: 8bit

During driver unload, "mrioc->bsg_device" reference count becomes negative.
Also, as reported in [1], driver's bsg_device model had few more 
bugs so reworked it to fix up them.

[1] https://marc.info/?l=linux-scsi&m=165183971411991&w=2

Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 48 +++++++++++++++-----------------
 2 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 01cd01787b0f..0e1cb4aa4ca2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -954,7 +954,7 @@ struct mpi3mr_ioc {
 	u16 active_poll_qcount;
 	u16 requested_poll_qcount;
 
-	struct device *bsg_dev;
+	struct device bsg_dev;
 	struct request_queue *bsg_queue;
 	u8 stop_bsgs;
 	u8 *logdata_buf;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9ab1762468ad..29ed64a572ea 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1487,28 +1487,28 @@ static int mpi3mr_bsg_request(struct bsg_job *job)
  */
 void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc)
 {
+	struct device *bsg_dev = &mrioc->bsg_dev;
 	if (!mrioc->bsg_queue)
 		return;
 
 	bsg_remove_queue(mrioc->bsg_queue);
 	mrioc->bsg_queue = NULL;
 
-	device_del(mrioc->bsg_dev);
-	put_device(mrioc->bsg_dev);
-	kfree(mrioc->bsg_dev);
+	device_del(bsg_dev);
+	put_device(bsg_dev);
 }
 
 /**
  * mpi3mr_bsg_node_release -release bsg device node
  * @dev: bsg device node
  *
- * decrements bsg dev reference count
+ * decrements bsg dev parent reference count
  *
  * Return:Nothing
  */
 static void mpi3mr_bsg_node_release(struct device *dev)
 {
-	put_device(dev);
+	put_device(dev->parent);
 }
 
 /**
@@ -1521,41 +1521,37 @@ static void mpi3mr_bsg_node_release(struct device *dev)
  */
 void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 {
-	mrioc->bsg_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!mrioc->bsg_dev) {
-		ioc_err(mrioc, "bsg device mem allocation failed\n");
-		return;
-	}
+	struct device *bsg_dev = &mrioc->bsg_dev;
+	struct device *parent = &mrioc->shost->shost_gendev;
+
+	device_initialize(bsg_dev);
+
+	bsg_dev->parent = get_device(parent);
+	bsg_dev->release = mpi3mr_bsg_node_release;
 
-	device_initialize(mrioc->bsg_dev);
-	dev_set_name(mrioc->bsg_dev, "mpi3mrctl%u", mrioc->id);
+	dev_set_name(bsg_dev, "mpi3mrctl%u", mrioc->id);
 
-	if (device_add(mrioc->bsg_dev)) {
+	if (device_add(bsg_dev)) {
 		ioc_err(mrioc, "%s: bsg device add failed\n",
-		    dev_name(mrioc->bsg_dev));
-		goto err_device_add;
+		    dev_name(bsg_dev));
+		put_device(bsg_dev);
+		return;
 	}
 
-	mrioc->bsg_dev->release = mpi3mr_bsg_node_release;
-
-	mrioc->bsg_queue = bsg_setup_queue(mrioc->bsg_dev, dev_name(mrioc->bsg_dev),
+	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev),
 			mpi3mr_bsg_request, NULL, 0);
 	if (IS_ERR(mrioc->bsg_queue)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
-		    dev_name(mrioc->bsg_dev));
-		goto err_setup_queue;
+		    dev_name(bsg_dev));
+		device_del(bsg_dev);
+		put_device(bsg_dev);
+		return;
 	}
 
 	blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
 	blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
 
 	return;
-
-err_setup_queue:
-	device_del(mrioc->bsg_dev);
-	put_device(mrioc->bsg_dev);
-err_device_add:
-	kfree(mrioc->bsg_dev);
 }
 
 /**
-- 
2.27.0


--000000000000132b3105dfed27c7
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILVBD+5EGyOtxb1BZNkFA9qX896b8jD8
NJlfho8CUf0JMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDUy
NjE3MDIxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCaMmUmJKbFHLHbQDBJ5OLjON/8p9EKMgANYUFVJw68Ll0VhRAt
dyM+iAcmmsJpg8QED5G6ulgo/QNk7d7o4Rnlj3Rk9KeZF0oZgEUhVoOd8QTDr5brNIGI/vMklAwY
9hsTa3EG0YtqGMC0ctRyR3t4UOvvOIcP876yw5YqqbvmO9vh32KFADRXE84OeZNCF+/TnKlmlPkn
vBymVG9kVhLXNL9L9VulY7k3QFaCW5tgTbd65et+gxX3qbrWVTXIHPYbWrE2rQSi0JUQGieWlZXz
29psMUBdou75zOtCb3aeaqGm6h8RcwVyXRXG/jl7MjoedjsnQMGcmDpFOqHMbxjC
--000000000000132b3105dfed27c7--
