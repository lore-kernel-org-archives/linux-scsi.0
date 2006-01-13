From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas.c - mapping the rphy channel equal to the port identifier
Date: Fri, 13 Jan 2006 16:33:59 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7FE@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61899.D49B25C3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:17847 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1423109AbWAMXeI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 18:34:08 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61899.D49B25C3
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

 Here's the patch, just in case my mailer messed things up.

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Moore, Eric
> Sent: Friday, January 13, 2006 4:25 PM
> To: linux-scsi@vger.kernel.org; hch@lst.de;=20
> James.Bottomley@steeleye.com
> Subject: [PATCH] scsi_transport_sas.c - mapping the rphy=20
> channel equal to the port identifier
>=20
> Remapping the channel number to the port identifier.
>=20
> We will be mapping the RAID volumes in mptsas to a reserved=20
> channel that
> is one larger than the anticapated number of ports on the direct
> attached host
> adapter.
>=20
> Signed-off-by: Eric Moore <Eric.Moore@lsil.com>
>=20
> --- scsi-misc-2.6-old/drivers/scsi/scsi_transport_sas.c=09
> 2006-01-13
> 11:44:08.000000000 -0700
> +++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2006-01-13
> 12:25:21.000000000 -0700
> @@ -638,7 +638,7 @@
>  	mutex_unlock(&sas_host->lock);
> =20
>  	if (rphy->scsi_target_id !=3D -1) {
> -		scsi_scan_target(&rphy->dev, parent->number,
> +		scsi_scan_target(&rphy->dev, parent->port_identifier,
>  				rphy->scsi_target_id, ~0, 0);
>  	}
> =20
> @@ -735,9 +745,9 @@
>  		if (rphy->scsi_target_id =3D=3D -1)
>  			continue;
> =20
> -		if ((channel =3D=3D SCAN_WILD_CARD || channel =3D=3D
> parent->number) &&
> +		if ((channel =3D=3D SCAN_WILD_CARD || channel =3D=3D
> parent->port_identifier) &&
>  		    (id =3D=3D SCAN_WILD_CARD || id =3D=3D
> rphy->scsi_target_id)) {
> -			scsi_scan_target(&rphy->dev, parent->number,
> +			scsi_scan_target(&rphy->dev,
> parent->port_identifier,
>  					 rphy->scsi_target_id, lun, 1);
>  		}
>  	}
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

------_=_NextPart_001_01C61899.D49B25C3
Content-Type: application/octet-stream;
	name="raid-1.patch"
Content-Transfer-Encoding: base64
Content-Description: raid-1.patch
Content-Disposition: attachment;
	filename="raid-1.patch"

LS0tIHNjc2ktbWlzYy0yLjYtb2xkL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zYXMuYwky
MDA2LTAxLTEzIDExOjQ0OjA4LjAwMDAwMDAwMCAtMDcwMAorKysgc2NzaS1taXNjLTIuNi9kcml2
ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfc2FzLmMJMjAwNi0wMS0xMyAxMjoyNToyMS4wMDAwMDAw
MDAgLTA3MDAKQEAgLTYzOCw3ICs2MzgsNyBAQAogCW11dGV4X3VubG9jaygmc2FzX2hvc3QtPmxv
Y2spOwogCiAJaWYgKHJwaHktPnNjc2lfdGFyZ2V0X2lkICE9IC0xKSB7Ci0JCXNjc2lfc2Nhbl90
YXJnZXQoJnJwaHktPmRldiwgcGFyZW50LT5udW1iZXIsCisJCXNjc2lfc2Nhbl90YXJnZXQoJnJw
aHktPmRldiwgcGFyZW50LT5wb3J0X2lkZW50aWZpZXIsCiAJCQkJcnBoeS0+c2NzaV90YXJnZXRf
aWQsIH4wLCAwKTsKIAl9CiAKQEAgLTczNSw5ICs3NDUsOSBAQAogCQlpZiAocnBoeS0+c2NzaV90
YXJnZXRfaWQgPT0gLTEpCiAJCQljb250aW51ZTsKIAotCQlpZiAoKGNoYW5uZWwgPT0gU0NBTl9X
SUxEX0NBUkQgfHwgY2hhbm5lbCA9PSBwYXJlbnQtPm51bWJlcikgJiYKKwkJaWYgKChjaGFubmVs
ID09IFNDQU5fV0lMRF9DQVJEIHx8IGNoYW5uZWwgPT0gcGFyZW50LT5wb3J0X2lkZW50aWZpZXIp
ICYmCiAJCSAgICAoaWQgPT0gU0NBTl9XSUxEX0NBUkQgfHwgaWQgPT0gcnBoeS0+c2NzaV90YXJn
ZXRfaWQpKSB7Ci0JCQlzY3NpX3NjYW5fdGFyZ2V0KCZycGh5LT5kZXYsIHBhcmVudC0+bnVtYmVy
LAorCQkJc2NzaV9zY2FuX3RhcmdldCgmcnBoeS0+ZGV2LCBwYXJlbnQtPnBvcnRfaWRlbnRpZmll
ciwKIAkJCQkJIHJwaHktPnNjc2lfdGFyZ2V0X2lkLCBsdW4sIDEpOwogCQl9CiAJfQo=

------_=_NextPart_001_01C61899.D49B25C3--
