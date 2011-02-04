From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v6 PATCH 4/4] bnx2fc: Makefile, Kconfig changes and FCoE interfaces
Date: Fri, 04 Feb 2011 11:03:12 -0600
Message-ID: <4D4C3150.60709@cs.wisc.edu>
References: <1296790527.268.827.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41803 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1BDRCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2011 12:02:50 -0500
In-Reply-To: <1296790527.268.827.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mchan@broadcom.com

On 02/03/2011 09:35 PM, Bhanu Gollapudi wrote:

> +
> +static int bnx2fc_l2_rcv_thread(void *arg)
> +{
> +	struct fcoe_percpu_s *bg = arg;
> +	struct sk_buff *skb;
> +
> +	while (!kthread_should_stop()) {
> +		spin_lock_bh(&bg->fcoe_rx_list.lock);
> +		while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) == NULL) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			spin_unlock_bh(&bg->fcoe_rx_list.lock);
> +			schedule();
> +			set_current_state(TASK_RUNNING);
> +			if (kthread_should_stop())
> +				return 0;
> +			spin_lock_bh(&bg->fcoe_rx_list.lock);
> +		}
> +		spin_unlock_bh(&bg->fcoe_rx_list.lock);
> +		bnx2fc_recv_frame(skb);
> +	}
> +	return 0;
> +}
> +
> +

I am not sure this is correct. Do you want to set the state to 
interruptible before calling kthread_should_stop and before scheduling? 
If kthread_stop is called after the check for kthread_should_stop() and 
before setting the state to interruptible then will you have missed 
kthread_stop's wake_up and will you schedule and not wake up again?

Do you need something like:

set_current_state(TASK_INTERRUPTIBLE);
while (!kthread_should_stop()) {
	schedule();
	set_current_state(TASK_RUNNING);
	spin_lock_bh(&bg->fcoe_rx_list.lock);
	while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL) {
		spin_unlock_bh(&bg->fcoe_rx_list.lock);
		bnx2fc_recv_frame(skb);
		spin_lock_bh(&bg->fcoe_rx_list.lock);
	}
	set_current_state(TASK_INTERRUPTIBLE);
}
set_current_state(TASK_RUNNING);
