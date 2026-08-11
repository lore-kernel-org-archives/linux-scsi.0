Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F369643B6F1;
	Tue, 11 Aug 2026 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447218; cv=none; b=Lw8jDq9XYMs9URVK5e57DqbBGsgz7nMC4bojHJ2uIHHH3pNUOEuRt9jKP73QKb/C55dHSlVqy6jLpajD1QQcC/wZLzvzB+/3B96mdajE4kClK20XAIGyadG3Ybis+g0t3yPt9lo/39YtGFUQAUDAatSn8eLnHZbM6h/wdMpXog8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447218; c=relaxed/simple;
	bh=hP2q0fvYUyALODu9a8IWam9G5S5Skzuwf6D7a8ar4wg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CCj9tPOPXKEqyezY7vsw9qzQUJ36AiBNinOO68UG8DHYD1KKfR4/9xtib5pOLuBrlN/Yvr6+Z2IOPFSoDvqacK+bjnC7hN+5aTVQ6Igx0weDeQXRA2ji5xe/p1vcovh5rzoUbefD6ln+QZgV2e+JJy/uRe+XrYHh+j7QxVFuffo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9dc60394957611f1aa26b74ffac11d73-20260811
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:397b2e18-c2e3-4b38-8858-518d2482dd93,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:f5d4d9709f610d42177090eb9773e0d6,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9dc60394957611f1aa26b74ffac11d73-20260811
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 15344228; Tue, 11 Aug 2026 19:20:11 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: doubled@leap-io-kernel.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: hare@kernel.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 2/2] scsi: leapraid: serialize firmware log mmap with teardown
Date: Tue, 11 Aug 2026 19:20:01 +0800
Message-Id: <20260811112001.1158587-3-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260811112001.1158587-1-lilinmao@kylinos.cn>
References: <20260811112001.1158587-1-lilinmao@kylinos.cn>
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
 drivers/scsi/leapraid/leapraid_app.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
index 841027ce2501c..c124f9eaea6ea 100644
--- a/drivers/scsi/leapraid/leapraid_app.c
+++ b/drivers/scsi/leapraid/leapraid_app.c
@@ -171,7 +171,8 @@ static int leapraid_ctl_validate_sge_offset(struct leapraid_adapter *adapter,
 	return 0;
 }
 
-static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
+static struct leapraid_adapter *
+leapraid_ctl_lookup_adapter(int adapter_id, bool track_mmap)
 {
 	struct leapraid_adapter *adapter;
 	struct Scsi_Host *shost;
@@ -184,6 +185,8 @@ static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
 			shost = adapter->shost;
 			if (!shost || !scsi_host_get(shost))
 				break;
+			if (track_mmap)
+				atomic_inc(&adapter->fw_log_desc.mmap_refcnt);
 			spin_unlock(&leapraid_adapter_lock);
 			return adapter;
 		}
@@ -589,7 +592,7 @@ static int leapraid_ctl_ioctl_main(struct file *file, unsigned int cmd,
 		return -EFAULT;
 	}
 
-	adapter = leapraid_ctl_lookup_adapter(ioctl_header.adapter_id);
+	adapter = leapraid_ctl_lookup_adapter(ioctl_header.adapter_id, false);
 	if (!adapter)
 		return -EFAULT;
 
@@ -728,7 +731,7 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	length = vma->vm_end - vma->vm_start;
 
-	adapter = leapraid_ctl_lookup_adapter(adapter_id);
+	adapter = leapraid_ctl_lookup_adapter(adapter_id, true);
 	if (!adapter) {
 		pr_err("%s: No adapter found!\n", __func__);
 		return -EINVAL;
@@ -771,6 +774,9 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
 
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

