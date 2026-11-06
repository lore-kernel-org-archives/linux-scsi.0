Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793996991;
	b=FiIY2mPW9OxloVhCaTK8Mb1sNZutN6Av7Pelq8Eza9JLBYIfkdDPsbCR/kcrNYe08kO5
	 BC4xuNi3j2uapzu7HX0K7fpTRRM2T4BecMMCq0VIcF7fCS2BCwuWoxQkCw5L9AiBRGMe1
	 58HdXJiyY9ExlHDgHqRUNqO505oqi4ikXJSU0VCVGUWEfbVrbKzTcTDUe6EUFSCbRVJxo
	 pT9lRrjx17hH6/kjAUCDN+UO96vJK2KbtHKYyQA07ovv6OGyYYR5JcxJ5itbxS/BEL/gp
	 b5FBWAXGZ5rkOSmLgIqQ6Q+iVv9EpSdrZek3J7KoI0g02e5pj5r6PyDDvKHWLaYisog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793996991;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=DRYj0UOzChUmlvryovlnIJCjy5zBLHbrQxV+Mq7Dd54=;
	b=Ic7ku6Xr/l4NkhygQb/lQOZ5DPt+XG9BQxLaBxb8NNUCYc2BW7dAS+M3yneiE4+sWSAs
	 asQs2+85plzQJGAnqg4BNvAdm2ELrgT1rtATImq9QRfcV5X3ecv3ISCgGXnTKzfm/RE9p
	 CGCByY063hozWEggXv1vUS11/tdGYwxulp/qU4mzDlbNprv9kI/YBTg1ntngE5IlcS5Jd
	 0wLU9yKJq1D6UBo5MRXvXrtV+AHDBRyX1JOu9GkqR6kJPDa++bEddlJtDPRotAcsSEJx/
	 Tp9kTsfuTbK1hAQ8+jqy9GYh6TOVBxPibJZ8QoiWb7ejFSN9HgnlHILcME6ziO96hUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GEDzW24x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78819606A32C;
	Fri,  6 Nov 2026 20:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GEDzW24x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6461F008A3;
	Fri,  6 Nov 2026 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793996990;
	bh=DRYj0UOzChUmlvryovlnIJCjy5zBLHbrQxV+Mq7Dd54=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GEDzW24x0AqVl7R2HV75ZAQFXWigxwQa5nQZZ8Krgr9VZpifabDSTSfvH0Tc7FWE6
	 pncQvVY8W1z6RzUIFgfJQvElEeMdMn4u5QKqzSAbe0UBugYrBwJAI8p8ThDrjSdGTt
	 gPUJ4muaF7hEwk451UtIfNGNMOJAmy208EEXWN3mCDrowuq9UnemehcMU53JsPfiZR
	 koBVhYavbyX9OlyAty47FUKdXDwGptJ99yk0xWaW8w5FYmakwhIvkuvLekVAWuKnGq
	 CF7ojRtvo3mJESuw9hzLy732Y3rF0zYDO2DbJJNKmccN/tk0ast4AHRcofJYbrg0Fh
	 p4hk9zVjYLJzw==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 06 Nov 2026 15:29:26 -0500
Subject: [PATCH v3 1/2] scsi: mpt3sas: Serialize interrupt-time sdev block
 with hostdata teardown
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-sas-abba-v3-1-571b854594aa@kernel.org>
References: <20261106-sas-abba-v3-0-571b854594aa@kernel.org>
In-Reply-To: <20261106-sas-abba-v3-0-571b854594aa@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Keith Busch <kbusch@kernel.org>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5340; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=G9K/vOWTlLZPhlqkazOXYsAtIxaP4/uffWcLVANe0J8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7ji7ltEZPPQzJe26H1/ZUv5CmhjvxdjGyqcYR
 IX2YtlsQnOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCau44uwAKCRAADmhBGVaC
 FTM/D/9hX/2IrQT6cgIKtvTuTh8zqQMmjmlrLyCtSe4RKozApuwYvXjs8HB93ZR2xdgGKPbApru
 fG3ZL4wTrnO/EYPI/4L22KOBk1ef209sJGQy12pXIgOpnmsf39fnTF9OCsLBT5sT+/JKUZw0ocW
 zp93g/qcTV1Oz/DA0pXJTEDAeVmpfT6LiLx2/20gr+KullS33JrvTAW6QH53OGu9ZbGCLXBLh7S
 EPo8IgD5CTcB4aRnzONH8s4ChA0Bl3LxFgYPL9T8Jxqzls6j8Jegg5htEk6qi6ZXCvKYbnWYZ4M
 B5a3DOF3pC07oLsBYEqlV/Y7ogYCo1M2+qPTcb7IKUMPBqFSm/UNiE/3sHacAZEN8NFYGIZ7ntA
 TtDxD51gltsCTN6Kn6My1Qfhw0PI/bijrnM7AU/wgZ8ffOJ3eABU3YSHondIUcyaxjxgh43jX0i
 ZXTS/WxN9yYu8A3H0Fl3x3eWqYJVLKrQJrqvyYaYbjsXt/ex8mBZv64f6APnPmJLliqjA9B/aW+
 6lf9Ny3LPPb9AAIWdfNXNSr+fE5zPAXTNrlBHfn5gWj83Xs5zo128ZvqSAQbrQB9QZnYpakKU5j
 16rEHfBJZiC4OJs2pVlapROy66WN11yc72TZrZP/CG18ggd1NLeVBTqm3xcPLjX+GH39W+W4DHy
 sMp8ZG3afrYEqRw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

