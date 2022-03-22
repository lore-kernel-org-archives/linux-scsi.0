Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE155C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 12:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbiCVMXo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbiCVMXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 08:23:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D78594F
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 05:22:05 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so1994751pjl.4
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 05:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=yMtSbVWU3mjUEszQbVhbuP+4Rh097vOncCiKrLGAha8=;
        b=YIG4r2hA7jt8Arf5aQ1svR4Z26IQdvvximHcRkSkAd8Q6UBwszkZsvSeO876WoLTLJ
         sg6ef/N+O0NkcU60CNwEfCN9ORoeeV5C9w/UxrcHV2tvlQ5XWP/MORczWzJ/u4mYk8Y3
         1Yx66sL6atq32a5teIK2VIkPiCXTQ/kfRs4uQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=yMtSbVWU3mjUEszQbVhbuP+4Rh097vOncCiKrLGAha8=;
        b=cFDKonchYDuBN7DOsf+2F2ULAAt6wZp716cnqm+GBBvLEJKWnoebbWzMA7KPWbL5Vv
         mja/lPnP/jPZA+Een0lwaPcDeu8qya5SipR3ofzriXaynGlYQfTwswr7jGgzYMJ7KqyV
         Z7EIX4xPuQYi8L44XcBvhZHQbUde5Umj0BY5vL+c2UWejoZqlUlAQIKE1BMkYKK51lfJ
         qxf96mHyel9Ny/Rzx61J/ki6O7dvrMs9qvAh790X1MbjkSiHNqTU1f6guhJdDPnioJGP
         mbBcWfpdbuCWfHgSIfViXS12/mbuhZkJHSwcCKnJH8hvJNpz1aI4V9YbHL9nKt7OmNHU
         rOkg==
X-Gm-Message-State: AOAM530/nfnAcrrn5t0ZFwo7IBUnMnkMrvF3auF0M/z9bc45UIzI7RKV
        EgcXdczBls0/cOzgwHt4OaYSASpaqCYzHQqEsQwacNt3pPXAnhe4AtSx5Zy+NPC+m5pWj97aJl4
        vRti4VbjNrQTvCigt/3VHo22OOIx20pODTdvvkFyOyHREZM9OYawR3rnIQc8cyVL4lVRCk/6GqX
        r4uQ6qpg49Eg==
X-Google-Smtp-Source: ABdhPJzZzcMt2vE8UwiATN63pUwEqx1dMdhdaVHBe6UgjFDDJ0w4RTYLk0xn8nRc9pRSjOlS9kBUMA==
X-Received: by 2002:a17:90b:38d2:b0:1c6:fa94:96bb with SMTP id nn18-20020a17090b38d200b001c6fa9496bbmr4760680pjb.206.1647951724421;
        Tue, 22 Mar 2022 05:22:04 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a0010cb00b004e1b76b09c0sm23225259pfu.74.2022.03.22.05.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:22:03 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 5/7] mpi3mr: expose adapter state to sysfs
Date:   Tue, 22 Mar 2022 08:21:05 -0400
Message-Id: <20220322122107.8482-6-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220322122107.8482-1-sumit.saxena@broadcom.com>
References: <20220322122107.8482-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002b2b4805dacda9f9"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002b2b4805dacda9f9
Content-Transfer-Encoding: 8bit

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 46 ++++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  1 +
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 10c074c1eea6..5a1b2d9b64da 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1022,5 +1022,5 @@ int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
 void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
-
+extern const struct attribute_group *mpi3mr_host_groups[];
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index aa95bff5412a..da3c7835ada4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1220,3 +1220,49 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 err_device_add:
 	kfree(mrioc->bsg_dev);
 }
+
+/**
+ * adapter_state_show - SysFS callback for adapter state show
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying adapter state
+ */
+static ssize_t
+adp_state_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	enum mpi3mr_iocstate ioc_state;
+	uint8_t adp_state;
+
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
+		adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
+	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
+		adp_state = MPI3MR_BSG_ADPSTATE_IN_RESET;
+	else if (ioc_state == MRIOC_STATE_FAULT)
+		adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
+	else
+		adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", adp_state);
+}
+
+static DEVICE_ATTR_RO(adp_state);
+
+static struct attribute *mpi3mr_host_attrs[] = {
+	&dev_attr_adp_state.attr,
+	NULL,
+};
+
+static const struct attribute_group mpi3mr_host_attr_group = {
+	.attrs = mpi3mr_host_attrs
+};
+
+const struct attribute_group *mpi3mr_host_groups[] = {
+	&mpi3mr_host_attr_group,
+	NULL,
+};
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 19298136edb6..89a4918c4a9e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4134,6 +4134,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
 	.max_segment_size		= 0xffffffff,
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct scmd_priv),
+	.shost_groups			= mpi3mr_host_groups,
 };
 
 /**
-- 
2.27.0


--0000000000002b2b4805dacda9f9
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFycPYD8krzRlR7/kLHGV3qPc+riWnhR
Y4/JAOsBlg5NMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MjEyMjIwNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBtGaaH6vmKh5jrmwKCtXrQ62v1JUNTR6OPMRJ/F77hqZCVr/7o
Q7dhR/fW650COVQQBrO9dCXweQSaw7MKCTHxpu62PGMvD5EKvlqJ1MkWR6QycNMKLKaS8ikOOUZp
XAigUJW8nyShOAqhUA2yxTPyX+b7dkdageHDQiWGuN4/M84YUg/uoGIx4RkNaex1eG7hAtbYXpms
BahQN6SQ6Zz2Mzug6M9MH5httWdd6uQMVtZMmexb+tVK9hCNHNdrLu02oIwdQ8FZ5o1It06vI+qk
Ig5IcUHI5spiZ/yHsFfry6WyRl0xXGpGlour0KRt+09MhtEDnhdUv8UqNmJBZhoI
--0000000000002b2b4805dacda9f9--
