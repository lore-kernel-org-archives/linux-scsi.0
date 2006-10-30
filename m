From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: avoid oops when destroying unbound connection
Date: Mon, 30 Oct 2006 12:02:17 -0600
Message-ID: <45463E29.2070204@cs.wisc.edu>
References: <20061030012912.GA12233@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32174 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932467AbWJ3SCY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 13:02:24 -0500
In-Reply-To: <20061030012912.GA12233@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: linux-scsi@vger.kernel.org

Pete Wyckoff wrote:
> Initialize the conn->item list head in a connection, used for
> associating it with a session, to avoid an oops if list_del happens
> before the connection is bound.  The oops is easy enough to
> reproduce by calling CREATE_SESSION, CREATE_CONN, then DESTROY_CONN
> (but no BIND_CONN) from userspace.
> 
> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> ---
>  drivers/scsi/libiscsi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index c542d0e..66fc239 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1477,6 +1477,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
>  	INIT_LIST_HEAD(&conn->run_list);
>  	INIT_LIST_HEAD(&conn->mgmt_run_list);
>  	INIT_LIST_HEAD(&conn->xmitqueue);
> +	INIT_LIST_HEAD(&conn->item);
>  
>  	/* initialize general immediate & non-immediate PDU commands queue */
>  	conn->immqueue = kfifo_alloc(session->mgmtpool_max * sizeof(void*),


Thanks for the patch. We actually already fixed this by just removing
that list. It was not being used for what it was originally intended and
was getting in the way.

The fix should be in 2.6.19-rc4 when it comes out.
