From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] iscsi_tcp: consider session state in iscsi_sw_sk_state_check
Date: Wed, 24 Jul 2013 20:02:52 -0500
Message-ID: <51F0793C.1090401@cs.wisc.edu>
References: <1374615728-11056-1-git-send-email-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBRHSYGHQKGQE34SAF5Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1374615728-11056-1-git-send-email-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 07/23/2013 04:42 PM, Chris Leech wrote:
> It seems some iSCSI targets (including the Linux kernel target) close
> the TCP connection from the target side immediately after processing a
> session logout.
> 
> When a TCP FIN comes in right after the iSCSI logout response,
> iscsi_sw_sk_state_check sees the local socket as not yet being in
> CLOSE_WAIT or CLOSE and logs an error.  But the initiator would close
> the connection right after processing the logout response anyway, and
> the error is confusing to admins who just requested that the session be
> shut down.
> 
> This adds a check of the session state, and suppresses the error if we
> are in the process of logging out.
> 
> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/iscsi_tcp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9e2588a..add6d15 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -116,6 +116,7 @@ static inline int iscsi_sw_sk_state_check(struct sock *sk)
>  	struct iscsi_conn *conn = sk->sk_user_data;
>  
>  	if ((sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) &&
> +	    (conn->session->state != ISCSI_STATE_LOGGING_OUT) &&
>  	    !atomic_read(&sk->sk_rmem_alloc)) {
>  		ISCSI_SW_TCP_DBG(conn, "TCP_CLOSE|TCP_CLOSE_WAIT\n");
>  		iscsi_conn_failure(conn, ISCSI_ERR_TCP_CONN_CLOSE);
> 

My only concern with the patch is what happens if the target closes
connection due to a logout processing error. The logout timeout will
kick in so we do not hang, but the patch makes it harder to debug those
type of problems. I think the annoyance that this error message causes
is higher than those concerns though since that happens so rarely now.
So patch is ok with me.


Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.
