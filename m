From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Thu, 14 Oct 2004 10:30:28 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416DC8A4.6070107@torque.net>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:48907 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S269933AbUJNAbe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 20:31:34 -0400
In-Reply-To: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <yanling.qi@engenio.com>
Cc: 'Dave Olien' <dmo@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Qi, Yanling wrote:
> The check-condition (06h/8Bh/02h) is Engenio's vendor specific UA. It 
> means "Quiescence Is In Progress" while transferring a volume from one 
> controller to the other. When the volume transfer (cache sync and 
> bookkeeping) is completed, the device server will start accept IO requests.
> 
> Yanling

Thanks for that information.

So in the future when we print a SK/ASC/ASCQ sequence to log
we should note:
   a) if (asc >= 0x80) then it is vendor specific
   b) if (ascq >= 0x80) then it is a vendor specific qualification
      of a standard asc value

That should alert diligent users to look at the vendor's product
manual or to contact the vendor.

Doug Gilbert

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Dave Olien
> Sent: Wednesday, October 13, 2004 12:57 PM
> To: Douglas Gilbert
> Cc: James Bottomley; Tim Pepper; SCSI Mailing List
> Subject: Re: Question about Request Sense case in scsi_lib.c
> 
> 
> 
> Here's what seeing out of the SCSI log:
> 
>         command = Write (10) 00 00 00 84 00 00 04 00 00
> Current sdx: sense key Unit Attention
> ASC=8b ASCQ= 2
> P<6>scsi <2:0:2:3> done SUCCESS        2 scsi2 : destination target 2, 
> lun 3
>         command = Write (10) 00 00 00 88 00 00 04 00 00
> Current sdx: sense key Unit Attention
> ASC=8b ASCQ= 2
> P<6>scsi <2:0:2:0> done SUCCESS        2 scsi2 : destination target 2, 
> lun 0
>         command = Write (10) 00 00 00 00 48 00 04 00 00
> Current sdu: sense key Unit Attention
> ASC=8b ASCQ= 2
> P<3>Incorrect number of segments after building list
> counted 11, received 5
> req nr_sec 1024, cur_nr_sec 8
> 
> 
> On Wed, Oct 13, 2004 at 12:10:21PM +1000, Douglas Gilbert wrote:
>  > UNIT ATTENTION and NOT READY are both sense keys so a
>  > device can't yield both on one command. However you may be
>  > on the right track as there is an ever increasing number of
>  > reasons a device could issue a UNIT ATTENTION. [See SPC-3
>  > rev 21 and I believe these ASC codes (and all their associated
>  > ASCQ codes) occur with a sense key of UNIT ATTENTION:
>  > 0x28, 0x29, 0x2a, 0x3f, 0x5b/0x1 and 0x5d.]
>  >
>  > Unlikely in this case but a sense key of UNIT ATTENTION
>  > (or perhaps RECOVERED ERROR)  with an additional sense
>  > of "Hardware impending failure, seek error rate too high"
>  > may slip by without even a log entry.
>  >
>  > >As for the error, I still don't understand that, but it looks like
>  > >something went wrong in setting up or tearing down the dma mapping, so
>  > >that it was incorrectly described when this happened a second time.
>  >
>  > I hope to address the code in the scsi_io_completion() error/warning
>  > processing paths with the descriptor_sense cleanup. There seems to
>  > be a missing scsi_print_sense() call on the UNIT ATTENTION path.
>  >
>  > Dave, does your log show a bus error (ASC/ASCQ=0x29/0x2) has occurred?
>  >
>  > Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

