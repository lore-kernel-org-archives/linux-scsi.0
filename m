Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC26C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 13:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D2B64EA2
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 13:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhBANST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhBANRj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 08:17:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF79C06178C
        for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2021 05:16:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e9so10908916pjj.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Feb 2021 05:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kEfaHvb22cBHOFzHkDkzr6FYclDR4ti3FncQ6m3O4Og=;
        b=XvNEGUbdCVFT+CgSbRxzdz4a3JC8M0aCJUqOu7zFmiThgei1UXSeBrZNK9cuYCrctM
         n5J5OKDEnDQ/X29Ge6JvLmJ2mOIdPhqAlWvIiOkTpP4Z1KP4UJORJKSe5OFHN08pKDf1
         AX40HiCx3Xw6Gi/9pzhdk3mYVFZMczV++Gb9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kEfaHvb22cBHOFzHkDkzr6FYclDR4ti3FncQ6m3O4Og=;
        b=RrbSxGxKkke7Ai63NJ9SEuO42oWx90M4PMHN0eC0Sj/kYHw555ID5/x6qBAz+72Epm
         6otgMaSeJ5DZRKPNEe6m97dcLuu9A8bzGStOh3DcZlR7rotfAUPWaKKz/0vN35X7++sk
         RD1IFw+jlEaUfivgugEwp6IzIa4IU+qMe2b9CxmZII1nyo4ELQ2+m1f2XUO8YOh4WlrI
         mZ1CFeBmlo7Oqmby60GlixrPKwsi24ln+SBstdWpuYtehGdoW4MwZ/jzhqP1Mo9wxfoi
         R81V6bFDcEjyDSv2XM/NeMlkfWjcTHJtc7Q9OK9+SUqgPhlAaML2scIwFkVXKYm4xX77
         hD2w==
X-Gm-Message-State: AOAM532Bdlay7lw0Qc16YFBuXzLiRO++2IP5MmFi90kUbn5B5isL/s6t
        N2jJhKZL6+P/OthfdfhLOhsDkuaHMysnQKiESF/ISn/zJuaZ2LcPjtu77E104pX73YJenBiVavk
        Y5u1v2Oda6hGCnfrrbS57lUcOIfNT4rbWJyIxk/D7SXUsYnnEvUm2eHcvHwS4/KDUddbrf/8nTK
        6URWPts6JV
X-Google-Smtp-Source: ABdhPJzM1G6J22zBh4nkIUYmdL5kxIgC9UNNKzG/2KLZapO9+jWSEmEVst9yOHADO84ohbOrXaBLmw==
X-Received: by 2002:a17:90a:8e82:: with SMTP id f2mr17126080pjo.234.1612185377779;
        Mon, 01 Feb 2021 05:16:17 -0800 (PST)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h2sm18573898pfk.4.2021.02.01.05.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 05:16:17 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 4/4] scsi: set shost as hctx driver_data
Date:   Mon,  1 Feb 2021 10:46:19 +0530
Message-Id: <20210201051619.19909-5-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210201051619.19909-1-kashyap.desai@broadcom.com>
References: <20210201051619.19909-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c7765505ba46285e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c7765505ba46285e

hctx->driver_data is not set for SCSI currently.
Separately set hctx->driver_data = shost.

Suggested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/scsi_lib.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8c29bf0e4cfd..f661c50f3b88 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1792,9 +1792,7 @@ static void scsi_mq_exit_request(struct blk_mq_tag_set *set, struct request *rq,
 
 static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
 {
-	struct request_queue *q = hctx->queue;
-	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
+	struct Scsi_Host *shost = hctx->driver_data;
 
 	if (shost->hostt->mq_poll)
 		return shost->hostt->mq_poll(shost, hctx->queue_num);
@@ -1802,6 +1800,15 @@ static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
 	return 0;
 }
 
+static int scsi_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			  unsigned int hctx_idx)
+{
+	struct Scsi_Host *shost = data;
+
+	hctx->driver_data = shost;
+	return 0;
+}
+
 static int scsi_map_queues(struct blk_mq_tag_set *set)
 {
 	struct Scsi_Host *shost = container_of(set, struct Scsi_Host, tag_set);
@@ -1869,15 +1876,14 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit = {
 	.cleanup_rq	= scsi_cleanup_rq,
 	.busy		= scsi_mq_lld_busy,
 	.map_queues	= scsi_map_queues,
+	.init_hctx	= scsi_init_hctx,
 	.poll		= scsi_mq_poll,
 };
 
 
 static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
 {
-	struct request_queue *q = hctx->queue;
-	struct scsi_device *sdev = q->queuedata;
-	struct Scsi_Host *shost = sdev->host;
+	struct Scsi_Host *shost = hctx->driver_data;
 
 	shost->hostt->commit_rqs(shost, hctx->queue_num);
 }
@@ -1898,6 +1904,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.cleanup_rq	= scsi_cleanup_rq,
 	.busy		= scsi_mq_lld_busy,
 	.map_queues	= scsi_map_queues,
+	.init_hctx	= scsi_init_hctx,
 	.poll		= scsi_mq_poll,
 };
 
-- 
2.18.1


--000000000000c7765505ba46285e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgw4CRQBdg
ORj8jCNSKdZtXtudlYwNDSwscohmmm8htWAwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjAxMTMxNjE4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAIVkbfQ+qFUstLZnewoWEB3kTBcx
USukhH2/OR8+QSEd4Kjd8KYRnlNJXywsSfLDDgAqVM2OZKFqb0Mqi9x1TjK61vIVJYHis4QadUed
Lkb5kcHZnYQcRwkPk4n6BAgMGfKyrC9zYseRYNY50nTGx5eS7xmhr5QxmRXz67gMnKMkL+whwsn9
MeDlXHcF2YJRMa6lvUhy1wEX1SVraw1Nx0zg13EfrdkZCuKcw1jL+BiPmTN564ZKSRZ7gCxAcVt1
OEG1kmj35HhVUsuZLmZ/CcK3g/3tXgvxk/qfkReJ/TGXiCxxK9z2DaDMuOuz+Xm0FJ2xNjQXSDsM
CUFFx/lj/VI=
--000000000000c7765505ba46285e--
