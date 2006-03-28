From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/5] AIC7xxx : remove qfrozen
Date: Tue, 28 Mar 2006 09:53:41 -0600
Message-ID: <1143561222.3353.19.camel@mulgrave.il.steeleye.com>
References: <IWUGSW$1A08F7ADC49061416D53454FC5B6672B@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45293 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932074AbWC1PyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:54:00 -0500
In-Reply-To: <IWUGSW$1A08F7ADC49061416D53454FC5B6672B@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel =?ISO-8859-1?Q?Fust=E9?= <emmanuel.fuste@laposte.net>
Cc: hare <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-03-28 at 17:38 +0200, Emmanuel Fust=C3=A9 wrote:
> @@ -747,14 +740,11 @@ ahc_linux_bus_reset(struct scsi_cmnd *cm
>  {
>         struct ahc_softc *ahc;
>         int    found;
> -       unsigned long flags;
> =20
>         ahc =3D *(struct ahc_softc **)cmd->device->host->hostdata;
> =20
> -       ahc_lock(ahc, &flags);
>         found =3D ahc_reset_channel(ahc, scmd_channel(cmd) + 'A',
>                                   /*initiate reset*/TRUE);
> -       ahc_unlock(ahc, &flags);

This looks to be a bug in aic79xx which is being copied into aic7xxx.

You can't call the reset function without holding the locks because it
will try to pause the sequencer.  The locks are essentially to gate
access to the sequencer registers.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
