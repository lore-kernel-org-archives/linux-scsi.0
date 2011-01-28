From: BingJiun Luo <luobingjiun@gmail.com>
Subject: Re: Why is scsi_request_fn called every 4 milliseconds?
Date: Fri, 28 Jan 2011 10:22:07 +0800
Message-ID: <AANLkTimpC5r+1NwNb56XWiwHnfX4JhdiVgCwz0ypoXK4@mail.gmail.com>
References: <AANLkTinidWkKphNbYdtmhZc4G9WOJV-R6Mkyf_Vrpf4r@mail.gmail.com>
	<1296139406.3050.29.camel@mulgrave.site>
	<4D41AED7.3090806@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D41AED7.3090806@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@suse.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 28, 2011 at 1:43 AM, Douglas Gilbert <dgilbert@interlog.com=
> wrote:
> On 11-01-27 09:43 AM, James Bottomley wrote:
>>
>> On Thu, 2011-01-27 at 22:04 +0800, BingJiun Luo wrote:
>>>
>>> I want to measure SATA AHCI Host controller read performance. =A0Op=
en
>>> /dev/sda and using =A0read(int fildes, void *buf, size_t nbyte) use=
r space
>>> function to read 2048 times, each time 64KByets, and total 128 Mbyt=
es.
>>>
>>> I measured the time start from one step before write CI register in=
side
>>> ahci_qc_issue() function until ahci_port_intr () is called in the
>>> interrupt
>>> context. It takes about 1 milliseconds to complete one 256KBytes RE=
AD
>>> DMA EXT command, and spend about 15 microseconds call to scsi_done(=
).
>>>
>>> However, why scsi_request_fn is called about after 4 milliseconds
>>> to pass next IO request for Hardware to issue? It take less if the =
READ
>>> DMA command with less number of sectors.
>>
>> I'm not sure I parse the question, but I think you're asking why we
>> chain the next issue from the softirq in SCSI? =A0That's because mos=
t SCSI
>> devices are tagged and the bus is the bottleneck, so after processin=
g
>> the completion, we need to get the next command out ASAP to keep the=
 bus
>> utilised to capacity.
>>
>>> My questions are:
>>> 1. Is it the time to prepare one 256 KB READ DMA EXT command by upp=
er
>>> layer (Block Layer or Virtual File system Layer)? Or, It is the tim=
e to
>>> copy
>>> data from kernel space memory to user space memory after data is re=
ad
>>> back from Hard Drive and delay the next command pass to SCSI?
>>
>> Everything in SCSI is done with zero copy (as in we DMA straight to =
the
>> pagecache page, which is then attached to userspace).
>
> Just to add some numbers to that point, on this CPU:
> =A0 =A0Intel(R) Core(TM) i5 CPU M 540 =A0@ 2.53GHz
> [a Lenovo X201 laptop] with a dummy logical unit
> (pseudo disk) set up with this invocation:
> =A0$ modprobe scsi_debug delay=3D0 virtual_gb=3D2468
> with lk 2.6.37 I measure the following.
>
> =A0$ ddpt if=3D/dev/bsg/7:0:0:0 bs=3D512 count=3D1m bpt=3D1
> Output file not specified so no copy, just reading input
> 1048576+0 records in
> 0+0 records out
> time to read data: 4.815756 secs at 111.48 MB/sec
>
> That is issuing over 1 million SCSI READ commands from a
> user space program (and reading the data returned) in less
> that 5 seconds. So the SCSI READ command overhead is better
> (i.e. less) than 5 microseconds per command.
>
It depends one how many sectors to be read per command? If 512
sectors are read per time, it spends about 900 microseconds.


> Increase the "blocks per transfer" (bpt) to 512 to see
> the data throughput (plus fetch 10m blocks) and this
> is the result:
>
> =A0$ ddpt if=3D/dev/bsg/7:0:0:0 bs=3D512 count=3D10m bpt=3D512
> Output file not specified so no copy, just reading input
> 10485760+0 records in
> 0+0 records out
> time to read data: 1.896136 secs at 2831.39 MB/sec
>
> The latter figure is around 800 MB/sec using the Ubuntu
> 10.10 stock kernel (lk 2.6.35-24-generic) on the same
> machine. Something increased data throughput considerably
> between lk 2.6.35 and 2.6.37 . OTOH it may be a
> difference in my .config settings.
>
>
> So the latency per command added by the kernel and the
> SCSI subsystem (apart from the low level driver and the
> transport) is measured in microseconds rather than
> milliseconds.
>
I am not running on PC, but embedded system CPU=3D512MHz
and AHB bus 133 MHz. I think there is the different. I can only
read about 112 MBytes in 3 seconds. Using hdparm. Kernel
version 2.6.28.

> Doug Gilbert
>
>
> PS Another throughput datapoint, using the block
> subsystem (rather than a pass-through):
> =A0$ ddpt if=3D/dev/sdb bs=3D512 count=3D10m bpt=3D512
> Output file not specified so no copy, just reading input
> 10485760+0 records in
> 0+0 records out
> time to read data: 4.807517 secs at 1116.73 MB/sec
>
>
>>> I know some architecture has not good enough performance to do memc=
py
>>> or something like that.
>>>
>>> 2. If I do not mount /dev/sda to any file system, what is the first
>>> kernel function
>>> called after read() function from user space? Is it located at VFS =
or
>>> directly to
>>> Block layer?
>>
>> I think you need to trace this for yourself ... it's complex because
>> read doesn't go to the device, it goes via the page cache, which is =
also
>> how the VFS operates. =A0If the pages are all current in the cache, =
a
>> read() doesn't have to trouble the disk.
>>
>>> Because I want to keep track the time spend at the layer higher tha=
n
>>> SCSI.
>>>
>>> 3. When scsi_done() is called, what is the function to process this
>>> completed
>>> command and pass the data to user space? I think there might be som=
ewhere
>>> inside the code to copy this data from kernel space memory address =
to
>>> user
>>> space memory address.
>>
>> scsi_done doesn't do anything about completion, it triggers the bloc=
k
>> softirq to schedule a completion for us when all interrupts are
>> processed.
>>
>> James
>
>
>
