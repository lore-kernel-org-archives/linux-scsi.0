From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: unify scsi_level in proc and sysfs
Date: Tue, 21 Jan 2014 10:07:55 -0500
Message-ID: <52DE8D4B.3090008@interlog.com>
References: <1390297947-6772-1-git-send-email-handai.szj@taobao.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58543 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbaAUPIK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jan 2014 10:08:10 -0500
In-Reply-To: <1390297947-6772-1-git-send-email-handai.szj@taobao.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sha Zhengju <handai.szj@gmail.com>, linux-scsi@vger.kernel.org
Cc: Sha Zhengju <handai.szj@taobao.com>

On 14-01-21 04:52 AM, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
>
> There're severel interfaces to show scsi_level value of scsi_debug,
> but they're not in consistent. E.g:
>
> 1)
> #cat /sys/bus/pseudo/drivers/scsi_debug/scsi_level
> 5
>
> 2)
> #cat /proc/scsi/scsi_debug/7
> scsi_debug adapter driver, version 1.82 [20100324]
> num_tgts=1, shared (ram) size=1024 MB, opts=0x0, every_nth=0(curr:0)
> delay=1, max_luns=1, scsi_level=5
> sector_size=512 bytes, cylinders=130, heads=255, sectors=63
> number of aborts=0, device_reset=0, bus_resets=0, host_resets=0
> dix_reads=0 dix_writes=0 dif_errors=0
>
> 3)
> #cat /sys/bus/scsi/devices/7\:0\:0\:0/scsi_level (or lsscsi -l)
> 6
>
> According to the description in scsi.h, "struct scsi_device::scsi_level
> values. For SCSI devices other than those prior to SCSI-2 (i.e. over
> 12 years old) this value is (resp[2] + 1) where 'resp' is a byte array
> of the response to an INQUIRY". For scsi_debug, the resp[2] of INQUIRY
> is 5 which indicates using SPC-3, but the sysfs's scsi_level will show 6.
>
> The aboving 1) and 2) entry export resp[2] of INQUIRY directly, unify
> them with 3) which is resp[2] + 1.

Hmmm. scsi_level is a Linux hack that should be, but cannot
easily be, replaced. I agree all scsi_level outputs should
be consistent (and thus equally confusing). Perhaps scsi_debug
(and the mid-level) should introduce a new variable, something
like 't10_inq_version' that is rsp[2] from a standard INQUIRY
response. Since SPC-2, that byte has had the field name VERSION
and that name seems unlikely to change.

Doug Gilbert

> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> ---
>   drivers/scsi/scsi_debug.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 80b8b10..a52d0687 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2866,7 +2866,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
>   	    SCSI_DEBUG_VERSION, scsi_debug_version_date, scsi_debug_num_tgts,
>   	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
>   	    scsi_debug_cmnd_count, scsi_debug_delay,
> -	    scsi_debug_max_luns, scsi_debug_scsi_level,
> +	    scsi_debug_max_luns, scsi_debug_scsi_level + 1,
>   	    scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
>   	    sdebug_sectors_per, num_aborts, num_dev_resets, num_bus_resets,
>   	    num_host_resets, dix_reads, dix_writes, dif_errors);
> @@ -3091,7 +3091,7 @@ DRIVER_ATTR(no_uld, S_IRUGO, sdebug_no_uld_show, NULL);
>
>   static ssize_t sdebug_scsi_level_show(struct device_driver * ddp, char * buf)
>   {
> -        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_scsi_level);
> +        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_scsi_level + 1);
>   }
>   DRIVER_ATTR(scsi_level, S_IRUGO, sdebug_scsi_level_show, NULL);
>
>

