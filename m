From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 00/12] Block support for zoned drives
Date: Mon, 4 Apr 2016 15:13:44 +0700
Message-ID: <CAJVOszBtQuZznc41rEv1x5fFf2fVJdpcd4DwxRsBzSXihhg+LA@mail.gmail.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com> <57021877.1070609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <57021877.1070609@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 4, 2016 at 2:32 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 04/04/2016 07:06 AM, Shaun Tancheff wrote:
>> As Host Aware drives are becoming available we would like to be able
>> to make use of such drives. This series is also intended to be suita=
ble
>> for use by Host Managed drives.
>>
>> The following series is hopefully a reasonable start at adding such
>> support.
>>
>> ZAC/ZBC drives add new commands. Some of this support is already in
>> progress by Hannes Reinecke <hare@suse.de>. This patch finishes up a
>> couple of scsi <-> ata translations. These patches will be re-worked
>> or dropped in favor of Hannes' next release.
>>
>> With the ZAC support in place adding some additional flags to struct=
 bio
>> to identify the new drive requests (Report zones, Open/Close/Reset z=
ones).
>>
>> With the bio support in place there are two new users added. The fir=
st
>> user is an ioctl the second user is a device mapper target.
>> The user space tools for the ioctl is intended to be acceptable for
>> inclusion by util-linux. Initial patches for 2.20.1 and 2.21.1
>> can be found here:
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_Se=
agate_ZDM-2DDevice-2DMapper_tree_master_patches_util-2Dlinux&d=3DCwID-g=
&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DWg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGO=
rWzA&m=3D4-JH1zADrs_TK5Uu77zQ1VSbAHgw5wTORr6yOSgYD5M&s=3DRDPFmAeTZPfhBJ=
m7NWJ98rZLNz6XK6fUaEfuddyReH8&e=3D
>>
>> Please consider the new device mapper target, as an RFC.
>>
>> Patch "Limit bio_endio recursion" is based on an older patch that wa=
s
>> not picked up. It is not strictly necessary but it does reduce stack
>> usage, especially for badly behaved DM targets that return
>> DM_MAPIO_REQUEUE too frequently.
>>
>> Patch "Use PID to seed Stream Id" depends on:
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lkml.kernel.o=
rg_r_1457107853-2D8689-2D1-2Dgit-2Dsend-2Demail-2Daxboe-40fb.com&d=3DCw=
ID-g&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DWg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3W=
VYGOrWzA&m=3D4-JH1zADrs_TK5Uu77zQ1VSbAHgw5wTORr6yOSgYD5M&s=3DIN4c2F-7PS=
BRdZ48Vd9a9ErYT6ZC8LU9Gz64JkCkR4o&e=3D
>>
>> Patch "Block Zoned Control for Userspace" is a hold over for user sp=
ace
>> tools that have not been updated to use the new block ioctl. The pat=
ch
>> will be dropped when zdm-tools is updated and sd-tools is replaced
>> with util-linux.
>>
>> This series is based on Linus v4.5 kernel.
>>
>> Code is also available on github here:
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_Se=
agate_ZDM-2DDevice-2DMapper&d=3DCwID-g&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DW=
g5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGOrWzA&m=3D4-JH1zADrs_TK5Uu77zQ1VSb=
AHgw5wTORr6yOSgYD5M&s=3DORjeO0XATR5F7vYAssdTzdmSeRV3svNBuoL63WOtcno&e=3D
>>
>> And a fork of Linus kernel with ZDM branches is available here:
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_st=
ancheff_linux&d=3DCwID-g&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DWg5NqlNlVTT7Ugl=
8V50qIHLe856QW0qfG3WVYGOrWzA&m=3D4-JH1zADrs_TK5Uu77zQ1VSbAHgw5wTORr6yOS=
gYD5M&s=3DHGzFkskoVEIBv0BMxTwLpzVxLZsAqiLNEUKWeqK_Xgk&e=3D
>>
>> Shaun Tancheff (12):
>>   Add ZBC <-> ZAC xlat support for report, open, close, reset, finis=
h
>>   ata-scsi: Translate ReportZones result to big endian
>>   BUG: Losing bits on request.cmd_flags
>>   Add bio/request flags for using ZBC/ZAC commands
>>   Add ioctl to issue ZBC/ZAC commands via block layer
>>   Add ata pass-through path for ZAC commands.
>>   ZDM: New DM target 'zoned'
>>   RAID 4/5/6: Indicate parity blocks as 'META'
>>   RAID 4/5/6: Fine-grained TRIM enable for ZDM
>>   Limit bio_endio recursion
>>   Stream Id: Use PID to seed Stream Id construction.
>>   Block Zoned Control for Userspace
>>
> Please hold off with this series for the moment.

Sure no problem, I was planning to re-base on top of your patchset.

Just hopping to get some early feedback on the struct bio changes...

> I've just finished up porting my ZAC/ZBC patchset and will be posting=
 an
> update shortly.
> I'm happy to integrate any of your fixes.

Thanks!

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnbe=
rg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=3D=
http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=3DCwID-g&c=3DIGDlg0lD0=
b-nebmJJ0Kp8A&r=3DWg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGOrWzA&m=3D4-JH1=
zADrs_TK5Uu77zQ1VSbAHgw5wTORr6yOSgYD5M&s=3DNjPE1IDNgJ6Y4TNHshx_mgv4CeKI=
vcYlEW0FVxUFnNc&e=3D

--=20
Shaun Tancheff
