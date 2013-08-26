From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
Date: Mon, 26 Aug 2013 22:15:52 +0200
Message-ID: <521BB778.5050701@fastmail.fm>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net> <51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net> <51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm> <51FA71E2.6010501@fastmail.fm> <yq1li4ker0k.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1li4ker0k.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nix <nix@esperi.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Martin,

sorry for my late reply, I entirely lost track of this (customer issues,
vacation, lots of main work, ...).

On 08/02/2013 05:00 AM, Martin K. Petersen wrote:
>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:
> 
> Bernd,
> 
> Bernd> Once I noticed that scsi_get_vpd_page() works fine from other
> Bernd> function calls and that it is not 0x89, but already 0x0 that
> Bernd> fails fixing it became easy.
> 
> Bernd> Nix, any chance you could verify it also works for you?
> 
> Do we get an appropriate error back when we try to issue WRITE SAME
> 10/16? If so, I'm OK with this fix.
> 
> And thanks for looking into this!
> 


Is testing with sg_write_same sufficient?

With F/W V1.49:

> (squeeze)fslab2:~# lsscsi | grep sda
> [2:0:0:0]    disk    ATA      HDS724040KLSA80  KFAO  /dev/sda

> (squeeze)fslab2:~# strace -f sg_write_same  --10 -v --num=0 --lba=0 /dev/sda

> ioctl(3, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[10]=[41, 00, 00, 00, 00, 00, 00, 00, 00, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=60000, flags=0, data[512]=["\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...], status=02, masked_status=01, sb[18]=[70, 00, 05, 00, 00, 00, 00, 0a, 00, 00, 00, 00, 20, 00, 00, 00, 00, 00], host_status=0, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> write(2, "Write same:  Fixed format, curre"..., 114Write same:  Fixed format, current;  Sense key: Illegal Request
>  Additional sense: Invalid command operation code
> ) = 114
> write(2, "Write same(10) command not suppo"..., 37Write same(10) command not supported
> ) = 37


> (squeeze)fslab2:~# strace -f  sg_write_same  --16 -v --num=0 --lba=0 /dev/sda

> ioctl(3, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[16]=[93, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=60000, flags=0, data[512]=["\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...], status=02, masked_status=01, sb[18]=[70, 00, 05, 00, 00, 00, 00, 0a, 00, 00, 00, 00, 24, 00, 00, 00, 00, 00], host_status=0, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> write(2, "Write same:  Fixed format, curre"..., 104Write same:  Fixed format, current;  Sense key: Illegal Request
>  Additional sense: Invalid field in cdb
> ) = 104
> write(2, "bad field in Write same(16) cdb,"..., 63bad field in Write same(16) cdb, option probably not supported
> ) = 63



Now with F/W V1.46

> (squeeze)fslab2:~# lsscsi | grep sdk
> [10:0:1:2]   disk    Hitachi  HDS724040KLSA80  R001  /dev/sdk

> (squeeze)fslab2:~# cat /sys/class/scsi_host/host10/host_fw_model 
> ARC-1260


> (squeeze)fslab2:~# strace -f sg_write_same  --10 -v --num=0 --lba=0 /dev/sdk
> execve("/usr/bin/sg_write_same", ["sg_write_same", "--10", "-v", "--num=0", "--lba=0", "/dev/sdk"], [/* 26 vars */]) = 0

> ioctl(3, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[10]=[41, 00, 00, 00, 00, 00, 00, 00, 00, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=60000, flags=0, data[512]=["\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...], status=00, masked_status=00, sb[19]=[f0, 00, 05, 00, 00, 00, 00, 0b, 00, 00, 00, 00, 20, 00, 00, 00, 02, 00, 00], host_status=0, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> write(2, "Write same:  Fixed format, curre"..., 134Write same:  Fixed format, current;  Sense key: Illegal Request
>  Additional sense: Invalid command operation code
>   Info fld=0x0 [0] 
> ) = 134
> write(2, "Write same(10) command not suppo"..., 37Write same(10) command not supported
> ) = 37

> (squeeze)fslab2:~# strace -f  sg_write_same  --16 -v --num=0 --lba=0 /dev/sdk
> execve("/usr/bin/sg_write_same", ["sg_write_same", "--16", "-v", "--num=0", "--lba=0", "/dev/sdk"], [/* 26 vars */]) = 0

> ioctl(3, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[16]=[93, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00], mx_sb_len=32, iovec_count=0, dxfer_len=512, timeout=60000, flags=0, data[512]=["\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...], status=00, masked_status=00, sb[19]=[f0, 00, 05, 00, 00, 00, 00, 0b, 00, 00, 00, 00, 20, 00, 00, 00, 02, 00, 00], host_status=0, driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> write(2, "Write same:  Fixed format, curre"..., 134Write same:  Fixed format, current;  Sense key: Illegal Request
>  Additional sense: Invalid command operation code
>   Info fld=0x0 [0] 
> ) = 134
> write(2, "Write same(16) command not suppo"..., 37Write same(16) command not supported
> ) = 37


Is this sufficient, or do you need something else?


Thanks,
Bernd
