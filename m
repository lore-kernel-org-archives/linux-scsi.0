Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120B9C388F9
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 13:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDFF20936
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 13:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LXzH5mEV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgKENDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 08:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKENDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 08:03:23 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C9CC0613CF
        for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2020 05:03:23 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id y7so390912pfq.11
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2020 05:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cu07e8/kT3mYvc0P5Yz/ZPTYuhP+CdMddVbnC1aSZ9Q=;
        b=LXzH5mEVcjRUu+AkGSW65W01UqMjRWdDmFyewIy1vISVq2djvMF7XEbE+Foc7dwRl6
         1Q/AgZTnkTRCFzXJXKmV7Mj9JO5VDPDKFXNPBYnK64Vv+AYHOGir1t9RGDRIkP7/0fIB
         0oNlBHMgm7sWmuulgoCWdsRduJiLslM+QYhk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cu07e8/kT3mYvc0P5Yz/ZPTYuhP+CdMddVbnC1aSZ9Q=;
        b=Ayp3JLQSJDO4eNM2SFQNbjYJI14G7FwpW6NUey9ILA1bpFE231tvsXPif9CNHHiY2i
         C7RCUjPeTwTo6p4URrBDLDcDlcW1uAUpwB6H0ir6+/CEmBJuC4BZrSBC3TfRBLMRRHyj
         BNyhLwfwlPYRT3R8u5wmNXW1IHciuTDcgJyUnpvnyG4x2eWsG5jwd+czhscpow0z0B+F
         g3LIdRnZ6E99jViF5r/6lIwlIu0XxWBLH4+bROJKZazhhMFoqg/7zNz2wbya4kqEjBX5
         ae27I6tLoFuv8urcA5OvW8hPoHFTpUlN63Kl+3UaMPNIddwpSoTCKYYitrISW6BoxvMy
         P8QA==
X-Gm-Message-State: AOAM532Uf+Sw1ZTpSSE7s5TgiaZimgBhXX+Ydt5heTyvxXRvhUnVsdoV
        TLm7LuVm3K6fKZCUWr2VgWIFpJP99A/8C1AYHJxVWjv7/m0vVoaUUSXQRd/QTTU5WUyHs/E8pIc
        7tsA3MbmngqAst5AEd95DGgqvThtrA7nmHvr8LVpfJWYufgIjOxquLe2vnrHdjwAJ7Lq3uLZFdC
        Kx6d/Z+28/X/U=
X-Google-Smtp-Source: ABdhPJyQD4EIINIAM0eipa9q1q/nfMyxw9Mj2hPo/PPKwzkzIFLkAb0UTHbMyUUVpNaETMiFd+XgAQ==
X-Received: by 2002:a62:f846:0:b029:15f:f897:7647 with SMTP id c6-20020a62f8460000b029015ff8977647mr2496415pfm.75.1604581402662;
        Thu, 05 Nov 2020 05:03:22 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y141sm2491319pfb.17.2020.11.05.05.03.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 05:03:22 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v6 2/4] scsi: No retries on abort success
Date:   Thu,  5 Nov 2020 11:39:54 +0530
Message-Id: <1604556596-27228-3-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604556596-27228-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1604556596-27228-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008b948805b35bb88d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008b948805b35bb88d

Made an additional check in scsi_noretry_cmd to verify whether user has
decided not to do retries on abort success by checking the
SCMD_NORETRIES_ABORT bit

If SCMD_NORETRIES_ABORT bit is set we are making sure there won't be any
retries done on the same path and also setting the host byte as
DID_TRANSPORT_MARGINAL so that the error can be propogated as recoverable
transport error to the blk layers.

Added a new error code DID_TRANSPORT_MARGINAL to handle marginal
errors in scsi.h

Added a code in scsi_result_to_blk_status to translate
a new error DID_TRANSPORT_MARGINAL to the corresponding blk_status_t
i.e BLK_STS_TRANSPORT

Added DID_TRANSPORT_MARGINAL case to scsi_decide_disposition

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v6:
Rearranged the patch by merging second hunk of the patch2 in v5
to this patch

v5:
added the DID_TRANSPORT_MARGINAL case to
scsi_decide_disposition

v4:
Modified the comments in the code appropriately

v3:
Merged  first part of the previous patch(v2 patch3) with
this patch.

