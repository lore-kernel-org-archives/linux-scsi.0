From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: mpt3sas: memory allocation for firmware upgrade DMA memory question
Date: Wed, 25 May 2016 11:18:53 +0200
Message-ID: <20160525091853.psv6kml6oingj4fx@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbcEYJSz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 05:18:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>

Hi Chaitra and Suganath,

I've got a question regarding mpt3sas' memory allocation used when doin=
g a
firmware upgrade. Currently you're doing a pci_alloc_consitent() which =
tries
to allocate memory via GFP_ATOMIC. This memory then is passed as a sing=
le
element on a sg_list.

Jeff reported it returned -ENOMEM on his Server due to highly fragmente=
d
memory.

Is it required to have the memory for the DMA operation contiguous, or =
can I
just allocate several non-contiguous junks of memory and map it to a sg=
_list?

If not, is GFP_ATMOIC really needed? I've converted the driver to use
GFP_KERNEL but I'm a bit reluctant to test below patch on real hardware=
 to not
brick the HBA.

Thanks,
	Johannes

RFC patch for GFP_KERNEL allocation, though splitting into multiple sg =
mapped
elements is the preferred fix here:

=46rom 06e63654d887df7f740dc5abcb40d441a8da7fa5 Mon Sep 17 00:00:00 200=
1
=46rom: Johannes Thumshirn <jthumshirn@suse.de>
Date: Tue, 24 May 2016 17:25:59 +0200
Subject: [RFC PATCH] mpt3sas: Don't do atomic memory allocations for fi=
rmware
 update DMA

Currently mpt3sas uses pci_alloc_consistent() to allocate memory for th=
e DMA
used to do firmware updates. pci_alloc_consistent() in turn uses GFP_AT=
OMIC
allocations. On a host with high memory fragmention this can lead to pa=
ge
allocation failures, as the DMA buffer holds the complete firmware upda=
te and
thus can need page allocations of higher orders.

As the firmware update code path may sleep, convert allocation to a nor=
mal
kzalloc() call with GFP_KERNEL and map it to the DMA buffers.

Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 39 ++++++++++++++++++++++++++++--=
--------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/=
mpt3sas_ctl.c
index 7d00f09..14be3cf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -751,8 +751,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, st=
ruct mpt3_ioctl_command karg,
=20
 	/* obtain dma-able memory for data transfer */
 	if (data_out_sz) /* WRITE */ {
-		data_out =3D pci_alloc_consistent(ioc->pdev, data_out_sz,
-		    &data_out_dma);
+		data_out =3D kzalloc(data_out_sz, GFP_KERNEL);
 		if (!data_out) {
 			pr_err("failure at %s:%d/%s()!\n", __FILE__,
 			    __LINE__, __func__);
@@ -760,6 +759,14 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, s=
truct mpt3_ioctl_command karg,
 			mpt3sas_base_free_smid(ioc, smid);
 			goto out;
 		}
+		data_out_dma =3D pci_map_single(ioc->pdev, data_out,
+					      data_out_sz, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&ioc->pdev->dev, data_out_dma)) {
+			ret =3D -EINVAL;
+			mpt3sas_base_free_smid(ioc, smid);
+			goto out_free_data_out;
+		}
+
 		if (copy_from_user(data_out, karg.data_out_buf_ptr,
 			data_out_sz)) {
 			pr_err("failure at %s:%d/%s()!\n", __FILE__,
@@ -771,8 +778,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, st=
ruct mpt3_ioctl_command karg,
 	}
=20
 	if (data_in_sz) /* READ */ {
-		data_in =3D pci_alloc_consistent(ioc->pdev, data_in_sz,
-		    &data_in_dma);
+		data_in =3D kzalloc(data_in_sz, GFP_KERNEL);
 		if (!data_in) {
 			pr_err("failure at %s:%d/%s()!\n", __FILE__,
 			    __LINE__, __func__);
@@ -780,6 +786,13 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, s=
truct mpt3_ioctl_command karg,
 			mpt3sas_base_free_smid(ioc, smid);
 			goto out;
 		}
+		data_in_dma =3D pci_map_single(ioc->pdev, data_in,
+					     data_in_sz, PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&ioc->pdev->dev, data_in_dma)) {
+			ret =3D -EINVAL;
+			mpt3sas_base_free_smid(ioc, smid);
+			goto out_free_data_in;
+		}
 	}
=20
 	psge =3D (void *)request + (karg.data_sge_offset*4);
@@ -1013,13 +1026,19 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc=
, struct mpt3_ioctl_command karg,
  out:
=20
 	/* free memory associated with sg buffers */
-	if (data_in)
-		pci_free_consistent(ioc->pdev, data_in_sz, data_in,
-		    data_in_dma);
+	if (data_in) {
+		pci_unmap_single(ioc->pdev, data_in_dma,
+				 data_in_sz, PCI_DMA_TODEVICE);
+out_free_data_in:
+		kfree(data_in);
+	}
=20
-	if (data_out)
-		pci_free_consistent(ioc->pdev, data_out_sz, data_out,
-		    data_out_dma);
+	if (data_out) {
+		pci_unmap_single(ioc->pdev, data_out_dma,
+				 data_out_sz, PCI_DMA_FROMDEVICE);
+out_free_data_out:
+		kfree(data_out);
+	}
=20
 	kfree(mpi_request);
 	ioc->ctl_cmds.status =3D MPT3_CMD_NOT_USED;
--=20
1.8.5.6



--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
