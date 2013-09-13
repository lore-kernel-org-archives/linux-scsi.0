From: Ben Collins <ben.c@servergy.com>
Subject: [PATCH] megaraid: Use resource_size_t for PCI resources, not long
Date: Fri, 13 Sep 2013 12:46:44 -0400
Message-ID: <D74A8430-BF73-488F-8CD1-0E00B5FE75A6@servergy.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8C661A14-D25D-4675-991C-07E8BED7466D"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43930 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3IMQqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 12:46:45 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so2779194pad.28
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2013 09:46:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Sumit Saxena <Sumit.Saxena@lsi.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>


--Apple-Mail=_8C661A14-D25D-4675-991C-07E8BED7466D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

The assumption that sizeof(long) >=3D sizeof(resource_size_t) can lead =
to
truncation of the PCI resource address, meaning this driver didn't work
on 32-bit systems with 64-bit PCI adressing ranges.

Signed-off-by: Ben Collins <ben.c@servergy.com>
Cc: Sumit Saxena <Sumit.Saxena@lsi.com>
Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 1 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h =
b/drivers/scsi/megaraid/megaraid_sas.h
index 04a42a5..2f58758 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1460,7 +1460,6 @@ struct megasas_instance {
 	u32 *reply_queue;
 	dma_addr_t reply_queue_h;
=20
-	unsigned long base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c =
b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1f0ca68..5df5522 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3498,6 +3498,7 @@ static int megasas_init_fw(struct megasas_instance =
*instance)
 	u32 max_sectors_1;
 	u32 max_sectors_2;
 	u32 tmp_sectors, msix_enable, scratch_pad_2;
+	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
@@ -3506,14 +3507,14 @@ static int megasas_init_fw(struct =
megasas_instance *instance)
 	/* Find first memory bar */
 	bar_list =3D pci_select_bars(instance->pdev, IORESOURCE_MEM);
 	instance->bar =3D find_first_bit(&bar_list, sizeof(unsigned =
long));
-	instance->base_addr =3D pci_resource_start(instance->pdev, =
instance->bar);
 	if (pci_request_selected_regions(instance->pdev, instance->bar,
 					 "megasas: LSI")) {
 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
 		return -EBUSY;
 	}
=20
-	instance->reg_set =3D ioremap_nocache(instance->base_addr, =
8192);
+	base_addr =3D pci_resource_start(instance->pdev, instance->bar);
+	instance->reg_set =3D ioremap_nocache(base_addr, 8192);
=20
 	if (!instance->reg_set) {
 		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
--=20
1.8.3.2


--
Ben Collins - Principal Architect
Servergy, Inc. - www.servergy.com


--Apple-Mail=_8C661A14-D25D-4675-991C-07E8BED7466D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iEYEARECAAYFAlIzQXQACgkQbVJJsWDoC1tUswCfRJlKhH65Zf4F70z9v9q/exO/
S4QAoKYpdUE6QgVHQvfpeTe6dVwfhKO5
=Sa2U
-----END PGP SIGNATURE-----

--Apple-Mail=_8C661A14-D25D-4675-991C-07E8BED7466D--
