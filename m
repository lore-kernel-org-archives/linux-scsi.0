Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043416;
	b=lJcZTi3EPy1blTxMOWyCfSAq1w/T8B0w0QAT891s7tJSOrC1c3e1NHZ7dxzXLvVgQUEl
	 dqKL8QqIEQwOQMynfHfyiDM/Ckh9YjokNUb5wEHQR9v9W07HocnmBPTHcKc46ChllxH2d
	 Y7X6Ae0PvInUJUYOUep1kLyzGVNWsrSCLqf7zbS9UhYNd0E0Vx6e+2PnQI+l6hUwt4UqR
	 wEvDwhyz8XrbPPn1DOW22AJeiq05/lh5VDFWyNJeLdtPqMXxy49QnJVx3hEebC5XXnIxl
	 pgpKBJJHXz13oXRTN2MDXfSRW/wPyUWDCE2nZCJ8IkMIIZEd+TkGou035VdARJUbfCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043416;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=lCORn1V52AHs1JTiH6PZyHNYOtYlzdKJZh6WhMxEQyg=;
	b=DsY2iF8wDFToiEE+/O0pkhONljCm1Lx1mMzWX34HoeJcN3HsqXFOG/2gi/PyCcTIShya
	 y5B0z6ynQnTGARVaSUhQZL+HW4le+ATJ7zlErkgNSbnwyPRpMHwDfOJvb9lgqPnq4MNOX
	 T8tzpkkvUc1moPpgVaTiMU4AY5BK+h/FbFNFjKf8nfvK+DOYRNkQQUxU+mf3RhpB9vW1c
	 NRT7zgIXe7iN7vB6v4aR82n/ALnmRoOANrFZav+Dc+Rz19UBUQU4AhXUgPj6wM29mwsAE
	 R/Cp7t6s+FzjDqysxE+7TpUZYznWIXFgFTS3828EW1YiNqgzp/Cdi6y+JFWXr469+UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="a9QZ//H2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B04E606A337;
	Wed, 18 Nov 2026 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9QZ//H2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DB71F00927;
	Wed, 18 Nov 2026 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043416;
	bh=lCORn1V52AHs1JTiH6PZyHNYOtYlzdKJZh6WhMxEQyg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a9QZ//H2pA+fxcVUZww5B3e3Xxp6fA1OLNhNZp5tlFnKSnhfEXO7joPMQ0agETrYv
	 HLEkDTylyCevWVvzFplFPrhQu7U7Hilp+r6fhQnz81j0ojBhoPcg8FlzDKljKE1F7m
	 8Ksedoyr8iUPw43J56PlYhodPjTjm1LGtSdrxkULyioJaJ5IWeGE6xTrOPJ8cX/+qp
	 DbWIp2yKLZEd89jGLSaXBM3vOCxcyMImDqa3W8leGh0wexF8FWcfBJmGfYvymTWV/U
	 FR5bFeioxinp1AHCgZmev2t+9RjbnHHYz8awgieUGrkqOSdh3x/hB78l5M4S6w0PXS
	 Irc3PIWunswuA==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:06 -0800
Subject: [PATCH v3 09/11] scsi: mpt3sas: Serialize interrupt-time sdev
 block with hostdata teardown
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
Message-Id: <20261118-sas-abba-v3-9-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5427; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Q6lma4UbxR9komlJMg2JmbOO32FmedfzbBaipPExT1M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBR2aPb30+SjLRmDOmWnsm4Lk8iEvHZq2EVl
 zDY+9OU96CJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUQAKCRAADmhBGVaC
 FSLfD/oDd3qehe73v96YpAb7le9w3m6d3CQgVPicb+qFvrnH0ubOUKP9aGLElEVheOgu32PBrKC
 3NYNjaKN220S5ldyHazEBZREr3rXGAMc0BPdvywDfAmi7tHX1U+OUlAgQ+hLHbxl6Ic1bYpkcHf
 a8urbjUxkGW1q2UMwXNlw3IiIsC44MXwpCWIqNuQ3Q9TaP2DUJVPkdwlZdNUiW+Jst2v3R9tIuG
 7pn5iXZ7ttGu+8Ib+6skhI/VjY5olfnUV2j3y986lqD6s5TrQWsKTthLQlUuPdcUnkNWPEH9Fbl
 t9hfWn/TTvxCYD0nF7sZ9TWHjfVdNHj0dSzG5rT69GjOustSuLijiPi0R8OI43RAABVloX+Qlp0
 hHGkHN2L0HJKHP0eKPdJqBlbXCqyYclvCrwEqJcNms98PT2ZqeD6e0PEq57Q/drHGYIzhf/f7Ap
 tEdWa8A/G8KDD5wSFGK6Hu3dr3kQ48J9htWx3WPPBUa/rxqpe2mLVR/kimKVIjTM0RTdp/mvR3c
 v3KK1idJHbMrkHejktXTHig7uf+UHoennMTTRGU3hwNl+AH+RuDl8gnloE+b3fF/onRDXOzQmc4
 z6uY2Y+fUl9ngQmgkjEuEB57nl/BrEdLUtwcj6MNI3bXY+wREfh70ui6BYmf62IePoSOCiwOKPY
 AIdoLACqHTI+y+A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

On DELAY_NOT_RESPONDING, the event callback runs
_scsih_block_io_device() at interrupt time. This function walks the
sdevs with shost_for_each_device(). It uses sdev->hostdata and its
sas_target, and holds no lock.

The sdev reference pins only the scsi_device. __scsi_remove_device()
can still call ->sdev_destroy() at the same time, for example when a
scan fails to probe a new LUN. scsih_sdev_destroy() frees hostdata,
which causes a use-after-free. scsi_target_reap() frees the hostdata of
the target, after sdev_destroy.

Add ioc->block_lock. Take it:

 - in _scsih_block_io_device(), for each sdev
 - around the code that sets and clears sdev->hostdata in
   scsih_sdev_init() and scsih_sdev_destroy()

The sdev is on shost->__devices before sdev_init. Because the driver
publishes hostdata under the lock, the lock also orders the sas_target
store. While the lock is held and hostdata is non-NULL, hostdata and
its target are live.

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
index 1269446eec4e..09dfa3124ebf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2132,12 +2132,17 @@ scsih_sdev_init(struct scsi_device *sdev)
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
@@ -2189,6 +2194,7 @@ scsih_sdev_init(struct scsi_device *sdev)
 static void
 scsih_sdev_destroy(struct scsi_device *sdev)
 {
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
 	struct Scsi_Host *shost;
@@ -2231,8 +2237,11 @@ scsih_sdev_destroy(struct scsi_device *sdev)
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
@@ -4384,26 +4393,30 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
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
@@ -13697,6 +13710,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->raid_device_lock);
 	spin_lock_init(&ioc->pcie_device_lock);
 	spin_lock_init(&ioc->diag_trigger_lock);
+	spin_lock_init(&ioc->block_lock);
 
 	INIT_LIST_HEAD(&ioc->sas_device_list);
 	INIT_LIST_HEAD(&ioc->sas_device_init_list);

-- 
2.56.1

