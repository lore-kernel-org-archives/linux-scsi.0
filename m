From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Sat, 17 Nov 2007 12:20:58 -0700
Message-ID: <8202f4270711171120nddf24a8m8d1ece8c41b6c1ab@mail.gmail.com>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>
	 <473E6E62.9090309@rtr.ca>
	 <8202f4270711162320s2eb1d48dwb1430f4a779809a9@mail.gmail.com>
	 <473F15E1.5030601@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <473F15E1.5030601@rtr.ca>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 11/17/07, Mark Lord <liml@rtr.ca> wrote:
> Fajun Chen wrote:
> > On 11/16/07, Mark Lord <liml@rtr.ca> wrote:
> >> Fajun Chen wrote:
> >>> Hi All,
> >>>
> >>> I use sg/libata and ata pass through for read/writes. Linux 2.6.18-rc2
> >>> and libata version 2.00 are loaded on ARM XScale board.  Under heavy
> >>> cpu load (e.g. when blocks per transfer/sector count is set to 1),
> >>> I've observed that the test application can suck cpu away for long
> >>> time (more than 20 seconds) and other processes including high
> >>> priority shell can not get the time slice to run.  What's interesting
> >>> is that if the application is under heavy IO load (e.g. when blocks
> >>> per transfer/sector count is set to 256),  the problem goes away. I
> >>> also tested with open source code sg_utils and got the same result, so
> >>> this is not a problem specific to my user-space application.
> >> ..
> >>
> >> Post the relevant code here, and then we'll be able to better understand
> >> and explain it to you.
> >>
> >> For example, if the code is using ATA opcodes 0x20, 0x21, 0x24,
> >> 0x30, 0x31, 0x34, 0x29, 0x39, 0xc4 or 0xc5 (any of the R/W PIO ops),
> >> then this behaviour does not surprise me in the least.  Fully expected
> >> and difficult to avoid.
> >>
> >
> > This problem also happens with R/W DMA ops. Below are simplified code snippets:
> >     // Open one sg device for read
> >       if ((sg_fd  = open(dev_name, O_RDWR))<0)
> >       {
> >           ...
> >       }
> >       read_buffer = (U8 *)mmap(NULL, buf_sz, PROT_READ | PROT_WRITE,
> >                              MAP_SHARED, sg_fd, 0);
> >
> >     // Open the same sg device for write
> >       if ((sg_fd_wr = open(dev_name, O_RDWR))<0)
> >       {
> >          ...
> >       }
> >       write_buffer = (U8 *)mmap(NULL, buf_sz, PROT_READ | PROT_WRITE,
> >                              MAP_SHARED, sg_fd_wr, 0);
> ..
>
> Mmmm.. what is the purpose of those two mmap'd areas ?
> I think this is important and relevant here:  what are they used for?
>
> As coded above, these are memory mapped areas taht (1) overlap,
> and (2) will be demand paged automatically to/from the disk
> as they are accessed/modified.  This *will* conflict with any SG_IO
> operations happening at the same time on the same device.
>
> ????

The purpose of using two memory mapped areas is to meet our
requirement that certain data patterns for writing need to be kept
across commands. For instance, if one buffer is used for both reads
and writes, then this buffer will need to be re-populated with certain
write data after each read command, which would be very costly for
write-read mixed type of ops. This separate R/W buffer setting also
facilitates data comparison.

These buffers are not used at the same time (one will be used only
after the command on the other is completed). My application is the
only program accessing disk using sg/libata and the rest of the
programs run from ramdisk. Also, each buffer is only about 0.5MB and
we have 64MB RAM on the target board.
With this setup,  these two buffers should be pretty much independent
and free from block layer/file system, correct?

One thing is worthy of mentioning here. If the application is set to
low priority (nice 19) or sched_yield() is called after each R/W
command, then this issue disappears but performance suffers.

Some thoughts here. For  a static process, Linux scheduler could
assign some dynamic priority to it based on activity and age, etc. Any
chance  that the scheduler favors my application unfairly due to the
load condition?

Thanks,
Fajun
