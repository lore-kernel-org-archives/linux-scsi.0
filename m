From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 06/12] scsi_transport_srp: Reduce failover time
Date: Thu, 30 Apr 2015 13:13:01 +0300
Message-ID: <5542002D.8060308@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EF01.3030008@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36274 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbbD3KNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 06:13:05 -0400
Received: by lagv1 with SMTP id v1so40334391lag.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2015 03:13:04 -0700 (PDT)
In-Reply-To: <5541EF01.3030008@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/30/2015 11:59 AM, Bart Van Assche wrote:
> Unlike FC, there is no risk that SCSI devices will be offlined
> by the error handler if it is started while a reconnect attempt
> is ongoing. Hence report timeout errors as soon as possible
> if a higher software layer (e.g. multipathd) needs to be informed
> about a timeout. It is assumed that if both fast_io_fail_tmo < 0
> and rport->dev_loss_tmo < 0 that this means that there is no
> need to report timeouts quickly.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: James Bottomley <JBottomley@Odin.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
> ---
>   drivers/scsi/scsi_transport_srp.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 4a44337..6667c2b 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -61,6 +61,11 @@ static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
>   	return dev_to_shost(r->dev.parent);
>   }
>
> +static inline struct srp_rport *shost_to_rport(struct Scsi_Host *shost)
> +{
> +	return transport_class_to_srp_rport(&shost->shost_gendev);
> +}
> +
>   /**
>    * srp_tmo_valid() - check timeout combination validity
>    * @reconnect_delay: Reconnect delay in seconds.
> @@ -626,9 +631,11 @@ static enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
>   	struct scsi_device *sdev = scmd->device;
>   	struct Scsi_Host *shost = sdev->host;
>   	struct srp_internal *i = to_srp_internal(shost->transportt);
> +	struct srp_rport *rport = shost_to_rport(shost);
>
>   	pr_debug("timeout for sdev %s\n", dev_name(&sdev->sdev_gendev));
> -	return i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
> +	return rport->fast_io_fail_tmo < 0 && rport->dev_loss_tmo < 0 &&
> +		i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
>   		BLK_EH_RESET_TIMER : BLK_EH_NOT_HANDLED;
>   }
>
>

I'm not sure I understand the purpose of this patch? If the user
requested fast_io_fail_tmo of X, I would assume it wants srp to retry
for the command for X secs. Why should we fail it any earlier than that?

There is a situation where I've seen srp starting the fast_io_fail_tmo
later than expected because the QP retry exceeded error completion
arrives late for certain workloads. Was this the motivation for this
patch?

Sagi.
