From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [Suspected SPAM] [PATCH 3/3] SCSI: qla2xxx, fix lock imbalance
Date: Tue, 16 Mar 2010 13:23:09 -0700
Message-ID: <C7C536BD.5D55%giridhar.malavali@qlogic.com>
References: <1268753039-17214-3-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22357 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0CPUXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2010 16:23:14 -0400
In-Reply-To: <1268753039-17214-3-git-send-email-jslaby@suse.cz>
Content-Language: en
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: LinuxSCSI <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jirislaby@gmail.com" <jirislaby@gmail.com>




On 3/16/10 8:23 AM, "Jiri Slaby" <jslaby@suse.cz> wrote:

> Stanse found that one error path in qla24xx_bsg_timeout omits to
> unlock ha->hardware_lock. Fix that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Cc: James Bottomley <James.Bottomley@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 90d1e06..a3591e5 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2388,6 +2388,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
>         return 0;
> 
>  done:
> +       spin_unlock_irqrestore(&ha->hardware_lock, flags);
>         if (bsg_job->request->msgcode == FC_BSG_HST_CT)
>                 kfree(sp->fcport);
>         kfree(sp->ctx);
> --
> 1.7.0.1
> 
> 
Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>

