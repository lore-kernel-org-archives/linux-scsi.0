From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [SCSI RFC] mpt2sas: wait_for_completion_timeout timeout not reported
Date: Sat, 27 Dec 2014 11:49:29 -0500
Message-ID: <549EE319.9030702@stratus.com>
References: <1419873954-22573-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1419873954-22573-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/29/2014 12:25 PM, Nicholas Mc Guire wrote:
> wait_for_completion_timeout reaching timeout was being ignored,
> this probably also should fail if timeout condition occurs ?
> 
> this was only compile tested with
> x86_64_defconfig + CONFIG_SCSI_LOWLEVEL=y + CONFIG_SCSI_MPT2SAS=m
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_config.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
> index c72a2ff..02dc2d8 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_config.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
> @@ -391,7 +391,7 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
>  	mpt2sas_base_put_smid_default(ioc, smid);
>  	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
>  	    timeout*HZ);
> -	if (!(ioc->config_cmds.status & MPT2_CMD_COMPLETE)) {
> +	if (timeleft == 0 || !(ioc->config_cmds.status & MPT2_CMD_COMPLETE)) {
>  		printk(MPT2SAS_ERR_FMT "%s: timeout\n",
>  		    ioc->name, __func__);
>  		_debug_dump_mf(mpi_request,
> 

Hi Nicholas,

This would look like the correct thing to do here, for it eliminates a
small window where we timeout when mpt2sas_config_done had set
MPT2_CMD_COMPLETE and MPT3_CMD_REPLY_VALID, but has not finished copying
the reply data into config_cmds.reply.

It looks like the same patch should be applied to the mpt3sas driver as
well.

-- Joe
