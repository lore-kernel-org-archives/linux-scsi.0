From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/4] fcoe: use dedicated workqueue instead of system_wq
Date: Mon, 24 Jan 2011 22:43:34 -0600
Message-ID: <1295930614.15425.137.camel@mulgrave.site>
References: <1295877451-16602-1-git-send-email-tj@kernel.org>
	 <1295877451-16602-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41374 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275Ab1AYGj7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 01:39:59 -0500
In-Reply-To: <1295877451-16602-4-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Robert Love <robert.w.love@intel.com>

On Mon, 2011-01-24 at 14:57 +0100, Tejun Heo wrote:
> fcoe uses the system_wq to destroy ports and the work items need to be
> flushed before the driver is unloaded.  As the work items free the
> containing data structure, they can't be flushed directly.  The
> workqueue should be flushed instead.
> 
> Also, the destruction works can be chained - ie. destruction of a port
> may lead to destruction of another port where the work item for the
> former queues the work for the latter.  Currently, the depth of chain
> can be at most two and fcoe_exit() makes sure everything is complete
> by calling flush_scheduled_work() twice.
> 
> With commit c8efcc25 (workqueue: allow chained queueing during
> destruction), destroy_workqueue() can take care of chained works on
> workqueue destruction.  Add and use fcoe_wq instead.  Simply
> destroying fcoe_wq on driver unload takes care of flushing.

Cc'ing FCoE maintainer for an opinion.

Robert, I assume this will come back via your queue with an ack.

James


> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/scsi/fcoe/fcoe.c |   25 ++++++++++++++++---------
>  1 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 9f9600b..e2f5820 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -31,6 +31,7 @@
>  #include <linux/fs.h>
>  #include <linux/sysfs.h>
>  #include <linux/ctype.h>
> +#include <linux/workqueue.h>
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsicam.h>
>  #include <scsi/scsi_transport.h>
> @@ -58,6 +59,8 @@ MODULE_PARM_DESC(ddp_min, "Minimum I/O size in bytes for "	\
>  
>  DEFINE_MUTEX(fcoe_config_mutex);
>  
> +static struct workqueue_struct *fcoe_wq;
> +
>  /* fcoe_percpu_clean completion.  Waiter protected by fcoe_create_mutex */
>  static DECLARE_COMPLETION(fcoe_flush_completion);
>  
> @@ -1874,7 +1877,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
>  		list_del(&fcoe->list);
>  		port = lport_priv(fcoe->ctlr.lp);
>  		fcoe_interface_cleanup(fcoe);
> -		schedule_work(&port->destroy_work);
> +		queue_work(fcoe_wq, &port->destroy_work);
>  		goto out;
>  		break;
>  	case NETDEV_FEAT_CHANGE:
> @@ -2412,6 +2415,10 @@ static int __init fcoe_init(void)
>  	unsigned int cpu;
>  	int rc = 0;
>  
> +	fcoe_wq = alloc_workqueue("fcoe", 0, 0);
> +	if (!fcoe_wq)
> +		return -ENOMEM;
> +
>  	mutex_lock(&fcoe_config_mutex);
>  
>  	for_each_possible_cpu(cpu) {
> @@ -2442,6 +2449,7 @@ out_free:
>  		fcoe_percpu_thread_destroy(cpu);
>  	}
>  	mutex_unlock(&fcoe_config_mutex);
> +	destroy_workqueue(fcoe_wq);
>  	return rc;
>  }
>  module_init(fcoe_init);
> @@ -2467,7 +2475,7 @@ static void __exit fcoe_exit(void)
>  		list_del(&fcoe->list);
>  		port = lport_priv(fcoe->ctlr.lp);
>  		fcoe_interface_cleanup(fcoe);
> -		schedule_work(&port->destroy_work);
> +		queue_work(fcoe_wq, &port->destroy_work);
>  	}
>  	rtnl_unlock();
>  
> @@ -2478,12 +2486,11 @@ static void __exit fcoe_exit(void)
>  
>  	mutex_unlock(&fcoe_config_mutex);
>  
> -	/* flush any asyncronous interface destroys,
> -	 * this should happen after the netdev notifier is unregistered */
> -	flush_scheduled_work();
> -	/* That will flush out all the N_Ports on the hostlist, but now we
> -	 * may have NPIV VN_Ports scheduled for destruction */
> -	flush_scheduled_work();
> +	/*
> +	 * destroy_work's may be chained but destroy_workqueue() can take
> +	 * care of them.  Just kill the wq.
> +	 */
> +	destroy_workqueue(fcoe_wq);
>  
>  	/* detach from scsi transport
>  	 * must happen after all destroys are done, therefor after the flush */
> @@ -2632,7 +2639,7 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
>  	mutex_lock(&n_port->lp_mutex);
>  	list_del(&vn_port->list);
>  	mutex_unlock(&n_port->lp_mutex);
> -	schedule_work(&port->destroy_work);
> +	queue_work(fcoe_wq, &port->destroy_work);
>  	return 0;
>  }
>  


