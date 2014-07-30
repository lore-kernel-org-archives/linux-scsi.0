From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] libiscsi: return new error code when nop times out
Date: Wed, 30 Jul 2014 14:52:37 +0200
Message-ID: <53D8EA95.4030104@suse.de>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu> <1405198311-64449-5-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbaG3Mwj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 08:52:39 -0400
In-Reply-To: <1405198311-64449-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 07/12/2014 10:51 PM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> When a iscsi nop as ping timedout we were failing with the
> common connection error code, ISCSI_ERR_CONN_FAILED. This
> patch adds a new error code for this problem so can properly
> track/distinguish in userspace.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/libiscsi.c |    2 +-
>   include/scsi/iscsi_if.h |    1 +
>   2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f2db82b..b0813fd 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2097,7 +2097,7 @@ static void iscsi_check_transport_timeouts(unsi=
gned long data)
>   				  conn->ping_timeout, conn->recv_timeout,
>   				  last_recv, conn->last_ping, jiffies);
>   		spin_unlock(&session->frwd_lock);
> -		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
> +		iscsi_conn_failure(conn, ISCSI_ERR_NOP_TIMEDOUT);
>   		return;
>   	}
>
> diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
> index fd0421c..95ed942 100644
> --- a/include/scsi/iscsi_if.h
> +++ b/include/scsi/iscsi_if.h
> @@ -527,6 +527,7 @@ enum iscsi_err {
>   	ISCSI_ERR_XMIT_FAILED		=3D ISCSI_ERR_BASE + 19,
>   	ISCSI_ERR_TCP_CONN_CLOSE	=3D ISCSI_ERR_BASE + 20,
>   	ISCSI_ERR_SCSI_EH_SESSION_RST	=3D ISCSI_ERR_BASE + 21,
> +	ISCSI_ERR_NOP_TIMEDOUT		=3D ISCSI_ERR_BASE + 22,
>   };
>
>   /*
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
