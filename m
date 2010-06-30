From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 2/7] BNX2I: Created an active linklist which holds bnx2i
 endpoints
Date: Wed, 30 Jun 2010 00:59:06 -0500
Message-ID: <4C2ADD2A.7030403@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1277516372-469-3-git-send-email-eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRCBuavhBBoEy8gkBA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1277516372-469-3-git-send-email-eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/25/2010 08:39 PM, Eddie Wai wrote:
> +/**
> + * bnx2i_ep_active_list_add - add an entry to ep active list
> + * @hba:	pointer to adapter instance
> + * @ep:		pointer to endpoint (transport indentifier) structure
> + *
> + * current active conn queue manager
> + */
> +static int bnx2i_ep_active_list_add(struct bnx2i_hba *hba,
> +				    struct bnx2i_endpoint *ep)
> +{
> +	write_lock_bh(&hba->ep_rdwr_lock);
> +	list_add_tail(&ep->link,&hba->ep_active_list);
> +	write_unlock_bh(&hba->ep_rdwr_lock);
> +	return 0;
> +}

I do not think you need the return here. It is always zero and no one 
ever checks it.


> +
> +
> +/**
> + * bnx2i_ep_active_list_del - deletes an entry to ep active list
> + * @hba:	pointer to adapter instance
> + * @ep:		pointer to endpoint (transport indentifier) structure
> + *
> + * current active conn queue manager
> + */
> +static int bnx2i_ep_active_list_del(struct bnx2i_hba *hba,
> +				    struct bnx2i_endpoint *ep)
> +{
> +	write_lock_bh(&hba->ep_rdwr_lock);
> +	list_del_init(&ep->link);
> +	write_unlock_bh(&hba->ep_rdwr_lock);
> +	return 0;
> +}

Same as above.

> @@ -1755,6 +1792,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
>   	} else
>   		rc = cnic->cm_connect(bnx2i_ep->cm_sk,&saddr);
>
> +	bnx2i_ep_active_list_add(hba, bnx2i_ep);
> +
>   	if (rc)
>   		goto release_ep;

This is a little strange. It seems cleaner to just do:

         if (bnx2i_map_ep_dbell_regs(bnx2i_ep))
                 goto del_active_ep:

del_active_ep:
	bnx2i_ep_active_list_del(hba, bnx2i_ep);
release_ep:
         if (bnx2i_tear_down_conn(hba, bnx2i_ep)) {
                 mutex_unlock(&hba->net_dev_lock);
                 return ERR_PTR(rc);


>
> @@ -1764,6 +1803,7 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
>   	return ep;
>
>   release_ep:
> +	bnx2i_ep_active_list_del(hba, bnx2i_ep);
>   	if (bnx2i_tear_down_conn(hba, bnx2i_ep)) {
>   		mutex_unlock(&hba->net_dev_lock);
>   		return ERR_PTR(rc);
> @@ -1931,6 +1971,7 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
>   	del_timer_sync(&bnx2i_ep->ofld_timer);
>
>   destroy_conn:
> +	bnx2i_ep_active_list_del(hba, bnx2i_ep);
>   	if (bnx2i_tear_down_conn(hba, bnx2i_ep))
>   		ret = -EINVAL;
>   out:

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
