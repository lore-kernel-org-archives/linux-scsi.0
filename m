Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DC7C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhLTOEr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhLTOEl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9144C06173E
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:40 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r138so9468043pgr.13
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=n9PwOpcnb6Fkn0c2AjAMOkxIYiAwL5ct6ODl0noOYWs=;
        b=SpXtpJ7GMHHhpaN6VRhzX4zDyw1THmRBwlydoGRFHOUy+6kimYVWErnu+pdMni4FmU
         +tVT/yaFNToj0UUKAR2DUxWYflj5Qr5iB2SQdcwrJaaveAc58G1MuNQmgaXA27P2Q/X/
         ssGTQfpGb5YE1f/weYlN/GUI0T7333VGjeD3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=n9PwOpcnb6Fkn0c2AjAMOkxIYiAwL5ct6ODl0noOYWs=;
        b=2g3IxrPmZhItS4IzvzO3nC4THVrlk/MDu0z9CaRfcf7IWbvdiOeV7xxccsSNxdIjgd
         6QsItQOJHcR/zR7XBsZRI63ptVAaiX5RqpPdGan4Opu3IVwQddcOWwASr/yGOvol1o5F
         fmiiO6gXpGd/QACIS99BMWaP2e9g4OXXAFTzGe987g/0KJ/Vwqd28pru80CKAmopP6bc
         r1TV8QI2QdCeThloFiuGs/FXlyN12JaPK0Yd4dlRuCdANW0RBwoDOql1XzROsNRKU3e3
         YYxZKkCA2gAkTOcEA/0ctmtqpe0LSZGUkNnKSmqfNtNzx98rrwUA45cNzY6hVldVXARb
         0wbw==
X-Gm-Message-State: AOAM533YsMw1T9F8+bmzkZd5ICOiopE+rgVj71xKe4wPLlsGn0AEnk1S
        F6xlNarzIa59+adfrpDmNWFsbbYEntSzwNlLdiB6umWTBcWd1ZvruR8RoIXiqzjKuIeaWvRoZRY
        g+ZI9wwHa6QYdXY+rH25yP4nvJr3Yx6p3Hdy2bdBkaNIVLMkxz5FZdWdd1GmGjhUt0lV6yzBPe8
        jsIBkF2L80
X-Google-Smtp-Source: ABdhPJwU68+Jmhg9InsfHgb5nEJp+4dRI0oSLjx3kg6wvVCBYjiYJIj6KaSyGg2PMeGIT0g++qyQjg==
X-Received: by 2002:a65:58ca:: with SMTP id e10mr15230696pgu.116.1640009079827;
        Mon, 20 Dec 2021 06:04:39 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:39 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 17/25] mpi3mr: Gracefully handle online FW update operation
Date:   Mon, 20 Dec 2021 19:41:51 +0530
Message-Id: <20211220141159.16117-18-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000aa503b05d3945eb0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000aa503b05d3945eb0
Content-Transfer-Encoding: 8bit

The driver is enhanced to gracefully handle discrepancies in
certain key data sizes between firmware update operations as
mentioned below,
- The driver displays an error message and marks the controller
as unrecoverable if the firmware reports ReplyFrameSize that
is greater than the current ReplyFrameSize.
- If the firmware reports ReplyFrameSize greater than the
current ReplyFrameSize then the driver uses the current
ReplyFrameSize while copying the reply messages.
- The driver displays an error message and marks the controller
as unrecoverable if the firmware reports
MaxOperationalReplyQueues less than the currently allocated
operational reply queues count.
- If the firmware reports MaxOperationalReplyQueues that is
greater than the currently allocated operational reply queue
count then the driver ignores the new increased value and
uses the previously allocated number of operational queues
only.
- If the firmware reports MaxDevHandle greater than the
previously used MaxDevHandle value after a reset then the
driver re-allocates the 'device remove pending bitmap'
buffer with the newer size using krealloc().

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 109 ++++++++++++++++++++++++++------
 2 files changed, 92 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index b24efe2..24b65bb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -752,6 +752,7 @@ struct mpi3mr_ioc {
 	dma_addr_t reply_buf_dma_max_address;
 
 	u16 reply_free_qsz;
+	u16 reply_sz;
 	struct dma_pool *reply_free_q_pool;
 	__le64 *reply_free_q;
 	dma_addr_t reply_free_q_dma;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4d048e5..4050195 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -13,6 +13,8 @@
 static int
 mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u32 reset_reason);
 static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
