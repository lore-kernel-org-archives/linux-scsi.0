From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Fri, 15 Jul 2005 23:10:18 -0300
Message-ID: <20050716021018.GA1555@ime.usp.br>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de> <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <42D82E49.7090907@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout1.uol.com.br ([200.221.4.192]:45553 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S262005AbVGPCKV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 22:10:21 -0400
Received: from dumont.rtb.ath.cx (unknown [200.221.104.251])
	by scorpion1.uol.com.br (Postfix) with ESMTP id 03B607CD9
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2005 23:10:19 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <42D82E49.7090907@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ben Collins <bcollins@debian.org>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, James.Bottomley@SteelEye.com

Hi, Stefan.

On Jul 15 2005, Stefan Richter wrote:
> Rog=E9rio, try "modprobe ieee1394 disable_irm=3D1" again, of course b=
efore
> ohci1394 is loaded. Make sure that sd_mod was loaded.

Ok, I tried this. Here is the relevant part of the dmesg (the whole log=
 is
uploaded to http://www.ime.usp.br/~rbrito/bug/):

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
SCSI subsystem initialized
ieee1394: Initialized config rom entry `ip1394'
ieee1394: IRM functionality disabled
sbp2: $Rev: 1311 $ Ben Collins <bcollins@debian.org>
ohci1394: $Rev: 1313 $ Ben Collins <bcollins@debian.org>
PCI: Found IRQ 5 for device 0000:00:0a.0
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=3D[5]  MMIO=3D[db800000-db=
8007ff]  Max Packet=3D[2048]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011066645555ead]
ieee1394: Node added: ID:BUS[0-01:1023]  GUID[0050c501e00010e8]
scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: Node 0-01:1023: Max speed [S400] - Max payload [2048]
  Vendor: ST316002  Model: 1A                Rev: 3.06
  Type:   Unknown                            ANSI SCSI revision: 06
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sda: drive cache: write back
 sda: [mac] sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -

This time, I removed everything like udev and hotplug, doing things by
hand. I loaded the ohci1394 module after I loaded the sbp2 module.

The drive works this way, but the mouse (ps2) doesn't work. I don't kno=
w if
this is related to the fact that I am not using the hotplug scripts (OT=
OH,
I do see that the kernel has identified the mouse in the dmesg log).

> If this does not help, enable scsi_print_command(...) and=20
> scsi_print_sense(...)
> in sbp2scsi_complete_command(), i.e. #define CONFIG_IEEE1394_SBP2_DEB=
UG 1
> or 2 near the beginning of sbp2.c. I assume there won't be too much=20
> resulting SCSI traffic logged, so you could post it directly here to =
the
> lists.

I will try this right now with the hotplug/udev scripts back (with the
patch you mentioned) and without disable_irm.


Thanks, Rog=E9rio.

--=20
Rog=E9rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
Homepage of the algorithms package : http://algorithms.berlios.de
Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
