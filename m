From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [SCIS] mpt3sas: wait_for_completion_timeout timeout not reported
Date: Tue, 30 Dec 2014 16:14:21 -0500
Message-ID: <54A315AD.7000402@stratus.com>
References: <1419956387-28252-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1419956387-28252-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/30/2014 11:19 AM, Nicholas Mc Guire wrote:
> wait_for_completion_timeout reaching timeout was being ignored,
> this also should fail if timeout condition occurs. 
> 
> Thanks to Joe Lawrence <joe.lawrence@stratus.com> for confirmation.

How about this instead:

Acked-by: Joe Lawrence <joe.lawrence@stratus.com>

You still probably want a review from the Avago folks though.

BTW, don't worry about the "[SCSI]" subject prefix to the commit,
"[PATCH]" is fine.  I believe the former is a convention that the
maintainer applies to patches as he collects them to indicate that they
originated via the SCSI tree.

Thanks,

-- Joe

> this was only compile tested with
> x86_64_defconfig + CONFIG_SCSI_LOWLEVEL=y + CONFIG_SCSI_MPT3SAS=m
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_config.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
> index 4472c2a..04ff21b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -393,7 +393,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
>  	mpt3sas_base_put_smid_default(ioc, smid);
>  	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
>  	    timeout*HZ);
> -	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
> +	if (timeleft == 0 || !(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
>  		pr_err(MPT3SAS_FMT "%s: timeout\n",
>  		    ioc->name, __func__);
>  		_debug_dump_mf(mpi_request,
> 
