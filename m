From: Dave Olien <dmo@osdl.org>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Wed, 13 Oct 2004 10:56:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041013175655.GA30013@osdl.org>
References: <20041012000058.GA26569@osdl.org> <eada2a07041012092973d35415@mail.gmail.com> <20041012165919.GA27526@osdl.org> <1097601199.2044.91.camel@mulgrave> <416C8E8D.7050000@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:48573 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S269768AbUJMR53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 13:57:29 -0400
Content-Disposition: inline
In-Reply-To: <416C8E8D.7050000@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Here's what seeing out of the SCSI log:

        command = Write (10) 00 00 00 84 00 00 04 00 00
Current sdx: sense key Unit Attention
ASC=8b ASCQ= 2
P<6>scsi <2:0:2:3> done SUCCESS        2 scsi2 : destination target 2, lun 3
        command = Write (10) 00 00 00 88 00 00 04 00 00
Current sdx: sense key Unit Attention
ASC=8b ASCQ= 2
P<6>scsi <2:0:2:0> done SUCCESS        2 scsi2 : destination target 2, lun 0
        command = Write (10) 00 00 00 00 48 00 04 00 00
Current sdu: sense key Unit Attention
ASC=8b ASCQ= 2
P<3>Incorrect number of segments after building list
counted 11, received 5
req nr_sec 1024, cur_nr_sec 8


On Wed, Oct 13, 2004 at 12:10:21PM +1000, Douglas Gilbert wrote:
> UNIT ATTENTION and NOT READY are both sense keys so a
> device can't yield both on one command. However you may be
> on the right track as there is an ever increasing number of
> reasons a device could issue a UNIT ATTENTION. [See SPC-3
> rev 21 and I believe these ASC codes (and all their associated
> ASCQ codes) occur with a sense key of UNIT ATTENTION:
> 0x28, 0x29, 0x2a, 0x3f, 0x5b/0x1 and 0x5d.]
> 
> Unlikely in this case but a sense key of UNIT ATTENTION
> (or perhaps RECOVERED ERROR)  with an additional sense
> of "Hardware impending failure, seek error rate too high"
> may slip by without even a log entry.
> 
> >As for the error, I still don't understand that, but it looks like
> >something went wrong in setting up or tearing down the dma mapping, so
> >that it was incorrectly described when this happened a second time.
> 
> I hope to address the code in the scsi_io_completion() error/warning
> processing paths with the descriptor_sense cleanup. There seems to
> be a missing scsi_print_sense() call on the UNIT ATTENTION path.
> 
> Dave, does your log show a bus error (ASC/ASCQ=0x29/0x2) has occurred?
> 
> Doug Gilbert
