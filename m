From: Or Gerlitz <ogerlitz@Voltaire.com>
Subject: Re: [PATCH 06/16] BNX2I: Added code to handle the binding of an	existing
 connection
Date: Thu, 6 Jan 2011 08:54:50 +0200
Message-ID: <4D25673A.6070701@Voltaire.com>
References: <Eddie Wai <eddie.wai@broadcom.com>	<1289430297-30221-7-git-send-email-eddie.wai@broadcom.com>	<4CE49C85.2070109@cs.wisc.edu> <4D1FFADB.60307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:14014 "EHLO
	Exil2010.voltaire.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754018Ab1AFGyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 01:54:54 -0500
In-Reply-To: <4D1FFADB.60307@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

Mike Christie wrote:
> I went a different way. In the attached patch we detect the problem when
> binding and will force a disconnect of the old ep before binding a new one.
> Try it out and let me know.

> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -651,8 +651,7 @@ free_addr:
>  
>  static int
>  iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
> -		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
> -		       int is_leading)
> +		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph)
>  {
>  	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
>  	struct iscsi_host *ihost = shost_priv(shost);
> @@ -685,7 +684,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
>  	if (err)
>  		goto free_socket;
>  
> -	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
> +	err = iscsi_conn_bind(cls_session, cls_conn, NULL);

should this be transport_eph instead of NULL?

> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3137,16 +3137,18 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
>  EXPORT_SYMBOL_GPL(iscsi_conn_stop);
>  
>  int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
> -		    struct iscsi_cls_conn *cls_conn, int is_leading)
> +		    struct iscsi_cls_conn *cls_conn,
> +		    struct iscsi_endpoint *ep)
>  {
>  	struct iscsi_session *session = cls_session->dd_data;
>  	struct iscsi_conn *conn = cls_conn->dd_data;
>  
>  	spin_lock_bh(&session->lock);
> -	if (is_leading)
> -		session->leadconn = conn;
> +	session->leadconn = conn;
>  	spin_unlock_bh(&session->lock);
>  
> +	ep->conn = cls_conn;
> +	cls_conn->ep = ep;

if not, it doesn't look like ep can be null here...


> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -388,7 +388,7 @@ extern void iscsi_conn_teardown(struct iscsi_cls_conn *);
>  extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
> -			   int);
> +			   struct iscsi_endpoint *);

> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -95,7 +95,7 @@ struct iscsi_transport {
>  				uint32_t cid);
>  	int (*bind_conn) (struct iscsi_cls_session *session,
>  			  struct iscsi_cls_conn *cls_conn,
> -			  uint64_t transport_eph, int is_leading);
> +			  uint64_t transport_eph);

so we're implicitly casting from u64 to ep pointer? I guess this should be fine.

Or.
