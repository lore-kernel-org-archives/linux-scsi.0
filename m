Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7102574B;
	Sat, 29 Jun 2024 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719664959; cv=none; b=SeQlNyWJfsalCyuxDMJSR502fYx8H97n7RNFX2joyJMgdTxHJEdWtQ12+xAcK35aDTUQ0fpJUUnj1aZYNXKjpVJa0STUE880mKfwG3z1OvOvoYwM1TQheqieV2NLul5Kuw3AIH4SiThkf6AYd1d22GTSilxR9HJAIHBJeuzz/h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719664959; c=relaxed/simple;
	bh=f4Qe+uisdyi95QeN2VZXvu3hEOAuQmhtk4sPU4vbjOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wn9PlmE1W/6SN5X5ZO8h0ay08DeiDeJAdyRXFQkoUfU8tRUdiQ9cJagxUjz+4Lcy0pcARPharkBUVRooUbctHZ1k1fTl6JvdI57gHSYpMMmPmCyza1qN2BDq88b2t9hBJ3MY9x0CZmsqKWWW2dqDypT+yaX7C1zhSU98YXbit+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBroWHsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBroWHsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983FFC32789;
	Sat, 29 Jun 2024 12:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719664959;
	bh=f4Qe+uisdyi95QeN2VZXvu3hEOAuQmhtk4sPU4vbjOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBroWHsp9iWHnv0yrZAlAhYYQ9z9TqkRWZVh8x7uppXVYdeAdf31S+yP5xpz5nzYY
	 bOJDOA7n6cDiU6DsnlKcmVJd1bh2ayQQyC7G2SnZshYwD3yqI0aObuRZCeOaT+QvBX
	 vemJfiAfmV3uDhn2g76snSeQsfZA23+cSARXyYFeiXiuE3IZrgUtOQ1dJSGVB+KN9W
	 6YvaKgJODXvOM6pwYjqiAVd2jv1lq4h6WjRGgRxFxWlVmTsWbELy4tBSmZ7MXe/S0X
	 ROOhEbmOVaTiGAM4Y4isipWdQyJNb4goHRcL/jCw42Sh8c0wOWBig7Sy/9k5FS0yOi
	 8oVvT2VGLVdBw==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Colin Ian King <colin.i.king@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	stable@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ata: libata-core: Fix double free on error
Date: Sat, 29 Jun 2024 14:42:13 +0200
Message-ID: <20240629124210.181537-9-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240629124210.181537-6-cassel@kernel.org>
References: <20240629124210.181537-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2946; i=cassel@kernel.org; h=from:subject; bh=f4Qe+uisdyi95QeN2VZXvu3hEOAuQmhtk4sPU4vbjOM=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNIaGDUCp52+Z9jquec0Zxa//YSQ8McSO3YYPl2VIHJVg e+wUurUjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExEtZeRYfqFmjMPZuzKaDa3 E5x4WHlHs8CF0qqYfW5fvvZr1drfmMfI0NScOqN0leKF3f8OPA9NL+Yt+BAUf/rFLLMnMtW/rmx X5wEA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

If e.g. the ata_port_alloc() call in ata_host_alloc() fails, we will jump
to the err_out label, which will call devres_release_group().
devres_release_group() will trigger a call to ata_host_release().
ata_host_release() calls kfree(host), so executing the kfree(host) in
ata_host_alloc() will lead to a double free:

kernel BUG at mm/slub.c:553!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 11 PID: 599 Comm: (udev-worker) Not tainted 6.10.0-rc5 #47
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
RIP: 0010:kfree+0x2cf/0x2f0
Code: 5d 41 5e 41 5f 5d e9 80 d6 ff ff 4d 89 f1 41 b8 01 00 00 00 48 89 d9 48 89 da
RSP: 0018:ffffc90000f377f0 EFLAGS: 00010246
RAX: ffff888112b1f2c0 RBX: ffff888112b1f2c0 RCX: ffff888112b1f320
RDX: 000000000000400b RSI: ffffffffc02c9de5 RDI: ffff888112b1f2c0
RBP: ffffc90000f37830 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc90000f37610 R11: 617461203a736b6e R12: ffffea00044ac780
R13: ffff888100046400 R14: ffffffffc02c9de5 R15: 0000000000000006
FS:  00007f2f1cabe980(0000) GS:ffff88813b380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2f1c3acf75 CR3: 0000000111724000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body.cold+0x19/0x27
 ? die+0x2e/0x50
 ? do_trap+0xca/0x110
 ? do_error_trap+0x6a/0x90
 ? kfree+0x2cf/0x2f0
 ? exc_invalid_op+0x50/0x70
 ? kfree+0x2cf/0x2f0
 ? asm_exc_invalid_op+0x1a/0x20
 ? ata_host_alloc+0xf5/0x120 [libata]
 ? ata_host_alloc+0xf5/0x120 [libata]
 ? kfree+0x2cf/0x2f0
 ata_host_alloc+0xf5/0x120 [libata]
 ata_host_alloc_pinfo+0x14/0xa0 [libata]
 ahci_init_one+0x6c9/0xd20 [ahci]

Ensure that we will not call kfree(host) twice, by performing the kfree()
only if the devres_open_group() call failed.

Fixes: dafd6c496381 ("libata: ensure host is free'd on error exit paths")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 481baa55ebfc..e0455a182af7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5578,8 +5578,10 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 	if (!host)
 		return NULL;
 
-	if (!devres_open_group(dev, NULL, GFP_KERNEL))
-		goto err_free;
+	if (!devres_open_group(dev, NULL, GFP_KERNEL)) {
+		kfree(host);
+		return NULL;
+	}
 
 	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
 	if (!dr)
@@ -5611,8 +5613,6 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 
  err_out:
 	devres_release_group(dev, NULL);
- err_free:
-	kfree(host);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(ata_host_alloc);
-- 
2.45.2

