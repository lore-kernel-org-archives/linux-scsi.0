Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5B3169AD2
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 03:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761102363; cv=none; b=OFsPIJAdv35Yqr8uE/hG+a7GGTQXS6NiWloRgNHqaXvbJaguX3sL0+gjICbaNCga5+8ZrXfcZaRq05y6ogpoevnn+lNZutoLI9Qh8K6s7ugR6LBvc+SzB1kYSkF0b1ADIENN2RnZWY34i4SSVY5hluyZuLuwFFNM1kgqV0PDou8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761102363; c=relaxed/simple;
	bh=hDKcO+6tpTx+vDwFCsnE/KqKIMKRHk43B2xmWcILIeI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZOdfyMM0LVTfJVDlcYMFQgx9r9wJE6ebe4M9g9/p08ENFhVOp6S1bhRhSEkycDsanlgCaZQlxrosNv0x8bqkwqkxeDzXyXmjhZADtVon40p+D7vKBnfUOgeiZtyctzVaz9XlRSUGCpl4vjTCuydcLXQkjjYQ+9bpWHVrH0F4Qqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1ILQ9Gy; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1ILQ9Gy"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-93bccd4901aso531984139f.2
        for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2025 20:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761102360; x=1761707160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ISiPvSTNn3o9NNdr1WqejjfJYooOZ4Dr+K+ubbeMFdo=;
        b=N1ILQ9GyoYWu78c+23T3lRiFF3AuRglExibXz+8nVLA4fxWBCxM01aaZGlO8fYecla
         h6UEyXfjNKUtxdBdgOSPnFTtoWxJgx4/lCbiKmy5BvhgliviBW+76NTKXvMz0hW7eG59
         RrbXHFrJdbbvuWUF1e7KJRIJbNANoTugQapJmSWir+Rzr0q8qVIkMSNJjx+3sUk0XSri
         CIPY8WvYcMnC8RFzIyaYDw0GjQWD1XgkUVzoWvepSSldoJa7bqqQEnN7lIIQfA4/oOvU
         gQb3BVIDqTQp//jVVbTplSz2IcqOiYBT7N5UlBBo63wjJDn3ize+mQvMFlJQd7dQSuh3
         YBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761102360; x=1761707160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ISiPvSTNn3o9NNdr1WqejjfJYooOZ4Dr+K+ubbeMFdo=;
        b=ZYd3l8zstyVvHdNXvQWyhSRCCmAkk/gBNnZdyIPdvobisO6VkhzroBzuY7D6hc6knb
         oxx4xfgnD0gAF/LWKQKwYHv+lxbrOv9hfnOPbBy5ZMIFRg6avKdeP/wlbGXq6NBcgnnr
         qXbYd5rV8MOravyRq/73B4wLB0GA6T6XyVifgTrE2320UAPZEtCCP0lbl7UrR3xqB8wX
         o4ZzD7pv3DIiWRnLMaa/b+mp0Lw2EiYmCZxe0Ua9td+P1+W2A59EpdDPUFlJEPIPPsee
         0rUdtTuDFPMxndv+NSno4fesNNUNrkFEAwfZMeD7ikqnVbPDynl6DYlBA0EdvhVU0lQh
         tuDg==
X-Forwarded-Encrypted: i=1; AJvYcCWerWqmELH9ujhUt2+cjU17y/GOaNBw5SsAnbYTbJn/jM5qYh18gLUiTsVXDpb9Ajz0jNxYPNnvUYmP@vger.kernel.org
X-Gm-Message-State: AOJu0YyeR0k74uvV+XSgvfo6NMX6mV//n+AKKmJpgPVlufuDqCblRdHU
	Q2GZemSGqYLp7CbnmQG4PKwk7doO0O/yZnBEwjeO/Qol4dgu65RWc0Wx
X-Gm-Gg: ASbGncsVMj+P2HFnhnuc3Q9UzhyGctT6CrX5hqXlsK6uyaxHW2TbDL2B+sAbtV0fG1T
	x90U8MW4okOdSPQR4pOd7GSnODiAkcLLtcBHu/Amj+vHqotyQMom6UiR5v2CwiEAmcToQyKnr+U
	A/7hEeMzpYUXF7htO4CtvXWP5ARVdvhdd5LqOzpdeaAIhc+cLk45WFAND56Z8wy8/hE84RZUKmx
	nEP1A1nRAUahcGw5d4r59CP9jUBraYbTmTh8zOz108SrtN4UwO9K6m8PEgEYa5+2hRLrEJPLQKz
	YGQdoiQOQOvKugaFBRxCCcVJsZjtBUrmu8G9NiBSILvthc9AUNiAEM3nu1GFwHdWb/29/Cx0Tmu
	NvRnKGlEIArRw0nDIPtxQbc8NTfvislP9HYHpdVBu+56RzftE8CPsOj8MgXi59nuz9/tcxFO0tS
	5p3SphNjXoPodFxbux2sdlBIMfoPyIFow8Vdo70IIQDj6lXoiv0rSnzlc91/lfV8llmgpj5gE33
	BpCCqu4JtAloiw=
