Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C21A3264C1
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2026 07:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775633474; cv=none; b=LQz6trJTbmPSyof8hsmdy5PP1yo2pvBQPdK1R+WD8KT2FVq66oPF0X9MJlvbG5/us7+vVSqRWzWtABQQhDEzVxcU/pOTxDnOSJRM/9iWAtoM0D2oeBi3NkfnZ+U2H+wfVWa6/WkGkqWCJz3t4+CsKCYlGEybHvFIm7LrJkSMzjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775633474; c=relaxed/simple;
	bh=ytB53dNuSiSNA7KpLGzUUg37w5+LYWgYBJoL01WyyRo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RiVQFd3hg3KVAJAH35KltzXSiLq64GhPqhCjWR8x3cMsq1srv2xBoRq3npBUy4ZL4xQ8fAdyiLubpdv91soKp4ZqyWs7uBlKkvGKBdpXicqNowDXzd47V9u2yt/pPea0P/u0tyz2h8fZNFcmDCYcUIJh9QCamQ4kt8aNjlbT1ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FfeVMJoV; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FfeVMJoV"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35d971fb6f1so5108422a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 00:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775633473; x=1776238273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MlstBpIKOzxoAPZSb6mPVzZ0DWzq15OlHmrRs8yLD0g=;
        b=FfeVMJoVmXRXMd10eUsz9UGYLuRl6HB/Tzs+JPJUXLpoQHQToZ/0RrLoslvTL7SbD6
         dzp8nivx7L0qElkCJOEFtNYGZ/t9Om+B/hBE0dcq+Ip9tRN36WcX1oGwiAV1+b9l9x7P
         fF1QVrxD/QYlhHvAtLzUZ/B/LSh8dmf6DFSWWtTH/L5BzTeD99Ycb5EnvvWyFNbdLt5D
         tg10V9FrYTY+kBhWs7Q2hz284hUfxJzqZQX0O06yqouFSe8rfSYndI4ZkzsR88P61LSp
         5KFbaKyQrauKTfxl43/ZoAZNaHOi6iAEN4wGbEx7ioBxldhkpX9uA6LGFMsTL2deInN2
         /U7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775633473; x=1776238273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlstBpIKOzxoAPZSb6mPVzZ0DWzq15OlHmrRs8yLD0g=;
        b=qO5nJCEybW6ZzIkDSUVmS69yofpfCr6HZouJX73QZ5CTuN48h1PwBiN0sEnXGTy9CX
         4CrOc6DiQlTGHvtgv/DVjBgO5Gc1Bjv2tcb3cbSzVMvBmuL19zyg+yNRXVV4IJCPmJW4
         +KzXddGqke5dM43D4zrZAAPGm1/+D4wZnhsLBWclFFS9hkUpd+ZbX0HtD2XzF2GvJsrX
         2xcJ8ZtMuz+6tdCQygLtgoXMe8248T8gt5bAcJifFGXn5m/KHDd0G6GxOvkdW+rNNUC7
         3vMYd6qsBgJx1/R87XshGM6cOXHjQ1P/sJAZpYQEudjOonMn3orglXAEq6XkSpYO49p5
         N46w==
X-Forwarded-Encrypted: i=1; AJvYcCXWmDX0lLW210UUp2qke+PgwRznSwpbJUf+OQYl4AtsPF35jlNQuxDlUInAMGdCWv3bZFOdg50swZVl@vger.kernel.org
X-Gm-Message-State: AOJu0YzwJau643dUxUr4OOdLccUOU+anhuASnv4L0rpA01vGJZGwomPs
	ind3bcD3oqIMNb+C1AZi8yoTDj1R5MKhxBYhzsc5TEgsXUDwU74yksll
X-Gm-Gg: AeBDietfN+y/aOr4OGmmq5sCEdXRZ35aBH4Ld2eXh2EICl8vjZJ2PR4MPAINqvkN7CY
	CvaP5VaUbIxFnaR1xDxSQOS8biXhPrSlbMYpyu1rIZXPeVNvNjZOmK5GJibpm96jHQGiugHw9lD
	UWi36KOM/CJztPXp0zFYrmNTK43jWmL8kJ0jbBJ1pfb0A+X/k/rFG2LfiOAWsjBQdW3OqAo1C18
	Lpxfh6epGIbcnLZAH+/OvXrkzfFUF8At3EgOgHuw7jhPHNz1GZKXB1ys5N9N2+Cd6AejSVmUUB9
	gq0DMji3B/XqSMbsOsL6PQiH2vgyDe3N0AAaI4iGvsTJzaqusSXyZSaRwjg9TvA1JGVePx6l1Sh
	OySI6gYa89M0w2aihdWIJF4TvQKlta7p4Kq19fR3J5naKbwflD7fG+cel8YMrcTTBB5530zDb4k
	/NPxur39dxJNBq6LVFZmsETyW9pT6Z6e6uYKKbyH+ei56u7vw=
