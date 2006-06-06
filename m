From: "adam radford" <aradford@gmail.com>
Subject: Re: [SCSI] 3w-9xxx: kmap_atomic in twa_scsiop_execute_scsi
Date: Tue, 6 Jun 2006 11:46:56 -0700
Message-ID: <b1bc6a000606061146p7a26aca9o62f9a8c22ffb0c63@mail.gmail.com>
References: <DB599F406D04E34389140B7D99C71B1B0203D625@SDCEXCHANGE01.ad.amcc.com>
	 <44851778.7010107@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:30342 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S1750947AbWFFSq5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 14:46:57 -0400
Received: by wr-out-0506.google.com with SMTP id 55so240270wri
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2006 11:46:56 -0700 (PDT)
In-Reply-To: <44851778.7010107@sw.ru>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: Adam Radford <aradford@amcc.com>, linuxraid <linuxraid@amcc.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, devel@openvz.org, Andrew Morton <akpm@osdl.org>

Vasily,

On 6/5/06, Vasily Averin <vvs@sw.ru> wrote:

> I'm agree that queuecommand() executed with disabled interrupts. However
> twa_scsiop_execute_scsi() can be called not only from queuecommand. For example,
>
> twa_interrupts (note: with _enabled_ interrupts)
>    twa_aen_read_queue
>      twa_scsiop_execute_scsi
>

twa_scsiop_execute_scsi() will not perform the kmap_atomic()/kunmap_atomic()
calls here because it is being used for an internal AEN drain  (cdb
post), i.e. "sglistarg" is non NULL.  See below:

if (!sglistarg) {

  ....
   kmap_atomc()
   kunmap_atomic()

} else {
   /* Internal cdb post */

}

> or
>
> twa_chrdev_ioctl
>    twa_reset_device_extension
>       twa_reset_sequence
>          twa_aen_drain_queue
>             twa_scsiop_execute_scsi

ditto for this location as well.

Thanks for looking over this code.  If you see anything else suspect,
feel free to let me know.

-Adam

>
> Thank you,
>         Vasily Averin
>
> SWsoft Virtuozzo/OpenVZ Linux kernel team
>
> > -----Original Message-----
> > From: Vasily Averin [mailto:vvs@sw.ru]
> > Sent: Sunday, June 04, 2006 1:49 AM
> > To: adam radford; linuxraid
> > Cc: James Bottomley; Linux Kernel Mailing List;
> > linux-scsi@vger.kernel.org; devel@openvz.org; Andrew Morton
> > Subject: [SCSI] 3w-9xxx: kmap_atomic in twa_scsiop_execute_scsi
> >
> > Hello Adam,
> >
> > you have fixed recently potential memory corruption, kmap_atomic issue
> > in 3w-9xxx driver, however it seems for me you have forgotten to fix the
> > same issue in yet another similar place, in twa_scsiop_execute_scsi()
> > function.
> >
> > Signed-off-by: Vasily Averin <vvs@sw.ru>
> >
> > Thank you,
> >       Vasily Averin
> >
> > SWsoft Virtuozzo/OpenVZ Linux kernel team
> >
> >
>
>
