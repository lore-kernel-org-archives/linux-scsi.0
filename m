From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: REPORT LUNS
Date: Fri, 13 Jun 2003 11:22:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030613112222.A23260@beaverton.ibm.com>
References: <3EE9DA00.A429F83F@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:21173 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265469AbTFMSMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2003 14:12:37 -0400
Content-Disposition: inline
In-Reply-To: <3EE9DA00.A429F83F@fujitsu-siemens.com>; from josef.moellers@fujitsu-siemens.com on Fri, Jun 13, 2003 at 04:04:48PM +0200
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Josef_M=F6llers?= <josef.moellers@fujitsu-siemens.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 13, 2003 at 04:04:48PM +0200, Josef M=F6llers wrote:
> Hi,
>=20
> Wile trying to figure out how to ignore non-existing LUNs on RAID
> devices, I have fallen across an error in scsilun_to_int() where it
> doesn't behave as the comment suggests and a problematic piece of cod=
e
> in scsi_report_lun_scan().
>=20
> Patch is included.

If we clear the upper bits (address method, per SAM-3), someone has to
eventually set them again, and this is not handled today in linux scsi
core.

What adapter and driver are you using? AFAIK the Emulex driver figures =
out
the address method (high two bits) and ors it with each LUN sent down.

I don't recall what happens with the qlogic driver, I thought it had so=
me
special code to handle these, but can't find it.

=46or SPI it seems OK to ignore the upper bits since they are truncated=
=2E
Maybe some devices work OK this way - they set an address method of 10b=
 or
01b, and then don't care that the LUN comes in without the high bits se=
t.

So the change might work for some adapters, but break on others.

We are probably broken for anyone using the 11b extended logical unit
addressing method (with or without your patch).

Can you change your RAID device to use the peripheral device addressing
method - address method of 00b - instead?

In any case we should do what actually works, given that we are
translating an 8 byte LUN to a (host ordered) int, and later converting
that back to an 8 or 1 byte LUN (for qlogic, to a 2 byte LUN that is th=
en
converted to an 8 byte LUN).

> @@ -1027,13 +1027,18 @@
>  	 * the header, so start at 1 and go up to and including num_luns.
>  	 */
>  	for (lunp =3D &lun_data[1]; lunp <=3D &lun_data[num_luns]; lunp++) =
{
> +		int j;
> +
>  		lun =3D scsilun_to_int(lunp);
> =20
>  		/*
>  		 * Check if the unused part of lunp is non-zero, and so
>  		 * does not fit in lun.
>  		 */
> -		if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", 4)) {
> +		for (j =3D sizeof(lun); j < sizeof(struct scsi_lun); j++)
> +		    if (lunp->scsi_lun[j] !=3D 0)
> +			break;
> +		if (j < sizeof(struct scsi_lun)) {
>  			int i;
> =20
>  			/*

What does the above patch fix? It looks like they both check if the las=
t
four bytes are 0.

PS: Going offline really soon now for about a week.

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
