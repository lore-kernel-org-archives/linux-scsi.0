From: Hannes Reinecke <hare@suse.de>
Subject: Re: [SCSI] scsi_dh: Update EMC handler
Date: Mon, 13 Jul 2015 16:06:14 +0200
Message-ID: <55A3C5D6.9080502@suse.de>
References: <20150711221438.GA20058@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbGMOGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jul 2015 10:06:15 -0400
In-Reply-To: <20150711221438.GA20058@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 07/12/2015 12:14 AM, Dan Carpenter wrote:
> Hello Hannes Reinecke,
>=20
> The patch b6ff1b14cdf4: "[SCSI] scsi_dh: Update EMC handler" from Jul
> 17, 2008, leads to the following static checker warning:
>=20
> 	drivers/scsi/device_handler/scsi_dh_emc.c:252 parse_sp_model()
> 	warn: buffer overflow 'buffer' 252 <=3D 255
>=20
> drivers/scsi/device_handler/scsi_dh_emc.c
>    217  static char * parse_sp_model(struct scsi_device *sdev, unsign=
ed char *buffer)
>    218  {
>    219          unsigned char len =3D buffer[4] + 5;
>=20
> The warning is simply because Smatch assumes that "len" can be up to =
255
> since it is a u8.  That is likely not a real concern but I think ther=
e
> are some off by one errors.
>=20
>    220          char *sp_model =3D NULL;
>    221          unsigned char sp_len, serial_len;
>    222 =20
>    223          if (len < 160) {
>=20
> These conditions seem off by one to me.  If len =3D=3D 160 then we ca=
n read
> up to buffer[159]?  I think this should be:
>=20
> 		if (len < 161).
>=20
>    224                  sdev_printk(KERN_WARNING, sdev,
>    225                              "%s: Invalid information section =
length %d\n",
>    226                              CLARIION_NAME, len);
>    227                  /* Check for old FC arrays */
>    228                  if (!strncmp(buffer + 8, "DGC", 3)) {
>    229                          /* Old FC array, not supporting exten=
ded information */
>    230                          sp_model =3D emc_default_str;
>    231                  }
>    232                  goto out;
>    233          }
>    234 =20
>    235          /*
>    236           * Parse extended information for SP model number
>    237           */
>    238          serial_len =3D buffer[160];
>    239          if (serial_len =3D=3D 0 || serial_len + 161 > len) {
>=20
> Here the > should probably be >=3D.
>=20
>    240                  sdev_printk(KERN_WARNING, sdev,
>    241                              "%s: Invalid array serial number =
length %d\n",
>    242                              CLARIION_NAME, serial_len);
>    243                  goto out;
>    244          }
>    245          sp_len =3D buffer[99];
>    246          if (sp_len =3D=3D 0 || serial_len + sp_len + 161 > le=
n) {
>=20
> And here as well.
>=20
>    247                  sdev_printk(KERN_WARNING, sdev,
>    248                              "%s: Invalid model number length =
%d\n",
>    249                              CLARIION_NAME, sp_len);
>    250                  goto out;
>    251          }
>    252          sp_model =3D &buffer[serial_len + 161];
>=20
>=20
> Otherwise we are potetially reading from &buffer[len] here which look=
s
> off by one.
>=20
>    253          /* Strip whitespace at the end */
>    254          while (sp_len > 1 && sp_model[sp_len - 1] =3D=3D ' ')
>    255                  sp_len--;
>    256 =20
>    257          sp_model[sp_len] =3D '\0';
>    258 =20
>    259  out:
>    260          return sp_model;
>    261  }
>=20
Thanks, I'll be sending a patch for it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
