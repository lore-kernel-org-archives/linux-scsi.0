From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH 4/5] fnic: do not reset dev_loss_tmo in slave callout
Date: Fri, 06 Aug 2010 08:06:31 -0700
Message-ID: <4C5C24F7.3050403@cisco.com>
References: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-2-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-3-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-4-git-send-email-michaelc@cs.wisc.edu> <1281081761-24586-5-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:56985 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab0HFPGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2010 11:06:31 -0400
In-Reply-To: <1281081761-24586-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com

On 8/6/10 1:02 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie<michaelc@cs.wisc.edu>
>
> This fixes a bug where the driver was resetting the
> rport dev_loss_tmo when devices were added by adding
> support for the get_host_def_dev_loss_tmo callout.

fnic devloss timeout isn't settable on the host.
It's only configurable from network configuration.
So, I think this patch is unnecessary.

Note that we don't have a set method, so the
/sys file will be read-only.

> Patch has only been compile tested.
>
> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/fnic/fnic_main.c |   14 ++++++++++----
>   1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 9eb7a9e..df91a61 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -80,8 +80,6 @@ static struct libfc_function_template fnic_transport_template = {
>   static int fnic_slave_alloc(struct scsi_device *sdev)
>   {
>   	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
> -	struct fc_lport *lp = shost_priv(sdev->host);
> -	struct fnic *fnic = lport_priv(lp);
>
>   	sdev->tagged_supported = 1;
>
> @@ -89,8 +87,6 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
>   		return -ENXIO;
>
>   	scsi_activate_tcq(sdev, FNIC_DFLT_QUEUE_DEPTH);
> -	rport->dev_loss_tmo = fnic->config.port_down_timeout / 1000;
> -
>   	return 0;
>   }
>
> @@ -113,6 +109,15 @@ static struct scsi_host_template fnic_host_template = {
>   	.shost_attrs = fnic_attrs,
>   };
>
> +static void
> +fnic_get_host_def_loss_tmo(struct Scsi_Host *shost)
> +{
> +	struct fc_lport *lp = shost_priv(shost);
> +	struct fnic *fnic = lport_priv(lp);
> +
> +	fc_host_def_dev_loss_tmo(shost) = fnic->config.port_down_timeout / 1000;
> +}
> +
>   static void fnic_get_host_speed(struct Scsi_Host *shost);
>   static struct scsi_transport_template *fnic_fc_transport;
>   static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *);
> @@ -142,6 +147,7 @@ static struct fc_function_template fnic_fc_functions = {
>   	.show_rport_dev_loss_tmo = 1,
>   	.issue_fc_host_lip = fnic_reset,
>   	.get_fc_host_stats = fnic_get_stats,
> +	.get_host_def_dev_loss_tmo = fnic_get_host_def_loss_tmo,
>   	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
>   	.terminate_rport_io = fnic_terminate_rport_io,
>   	.bsg_request = fc_lport_bsg_request,
