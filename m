Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957CDC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhLTOEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhLTOEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:52 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DEFC06173E
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:51 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t123so7437841pfc.13
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=gKGi8JN/NQTE6x9MdlIYwHJpCD3JylYj/BbUGQAr8LM=;
        b=Si0b0vLiRoB1sJPpyO08sjmgR7O/nuUu9qdOf9PL/C5wy7GEXo9qXc1ZHWfE8hw+MK
         Ppa+n1FcIFCSO+uCTqnu3AOS+uSBpi3JaLzYtEC5kUIcjujqn+TSTfisA6hc26G+tS2f
         sqK9iUI1mcHaZ54knTAxGtuV96H00hyJ5EEM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=gKGi8JN/NQTE6x9MdlIYwHJpCD3JylYj/BbUGQAr8LM=;
        b=aj5YDxJrUMHCThoTkVdmcdVxrSYjG4WqgzJitDMQaOfsZyYdd299XXsA6n3QOmEWh9
         A1FnVjJZ7/ZmQU1v8QKv5kLUw7jjmPngXnuH6PgS3dyEuF8hPpePhOoFwM10O2iTDXMQ
         KKWjUs6SaFgcvzz733x0p0NS90WxvEIFjOs6WRW/GF+cUDg82MuqUn8Zyt2KIqGcRjIj
         G/U1VFcAIzwIUOAxsk+CCOdeb6STDK6FLY8FlsKKc9Cv4sS/d4+cYUTa/xBiTvRU7nlH
         K6GLbXlwYOLzCPWfvBIvS+lF3+AoQTq5ApLTpTt/MOC0HrOVHJe9Bpwz/MDLv22LBks6
         ahRw==
X-Gm-Message-State: AOAM532zM3/G5VxbYku44qgCjniC69/aK7TaXo/nMyUHcNSnnNfXFR+k
        cYXuQ4eNm2gjYHHsKLCSXJJbgCa9mMAw/2pfUNt8DgN9pbJBl1bHhl/wt8wU/zblkVHUmqrQwhw
        LHZH3Q/+YsL0G5Evi+HJkIFCIlssWM7YnZVXngHUqsIJXXLu8Gmcj/ruXvkSCnWvW8cwBHAYY55
        ZK4AOJJKX8
X-Google-Smtp-Source: ABdhPJyQ1a23GR/Fyk2fOuSQIhoggWe+T7+po76iMUlvsC/dx3/4VQ4RJ49UaMT3pvT8cv5rDNYNOg==
X-Received: by 2002:a05:6a00:728:b0:4b0:b1c:6fd9 with SMTP id 8-20020a056a00072800b004b00b1c6fd9mr16350498pfm.27.1640009090939;
        Mon, 20 Dec 2021 06:04:50 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:50 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 22/25] mpi3mr: use TM response codes from MPI3 headers
Date:   Mon, 20 Dec 2021 19:41:56 +0530
Message-Id: <20211220141159.16117-23-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000052210d05d3945f01"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000052210d05d3945f01
Content-Transfer-Encoding: 8bit

Remove locally defined TM response codes and use
codes from MPI3 headers.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  7 -----
 drivers/scsi/mpi3mr/mpi3mr_os.c | 54 ++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 64783a8..e9e7a86 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -142,13 +142,6 @@ extern int prot_mask;
 
 /* ResponseCode definitions */
 #define MPI3MR_RI_MASK_RESPCODE		(0x000000FF)
-#define MPI3MR_RSP_TM_COMPLETE		0x00
-#define MPI3MR_RSP_INVALID_FRAME	0x02
-#define MPI3MR_RSP_TM_NOT_SUPPORTED	0x04
-#define MPI3MR_RSP_TM_FAILED		0x05
-#define MPI3MR_RSP_TM_SUCCEEDED		0x08
-#define MPI3MR_RSP_TM_INVALID_LUN	0x09
-#define MPI3MR_RSP_TM_OVERLAPPED_TAG	0x0A
 #define MPI3MR_RSP_IO_QUEUED_ON_IOC \
 			MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8bf1b59..b2f1c6a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2799,49 +2799,52 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
 }
 
 /**
- * mpi3mr_print_response_code - print TM response as a string
- * @mrioc: Adapter instance reference
+ * mpi3mr_tm_response_name -  get TM response as a string
  * @resp_code: TM response code
  *
- * Print TM response code as a readable string.
+ * Convert known task management response code as a readable
+ * string.
  *
- * Return: Nothing.
+ * Return: response code string.
  */
