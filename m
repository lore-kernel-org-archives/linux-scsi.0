From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] iscsi: conn error (1020) each time iscsi session logout
Date: Wed, 18 Dec 2013 01:17:36 -0600
Message-ID: <52B14C10.4060709@cs.wisc.edu>
References: <1387349221-18501-1-git-send-email-vaughan.cao@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBFUYYWKQKGQEHOYHPLI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1387349221-18501-1-git-send-email-vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Vaughan Cao <vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: James.Bottomley-l3A5Bk7waGM@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 12/18/2013 12:47 AM, Vaughan Cao wrote:
> We do a normal login/logout process to iscsi server. iscsiadm report success,
> but we always see the following error just before conn shutdown in dmesg.
> 
> Oct 15 05:30:09 vmhodtest019 iscsid: Connection1:0 to [target:
> iqn.1986-03.com.sun:02:7b863a18-045a-cb04-c686-841f17df2f9c, portal:
> 10.182.32.162,3260] through [iface: default] is operational now
> Oct 15 05:30:42 vmhodtest019 kernel:  connection1:0: detected conn error
> (1020)
> Oct 15 05:30:42 vmhodtest019 iscsid: Connection1:0 to [target:
> iqn.1986-03.com.sun:02:7b863a18-045a-cb04-c686-841f17df2f9c, portal:
> 10.182.32.162,3260] through [iface: default] is shutdown.
> 
> It's because iscsi_tcp module evaluates socket state in data_ready() callback,
>  and that detect the socket close. However, this socket close on target peer 
> is in response to the logout request from initiator. So this is not an error 
> that should be reported out. I quiesce it by checking session state and err 
> value accordingly.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/libiscsi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 415f2c0..84171ef 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1360,6 +1360,12 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
>  		spin_unlock_bh(&session->lock);
>  		return;
>  	}
> +	/* Target closed the connection in response to logout */
> +	if (session->state == ISCSI_STATE_LOGGING_OUT &&
> +		err == ISCSI_ERR_TCP_CONN_CLOSE) {
> +		spin_unlock_bh(&session->lock);
> +		return;
> +	}
>  
>  	if (conn->stop_stage == 0)
>  		session->state = ISCSI_STATE_FAILED;
> 


Someone just sent a patch for this.

commit c712495e687e221b00bddae96247dbf6ffbc6200
Author: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 26 09:09:44 2013 -0700

    [SCSI] iscsi_tcp: consider session state in iscsi_sw_sk_state_check


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.
