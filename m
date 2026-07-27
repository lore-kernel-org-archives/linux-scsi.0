Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09FE390987
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166045; cv=none; b=PyD6I8233p2rY1ePaVzCDDDf/ymOQ2eH6xHaOKvoTqab0LpOklj5W76q2rkrxs6KhrIfYlmnHXgrVvnRORNO6F/6FwEONlZAM9bUpiBR1OJQ8yAqW2HCJBSMZdS5B0kwN9KiDIU8iwlta7Pn/o6Gl+rn1Ac5Z1Nlz2hUKTSY+uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166045; c=relaxed/simple;
	bh=Swgn6s2kY7p2tvnBeuVFL1zLewFRMddlqXIih/LU3m0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pfPi4HWSKrxguwL8knH9dhTk2qXR6w3JuiUdiBqACIcXkuxIoa451CyM6/ERf491tsMVlqW21y5aJcGA+0FlB7jhhRV11q6+8wlL9+S8TZVP+LsFyoP6PhSocXf2K3UfjuUMH0P7OV42Ca74IZMC/xWMwZQRdYb1FRMVmKWvmKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKMtK+cV; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKMtK+cV"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ceae1ed204so30370025ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 08:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785166043; x=1785770843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KqISqetJ0Hj8Ab0QVlJRkGNZyqybFdl4vH7c2gdR6nQ=;
        b=MKMtK+cVoR3eXlrUZwE0zlSWXmlltG1t88urSbXYLfmKz1mmx5ZUhit7ihR8bkfnYe
         MNo2KP+yu7dusMxriGwAXeRtT5nmDiVr7rk0rjw4VUlo7yiP+GNJnUqleG7rtCtB38l9
         LDgW8LGYwufanI1D0DP/js+5qetpdzbS/JK7T/41OBvtxyt6mzIJ74HpuGVNvFwlccgq
         d8Nm7P5ThoZBNI/CmR0/WIP6QZSBnDrIX9BSyixk91zf9GSBnRJe6BnaFpf2zyAyZE/O
         bOnv3EbHLwyABzEVQY/Oa0I3THBKqgFIZqVYKbSGdrxOwSDgX+38fzuEnutM+MxU5y6/
         vESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785166043; x=1785770843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KqISqetJ0Hj8Ab0QVlJRkGNZyqybFdl4vH7c2gdR6nQ=;
        b=n/EDBnhOzP40uOcivtLMNmvqLqV8zWxfKp5PDNAXySGXTJIF0UqyULjLjGmKFx2k0r
         rOhAN5zFKgK4U++y86pI9ekZGHEc5/dF/XQ/+CoyQ2O1cjUoaOAuDFaHrE1u0TXKtG82
         41YH+k3wfYJ8sdIm3OyNM54jnbzSCRBwI3Y+/FU5XkVTGS/uOP2NcHLBdvkd+y/XVc7U
         TzcxhMe4QWS9+n/8VoyybsxtpqnsoiKYLu+9VVBacdcnGWJLxBvedXauz2x2Vkg9oB1S
         rOkNuZmyJwPOAIkhL5IhNajMiB3aqYdzyGcdqnPdEXEmUOoVpgUu3DFzbdpi48GfngXL
         azGQ==
X-Forwarded-Encrypted: i=1; AHgh+RpStaelzMN9e3fPuQVlBwGv06wMmwIRS1kgJWeqclgL6XcjyPBBncjcxKaxjK9osOM8jxvHdajTEKwr@vger.kernel.org
X-Gm-Message-State: AOJu0YyY5RRdyx0Ozb6rI7l1H9g/n/c0vxjxdcfZqEbDHZNSkLkW7iB+
	Rjt8S1I62BC2S2b+WsKvxsOv0f6LvidlwTEjoaMDfY28j3lXr32V201k
X-Gm-Gg: AR+sD12tiQQ7yYE18/z6SoClVZhLreysf6wNkxmbAgAROdWGXPpL4fCvSoKFuQUw6Jo
	KoxcSYGnrPgm9liy69T81GnrifWwX3qH/4uEAfYU5GI3NQQVqc0B81fXarIMnOuHGi/grBfHOW0
	Uka77cUBaTpHRhEBtwnP/RY3G1jgNAmMIqvqshO79hU75sgxvvtNFnJ6wymjVhrvqVwYP9w9kUz
	5sCAhuMvhxODPcZZs7y+H4eJSNoWfbHFKDPq0e9KbDZNV5M11ASVjDEQlnxZjH0WDUGULwmxx4/
	wIT/yx51FxCNzjTzfEXujLvS2cCCEOhTysshCUPOVbXYbHCHXofGBWa4n080bbhIcdOS4uXf9pC
	7f7Vsb8CEgtfBrEvz6hMDvPVyFmwo80ED/sDXWIGbWYISQhU5Wht2vNW9WD82JRnxkibi0cP7h7
	SmHeL8+hiTmE/PhZ/n+9d2ieZNSA==
