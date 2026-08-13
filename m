Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DF7439F73;
	Thu, 13 Aug 2026 07:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786605996; cv=none; b=jkjbpwtXbA6Cu+Gc0uNCHYJk4QqSNgonF61FX5hhrm3Oc3DcQanopBt7R4swPk1TwhFI2nsXPnUaxSDgESL3V3OoJAjN3FAcugQs0/wh4srVlOJAR11eje5gJvgsslFykluv1eMVJFrFhhyR4oFT/D6obnDSMTXlqimLHjCTYeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786605996; c=relaxed/simple;
	bh=jXlLBi2xaglIbDtLHE0zO1dmTguB7J4SeRh65nGAEtY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qg+Q+0uhW5Yp8ZtUTcvZZgXGmgzZlPjYzrfRfrPPVM04Xz7ArzFqUHKxYEEk5EWdBANGbz/XyHu/FY/Mb4W4ybYZS3fJIpITwzYZvf0oSf65ME1B3XukeU7TrqhpGVZnRjOiTCjvHJs91wV9Epx/DWD3lh4mAmaT3nbAouLmAN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4a4871d496e811f1aa26b74ffac11d73-20260813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:49ba96fd-52b2-4ede-878a-07c6e18f8493,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:36d3ffba1c89fa2f94277309e926479a,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4a4871d496e811f1aa26b74ffac11d73-20260813
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1832890987; Thu, 13 Aug 2026 15:26:24 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: doubled@leap-io-kernel.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: hare@kernel.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH v2 2/2] scsi: leapraid: serialize firmware log mmap with teardown
Date: Thu, 13 Aug 2026 15:26:14 +0800
Message-Id: <20260813072614.1387555-3-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813072614.1387555-1-lilinmao@kylinos.cn>
References: <20260813072614.1387555-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

leapraid_fw_log_exit() waits for mmap_refcnt to reach zero before it
frees the firmware log buffer.  leapraid_fw_mmap() checks
host_removing, but it does not increment mmap_refcnt until after
dma_mmap_coherent() succeeds and the VMA open callback runs.

Removal can set host_removing and observe a zero mmap_refcnt between
the check and the VMA open.  It can then free the coherent buffer while
the mmap path is still establishing a userspace mapping of it.

Claim a temporary mmap reference while looking up the adapter under
leapraid_adapter_lock.  Removal deletes the adapter from the same
locked list after setting host_removing, so a mapping is either
rejected or included in the count that removal waits for.  Drop the
temporary reference on the common exit path, after a successful VMA
open has acquired the reference covering the VMA lifetime.

Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/scsi/leapraid/leapraid_app.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
index 841027ce2501c..790a3191e9259 100644
--- a/drivers/scsi/leapraid/leapraid_app.c
+++ b/drivers/scsi/leapraid/leapraid_app.c
@@ -171,7 +171,7 @@ static int leapraid_ctl_validate_sge_offset(struct leapraid_adapter *adapter,
 	return 0;
 }
 
-static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
+static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id, bool track_mmap)
 {
 	struct leapraid_adapter *adapter;
 	struct Scsi_Host *shost;
@@ -184,6 +184,8 @@ static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
 			shost = adapter->shost;
 			if (!shost || !scsi_host_get(shost))
 				break;
+			if (track_mmap)
+				atomic_inc(&adapter->fw_log_desc.mmap_refcnt);
 			spin_unlock(&leapraid_adapter_lock);
 			return adapter;
 		}
@@ -589,7 +591,7 @@ static int leapraid_ctl_ioctl_main(struct file *file, unsigned int cmd,
 		return -EFAULT;
 	}
 
-	adapter = leapraid_ctl_lookup_adapter(ioctl_header.adapter_id);
+	adapter = leapraid_ctl_lookup_adapter(ioctl_header.adapter_id, false);
 	if (!adapter)
 		return -EFAULT;
 
@@ -728,7 +730,7 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	length = vma->vm_end - vma->vm_start;
 
-	adapter = leapraid_ctl_lookup_adapter(adapter_id);
+	adapter = leapraid_ctl_lookup_adapter(adapter_id, true);
 	if (!adapter) {
 		pr_err("%s: No adapter found!\n", __func__);
 		return -EINVAL;
@@ -771,6 +773,9 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	rc = 0;
 out_put:
+	if (adapter &&
+	    atomic_dec_and_test(&adapter->fw_log_desc.mmap_refcnt))
+		wake_up(&adapter->fw_log_desc.mmap_waitq);
 	leapraid_ctl_put_adapter(adapter);
 	return rc;
 }
-- 
2.25.1

