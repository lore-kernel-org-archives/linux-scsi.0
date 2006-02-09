From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] megaraid_sas: fix physical disk handling
Date: Thu, 9 Feb 2006 15:44:54 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F021CA7F6@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62DB9.AEAAD35C"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:16573 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1750775AbWBIUo5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 15:44:57 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>, Christoph Hellwig <hch@lst.de>
Cc: Sreenivas.Bagalkote@lsil.com, Chandra_Nelogal@Dell.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62DB9.AEAAD35C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

What about considering the enclosed patch (submitted 2/2/2006 under the
title "RE: [PATCH 1/5] aacraid: simplify non-dasd support") and clearing
the scsi device writeable flag along with the no_uld_attach flag?

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Sumant Patro
> Sent: Thursday, February 09, 2006 1:30 PM
> To: Christoph Hellwig
> Cc: Sreenivas.Bagalkote@lsil.com; Chandra_Nelogal@Dell.com;=20
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] megaraid_sas: fix physical disk handling
>=20
>=20
> Hello Christoph,
>=20
> 	Thank you for the patch.
>=20
>         As you mentioned this patch allows scsi generic access to the
> physical disks. I see this as potential data integrity issue=20
> if someone
> does a write operation on a disk that belongs to a Logical=20
> RAID volume.
> I would rather prevent all access to the disks using slave_alloc(). I
> will be sending a patch shortly for review that implements
> megasas_slave_alloc to block all direct access to the physical disks.
>=20
> Regards,
>=20
> Sumant
>=20
> On Mon, 2006-02-06 at 15:05 +0100, Christoph Hellwig wrote:
> > Chandra_Nelogal noticed that megaraid_sas currently exports=20
> all physical
> > disks normally to the disk layer, which is obviously quite bad.
> >=20
> > The problems is that megaraid_sas is doing inquiry=20
> sniffing, and since
> > 2.6.15 inquiry commands are sent down as one-element scatterlists on
> > which the code in the driver doesn't work anymore.  The=20
> right place to
> > keep the scsi midlayer from attaching to a device is the slave_alloc
> > method in the host template.  To completely prevent=20
> attaching the method
> > needs to return -ENXIO, but the patch below sets the=20
> no_uld_attach flag
> > instead which prevents upper level drivers from attaching=20
> while still
> > allowing scsi generic access to it, as in other raid HBA drivers.
> >=20
> >=20
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> >=20
> > Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
> > =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c=09
> 2006-02-04 13:35:00.000000000 +0100
> > +++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c=09
> 2006-02-06 14:59:13.000000000 +0100
> > @@ -707,6 +707,16 @@
> >  	return 0;
> >  }
> > =20
> > +static int megasas_slave_configure(struct scsi_device *sdev)
> > +{
> > +	/*
> > +	 * Don't export physical disk devices to the disk driver.
> > +	 */
> > +	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&=20
> sdev->type =3D=3D TYPE_DISK)
> > +		sdev->no_uld_attach =3D 1;
> > +	return 0;
> > +}
> > +
> >  /**
> >   * megasas_wait_for_outstanding -	Wait for all outstanding cmds
> >   * @instance:				Adapter soft state
> > @@ -857,6 +867,7 @@
> >  	.module =3D THIS_MODULE,
> >  	.name =3D "LSI Logic SAS based MegaRAID driver",
> >  	.proc_name =3D "megaraid_sas",
> > +	.slave_configure =3D megasas_slave_configure,
> >  	.queuecommand =3D megasas_queue_command,
> >  	.eh_device_reset_handler =3D megasas_reset_device,
> >  	.eh_bus_reset_handler =3D megasas_reset_bus_host,
> > @@ -985,20 +996,6 @@
> >  			break;
> >  		}
> > =20
> > -		/*
> > -		 * Don't export physical disk devices to mid-layer.
> > -		 */
> > -		if (!MEGASAS_IS_LOGICAL(cmd->scmd) &&
> > -		    (hdr->cmd_status =3D=3D MFI_STAT_OK) &&
> > -		    (cmd->scmd->cmnd[0] =3D=3D INQUIRY)) {
> > -
> > -			if (((*(u8 *)=20
> cmd->scmd->request_buffer) & 0x1F) =3D=3D
> > -			    TYPE_DISK) {
> > -				cmd->scmd->result =3D=20
> DID_BAD_TARGET << 16;
> > -				exception =3D 1;
> > -			}
> > -		}
> > -
> >  	case MFI_CMD_LD_READ:
> >  	case MFI_CMD_LD_WRITE:
> > =20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

------_=_NextPart_001_01C62DB9.AEAAD35C
Content-Type: application/octet-stream;
	name="wprotect2.patch"
Content-Transfer-Encoding: base64
Content-Description: wprotect2.patch
Content-Disposition: attachment;
	filename="wprotect2.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvc2NzaS5jIGIvZHJpdmVycy9zY3NpL3Njc2kuYwotLS0g
YS9kcml2ZXJzL3Njc2kvc2NzaS5jCTIwMDYtMDEtMTYgMDc6NTY6MDguMDAwMDAwMDAwIC0wNTAw
CisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpLmMJMjAwNi0wMi0wMiAwODo0MDozNi41MjI5Mjc5MTAg
LTA1MDAKQEAgLTYyMSw2ICs2MjEsMjMgQEAKIAkJZ290byBvdXQ7CiAJfQogCisJLyoKKwkgKiBE
ZXZpY2Ugb3IgTExEIHdyaXRlIHByb3RlY3QgZW5mb3JjZW1lbnQuCisJICovCisJaWYgKHVubGlr
ZWx5KCFjbWQtPmRldmljZS0+d3JpdGVhYmxlKSAmJgorCSAgICAoY21kLT5zY19kYXRhX2RpcmVj
dGlvbiA9PSBETUFfVE9fREVWSUNFKSkgeworCQljbWQtPnJlc3VsdCA9IERJRF9PSyA8PCAxNgor
CQkgICAgICAgICAgICB8IENPTU1BTkRfQ09NUExFVEUgPDwgOAorCQkgICAgICAgICAgICB8IFNB
TV9TVEFUX0NIRUNLX0NPTkRJVElPTjsKKwkJY21kLT5zZW5zZV9idWZmZXJbMF0gPSAweEYwOwor
CQljbWQtPnNlbnNlX2J1ZmZlclsyXSA9IERBVEFfUFJPVEVDVDsKKwkJY21kLT5zZW5zZV9idWZm
ZXJbN10gPSA2OworCQljbWQtPnNlbnNlX2J1ZmZlclsxMl0gPSBEQVRBX1BST1RFQ1QgPDwgMTsK
KwkJY21kLT5zZW5zZV9idWZmZXJbMTNdID0gMHgwNTsKKwkJc2NzaV9kb25lKGNtZCk7CisJCWdv
dG8gb3V0OworCX0KKwogCXNwaW5fbG9ja19pcnFzYXZlKGhvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
OwogCXNjc2lfY21kX2dldF9zZXJpYWwoaG9zdCwgY21kKTsgCiAK

------_=_NextPart_001_01C62DB9.AEAAD35C--
