Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB60E2D5929
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 10:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250675; cv=none; b=AzJnvjRWfgGkseS6QukmUTqZBWHKW2ft05K5lqe0CtboTwHY/6PXz0QLfsrTl1qy8yCa+D5DrVwXSqLk/yIhVlmosmKd30P21Udiwy9Og2ZCdRHawWN7gZskrv4VQB9UwX+IMbjCvc0AD0Qu6Na4+LAMDPUqJoYISgW7tMV9C1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250675; c=relaxed/simple;
	bh=3QCMI3lWIrN4z85zKr8FZAhyb3w/JJv5uITuZfIFFhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upVBABWwe12GmAtD7EaMzDEIq0+gkou2kZsyP9ls52Z/Wnk41f5DBoL7z/IObETCGZfzgh7xYffACwRlRMVY2pgKqoR+Y+BtJGbsxzGBuaxO3SuhmgRyrmSO5MNUiyDniGw3Ayzf3saCxLR4B4HKfRktIEbUwLdLwXcV7tlS5kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eY0SK0yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eY0SK0yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA20C4CEF7;
	Tue,  4 Nov 2025 10:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762250675;
	bh=3QCMI3lWIrN4z85zKr8FZAhyb3w/JJv5uITuZfIFFhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eY0SK0yuiKkwJXiAc0ZJaCvRnNo9XaVZcOk5q/U2yqpdoOtPCHmIKWnrHk2dmRy+0
	 PAuzLs4WhQIzafDFGY/NfVI8Kvlntm/Jh+PEfpGN31C4zKYDB6CJUhqL0eZE+FxmTe
	 n/QlVMdY5U0WKciK6HnzoGddSaexeuhLwKaZkSlQ6xsaiONDlwGnPRuy3ImQsP7vlI
	 DEai7U8yK7qE8nG+3bq+D5KHFEnB8hdoAzizJygi6E3zLtCRhuuQvzpXmYqos8Y5Kd
	 ipuKvjARTCa07hkhhqqUn40GbFFFuyv5DudjtkiDcpdcCiLUkMcxeWY14MJSLZE03f
	 Mr1wnwcw8j7Uw==
From: Hannes Reinecke <hare@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 2/4] fnic: correctly initialize 'fnic->name'
Date: Tue,  4 Nov 2025 11:04:22 +0100
Message-ID: <20251104100424.8215-3-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251104100424.8215-1-hare@kernel.org>
References: <20251104100424.8215-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The instance name is required for setting up interrupt handlers, so
set it early enough to avoid the request_irq() routine crashing on
duplicate or empty names.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 7075a23d9229..870b265be41a 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -575,9 +575,6 @@ static void fnic_scsi_init(struct fnic *fnic)
 {
 	struct Scsi_Host *host = fnic->host;
 
-	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
-			 host->host_no);
-
 	host->transportt = fnic_fc_transport;
 }
 
@@ -732,6 +729,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	fnic->pdev = pdev;
 	fnic->fnic_num = fnic_id;
+	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
+		 fnic->fnic_num);
 
 	/* Find model name from PCIe subsys ID */
 	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0) {
-- 
2.43.0

