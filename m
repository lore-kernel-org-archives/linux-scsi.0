From: Lee Duncan <lduncan@suse.com>
Subject: Re: [Patch v2 2/2] libiscsi: Remove iscsi_destroy_session
Date: Wed, 13 Sep 2017 17:09:03 -0700
Message-ID: <9be07c2e-71ef-cab4-7b04-94d33a191d03@suse.com>
References: <20170713161122.89375-1-khazhy@google.com>
 <20170713161122.89375-2-khazhy@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39849 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751173AbdINAJI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 20:09:08 -0400
In-Reply-To: <20170713161122.89375-2-khazhy@google.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Khazhismel Kumykov <khazhy@google.com>, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com

On 07/13/2017 09:11 AM, Khazhismel Kumykov wrote:
> iscsi_session_teardown was the only user of this function. Function
> currently is just short for iscsi_remove_session + iscsi_free_session.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>

Why is this needed? I dislike changes that don't fix anything.

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
> 

-- 
Lee Duncan
SUSE Labs
