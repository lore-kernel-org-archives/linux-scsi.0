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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B5DC43460
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EFD161166
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhDSLDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbhDSLDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 07:03:03 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C78EC061761
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:02:31 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s22so2892776pgk.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oj7p2Z71lb5Km3vK9y7G520buN4EqglrK1sSbhieOzU=;
        b=ZV3Z9vL4E+zj/235hvQJ8pXzZRF3KoALiHknGRe8qnITTr8vCxPHrE+pyeRbCXOFA4
         +Frq5So+wqrmuVr5l/5ZAgBUE7CktpDWjymBsViIppDWp9MosrBsrsBB5xII/zaxE6r5
         6wcqzyHMxOdnGZ3uo8ujNg0YgeCNz118dH6uQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oj7p2Z71lb5Km3vK9y7G520buN4EqglrK1sSbhieOzU=;
        b=gnFCdW58mMTxeJeqIgOZ7cYeTJdH+X0N+d+X4ffQFW82NSB+/R3mr3vICiBZG4hvPQ
         xW9nElBinmq43W1wjUMcA39DHJAjg6bMNSiyoIFbM4zJ4jmdwbB+sJ2NE4vCcmdE5xKs
         j/+KUpkd58Kt56DjtKRvyAWOGeeIY0i6qaPpiRf4N5YHg2QXENS5Z4WdjGFJEeB0eY42
         MA0dR7TJu1ZpBrbdjxA7jrqt9rrQLkLDsTGrOoKjanwu1ka8+eF9kKkbf4osHVwFVo7E
         DGXAw6b4RLibQC+Ghh9cy9u7IBTqGU8DwVUv1vPfTBRdMUxtJL4Axzrc+0vwtflzondx
         pwFw==
X-Gm-Message-State: AOAM533hpSOFwz7PSs6xNz7RsXKDr9Jm1MckONweet3EoErRVFpd/jt9
        TGrbT4V6e7SMf57Mw1i+oZ9BXCj2KPETgk9+ZXsB/1MgMAt02ZVgPY4V3IWJykKlvzjIbTcOk16
        HMmaOSi6SxDQ4PmCZ8zp2/KQOV6uQBAfynaFFrf3rKvX8PUOkI3KHEv2/IJ/INXQHtaVkzXsdWm
        C3U5Sb9xWr
X-Google-Smtp-Source: ABdhPJxNIDGCNK2b3XMDua/+72dPtp4kj5DesogBGG3+HTBPHxe8djzlZc8zi2yaaeXgLpSNSAT+xQ==
X-Received: by 2002:a62:10b:0:b029:259:fdc3:7c69 with SMTP id 11-20020a62010b0000b0290259fdc37c69mr14050835pfb.11.1618830150711;
        Mon, 19 Apr 2021 04:02:30 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k13sm11825736pfc.50.2021.04.19.04.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 04:02:30 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v3 11/24] mpi3mr: print ioc info for debugging
Date:   Mon, 19 Apr 2021 16:31:43 +0530
Message-Id: <20210419110156.1786882-12-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001c282805c0514451"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001c282805c0514451

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 80 +++++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c |  1 +
 2 files changed, 81 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4e28a0efb082..3df689410c8f 100644
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
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index d82581ec73e1..39928e2997ba 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -339,6 +339,7 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc)
  * mpi3mr_flush_scmd - Flush individual SCSI command
  * @rq: Block request
  * @data: Adapter instance reference
+ * @reserved: N/A. Currently not used
  *
  * Return the SCSI command to the upper layers if it is in LLD
  * scope.
-- 
2.18.1


--0000000000001c282805c0514451
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHsCqbJSaX7W0R4goNKc/l4u3pjd
JoUdEJBxqXjs9FteMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTExMDIzMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAZmXFp7mZE1K2odIXHAZkOB4jvNyuCixVXMnFrkdP6dLBI
WnfisOIzHLgmgAQP7Q6jYE3PFcXffbNNvIx9Y4F7DvINfWZ0VvAXG/dLbZTjWTn7bTZ78FnY4nAR
PUWmKgamO66c4tv4qDn/k9wl6zwzZo/lqNAQfvMT5cBlo2bPfgItz9qyLStmRBcOgKV33IKSS6Ta
DZLSwiKgkOAc68ld9PvvmFNQ99GxBaTsGTw3cdwWf4nZVE8ofCguhVZS6EbTvlyXcYO8/VNn3M2Q
ZQrksRprSHOMuwOcGiJdpVRkKLdPku5BpYDOAycqB8PsSEsJa2DFgLXD6pUtklieZIEv
--0000000000001c282805c0514451--
