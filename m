From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/12] Block support for zoned drives
Date: Mon, 4 Apr 2016 09:32:07 +0200
Message-ID: <57021877.1070609@suse.de>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
Sender: linux-ide-owner@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On 04/04/2016 07:06 AM, Shaun Tancheff wrote:
> As Host Aware drives are becoming available we would like to be able=20
> to make use of such drives. This series is also intended to be suitab=
le
> for use by Host Managed drives.
>=20
> The following series is hopefully a reasonable start at adding such=20
> support.
>=20
> ZAC/ZBC drives add new commands. Some of this support is already in
> progress by Hannes Reinecke <hare@suse.de>. This patch finishes up a
> couple of scsi <-> ata translations. These patches will be re-worked=20
> or dropped in favor of Hannes' next release.
>=20
> With the ZAC support in place adding some additional flags to struct =
bio=20
> to identify the new drive requests (Report zones, Open/Close/Reset zo=
nes).
>=20
> With the bio support in place there are two new users added. The firs=
t=20
> user is an ioctl the second user is a device mapper target.
> The user space tools for the ioctl is intended to be acceptable for
> inclusion by util-linux. Initial patches for 2.20.1 and 2.21.1
> can be found here:
> https://github.com/Seagate/ZDM-Device-Mapper/tree/master/patches/util=
-linux
>=20
> Please consider the new device mapper target, as an RFC.
>=20
> Patch "Limit bio_endio recursion" is based on an older patch that was=
=20
> not picked up. It is not strictly necessary but it does reduce stack=20
> usage, especially for badly behaved DM targets that return
> DM_MAPIO_REQUEUE too frequently.
>=20
> Patch "Use PID to seed Stream Id" depends on:
> https://lkml.kernel.org/r/1457107853-8689-1-git-send-email-axboe@fb.c=
om
>=20
> Patch "Block Zoned Control for Userspace" is a hold over for user spa=
ce
> tools that have not been updated to use the new block ioctl. The patc=
h
> will be dropped when zdm-tools is updated and sd-tools is replaced
> with util-linux.
>=20
> This series is based on Linus v4.5 kernel.
>=20
> Code is also available on github here:
> https://github.com/Seagate/ZDM-Device-Mapper
>=20
> And a fork of Linus kernel with ZDM branches is available here:
> https://github.com/stancheff/linux
>=20
> Shaun Tancheff (12):
>   Add ZBC <-> ZAC xlat support for report, open, close, reset, finish
>   ata-scsi: Translate ReportZones result to big endian
>   BUG: Losing bits on request.cmd_flags
>   Add bio/request flags for using ZBC/ZAC commands
>   Add ioctl to issue ZBC/ZAC commands via block layer
>   Add ata pass-through path for ZAC commands.
>   ZDM: New DM target 'zoned'
>   RAID 4/5/6: Indicate parity blocks as 'META'
>   RAID 4/5/6: Fine-grained TRIM enable for ZDM
>   Limit bio_endio recursion
>   Stream Id: Use PID to seed Stream Id construction.
>   Block Zoned Control for Userspace
>=20
Please hold off with this series for the moment.
I've just finished up porting my ZAC/ZBC patchset and will be posting a=
n
update shortly.
I'm happy to integrate any of your fixes.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
