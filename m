From: Sergei Shtylyov <sergei.shtylyov-M4DtvfQ/ZS1MRgGoP+s0PdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 10/24] uas: zap_pending: data urbs should have completed
 at this time
Date: Sat, 13 Sep 2014 22:31:50 +0300
Message-ID: <54149BA6.3010305@cogentembedded.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com> <1410604011-3828-11-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410604011-3828-11-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 9/13/2014 1:26 PM, Hans de Goede wrote:

> The data urbs are all killed before calling zap_pending, and their completion
> handler should have cleared their inflight flag.

> Do not 0 the data inflight flags, and add a check for try_complete succeeding,
> as it should always succeed when called from zap_pending.

> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/usb/storage/uas.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 08edb6b..85bbc1d 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -145,6 +145,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
>   	struct uas_cmd_info *cmdinfo;
>   	struct uas_cmd_info *temp;
>   	unsigned long flags;
> +	int err;

    Er, I don't see why this variable is necessary.

[...]
> @@ -152,12 +153,11 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
>   		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
>   						      SCp);
>   		uas_log_cmd_state(cmnd, __func__);
> -		/* all urbs are killed, clear inflight bits */
> -		cmdinfo->state &= ~(COMMAND_INFLIGHT |
> -				    DATA_IN_URB_INFLIGHT |
> -				    DATA_OUT_URB_INFLIGHT);
> +		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
> +		cmdinfo->state &= ~COMMAND_INFLIGHT;
>   		cmnd->result = result << 16;
> -		uas_try_complete(cmnd, __func__);
> +		err = uas_try_complete(cmnd, __func__);
> +		WARN_ON(err != 0);

    Why not:

		WARN_ON(uas_try_complete(cmnd, __func__));

>   	}
>   	spin_unlock_irqrestore(&devinfo->lock, flags);
>   }

WBR, Sergei

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
