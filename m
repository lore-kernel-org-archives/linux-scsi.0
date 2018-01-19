From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH target-pending] iscsi-target: make sure to wake up
 sleeping login worker
Date: Fri, 19 Jan 2018 07:46:25 -0800
Message-ID: <1516376785.3606.37.camel@gmail.com>
References: <20180119133629.14812-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119133629.14812-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
To: Florian Westphal <fw@strlen.de>, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, nab@linux-iscsi.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-01-19 at 14:36 +0100, Florian Westphal wrote:
> Mike Christie reports:
>   Starting in 4.14 iscsi logins will fail around 50% of the time.
> 
> Problem appears to be that iscsi_target_sk_data_ready() callback may
> return without doing anything in case it finds the login work queue
> is still blocked in sock_recvmsg().
> 
> Nicholas Bellinger says:
>   It would indicate users providing their own ->sk_data_ready() callback
>   must be responsible for waking up a kthread context blocked on
>   sock_recvmsg(..., MSG_WAITALL), when a second ->sk_data_ready() is
>   received before the first sock_recvmsg(..., MSG_WAITALL) completes.
> 
> So, do this and invoke the original data_ready() callback -- in
> case of tcp sockets this takes care of waking the thread.
> 
> Disclaimer: I do not understand why this problem did not show up before
> tcp prequeue removal.
> 
> Reported-by: Mike Christie <mchristi@redhat.com>
> Bisected-by: Mike Christie <mchristi@redhat.com>
> Tested-by: Mike Christie <mchristi@redhat.com>
> Diagnosed-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Fixes: e7942d0633c4 ("tcp: remove prequeue support")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index b686e2ce9c0e..3723f8f419aa 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -432,6 +432,9 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
>  	if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
>  		write_unlock_bh(&sk->sk_callback_lock);
>  		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
> +		if (WARN_ON(iscsi_target_sk_data_ready == conn->orig_data_ready))
> +			return;

Is this WARN_ON() belonging to this fix ?
At least make it WARN_ON_ONCE() or pr_err_once()

> +		conn->orig_data_ready(sk);
>  		return;
>  	}
>  
