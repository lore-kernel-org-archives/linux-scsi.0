From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH] bnx2i: use kthread_create_on_node()
Date: Thu, 2 Feb 2012 16:57:50 -0800
Message-ID: <1328230670.5058.160.camel@dhcp-10-12-137-160.irv.broadcom.com>
References: <1328187802.2279.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2481 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab2BCAyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Feb 2012 19:54:45 -0500
In-Reply-To: <1328187802.2279.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Michael Chan <mchan@broadcom.com>, Benjamin Li <benli@broadcom.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Looks good, thanks.

Acked-by: Eddie Wai <eddie.wai@broadcom.com>

On Thu, 2012-02-02 at 14:03 +0100, Eric Dumazet wrote:
> bnx2i_percpu_thread_create() create per cpu kthread, and should use
> proper NUMA aware API.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Eddie Wai <eddie.wai@broadcom.com>
> Cc: Benjamin Li <benli@broadcom.com>
> Cc: Michael Chan <mchan@broadcom.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_init.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
> index 1a947f1..62c8c0a 100644
> --- a/drivers/scsi/bnx2i/bnx2i_init.c
> +++ b/drivers/scsi/bnx2i/bnx2i_init.c
> @@ -393,8 +393,9 @@ static void bnx2i_percpu_thread_create(unsigned int cpu)
>  
>  	p = &per_cpu(bnx2i_percpu, cpu);
>  
> -	thread = kthread_create(bnx2i_percpu_io_thread, (void *)p,
> -				"bnx2i_thread/%d", cpu);
> +	thread = kthread_create_on_node(bnx2i_percpu_io_thread, (void *)p,
> +					cpu_to_node(cpu),
> +					"bnx2i_thread/%d", cpu);
>  	/* bind thread to the cpu */
>  	if (likely(!IS_ERR(thread))) {
>  		kthread_bind(thread, cpu);
> 
> 
> 