X-Received: by 2002:a17:903:1a28:b0:2b0:c90f:44b2 with SMTP id d9443c01a7336-2b28173548amr214128665ad.12.1775633472474;
        Wed, 08 Apr 2026 00:31:12 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.mshome.net ([104.43.2.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2ae05991bsm47105515ad.70.2026.04.08.00.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 00:31:12 -0700 (PDT)
From: Tianyu Lan <ltykernel@gmail.com>
X-Google-Original-From: Tianyu Lan <tiala@microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	apais@microsoft.com
Cc: Tianyu Lan <tiala@microsoft.com>,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	vdso@hexbites.dev,
	mhklinux@outlook.com
Subject: [PATCH] x86/VMBus: Confidential VMBus for dynamic DMA transfers
Date: Wed,  8 Apr 2026 03:31:05 -0400
Message-Id: <20260408073105.272255-1-tiala@microsoft.com>
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
 drivers/scsi/storvsc_drv.c | 28 +++++++++++++++++++++-------
 include/linux/hyperv.h     |  1 +
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ae1abab97835..79b7611518b7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1316,7 +1316,8 @@ static void storvsc_on_channel_callback(void *context)
 					continue;
 				}
 				request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
-				scsi_dma_unmap(scmnd);
+				if (!device->co_external_memory)
+					scsi_dma_unmap(scmnd);
 			}
 
 			storvsc_on_receive(stor_device, packet, request);
@@ -1339,6 +1340,8 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 
 	device->channel->max_pkt_size = STORVSC_MAX_PKT_SIZE;
 	device->channel->next_request_id_callback = storvsc_next_request_id;
+	if (device->channel->co_external_memory)
+		device->co_external_memory = true;
 
 	ret = vmbus_open(device->channel,
 			 ring_size,
@@ -1805,7 +1808,7 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 		unsigned long offset_in_hvpg = offset_in_hvpage(sgl->offset);
 		unsigned int hvpg_count = HVPFN_UP(offset_in_hvpg + length);
 		struct scatterlist *sg;
-		unsigned long hvpfn, hvpfns_to_add;
+		unsigned long hvpfn, hvpfns_to_add, hvpgoff;
 		int j, i = 0, sg_count;
 
 		payload_sz = (hvpg_count * sizeof(u64) +
@@ -1821,7 +1824,11 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 		payload->range.len = length;
 		payload->range.offset = offset_in_hvpg;
 
-		sg_count = scsi_dma_map(scmnd);
+		if (dev->co_external_memory)
+			sg_count = scsi_sg_count(scmnd);
+		else
+			sg_count = scsi_dma_map(scmnd);
+
 		if (sg_count < 0) {
 			ret = SCSI_MLQUEUE_DEVICE_BUSY;
 			goto err_free_payload;
@@ -1836,9 +1843,16 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 			 * Such offsets are handled even on other than the first
 			 * sgl entry, provided they are a multiple of PAGE_SIZE.
 			 */
-			hvpfn = HVPFN_DOWN(sg_dma_address(sg));
-			hvpfns_to_add = HVPFN_UP(sg_dma_address(sg) +
-						 sg_dma_len(sg)) - hvpfn;
+			if (dev->co_external_memory) {
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
@@ -1860,7 +1874,7 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 	ret = storvsc_do_io(dev, cmd_request, smp_processor_id());
 	migrate_enable();
 
-	if (ret)
+	if (ret && (!dev->co_external_memory))
 		scsi_dma_unmap(scmnd);
 
 	if (ret == -EAGAIN) {
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index dfc516c1c719..bcb143766d6e 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1285,6 +1285,7 @@ struct hv_device {
 
 	/* place holder to keep track of the dir for hv device in debugfs */
 	struct dentry *debug_dir;
+	bool co_external_memory;
 
 };
 
-- 
2.50.1

