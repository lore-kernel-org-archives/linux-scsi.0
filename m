Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23ECCC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE9261211
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhIUSsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbhIUSr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 14:47:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D065C061574
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:27 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id me1so243600pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NJ+nWZCFIY/UOj9FMrU5Kq1nXYZWQms7K1BB/RcYtYs=;
        b=NQlI8ywFm2lKKwW1lXcBAzlXaR2nKntnR2hTGVI/NiEeM7g5x4EO3yvclT3GaCxO44
         n+1IaIw36pw84Hx/9OBRGTVfPUbpRF9f/wv/pEdcSL8L3Wv1OnFmkM3rMOb0hn5cW55C
         hPEEnOJJR8C+9tM2Wffef8csmqO0ZIHuR3EHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NJ+nWZCFIY/UOj9FMrU5Kq1nXYZWQms7K1BB/RcYtYs=;
        b=CwFdSlf007VoJdJTjzW0n0wO7zYaZHDZKsfVwE+HeCVQIigXQW6z5rtghSg7rqhG7+
         YCYSrQ04Dt/0vavg+J7xo+q80QuBQuELi5wXVKhKthyEreCmiUnBF0in7YSetCTSxxLy
         3A2JrGlEVpqRCWNYQElpac8sqrU7aRdyyEQlqY97MSFg+Fi32Hkr1GDT8xsFlKBpSSnK
         suA/TImJ+a/7NOqSK9/qzfhjRsDDkBhnRopM4PnbJUuTw+w4CsE6+4xngWTZ+Dt9Aa0R
         l7rLuJKgGuUUh4u1TD/UbkuSxFlcsE1uco8CGGfDJRlqnI1ULZvTldLieMcYUYD1uacL
         /+5A==
X-Gm-Message-State: AOAM530rmLyc99qlT+BtkVDJquGdXbKKDIDidlGXpY0bCGY+tdvE0URW
        PP5i/kF3FbW5Xc8Qv4PrE34Pfr5Fstiw7PUe9ORd/eiEgxei2kcoANEBlJVEcpfU2VNyl85WgWZ
        W2PJgYb3+rHpbiwZqz7n4yM4FILzIY18e8EawP+SX26ucQmvBIVSUIex29RoOu4QuhPnDlCeviw
        GhbG7MP53j
X-Google-Smtp-Source: ABdhPJylyVbzOZf+r4xNlA46vkA+XFLxN2H/YR8klN9gAexxgxtnl0zQws0DvVp2f/JrOtte+S5GTg==
X-Received: by 2002:a17:90a:ba0e:: with SMTP id s14mr6996811pjr.213.1632249986510;
        Tue, 21 Sep 2021 11:46:26 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f144sm18258897pfa.24.2021.09.21.11.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:46:26 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 7/7] mpi3mr: task management for pass through command
Date:   Wed, 22 Sep 2021 00:16:00 +0530
Message-Id: <20210921184600.64427-8-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210921184600.64427-1-kashyap.desai@broadcom.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a86f7105cc85d02b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a86f7105cc85d02b

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h     |  4 ++++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 23 +++++++++++++++++++----
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  2 +-
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 289aaaec7ee2..db3de78a979c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -953,6 +953,10 @@ void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
 
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 			      u32 reset_reason, u8 snapdump);
+int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
+		    u16 handle, uint lun, u16 htag, ulong timeout,
+		    struct mpi3mr_drv_cmd *drv_cmd,
+		    u8 *resp_code, struct scmd_priv *cmd_priv);
 int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
 				   u32 reset_reason);
 void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0ecdf02c10c5..c45d722a7f2a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -931,7 +931,7 @@ static long mpi3mr_ioctl_process_mpt_cmds(struct file *file,
 	struct mpi3_status_reply_descriptor *status_desc;
 	struct mpi3mr_ioctl_reply_buf *ioctl_reply_buf = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 count, bufcnt, din_cnt = 0, dout_cnt = 0, nvme_fmt;
+	u8 count, bufcnt, din_cnt = 0, dout_cnt = 0, nvme_fmt, resp_code;
 	u8 erb_offset = 0xFF, reply_offset = 0xFF, sg_entries = 0;
 	bool invalid_be = false, is_rmcb = false, is_rmrb = false;
 	u32 tmplen;
@@ -1165,10 +1165,25 @@ static long mpi3mr_ioctl_process_mpt_cmds(struct file *file,
 				    (karg.timeout * HZ));
 	if (!(mrioc->ioctl_cmds.state & MPI3MR_CMD_COMPLETE)) {
 		mrioc->ioctl_cmds.is_waiting = 0;
-		dbgprint(mrioc, "%s command timed out\n", __func__);
+		if (mrioc->ioctl_cmds.state & MPI3MR_CMD_RESET) {
+			rval = -EAGAIN;
+			goto out_unlock;
+		}
 		rval = -EFAULT;
-		mpi3mr_soft_reset_handler(mrioc,
-				MPI3MR_RESET_FROM_IOCTL_TIMEOUT, 1);
+		dbgprint(mrioc,
+		    "%s: ioctl request timedout after %d seconds\n",
+		    __func__, karg.timeout);
+		if ((mpi_header->function == MPI3_FUNCTION_NVME_ENCAPSULATED) ||
+		    (mpi_header->function == MPI3_FUNCTION_SCSI_IO))
+			mpi3mr_issue_tm(mrioc,
+			    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
+			    mpi_header->function_dependent, 0,
+			    MPI3MR_HOSTTAG_BLK_TMS, MPI3MR_RESETTM_TIMEOUT,
+			    &mrioc->host_tm_cmds, &resp_code, NULL);
+		if (!(mrioc->ioctl_cmds.state & MPI3MR_CMD_COMPLETE) &&
+		    !(mrioc->ioctl_cmds.state & MPI3MR_CMD_RESET))
+			mpi3mr_soft_reset_handler(mrioc,
+			    MPI3MR_RESET_FROM_IOCTL_TIMEOUT, 1);
 		goto out_unlock;
 	}
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 149ba3fdfceb..c82cb3c2fe4b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2606,7 +2606,7 @@ static void mpi3mr_print_response_code(struct mpi3mr_ioc *mrioc, u8 resp_code)
  *
  * Return: 0 on success, non-zero on errors
  */
-static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
+int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	u16 handle, uint lun, u16 htag, ulong timeout,
 	struct mpi3mr_drv_cmd *drv_cmd,
 	u8 *resp_code, struct scmd_priv *cmd_priv)
-- 
2.18.1


--000000000000a86f7105cc85d02b
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPd6/UXOUWDNY5zhrpHOUzKS1dBw
1hHSFQrSXnDX6L2yMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDkyMTE4NDYyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCjs22Z0izCpuVwOu/xDLp6k3XFsFdLAmwcuYUvQAG1TGLl
LF9yCXNBeopYTfvFKKlmjqsGOPUTPpm/8deq3RhJCDXw87/PVpW2xx7HD8+klucW15zPMYrhz1YB
LoACwTJxHoOONWH56MzvDymWW69Ch4euVZWqQY1vZGIT+qLqgqsLZFz2LYUvKEVbU6unHW3tC0NF
eJ9ooINhDfyJkQKIILOCLBBg9OUi7s7mMy0YwLxm/CfMGL2tSxwid1xNY7nex80ID+YQngljvYVk
LjPPexfbK9pYoiR2YgbbUrLBKym+/XpeZKaKLAJxWv3dGFeB1j8eB3lECwaalwVkcbJY
--000000000000a86f7105cc85d02b--
