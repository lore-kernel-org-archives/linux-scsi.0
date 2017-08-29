From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v2 2/2] libiscsi: Remove iscsi_destroy_session
Date: Tue, 29 Aug 2017 11:30:01 -0700
Message-ID: <20170829183001.6ncutkoss6qfekd7@straylight.hirudinean.org>
References: <20170713161122.89375-1-khazhy@google.com>
 <20170713161122.89375-2-khazhy@google.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCYMVIPVXQMBBM7FS3GQKGQEENPTNJI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20170713161122.89375-2-khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: 'Khazhismel Kumykov' via open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: lduncan-IBi9RG/b67k@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Khazhismel Kumykov <khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Thanks.

Acked-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Jul 13, 2017 at 09:11:22AM -0700, 'Khazhismel Kumykov' via open-iscsi wrote:
> iscsi_session_teardown was the only user of this function. Function
> currently is just short for iscsi_remove_session + iscsi_free_session.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 16 ----------------
>  include/scsi/scsi_transport_iscsi.h |  1 -
>  2 files changed, 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index a424eaeafeb0..924ac408d8a9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2210,22 +2210,6 @@ void iscsi_free_session(struct iscsi_cls_session *session)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_free_session);
>  
> -/**
> - * iscsi_destroy_session - destroy iscsi session
> - * @session: iscsi_session
> - *
> - * Can be called by a LLD or iscsi_transport. There must not be
> - * any running connections.
> - */
> -int iscsi_destroy_session(struct iscsi_cls_session *session)
> -{
> -	iscsi_remove_session(session);
> -	ISCSI_DBG_TRANS_SESSION(session, "Completing session destruction\n");
> -	iscsi_free_session(session);
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(iscsi_destroy_session);
> -
>  /**
>   * iscsi_create_conn - create iscsi class connection
>   * @session: iscsi cls session
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 6183d20a01fb..b266d2a3bcb1 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -434,7 +434,6 @@ extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
>  						unsigned int target_id);
>  extern void iscsi_remove_session(struct iscsi_cls_session *session);
>  extern void iscsi_free_session(struct iscsi_cls_session *session);
> -extern int iscsi_destroy_session(struct iscsi_cls_session *session);
>  extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
>  						int dd_size, uint32_t cid);
>  extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
> -- 
> 2.13.2.932.g7449e964c-goog
> 
> -- 
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> Visit this group at https://groups.google.com/group/open-iscsi.
> For more options, visit https://groups.google.com/d/optout.


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
