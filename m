From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: 14 Oct 2004 10:25:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097767531.1717.20.camel@mulgrave>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
	<416DC8A4.6070107@torque.net>  <ac71172a0410132349715aa9b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37076 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266195AbUJNP0x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 11:26:53 -0400
In-Reply-To: <ac71172a0410132349715aa9b4@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: Lan Tran <transter@gmail.com>
Cc: Douglas Gilbert <dougg@torque.net>, "Qi, Yanling" <yanling.qi@engenio.com>, Dave Olien <dmo@osdl.org>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-10-14 at 01:49, Lan Tran wrote:
> And it was due to the fact that when a bio is sent down to the
> mid-layer, it would come back with another bio chained to it, so when
> the original bio was retried, the  number of segments that were mapped
> (i.e. 2, one from each bio) did not match the value stored in
> cmd->use_sg (i.e. 1).

This sounds a bit unlikely, since the SCSI layer never deals with bios
per se, it merely maps a request (which is a collection of bios).  What
was the evidence that this was happening?

I can see the reverse being true: the scsi request is partially complete
when requeued, so some of the bios are fully complete and somehow this
causes a miscalculation in the segments.  However, the miscalculation
has to be that we undercount the number of needed request slots, and
this looks hard to do.

>  I still haven't figured out why chained bios
> from indepedent IO requests are returned from the mid-layer ... but
> may be a similar issue you're seeing here?

It sounds similar.  The problem seems to be in requeuing somehow.  I'm
going to dig out my old requeueing simulator and see if I can reproduce
it.

James


