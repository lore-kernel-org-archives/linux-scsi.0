From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/2] sd: add missing scenario for sd_config_write_same
Date: Sat, 27 Feb 2016 04:26:32 +0800
Message-ID: <CAGnHSEm6+zpYzfhFNZrgJK9=zkYxTaLQmYqbPvM-8KJCMteiNw@mail.gmail.com>
References: <56d0b088.e99c420a.dbca1.0411@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f193.google.com ([209.85.160.193]:35089 "EHLO
	mail-yk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbcBZU0d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 15:26:33 -0500
Received: by mail-yk0-f193.google.com with SMTP id u9so2479410ykd.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 12:26:32 -0800 (PST)
In-Reply-To: <56d0b088.e99c420a.dbca1.0411@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I wonder if we want to disable write same too, instead of falling back
to SD_MAX_WS10_BLOCKS for either of the WRITE SAME (10) and (16)
opcodes, when they are reported to be supported. If not, should we go
for SD_MAX_WS16_BLOCKS instead when WRITE SAME (16) is supported?

P.S. Please be noted I have been talking about cases when the Maximum
Write Same Length reported in the Block Limit VPD is 0.

On 27 February 2016 at 04:07,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> Example:
>
> [root@localhost ~]# sg_opcodes /dev/sdb > /dev/null
> Report supported operation codes: Illegal request, invalid opcode
>
> [root@localhost ~]# sg_vpd -p bl /dev/sdb | grep 'write same'
>   Maximum write same length: 0x0 blocks
>
> [root@localhost ~]# cat /sys/block/sdb/queue/write_same_max_bytes
> 33553920
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d749da7..1179ec1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -807,6 +807,8 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
>         if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
>                 sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
>                                                    (u32)SD_MAX_WS16_BLOCKS);
> +       else if (sdkp->max_ws_blocks == 0 && sdkp->device->no_report_opcodes)
> +               sdkp->device->no_write_same = 1;
>         else if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
>                 sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
>                                                    (u32)SD_MAX_WS10_BLOCKS);
> --
> 2.7.1
>
