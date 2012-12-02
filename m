From: Hiroyuki Yamada <mogwaing@gmail.com>
Subject: Re: one 16K random read I/O issues 2 scsi I/O (16K and 4K) requests
Date: Sun, 2 Dec 2012 18:23:15 +0900
Message-ID: <CAPDOW75pHJ7mN1+EywLtkhOSdGX9Hvt9_T9LH5JzY3V2_LA_XA@mail.gmail.com>
References: <CAPDOW76Mp8FKDv3oEo=rKZpXf2+uwG0kB5ejCusnrkY4Euq_NQ@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40294CD01BD9@G9W0745.americas.hpqcorp.net>
	<CAPDOW76rRJML+0NsSjFyTjBnN9Un1f7e=6sAtrF71zR3eDXO6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61598 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2LBJXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 04:23:16 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so747477vby.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 01:23:15 -0800 (PST)
In-Reply-To: <CAPDOW76rRJML+0NsSjFyTjBnN9Un1f7e=6sAtrF71zR3eDXO6Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I figured out what is going on, but I don't know what it is for.

Ext3 filesystem has some 4KB data in each 4096KB(8192 sectors) data.
Visually, data is aligned like the following.

|4KB|4096KB|4KB|4096KB|4KB|4096KB| ...

And 4096KB area in only accessible by application programs.
When accessing the first 4096KB area for the first time,
then OS reads the 4KB just before the 4096KB area first
and then read the requested data in the 4096KB area.

When accessing a large file (compared to the DRAM size) randomly,
every I/O has rare chance of hitting page cahce,
so every I/O request comes together with 4KB I/O.

The thing is what the 4KB data is for ?
Is this location metadata for filesystem ?
Is there any way I can remove this ?
Or Is there any way I can clear the 4096KB area only ?

Any comments and advices are appreciated.

(I tested in many machines with many kernel versions. this happens in
all machines.)

Thanks.

On Sun, Dec 2, 2012 at 10:27 AM, Hiroyuki Yamada <mogwaing@gmail.com> wrote:
> Hi Elliott,
>
> Thank you for the comments.
>
>> 1. All the starting-sector values are unaligned.   Are the files on an unaligned partition (e.g. on an MBR disk starting at LBA 63)?  That would cause extra accesses.
>
> I think the partition is fine.
> I access the partition itself with DIRECT_IO and the issue never happens.
> (Requested bytes and scsi drivers dispatching bytes match.)
>
>> 2. Files might be fragmented.
>
> I re-created filesystem several times and I still get the same issue.
> (I re-created filesystem and create a dummy file with dd and I access
> the file as I said.)
> so, files are not fragmented in that case.
>
>
> I noticed that when I keep reading files randomly,
> unknown 4KB I/O gradually disappears. (only 16KB I/O is issued.)
> After I flushed the page cache, I again get 4KB I/O and requested 16KB I/O.
>
> (the file is big enough for the DRAM size, so basically most of the
> I/O does not hit the
> page cache and goes to scsi driver level.)
>
>
>
> On Sun, Dec 2, 2012 at 5:18 AM, Elliott, Robert (Server Storage)
> <Elliott@hp.com> wrote:
>> Two things to consider:
>> 1. All the starting-sector values are unaligned.   Are the files on an unaligned partition (e.g. on an MBR disk starting at LBA 63)?  That would cause extra accesses.
>>
>> It is important that all I/Os be aligned nowadays, due to:
>> - SSDs (with 4 KiB or larger page sizes)
>> - 512e Advanced Format HDDs (with 4 KiB or larger physical sector sizes);
>> - RAID logical drives (with 16 KiB or larger strip sizes)
>>
>> 2. Files might be fragmented.
>>
>>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Hiroyuki Yamada
>> Sent: Saturday, December 01, 2012 3:45 AM
>> To: linux-scsi@vger.kernel.org
>> Subject: one 16K random read I/O issues 2 scsi I/O (16K and 4K) requests
>>
>> I noticed weird issue when benchmarking random read I/O for files in
>> linux (2.6.18-274).
>> The Benchmarking program is my own program and it simply keeps reading
>> 16KB of a file from a random offset.
>>
>> I traced I/O behavior at system call level and scsi level with systemtap and
>> I noticed that one 16KB pread issues 2 scsi I/Os as following.
>>
>> =============================================
>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 128137183232
>> SCSI random(8472) 0 1 0 0 start-sector: 226321183 size: 4096 bufflen
>> 4096 FROM_DEVICE 1354354008068009
>> SCSI random(8472) 0 1 0 0 start-sector: 226323431 size: 16384 bufflen
>> 16384 FROM_DEVICE 1354354008075927
>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 21807710208
>> SCSI random(8472) 0 1 0 0 start-sector: 1889888935 size: 4096 bufflen
>> 4096 FROM_DEVICE 1354354008085128
>> SCSI random(8472) 0 1 0 0 start-sector: 1889891823 size: 16384 bufflen
>> 16384 FROM_DEVICE 1354354008097161
>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 139365318656
>> SCSI random(8472) 0 1 0 0 start-sector: 254092663 size: 4096 bufflen
>> 4096 FROM_DEVICE 1354354008100633
>> SCSI random(8472) 0 1 0 0 start-sector: 254094879 size: 16384 bufflen
>> 16384 FROM_DEVICE 1354354008111723
>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 60304424960
>> SCSI random(8472) 0 1 0 0 start-sector: 58119807 size: 4096 bufflen
>> 4096 FROM_DEVICE 1354354008120469
>> SCSI random(8472) 0 1 0 0 start-sector: 58125415 size: 16384 bufflen
>> 16384 FROM_DEVICE 1354354008126343
>> =============================================
>>
>>
>> As shown above, one 16KB pread issues 2 scsi I/Os. (I traced scsi io
>> dispatching with probe scsi.iodispatching)
>>
>> One scsi I/O is 16KB I/O as requested from the application and it's OK.
>> The thing is the other 4KB I/O which I don't know why linux issues that I/O.
>>
>> Of course, I/O performance is degraded by the weired 4KB I/O and I am
>> having trouble.
>> I also use fio (famous I/O benchmark tool) and noticed the same issue,
>> so it's not from the application.
>> Does anybody know what is going on ?
>> Any comments or advices are appreciated.
>>
>> Thanks
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
