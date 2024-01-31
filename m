Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005F720DE2
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726245; cv=none; b=L+mPODN2l/J+h04/xUqUSe0zzLqMCYTt/VPhhvi1kXPaq5DePKSnrDrT7O+7wonxuvmdYy/dEcbvt2yQg9zIJDwDtX6V40foq0RMj/OSzTNYHRx3a0zg7FluIaxnO1PXiyO1rFFN65fhZ/u6LqpWcplzkHrpFCZIOFa5AirMPUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726245; c=relaxed/simple;
	bh=QZC3p6OxMgCqOSF4VYGbC6vOX6EakA87eYj4cdy5CVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EBfEAgFvLHnVH/1ODlEXhNa0LI1qfKOo8sjOl8ANnFN9f9Lx3C/omFqcJSmxFjthCGrRGNypZpOAMhNLApzB1KUSVyMeLvFyJS2O0RZbCL+l1Q5OJinwmJXKlCjrLW0KYijQtWIfxYjCp39mreYyewWh4DMKltfIfriNleakroM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0AnsnOk; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0AnsnOk"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-68c3de3eabbso191226d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726241; x=1707331041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSnj8+K8t2zMtsT9CuwsNJZ/DNaHwaVFLBOycPKEqAI=;
        b=B0AnsnOkyWSg438eOqQY3zAd6o4JS4NERaT8z6bX06xFneOinGUbJAMrGgFJUke59Y
         z3O+xNvs5EPo9xhfB9/rEHTAhahPw5Veh4aHUAVK/iVtbNHoxNTkUCFnq/J98oldyFAP
         0g/IQHDoJhjVQDXEpHeY7fKv1NmVK9G4MHuj/7+NvWQOQrXUmvD1XcZM61zQIT5BUWF/
         T0alll5cS0ANps4M/xfXenx2XDWo4OwmEc248fR+RrNv8pH9aIW12DG0KTNZnHbdwSPl
         CP4Q+mtagaHFSJjH/j+I8JVq8Gm2LwqrcbA+7DAyZqNnd9WkQf2Gl4Bdhg6qnMtmuwLX
         pKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726241; x=1707331041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSnj8+K8t2zMtsT9CuwsNJZ/DNaHwaVFLBOycPKEqAI=;
        b=kd1ucPX+v4euPWHcjrjWgQGWrWa1XAv+HqUatyp/JcM0N1pSthlnLx8d6GtFB0f+jK
         DSTCSGSBX92a1oKw41WPpGL+wx5Pp3kgqWVriqkxh+o9Cx97vGAirj3jFS3FBhDPe6lB
         ovs2Pd/n+Q3KlIL7nHXBiRIecj70MDygAhU+g+7kH+URhzF20T0WERvqOYxeuBVRMqBz
         xnr8yQT3vRYofoptarn1ebuY72kZJzRHMzA+T9KdXGZj9cLa0f0WzY+qMD0J/EQDdpje
         pYO/h+KffLsPnuKR/qVo3X0zUIDIXyGMP4uKrXNPyaBP7RBlSziXi2cTJL+3pjSCsnR3
         xFCw==
X-Gm-Message-State: AOJu0YwRQxf6bFdiwRZ2gg2VxOO4P+9yggbJj2wItvvNA3gKynzA1SlH
	TUKx4pDoOXy3CYFrIo+36BTBuKfu/qZ/HhkaGpnRMOVkHS+abtmfqSkG56KH
X-Google-Smtp-Source: AGHT+IHB0Wr5UFYamgefN338deK0//G2i7fBS45bOWfUu6ncB2vzusWjNOzDb4jApy9etqIOsc21ag==
X-Received: by 2002:a0c:f8ce:0:b0:68c:60bd:2226 with SMTP id h14-20020a0cf8ce000000b0068c60bd2226mr229824qvo.1.1706726241577;
        Wed, 31 Jan 2024 10:37:21 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:21 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 03/17] lpfc: Use sg_dma_len API to get struct scatterlist's length
Date: Wed, 31 Jan 2024 10:50:58 -0800
Message-Id: <20240131185112.149731-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sg_dma_len API should be used to retrieve a scatterlist's length
instead of directly accessing scatterlist->length.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d26941b131fd..07e941da8a16 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2728,14 +2728,14 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		sgde = scsi_sglist(cmd);
 		blksize = scsi_prot_interval(cmd);
 		data_src = (uint8_t *)sg_virt(sgde);
-		data_len = sgde->length;
+		data_len = sg_dma_len(sgde);
 		if ((data_len & (blksize - 1)) == 0)
 			chk_guard = 1;
 
 		src = (struct scsi_dif_tuple *)sg_virt(sgpe);
 		start_ref_tag = scsi_prot_ref_tag(cmd);
 		start_app_tag = src->app_tag;
-		len = sgpe->length;
+		len = sg_dma_len(sgpe);
 		while (src && protsegcnt) {
 			while (len) {
 
@@ -2800,7 +2800,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 						goto out;
 
 					data_src = (uint8_t *)sg_virt(sgde);
-					data_len = sgde->length;
+					data_len = sg_dma_len(sgde);
 					if ((data_len & (blksize - 1)) == 0)
 						chk_guard = 1;
 				}
@@ -2810,7 +2810,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 			sgpe = sg_next(sgpe);
 			if (sgpe) {
 				src = (struct scsi_dif_tuple *)sg_virt(sgpe);
-				len = sgpe->length;
+				len = sg_dma_len(sgpe);
 			} else {
 				src = NULL;
 			}
-- 
2.38.0

