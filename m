From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH ver. 2] sd: Fix regression in sd_read_cache_type
Date: Wed, 23 Mar 2011 10:40:55 -0700 (PDT)
Message-ID: <711020.90880.qm@web31810.mail.mud.yahoo.com>
References: <Pine.LNX.4.44L0.1103231216030.2211-100000@iolanthe.rowland.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.190]:21605 "HELO
	nm4-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755135Ab1CWRk4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:56 -0400
In-Reply-To: <Pine.LNX.4.44L0.1103231216030.2211-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: Richard Senior <richard@r-senior.demon.co.uk>, SCSI development list <linux-scsi@vger.kernel.org>

--- On Wed, 3/23/11, Alan Stern <stern@rowland.harvard.edu> wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> Subject: [PATCH ver. 2] sd: Fix regression in sd_read_cache_type
> To: "James Bottomley" <James.Bottomley@suse.de>
> Cc: ltuikov@yahoo.com, "Richard Senior" <richard@r-senior.demon.co.uk=
>, "SCSI development list" <linux-scsi@vger.kernel.org>
> Date: Wednesday, March 23, 2011, 9:18 AM
> This patch (as1454b) fixes a
> regression in the sd driver.=A0 Commit
> 24d720b726c1a85f1962831ac30ad4d2ef8276b1 ([SCSI] Retrieve
> the Caching
> mode page) recently introduced the strategy of asking for
> all pages
> (page code 0x3F) instead of asking for the caching page
> (0x08) on
> devices that might not support it.=A0 This ought to be
> safe, because sd
> already uses page code 0x3F when checking for write
> protection.
>=20
> Unfortunately, the commit did not copy the checks used by
> sd_read_write_protect_flag().=A0 Some devices don't
> support page code
> 0x3F, and others require a fixed transfer length of 192
> bytes.=A0 This
> patch adds those checks into sd_read_cache_type().
>=20
> Without this fix, some USB mass-storage devices crash when
> they
> receive a MODE SENSE command with page code 0x3F asking for
> only 4
> bytes of data.
>=20
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-and-tested-by: Richard Senior <richard@r-senior.demon.co.uk>
> CC: Luben Tuikov <ltuikov@yahoo.com>

Acked-by: Luben Tuikov <ltuikov@yahoo.com>

> CC: <stable@kernel.org>
>=20
> ---
>=20
>  drivers/scsi/sd.c |=A0=A0=A016 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>=20
> Index: usb-2.6/drivers/scsi/sd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-2.6.orig/drivers/scsi/sd.c
> +++ usb-2.6/drivers/scsi/sd.c
> @@ -1904,17 +1904,23 @@ sd_read_cache_type(struct scsi_disk
> *sdk
> =20
>  =A0=A0=A0 int dbd;
>  =A0=A0=A0 int modepage;
> +=A0=A0=A0 int first_len;
>  =A0=A0=A0 struct scsi_mode_data data;
>  =A0=A0=A0 struct scsi_sense_hdr sshdr;
>  =A0=A0=A0 int old_wce =3D sdkp->WCE;
>  =A0=A0=A0 int old_rcd =3D sdkp->RCD;
>  =A0=A0=A0 int old_dpofua =3D sdkp->DPOFUA;
> =20
> +=A0=A0=A0 first_len =3D 4;
>  =A0=A0=A0 if (sdp->skip_ms_page_8) {
>  =A0=A0=A0 =A0=A0=A0 if (sdp->type =3D=3D
> TYPE_RBC)
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> goto defaults;
>  =A0=A0=A0 =A0=A0=A0 else {
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> if (sdp->skip_ms_page_3f)
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 goto defaults;
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> modepage =3D 0x3F;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> if (sdp->use_192_bytes_for_3f)
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 first_len =3D 192;
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> dbd =3D 0;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 } else if (sdp->type =3D=3D TYPE_RBC) {
> @@ -1926,13 +1932,15 @@ sd_read_cache_type(struct scsi_disk
> *sdk
>  =A0=A0=A0 }
> =20
>  =A0=A0=A0 /* cautiously ask */
> -=A0=A0=A0 res =3D sd_do_mode_sense(sdp, dbd,
> modepage, buffer, 4, &data, &sshdr);
> +=A0=A0=A0 res =3D sd_do_mode_sense(sdp, dbd,
> modepage, buffer, first_len,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> &data, &sshdr);
> =20
>  =A0=A0=A0 if (!scsi_status_is_good(res))
>  =A0=A0=A0 =A0=A0=A0 goto bad_sense;
> =20
>  =A0=A0=A0 if (!data.header_length) {
>  =A0=A0=A0 =A0=A0=A0 modepage =3D 6;
> +=A0=A0=A0 =A0=A0=A0 first_len =3D 0;
>  =A0=A0=A0 =A0=A0=A0 sd_printk(KERN_ERR,
> sdkp, "Missing header in MODE_SENSE response\n");
>  =A0=A0=A0 }
> =20
> @@ -1950,9 +1958,13 @@ sd_read_cache_type(struct scsi_disk
> *sdk
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 "data from %d to %d bytes\n", len, SD_BUF_SIZE);
>  =A0=A0=A0 =A0=A0=A0 len =3D SD_BUF_SIZE;
>  =A0=A0=A0 }
> +=A0=A0=A0 if (modepage =3D=3D 0x3F &&
> sdp->use_192_bytes_for_3f)
> +=A0=A0=A0 =A0=A0=A0 len =3D 192;
> =20
>  =A0=A0=A0 /* Get the data */
> -=A0=A0=A0 res =3D sd_do_mode_sense(sdp, dbd,
> modepage, buffer, len, &data, &sshdr);
> +=A0=A0=A0 if (len > first_len)
> +=A0=A0=A0 =A0=A0=A0 res =3D
> sd_do_mode_sense(sdp, dbd, modepage, buffer, len,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 &data, &sshdr);
> =20
>  =A0=A0=A0 if (scsi_status_is_good(res)) {
>  =A0=A0=A0 =A0=A0=A0 int offset =3D
> data.header_length + data.block_descriptor_length;
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
