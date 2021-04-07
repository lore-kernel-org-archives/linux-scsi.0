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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3238EC433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1248A613B8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbhDGCFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343951AbhDGCEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:04:49 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6094C061756
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:04:40 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g10so8537479plt.8
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LCw+mCnirKny0ZbZtTJPKG+lNeivowMF7Homn9kOAds=;
        b=hDvR5FzDWF92HkVk566YBLzcbfVpbvW4KeO8dNjz3DUIBj4jQQIKU2ZIXp+OyB5D0U
         S3IHMxWGcadZUSYsMjzH4f9k0jZfIXFr43AV86V3oVXWwe8r3k8HJSrRrJz0eHxGWR0V
         7D/8FL60A/AWkdQqwrbchTDFTcpCVVEqINY4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LCw+mCnirKny0ZbZtTJPKG+lNeivowMF7Homn9kOAds=;
        b=YaT2P2rPNx0XTZlCpjJxQAeUHR8r3wc7GubsBJ4wkMqlM+AMBZK5f8fPbM7K1USpBB
         oz6HutHrSTI3oJmjcZhe6vfRBTrqhrC+MpZEK9JrtAI890CE3cH6KeqK/CwqDItRpw2E
         rdi4McCTKunZlhjWhtllO+lEKDZFS25kDej/slidvZxUFnQtohqMI4I5V2TYXgqE2XNb
         bb3oe1B4vHEs+TOAQ1KW9U6N1xrepT27PsixrIUU0rJeTrFgQ2aEOHLTR+B7ys55PvbH
         9zOpZQby3qC/jd26fIh/TgnLBXI+Yy27kpfFXEnnVVGowjlBuR9XT6XVLskTGilOYEml
         HOVg==
X-Gm-Message-State: AOAM531EJxxuHoxtlBHLPknFoBWGrGBHiG/PYbliLcgtoapw5mAULSc5
        hCtK7SkYaUXL9Klza1ejpMy/Z4oLEB/mu7/ehUHmu9uR6dLVDSgHw6PD41XibIKSdPcKpmSR8QI
        tVdRkwAxrsrifJ+WJw1Rv2g1ztJ2ohknG7oagAI0+mUGiU082pZV8m/47B2S98jOnNV+maVvKO0
        sRDt0F1w==
X-Google-Smtp-Source: ABdhPJxtTR1ft5yNDksIbWGH94QvOPfLCxKF79aYJXDp/9COHSTPt4b0xZwiVlXcfcnIs7SE7i7Ceg==
X-Received: by 2002:a17:902:e752:b029:e9:5e60:b866 with SMTP id p18-20020a170902e752b02900e95e60b866mr1039383plf.55.1617761079975;
        Tue, 06 Apr 2021 19:04:39 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:04:39 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 11/24] mpi3mr: print ioc info for debugging
Date:   Wed,  7 Apr 2021 07:34:38 +0530
Message-Id: <20210407020451.924822-12-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000874eb905bf585ab8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000874eb905bf585ab8

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 80 +++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d47031d05322..c3882fef2d2a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2550,6 +2550,85 @@ int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
 	return retval;
 }
 
+/* Protocol type to name mapper structure*/
+static const struct {
+	u8 protocol;
+	char *name;
+} mpi3mr_protocols[] = {
+	{ MPI3_IOCFACTS_PROTOCOL_SCSI_INITIATOR, "Initiator" },
+	{ MPI3_IOCFACTS_PROTOCOL_SCSI_TARGET, "Target" },
+	{ MPI3_IOCFACTS_PROTOCOL_NVME, "NVMe attachment" },
+};
+
+/* Capability to name mapper structure*/
+static const struct {
+	u32 capability;
+	char *name;
+} mpi3mr_capabilities[] = {
+	{ MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE, "RAID" },
+};
+
+/**
+ * mpi3mr_print_ioc_info - Display controller information
+ * @mrioc: Adapter instance reference
+ *
+ * Display controller personalit, capability, supported
+ * protocols etc.
+ *
+ * Return: Nothing
+ */
+static void
+mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
+{
+	int i = 0;
+	char personality[16];
+	char protocol[50] = {0};
+	char capabilities[100] = {0};
+	bool is_string_nonempty = false;
+	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
+
+	switch (mrioc->facts.personality) {
+	case MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA:
+		strcpy(personality, "Enhanced HBA");
+		break;
+	case MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR:
+		strcpy(personality, "RAID");
+		break;
+	default:
+		strcpy(personality, "Unknown");
+		break;
+	}
+
+	ioc_info(mrioc, "Running in %s Personality", personality);
+
+	ioc_info(mrioc, "FW Version(%d.%d.%d.%d.%d.%d)\n",
+	fwver->gen_major, fwver->gen_minor, fwver->ph_major,
+	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
+
+	for (i = 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
+		if (mrioc->facts.protocol_flags &
+		    mpi3mr_protocols[i].protocol) {
+			if (is_string_nonempty)
+				strcat(protocol, ",");
+			strcat(protocol, mpi3mr_protocols[i].name);
+			is_string_nonempty = true;
+		}
+	}
+
+	is_string_nonempty = false;
+	for (i = 0; i < ARRAY_SIZE(mpi3mr_capabilities); i++) {
+		if (mrioc->facts.protocol_flags &
+		    mpi3mr_capabilities[i].capability) {
+			if (is_string_nonempty)
+				strcat(capabilities, ",");
+			strcat(capabilities, mpi3mr_capabilities[i].name);
+			is_string_nonempty = true;
+		}
+	}
+
+	ioc_info(mrioc, "Protocol=(%s), Capabilities=(%s)\n",
+	    protocol, capabilities);
+}
 
 /**
  * mpi3mr_cleanup_resources - Free PCI resources
@@ -2808,6 +2887,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 		}
 
 	}
+	mpi3mr_print_ioc_info(mrioc);
 
 	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
 	if (retval) {
-- 
2.18.1


--000000000000874eb905bf585ab8
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOk1oSdxIICsfe9etD5ZdHauJPlF
0WBywRJ9k/VdeDchMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDQ0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAwzBcElzIyf+q5p4mBQqJKwhO9qhlFF2ijNmAWVdXNhMmz
D2tYFawpYETLzfje7YmielCio9ORkSzcZxmQ7Nl3aCA57n7a8A7mBYb+jjm2KTX1AeAV4yDtZPJV
i1UHm9cDyhfRGYseeiBKS8zHraSoLdFnpH2xB/OQCgdo1lo/p68evJZO8tZHNE8RAyMIExtdahz1
du6zcVzfSyXqQp2ERr5ZoLk1lmywKWQfkw7BrtxUO5uq3CwXwWCD18xPEunCjqmW3hr1WucwYNyP
psl3K+l1SC4lGFjms1IA3syaKRSCJxbgxN4PgNthIPVQMRxk/aC3x42FPFJMSEBA0PoZ
--000000000000874eb905bf585ab8--
