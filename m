Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB0BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhLTOEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbhLTOE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:29 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553FCC06173E
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:29 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 200so9489442pgg.3
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=W4fapNrUv1kEeKxZ+r46ZkxcAJHVg2vG3VTG22cKMIs=;
        b=cx95o1m5bIElMO0SIAZGX5JFwoPJojXQRRFv8/qZKUlwj2HcCSgPTLemFQTj+pKK8U
         HFxYX1KaEiJdAhw/b53bGqROvjaGheZWhNOkxqO6/k+6HIrRLXDSE1PgRRjk6EGKM/9D
         XvKCyVAY2itjBT4L6eaTkH//o3f4tWsMYmDoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=W4fapNrUv1kEeKxZ+r46ZkxcAJHVg2vG3VTG22cKMIs=;
        b=BGJRNPL2nrJlT/flrFmRXFozDwBxdcWgpAD+O2ygzoHdJD1Apno1jFdmDDX9A4qZVS
         zGkT8HMUBwB+OhxUns/ZMAv+xh98yzYK7glkZhgXqCMWhXSsP4LbFhakIz7hI1Qy/ZSj
         RSm4rvUAbFxMJK5CoPvCUSigd793zxWz0/E88orLhExe+vwYxueDDwVsmWDYR1IjAm+r
         1QQ962a3e/1Ju7kJsVE6cdeeQ97tV+BSThYLMnpLM7+6yU5NpvAiN8W/B6RHbj2ukBWK
         Q3VMCgEqExpHbV6+oyfQ+1Dq/rpN+3PxJ/ahFcd8acBhwSOmILA5Z2Jaw0xz7oTr3R4n
         hUTw==
X-Gm-Message-State: AOAM5300ecljgftecneH+B6SZ0mq5Fxc+R8oXcYUcqujgGpbZd1jiJxG
        8CnMyGOKQSdKRDcZkWS4QWkZNv3qbHBLCebkq3UZZhspUbFn7iOFGypk2Uc40pqfldjnQnI0Yb6
        pAjeDaxYiXjrdpgwvf+tDClZ7k1FsW8U8859DGlrT+v6nWzdVkExXLNc22W/t3vi3DiAJMPD6SS
        MXBcY+8z7Z
X-Google-Smtp-Source: ABdhPJw6t1Rn6BxhTbBhcJh/4VqU8B4LYIfrRW9Ni9MaQn/Q7RgnDBSU6UrqKZ6o3PiD/4tZvY0Ggg==
X-Received: by 2002:a63:5f0a:: with SMTP id t10mr15561022pgb.11.1640009068390;
        Mon, 20 Dec 2021 06:04:28 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:27 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 12/25] mpi3mr: code refactor of IOC init patch - part1
Date:   Mon, 20 Dec 2021 19:41:46 +0530
Message-Id: <20211220141159.16117-13-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fa4a3f05d3945d2d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000fa4a3f05d3945d2d
Content-Transfer-Encoding: 8bit

- Separate out reply and sense buffers allocation and
initialization into two routines and call only
initialization routine while issuing the IOC Init
request message.

- Also move out the event enable logic to a separate
function.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 107 ++++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index b6d4e9d..f7cdb21 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2555,10 +2555,9 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
 	u32 sz, i;
-	dma_addr_t phy_addr;
 
 	if (mrioc->init_cmds.reply)
-		goto post_reply_sbuf;
+		return retval;
 
 	mrioc->init_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
 	if (!mrioc->init_cmds.reply)
@@ -2651,7 +2650,28 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->sense_buf_q)
 		goto out_failed;
 
