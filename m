From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Why is scsi_request_fn called every 4 milliseconds?
Date: Thu, 27 Jan 2011 23:37:02 -0800
Message-ID: <1296200222.3050.145.camel@mulgrave.site>
References: <AANLkTinidWkKphNbYdtmhZc4G9WOJV-R6Mkyf_Vrpf4r@mail.gmail.com>
	 <1296139406.3050.29.camel@mulgrave.site>
	 <AANLkTi=LtzLkLz=NBB+7y+Fd8j0HxRSwb01evcLEU=k6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=LtzLkLz=NBB+7y+Fd8j0HxRSwb01evcLEU=k6@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: BingJiun Luo <luobingjiun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-01-28 at 10:42 +0800, BingJiun Luo wrote:
> On Thu, Jan 27, 2011 at 10:43 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > On Thu, 2011-01-27 at 22:04 +0800, BingJiun Luo wrote:
> >> I want to measure SATA AHCI Host controller read performance.  Open
> >> /dev/sda and using  read(int fildes, void *buf, size_t nbyte) user space
> >> function to read 2048 times, each time 64KByets, and total 128 Mbytes.
> >>
> >> I measured the time start from one step before write CI register inside
> >> ahci_qc_issue() function until ahci_port_intr () is called in the interrupt
> >> context. It takes about 1 milliseconds to complete one 256KBytes READ
> >> DMA EXT command, and spend about 15 microseconds call to scsi_done().
> >>
> >> However, why scsi_request_fn is called about after 4 milliseconds
> >> to pass next IO request for Hardware to issue? It take less if the READ
> >> DMA command with less number of sectors.
> >
> > I'm not sure I parse the question, but I think you're asking why we
> > chain the next issue from the softirq in SCSI?  That's because most SCSI
> > devices are tagged and the bus is the bottleneck, so after processing
> > the completion, we need to get the next command out ASAP to keep the bus
> > utilised to capacity.
> 
> I observed that each time scsi_request_fn is called, scsi_dispatch_cmd
> is called
> only once and then return.  It means that only one IO request available to be
> processed by Host Contoller.

Either you're untagged, or you don't have enough I/O then.

> After time passed about 4 milliseconds,  scsi_request_fn is called
> again. Why it
> takes so long time, because the previous command already completed in only about
> 1 millisecond, including call to scsi_done(). The host controller is
> idle about 3 milliseconds,
> has nothing to do.

No idea ... it's either something to do with the setup on the
architecture or it's simply that the I/O load isn't generating multiple
commands.  On an x86 it's microseconds to reissue from block softirq.

> >
> >> My questions are:
> >> 1. Is it the time to prepare one 256 KB READ DMA EXT command by upper
> >> layer (Block Layer or Virtual File system Layer)? Or, It is the time to copy
> >> data from kernel space memory to user space memory after data is read
> >> back from Hard Drive and delay the next command pass to SCSI?
> >
> > Everything in SCSI is done with zero copy (as in we DMA straight to the
> > pagecache page, which is then attached to userspace).
> >
> Yes, I know it is zero copy at SCSI, but I am not sure at upper layer(VFS or
> anything else).
> 
> It is unlikely to zero copy between kernel space and user space
> memory buffer, right? Because no matter the data read back from disk or already
> available inside the page cache, both of them are located at kernel
> space memory,

It depends.  Glibc can play clever tricks where it services read() via
mmapped buffers.  That's zero copy.

> and this data have to be copied into user space address. All of these works are
> not done in the SCSI layer, somewhere higher than SCSI, just I don't
> know where?.

No ... the page can simply be placed into an empty userspace mapping ...
that's what we mostly try to do.

> >> I know some architecture has not good enough performance to do memcpy
> >> or something like that.
> >>
> >> 2. If I do not mount /dev/sda to any file system, what is the first
> >> kernel function
> >> called after read() function from user space? Is it located at VFS or
> >> directly to
> >> Block layer?
> >
> > I think you need to trace this for yourself ... it's complex because
> > read doesn't go to the device, it goes via the page cache, which is also
> > how the VFS operates.  If the pages are all current in the cache, a
> > read() doesn't have to trouble the disk.
> >
> I am pretty sure almost all READ DMA commands go to the disk, because
> I captured them by Catalyst Analyzer. So, if all request must go to disk, does
> it means the data not available in the page cache.

Yes ... page cache is checked first before fetching from storage.

James


> >> Because I want to keep track the time spend at the layer higher than SCSI.
> >>
> >> 3. When scsi_done() is called, what is the function to process this completed
> >> command and pass the data to user space? I think there might be somewhere
> >> inside the code to copy this data from kernel space memory address to user
> >> space memory address.
> >
> > scsi_done doesn't do anything about completion, it triggers the block
> > softirq to schedule a completion for us when all interrupts are
> > processed.
> >
> > James
> >
> >
> >


