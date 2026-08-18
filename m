Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDCB45FFAC
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075853; cv=none; b=D8sc4hyC+h6Mq0CTjhL/WG9HYtXyyKPTNiYHse7XnzPJeIPr7PtyZuv+XsTrx49/9VI7KNCyW2eyEw2Jil7QGzs/FqjK7KMr0KQnnmI5Uxz+1NVk1sop2pXz/zJxylexouKk/m8hn9HLDkJ6l3PafvvT+uQvZrzWPELN0OoVnh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075853; c=relaxed/simple;
	bh=9BjpCZ5EEiJSMU31AhWCgyosZFWJs9ScH1Fah+mJs2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeJuo51RaGQq59VaZ6GYxeWJWfK6KqNUbi5uDNpMo0/O5ja6pi0gPjeZSDkbU0VdZfr5kvdblBUGO8C4hLBaGEd4PYJmFzQgigfBoa2gNB3u5cIg+xeJdU4s4nbFaiBpW9ZmsTlt0HjLgQWG5m9OwusNAWwwO2g3iOI2EbW7R7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=I3FDH1uH; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="I3FDH1uH"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cf452def93so11976335ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075852; x=1787680652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lEF7lCJqOChWp5/vJM8BGaX0X0trU8QH+t1O3EDS8qw=;
        b=YlNf7VKImJyLOSFZC3Bn0DKdtTAEMo6EVPJe/aUFugJztK0csfuljeg75CvfAauB12
         Ntd8d3abDHIRrtGlbds7zjhuwoCjgHWIQ3BiupPR9JPphXfjUGzQVt6tTGiNU7CWurgG
         dNtdbFO14pMLfpjqyIme4WJgy5ALY8Wf8awC81Fe4p4iQ4Aq5oUZlDLFcMgUTiHaGAel
         uLPRF8iP1bGeZCogMlJnRAtoR8l9e3YJ2OdCCceIGlkf3iaM2mp6NeRKj2ycrFIrzA3Y
         O+j42D5xqx3l7F2WH0dNhklcSujV7OWecq+p4rxE9iEilUEzgMAGT17Yaw93jMuGj9E2
         x/6w==
X-Gm-Message-State: AOJu0YzPEWe45fj6EqryVwEdnr68euuiBcZpX7UcFkNqrEDJK+e10VVO
	oEXaX+pImIXfOjknDnIPExRQc2miZK2L8SS6llPSq+hSdUB9IJ2DRi1DZWljO14j8R1hllMPftz
	LT/jD4gj3Z4k9m3Jbk7JzByD8WG3IcGWWyerbvXowRpCqnqhp3qj0u/TRg1QIWdYuR8FDf6ewY9
	KCGTfc2CFJlUkvw0nX1gCileX9zuAZGznmSmxhy0ktViw4fwqfiGQSZlR5J0/ZAn6mqyCaiIJ/R
	9bmuMtNp+Ts3RmO3/x04ham
X-Gm-Gg: AR+sD10Girtuyvu3L/jqqZzXfuI5sJwuVOQ2lPc7e5+SPcI1fsIW7FiYXu5KN7qkdSW
	Bg4n4Hi9b77dft9d3voVTsNspMTkiz2xllFdxa6zNXDzy0AdQr415q6TM6VLrH3YnwtSa+aLD7t
	2+WjfKdnwFL/EC7zJBPXKuWR/6xxFPWM6nF9KDwSxtOA71TW96YxiU+bSPGbX6BDYRFH9N9aiCW
	Q3RTw9UW8O1WgGx2PlOrArzrGuCDJKS0Pw8TBAw0NuCndoi+H8jEgFceD/xm7RBRBbUe/yQm8+l
	+Ax6ruWGOjlOey+ydYBRMBHpCrNnkh4WcKJi40P7hIVY8BogXS3ZM+G+lP5O6HiUwpA+Oawws3Z
	CkitXQCamzo0aE+Waa9HdwUZnSoTeSazirVQAgTC2pPDnURmkoeV+kHg4fATQSrOdBjzHa3CjI3
	GFhiEbVDZc1c6J872ygvWFgpLCwCpZCkvdbxwj8GO4Qak=
X-Received: by 2002:a17:90b:4d0a:b0:38e:42f5:d096 with SMTP id 98e67ed59e1d1-39579647ec5mr130050a91.0.1787075851820;
        Tue, 18 Aug 2026 10:57:31 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39531ddc462sm4063312a91.5.2026.08.18.10.57.31
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:31 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbedbd182f5so12255a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075850; x=1787680650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lEF7lCJqOChWp5/vJM8BGaX0X0trU8QH+t1O3EDS8qw=;
        b=I3FDH1uHAcvYKgintoqOElXtxHVYfyg5amNK8qS96HuZIFyfYsGJ/nwFikqNDQqbsG
         hKGTO/5zT8WXLYSnIp/u/Oe73gVb2xdj1cJJ9VE8YV/ACuxHggl/9Udzf8amjcvmq3N2
         9vrCq4w85QDeMqZ9vkXSZeKNlDbdxl+9jT2vg=
X-Received: by 2002:a05:6a20:4392:b0:3bf:9bd9:cf60 with SMTP id adf61e73a8af0-3ccde9020e1mr10436125637.6.1787075850037;
        Tue, 18 Aug 2026 10:57:30 -0700 (PDT)
X-Received: by 2002:a05:6a20:4392:b0:3bf:9bd9:cf60 with SMTP id adf61e73a8af0-3ccde9020e1mr10436039637.6.1787075849403;
        Tue, 18 Aug 2026 10:57:29 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:28 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 08/17] mpi3mr: Fix out-of-bounds bitmap access during device removal
Date: Wed, 19 Aug 2026 04:44:17 +0530
Message-ID: <20260818231426.58105-9-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
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
 drivers/scsi/mpi3mr/mpi3mr_os.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 402d1f35d214..15207eed7edc 100644
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
@@ -2564,6 +2565,12 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	drv_cmd->callback = mpi3mr_dev_rmhs_complete_tm;
 	drv_cmd->dev_handle = handle;
 	drv_cmd->iou_rc = iou_rc;
+	if (handle >= mrioc->facts.max_devhandle) {
+		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >= max_devhandle(0x%04x)\n",
+			handle, mrioc->facts.max_devhandle);
+		goto out_failed;
+	}
+
 	tm_req.dev_handle = cpu_to_le16(handle);
 	tm_req.task_type = MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
 	tm_req.host_tag = cpu_to_le16(drv_cmd->host_tag);
