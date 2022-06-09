Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2463CCA473
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 12:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245212AbiFIMOV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 08:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242744AbiFIMOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 08:14:20 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9051512F35A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 05:14:19 -0700 (PDT)
Date:   Thu, 9 Jun 2022 14:14:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654776857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5uWL1ArULPDWUS6tOuTA5hN3EW/IJt7+aM/VeD92KAA=;
        b=BaeuivrlpxmL6t7PcuRp6hHe/Pb1DTIl2m54aOGO2tr7Kzu9Zscm44aiQQLn6gFEwG/PHO
        DWjwVWE9QlG0Aj2q39rXGXAugr8gI2PX2SprWDtR7D+87zp1Hdogx/V3ekPMN9MqXJyaNP
        lvLCXAw/NdeyQeAn0285TdXAkLQu3OQoRWr0RpbGpIGsaU7VLtucWO72QjJFK8pv/N51zj
        36j0cekeAtDNm82lzkGS27yLkt2ugCbHyq9v1JnXb2JR0O1ac+RHHYaPgO06CIDOaMHsC9
        Rj8QdNduDk45qsttHTyAxXdXnZkVPFRtvrJUriYTKPEWXvnYfauy4nNtOmMIkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654776857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5uWL1ArULPDWUS6tOuTA5hN3EW/IJt7+aM/VeD92KAA=;
        b=126RNnEEsUdRbOjuk5N0W3GuztEhGJFgm/EEhnRtGOTk2hnlCIMKA0kjgAm/9T3Apo9erN
        NC5MH4s7fUwaKhDg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Bradley Grove <linuxdrivers@attotech.com>
Subject: Re: [PATCH 07/10] scsi/esas2r: Replace tasklet with workqueue
Message-ID: <YqHkF+bJWNhsQa1N@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-8-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220530231512.9729-8-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:09 [-0700], Davidlohr Bueso wrote:
> diff --git a/drivers/scsi/esas2r/esas2r_int.c b/drivers/scsi/esas2r/esas2r_int.c
> index 5281d9356327..1b1b8b65539d 100644
> --- a/drivers/scsi/esas2r/esas2r_int.c
> +++ b/drivers/scsi/esas2r/esas2r_int.c
> @@ -86,7 +86,7 @@ void esas2r_polled_interrupt(struct esas2r_adapter *a)
>  
>  /*
>   * Legacy and MSI interrupt handlers.  Note that the legacy interrupt handler
> - * schedules a TASKLET to process events, whereas the MSI handler just
> + * schedules work to process events, whereas the MSI handler just
>   * processes interrupt events directly.

Yeah, and why? What is special about the legacy vs MSI that different
behaviour is needed. Why not do the tasklet/workqueue thingy for MSI,
too?

>   */
>  irqreturn_t esas2r_interrupt(int irq, void *dev_id)
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index 7a4eadad23d7..abe45a934cce 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -1540,10 +1550,10 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
>  	esas2r_free_request(a, rq);
>  }
>  
> -/* Run tasklet to handle stuff outside of interrupt context. */
> -void esas2r_adapter_tasklet(unsigned long context)
> +/* Handle stuff outside of interrupt context. */
> +void esas2r_adapter_work(struct work_struct *work)
>  {
> -	struct esas2r_adapter *a = (struct esas2r_adapter *)context;
> +	struct esas2r_adapter *a = (struct esas2r_adapter *)work;

container_of()

>  
>  	if (unlikely(test_bit(AF2_TIMER_TICK, &a->flags2))) {
>  		clear_bit(AF2_TIMER_TICK, &a->flags2);
> @@ -1555,16 +1565,16 @@ void esas2r_adapter_tasklet(unsigned long context)
>  		esas2r_adapter_interrupt(a);
>  	}
>  
> -	if (esas2r_is_tasklet_pending(a))
> -		esas2r_do_tasklet_tasks(a);
> +	if (esas2r_is_work_pending(a))
> +		esas2r_do_work_tasks(a);
>  
> -	if (esas2r_is_tasklet_pending(a)
> +	if (esas2r_is_work_pending(a)
>  	    || (test_bit(AF2_INT_PENDING, &a->flags2))
>  	    || (test_bit(AF2_TIMER_TICK, &a->flags2))) {
> -		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
> -		esas2r_schedule_tasklet(a);
> +		clear_bit(AF_WORK_SCHEDULED, &a->flags);
> +		esas2r_schedule_work(a);

This AF_TASKLET_SCHEDULED bit is odd and shouldn't be needed. What you
usually do is set_bit() + schedule_tasklet() and clear_bit() within the
tasklet. If the tasklet is already running then it will be scheduled
again which is intended. If it is not yet running then it will run once.

>  	} else {
> -		clear_bit(AF_TASKLET_SCHEDULED, &a->flags);
> +		clear_bit(AF_WORK_SCHEDULED, &a->flags);
>  	}
>  }
>  
> @@ -1586,7 +1596,7 @@ static void esas2r_timer_callback(struct timer_list *t)
>  
>  	set_bit(AF2_TIMER_TICK, &a->flags2);
>  
> -	esas2r_schedule_tasklet(a);
> +	esas2r_schedule_work(a);
>  
>  	esas2r_kickoff_timer(a);

It appears that the timer is always scheduled (except in degraded
mode) and the timer re-arms itself and schedules the tasklet. The timer
and the tasklet are synchronized and the tasklet will always after the
timer and one can not interrupt the other. But with the workqueue you
can get the following depending on how much the workqueue was delayed:

       worker                                                timer
   esas2r_adapter_work();
    -> test_bit(AF2_TIMER_TICK, &a->flags2) -> false
                                                            esas2r_timer_callback
                                                            set_bit(AF2_TIMER_TICK, &a->flags2);
                                                            esas2r_schedule_tasklet()
                                                            -> if (!test_and_set_bit(AF_TASKLET_SCHEDULED, &a->flags)) (bit set)
                                                               no schedule since bit was set
                                                            esas2r_kickoff_timer();
       clear_bit(AF_TASKLET_SCHEDULED, &a->flags);

No more tasklets. So another reason to get rid of this
AF_TASKLET_SCHEDULED bit ;)

>  }

Sebastian