-static void mpi3mr_print_response_code(struct mpi3mr_ioc *mrioc, u8 resp_code)
+static const char *mpi3mr_tm_response_name(u8 resp_code)
 {
 	char *desc;
 
 	switch (resp_code) {
-	case MPI3MR_RSP_TM_COMPLETE:
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE:
 		desc = "task management request completed";
 		break;
-	case MPI3MR_RSP_INVALID_FRAME:
+	case MPI3_SCSITASKMGMT_RSPCODE_INVALID_FRAME:
 		desc = "invalid frame";
 		break;
-	case MPI3MR_RSP_TM_NOT_SUPPORTED:
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_FUNCTION_NOT_SUPPORTED:
 		desc = "task management request not supported";
 		break;
-	case MPI3MR_RSP_TM_FAILED:
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_FAILED:
 		desc = "task management request failed";
 		break;
-	case MPI3MR_RSP_TM_SUCCEEDED:
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED:
 		desc = "task management request succeeded";
 		break;
-	case MPI3MR_RSP_TM_INVALID_LUN:
-		desc = "invalid lun";
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_INVALID_LUN:
+		desc = "invalid LUN";
 		break;
-	case MPI3MR_RSP_TM_OVERLAPPED_TAG:
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_OVERLAPPED_TAG:
 		desc = "overlapped tag attempted";
 		break;
-	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
+	case MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC:
 		desc = "task queued, however not sent to target";
 		break;
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_NVME_DENIED:
+		desc = "task management request denied by NVMe device";
+		break;
 	default:
 		desc = "unknown";
 		break;
 	}
-	ioc_info(mrioc, "%s :response_code(0x%01x): %s\n", __func__,
-	    resp_code, desc);
+
+	return desc;
 }
 
 /**
@@ -2965,10 +2968,10 @@ static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	*resp_code = le32_to_cpu(tm_reply->response_data) &
 	    MPI3MR_RI_MASK_RESPCODE;
 	switch (*resp_code) {
-	case MPI3MR_RSP_TM_SUCCEEDED:
-	case MPI3MR_RSP_TM_COMPLETE:
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED:
+	case MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE:
 		break;
-	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
+	case MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC:
 		if (tm_type != MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
 			retval = -1;
 		break;
@@ -2977,14 +2980,11 @@ static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 		break;
 	}
 
-	ioc_info(mrioc,
-	    "%s :Issue TM: Completed TM type (0x%x) handle(0x%04x) ",
-	    __func__, tm_type, handle);
-	ioc_info(mrioc,
-	    "with ioc_status(0x%04x), loginfo(0x%08x), term_count(0x%08x)\n",
-	    drv_cmd->ioc_status, drv_cmd->ioc_loginfo,
-	    le32_to_cpu(tm_reply->termination_count));
-	mpi3mr_print_response_code(mrioc, *resp_code);
+	dprint_tm(mrioc,
+	    "task management request type(%d) completed for handle(0x%04x) with ioc_status(0x%04x), log_info(0x%08x), termination_count(%d), response:%s(0x%x)\n",
+	    tm_type, handle, drv_cmd->ioc_status, drv_cmd->ioc_loginfo,
+	    le32_to_cpu(tm_reply->termination_count),
+	    mpi3mr_tm_response_name(*resp_code), *resp_code);
 
 out_unlock:
 	drv_cmd->state = MPI3MR_CMD_NOTUSED;
-- 
2.27.0


--00000000000052210d05d3945f01
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJ0ZSIv9nGOUtrUaQnHR
u+W5qxAo+2j689tCX049pELQMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQ1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC8NdP9ghVx6UGbhfz86IS3XWKbHNJfkoPCBX6q
YsrrU1dmU1sBimNZaYTVbi6veYGm8+Q3jH/k1vmqrxgOiqpNyhRrYSiLOhtAxMtagy/zz37AtLdC
+Gfcv5FLRGdECOR8VzPiZpTMYzV2I31X8es6EEfjICvApF7auNYFQDTXBBhqKdG2C6Tqmt/6cfTt
kwnz+s+hFjkVTsCE+JGKNGbUVDOr6uqjUdU5KunrPaFYJU8QY51YeeVzxETBf1cykfwjIT2Lb5A+
F3QmJhAITRab9Rkhh3ckBosWeWJXJlkDuV9EFTC/FFcC7H3qgQSYxUvGfEQ5DZaR1Q6Szj3Y1M7n
--00000000000052210d05d3945f01--