X-Received: by 2002:a05:6a21:6005:b0:3c3:b57b:645e with SMTP id adf61e73a8af0-3c67d9b3e93mr8509256637.5.1785166042810;
        Mon, 27 Jul 2026 08:27:22 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.mshome.net ([104.43.2.12])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb660f4d8sm3389724a12.5.2026.07.27.08.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 08:27:22 -0700 (PDT)
From: Tianyu Lan <ltykernel@gmail.com>
X-Google-Original-From: Tianyu Lan <tiala@microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: Tianyu Lan <tiala@microsoft.com>,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	hch@infradead.org,
	robin.murphy@arm.com,
	vdso@hexbites.dev,
	mhklinux@outlook.com
Subject: [PATCH V2 1/1] x86/VMBus: Confidential VMBus for dynamic DMA transfers
Date: Mon, 27 Jul 2026 11:27:11 -0400
Message-Id: <20260727152711.2045-1-tiala@microsoft.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hyper-V provides Confidential VMBus to communicate between
device model and device guest driver via encrypted/private
memory in Confidential VM. The device model is in OpenHCL
(https://openvmm.dev/guide/user_guide/openhcl.html) that
plays the paravisor role.

For a VMBus device, there are two communication methods to
talk with Host/Hypervisor. 1) VMBUS Ring buffer 2) Dynamic
DMA transfer.

The Confidential VMBus Ring buffer has been upstreamed by
Roman Kisel(commit 6802d8af47d1).

The dynamic DMA transition of VMBus device normally goes
through DMA core and it uses SWIOTLB as bounce buffer in
a CoCo VM.

The Confidential VMBus device can do DMA directly to
private/encrypted memory. Because the swiotlb is decrypted
memory, the DMA transfer must not be bounced through the
swiotlb, so as to preserve confidentiality. This is different
from the default for Linux CoCo VMs, so not use DMA(SWIOTLB)
API in VMBus driver when confidential dynamic DMA transfers
capability is present.

Signed-off-by: Tianyu Lan <tiala@microsoft.com>
---
Change since v1:
	* Fix code style issue
	* Use co_external_memory flag in struct vmbus_channel
	   directly instead of adding new flag in the struct
	   hv_device.
---
 drivers/scsi/storvsc_drv.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6977ca8a0658..a3b22cba3421 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1326,7 +1326,8 @@ static void storvsc_on_channel_callback(void *context)
 					continue;
 				}
 				request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
-				scsi_dma_unmap(scmnd);
+				if (!device->channel->co_external_memory)
+					scsi_dma_unmap(scmnd);
 			}
 
 			storvsc_on_receive(stor_device, packet, request);
@@ -1815,7 +1816,7 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 		unsigned long offset_in_hvpg = offset_in_hvpage(sgl->offset);
 		unsigned int hvpg_count = HVPFN_UP(offset_in_hvpg + length);
 		struct scatterlist *sg;
-		unsigned long hvpfn, hvpfns_to_add;
+		unsigned long hvpfn, hvpfns_to_add, hvpgoff;
 		int j, i = 0, sg_count;
 
 		payload_sz = (hvpg_count * sizeof(u64) +
@@ -1831,10 +1832,14 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 		payload->range.len = length;
 		payload->range.offset = offset_in_hvpg;
 
-		sg_count = scsi_dma_map(scmnd);
-		if (sg_count < 0) {
-			ret = SCSI_MLQUEUE_DEVICE_BUSY;
-			goto err_free_payload;
+		if (dev->channel->co_external_memory) {
+			sg_count = scsi_sg_count(scmnd);
+		} else {
+			sg_count = scsi_dma_map(scmnd);
+			if (sg_count < 0) {
+				ret = SCSI_MLQUEUE_DEVICE_BUSY;
+				goto err_free_payload;
+			}
 		}
 
 		for_each_sg(sgl, sg, sg_count, j) {
@@ -1846,9 +1851,16 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 			 * Such offsets are handled even on other than the first
 			 * sgl entry, provided they are a multiple of PAGE_SIZE.
 			 */
-			hvpfn = HVPFN_DOWN(sg_dma_address(sg));
-			hvpfns_to_add = HVPFN_UP(sg_dma_address(sg) +
-						 sg_dma_len(sg)) - hvpfn;
+			if (dev->channel->co_external_memory) {
+				hvpgoff = HVPFN_DOWN(sg->offset);
+				hvpfn = page_to_hvpfn(sg_page(sg)) + hvpgoff;
+				hvpfns_to_add =	HVPFN_UP(sg->offset + sg->length) -
+							hvpgoff;
+			} else {
+				hvpfn = HVPFN_DOWN(sg_dma_address(sg));
+				hvpfns_to_add = HVPFN_UP(sg_dma_address(sg) +
+							 sg_dma_len(sg)) - hvpfn;
+			}
 
 			/*
 			 * Fill the next portion of the PFN array with
@@ -1870,7 +1882,7 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 	ret = storvsc_do_io(dev, cmd_request, smp_processor_id());
 	migrate_enable();
 
-	if (ret)
+	if (ret && (!dev->channel->co_external_memory))
 		scsi_dma_unmap(scmnd);
 
 	if (ret == -EAGAIN) {
-- 
2.50.1

