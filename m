From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [patch] ibmvfc: prevent a potential deadlock
Date: Fri, 15 Jul 2016 11:06:05 -0400
Message-ID: <1468595165.4064.44.camel@localhost.localdomain>
References: <20160715111857.GC13153@mwanda>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbcGOPGH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 11:06:07 -0400
In-Reply-To: <20160715111857.GC13153@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2016-07-15 at 14:18 +0300, Dan Carpenter wrote:
> My static checker complains that we need to unlock on this path.  Seems
> true.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index fc523c3..ab67ec4 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -4722,6 +4722,8 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
>  					tgt_dbg(tgt, "Setting rport roles\n");
>  					fc_remote_port_rolechg(rport, tgt->ids.roles);
>  					put_device(&rport->dev);
> +				} else {
> +					spin_unlock_irqrestore(vhost->host->host_lock, flags);
>  				}
>  
>  				kref_put(&tgt->kref, ibmvfc_release_tgt);
> --

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

