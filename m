From: Lan Tran <transter@gmail.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Wed, 13 Oct 2004 23:49:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ac71172a0410132349715aa9b4@mail.gmail.com>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
	 <416DC8A4.6070107@torque.net>
Reply-To: Lan Tran <transter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.194]:15484 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S269979AbUJNGtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 02:49:12 -0400
Received: by mproxy.gmail.com with SMTP id 80so306563rnk
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2004 23:49:09 -0700 (PDT)
In-Reply-To: <416DC8A4.6070107@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Qi, Yanling" <yanling.qi@engenio.com>, Dave Olien <dmo@osdl.org>, James Bottomley <james.bottomley@steeleye.com>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Don't know if this will help or hinder, but I was also getting the
same error for a multipathing block layer driver  we have been working
on:

Incorrect number of segments after building list
counted 2, received 1
req nr_sec 0, cur_nr_sec 8

And it was due to the fact that when a bio is sent down to the
mid-layer, it would come back with another bio chained to it, so when
the original bio was retried, the  number of segments that were mapped
(i.e. 2, one from each bio) did not match the value stored in
cmd->use_sg (i.e. 1).  I still haven't figured out why chained bios
from indepedent IO requests are returned from the mid-layer ... but
may be a similar issue you're seeing here?

Lan

On Thu, 14 Oct 2004 10:30:28 +1000, Douglas Gilbert <dougg@torque.net> wrote:
> Qi, Yanling wrote:
> > The check-condition (06h/8Bh/02h) is Engenio's vendor specific UA. It
> > means "Quiescence Is In Progress" while transferring a volume from one
> > controller to the other. When the volume transfer (cache sync and
> > bookkeeping) is completed, the device server will start accept IO requests.
> >
> > Yanling
> 
> Thanks for that information.
> 
> So in the future when we print a SK/ASC/ASCQ sequence to log
> we should note:
>    a) if (asc >= 0x80) then it is vendor specific
>    b) if (ascq >= 0x80) then it is a vendor specific qualification
>       of a standard asc value
> 
> That should alert diligent users to look at the vendor's product
> manual or to contact the vendor.
> 
> Doug Gilbert
> 
> 
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org
> > [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Dave Olien
> > Sent: Wednesday, October 13, 2004 12:57 PM
> > To: Douglas Gilbert
> > Cc: James Bottomley; Tim Pepper; SCSI Mailing List
> > Subject: Re: Question about Request Sense case in scsi_lib.c
> >
> >
> >
> > Here's what seeing out of the SCSI log:
> >
> >         command = Write (10) 00 00 00 84 00 00 04 00 00
> > Current sdx: sense key Unit Attention
> > ASC=8b ASCQ= 2
> > P<6>scsi <2:0:2:3> done SUCCESS        2 scsi2 : destination target 2,
> > lun 3
> >         command = Write (10) 00 00 00 88 00 00 04 00 00
> > Current sdx: sense key Unit Attention
> > ASC=8b ASCQ= 2
> > P<6>scsi <2:0:2:0> done SUCCESS        2 scsi2 : destination target 2,
> > lun 0
> >         command = Write (10) 00 00 00 00 48 00 04 00 00
> > Current sdu: sense key Unit Attention
> > ASC=8b ASCQ= 2
> > P<3>Incorrect number of segments after building list
> > counted 11, received 5
> > req nr_sec 1024, cur_nr_sec 8
> >
> >
> > On Wed, Oct 13, 2004 at 12:10:21PM +1000, Douglas Gilbert wrote:
> >  > UNIT ATTENTION and NOT READY are both sense keys so a
> >  > device can't yield both on one command. However you may be
> >  > on the right track as there is an ever increasing number of
> >  > reasons a device could issue a UNIT ATTENTION. [See SPC-3
> >  > rev 21 and I believe these ASC codes (and all their associated
> >  > ASCQ codes) occur with a sense key of UNIT ATTENTION:
> >  > 0x28, 0x29, 0x2a, 0x3f, 0x5b/0x1 and 0x5d.]
> >  >
> >  > Unlikely in this case but a sense key of UNIT ATTENTION
> >  > (or perhaps RECOVERED ERROR)  with an additional sense
> >  > of "Hardware impending failure, seek error rate too high"
> >  > may slip by without even a log entry.
> >  >
> >  > >As for the error, I still don't understand that, but it looks like
> >  > >something went wrong in setting up or tearing down the dma mapping, so
> >  > >that it was incorrectly described when this happened a second time.
> >  >
> >  > I hope to address the code in the scsi_io_completion() error/warning
> >  > processing paths with the descriptor_sense cleanup. There seems to
> >  > be a missing scsi_print_sense() call on the UNIT ATTENTION path.
> >  >
> >  > Dave, does your log show a bus error (ASC/ASCQ=0x29/0x2) has occurred?
> >  >
> >  > Doug Gilbert
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
