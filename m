From: Mark Lord <lkml@rtr.ca>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 09:37:29 -0400
Message-ID: <47E90019.3050006@rtr.ca>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47E88A13.70808@zytor.com>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

H. Peter Anvin wrote:
> Mark Lord wrote:
>>
>> One candidate might seem to be the existing 
>> /sys/block/dev/partition/start
>> which I expect is already 64-bit friendly.
>>
>> But this requires about 150 lines of somewhat complex C code to access,
>> using only the dev_t (from stat(2) on a file) as a starting point,
>> or less if one relies upon the udev device name matching the sysfs 
>> device name.
>>
>> Is it time now for HDIO_GETGEO64 to make an appearance?
>> Similar to how the existing BLKGETSIZE64 is supplanting BLKGETSIZE ?
>>
> 
> Probably a better thing to have would be a way to look up block devices 
> in sysfs by device number.
..

Yeah, that would be just as good, really.  Maybe even better.

Mark Lord wrote (later on):
> Instead, software has to search everything inside /sys/block/
> looking for a "dev" file whose contents match,
> rather than just trying to access something like this:
> 
>   /sys/block/8:1/start
> or
>   /sys/block/majors/8/minors/1/start
> 
> Or any one of a number of similar ways to arrange it. 
..

Greg ?
