Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C61A3B2D18
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 22:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400882; cv=none; b=XQBSLWnjR61TqrHKa3rBf6x1IiFwuv5nsRkQ0TL5peDTLfxj/b2ezvTrsPlCgtUNzianR4UUOz7FLY47CVrXRUEAKiKewZqxkBlmqPBZH2IreN1BLti2i0yo9y4O7jvTb3XL199CtQF/KO2ezRo/dauHsA2zeT8S4jlhHtN020M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400882; c=relaxed/simple;
	bh=ocpeLQwBB2IKGxQapgMf/muYO0QsC5x7yDT2DqMNh1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K91CXaFH/kUg6rkew82Q9TJcgcg1H4nGR69/4xTE7QhGbUjcz/zwR8u7zMvHrh9qc03CMFe57lWxB3JcUwKEmrcr5SsRrC0k1kylG/faXoPtrH1Kl8KiMO5Uy0L0x1hhtfZvopTMZgD8kXgImTDIciDjzXCmCIYf1dLcp6WkkWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FW68crmj; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FW68crmj"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cf50c6f235so2500905ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 15:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786400880; x=1787005680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EoJvKfC835hK+lVOdLfMGNXk8KCDAst2Mgrk/StD0vQ=;
        b=FW68crmjBpYp4r9ZGIStHFTd4J6tQOd7Y7oN/E7y2EiMbaM5EV4e0UEbYk+PIDgglV
         XYHDw/P/h2dfJiSFQu4eqxBo5TOtNOIe3S9hUtKhcBUbp5ZqgXubTV5Wds/Xe3XPpv4L
         DO0jXICvKCm/vm5ET3PK9jV5EAPB/zdjgIqNulgRmjh9r6f29tvmz/osGU+MkYU1nL9D
         zLAmYkKwfcLL1BQFM2YUehdP0CZLFheOTnen9ASJaHcWiRo7rJ1bbLplO2hHtyIiZbhg
         KQNRb/sRPUW4Tnms+wAT76simmGrjoXxRFNMpr3Jw0MMkOm347BvB2FuQKpJaQESAg5n
         wfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400880; x=1787005680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EoJvKfC835hK+lVOdLfMGNXk8KCDAst2Mgrk/StD0vQ=;
        b=o0XYYChZR2/9GvB72LYulw7XtLeamLNmyMAR0RFsiYGTL7D8gq0wa7o0W6t0ouZ0fM
         JTF3tKWnFaD8LjUXKcZbZ3FcDfmhfAcHLs0ygcGLMLmk5uyclrlQzrcNwuqqBaJq8veN
         ccrVCPBVxsLhXtd9bTUT+/4mJDfEF8MSubMs0kSfSV7/lhJ3oooqUdVuCJw4aKeEUNaD
         f8ltzBokzQNp7aZjzDuNEJf+5tyUtO9zV76YLP3o+HOT/Czy9zJuoSPTfbpC5kYZv64+
         qthNbUEDwvmWRoYjoUo7CH66FSWWRHW5G3L0fLoagypxwZijCzA4MZN/FujgWGY0mDjN
         ldZw==
X-Gm-Message-State: AOJu0YwLDP1Uu1zqn1eTQa/6j6cRJLCedDbaIYQgLcpDYt0EeguIktq3
	RYAdbSoV1/G6+AI2yQhAnSWFB9JS8hsnOinjbN9+4OeQugO9U95y5d7a
