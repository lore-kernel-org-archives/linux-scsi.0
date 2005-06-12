From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Sun, 12 Jun 2005 10:38:29 -0500
Message-ID: <1118590709.4967.6.camel@mulgrave>
References: <20050526143516.GA9593@gmail.com>
	 <1117118766.4967.22.camel@mulgrave> <20050526173518.GA9132@gmail.com>
	 <1117463938.4913.3.camel@mulgrave> <20050530150950.GA14351@gmail.com>
	 <1117467248.4913.9.camel@mulgrave> <20050530160147.GD14351@gmail.com>
	 <1117477040.4913.12.camel@mulgrave> <20050530190716.GA9239@gmail.com>
	 <1118081857.5045.49.camel@mulgrave>  <20050607085710.GB9230@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29145 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262622AbVFLPiu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jun 2005 11:38:50 -0400
In-Reply-To: <20050607085710.GB9230@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-06-07 at 10:57 +0200, Gr=E9goire Favre wrote:
> I have set all device to 10 Mhz (for that controller) in the BIOS, bu=
t I
> still can't boot.

OK, let's see if I can find out why this particular controller isn't
transferring the bios settings to the transport class max and min

Try this patch and send me the output.

Thanks,

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -620,9 +620,11 @@ ahc_linux_target_alloc(struct scsi_targe
 	*ahc_targp =3D starget;
 	memset(targ, 0, sizeof(*targ));
=20
+	dev_printk(KERN_ERR, &starget->dev, "SC IS %p\n", sc);
 	if (sc) {
 		if ((ahc->features & AHC_ULTRA2) !=3D 0) {
 			scsirate =3D sc->device_flags[target_offset] & CFXFER;
+			dev_printk(KERN_ERR, &starget->dev, "ULTRA2\n");
 		} else {
 			scsirate =3D (sc->device_flags[target_offset] & CFXFER) << 4;
 			if (sc->device_flags[target_offset] & CFSYNCH)
@@ -635,6 +637,12 @@ ahc_linux_target_alloc(struct scsi_targe
 			spi_max_width(starget) =3D 0;
 		spi_min_period(starget) =3D=20
 			ahc_find_period(ahc, scsirate, AHC_SYNCRATE_DT);
+		dev_printk(KERN_ERR, &starget->dev, "scsirate IS 0x%x, min_period is=
 %d\n", scsirate, spi_min_period(starget));
+		if (spi_min_period(starget) =3D=3D 0)
+			/* This means async, so set offset to zero */
+			spi_max_offset(starget) =3D 0;
+	=09
+
 		tinfo =3D ahc_fetch_transinfo(ahc, channel, ahc->our_id,
 					    starget->id, &tstate);
 	}


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