+static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
+	struct mpi3_ioc_facts_data *facts_data);
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
@@ -376,7 +378,7 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 			if (def_reply) {
 				cmdptr->state |= MPI3MR_CMD_REPLY_VALID;
 				memcpy((u8 *)cmdptr->reply, (u8 *)def_reply,
-				    mrioc->facts.reply_sz);
+				    mrioc->reply_sz);
 			}
 			if (cmdptr->is_waiting) {
 				complete(&cmdptr->done);
@@ -996,6 +998,66 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
+/**
+ * mpi3mr_revalidate_factsdata - validate IOCFacts parameters
+ * during reset/resume
+ * @mrioc: Adapter instance reference
+ *
+ * Return zero if the new IOCFacts parameters value is compatible with
+ * older values else return -EPERM
+ */
+static int
+mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
+{
+	u16 dev_handle_bitmap_sz;
+	void *removepend_bitmap;
+
+	if (mrioc->facts.reply_sz > mrioc->reply_sz) {
+		ioc_err(mrioc,
+		    "cannot increase reply size from %d to %d\n",
+		    mrioc->reply_sz, mrioc->facts.reply_sz);
+		return -EPERM;
+	}
+
+	if (mrioc->facts.max_op_reply_q < mrioc->num_op_reply_q) {
+		ioc_err(mrioc,
+		    "cannot reduce number of operational reply queues from %d to %d\n",
+		    mrioc->num_op_reply_q,
+		    mrioc->facts.max_op_reply_q);
+		return -EPERM;
+	}
+
+	if (mrioc->facts.max_op_req_q < mrioc->num_op_req_q) {
+		ioc_err(mrioc,
+		    "cannot reduce number of operational request queues from %d to %d\n",
+		    mrioc->num_op_req_q, mrioc->facts.max_op_req_q);
+		return -EPERM;
+	}
+
+	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
+	if (mrioc->facts.max_devhandle % 8)
+		dev_handle_bitmap_sz++;
+	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
+		removepend_bitmap = krealloc(mrioc->removepend_bitmap,
+		    dev_handle_bitmap_sz, GFP_KERNEL);
+		if (!removepend_bitmap) {
+			ioc_err(mrioc,
+			    "failed to increase removepend_bitmap sz from: %d to %d\n",
+			    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
+			return -EPERM;
+		}
+		memset(removepend_bitmap + mrioc->dev_handle_bitmap_sz, 0,
+		    dev_handle_bitmap_sz - mrioc->dev_handle_bitmap_sz);
+		mrioc->removepend_bitmap = removepend_bitmap;
+		ioc_info(mrioc,
+		    "increased dev_handle_bitmap_sz from %d to %d\n",
+		    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
+		mrioc->dev_handle_bitmap_sz = dev_handle_bitmap_sz;
+	}
+
+	return 0;
+}
+
 /**
  * mpi3mr_bring_ioc_ready - Bring controller to ready state
  * @mrioc: Adapter instance reference
@@ -1854,8 +1916,13 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 	    mrioc->intr_info_count - mrioc->op_reply_q_offset;
 	if (!mrioc->num_queues)
 		mrioc->num_queues = min_t(int, num_queues, msix_count_op_q);
-	num_queues = mrioc->num_queues;
-	ioc_info(mrioc, "Trying to create %d Operational Q pairs\n",
+	/*
+	 * During reset set the num_queues to the number of queues
+	 * that was set before the reset.
+	 */
+	num_queues = mrioc->num_op_reply_q ?
+	    mrioc->num_op_reply_q : mrioc->num_queues;
+	ioc_info(mrioc, "trying to create %d operational queue pairs\n",
 	    num_queues);
 
 	if (!mrioc->req_qinfo) {
@@ -2447,6 +2514,7 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *mrioc,
 		goto out_unlock;
 	}
 	memcpy(facts_data, (u8 *)data, data_len);
+	mpi3mr_process_factsdata(mrioc, facts_data);
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
 	mutex_unlock(&mrioc->init_cmds.mutex);
@@ -2593,12 +2661,6 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	ioc_info(mrioc, "DMA mask %d InitialPE status 0x%x\n",
 	    mrioc->facts.dma_mask, (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK));
-
-	mrioc->max_host_ios = mrioc->facts.max_reqs - MPI3MR_INTERNAL_CMDS_RESVD;
-
-	if (reset_devices)
-		mrioc->max_host_ios = min_t(int, mrioc->max_host_ios,
-		    MPI3MR_HOST_IOS_KDUMP);
 }
 
 /**
@@ -2618,18 +2680,18 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (mrioc->init_cmds.reply)
 		return retval;
 
-	mrioc->init_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	mrioc->init_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
 	if (!mrioc->init_cmds.reply)
 		goto out_failed;
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
-		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->facts.reply_sz,
+		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->reply_sz,
 		    GFP_KERNEL);
 		if (!mrioc->dev_rmhs_cmds[i].reply)
 			goto out_failed;
 	}
 
-	mrioc->host_tm_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	mrioc->host_tm_cmds.reply = kzalloc(mrioc->reply_sz, GFP_KERNEL);
 	if (!mrioc->host_tm_cmds.reply)
 		goto out_failed;
 
@@ -2655,7 +2717,7 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	mrioc->sense_buf_q_sz = mrioc->num_sense_bufs + 1;
 
 	/* reply buffer pool, 16 byte align */
-	sz = mrioc->num_reply_bufs * mrioc->facts.reply_sz;
+	sz = mrioc->num_reply_bufs * mrioc->reply_sz;
 	mrioc->reply_buf_pool = dma_pool_create("reply_buf pool",
 	    &mrioc->pdev->dev, sz, 16, 0);
 	if (!mrioc->reply_buf_pool) {
@@ -2731,10 +2793,10 @@ static void mpimr_initialize_reply_sbuf_queues(struct mpi3mr_ioc *mrioc)
 	u32 sz, i;
 	dma_addr_t phy_addr;
 
-	sz = mrioc->num_reply_bufs * mrioc->facts.reply_sz;
+	sz = mrioc->num_reply_bufs * mrioc->reply_sz;
 	ioc_info(mrioc,
 	    "reply buf pool(0x%p): depth(%d), frame_size(%d), pool_size(%d kB), reply_dma(0x%llx)\n",
-	    mrioc->reply_buf, mrioc->num_reply_bufs, mrioc->facts.reply_sz,
+	    mrioc->reply_buf, mrioc->num_reply_bufs, mrioc->reply_sz,
 	    (sz / 1024), (unsigned long long)mrioc->reply_buf_dma);
 	sz = mrioc->reply_free_qsz * 8;
 	ioc_info(mrioc,
@@ -2754,7 +2816,7 @@ static void mpimr_initialize_reply_sbuf_queues(struct mpi3mr_ioc *mrioc)
 
 	/* initialize Reply buffer Queue */
 	for (i = 0, phy_addr = mrioc->reply_buf_dma;
-	    i < mrioc->num_reply_bufs; i++, phy_addr += mrioc->facts.reply_sz)
+	    i < mrioc->num_reply_bufs; i++, phy_addr += mrioc->reply_sz)
 		mrioc->reply_free_q[i] = cpu_to_le64(phy_addr);
 	mrioc->reply_free_q[i] = cpu_to_le64(0);
 
@@ -3459,7 +3521,13 @@ retry_init:
 		goto out_failed;
 	}
 
-	mpi3mr_process_factsdata(mrioc, &facts_data);
+	mrioc->max_host_ios = mrioc->facts.max_reqs - MPI3MR_INTERNAL_CMDS_RESVD;
+
+	if (reset_devices)
+		mrioc->max_host_ios = min_t(int, mrioc->max_host_ios,
+		    MPI3MR_HOST_IOS_KDUMP);
+
+	mrioc->reply_sz = mrioc->facts.reply_sz;
 
 	retval = mpi3mr_check_reset_dma_mask(mrioc);
 	if (retval) {
@@ -3582,7 +3650,12 @@ retry_init:
 		goto out_failed;
 	}
 
-	mpi3mr_process_factsdata(mrioc, &facts_data);
+	dprint_reset(mrioc, "validating ioc_facts\n");
+	retval = mpi3mr_revalidate_factsdata(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to revalidate ioc_facts data\n");
+		goto out_failed_noretry;
+	}
 
 	mpi3mr_print_ioc_info(mrioc);
 
-- 
2.27.0


--000000000000aa503b05d3945eb0
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINGvhbF7dXAqR0Dyokfe
VC5kF+AEkaQZhk8b8gr6V5YAMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQ0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBmEtY6l5RO8w45kLp6qlBL/wUGD237+7vN8rDM
Hhp8HDtWLvxSyVpIrU6+VDHOYsPRrC/kIP6yRDBvhw12Di/nPLsUvdrkXpp8t3QEpb3bi+Q3016g
E//aLdB+LCx9L+TtMDrCv6CkkWvnbbtb/A6RnIJD8tR4UkOV9rdAvcUFAeZiZNWQaHCVrunkKq/s
QbVyrdUE4Rk2VA0JmbfP/wtDcMDd1MvVToU0/199SCHo4d7bJz2Z3gL/pVPuUEuL+xbBCUhxTKPN
1Mb59mq+81YOYVTcV0s8nJMnQKr4hQEyHZAjLbq+aGJIefrUs3QI+5dM0IvMPd2vAO0EalT63Wv4
--000000000000aa503b05d3945eb0--