X-Gm-Gg: AR+sD12Z40cQAqQitcS3h1I83Qhh+3mjyc2YkuKUg464sYZJ6gwf/KwJzcykM98LDlt
	riuNqG/jlY8/iOwRNtEBK5LcOTP5o+fyaNwZNxgFs7KEcrtbrS7gDdneaDSbrFnYqJSyWFT/yYy
	cKazcuPXl/7jJxJ/SaMgEX9i4S9fL9WLUTGKHWg0ZtfpBqYo/H7VofWw7M1sjbYI7Cgp/BMAbQg
	TbYIAWLUPPdaGmsXkJSSxCsrq9eu6Y5n6debnPwkm7L0vo+SUCoDo6SxsutnsXlg7d4eY0W19h4
	HnacIr1h8DJhcmIRkCIEyImaYXZPKjjGMo83kwzJG9I1iGroA8YWCkix+5D8cXDyQ4ar4+pH3W5
	dDWlQ/nvvr5Dl3n0a23M84EOu6W8zxyynLrNEFk/akipZQ3ISkR9qsZ/PR5303ofphXQ7WDYLuL
	tUlB31GvGmB94vqWFXtM6UPory/LE9UIh4gfblKmLC1Sf4nTloAxNjH6RQD65JwBwDA9k9p/jlb
	rKYBep4e6l5iRj8/bGEPZCYzEZQQUMT2xejS+D+GpEhlxZYwo3TxIdPk/MX
X-Received: by 2002:a17:902:e94c:b0:2c8:4c29:afeb with SMTP id d9443c01a7336-2d0ca7b5520mr594494185ad.8.1786400879796;
        Mon, 10 Aug 2026 15:27:59 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d15ecf2496sm40870595ad.58.2026.08.10.15.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 15:27:58 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH v2] scsi: aacraid: fix DMA mapping leak in aac_send_raw_srb()
Date: Mon, 10 Aug 2026 16:27:38 -0600
Message-ID: <20260810222738.26278-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260809033449.286233-1-skunkolee@gmail.com>
References: <20260809033449.286233-1-skunkolee@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aac_send_raw_srb() maps each scatter/gather entry for DMA via
dma_map_single() across five separate code paths, depending on the
adapter type and SG format (native HBA, 64-bit host SG, 32-bit host
SG, and two legacy formats). None of these mappings are ever undone:
there is no dma_unmap_single() call anywhere in the file, on the
success path or any of the error paths that funnel through the
single cleanup label.

Every FSACTL_SEND_RAW_SRB ioctl that submits at least one SG entry
therefore leaks that many DMA mappings permanently. Under an IOMMU
or SWIOTLB this is a genuinely exhaustible resource: sustained use
(e.g. periodic smartctl -d aacraid,... polling) eventually drives
new DMA mappings to fail, surfacing as intermittent I/O failures
(aac_fib_send failing with -ENOMEM) and, left long enough, adapter
resets and system instability.

Fix this by tracking the DMA address returned from each of the five
dma_map_single() calls in a new per-entry array (sg_addr[]). Each
entry is initialized to DMA_MAPPING_ERROR and checked with
dma_mapping_error() immediately after mapping, bailing out to
cleanup on failure rather than using a possibly-error address.
Entries are unmapped exactly once: for SRB_DataIn (hardware writes
via DMA), each entry is unmapped immediately before its
copy_to_user() in the existing per-entry loop, since on
non-coherent architectures dma_unmap_single() performs the cache
invalidation needed before the CPU can safely read what the device
wrote; unmapping only later in cleanup, after that read, could
return stale pre-DMA-completion data to userspace. Entries handled
this way are marked DMA_MAPPING_ERROR again so cleanup does not
unmap them a second time. All other entries (SRB_DataOut-only, or
any entry on an error path that never reaches the DataIn copy loop)
are unmapped once in cleanup, guarded by the same sentinel check.

v1 of this patch used 0 as the "unmapped" sentinel and unmapped
every entry only in cleanup, after any copy_to_user() had already
read from it. Both were wrong: 0 is a valid DMA address on some
platforms (DMA_MAPPING_ERROR is ~(dma_addr_t)0, not 0), so a mapping
that legitimately returned address 0 would never be unmapped; and
unmapping only in cleanup meant SRB_DataIn transfers could read
stale, not-yet-cache-invalidated data on non-coherent architectures.
Both issues were caught in review by an automated reviewer
(Sashiko AI) on the v1 submission.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220504
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 drivers/scsi/aacraid/commctrl.c | 43 +++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index bd82aeb679ae..27482d98c6fd 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -492,6 +492,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	u32 data_dir;
 	void __user *sg_user[HBA_MAX_SG_EMBEDDED];
 	void *sg_list[HBA_MAX_SG_EMBEDDED];
