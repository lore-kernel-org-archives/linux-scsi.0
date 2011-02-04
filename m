From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [v6 PATCH 4/4] bnx2fc: Makefile,	Kconfig changes
 and FCoE interfaces
Date: Fri, 04 Feb 2011 11:28:32 -0600
Message-ID: <4D4C3740.9080407@cs.wisc.edu>
References: <1296790527.268.827.camel@LTLNR-SJCE10.corp.ad.broadcom.com> <4D4C3150.60709@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42080 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1BDR2H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2011 12:28:07 -0500
In-Reply-To: <4D4C3150.60709@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/04/2011 11:03 AM, Mike Christie wrote:

> set_current_state(TASK_INTERRUPTIBLE);
> while (!kthread_should_stop()) {
> schedule();
> set_current_state(TASK_RUNNING);
> spin_lock_bh(&bg->fcoe_rx_list.lock);
> while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL) {
> spin_unlock_bh(&bg->fcoe_rx_list.lock);
> bnx2fc_recv_frame(skb);
> spin_lock_bh(&bg->fcoe_rx_list.lock);
> }

Oops, missing spin_unlock here.


> set_current_state(TASK_INTERRUPTIBLE);
> }
> set_current_state(TASK_RUNNING);
> _______________________________________________
> devel mailing list
> devel@open-fcoe.org
> https://lists.open-fcoe.org/mailman/listinfo/devel

