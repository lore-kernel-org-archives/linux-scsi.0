From: Anoob Soman <anoob.soman-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 1/1] libiscsi: Fix race between iscsi_xmit_task and
 iscsi_complete_task
Date: Mon, 9 Jul 2018 11:43:14 +0100
Message-ID: <5cc14ea6-2586-ce2b-f8c4-c46222280df7@citrix.com>
References: <1530543624-130587-1-git-send-email-anoob.soman@citrix.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Return-path: <open-iscsi+bncBCLIFEWU6YHBBR7YRTNAKGQES6WBLIA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1530543624-130587-1-git-send-email-anoob.soman-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 02/07/18 16:00, Anoob Soman wrote:
> ---
>   drivers/scsi/libiscsi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index d609383..aa3be6f 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1449,7 +1449,13 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
>   	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx))
>   		return -ENODATA;
>   
> +	spin_lock_bh(&conn->session->back_lock);
> +	if (conn->task == NULL) {
> +		spin_unlock_bh(&conn->session->back_lock);
> +		return -ENODATA;
> +	}
>   	__iscsi_get_task(task);
> +	spin_unlock_bh(&conn->session->back_lock);
>   	spin_unlock_bh(&conn->session->frwd_lock);
>   	rc = conn->session->tt->xmit_task(task);
>   	spin_lock_bh(&conn->session->frwd_lock);


Hi Chris, Lee.

Could one of you look at this change and provide some comments ?

Thanks,

-Anoob.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
