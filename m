Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D51FC433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 481A2613BD
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbhDGCFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344092AbhDGCEz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:04:55 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DCFC061761
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:04:46 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i190so3527431pfc.12
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y6z8aufsla+hKg2nW42CBLcDpw5T7OHsBk2CpQQWgdY=;
        b=Qg9+bsxTlm8roJWDruRUCy/3u+WEaakMk6nTXygLToOaaiBxsIV8UMW9PDQBPjGWwo
         T1d+2PwZSzbTUMnF1PMndjESmhC4VzyCMCeuYhMTU8stx/vsSVKGfJcjqvAv/glmkkoW
         whQgJ1TJTFpHxgQ84z7zrClKyt0Ls/qOodsdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y6z8aufsla+hKg2nW42CBLcDpw5T7OHsBk2CpQQWgdY=;
        b=BHdQu1HnbC5dIKPD2MzfnFJWrySxxA/RmPav8e0x5/nWfwlM6o1+FATrNqXc4gEVQj
         zz2cZ2eNLbQcnzvpfNre5yA/NqWrAQHZcCepKW+78Jdu6Oa33Hjb6kEi+BJSIGJ03nfn
         PNCElYhF9SQHRnpvzk2NR/Jv8/4TOvXP+1xFjG4lkOk294IJIGE6ccsJKkFRHKBNSN98
         6k9hwJvIweWsvMmUu8nJ28vK62ZkC07xA+fT7H/QaXE5PPzEbb7m4SySBRgBi6Sq8oYm
         ZTvb+cLxMWod9qeJC5Ri3mpddgqjxROUNzAUY1dlxTD34URJfsxhTDUdGKFlS+ss7qce
         gEIw==
X-Gm-Message-State: AOAM532JTB+EhBMRQD/FPCKslWLjp2kShaSmSqQ3hPqr43WmcPgT6/Jt
        uad56M1kZghs+iRVb5NWkSSETvCrZu1+f9s7ji9VU4eFIHThbhvlGZvj90a9rwhKdoRlq2gKOl9
        aUPRi8smPSukRU6UNJBVnJgoR8LZKsIvwUNzg4GqXk2VvVsBnF2yQonppMqQOSq+HOUmKTb6rtD
        +5JFc6PQ==
X-Google-Smtp-Source: ABdhPJx3WDSYRv1ZnfUOlCBoqz6EKR9HI/UEmL9ifvlIabIDEgNN4vWtr5rUne+HUmgFCeSRXplAjQ==
X-Received: by 2002:a62:384a:0:b029:23d:607e:ac30 with SMTP id f71-20020a62384a0000b029023d607eac30mr847889pfa.14.1617761085968;
        Tue, 06 Apr 2021 19:04:45 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:04:45 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 14/24] mpi3mr: add change queue depth support
Date:   Wed,  7 Apr 2021 07:34:41 +0530
Message-Id: <20210407020451.924822-15-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e4766405bf585a3d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e4766405bf585a3d

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 35 ++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index fe6c815b918a..e3ce54f877fa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -141,6 +141,9 @@ extern struct list_head mrioc_list;
 /* Command retry count definitions */
 #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
 
+/* Default target device queue depth */
+#define MPI3MR_DEFAULT_SDEV_QD	32
+
 /* SGE Flag definition */
 #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a219e341ffb6..a521e59efd28 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -648,6 +648,34 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_change_queue_depth- Change QD callback handler
+ * @sdev: SCSI device reference
+ * @q_depth: Queue depth
+ *
+ * Validate and limit QD and call scsi_change_queue_depth.
+ *
+ * Return: return value of scsi_change_queue_depth
+ */
+static int mpi3mr_change_queue_depth(struct scsi_device *sdev,
+	int q_depth)
+{
+	struct scsi_target *starget = scsi_target(sdev);
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	int retval = 0;
+
+	if (!sdev->tagged_supported)
+		q_depth = 1;
+	if (q_depth > shost->can_queue)
+		q_depth = shost->can_queue;
+	else if (!q_depth)
+		q_depth = MPI3MR_DEFAULT_SDEV_QD;
+	retval = scsi_change_queue_depth(sdev, q_depth);
+
+	return retval;
+}
+
+
 /**
  * mpi3mr_update_sdev - Update SCSI device information
  * @sdev: SCSI device reference
@@ -668,6 +696,7 @@ mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
 	if (!tgtdev)
 		return;
 
+	mpi3mr_change_queue_depth(sdev, tgtdev->q_depth);
 	switch (tgtdev->dev_type) {
 	case MPI3_DEVICE_DEVFORM_PCIE:
 		/*The block layer hw sector size = 512*/
@@ -2726,9 +2755,12 @@ static int mpi3mr_slave_configure(struct scsi_device *sdev)
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
-	if (!tgt_dev)
+	if (!tgt_dev) {
+		mpi3mr_change_queue_depth(sdev, MPI3MR_DEFAULT_SDEV_QD);
 		return retval;
+	}
 
+	mpi3mr_change_queue_depth(sdev, tgt_dev->q_depth);
 	switch (tgt_dev->dev_type) {
 	case MPI3_DEVICE_DEVFORM_PCIE:
 		/*The block layer hw sector size = 512*/
@@ -2968,6 +3000,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
 	.slave_destroy			= mpi3mr_slave_destroy,
 	.scan_finished			= mpi3mr_scan_finished,
 	.scan_start			= mpi3mr_scan_start,
+	.change_queue_depth		= mpi3mr_change_queue_depth,
 	.eh_abort_handler		= mpi3mr_eh_abort,
 	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
 	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
-- 
2.18.1


--000000000000e4766405bf585a3d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGtslCD9/xBnJQQMq30/iTK2sDpn
YpUZpY3TMh2MiTQMMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDQ0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBVE192Y3mrq4IesMiNEGwrGSwKzvn1NPUJcjcmvYBkAGKb
r51AHvPj4wcDTKRwCK8WQOwOgDZLW+/ZOxS0CT/ul1ETRgfcxWTPv/4BOBvH6ZWwLgdx0p+rlm+k
gONgqjpYumKpZ1WTbyBF+jIm2gy+wqZeqthKrkkPKvM30St9FQjY2fuaAchtJZvn8kvP/fkbZMzq
ohC8wjFo/yZnnSJG4ksRaJKbjD2qmKYejJ1JVCA7frQZ6jHrPI8KhT8fgP5GAB8gZvZI7n0vz5vW
9aNMtcmkzAAVc4xH9cQINzMn9/RuMSjG0+DENFK7Dkw88OKnjYp2TvBzKA/kzV/bKDpz
--000000000000e4766405bf585a3d--
