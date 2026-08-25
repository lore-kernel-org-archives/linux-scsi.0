Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CEF481A92
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672687; cv=none; b=nzicnCC++j3h5ir9KbQVwgrN5spKSsF1+PRLycsAqJsW3Z5i9GFfvEbODfsotcAnIwvXLJOGFa5LqViCl9k7M9ejv/sPxPaVrMUxgF28xhnrJodCePYGiepOT1nKkmFJqdZueGuJGbDIXyqeqTfn1HsKCoK8GRv6GBXrmv67BZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672687; c=relaxed/simple;
	bh=5tugmiIhXwgo8PkNrzvbpvgBh1zooI33zj+7+bvi8to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skanBK5/ZvCcm8aNCYvJNwJZ1nDk68qHbCNzeNPmza+NjJlCKXDuEZGDpOR5p/de32lEDhJhEXVHOkxpXMHT6PJSOi1YYx2AjWn0usjYnDTSs4bzVZi5Hn546VG0+EJhjIRnKf0mIs2Lpt655bUeRKpuXH3PhbZO91zdnnSdUK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GS2IT269; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GS2IT269"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso83608a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672686; x=1788277486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lyp+NqZnwdH7PZw0OHvNoktWyEa81jmTKO1kbsaFlBQ=;
        b=aQfbH+7x+YnVUv/ziihP+Wbpz+tCbw+q7ZODH12NoZmUVfcPJiLWM7BTzujW3adI1J
         KceDQ+IgjFSESu5yIVm0GjTdpmS+0v48hOWmMLdh+16kv+k23dF5l3OirsnG6NOQVxud
         GysbTfLU0U2AeWaDIoJv6BstAVQcF3epZGod1hNrIeRYemCHGwG+ksfXTtiYqCzo9Li2
         fm4Gu3S+qJ0WcwFf9Xw1bfZ/boQvhkvwSS4aiEOaPOnHcjR/vAT4izVzT8yerIpMdRdR
         +bHn5g7iRXbA3/KZuo80jLWsE6L5mWxjqxJOrMzehJOvzmaMHQc2KEab7/cwp0ttvIs+
         oe9w==
X-Gm-Message-State: AFuF++l8ru+7en5MwZ4NVM5pnLE/hqjCw96oB0DU0R+DlNhnScvVFwDF
	v1uj9wDCi1mjK9NDqyenAfP8hOlWNtQxHYErIkrp1u6kGBEueexmKXloOmSZwyplG2h3n1P38ow
	ugV/7rhgiBwxtzVYyJ2t4NAQgqvIvGB18ONxxnNSYzqLa3Qn4+/oo5nv1bKx/bAYRnXa5+L2Ryo
	7rLhlWipqod4xWjaNOwsRA3P6OSGtezIc7Orb1E/uev0MEMVsmp7zmy78q4Lo5l8swS1anmT5pR
	zytazB198rAS1Y5ph8mqFSG
X-Gm-Gg: AR+sD13jv5FT8DTTZ4w9UfXwdDWEsFI42fmpajwsnr+m2sXDJVekVBMKFQ3jIg1T5JT
	pKFq3gioH5S63kmPHaNXFZlbrrh9+q0NrpjnteH/YJWzJgmNusllrMYivIHx0i8fpgf4fHk5hu2
	jBISr5LAs+gdgiGOzhb8mehQNYm0CiufbiAo0fuB825+0ZEu01HdzpaTYN7enRx+8YevSY5TVzl
	mioV73GAHyqPNU6dIDwcujYSSvFf8DbKd4VdgLWipDkGumIPcjx82FnjC9g0zbHgsPDzZgk8+v2
	NAliHw7pyfYpNf4m55aTxpZh2Z+idhK1SFE8eOjwhmTGvektltNRLvye5ZAkyxrphARBphOPqFE
	hUm5DT0wQp5NjFkZDUQQbrl/2JXK58EDXxt4TGJfOShTPcGVbx8FsKVZqsu28+ltz82TFedoF/y
	X86gEsbj4yPbZ+BEwY94pPHYrBdCMsOmfJPggXafKHhh0=
X-Received: by 2002:a05:6a21:4606:b0:3bf:b1d3:393e with SMTP id adf61e73a8af0-3cd9103bb66mr17252896637.2.1787672685630;
        Tue, 25 Aug 2026 08:44:45 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc199d0d3b1sm1287586a12.0.2026.08.25.08.44.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:44:45 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc11b5dd54dso6204876a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672684; x=1788277484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lyp+NqZnwdH7PZw0OHvNoktWyEa81jmTKO1kbsaFlBQ=;
        b=GS2IT269eWueWgpgDY/WrjPlMpworpPmnCONFUpQIgn9Wc0Ui6SbQ/HCP/SutgedOv
         Av3xvCueAcnQe88S9fMuoS+KHODlyk+/sPtZislTdvqFCZ225BueuckpusyGRmZiQkcC
         k1yebL2FadFQM2HNvTFR5CihWbC4zCetVNEp8=
X-Received: by 2002:a05:6a20:be8f:b0:3b3:216b:2743 with SMTP id adf61e73a8af0-3cd9103c931mr17395708637.4.1787672683778;
        Tue, 25 Aug 2026 08:44:43 -0700 (PDT)
X-Received: by 2002:a05:6a20:be8f:b0:3b3:216b:2743 with SMTP id adf61e73a8af0-3cd9103c931mr17395589637.4.1787672683312;
        Tue, 25 Aug 2026 08:44:43 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:44:42 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 08/17] mpi3mr: Fix out-of-bounds bitmap access during device removal
Date: Wed, 26 Aug 2026 02:34:02 +0530
Message-ID: <20260825210411.301535-9-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Device handles reported by the controller are used to index the remove
pending bitmap and to build a task management request without being
compared against the maximum handle the controller reported.

Check the handle before using it.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - Relocated handle bounds check to the entry of mpi3mr_dev_rmhs_send_tm()
   so out-of-bounds handles are rejected immediately without polluting
   delayed_rmhs_list.
 drivers/scsi/mpi3mr/mpi3mr_os.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f80a21ec161b..2a35f146fe69 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2401,7 +2401,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 		ioc_info(mrioc,
 		    "%s :dev removal handshake completed successfully: handle(0x%04x)\n",
 		    __func__, drv_cmd->dev_handle);
-		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
+		if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
+			clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
 	}
 
 	if (!list_empty(&mrioc->delayed_rmhs_list)) {
@@ -2515,6 +2516,20 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	unsigned long flags;
 
+	if (handle >= mrioc->facts.max_devhandle) {
+		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >= max_devhandle(0x%04x)\n",
+			handle, mrioc->facts.max_devhandle);
+		if (drv_cmd) {
+			cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+			drv_cmd->state = MPI3MR_CMD_NOTUSED;
+			drv_cmd->callback = NULL;
+			drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+			drv_cmd->retry_count = 0;
+			clear_bit(cmd_idx, mrioc->devrem_bitmap);
+		}
+		return;
+	}
+
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
 	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
-- 
2.52.0