X-Google-Smtp-Source: AGHT+IFpvoNVvIuGVZW7pKGl+iuAsqMxWnZwpLG8jZoAPt99z8wOXTWWP+d/25uNt9wvltkWSFCgDw==
X-Received: by 2002:a05:6e02:1945:b0:430:ae8a:40ae with SMTP id e9e14a558f8ab-430c5293567mr299326415ab.15.1761102360195;
        Tue, 21 Oct 2025 20:06:00 -0700 (PDT)
Received: from abc-virtual-machine.localdomain (c-76-150-86-52.hsd1.il.comcast.net. [76.150.86.52])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9629c16sm4660189173.27.2025.10.21.20.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 20:05:59 -0700 (PDT)
From: Yuhao Jiang <danisjiang@gmail.com>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuhao Jiang <danisjiang@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: aacraid: Fix DMA mapping leak in aac_send_raw_srb error paths
Date: Tue, 21 Oct 2025 22:05:37 -0500
Message-Id: <20251022030537.1298395-1-danisjiang@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The aac_send_raw_srb function creates DMA mappings for scatter-gather
buffers but fails to unmap them in most error paths, leading to DMA
mapping resource leaks.

This patch fixes all error paths except -ERESTARTSYS. The -ERESTARTSYS
case is a known design issue where resources cannot be safely freed
(hardware may still be accessing them) but also cannot be properly
tracked for later cleanup (they are local variables).

Fixed paths:
- copy_from_user failures during SG buffer setup
- aac_hba_send/aac_fib_send errors after DMA mapping
- copy_to_user failures after successful command execution

Fixes: 423400e64d377 ("scsi: aacraid: Include HBA direct interface")
Cc: stable@vger.kernel.org
Signed-off-by: Yuhao Jiang <danisjiang@gmail.com>
---
 drivers/scsi/aacraid/commctrl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 68240d6f27ab..e0495f278e2e 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -493,6 +493,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	void __user *sg_user[HBA_MAX_SG_EMBEDDED];
 	void *sg_list[HBA_MAX_SG_EMBEDDED];
 	u32 sg_count[HBA_MAX_SG_EMBEDDED];
+	dma_addr_t sg_dma_addr[HBA_MAX_SG_EMBEDDED];
+	int sg_dma_last_mapped = -1;
 	u32 sg_indx = 0;
 	u32 byte_count = 0;
 	u32 actual_fibsize64, actual_fibsize = 0;
@@ -690,6 +692,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			}
 			addr = dma_map_single(&dev->pdev->dev, p, sg_count[i],
 					      data_dir);
+			sg_dma_addr[i] = addr;
+			sg_dma_last_mapped = i;
 			hbacmd->sge[i].addr_hi = cpu_to_le32((u32)(addr>>32));
 			hbacmd->sge[i].addr_lo = cpu_to_le32(
 						(u32)(addr & 0xffffffff));
@@ -752,6 +756,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
+				sg_dma_addr[i] = addr;
+				sg_dma_last_mapped = i;
 
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
@@ -808,6 +814,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
+				sg_dma_addr[i] = addr;
+				sg_dma_last_mapped = i;
 
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
@@ -865,6 +873,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      usg->sg[i].count,
 						      data_dir);
+				sg_dma_addr[i] = addr;
+				sg_dma_last_mapped = i;
 
 				psg->sg[i].addr = cpu_to_le32(addr & 0xffffffff);
 				byte_count += usg->sg[i].count;
@@ -905,6 +915,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
+				sg_dma_addr[i] = addr;
+				sg_dma_last_mapped = i;
 
 				psg->sg[i].addr = cpu_to_le32(addr);
 				byte_count += sg_count[i];
@@ -986,6 +998,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 cleanup:
 	kfree(user_srbcmd);
 	if (rcode != -ERESTARTSYS) {
+		for (i = 0; i <= sg_dma_last_mapped; i++) {
+			dma_unmap_single(&dev->pdev->dev, sg_dma_addr[i],
+					 sg_count[i], data_dir);
+		}
 		for (i = 0; i <= sg_indx; i++)
 			kfree(sg_list[i]);
 		aac_fib_complete(srbfib);
-- 
2.34.1

