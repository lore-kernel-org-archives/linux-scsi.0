Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793626868;
	b=EQvTAdzWXH4a8q6nqKYNyLdqVNkasCfNUteNlhWBXA+8D1aegAYF2u/rBWUwLklu+/s7
	 r+NBnxxVmTNqxQ+o0bg+v1Ss+WsW5A5EkCrtuFUga1jcGO1bGrTSQtal76Yn8RMcyrJjL
	 owkMYuKed517+Z2mrEnNgyTARVhXzJgov47QPFF/TUAHjH2LeWqZ/OiOWZ7ankxIZ8TF0
	 9us4FfIlg3LoWU/8sU36dJ9Fc2LEQsWZGuK9tSIoZntyV2ixfrkjEg26s+miZnVnTZ32v
	 4LOZassiKBM34PK0DtpV9Wv4bfZWnwrl2Ujaz3q+BpyQoaGWH2VK/HNULNBeEh4fa9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793626868;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=rVnhiYvmXSErfddDwbB5BDtIZVGqAlWLXuZOVs0oMo4=;
	b=a2UmYYhQo9lYNtBki23HWVMYp9Y6p8o09yO8AE2cyrOvCwD8YM2qIIBDQBUes/91S4sn
	 OOa2CumiZgCX0vj2OdbuOTMxdF+QN5szAwdbqmS2eB68bu7KUHeQM4Vy2PloESAbCB1En
	 Cf7/JUP3j5si9j4Lf3lpUwKzjGHe1iI5x0mXGzfMcD9Bd59I+ALmYzrCpjagT8bfKH0HF
	 Gtp7dJPOsmmFnJLeqPHWj1MvZBx82S06mrKd7kcu7Q2WjAXybElOXw0TBO966q99ROEsn
	 XKufHvKLAcy5/AecVmKFMSRpS/mx6BBiIAsiXwDRzaSxswWQu+WJX2eMS1+gD5mQSfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EJdJ1R7R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA9A606A339;
	Mon,  2 Nov 2026 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EJdJ1R7R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA0D1F0157E;
	Mon,  2 Nov 2026 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626868;
	bh=rVnhiYvmXSErfddDwbB5BDtIZVGqAlWLXuZOVs0oMo4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EJdJ1R7RPiMRVjQmfYEIy6LSmrFHdjM+1MCo53NxghxGtOg+3bjA7qmyCxNSSWc+Y
	 IxLEkQL4jEiGCkL/y+ef13grPR0sESomuMqdvXX8xm0PTFCZFRq5SgTAdukt8qA0cf
	 fiZx3W/ffDHziNs0HzR82fKPjgi5y8VKaMY1VXd/ZmXTwrXEp3JP5axNBs6j+RGhNI
	 75G/GJDt8qUVUuirrxv/yExvKw8MsVlEQPtobewoEMRmcyMHk8qTuDemCACS2jZ6ei
	 dXCR8wNwpnYZp4DZb6UAeZcOCnGnuIzL7tgoFfzsmml9DlWPJGZkePELJxC3P8rkl+
	 3W3tQv4rxgcKw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Nov 2026 08:40:45 -0500
Subject: [PATCH v2 1/2] scsi: mpt3sas: Serialize interrupt-time sdev block
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
Message-Id: <20261102-sas-abba-v2-1-b3b9ba874b5a@kernel.org>
References: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
In-Reply-To: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4376; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=TCUsdRa2/WOCSz400q9Kb/x08BdKXx+qXNhYU/FsoS4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq6JLxaukXbivIXLXdDNToU2t3U47G+iyAxzo5C
 T3+z9IpRI6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauiS8QAKCRAADmhBGVaC
 Fdp8EAChSu1Z4arLFbkF8t1qryZWtpOCZEvM5LYhW1ENvXUePlP5ov+P4P3yBTV9G2SYhLJYHqQ
 cfiYA84sfThH4LMCFFkKFd9T9g95sAc3am+3fuNZbse6UUi0yLu5zamBAPd9/7sddD8ezbzZAJm
 2oyNzGbF/ZVoZMnj8jG8ZYiXp2rFIDSjXMefxjFKALEE1/n7wT7MyZinb2kHTqeq32529z5ZQa4
 2fK/ox/ErnQ/z2BkkolhCkDdCig2M+BQZQBB0wZneSYTbU600yDDlNGYVAI7d2dbEeIvfuope9t
 S9tHEfk78pQ85tltTDHPEdTjAhBqBg2fQEvFgyqQGAYEZ6rjM0Ebt4Wnbobq9D1XSp1zHYYXyo+
 v0j993iyXG9laUKh4CQLskx3329L8rHw6r0QiC8GYm218Yl9AKzhvSJTveveeOiXj7/dKXLFSmV
 mfMaiNuWE/P/4HKcY3VRvC2ee7L6l2z4UeEXHy9gwmEbNavwverX62Sn/fvsFCQVdM/vT9LnwtC
 GdGISY3JUJi65fFbNgqN9GOy0ix1CUzXd98srLBAOhafEGQta+w0KrUVQKh/1UKfnkp5YTTyWpi
 NPzuB8ODdy118qDsWyeZAv3/96ZCHkk6Z2c4sHLsdh0s0qR8sr672guZMmSvHmQ4dhdsMs5mE1B
 uELZ/WnWGWxlx6w==
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
and in scsih_sdev_destroy() around clearing sdev->hostdata. While
hostdata is non-NULL under the lock, it and its target are live.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 21 +++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

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
index 085d4672db85..c7886a12d308 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2176,6 +2176,7 @@ scsih_sdev_init(struct scsi_device *sdev)
 static void
 scsih_sdev_destroy(struct scsi_device *sdev)
 {
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	struct scsi_target *starget;
 	struct Scsi_Host *shost;
@@ -2218,8 +2219,11 @@ scsih_sdev_destroy(struct scsi_device *sdev)
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
@@ -4234,26 +4238,30 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
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
@@ -13537,6 +13545,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->raid_device_lock);
 	spin_lock_init(&ioc->pcie_device_lock);
 	spin_lock_init(&ioc->diag_trigger_lock);
+	spin_lock_init(&ioc->block_lock);
 
 	INIT_LIST_HEAD(&ioc->sas_device_list);
 	INIT_LIST_HEAD(&ioc->sas_device_init_list);

-- 
2.56.0

