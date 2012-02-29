From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v8 09/13] libsas: enforce eh strategy handlers only in
 eh context
Date: Wed, 29 Feb 2012 16:05:51 -0600
Message-ID: <1330553151.8846.26.camel@dabdike>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	 <20120210084525.25701.51128.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47867 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964851Ab2B2WFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Feb 2012 17:05:53 -0500
In-Reply-To: <20120210084525.25701.51128.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
> The strategy handlers may be called in places that are problematic for
> libsas (i.e. sata resets outside of domain revalidation filtering /
> libata link recovery), or problematic for userspace (non-blocking ioctl
> to sleeping reset functions).  However, these routines are also called
> for eh escalations and recovery of scsi_eh_prep_cmnd(), so permit them
> as long as we are running in the host's error handler.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index f0b9b7b..1cabedc 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -463,11 +463,14 @@ EXPORT_SYMBOL_GPL(sas_get_local_phy);
>  /* Attempt to send a LUN reset message to a device */
>  int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  {
> -	struct domain_device *dev = cmd_to_domain_dev(cmd);
> -	struct sas_internal *i =
> -		to_sas_internal(dev->port->ha->core.shost->transportt);
> -	struct scsi_lun lun;
>  	int res;
> +	struct scsi_lun lun;
> +	struct Scsi_Host *host = cmd->device->host;
> +	struct domain_device *dev = cmd_to_domain_dev(cmd);
> +	struct sas_internal *i = to_sas_internal(host->transportt);
> +
> +	if (current != host->ehandler)
> +		return FAILED;

Doing this will ensure that SG_SCSI_RESET now fails.

I don't mind checking for O_NONBLOCK in the sg handler and failing if it
is, but disallowing everything looks a trifle drastic.

James


