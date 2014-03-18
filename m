From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] Invalidate VPD page data
Date: Tue, 18 Mar 2014 07:52:58 +0100
Message-ID: <5327ED4A.9020202@suse.de>
References: <1394873512-102073-1-git-send-email-hare@suse.de> <1394873512-102073-7-git-send-email-hare@suse.de> <53277311.9000105@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaCRGxA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2014 02:53:00 -0400
In-Reply-To: <53277311.9000105@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/17/2014 11:11 PM, Jeremy Linton wrote:
> On 3/15/2014 3:51 AM, Hannes Reinecke wrote:
>> Add a flag 'vpd_invalid' to the SCSI device to indicate that
>> the VPD data needs to be refreshed. This is required if
>> either a manual rescan is triggered or if the sense code
>> INQUIRY DATA HAS CHANGED has been received.
>=20
>=20
>> --- a/drivers/scsi/scsi_error.c +++
>> b/drivers/scsi/scsi_error.c @@ -393,6 +393,7 @@ static void
>> scsi_report_sense(struct scsi_device *sdev,
>=20
>> if (sshdr->sense_key =3D=3D UNIT_ATTENTION) { if (sshdr->asc =3D=3D
>> 0x3f && sshdr->ascq =3D=3D 0x03) { +			sdev->vpd_invalid =3D 1;
>=20
>=20
> I didn't study the whole code path but does the VPD data get
> updated on a 6/2900? I suspect it should be. I can imagine a
> number of cases where the luns changed check condition gets=20
> preempted/lost by a device reset. I guess much of that should
> be masked by the port login/logout, but its probably better to
> be safe...
>=20
Argl.

I was hoping to avoid that; I've already had a rather lengthy
discussion with NetApp about handling Power-on-Reset UA.

We should be discussion that at LSF; Power-on-Reset UA handling
(and queued UA handling in general) has some implications which
could do with a proper elaboration. Rumours have it that Fred
Knight from NetApp will also at LSF, so we'll have someone to ask
for any technical issues :-).

And that's precisely why I hooked the 'sdev->vpd_invalid' flag
into the 'rescan' attribute, so that it can be refreshed on demand.

Cheers,

Hannes
- --=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTJ+1KAAoJEGz4yi9OyKjP8G8P/2+fO+nYNCJa9KyMfx9/IUke
VA5Ap81H2tbyUkmZp9irnegV9HNg7OF66MMNo+o5MvB96RZGCnma5pjUfmwpk4AW
as188YlrT36FSC769LH+7n7EA5rcCVuCzRkZkiqjvh7xG36Z7yg4HpKjx1aX0tHh
3iTvYy1IuPfhzti4W533lybmrFYJi7Izjr/qHV/AjeWlkmsGSVf/eb4A84dKskjn
RB0ahFrS86HVCOOvH233tsjNrN1ToP7+nNQT4cyDGT1mUqQZHQlNCz75zhJBUjAL
QuT31T2SiT0dS3EmpLIU/oI0A0rN8NbJo7zV1LpbVTHvJCVrNtkUtjMtxFV0/CMk
/ppWZGyIRjkPcCzNS01QVI1bUywpPbOhfVjJiG15gYY1Ef6z6/uktuX9SNOGWAzw
1MYylda+c10rg3I47nZTjahTKnnGkKBi7OLVXqi0hs0lHW7gA0UpZLYkovcOL4bA
7fYwABVDmfP65bzWl1tk9qmWoLeneD9TW5aaLkQ8d8qr/pd3oo1zd+RC6cgBQVXH
A2tRHTF36+R7C8kOO937tvQ2QIWa5YXNlgeaQkYAoOegJq0CWTB2kSe+f/h9EBtv
+YNLNPldhHD3bj0Poqrw2wXVfEWFlXD5Blz/2ioHPzzOx6EkQgH5uNGzyuyKR+5p
MMNGFIoQZSyqfJJNVtIK
=3D0T1G
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
