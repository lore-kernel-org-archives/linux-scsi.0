From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH] bnx2fc: use kthread_create_on_node
Date: Fri, 29 Jul 2011 12:22:50 -0700
Message-ID: <4E33088A.80903@broadcom.com>
References: <1311923178.7845.21.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4359 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1G2TXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 15:23:05 -0400
In-Reply-To: <1311923178.7845.21.camel@edumazet-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 7/29/2011 12:06 AM, Eric Dumazet wrote:
> Since bnx2fc_percpu_thread_create() creates percpu kthread, it makes
> sense to use kthread_create_on_node() to get proper NUMA affinity for
> kthread stack.
>
> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
> CC: "James E.J. Bottomley"<JBottomley@parallels.com>

Thanks Eric.

Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

> ---
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index a97aff3..9843434 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2161,9 +2161,9 @@ static void bnx2fc_percpu_thread_create(unsigned int cpu)
>
>   	p =&per_cpu(bnx2fc_percpu, cpu);
>
> -	thread = kthread_create(bnx2fc_percpu_io_thread,
> -				(void *)p,
> -				"bnx2fc_thread/%d", cpu);
> +	thread = kthread_create_on_node(bnx2fc_percpu_io_thread,
> +					(void *)p, cpu_to_node(cpu),
> +					"bnx2fc_thread/%d", cpu);
>   	/* bind thread to the cpu */
>   	if (likely(!IS_ERR(p->iothread))) {
>   		kthread_bind(thread, cpu);
>
>
>