On DELAY_NOT_RESPONDING, the event callback runs _scsih_block_io_device()
at interrupt time. It walks the sdevs with shost_for_each_device() and
uses sdev->hostdata and its sas_target, with no lock held.

The sdev reference only pins the scsi_device. __scsi_remove_device() can
still call ->sdev_destroy() concurrently, e.g. when a scan fails to
probe a new LUN, and scsih_sdev_destroy() frees hostdata, leading to a
use-after-free. The target's hostdata is freed in scsi_target_reap(),
after sdev_destroy.

Add ioc->block_lock. Take it in _scsih_block_io_device() for each sdev,
and around setting and clearing sdev->hostdata in scsih_sdev_init() and
scsih_sdev_destroy(). The sdev is on shost->__devices before sdev_init,
so publishing under the lock also orders the sas_target store. While
hostdata is non-NULL under the lock, it and its target are live.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 30 ++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 47255bf9cdda..419fdf164fc6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1249,6 +1249,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @pcie_device_list: pcie device object list
  * @pcie_device_init_list: pcie device object list (used only at init time)
  * @pcie_device_lock:
+ * @block_lock: serializes sdev blocking against sdev hostdata teardown
  * @io_missing_delay: time for IO completed by fw when PDR enabled
  * @device_missing_delay: time for device missing by fw when PDR enabled
  * @sas_id : used for setting volume target IDs
@@ -1482,6 +1483,7 @@ struct MPT3SAS_ADAPTER {
 	struct list_head pcie_device_list;
 	struct list_head pcie_device_init_list;
 	spinlock_t      pcie_device_lock;
+	spinlock_t	block_lock;
 
 	struct list_head raid_device_list;
 	spinlock_t	raid_device_lock;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a77bbc3d2b66..60c9cf679a8a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2119,12 +2119,17 @@ scsih_sdev_init(struct scsi_device *sdev)
 	sas_target_priv_data = starget->hostdata;
 	sas_target_priv_data->num_luns++;
 	sas_device_priv_data->sas_target = sas_target_priv_data;
+
+	shost = dev_to_shost(&starget->dev);
+	ioc = shost_priv(shost);
+
+	/* _scsih_block_io_device() may already see this sdev */
+	spin_lock_irqsave(&ioc->block_lock, flags);
 	sdev->hostdata = sas_device_priv_data;
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
 	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT))
 		sdev->no_uld_attach = 1;
 
-	shost = dev_to_shost(&starget->dev);
-	ioc = shost_priv(shost);
 	if (starget->channel == RAID_CHANNEL) {
 		spin_lock_irqsave(&ioc->raid_device_lock, flags);
 		raid_device = _scsih_raid_device_find_by_id(ioc,
@@ -2176,6 +2181,7 @@ scsih_sdev_init(struct scsi_device *sdev)
 static void
 scsih_sdev_destroy(struct scsi_device *sdev)
 {
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
 	struct Scsi_Host *shost;
@@ -2218,8 +2224,11 @@ scsih_sdev_destroy(struct scsi_device *sdev)
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
 
-	kfree(sdev->hostdata);
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	sas_device_priv_data = sdev->hostdata;
 	sdev->hostdata = NULL;
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+	kfree(sas_device_priv_data);
 }
 
 /**
@@ -4234,26 +4243,30 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
 	struct _sas_device *sas_device;
+	unsigned long flags;
 
 	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
 
 	shost_for_each_device(sdev, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
-			continue;
+			goto next;
 		if (sas_device_priv_data->sas_target->handle != handle)
-			continue;
+			goto next;
 		if (sas_device_priv_data->block)
-			continue;
+			goto next;
 		if (sas_device && sas_device->pend_sas_rphy_add)
-			continue;
+			goto next;
 		if (sas_device_priv_data->ignore_delay_remove) {
 			sdev_printk(KERN_INFO, sdev,
 			"%s skip device_block for SES handle(0x%04x)\n",
 			__func__, sas_device_priv_data->sas_target->handle);
-			continue;
+			goto next;
 		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 
 	if (sas_device)
@@ -13539,6 +13552,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->raid_device_lock);
 	spin_lock_init(&ioc->pcie_device_lock);
 	spin_lock_init(&ioc->diag_trigger_lock);
+	spin_lock_init(&ioc->block_lock);
 
 	INIT_LIST_HEAD(&ioc->sas_device_list);
 	INIT_LIST_HEAD(&ioc->sas_device_init_list);

-- 
2.56.0

