From: Sergei Shtylyov <sergei.shtylyov-M4DtvfQ/ZS1MRgGoP+s0PdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] uas: Limit qdepth at the scsi-host level
Date: Sat, 19 Mar 2016 18:52:40 +0300
Message-ID: <56ED75C8.8000005@cogentembedded.com>
References: <1458377952-12567-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458377952-12567-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 3/19/2016 11:59 AM, Hans de Goede wrote:

> Commit 64d513ac31bd ("scsi: use host wide tags by default") causes
> the scsi-core to queue more cmnds then we can handle on devices with

    SCSI core? Commands?

> multiple LUNs, limit the qdepth at the scsi-host level instead of

    Queue depth?

> per slave to fix this.
>
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1315013
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 4.4.x and 4.5.x
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/usb/storage/uas.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index c90a7e4..b5cb7ab 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
[...]
> @@ -932,6 +931,12 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
>   	if (result)
>   		goto set_alt0;
>
> +	/*
> +	 * 1 tag is reserved for untagged commands +
> +	 * 1 tag to avoid of by one errors in some bridge firmwares

    Off by one.

[...]

MBR, Sergei

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
