Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74B4D2FB;
	Wed, 18 Jun 2025 07:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750231110; cv=none; b=KpPfyXLUgCUgTbCod+Yk1/GiLDAF3nDo8jfBhgSxccptkON5l8KiJeesTXcLOS0vDB3jTQp4dW2nzekXczHMNjyL/+6Z0wt51tV4EEQP6ByL7IxuOEmUD0VvWy6xvwQlwRP3WICRhsi63piZBbH16s1l7cSqfJJhrDUIiVmRLdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750231110; c=relaxed/simple;
	bh=4nir1e7tcteiGBuPukso+J2OPuikjNgErY3yM5UU7mY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MzTMC37TxtcZQMZeV6Wnj/DRmXdRFGzbKtjVAt0ABFaDfSKG3yeZPEwEPfWbh6AM4n5ZSskNL8CXFOmeFog6HjotJs8qNeGwotN7pOhoqBLCbFN2xAOnCEwKyS0Vfw0TSh2UWcYah6+cljjTiCgtUm3efILRBRarf13dxEb7tFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aP1rTp1U; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aP1rTp1U"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a4ebbfb18fso785752f8f.3;
        Wed, 18 Jun 2025 00:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750231107; x=1750835907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YZkdmaRUBXZBLPwLD5ammg+TwGXiNi59RRNbzEoylRI=;
        b=aP1rTp1U9xdp8mU3OV1OpSAF4bOSCsDGGamIfspSUZxYj47s/vcMr7imi77ewo15wp
         38gCEXYUtTtWc1NmaGT4d3aF/wajfAOxT4t0Dx7lrsI8R4b1NTZ6hPrUki+2l89pYt2g
         tmhrH+5uFhb6etuM/BpU5ICBb68Evql7XK36CDiMlcTLG+KBg/QQROaOqOuk4qI/XAKM
         g8Ix0qaVXPqy0lde/AfU5pP2Cx7JHvnVNjXqYKiQC3yfyNhZlr0ytlAig8dJVFCgFFtv
         Z2Exjt26zCLyUF73VTlf55DEcfXHXpESk/NiE5YyiM/7RpEM8hGoKQfy5/WbWFB9EWMO
         FRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750231107; x=1750835907;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YZkdmaRUBXZBLPwLD5ammg+TwGXiNi59RRNbzEoylRI=;
        b=YYTZNmgF50wjdtXL35LsCvuCtGFpTW8f0NpM/2fn56UDK+DgjbTmu5cILXYuGDgtw6
         coQgjAOallWDH4/CY++lcnQc0WkvBTiXLgXPM3TBOBd5CMSU65qBEZ9R202h1gzwjitf
         KMkLSzKNKfGnkmYu7WtuGUl4K+BB1aroHSBU6fQ1l8FoPIZyXeOYdoeHPouep5KH5UoF
         ccTQKQ3wklQGEgyzXeTGcWNRk0QdQXFI6a2Z3LVozk37vzfO27IXuT5vy4tnwxCUvObS
         RiWkPr2XvMvbXbTFnQpULgnunxkLjOKoKcgxuHdOQ1KBZO3Pbr2Pt6FGgxYtOvakBfne
         FCKg==
X-Forwarded-Encrypted: i=1; AJvYcCUMaV1UixXgzfwcVCsf3bbb+CSdOjipN7i2pggUK37yaGT+G91LNFV7CnPtj1H2LLD5ityygrNxFtAGsyc=@vger.kernel.org, AJvYcCX5KuhJ9+5WrsE/tEKlUgCT58kNe7U9WUcsUCr7N0qbvYIkFSYQ7sb/TInO2ygQRGLYsxzfG/sRmbBOWg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1hpvbx9mHLA0OmXNN+lEJDNNqsnvOgXJUXSbUDdsqzhxRrWbL
	jHH6lumBM+JW3NDP+dysh9M4U8KaVPVU5pFdBYQH1E9rTnRZrtZnFfZP
X-Gm-Gg: ASbGncvRCRaWQQ3Sf+I5Nxv1w3DN/0DnLyh2pAXnT5Z1QbsBWopg+TEuQGPNtf1DA1R
	hwpj1vy+Uxe/quaZ6Y/3gbUE2dtqgc9ln4Nj7h/+4Hx3a9ThHJaXiJSfyXsoUKvzDyJpV1AC98q
	9mdigyKF2fTB7NsLf2do73oW6FHsEwKmd04i+czPCS0mAt/imtK1t1qAA+b+qXDg52bvMvcCgqK
	BM/gULaVGyh8yWNPpXtdYUtNb8//Krq/uRX7Yg4GwWFL0PfMIsmWWzCYLnmSRWLppYZYjUUqdxH
	jEZ4Or6IsvjGN78Pb5yPYbzaa+gnfCK9gk0hJwOjtHEd7XYdr38wOs42CCeUu8EeKyq5mf6bITI
	jF8yiNp3DnJikvj2f+FdGNgTMkPcEBxNKDyqtPjzX/rSFjjhayNwbs5xzu84cBVktZw1X5eSQ5K
	E=
X-Google-Smtp-Source: AGHT+IFXiKvmQeJ7mh6eNt66G706l/Bz36hMq6dHBok5OW+p6DIv32w9Mlb4ZN83dGaTXTN1hokYNA==
X-Received: by 2002:a05:600c:4f53:b0:442:e0e0:24d with SMTP id 5b1f17b1804b1-4533cadaac7mr48443335e9.7.1750231106594;
        Wed, 18 Jun 2025 00:18:26 -0700 (PDT)
Received: from thomas-precision3591.home (2a01cb00014ec300f1c5391b39542642.ipv6.abo.wanadoo.fr. [2a01:cb00:14e:c300:f1c5:391b:3954:2642])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4532de8c4e8sm195116085e9.3.2025.06.18.00.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 00:18:26 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michaelc@cs.wisc.edu>,
	James Bottomley <JBottomley@Parallels.com>,
	Lalit Chandivade <lalit.chandivade@qlogic.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla4xxx: Fix missing dma mapping error in qla4xxx_alloc_pdu()
Date: Wed, 18 Jun 2025 09:17:37 +0200
Message-ID: <20250618071742.21822-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dma_map_XXX() can fail and should be tested for errors with
dma_mapping_error().

Fixes: b3a271a94d00 ("[SCSI] qla4xxx: support iscsiadm session mgmt")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d4141656b204..a39f1da4ce47 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3420,6 +3420,8 @@ static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		task_data->data_dma = dma_map_single(&ha->pdev->dev, task->data,
 						     task->data_count,
 						     DMA_TO_DEVICE);
+		if (dma_mapping_error(&ha->pdev->dev, task_data->data_dma))
+			return -ENOMEM;
 	}
 
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
-- 
2.43.0

