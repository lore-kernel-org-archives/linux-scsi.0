Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EC5C43600
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 19:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EACD6600EF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 19:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhEKTw4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 15:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhEKTww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2021 15:52:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671A4C06175F
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 12:51:45 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s20so11334389plr.13
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 12:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YT/RiVit2nIn89/BxUaq5TI3X4qmG5Nqhd6v85HOQb8=;
        b=VzBgrCvpCi4jka7UjZ2+oj323CJsiKcWUICCUTTZZp+ShR9b0se3T6n4U+ITKlMYvk
         M9Cz/cMovl0lDE3cqlqorKOLOTfnMy3isl8/E23CU5PUVW52kgBKJN9dMhC9q723T8ud
         eF+kDn7ok2bg4q7nIKyUt4Hr17sovPjOJOI70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YT/RiVit2nIn89/BxUaq5TI3X4qmG5Nqhd6v85HOQb8=;
        b=NLaHDaRUPkqD5Poysr6Grh23NOebko7+pdg0CYAhI/hgTFLrGNIq2BFhbqqq8L7DzP
         Pq99S5r9IRdLZ5TdCKQb9NTiydFP26q8bEbEVs5Jg90O1hL8pmTojCtqEf3nqgK4oxtf
         8JcdT8fIa5By0kRnop/9SX1c8ON9PX8d2woTh6uSGqYS4urHyXvjQg76bGFRLi1Rj9dE
         wZQL6tKZ7gkv4y2SIep8VzurrBpZ66o9+mKXmmEUrIbdB+xOHdgz9AuAopmckvJcobf5
         gTWdHUb9Ha+paqr95gI4PRudTecYW8X+Dv6iBQeNue8gFWZcfV/h5a8o+fWnFVucpldu
         1Y7w==
X-Gm-Message-State: AOAM531ISrfxBxO51bnMSJO5ed3dqcJdkVBZB0P2ZHtwsg82BEDnPQVz
        AoBI71+d0ydzRmjxBP7BIal7Uj5BvRXm+vLD11+bo4IJCzS25Fx0KcuFOY6dcTXeXzxsFWjfp+z
        DcW9Mu77PTV0M0qoDjpY45BAYpHOp1Pxi2miWKV0rEewG+kxqmivxFPzRQgUSjO8SnPV9myNXxa
        rHJbhOjA==
X-Google-Smtp-Source: ABdhPJwbls5+EXYPOLi2n3mzBuVgoWoLCD5RM6MoI9IIA1EZkkkTZXjXob+VFILzN3bWhWnG5WZ+CA==
X-Received: by 2002:a17:90b:4908:: with SMTP id kr8mr6719491pjb.85.1620762704458;
        Tue, 11 May 2021 12:51:44 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b3sm6317581pfv.61.2021.05.11.12.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 12:51:43 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v4 11/24] mpi3mr: print ioc info for debugging
Date:   Wed, 12 May 2021 01:24:10 +0530
Message-Id: <20210511195423.2134562-12-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210511195423.2134562-1-kashyap.desai@broadcom.com>
References: <20210511195423.2134562-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004b6f4005c21339f6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000004b6f4005c21339f6

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 95 +++++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c |  1 +
 2 files changed, 96 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 3d834615c77b..023b9f6f374b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2534,6 +2534,99 @@ int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
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
+	int i = 0, bytes_wrote = 0;
+	char personality[16];
+	char protocol[50] = {0};
+	char capabilities[100] = {0};
+	bool is_string_nonempty = false;
+	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
+
+	switch (mrioc->facts.personality) {
+	case MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA:
+		strncpy(personality, "Enhanced HBA", sizeof(personality));
+		break;
+	case MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR:
+		strncpy(personality, "RAID", sizeof(personality));
+		break;
+	default:
+		strncpy(personality, "Unknown", sizeof(personality));
+		break;
+	}
+
+	ioc_info(mrioc, "Running in %s Personality", personality);
+
+	ioc_info(mrioc, "FW version(%d.%d.%d.%d.%d.%d)\n",
+	    fwver->gen_major, fwver->gen_minor, fwver->ph_major,
+	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
+
+	for (i = 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
+		if (mrioc->facts.protocol_flags &
+		    mpi3mr_protocols[i].protocol) {
+			if (is_string_nonempty &&
+			    (bytes_wrote < sizeof(protocol)))
+				bytes_wrote += snprintf(protocol + bytes_wrote,
+				    (sizeof(protocol) - bytes_wrote), ",");
+
+			if (bytes_wrote < sizeof(protocol))
+				bytes_wrote += snprintf(protocol + bytes_wrote,
+				    (sizeof(protocol) - bytes_wrote), "%s",
+				    mpi3mr_protocols[i].name);
+			is_string_nonempty = true;
+		}
+	}
+
+	bytes_wrote = 0;
+	is_string_nonempty = false;
+	for (i = 0; i < ARRAY_SIZE(mpi3mr_capabilities); i++) {
+		if (mrioc->facts.protocol_flags &
+		    mpi3mr_capabilities[i].capability) {
+			if (is_string_nonempty &&
+			    (bytes_wrote < sizeof(capabilities)))
+				bytes_wrote += snprintf(capabilities + bytes_wrote,
+				    (sizeof(capabilities) - bytes_wrote), ",");
+
+			if (bytes_wrote < sizeof(capabilities))
+				bytes_wrote += snprintf(capabilities + bytes_wrote,
+				    (sizeof(capabilities) - bytes_wrote), "%s",
+				    mpi3mr_capabilities[i].name);
+			is_string_nonempty = true;
+		}
+	}
+
+	ioc_info(mrioc, "Protocol=(%s), Capabilities=(%s)\n",
+	    protocol, capabilities);
+}
+
 /**
  * mpi3mr_cleanup_resources - Free PCI resources
  * @mrioc: Adapter instance reference
@@ -2792,6 +2885,8 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 		}
 	}
 
+	mpi3mr_print_ioc_info(mrioc);
+
 	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
 	if (retval) {
 		ioc_err(mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5f66926935aa..d7b6f9417aa8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -337,6 +337,7 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc)
  * mpi3mr_flush_scmd - Flush individual SCSI command
  * @rq: Block request
  * @data: Adapter instance reference
+ * @reserved: N/A. Currently not used
  *
  * Return the SCSI command to the upper layers if it is in LLD
  * scope.
-- 
2.18.1


--0000000000004b6f4005c21339f6
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGSfMcG0Ohx04mBhJHJAq4DroV7l
jOQHMVLXkZL90MQzMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMTE5NTE0NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCKMMl7GYAwiXcR9gNTHJZeZntux2ncPjQU8KUN/WbQKqFr
5GujGWx38W2k3R3/MyGs0RvteevIrYFl/+3ZbDGYLJ9wMTDByg1dYtLnkVzwI7FnzvOzTjvZSHhv
SrX5Ch6I1J/8moPLsGg2/OKyw2n3Jrkr1np0YB6ROq3W9yni2G9m1uJn6p3D65cazZbkQlyYFkuh
A3WPiZMAQCcPPlmCu3nOot50nxgw0UCNsG0jgOT+4k5HdM4a4+NWLPZejJXvV6up/kCCqJl8QgG9
khfacqA7A1XwWsVEIQu4+BWfBDXCQvzR1q6RqnRtwCWXt0i1S61CjxQSpJ7PBkzcwuSS
--0000000000004b6f4005c21339f6--
