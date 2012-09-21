From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: Don't disable BH on BH context
Date: Fri, 21 Sep 2012 03:44:37 -0500
Message-ID: <7B2DD735-D51F-4037-A651-2E02684DFFD1@cs.wisc.edu>
References: <1345512507-8257-1-git-send-email-ying.xue@windriver.com>
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37526 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab2IUIoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Sep 2012 04:44:44 -0400
In-Reply-To: <1345512507-8257-1-git-send-email-ying.xue@windriver.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Xue <ying.xue@windriver.com>
Cc: linux-scsi@vger.kernel.org


On Aug 20, 2012, at 8:28 PM, Ying Xue <ying.xue@windriver.com> wrote:

> Since we have already in BH context when iscsi_sw_tcp_write_space()
> is called, it's unnecessary to disable BH.

Hey,

I do don't think this is right anymore. It looks like it can be called in sock_setsockopt.

> 
> Signed-off-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Michael Christie <michaelc@cs.wisc.edu>
> ---
> drivers/scsi/iscsi_tcp.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9220861..d763857 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -194,7 +194,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
> 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
> 	void (*old_write_space)(struct sock *);
> 
> -	read_lock_bh(&sk->sk_callback_lock);
> +	read_lock(&sk->sk_callback_lock);
> 	conn = sk->sk_user_data;
> 	if (!conn) {
> 		read_unlock_bh(&sk->sk_callback_lock);
> @@ -204,7 +204,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
> 	tcp_conn = conn->dd_data;
> 	tcp_sw_conn = tcp_conn->dd_data;
> 	old_write_space = tcp_sw_conn->old_write_space;
> -	read_unlock_bh(&sk->sk_callback_lock);
> +	read_unlock(&sk->sk_callback_lock);
> 
> 	old_write_space(sk);
> 
> -- 
> 1.7.11
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

