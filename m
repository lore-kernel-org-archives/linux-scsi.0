Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6DD2574B;
	Sat, 29 Jun 2024 12:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719664953; cv=none; b=kyrZvNKIldXMqVGawLhQ55I2oESZOH8LNpvytaz2srLkZYy0wblePTln//rJZSeoc3YR1DW5USRSCDFP58YsKY3/Kz8dG1yAYDS+tUpr4RoaJ8/2PRyImW41iaTo3SgKH6wDVT6ykdZdyVNwUGGDy13x3Gr8Ff4dk2yaQ8O3MS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719664953; c=relaxed/simple;
	bh=Ghd/27ioPdGmjCXPDms5m/c98Lu6QS0GgtZMrPyqh2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAzH/PtvkFgv9iN+Oey2h10uhkUaLviY2bzSOQrBQzpEfx3OUyHBY7P/Y/hvBlDtstJ79dAKplBUT4hlJZmpa1W1TKYETGlVujFeVJGCUeOiWtIkG5Ac+wNQd8xHvNL50e4zrkcmsV11bkfZCSqeeoLWlj1+hh7tehUoK4nvLNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDSScS9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDSScS9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322C0C32789;
	Sat, 29 Jun 2024 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719664952;
	bh=Ghd/27ioPdGmjCXPDms5m/c98Lu6QS0GgtZMrPyqh2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDSScS9B4SQTGU7CHPWsbAeOpbWdQSeR7T+Z2/+SnxaV4eOPAMU8I9bogTQsVj+Bp
	 br22NwiUul28tPJbdJq79KwykkaKdJiZXOYpOyo/shVQgs63icJJBLj6MY78DoCpEO
	 EezUEy+CJ0gC76IxMC7QYyDW1O3C/4Q97u8nXYEz/3zZTaMkeL/rsXqelum/D02XSY
	 dSRi6gTn3JtAZgUYYUFk129eHgszsbEZORcVK3QfAdwI+oGb34hz0ChI16GfJsv40p
	 IbmqlCKhg8iO2L3jPFprFVD2g28D642CIItSW4/nNoak9HNwa3Z5P8Fjucrahxy7If
	 vvp24KrXrDIPg==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	stable@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: [PATCH 1/4] ata: libata-core: Fix null pointer dereference on error
Date: Sat, 29 Jun 2024 14:42:11 +0200
Message-ID: <20240629124210.181537-7-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240629124210.181537-6-cassel@kernel.org>
References: <20240629124210.181537-6-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2474; i=cassel@kernel.org; h=from:subject; bh=Ghd/27ioPdGmjCXPDms5m/c98Lu6QS0GgtZMrPyqh2U=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNIaGNUv7WD5IHLR78WWv4nPrTjUnszSl7RPF3H7HXAi6 39COPe3jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAExE5gDDHz65e8r741YsWy/0 /FxjYEemrsoP26/LmfXzF+48pdK3OYThr8DOKfMPXZs6fbNe37GbPrWnHS51Pj3oVyF754KRbJw 8Bw8A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

If the ata_port_alloc() call in ata_host_alloc() fails,
ata_host_release() will get called.

However, the code in ata_host_release() tries to free ata_port struct
members unconditionally, which can lead to the following:

BUG: unable to handle page fault for address: 0000000000003990
PGD 0 P4D 0
Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 10 PID: 594 Comm: (udev-worker) Not tainted 6.10.0-rc5 #44
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
RIP: 0010:ata_host_release.cold+0x2f/0x6e [libata]
Code: e4 4d 63 f4 44 89 e2 48 c7 c6 90 ad 32 c0 48 c7 c7 d0 70 33 c0 49 83 c6 0e 41
RSP: 0018:ffffc90000ebb968 EFLAGS: 00010246
RAX: 0000000000000041 RBX: ffff88810fb52e78 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88813b3218c0 RDI: ffff88813b3218c0
RBP: ffff88810fb52e40 R08: 0000000000000000 R09: 6c65725f74736f68
R10: ffffc90000ebb738 R11: 73692033203a746e R12: 0000000000000004
R13: 0000000000000000 R14: 0000000000000011 R15: 0000000000000006
FS:  00007f6cc55b9980(0000) GS:ffff88813b300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000003990 CR3: 00000001122a2000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __die_body.cold+0x19/0x27
 ? page_fault_oops+0x15a/0x2f0
 ? exc_page_fault+0x7e/0x180
 ? asm_exc_page_fault+0x26/0x30
 ? ata_host_release.cold+0x2f/0x6e [libata]
 ? ata_host_release.cold+0x2f/0x6e [libata]
 release_nodes+0x35/0xb0
 devres_release_group+0x113/0x140
 ata_host_alloc+0xed/0x120 [libata]
 ata_host_alloc_pinfo+0x14/0xa0 [libata]
 ahci_init_one+0x6c9/0xd20 [ahci]

Do not access ata_port struct members unconditionally.

Fixes: 633273a3ed1c ("libata-pmp: hook PMP support and enable it")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e1bf8a19b3c8..f47838da75d7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5518,6 +5518,9 @@ static void ata_host_release(struct kref *kref)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
+		if (!ap)
+			continue;
+
 		kfree(ap->pmp_link);
 		kfree(ap->slave_link);
 		kfree(ap->ncq_sense_buf);
-- 
2.45.2

