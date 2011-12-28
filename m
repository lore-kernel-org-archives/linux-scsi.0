From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH]libsas : do not set invalid phy
Date: Wed, 28 Dec 2011 11:08:41 -0800
Message-ID: <CAA9_cmf0Z6JZ5j=+h3wx8h7w9GvMjvz5JPMPiH_KfPt+bZyYNQ@mail.gmail.com>
References: <55AF4742E909495DB7D4D448381E7BFB@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51529 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1L1TIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2011 14:08:42 -0500
Received: by vcbfk14 with SMTP id fk14so9684090vcb.19
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2011 11:08:41 -0800 (PST)
In-Reply-To: <55AF4742E909495DB7D4D448381E7BFB@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: yuxiangl@marvell.com, ltuikov@yahoo.com, James.Bottomley@hansenpartnership.com, james <linux-scsi@vger.kernel.org>

On Tue, Dec 27, 2011 at 4:49 PM, Jack Wang <jack_wang@usish.com> wrote:
> Hi all,
>
> For detecting a failure to transmit initial dev to host FIS as descri=
bed in
> section G.5 of sas-2 r 04b , In order to generate the dev to host FIS=
, we
> send a link reset to the expander port, but this may still fail for s=
ome
> device, when this happened , we should ignore this , do not set the p=
hy, let
> libsas find the device later .
>
> From a315c8ee6f6b7ad000d6dc72d31dfb576ecbceb5 Mon Sep 17 00:00:00 200=
1
> From: Jack Wang <jack_wang@usish.com>
> Date: Tue, 27 Dec 2011 02:25:19 -0500
> Subject: [PATCH] don't set the invalid phy
>
> Signed-off-by: Lindar Liu <Lindar_liu@usish.com>
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> ---
> =A0drivers/scsi/libsas/sas_expander.c | =A0 =A06 ++++++
> =A01 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_expander.c
> b/drivers/scsi/libsas/sas_expander.c
> index e47599b..c7a27c7 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -304,6 +304,12 @@ static int sas_ex_phy_discover_helper(struct
> domain_device *dev, u8 *disc_req,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Wait for the reset to trigger the n=
egotiation */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0msleep(500);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 if ((dr->attached_dev_type =3D=3D 0 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dr->attached_sata_dev)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sas_printk("Found sata attached_dev_typ=
e =3D 0, ignore it to
> let it found later!\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0sas_set_ex_phy(dev, single, disc_resp);
> =A0 =A0 =A0 =A0return 0;
> =A0}

I wonder if we should just simulate the discovery of a sata disk in
this scenario?? Because the first thing libata is going to do is reset
it and wait for that to settle...

However, for that to work we would need to allow sas_ata_hard_reset to
set the detected device class.  The current scheme of returning
dev->sata_dev.command_set (from what libsas set) is awkward since we
may have legitimately switched device classes during the reset, and
certainly wrong if we were not able to make a proper classification
during initial discovery.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
