Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAE1175AA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396853; cv=none; b=cdbDMkaZOBryT96PViJhJmC2zeKlwzqgv4ZNfrkqptvnvC/oEv+XfKK28umQ8N++IW+jNKPHY+Xe0Cof3Olex6G2J5Do5RTO8xkbKCtz2KUVTywdF6qQzetknf9ve2YV9GhaRFjsW4ME2HzDxyFCEWOY+LGR87V7auFoqjN3md4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396853; c=relaxed/simple;
	bh=YT4XqsoyqpYnimAL/+pKLnMTJnTkInPjQZ4JMA/6fek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8A4LCSLx+ppHlF5jkCzCyB1SbtLAXPoING4z8A04oZCTWitvGqfeEt7CvCLAFuEYh6zdkXPFzMy8jnxyWOX8Ug2nx0ZFaVLyTuh23Nxad63bRAShTLqFVLXjOtBWsFCM49nkln5xb3t+ue2vNI178SAFl2zS100H1JICmyVBGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNKlgSJ5; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNKlgSJ5"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-710437d0affso4885376a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396851; x=1720001651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f91B5Fez4/RqYBgPifW7AJgON0I4xFSNufg1BzkOjAg=;
        b=fNKlgSJ5XTVnHaSQUQtKCwr65UHm7PGiyFMw0ZIZ06Tr0n2rL5XeUr/iaA2YI8BIIP
         QjYSiSguEYhAAOtBhbGCn4lPoe/ZhE1evzi2QYQrJzO9ycbpK8qnleB1Mb5WsztmeWPz
         93o2XBdixEe35UTl65jRjWXPNLiFFLVhdUcLenEQ1+lIy2B6zOD/OGb3sWzgP75XErCl
         /vvTboBhioCgt8ZiM+FPepVLFgMcPIbUXJJYywWbmfm2jyPU6vtI4alYNXKr9NasuicH
         uPDXIHRBQUeb7CFq4D8C9DpOZX22CY7If5aB35yZpiBs+AwB2stib36Hg1U3mdo+WfCJ
         QCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396851; x=1720001651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f91B5Fez4/RqYBgPifW7AJgON0I4xFSNufg1BzkOjAg=;
        b=qzLN9tNlBG5T5aGec05oJOLa5DwD32ankPm2gj88MeXs/SUCfrRHNVy3LmeOG5hQnH
         AptA4uC720tQ1sm1zdY4PUPi0VBMQaXfAe21qKFtsbG9HGvcKQ4yHk/uBbUbD2Zjv62X
         vFJb7rnJ74EtV+QQzTw2yBa8sV1JIQlqVtGrCGG7C7s3ZdiCUJ/EPDrMZhQe2Oh3Dn0H
         Mwh50zGu5wKdXPaCNXa44i597kS1pVp9lXR5k5diheMttnR0Kyv+1Secfu29D38iq3Vz
         6zLtWVPU5vWr/UWEGMZAr7Y5zs4SNyMyHtSSmpTqfzyywjbj8ZkcfQKNFZUKLvhjvBQR
         4/bA==
X-Gm-Message-State: AOJu0YxnvB/KhDRjvJ8o2urD99M7Yw//aSM4OooLEHhbi1/eZPV4raGH
	s5l7Lvz2ZX76DwlcyQulERWTtaSziUjpjb0pC6m0bHoSC5wHMyMLqR7eAA==
X-Google-Smtp-Source: AGHT+IEXjDaOAdoztLrXlJ+zfL0Pb5v1upHrtg3O26pxWqa+u4vCOjpA3dSs5PxUcokxG7r0uTr+vA==
X-Received: by 2002:a05:6a20:ba83:b0:1b0:2af5:f183 with SMTP id adf61e73a8af0-1bcf7e7ecd5mr8639585637.23.1719396851189;
        Wed, 26 Jun 2024 03:14:11 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:10 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 02/14] scsi: bfa: Used min() in fc_rftid_build_sol for bitmap size
Date: Wed, 26 Jun 2024 06:13:30 -0400
Message-ID: <20240626101342.1440049-3-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/bfa/bfa_fcbuild.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 52303e8c716d..784be9b435f1 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -1093,7 +1093,7 @@ fc_rftid_build_sol(struct fchs_s *fchs, void *pyld, u32 s_id, u16 ox_id,
 
 	rftid->dap = s_id;
 	memcpy((void *)rftid->fc4_type, (void *)fc4_bitmap,
-		(bitmap_size < 32 ? bitmap_size : 32));
+		min(bitmap_size, 32));
 
 	return sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s);
 }
-- 
2.45.1

