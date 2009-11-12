From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09/17] Add thread to allow controllers to register for
 rescan for new devices
Date: Thu, 12 Nov 2009 14:50:13 -0800
Message-ID: <20091112145013.b1172579.akpm@linux-foundation.org>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
	<20091111165109.17754.12015.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbZKLWuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Nov 2009 17:50:16 -0500
In-Reply-To: <20091111165109.17754.12015.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com

On Wed, 11 Nov 2009 10:51:09 -0600
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> Add thread to allow controllers to register for rescan for new devices
> (borrowed code from cciss.)
> 
> + * add_to_scan_list() - add controller to rescan queue
> + * @h:		      Pointer to the controller.
> + *
> + * Adds the controller to the rescan queue if not already on the queue.
> + *
> + * returns 1 if added to the queue, 0 if skipped (could be on the
> + * queue already, or the controller could be initializing or shutting
> + * down).
> + **/
> +static int add_to_scan_list(struct ctlr_info *h)
> +{
> +	struct ctlr_info *test_h;
> +	int found = 0;
> +	int ret = 0;
> +
> +	if (h->busy_initializing)
> +		return 0;
> +
> +	if (!mutex_trylock(&h->busy_shutting_down))
> +		return 0;

Generally a trylock needs a comment explaining wtf it's there for.

This one certainly does.

> +	mutex_lock(&scan_mutex);
> +	list_for_each_entry(test_h, &scan_q, scan_list) {
> +		if (test_h == h) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	if (!found && !h->busy_scanning) {
> +		INIT_COMPLETION(h->scan_wait);
> +		list_add_tail(&h->scan_list, &scan_q);
> +		ret = 1;
> +	}
> +	mutex_unlock(&scan_mutex);
> +	mutex_unlock(&h->busy_shutting_down);
> +
> +	return ret;
> +}
>
> ...
>
> +/* scan_thread() - kernel thread used to rescan controllers
> + * @data:	 Ignored.
> + *
> + * A kernel thread used scan for drive topology changes on
> + * controllers. The thread processes only one controller at a time
> + * using a queue.  Controllers are added to the queue using
> + * add_to_scan_list() and removed from the queue either after done
> + * processing or using remove_from_scan_list().
> + *
> + * returns 0.
> + **/
> +static int scan_thread(__attribute__((unused)) void *data)

Is the attribute actually needed?

We have various helper macros, such as __always_unused.

> +{
> +	struct ctlr_info *h;
> +	int host_no;
> +
> +	while (1) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		schedule();
> +		if (kthread_should_stop())
> +			break;

Looks wrong.  If a kthread_stop() comes in just before the
set_current_state(), I think the thread will sleep forever?

> +		while (1) {
> +			mutex_lock(&scan_mutex);
> +			if (list_empty(&scan_q)) {
> +				mutex_unlock(&scan_mutex);
> +				break;
> +			}
> +			h = list_entry(scan_q.next, struct ctlr_info,
> +					scan_list);
> +			list_del(&h->scan_list);
> +			h->busy_scanning = 1;
> +			mutex_unlock(&scan_mutex);
> +			host_no = h->scsi_host ?  h->scsi_host->host_no : -1;
> +			hpsa_update_scsi_devices(h, host_no);
> +			complete_all(&h->scan_wait);
> +			mutex_lock(&scan_mutex);
> +			h->busy_scanning = 0;
> +			mutex_unlock(&scan_mutex);
> +		}
> +	}
> +	return 0;
> +}
> +
>
> ...
>
