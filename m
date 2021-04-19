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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE28C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B2A61285
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbhDSLC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238399AbhDSLCw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 07:02:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADF4C061761
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:02:22 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso20142512pji.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O7GFjadVAn/Ms5P+xjYYEhm2kxnQ/6uQv+6SbaGr2YI=;
        b=EKdz2hqIytCqNibOYXc1riXlvj4a3pEXTQpJEKhspCXTtMvg2X0/HVyxQ+liNPV5bR
         LLPCcgkk/gbQKt9YwCP/da4Mwg5pvszoOQRvh9Mzg8I3h0JEDed6VsnCldbjNuI+vWsk
         2wvQ+LBELbqvXLkzGzglsBeWVDQKQ46uLOrNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O7GFjadVAn/Ms5P+xjYYEhm2kxnQ/6uQv+6SbaGr2YI=;
        b=Ek9FDnSKM6ZPddjTR1NDAddQwFVxGHVZfOlE6FIbiX7nx9QQ0cF7S84+Oosia2a4vt
         xSM5cGWbAiCMHAuN4tXmipnDPgq7tYJ7IjFb8i8A92CJV3U71VE1wFnLcMUAe5MTahw7
         LyFUSOLDq65EOwGlD7auwIzdg0jOZoOmekR55TXstKynIKvnrxY1qNInNtghWHWyeJBD
         1viUzoSe2UlYvcppAwpuxAO54fikuJD9OY7qFfwUn+8xQCXyWzskq2xVXkkHbjuOQoMa
         uL7IH8d9KzL9fwz0GFOCBhwiTZouWfJRGuDViKb4PR3yPUEEbLUqiiQS28BClLYpa9Bs
         zWOg==
X-Gm-Message-State: AOAM533Z31c1GOpOZJuc2+tLSpWk6jzZVGVM6W4apfLuwqHAekk/4O82
        fAjFjh/xGsMylF6WIai8rHqdKvuMAifKpVVGQXDPcY9u3qDgamsDIqrMcryF1RfYXuAIJChmiOd
        FV/JxhoKLLii5gMna6D3oZCFFrc60GRrigSc0fYsVuEh+yR5temg9uWT2gYI66RrLOg3ugv3hMH
        ofVq+P1JSH
X-Google-Smtp-Source: ABdhPJw5Uyf/U5pNPh9P7k5SQ1/q6BE8dNNltjQvQ9t89cmQsQlJiIp7pn6OX2pV9ZULqXlNwC4/2g==
X-Received: by 2002:a17:90a:3f08:: with SMTP id l8mr24139453pjc.136.1618830142015;
        Mon, 19 Apr 2021 04:02:22 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k13sm11825736pfc.50.2021.04.19.04.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 04:02:21 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v3 08/24] mpi3mr: add support of event handling part-3
Date:   Mon, 19 Apr 2021 16:31:40 +0530
Message-Id: <20210419110156.1786882-9-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000983b5105c05143df"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000983b5105c05143df

Firmware can report various MPI Events.
Support for certain Events (as listed below) are enabled in the driver
and their processing in driver is covered in this patch.

MPI3_EVENT_SAS_BROADCAST_PRIMITIVE
MPI3_EVENT_CABLE_MGMT
MPI3_EVENT_ENERGY_PACK_CHANGE

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  3 +++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 37 +++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 7f3b553e5b86..00c3996de032 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2745,8 +2745,11 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
 
 	retval = mpi3mr_issue_event_notification(mrioc);
 	if (retval) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3d78c558fe2a..3629184f68f9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1496,6 +1496,36 @@ static void mpi3mr_devstatuschg_evt_th(struct mpi3mr_ioc *mrioc,
 
 }
 
+/**
+ * mpi3mr_energypackchg_evt_th - Energy pack change evt tophalf
+ * @mrioc: Adapter instance reference
+ * @event_reply: Event data
+ *
+ * Identifies the new shutdown timeout value and update.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_energypackchg_evt_th(struct mpi3mr_ioc *mrioc,
+	Mpi3EventNotificationReply_t *event_reply)
+{
+	Mpi3EventDataEnergyPackChange_t *evtdata =
+	    (Mpi3EventDataEnergyPackChange_t *)event_reply->EventData;
+	u16 shutdown_timeout = le16_to_cpu(evtdata->ShutdownTimeout);
+
+	if (shutdown_timeout <= 0) {
+		ioc_warn(mrioc,
+		    "%s :Invalid Shutdown Timeout received = %d\n",
+		    __func__, shutdown_timeout);
+		return;
+	}
+
+	ioc_info(mrioc,
+	    "%s :Previous Shutdown Timeout Value = %d New Shutdown Timeout Value = %d\n",
+	    __func__, mrioc->facts.shutdown_timeout, shutdown_timeout);
+	mrioc->facts.shutdown_timeout = shutdown_timeout;
+}
+
+
 /**
  * mpi3mr_os_handle_events - Firmware event handler
  * @mrioc: Adapter instance reference
@@ -1559,9 +1589,16 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		process_evt_bh = 1;
 		break;
 	}
+	case MPI3_EVENT_ENERGY_PACK_CHANGE:
+	{
+		mpi3mr_energypackchg_evt_th(mrioc, event_reply);
+		break;
+	}
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_SAS_DISCOVERY:
+	case MPI3_EVENT_CABLE_MGMT:
 	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
+	case MPI3_EVENT_SAS_BROADCAST_PRIMITIVE:
 	case MPI3_EVENT_PCIE_ENUMERATION:
 		break;
 	default:
-- 
2.18.1


--000000000000983b5105c05143df
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIO5blIUwxT05R05iGFcVoAUWchxx
TxgDP44nbQPrkaTxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTExMDIyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCZiO2McRCKXf1pULV1Y969zwO18j4HV74hAByz31kT2ioS
jcyW+q7zCsQZwBPvbRYjhM9FwsyxC7Wkp+FL8m7Rf84/wwa5MqEBhHpaIpq8XKdKfgIvU8iArCfx
MOlalcydgNMcfWxQAcMaUiEUFR9cT8AR7qhmDcyXyli4pXxdpNiebl6Ismg74D0TluLOXTF5vK6H
phdjZsSuts7PLxYLGMwso43xwjyJwpssm/0lzHS9HRr7jzI7q+N1dQxpyLB629y+RBPdqSyZgNRx
cW5XVVEG8AsxpbnK/R8UiKZ3P6fuqMwKUzRTTDrDcR4xmGPKjInkd7EHoiQBGEy7tzDZ
--000000000000983b5105c05143df--
