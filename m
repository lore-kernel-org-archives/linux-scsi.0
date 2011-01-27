From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Why is scsi_request_fn called every 4 milliseconds?
Date: Thu, 27 Jan 2011 09:43:26 -0500
Message-ID: <1296139406.3050.29.camel@mulgrave.site>
References: <AANLkTinidWkKphNbYdtmhZc4G9WOJV-R6Mkyf_Vrpf4r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab1A0Ona (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2011 09:43:30 -0500
In-Reply-To: <AANLkTinidWkKphNbYdtmhZc4G9WOJV-R6Mkyf_Vrpf4r@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: BingJiun Luo <luobingjiun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2011-01-27 at 22:04 +0800, BingJiun Luo wrote:
> I want to measure SATA AHCI Host controller read performance.  Open
> /dev/sda and using  read(int fildes, void *buf, size_t nbyte) user space
> function to read 2048 times, each time 64KByets, and total 128 Mbytes.
> 
> I measured the time start from one step before write CI register inside
> ahci_qc_issue() function until ahci_port_intr () is called in the interrupt
> context. It takes about 1 milliseconds to complete one 256KBytes READ
> DMA EXT command, and spend about 15 microseconds call to scsi_done().
> 
> However, why scsi_request_fn is called about after 4 milliseconds
> to pass next IO request for Hardware to issue? It take less if the READ
> DMA command with less number of sectors.

I'm not sure I parse the question, but I think you're asking why we
chain the next issue from the softirq in SCSI?  That's because most SCSI
devices are tagged and the bus is the bottleneck, so after processing
the completion, we need to get the next command out ASAP to keep the bus
utilised to capacity.

> My questions are:
> 1. Is it the time to prepare one 256 KB READ DMA EXT command by upper
> layer (Block Layer or Virtual File system Layer)? Or, It is the time to copy
> data from kernel space memory to user space memory after data is read
> back from Hard Drive and delay the next command pass to SCSI?

Everything in SCSI is done with zero copy (as in we DMA straight to the
pagecache page, which is then attached to userspace).

> I know some architecture has not good enough performance to do memcpy
> or something like that.
> 
> 2. If I do not mount /dev/sda to any file system, what is the first
> kernel function
> called after read() function from user space? Is it located at VFS or
> directly to
> Block layer?

I think you need to trace this for yourself ... it's complex because
read doesn't go to the device, it goes via the page cache, which is also
how the VFS operates.  If the pages are all current in the cache, a
read() doesn't have to trouble the disk.

> Because I want to keep track the time spend at the layer higher than SCSI.
> 
> 3. When scsi_done() is called, what is the function to process this completed
> command and pass the data to user space? I think there might be somewhere
> inside the code to copy this data from kernel space memory address to user
> space memory address.

scsi_done doesn't do anything about completion, it triggers the block
softirq to schedule a completion for us when all interrupts are
processed.

James


