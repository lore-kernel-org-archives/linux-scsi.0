From: Hiroyuki Yamada <mogwaing@gmail.com>
Subject: Re: one 16K random read I/O issues 2 scsi I/O (16K and 4K) requests
Date: Sun, 2 Dec 2012 19:56:59 +0900
Message-ID: <CAPDOW76F_78CWNwgV4zOM=-Kq9Bdo-UwQgBxjZnsapvRf+kM-Q@mail.gmail.com>
References: <CAPDOW76Mp8FKDv3oEo=rKZpXf2+uwG0kB5ejCusnrkY4Euq_NQ@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40294CD01BD9@G9W0745.americas.hpqcorp.net>
	<CAPDOW76rRJML+0NsSjFyTjBnN9Un1f7e=6sAtrF71zR3eDXO6Q@mail.gmail.com>
	<CAPDOW75pHJ7mN1+EywLtkhOSdGX9Hvt9_T9LH5JzY3V2_LA_XA@mail.gmail.com>
	<50BB2CCD.6070501@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61175 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LBK5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 05:57:00 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so967835vcd.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 02:57:00 -0800 (PST)
In-Reply-To: <50BB2CCD.6070501@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org

Thank you for the comment.
I just figured it out and was checking ext4.

This problem never happens with ext4 !!!
It's from ext3 indirect block addressing.

Thank you Bart.


On Sun, Dec 2, 2012 at 7:26 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> On 12/02/12 10:23, Hiroyuki Yamada wrote:
>>
>> I figured out what is going on, but I don't know what it is for.
>>
>> Ext3 filesystem has some 4KB data in each 4096KB(8192 sectors) data.
>> Visually, data is aligned like the following.
>>
>> |4KB|4096KB|4KB|4096KB|4KB|4096KB| ...
>>
>> And 4096KB area in only accessible by application programs.
>> When accessing the first 4096KB area for the first time,
>> then OS reads the 4KB just before the 4096KB area first
>> and then read the requested data in the 4096KB area.
>>
>> When accessing a large file (compared to the DRAM size) randomly,
>> every I/O has rare chance of hitting page cahce,
>> so every I/O request comes together with 4KB I/O.
>>
>> The thing is what the 4KB data is for ?
>> Is this location metadata for filesystem ?
>> Is there any way I can remove this ?
>> Or Is there any way I can clear the 4096KB area only ?
>
>
> Does this behavior also occur with ext4 ? From the ext4 wiki
> (http://ext4.wiki.kernel.org/index.php/Ext4_Howto#Extents):
>
>  Extents
>
> Traditional, Unix-derived, file systems, like Ext3, use a indirect block
> mapping scheme to keep track of each block used for the blocks corresponding
> to the data of a file. This is inefficient for large files, especially
> during large file delete and truncate operations, because the mapping keeps
> an entry for every single block, and big files have many blocks -> huge
> mappings, slow to handle. Modern file systems use a different approach
> called "extents". An extent is basically a bunch of contiguous physical
> blocks. It basically says "The data is in the next n blocks". For example, a
> 100 MiB file can be allocated into a single extent of that size, instead of
> needing to create the indirect mapping for 25600 blocks (4 KiB per block).
> Huge files are split in several extents. Extents improve the performance and
> also help to reduce the fragmentation, since an extent encourages continuous
> layouts on the disk.
>
> Bart.
