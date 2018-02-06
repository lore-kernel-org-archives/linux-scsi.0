From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Add two new parameters to scsi_debug driver
Date: Tue, 6 Feb 2018 09:11:52 -0500
Message-ID: <269997d0-d3ff-fb46-16df-194a5e5b7a0b@interlog.com>
References: <1517683115-4690-1-git-send-email-loberman@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55387 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbeBFOL6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Feb 2018 09:11:58 -0500
In-Reply-To: <1517683115-4690-1-git-send-email-loberman@redhat.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com

On 2018-02-03 01:38 PM, Laurence Oberman wrote:
> ---
> This patch adds two new parameters to the scsi_debug driver.
> During various fault injection scenarios it would be useful to be able
> to pick a specific starting sector and number of follow on sectors
> where a MEDIUM ERROR for reads would be returned against a scsi-debug
> device.
> 
> Right now this only works against sector 0x1234 and OPT_MEDIUM_ERR_NUM
> follow on sectors.
> However during testing of md-raid and other scenarios I wanted more
> flexibility.
> 
> The idea is add 2 new parameters:
> medium_error_start
> medium_error_count
> 
> If medium_error_start is set then we don't use the default of
> OPT_MEDIUM_ERR_ADDR, but use that set value.
> If medium_error_count is set we use that value otherwise default to
> OPT_MEDIUM_ERR_NUM.
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> Tested-by    : Laurence Oberman <loberman@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> 
>   drivers/scsi/scsi_debug.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a5986da..5a5aba0 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -616,6 +616,8 @@ enum sdeb_opcode_index {
>   static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
>   static int sdebug_max_luns = DEF_MAX_LUNS;
>   static int sdebug_max_queue = SDEBUG_CANQUEUE;	/* per submit queue */
> +static unsigned int sdebug_medium_error_start = OPT_MEDIUM_ERR_ADDR;
> +static int sdebug_medium_error_count = OPT_MEDIUM_ERR_NUM;
>   static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
>   static int sdebug_ndelay = DEF_NDELAY;	/* if > 0 then unit is nanoseconds */
>   static int sdebug_no_lun_0 = DEF_NO_LUN_0;
> @@ -2712,8 +2714,8 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	}
>   
>   	if (unlikely((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
> -		     (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
> -		     ((lba + num) > OPT_MEDIUM_ERR_ADDR))) {
> +		     (lba <= (sdebug_medium_error_start + sdebug_medium_error_count - 1)) &&
> +		     ((lba + num) > sdebug_medium_error_start))) {
>   		/* claim unrecoverable read error */
>   		mk_sense_buffer(scp, MEDIUM_ERROR, UNRECOVERED_READ_ERR, 0);
>   		/* set info field and valid bit for fixed descriptor */
> @@ -4440,6 +4442,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
>   module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
>   module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
> +module_param_named(medium_error_start, sdebug_medium_error_start, int, S_IRUGO | S_IWUSR);
> +module_param_named(medium_error_count, sdebug_medium_error_count, int, S_IRUGO | S_IWUSR);
>   module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
>   module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
>   module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
> @@ -4497,6 +4501,8 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
>   MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
>   MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
> +MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
> +MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
>   MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
>   MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
>   MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
> 
