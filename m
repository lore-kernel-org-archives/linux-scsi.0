Received: from mail-244105.protonmail.ch (mail-244105.protonmail.ch [109.224.244.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E00133E35B
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 03:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774582618; cv=none; b=cUNOerp7OwyyaUdb94A5OthYG7IzUYKo/EVRuoHOjzB0xNeO/Oa2ajxR4yIrsCawuw0hGKEd0uh/KXtHXbifzUAlofBPzLYA54os4p9ffXzrUS102ToYFyystaPrdU1MAvM6aWbvAJ1SonqHfSgE1OeoVLmV183npObbIGIZg+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774582618; c=relaxed/simple;
	bh=MBxCmdmDQpACVDLMLvDvdaQ0SmC/FskylOBF0/RKBDg=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=FbWTGiSMAIdig0cgT23xNeI0EwTQvcQN/jo6D6mKpCQaclNNFFfDoxYP/RNjQpoFV6q7x/iND5qh46g4ruBRwwTcYU/zHqFKx2yaC9EB0Q5jRkNZSgcUgvmJVGQFuGo9YG/oCtHIKgyVP3e2Dgr0Z0vzGT+TLrv9UvtlALBJNbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=magik.net; spf=pass smtp.mailfrom=magik.net; dkim=pass (2048-bit key) header.d=magik.net header.i=@magik.net header.b=Gin7KAui; arc=none smtp.client-ip=109.224.244.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=magik.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=magik.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=magik.net header.i=@magik.net header.b="Gin7KAui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=magik.net;
	s=protonmail; t=1774581642; x=1774840842;
	bh=fWr2FU/P5rejCm6ZNq8tQtdq71aMGtKLRZrF2iLVlO8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Gin7KAuicMm9w5eDenUy6sdN1UhAS+mrMK/6ickmuIZzh2iBx4AQAb2q/s/MWTLW+
	 LWVLi5EkikL9IjugXDff2MJU6OoZJP3KBw9MsWHXD+wdzxFD+uR4tVgbLopjO60WCo
	 aXFlk2aEKp35Qb9cGTiwzB7+cdUV15wQVCo+GxV030+dmrjL5tR48fFvqN1gAJCNfN
	 tIbut0SohxD7f3UaWowcHjFkGrgSHTJCIgEgCJHfkU/ciCov5V5s1FBNBO0/PzMV6Y
	 jhd5hGQ5RGnOw1Gckq2cNo3SC1B6yMBn6JrGV25cS7bUtHob3Kmsgtl7LA3oSmggg8
	 LCWmUlg2MMFIA==
Date: Fri, 27 Mar 2026 03:20:36 +0000
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
From: me@magik.net
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
Message-ID: <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
Feedback-ID: 68610942:user:proton
X-Pm-Message-ID: 3b5355a5d6a35a1fbe69b791698367a181598161
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

megasas_make_prp_nvme() builds NVMe PRP lists in cmd->sg_frame,
which is a DMA-pool allocation sized by instance->max_chain_frame_sz.

On the affected controller, max_chain_frame_sz is 4096 bytes. The
function stores 64-bit PRP entries in that buffer and, at each PRP-list
page boundary, uses the last slot for a chain pointer to the next page.

When ptr_sgl reaches offset 4088, the code stores the chain pointer
there, increments ptr_sgl, and then writes the next PRP entry at offset
4096, past the end of the allocation.

On an affected system this reproduces reliably on 6.19.10 during normal
I/O to an NVMe device behind a MegaRAID SAS39xx controller:

  BUG: unable to handle page fault for address: ff76d0e56380c000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  RIP: 0010:megasas_make_prp_nvme.isra.0+0x12f/0x220 [megaraid_sas]
  RAX: 0000000000000200

RAX=3D0x200 indicates the fault happens at the 512th 8-byte slot, i.e.
exactly the 4096-byte boundary of the chain frame.

Fix this by checking that the chain frame still has room before writing:

- the page-boundary chain pointer plus at least one following PRP entry
- each PRP entry itself

If either check fails, return false and let the caller use the existing
IEEE SGL fallback path.

Tested on:
- ASUS ESC8000A-E13
- 2x AMD EPYC 9335
- Broadcom MegaRAID 9560-16i / SAS39xx
- KIOXIA 14TB NVMe behind the controller

Before this patch, 6.19.10 crashed repeatedly during boot and normal
disk I/O. After applying it, the system boots cleanly and completes 4GB
direct-I/O reads without crashes.

Cc: stable@vger.kernel.org
Signed-off-by: Lukasz Magiera <me@magik.net>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/meg=
araid/megaraid_sas_fusion.c
index 4e498a6..29fa7f1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2225,6 +2225,18 @@ megasas_make_prp_nvme(struct megasas_instance *insta=
nce, struct scsi_cmnd *scmd,
 =09=09/* Put PRP pointer due to page boundary*/
 =09=09page_mask_result =3D (uintptr_t)(ptr_sgl + 1) & page_mask;
 =09=09if (unlikely(!page_mask_result)) {
+=09=09=09/*
+=09=09=09 * Bounds check: if the chain frame buffer cannot
+=09=09=09 * fit the chain pointer plus at least one more
+=09=09=09 * PRP entry, bail out to IEEE SGL fallback.
+=09=09=09 * This prevents writing past the end of the
+=09=09=09 * DMA-allocated chain frame buffer.
+=09=09=09 */
+=09=09=09if ((num_prp_in_chain + 2) * sizeof(u64) >
+=09=09=09    instance->max_chain_frame_sz) {
+=09=09=09=09build_prp =3D false;
+=09=09=09=09break;
+=09=09=09}
 =09=09=09scmd_printk(KERN_NOTICE,
 =09=09=09=09    scmd, "page boundary ptr_sgl: 0x%p\n",
 =09=09=09=09    ptr_sgl);
@@ -2234,6 +2246,13 @@ megasas_make_prp_nvme(struct megasas_instance *insta=
nce, struct scsi_cmnd *scmd,
 =09=09=09num_prp_in_chain++;
 =09=09}
=20
+=09=09/* Bounds check: ensure space for this PRP entry */
+=09=09if ((num_prp_in_chain + 1) * sizeof(u64) >
+=09=09    instance->max_chain_frame_sz) {
+=09=09=09build_prp =3D false;
+=09=09=09break;
+=09=09}
+
 =09=09*ptr_sgl =3D cpu_to_le64(sge_addr);
 =09=09ptr_sgl++;
 =09=09ptr_sgl_phys +=3D 8;
--=20
2.43.0



