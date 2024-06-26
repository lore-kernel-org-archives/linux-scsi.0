Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A4118F2F0;
	Wed, 26 Jun 2024 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424867; cv=none; b=To08S9AU861tvJe9kCvds3Z41ge39GGHX0Mmi7wo+mXGMBE4U5vv2sdG0tNX5s/u+6ic5ILX/zlGoAEHOjf5/QFqoj+nlFXqIEG+K9QLwCrKTLDBzYbOaSAwrQvZlpXyHqxvIX+ywtHk8rxdAaiYHPKr6YV5P/cNPAl0jS95VRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424867; c=relaxed/simple;
	bh=o80Xm0+POlm2k0LTk7Efl4HCmFTOVufSY3+zwEc/JJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIoAffF06ea3Hq8WU8cV9c8tsnNAK4eZNndeBuBhqVxl+VlqoED3tGhFBp8/+Dhd+RQ966DowqfUjvR0vjoAEszgHc1IWPcVujs5sSkFOKAcVg9B9LH3RSH6jZjBQMhE6SOvgD/PuYZS02dStndKjpkPvOtsf6zAKoUTHlwXVgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCv20OEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCv20OEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B1BC32789;
	Wed, 26 Jun 2024 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424866;
	bh=o80Xm0+POlm2k0LTk7Efl4HCmFTOVufSY3+zwEc/JJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCv20OEEzZHPAp63+RtlGVpRsabW+M0wIMqtIwBYAmnVw9M/Te1oBTBcF4P3xLmNQ
	 FasW6Kw7qBvHZyyGkV3ZcGjygzBJXTLN6HhSnS02WC5jHRgwMPlAjBKrvmkgJJPF7n
	 rs1qfQ+TA/t1P1EUEeijSA6W17yRQY4TFWKTWAPtT3GUi3a6qHeGMgRToHPDbVbEXD
	 WVWrvaYyavOw63WeCfGzI1fVDA3mJYZDSiFIPkQNPwAkcLdZ7pyq+oMNUpAoNOBOVr
	 O+jM8LXgIi9MjFYuieHhtmGPy0C8Y0l7pisICL9MPSkw1rw5DSJ0dSrRX+zQ4xLVvg
	 UqBjiW1+QDQfg==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	stable@vger.kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 02/13] ata: libata-core: Fix double free on error
Date: Wed, 26 Jun 2024 20:00:32 +0200
Message-ID: <20240626180031.4050226-17-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2851; i=cassel@kernel.org; h=from:subject; bh=o80Xm0+POlm2k0LTk7Efl4HCmFTOVufSY3+zwEc/JJM=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwu1/MPSax+ou84lZYH/3A4/szQh2PouW+V5phVuE9 9hvr+/vKGVhEONikBVTZPH94bK/uNt9ynHFOzYwc1iZQIYwcHEKwERcPBj+B/JferJq1gGD12eL o9rmXw0PedAsIas4V/tDMoO9Vt3RKIZ/phkv2o+Zzvv8dBNvabXR7D+xb2+uC178XJwh/bVP266 5nAA=
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
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 88e32f638f33..c916cbe3e099 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5573,8 +5573,10 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
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
@@ -5606,8 +5608,6 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 
  err_out:
 	devres_release_group(dev, NULL);
- err_free:
-	kfree(host);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(ata_host_alloc);
-- 
2.45.2

