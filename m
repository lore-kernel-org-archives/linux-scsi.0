From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Wed, 05 Mar 2008 02:59:30 +0900
Message-ID: <47CD8E02.1020207@gmail.com>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk> <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net> <20080304123939.GM6704@kernel.dk> <fqk15l$lgq$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <fqk15l$lgq$1@ger.gmane.org>
Sender: linux-ide-owner@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

walt wrote:
> Jens Axboe wrote:
>> On Tue, Mar 04 2008, Mike Galbraith wrote:
>>> On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
>>>
>>>> Looks excellent to me, has a variant of this been tested as OK by the
>>>> users reporting the regression?
>>> K3b burning seems to be a nogo here.  This is git pulled this morning
>>> though, so it's a somewhat different tree than previously tested fwtw.
>>
>> can you please try git as of this morning without any patches applied,
>> and then pull
>>
>> git://git.kernel.dk/linux-2.6-block.git for-linus
>>
>> into that and see if that works?
> 
> Unfortunately this doesn't fix a problem I've discussed off-list with
> Kiyoshi Ueda, who suggested that I should follow this thread and try
> any patches posted here.
> 
> Here is what happens when I try to mount a CD (before and after I
> pull 'for-linus'):
> 
> hdc: ide_cd_check_ireason: wrong transfer direction!
> cdrom: failed setting lba address space
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> hdc: status timeout: status=0xd0 { Busy }
> ide: failed opcode was: unknown
> hdc: DMA disabled
> hdc: drive not ready for command
> hdc: ATAPI reset complete
> ISO 9660 Extensions: Microsoft Joliet Level 3
> ISOFS: changing to secondary root
> VFS: busy inodes on changed media.
> 
> The mount can take from 5 seconds on up to a minute or so before the
> CD can be accessed.

Which version did you try?  There was a recent IDE bug fix which
affected CD recording.  Commit bcd88ac3b2ff2eae3d0fa57a6b02d4fce5392f32
which is included in 2.6.25-rc3.  Also, did 2.6.24 work?

-- 
tejun
