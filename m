From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Fri, 03 Oct 2014 11:25:00 +0200
Message-ID: <542E6B6C.3010806@redhat.com>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com> <1412244280-15111-2-git-send-email-hdegoede@redhat.com> <20141002112627.GC17628@infradead.org> <542D467E.2020400@redhat.com> <20141002130654.GA17051@infradead.org> <542D4E58.5000809@redhat.com> <20141002131259.GA930@infradead.org> <542D5096.9010503@redhat.com> <1412256350.6343.18.camel@jarvis> <20141003084709.GA21274@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141003084709.GA21274-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 10/03/2014 10:47 AM, Christoph Hellwig wrote:
> On Thu, Oct 02, 2014 at 09:25:50AM -0400, James Bottomley wrote:
>> OK, so 3.17 should be on sunday giving three days or so to sort this
>> out.  If you're happy with blk-mq being disabled so the bug never
>> triggers unless the user activates it, doing nothing is my preferred
>> outcome ... but that also means no need to backport to stable.  
>>
>> If you want a it fixed in 3.17, then we need a patch from you now.
>> Ultimately you have to judge the necessity for us, since it's your
>> driver.
> 
> scsi-mq might be new and not default, but I wouldn't really consider it
> "experimental" in the sense that people should expect crashes if they
> attach a usb device.
> 
> Please consider applying the patch below for 3.17, as there is a cxgb
> patch pending anyway:

For the record, and since I said before that I'm fine with leaving this as
is. As Christoph believes it is important to get this fixed for 3.17, lets
try to get this fix in.

So my Acked-by which is included below still stands.

Regards,

Hans



> 
> ---
> From 8a42ea1369701960a821b7fa9a3da5c68e7e4366 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Date: Fri, 3 Oct 2014 10:45:10 +0200
> Subject: uas: disable use of blk-mq I/O path
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> The uas driver uses the block layer tag for USB3 stream IDs.  With
> blk-mq we can get larger tag numbers that the queue depth, which breaks
> this assumption.  A fix is under way for 3.18, but sits on top of
> large changes so can't easily be backported.   Set the disable_blk_mq
> path so that a uas device can't easily crash the system when using
> blk-mq for SCSI.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Acked-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/usb/storage/uas.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 3f42785..9bfa725 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -970,6 +970,13 @@ static struct scsi_host_template uas_host_template = {
>  	.cmd_per_lun = 1,	/* until we override it */
>  	.skip_settle_delay = 1,
>  	.ordered_tag = 1,
> +
> +	/*
> +	 * The uas drivers expects tags not to be bigger than the maximum
> +	 * per-device queue depth, which is not true with the blk-mq tag
> +	 * allocator.
> +	 */
> +	.disable_blk_mq = true,
>  };
>  
>  #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
