From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: cciss broken with 2.6.22-rc2
Date: Tue, 29 May 2007 15:36:06 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C0137E704@G3W0639.americas.hpqcorp.net>
References: <465C1613.4050600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:51245 "EHLO
	ccerelbas04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbXE2PgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 11:36:23 -0400
Content-class: urn:content-classes:message
In-Reply-To: <465C1613.4050600@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

=20

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]=20
> Sent: Tuesday, May 29, 2007 7:01 AM
> To: Miller, Mike (OS Dev); SCSI Mailing List
> Subject: cciss broken with 2.6.22-rc2
>=20
> Hi Mike,
>=20
> with the latest git snapshot the cciss driver hangs during=20
> initialisation. Enabling debug output I get:
>=20
> cciss0: <0x3230> at PCI 0000:06:00.0 IRQ 4338 using DAC=20
> Sending cff0000 - down to controller
> cciss:  FIFO Empty read
> cciss:  Read cff00000 back from board
> Sending cff0000 - down to controller
> cciss:  FIFO Empty read
> cciss:  Read cff00002 back from board
> LUN Data
> --------------------------
> Sending cff0000 - down to controller
> cciss:  FIFO Empty read
> cciss:  Read cff00000 back from board
>       blocks=3D 286677120 block_size=3D 512
> Sending cff0000 - down to controller
> cciss:  FIFO Empty read
> cciss:  Read cff00002 back from board
>       heads=3D255, sectors=3D32, cylinders=3D35132
>=20
> Sending 5103000 - down to controller
>=20
> and then the machine hangs.
> I'll try to investigate, but as I'm no expert in cciss my=20
> results might be limited.
> Looks like one of your recent fixes broke it; 2.6.21 worked fine.

Hannes,
Actually, it was someone else who broke the driver by making changes in=
 msi.c. This patch fixes the hang:

=46rom: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> writes:

=46ound what seems the problem with our vectors being listed backward. =
In drivers/pci/msi.c we should be using list_add_tail rather than list_=
add to preserve the ordering across various kernels. Please consider th=
is for inclusion.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c index 0e67723..d7497=
5d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -333,7 +333,7 @@ static int msi_capability_init(struct pci_dev *dev)
 			msi_mask_bits_reg(pos, is_64bit_address(control)),
 			maskbits);
 	}
-	list_add(&entry->list, &dev->msi_list);
+	list_add_tail(&entry->list, &dev->msi_list);
=20
 	/* Configure MSI capability structure */
 	ret =3D arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI); @@ -404,7 +404,7=
 @@ static int msix_capability_init(struct pci_dev *dev,
 		entry->dev =3D dev;
 		entry->mask_base =3D base;
=20
-		list_add(&entry->list, &dev->msi_list);
+		list_add_tail(&entry->list, &dev->msi_list);
 	}
=20
 	ret =3D arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
-----------------------------------------------------------------------=
-------------------------
This patch fixes an Oops during rmmod:

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Chase Maupin <chase.maupin@hp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c index e01380b..66321=
50 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -558,12 +558,12 @@ static int msi_free_irqs(struct pci_dev* dev)
=20
 	list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
 		if (entry->msi_attrib.type =3D=3D PCI_CAP_ID_MSIX) {
-			if (list_is_last(&entry->list, &dev->msi_list))
-				iounmap(entry->mask_base);
-
 			writel(1, entry->mask_base + entry->msi_attrib.entry_nr
 				  * PCI_MSIX_ENTRY_SIZE
 				  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+
+			if (list_is_last(&entry->list, &dev->msi_list))
+				iounmap(entry->mask_base);
 		}
 		list_del(&entry->list);
 		kfree(entry);
-----------------------------------------------------------------------=
-------------------------
WARNING: These patches may suffer from wordwrap as they are coming from=
 my microsucks email client.

We found and fixed these late last week. So I hope they make into Linus=
' git tree ASAP.

Thanks,
mikem

>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