+	dma_addr_t sg_addr[HBA_MAX_SG_EMBEDDED];
 	u32 sg_count[HBA_MAX_SG_EMBEDDED];
 	u32 sg_indx = 0;
 	u32 byte_count = 0;
@@ -517,6 +518,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	}
 
 	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
+	for (i = 0; i < HBA_MAX_SG_EMBEDDED; i++)
+		sg_addr[i] = DMA_MAPPING_ERROR; /* mark all entries unmapped */
 	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
 		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n"));
 		rcode = -EFAULT;
@@ -690,6 +693,11 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 			}
 			addr = dma_map_single(&dev->pdev->dev, p, sg_count[i],
 					      data_dir);
+			if (dma_mapping_error(&dev->pdev->dev, addr)) {
+				rcode = -ENOMEM;
+				goto cleanup;
+			}
+			sg_addr[i] = addr;
 			hbacmd->sge[i].addr_hi = cpu_to_le32((u32)(addr>>32));
 			hbacmd->sge[i].addr_lo = cpu_to_le32(
 						(u32)(addr & 0xffffffff));
@@ -752,7 +760,11 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
-
+				if (dma_mapping_error(&dev->pdev->dev, addr)) {
+					rcode = -ENOMEM;
+					goto cleanup;
+				}
+				sg_addr[i] = addr;
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
 				byte_count += sg_count[i];
@@ -808,7 +820,11 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
-
+				if (dma_mapping_error(&dev->pdev->dev, addr)) {
+					rcode = -ENOMEM;
+					goto cleanup;
+				}
+				sg_addr[i] = addr;
 				psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
 				byte_count += sg_count[i];
@@ -865,7 +881,11 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      usg->sg[i].count,
 						      data_dir);
-
+				if (dma_mapping_error(&dev->pdev->dev, addr)) {
+					rcode = -ENOMEM;
+					goto cleanup;
+				}
+				sg_addr[i] = addr;
 				psg->sg[i].addr = cpu_to_le32(addr & 0xffffffff);
 				byte_count += usg->sg[i].count;
 				psg->sg[i].count = cpu_to_le32(sg_count[i]);
@@ -905,7 +925,11 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				}
 				addr = dma_map_single(&dev->pdev->dev, p,
 						      sg_count[i], data_dir);
-
+				if (dma_mapping_error(&dev->pdev->dev, addr)) {
+					rcode = -ENOMEM;
+					goto cleanup;
+				}
+				sg_addr[i] = addr;
 				psg->sg[i].addr = cpu_to_le32(addr);
 				byte_count += sg_count[i];
 				psg->sg[i].count = cpu_to_le32(sg_count[i]);
@@ -932,6 +956,11 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 
 	if (flags & SRB_DataIn) {
 		for(i = 0 ; i <= sg_indx; i++){
+			if (sg_addr[i] != DMA_MAPPING_ERROR) {
+				dma_unmap_single(&dev->pdev->dev, sg_addr[i],
+						 sg_count[i], data_dir);
+				sg_addr[i] = DMA_MAPPING_ERROR;
+			}
 			if (copy_to_user(sg_user[i], sg_list[i], sg_count[i])) {
 				dprintk((KERN_DEBUG"aacraid: Could not copy sg data to user\n"));
 				rcode = -EFAULT;
@@ -986,8 +1015,12 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 cleanup:
 	kfree(user_srbcmd);
 	if (rcode != -ERESTARTSYS) {
-		for (i = 0; i <= sg_indx; i++)
+		for (i = 0; i <= sg_indx; i++) {
+			if (sg_addr[i] != DMA_MAPPING_ERROR)
+				dma_unmap_single(&dev->pdev->dev, sg_addr[i],
+						 sg_count[i], data_dir);
 			kfree(sg_list[i]);
+		}
 		aac_fib_complete(srbfib);
 		aac_fib_free(srbfib);
 	}
-- 
2.55.0

