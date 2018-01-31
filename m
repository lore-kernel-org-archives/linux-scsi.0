From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Spread interrupts when picking a
 channel for I/O requests
Date: Wed, 31 Jan 2018 21:22:02 +0000
Message-ID: <MWHPR21MB0846771D9A9BCD5A5ACA2E51CEFB0@MWHPR21MB0846.namprd21.prod.outlook.com>
References: <1516831913-26013-1-git-send-email-mikelley@ntdev.microsoft.com>
 <DM5PR2101MB1030445CF939E0C6A3BE3AC7DCE20@DM5PR2101MB1030.namprd21.prod.outlook.com>
 <MWHPR21MB084683CD3983777444DC0F77CEFB0@MWHPR21MB0846.namprd21.prod.outlook.com>
 <DM5PR2101MB103010D03B9F6DBF15985814DCFB0@DM5PR2101MB1030.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0113.outbound.protection.outlook.com ([104.47.32.113]:61353
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753219AbeAaVWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 16:22:07 -0500
In-Reply-To: <DM5PR2101MB103010D03B9F6DBF15985814DCFB0@DM5PR2101MB1030.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>

> Subject: RE: [PATCH 1/1] scsi: storvsc: Spread interrupts when picking a
> channel for I/O requests
>=20
> > From: Long Li
> > Sent: Wednesday, January 31, 2018 12:23 PM
> > To: Michael Kelley (EOSG) <Michael.H.Kelley@microsoft.com>; KY
> > Srinivasan <kys@microsoft.com>; Stephen Hemminger
> > <sthemmin@microsoft.com>; martin.petersen@oracle.com;
> > devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> > linux-scsi@vger.kernel.org; James E . J . Bottomley
> > <jejb@linux.vnet.ibm.com>
> > Subject: RE: [PATCH 1/1] scsi: storvsc: Spread interrupts when picking
> > a channel for I/O requests
> >
> > > Subject: RE: [PATCH 1/1] scsi: storvsc: Spread interrupts when
> > > picking a channel for I/O requests
> > >
> > > Updated/corrected two email addresses ...
> > >
> > > > -----Original Message-----
> > > > From: Michael Kelley (EOSG)
> > > > Sent: Wednesday, January 24, 2018 2:14 PM
> > > > To: KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> > > > <sthemmin@microsoft.com>; martin.petersen@oracle.com;
> > > > longi@microsoft.com; JBottomley@odin.com;
> > > > devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> > > > linux-scsi@vger.kernel.org
> > > > Cc: Michael Kelley (EOSG) <Michael.H.Kelley@microsoft.com>
> > > > Subject: [PATCH 1/1] scsi: storvsc: Spread interrupts when picking
> > > > a channel for I/O requests
> > > >
> > > > Update the algorithm in storvsc_do_io to look for a channel
> > > > starting with the current CPU + 1 and wrap around (within the
> > > > current NUMA node). This spreads VMbus interrupts more evenly
> > > > across CPUs. Previous code always started with first CPU in the
> > > > current NUMA node, skewing the interrupt load to that CPU.
> > > >
> > > > Signed-off-by: Michael Kelley <mikelley@microsoft.com>

Reviewed-by: Long Li <longli@microsoft.com>

> > > > ---
> > > >  drivers/scsi/storvsc_drv.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/scsi/storvsc_drv.c
> > > > b/drivers/scsi/storvsc_drv.c index e07907d..f3264c4 100644
> > > > --- a/drivers/scsi/storvsc_drv.c
> > > > +++ b/drivers/scsi/storvsc_drv.c
> > > > @@ -1310,7 +1310,8 @@ static int storvsc_do_io(struct hv_device
> *device,
> > > >  			 */
> > > >  			cpumask_and(&alloced_mask, &stor_device-
> alloced_cpus,
> > > >
> > > cpumask_of_node(cpu_to_node(q_num)));
> > > > -			for_each_cpu(tgt_cpu, &alloced_mask) {
> > > > +			for_each_cpu_wrap(tgt_cpu, &alloced_mask,
> > > > +					outgoing_channel->target_cpu + 1) {
> >
> > Does it work when target_cpu is the last CPU on the system?
> >
> > Otherwise, looking good.
>=20
> Yes, it works.  for_each_cpu_wrap() correctly wraps in the case where the
> 3rd parameter ('start') is one past the end of the mask.  Arguably, we
> shouldn't rely on that, and should do the wrap to 0 before calling
> for_each_cpu_wrap().
>=20
> >
> > > >  				if (tgt_cpu !=3D outgoing_channel->target_cpu)
> > > {
> > > >  					outgoing_channel =3D
> > > >  					stor_device->stor_chns[tgt_cpu];
> > > > --
> > > > 1.8.3.1
