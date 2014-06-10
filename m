From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/1] iscsi: kill redundant casts
Date: Tue, 10 Jun 2014 01:48:11 -0500
Message-ID: <5396AA2B.1040502@cs.wisc.edu>
References: <1402343822-27701-1-git-send-email-nlb@google.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBMWU3KOAKGQEFNXTKFQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1402343822-27701-1-git-send-email-nlb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Nick Black <nlb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Switching linux-kernel for linux-scsi mailing list.

On 6/9/14, 2:57 PM, 'Nick Black' via open-iscsi wrote:
> Remove two redundant casts from char * to char *.
>
> Signed-off-by: Nick Black <nlb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 0102a2d..38a1de3 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -3059,7 +3059,7 @@ iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
>   		evchap->u.get_chap.host_no = ev->u.get_chap.host_no;
>   		evchap->u.get_chap.chap_tbl_idx = ev->u.get_chap.chap_tbl_idx;
>   		evchap->u.get_chap.num_entries = ev->u.get_chap.num_entries;
> -		buf = (char *) ((char *)evchap + sizeof(*evchap));
> +		buf = (char *)evchap + sizeof(*evchap);
>   		memset(buf, 0, chap_buf_size);
>
>   		err = transport->get_chap(shost, ev->u.get_chap.chap_tbl_idx,
> @@ -3463,7 +3463,7 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
>   		evhost_stats->type = nlh->nlmsg_type;
>   		evhost_stats->u.get_host_stats.host_no =
>   					ev->u.get_host_stats.host_no;
> -		buf = (char *)((char *)evhost_stats + sizeof(*evhost_stats));
> +		buf = (char *)evhost_stats + sizeof(*evhost_stats);
>   		memset(buf, 0, host_stats_size);
>
>   		err = transport->get_host_stats(shost, buf, host_stats_size);
>


Looks ok to me.

Acked-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
