Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D44C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbiHDNAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiHDNAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:23 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E6360EF
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w10so19282905plq.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=vcxUkdyWlyZwNFk5sab4zShn9rXehvCFtuQJGZ9wRp4=;
        b=C3Vl7ZXTb1eITHr9kNZPwFJiKcKxZ9JEDsalBwJ2fIIg1KiiJseRkg+i/sl/PodSJL
         0Jk39myPFuF89Gp1K1urndKyu7hISx//LEI9ov/0GXlKZiGC0IA1bOop85a9Aq34gQlI
         u/NfttzZVDEGkOjmWqSK1BDKMvdv2sKbZewBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=vcxUkdyWlyZwNFk5sab4zShn9rXehvCFtuQJGZ9wRp4=;
        b=2tZMRN+eyRIN2hELZmRtDVsPfEzUgULEUEO1tt8HPvkxw1/bjrhFfxpKi5De55VMzK
         14ojMZifariTw2mkbkQEsIiWjBAhQ/5X9D2BjL8RktUS7dWi//qTqd7PUyJr9wPyrijB
         Rrsh2Jlvvs9mxRJWTFUwxoahoX4JWvWcQBDPF0d+8sdRwQVfu4hOYJcW7xvH0FCYuU8i
         KcQRIeyfgjww/jmzue7eouO8AfFABxW1xwj4fRFC5oQ+LkZQWHKFzIZm9FCv+Zw0URmg
         /3wp4QW/QhfW+f2qNuPBd7NCJPxMmzt4OjWS8hkw7iEbw9HGZIKsfYLNN6T72YIldLgY
         Tt2Q==
X-Gm-Message-State: ACgBeo0uz8MDfi6WFzRXS8YbXBkcAlki2mWCOYl26lkcQduB/klr9hf8
        8p8DP+MVLhOm8//7zt2bNakAXAasIi8l8E5eq6H2QkdjqKVCA3Je5wNOoalIjoTiAY+jsQ7+N0U
        cW6eP1JbEC8f6PpPk5CJi7zp105rzO3cvWqPPn5d98icMnGbor1L016EIe4ODKcHVhWvjILIqTK
        diGdLC0whV
X-Google-Smtp-Source: AA6agR7Sy4KHQxE2Zji4B6EH5x2SXRrkvuNGi064vBBC7t0XTMOkLihvHZZRkntYMlzM+WJFHqAoqg==
X-Received: by 2002:a17:90a:fe92:b0:1f5:1b0b:1cd7 with SMTP id co18-20020a17090afe9200b001f51b0b1cd7mr1993104pjb.197.1659618020355;
        Thu, 04 Aug 2022 06:00:20 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:19 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 01/15] mpi3mr: Add config and transport related debug flags
Date:   Thu,  4 Aug 2022 18:42:12 +0530
Message-Id: <20220804131226.16653-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a59b6605e569ee74"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a59b6605e569ee74
Content-Transfer-Encoding: 8bit

Add config and transport request related error & info debug
flags and functions.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_debug.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi3mr_debug.h
index 2464c40..ee6edd8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
+++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
@@ -23,9 +23,13 @@
 #define MPI3_DEBUG_RESET		0x00000020
 #define MPI3_DEBUG_SCSI_ERROR		0x00000040
 #define MPI3_DEBUG_REPLY		0x00000080
+#define MPI3_DEBUG_CFG_ERROR		0x00000100
+#define MPI3_DEBUG_TRANSPORT_ERROR	0x00000200
 #define MPI3_DEBUG_BSG_ERROR		0x00008000
 #define MPI3_DEBUG_BSG_INFO		0x00010000
 #define MPI3_DEBUG_SCSI_INFO		0x00020000
+#define MPI3_DEBUG_CFG_INFO		0x00040000
+#define MPI3_DEBUG_TRANSPORT_INFO	0x00080000
 #define MPI3_DEBUG			0x01000000
 #define MPI3_DEBUG_SG			0x02000000
 
@@ -122,6 +126,29 @@
 			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
 	} while (0)
 
+#define dprint_cfg_info(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_CFG_INFO) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_cfg_err(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_CFG_ERROR) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+#define dprint_transport_info(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
+#define dprint_transport_err(ioc, fmt, ...) \
+	do { \
+		if (ioc->logging_level & MPI3_DEBUG_TRANSPORT_ERROR) \
+			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
+	} while (0)
+
 #endif /* MPT3SAS_DEBUG_H_INCLUDED */
 
 /**
-- 
2.27.0


--000000000000a59b6605e569ee74
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJZaF+N7iMkISnfoR4C4
7w7xKBgfNcRVj/uQThq2kAAhMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDAyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBeNlyWXpnLOFghV0UXBgQl1UlsyEuSLZVR1RFk
8ydz8+K3qQjkwb3RG0STyzRgPWDw5amaocYns1w4nN+uFxAjNDHIIYL1of/FN4y7vLqV/KmSdR1c
dZYrVY5EvTFV72tOgyx2rm+5kIrc/7isnrExXMlFIxvvnUMSGLJKGYSNIwAht64nLwY/tUiv8VGu
rhtuq3rjtrZpwRZncgzq9vX7fn0ANj/elv0yMQsYQFXcwjeOEsgItJZQRgtObTzMmycsNitcJwSL
a+oGaE0jlQbjhQz2IbpjICL64NZ70JYNqvl7nRKW+9PPH0vd21F2RwovvAFzCnAwT+8L5XBQ77u7
--000000000000a59b6605e569ee74--