-post_reply_sbuf:
+	return retval;
+
+out_failed:
+	retval = -1;
+	return retval;
+}
+
+/**
+ * mpimr_initialize_reply_sbuf_queues - initialize reply sense
+ * buffers
+ * @mrioc: Adapter instance reference
+ *
+ * Helper function to initialize reply and sense buffers along
+ * with some debug prints.
+ *
+ * Return:  None.
+ */
+static void mpimr_initialize_reply_sbuf_queues(struct mpi3mr_ioc *mrioc)
+{
+	u32 sz, i;
+	dma_addr_t phy_addr;
+
 	sz = mrioc->num_reply_bufs * mrioc->facts.reply_sz;
 	ioc_info(mrioc,
 	    "reply buf pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB), reply_dma(0x%llx)\n",
@@ -2684,11 +2704,6 @@ post_reply_sbuf:
 	    i < mrioc->num_sense_bufs; i++, phy_addr += MPI3MR_SENSE_BUF_SZ)
 		mrioc->sense_buf_q[i] = cpu_to_le64(phy_addr);
 	mrioc->sense_buf_q[i] = cpu_to_le64(0);
-	return retval;
-
-out_failed:
-	retval = -1;
-	return retval;
 }
 
 /**
@@ -2715,6 +2730,8 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 		retval = -1;
 		goto out;
 	}
+	mpimr_initialize_reply_sbuf_queues(mrioc);
+
 	drv_info->information_length = cpu_to_le32(data_len);
 	strscpy(drv_info->driver_signature, "Broadcom", sizeof(drv_info->driver_signature));
 	strscpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name));
@@ -2784,6 +2801,13 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 		goto out_unlock;
 	}
 
+	mrioc->reply_free_queue_host_index = mrioc->num_reply_bufs;
+	writel(mrioc->reply_free_queue_host_index,
+	    &mrioc->sysif_regs->reply_free_host_index);
+
+	mrioc->sbq_host_index = mrioc->num_sense_bufs;
+	writel(mrioc->sbq_host_index,
+	    &mrioc->sysif_regs->sense_buffer_free_host_index);
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
 	mutex_unlock(&mrioc->init_cmds.mutex);
@@ -3291,6 +3315,44 @@ out_failed:
 	return retval;
 }
 
+/**
+ * mpi3mr_enable_events - Enable required events
+ * @mrioc: Adapter instance reference
+ *
+ * This routine unmasks the events required by the driver by
+ * sennding appropriate event mask bitmapt through an event
+ * notification request.
+ *
+ * Return: 0 on success and non-zero on failure.
+ */
+static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
+{
+	int retval = 0;
+	u32  i;
+
+	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
+		mrioc->event_masks[i] = -1;
+
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_ADDED);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_INFO_CHANGED);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_STATUS_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
+	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
+
+	retval = mpi3mr_issue_event_notification(mrioc);
+	if (retval)
+		ioc_err(mrioc, "failed to issue event notification %d\n",
+		    retval);
+	return retval;
+}
+
 /**
  * mpi3mr_init_ioc - Initialize the controller
  * @mrioc: Adapter instance reference
@@ -3313,7 +3375,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
 	u32 timeout;
-	u32 ioc_status, ioc_config, i;
+	u32 ioc_status, ioc_config;
 	struct mpi3_ioc_facts_data facts_data;
 
 	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
@@ -3455,13 +3517,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		    retval);
 		goto out_failed;
 	}
-	mrioc->reply_free_queue_host_index = mrioc->num_reply_bufs;
-	writel(mrioc->reply_free_queue_host_index,
-	    &mrioc->sysif_regs->reply_free_host_index);
-
-	mrioc->sbq_host_index = mrioc->num_sense_bufs;
-	writel(mrioc->sbq_host_index,
-	    &mrioc->sysif_regs->sense_buffer_free_host_index);
 
 	retval = mpi3mr_print_pkg_ver(mrioc);
 	if (retval) {
@@ -3494,25 +3549,9 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		goto out_failed;
 	}
 
-	for (i = 0; i < MPI3_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
-		mrioc->event_masks[i] = -1;
-
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_ADDED);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_INFO_CHANGED);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_DEVICE_STATUS_CHANGE);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_BROADCAST_PRIMITIVE);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_CABLE_MGMT);
-	mpi3mr_unmask_events(mrioc, MPI3_EVENT_ENERGY_PACK_CHANGE);
-
-	retval = mpi3mr_issue_event_notification(mrioc);
+	retval = mpi3mr_enable_events(mrioc);
 	if (retval) {
-		ioc_err(mrioc, "Failed to issue event notification %d\n",
+		ioc_err(mrioc, "failed to enable events %d\n",
 		    retval);
 		goto out_failed;
 	}
-- 
2.27.0


--000000000000fa4a3f05d3945d2d
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDxo1aN+XAsHSQNneoOw
JZ1s8yEKn8H0zzRaUDJwJwGZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQyOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCu+bLCFQF/W1tBDON7sm+lc0/Rex+VyiNTRICc
zepK+sZhTk5lvL+fFrGYjrZuqX7hA2FSZgJXaE90PgbEu0qjpE8H9VNSXx8Ukl7tLPixIlRjkrG+
BLGipNSd6drdciPjAEFu02+M7oJDVZSQklX9OIYep2WeY4WVVoy5k4X+6VOpqD1yKsZJSGeqTBZg
FIfniks4KFBAWimEb08EX/cNzSGTMAbmnBRY4HIj2kF9iFkksCBO0qvNzMnGiA1vJLemsRSU5zoj
KX2jc6IY2f8fE8np0KCJNI4QcTtPgdwcMICOLtOuBA+xkWgcmx3Zbaz46E2D1aXd/TZDgmvQoSRS
--000000000000fa4a3f05d3945d2d--
