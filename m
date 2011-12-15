From: Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] usb/uas: fix support on HS (device without command
 tagging)
Date: Thu, 15 Dec 2011 15:14:18 +0400
Message-ID: <4EE9D68A.4010001@mvista.com>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de> <1323888472-21035-2-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323888472-21035-2-git-send-email-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 14-12-2011 22:47, Sebastian Andrzej Siewior wrote:

> Right now UAS can not handle HS devices. This patch tries to fix this.
> On SS and HS we take the command tag increment it by one and assign it
> as the stream_id. This number is used to compare the tag number.
> This tag number is later used to find the matching command struct. On SS
> we could use urb->stream_id but this way the code flow is the same.
> Untagged commands are stashed in ->current_cmd. Once such a command is
> in process no other commands are allowed.
> What I observed so far is that the first command (INQUIRY) checked if
> command tagging is supporteed by the device or not. If so, all further
> commands are tagged, if not none are. So the assumption here is if
> ->current_cmd is available then take it else go by tag the number.
> Things will break apart if the initiator mixes tagged&  untagged
> commands.

> With this patch things work for me on HS-UASP without command tagging.

> Signed-off-by: Sebastian Andrzej Siewior<bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> ---
>   drivers/usb/storage/uas.c |   21 +++++++++++----------
>   1 files changed, 11 insertions(+), 10 deletions(-)

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 680bea9..97f969c 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -232,13 +232,16 @@ static void uas_stat_cmplt(struct urb *urb)
>   		return;
>   	}
>
> -	tag = be16_to_cpup(&iu->tag) - 1;
> -	if (sdev->current_cmnd)
> -		cmnd = sdev->current_cmnd;
> -	else
> -		cmnd = scsi_find_tag(sdev, tag);
> -	if (!cmnd)
> +	cmnd = sdev->current_cmnd;
> +	if (!cmnd) {
> +		tag = be16_to_cpup(&iu->tag);

    Why not just 'be16_to_cpu(iu->tag)'? Ah, that's how it was before...

WBR, Sergei
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
