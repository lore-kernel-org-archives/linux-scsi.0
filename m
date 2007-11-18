From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Sat, 17 Nov 2007 23:48:42 -0700
Message-ID: <8202f4270711172248x5d7abb0aq7a6e1bf2dad44e5e@mail.gmail.com>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>
	 <473E6E62.9090309@rtr.ca>
	 <8202f4270711162320s2eb1d48dwb1430f4a779809a9@mail.gmail.com>
	 <473F15E1.5030601@rtr.ca>
	 <8202f4270711171120nddf24a8m8d1ece8c41b6c1ab@mail.gmail.com>
	 <473F4724.6010107@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:42103 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbXKRGso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Nov 2007 01:48:44 -0500
Received: by wr-out-0506.google.com with SMTP id c49so350868wra
        for <linux-scsi@vger.kernel.org>; Sat, 17 Nov 2007 22:48:43 -0800 (PST)
In-Reply-To: <473F4724.6010107@rtr.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

On 11/17/07, Mark Lord <liml@rtr.ca> wrote:
> Fajun Chen wrote:
> > On 11/17/07, Mark Lord <liml@rtr.ca> wrote:
> >> Fajun Chen wrote:
> >>> On 11/16/07, Mark Lord <liml@rtr.ca> wrote:
> >>>> Fajun Chen wrote:
> ..
> >>> This problem also happens with R/W DMA ops. Below are simplified code snippets:
> >>>     // Open one sg device for read
> >>>       if ((sg_fd  = open(dev_name, O_RDWR))<0)
> >>>       {
> >>>           ...
> >>>       }
> >>>       read_buffer = (U8 *)mmap(NULL, buf_sz, PROT_READ | PROT_WRITE,
> >>>                              MAP_SHARED, sg_fd, 0);
> >>>
> >>>     // Open the same sg device for write
> >>>       if ((sg_fd_wr = open(dev_name, O_RDWR))<0)
> >>>       {
> >>>          ...
> >>>       }
> >>>       write_buffer = (U8 *)mmap(NULL, buf_sz, PROT_READ | PROT_WRITE,
> >>>                              MAP_SHARED, sg_fd_wr, 0);
> >> ..
> >>
> >> Mmmm.. what is the purpose of those two mmap'd areas ?
> >> I think this is important and relevant here:  what are they used for?
> >>
> >> As coded above, these are memory mapped areas taht (1) overlap,
> >> and (2) will be demand paged automatically to/from the disk
> >> as they are accessed/modified.  This *will* conflict with any SG_IO
> >> operations happening at the same time on the same device.
> ..
> > The purpose of using two memory mapped areas is to meet our
> > requirement that certain data patterns for writing need to be kept
> > across commands. For instance, if one buffer is used for both reads
> > and writes, then this buffer will need to be re-populated with certain
> > write data after each read command, which would be very costly for
> > write-read mixed type of ops. This separate R/W buffer setting also
> > facilitates data comparison.
> >
> > These buffers are not used at the same time (one will be used only
> > after the command on the other is completed). My application is the
> > only program accessing disk using sg/libata and the rest of the
> > programs run from ramdisk. Also, each buffer is only about 0.5MB and
> > we have 64MB RAM on the target board.
> > With this setup,  these two buffers should be pretty much independent
> > and free from block layer/file system, correct?
> ..
>
> No.  Those "buffers" as coded above are actually mmap'ed representations
> of portions of the device (disk drive).  So any write into one of those
> buffers will trigger disk writes, and just accessing ("read") the buffers
> may trigger disk reads.
>
> So what could be happening here, is when you trigger manual disk accesses
> via SG_IO, that result in data being copied into those "buffers", the kernel
> then automatically schedules disk writes to update the on-disk copies of
> those mmap'd regions.
>
> What you probably intended to do instead, was to use mmap to just allocate
> some page-aligned RAM, not to actually mmap'd any on-disk data.  Right?
>
> Here's how that's done:
>
>       read_buffer = (U8 *)mmap(NULL, buf_sz, PROT_READ | PROT_WRITE,
>                              MAP_SHARED|MAP_ANONYMOUS, -1, 0);
>
What I intended to do is to write data into disc or read data from
disc via SG_IO as requested by my user-space application. I don't want
any automatically scheduled kernel task to sync data with disc.

I've experimented with memory mapping using MAP_ANONYMOUS as you
suggested, the good news is that it does free up the cpu load and my
system is much more responsive with the change. The bad news is that
the data read back from disc (PIO or DMA read) seems to be invisible
to user-space application. For instance, read buffer is all zeros
after Identify Device command. Is this expected side effect of
MAP_ANONYMOUS option?

Thanks,
Fajun