v2:
set the hostbyte as DID_TRANSPORT_MARGINAL instead of
DID_TRANSPORT_FAILFAST.
---
 drivers/scsi/scsi_error.c | 17 +++++++++++++++++
 drivers/scsi/scsi_lib.c   |  1 +
 include/scsi/scsi.h       |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ae80daa5d831..02dfd70219b2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1763,6 +1763,16 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return 0;
 
 check_type:
+	/*
+	 * Check whether caller has decided not to do retries on
+	 * abort success by checking the SCMD_NORETRIES_ABORT bit
+	 */
+	if ((test_bit(SCMD_NORETRIES_ABORT, &scmd->state)) &&
+		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
+		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
+		return 1;
+	}
+
 	/*
 	 * assume caller has checked sense and determined
 	 * the check condition was retryable.
@@ -1861,6 +1871,13 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 * the fast io fail tmo fired), so send IO directly upwards.
 		 */
 		return SUCCESS;
+
+	case DID_TRANSPORT_MARGINAL:
+		/*
+		 * caller has decided not to do retries on
+		 * abort success, so send IO directly upwards.
+		 */
+		return SUCCESS;
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
 		    status_byte(scmd->result) == RESERVATION_CONFLICT)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2b5dea07498e..9606bad1542f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -629,6 +629,7 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 			return BLK_STS_OK;
 		return BLK_STS_IOERR;
 	case DID_TRANSPORT_FAILFAST:
+	case DID_TRANSPORT_MARGINAL:
 		return BLK_STS_TRANSPORT;
 	case DID_TARGET_FAILURE:
 		set_host_byte(cmd, DID_OK);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5339baadc082..5b287ad8b727 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -159,6 +159,7 @@ static inline int scsi_is_wlun(u64 lun)
 				 * paths might yield different results */
 #define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
 #define DID_MEDIUM_ERROR  0x13  /* Medium error */
+#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
-- 
2.26.2


--0000000000008b948805b35bb88d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
J/4V6ms/nIUi+/4vPYjckYUbRzkXm1/X0IyUfpp5cgdrFn9jBIk69fQGAUEhnVvwcXnHWotYxZFd
Xew5Fz0CAwEAAaOCAdMwggHPMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMG
A1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFGlygmIxZ5VEhXeRgMQENkmdewthMB0GA1Ud
DgQWBBR6On9cEmlB2VsuST951zNMSKtFBzANBgkqhkiG9w0BAQsFAAOCAQEAOGDBLQ17Ge8BVULh
hsKhgh5eDx0mNmRRdhvTJnxOTRX5QsOKvsJGOUbyrKjD3BTTcGmIUti9HmbqDe/3gRTbhu8LA508
LbMkW5lUoTb8ycBNOKLYhNE8UEOY8jRTUtMEhzT6NJDEE+1hb3kSGfArrrF3Z8pRYiUUhcpC5GKL
9KsxA+DECRfSGfXJJQSq6nEZUGKhz+dz5CV1s8UIZLe9HEEfyJO4eRP+Fw9X16cthAbY0kpVnAvT
/j45FAauY/h87uphdvSb5wC9v5w4VO0JKs0yNUjyWXg/RG+6JCvcViLFLAlRCLrcRcVaQwWZQ3YB
EpmWnHflnrBcah5Ozy137DGCAm8wggJrAgEBMG0wXTELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
b2JhbFNpZ24gbnYtc2ExMzAxBgNVBAMTKkdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDIgQ0EgLSBT
SEEyNTYgLSBHMwIMX/krgFDQUQNyOf+1MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEi
BCDAIk7hThN4CFilHhYq7K6/xAxqie2zrr6nBbQHVDZ5ujAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDUxMzAzMjNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAwDoVYHFzNXOvD3md
pw/QiKh+I3gBeFwGzv4fq9pzSQJC+L1r8HIkuUDxGE2S4mhAQSD+Evg1a4zPRd5Xy4zu9Dvx/qC5
jMMeTMjIr2tY8DH7hJfnP6Td6r057Q+7SG3g97Idbbr9WHF4oY1pomdFk3bEUVyPXJvoKlxKWU8d
4SNcPa3/NSS/CgI8EqLjPD/Ks4KPp6gqoJ/T8ruPLpE/Qy7mZDzcM9Zql70cWIuf1Uj5T4ws/H3/
dnqlMxkWNxQvKKg6G/QkJSih+BYrHVyldG38OQmvNTNo/XWApE2QDV6xCHVnYjHuz0KNZYGwbG9K
+vZn7QElG/ys9JqcOrxedg==
--0000000000008b948805b35bb88d--
