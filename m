From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Why is scsi_request_fn called every 4 milliseconds?
Date: Thu, 27 Jan 2011 12:43:51 -0500
Message-ID: <4D41AED7.3090806@interlog.com>
References: <AANLkTinidWkKphNbYdtmhZc4G9WOJV-R6Mkyf_Vrpf4r@mail.gmail.com> <1296139406.3050.29.camel@mulgrave.site>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57403 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab1A0RoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2011 12:44:01 -0500
In-Reply-To: <1296139406.3050.29.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: BingJiun Luo <luobingjiun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 11-01-27 09:43 AM, James Bottomley wrote:
> On Thu, 2011-01-27 at 22:04 +0800, BingJiun Luo wrote:
>> I want to measure SATA AHCI Host controller read performance.  Open
>> /dev/sda and using  read(int fildes, void *buf, size_t nbyte) user space
>> function to read 2048 times, each time 64KByets, and total 128 Mbytes.
>>
>> I measured the time start from one step before write CI register inside
>> ahci_qc_issue() function until ahci_port_intr () is called in the interrupt
>> context. It takes about 1 milliseconds to complete one 256KBytes READ
>> DMA EXT command, and spend about 15 microseconds call to scsi_done().
>>
>> However, why scsi_request_fn is called about after 4 milliseconds
>> to pass next IO request for Hardware to issue? It take less if the READ
>> DMA command with less number of sectors.
>
> I'm not sure I parse the question, but I think you're asking why we
> chain the next issue from the softirq in SCSI?  That's because most SCSI
> devices are tagged and the bus is the bottleneck, so after processing
> the completion, we need to get the next command out ASAP to keep the bus
> utilised to capacity.
>
>> My questions are:
>> 1. Is it the time to prepare one 256 KB READ DMA EXT command by upper
>> layer (Block Layer or Virtual File system Layer)? Or, It is the time to copy
>> data from kernel space memory to user space memory after data is read
>> back from Hard Drive and delay the next command pass to SCSI?
>
> Everything in SCSI is done with zero copy (as in we DMA straight to the
> pagecache page, which is then attached to userspace).

Just to add some numbers to that point, on this CPU:
     Intel(R) Core(TM) i5 CPU M 540  @ 2.53GHz
[a Lenovo X201 laptop] with a dummy logical unit
(pseudo disk) set up with this invocation:
   $ modprobe scsi_debug delay=0 virtual_gb=2468
with lk 2.6.37 I measure the following.

   $ ddpt if=/dev/bsg/7:0:0:0 bs=512 count=1m bpt=1
Output file not specified so no copy, just reading input
1048576+0 records in
0+0 records out
time to read data: 4.815756 secs at 111.48 MB/sec

That is issuing over 1 million SCSI READ commands from a
user space program (and reading the data returned) in less
that 5 seconds. So the SCSI READ command overhead is better
(i.e. less) than 5 microseconds per command.

Increase the "blocks per transfer" (bpt) to 512 to see
the data throughput (plus fetch 10m blocks) and this
is the result:

   $ ddpt if=/dev/bsg/7:0:0:0 bs=512 count=10m bpt=512
Output file not specified so no copy, just reading input
10485760+0 records in
0+0 records out
time to read data: 1.896136 secs at 2831.39 MB/sec

The latter figure is around 800 MB/sec using the Ubuntu
10.10 stock kernel (lk 2.6.35-24-generic) on the same
machine. Something increased data throughput considerably
between lk 2.6.35 and 2.6.37 . OTOH it may be a
difference in my .config settings.


So the latency per command added by the kernel and the
SCSI subsystem (apart from the low level driver and the
transport) is measured in microseconds rather than
milliseconds.

Doug Gilbert


PS Another throughput datapoint, using the block
subsystem (rather than a pass-through):
   $ ddpt if=/dev/sdb bs=512 count=10m bpt=512
Output file not specified so no copy, just reading input
10485760+0 records in
0+0 records out
time to read data: 4.807517 secs at 1116.73 MB/sec


>> I know some architecture has not good enough performance to do memcpy
>> or something like that.
>>
>> 2. If I do not mount /dev/sda to any file system, what is the first
>> kernel function
>> called after read() function from user space? Is it located at VFS or
>> directly to
>> Block layer?
>
> I think you need to trace this for yourself ... it's complex because
> read doesn't go to the device, it goes via the page cache, which is also
> how the VFS operates.  If the pages are all current in the cache, a
> read() doesn't have to trouble the disk.
>
>> Because I want to keep track the time spend at the layer higher than SCSI.
>>
>> 3. When scsi_done() is called, what is the function to process this completed
>> command and pass the data to user space? I think there might be somewhere
>> inside the code to copy this data from kernel space memory address to user
>> space memory address.
>
> scsi_done doesn't do anything about completion, it triggers the block
> softirq to schedule a completion for us when all interrupts are
> processed.
>
> James


