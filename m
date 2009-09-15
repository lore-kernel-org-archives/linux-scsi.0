From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [RFC][PATCH v2]Add pm8001 SAS/SATA HBA driver
Date: Tue, 15 Sep 2009 08:07:35 +0200
Message-ID: <200909150807.36222.eike-kernel@sf-tec.de>
References: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2833990.yohRRCNaPj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51560 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZIOGHg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2009 02:07:36 -0400
In-Reply-To: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: James.Bottomley@suse.de, matthew@wil.cx, linux-scsi@vger.kernel.org, lindar_liu@usish.com, tom_peng@usish.com, 'aoqingy' <aoqingyun@usish.com>

--nextPart2833990.yohRRCNaPj
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

jack wang wrote:
> Hi, James
> Sorry for the late response. Here is our driver next send with review inp=
ut
> from Matthew:
> 1 Big endian support is added but not test because lack of equipment.
> 2 IOCTL interface is replaced by sysfs.
> 3 Delete some unused debug info
> 4 Move Vendor id to pci_ids.h
> 5 Kconfig && Makefile modification
> Any comments and reviews will be appreciated
> Best wishes,
> Jack
>=20

Just a bunch of random things I found, I didn't look into everything yet:

=2DLOW_32_BITS/HIGH_32_BITS should be replaced by upper_32_bits/lower_32_bi=
ts=20
from linux/kernel.h
=2Dthere are at least 2 typos where "memory" is written as "memery"

+static void read_inbound_queue_table(struct pm8001_hba_info *pm8001_ha)
+{
+	int inbQ_num =3D 1;
+	u32 offset;

Can be declared inside the loop.

+	int i;
+	dma_addr_t address =3D pm8001_ha->inb_addr;
+	for (i =3D 0; i < inbQ_num; i++) {
+		offset =3D i * 0x24;
+		pm8001_ha->inb_data[i].pi_pci_bar =3D
+		get_pci_bar_index(pm8001_mr32(address, (offset + 0x14)));

This need more identation as it's a continued line.

+		pm8001_ha->inb_data[i].pi_offset =3D
+		pm8001_mr32(address, (offset + 0x18));
+	}
+}

=2Dread_outbound_queue_table(): the same

+ * check_fw_ready - The LLDD check if the FW is ready, if not,wait as long

There is a space mising behind the last ","

+	/* wait until scratch pad 1 and 2 registers in ready state  */
+	do {
+		mdelay(10);
+		value =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1)
+			& SCRATCH_PAD1_RDY;
+		value1 =3D pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2)
+			& SCRATCH_PAD2_RDY;
+		if ((--max_wait_count) =3D=3D 0)
+			break;
+	} while ((value !=3D SCRATCH_PAD1_RDY) || (value1 !=3D SCRATCH_PAD2_RDY));
+
+	if (!max_wait_count)
+		return -1;
+	return 0;

Why not directly "return -1" inside the loop?

+	/*This register is a 16-bit timer with a resolution of 1us. This is the
+	timer used for interrupt delay/coalescing in the PCIe Application Layer.
+	Zero is not a valid value.A value of 1 in the register will cause the
                              ^

Space missing

+/**
+ *Function to do BAR shifting function is called to shift BAR base address
+ *
+ *  @pm8001_ha handles for this instance of SAS/SATA hardware
+ *  @shiftValue shifting value
+ *
+ *  return success or fail
+ */

=2Dyou should use proper kerneldoc comments
=2Dthe description text duplicates itself somehow

+	return 0;
+}
+static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
+{

Newline missing.

There are some more of those I bet. I'll have to leave now, I'm sure someon=
e=20
will take care of the rest.

Eike

--nextPart2833990.yohRRCNaPj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqvLygACgkQXKSJPmm5/E4xGwCfVsCpLqShS3ezYBCGly6Ayhhe
W78AmgMLj1VbiDO82kNCzPgSWiOp1xl7
=A29h
-----END PGP SIGNATURE-----

--nextPart2833990.yohRRCNaPj--
