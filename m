From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][PATCH] fix sign extension with 1.5TB usb-storage LBD=y
Date: Tue, 21 Apr 2009 15:49:10 -0700
Message-ID: <1240354150.10627.36.camel@nimitz>
References: <1240347174.10627.20.camel@nimitz>
	 <20090421211858.GA1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090421211858.GA1926-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-04-21 at 15:18 -0600, Matthew Wilcox wrote:
> 
> this certainly fixes your problem.  I'd prefer this patch instead, just
> because I find the cast unaesthetic ...
> 
> ----
> 
> Fix READ CAPACITY 10 with drives over 1TB
> 
> Shifting an unsigned char implicitly casts it to a signed int.  This
> caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> which was not supported by at least one drive.  Making 'lba' an
> unsigned
> int ensures that sign extension will not occur.
> 
> Signed-off-by: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3fcb64b..c856b1b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1373,7 +1373,7 @@ static int read_capacity_10(struct scsi_disk
> *sdkp, struct scsi_device *sdp,
>         int sense_valid = 0;
>         int the_result;
>         int retries = 3;
> -       sector_t lba;
> +       unsigned lba;
>         unsigned sector_size;
> 
>         do {
> @@ -1413,7 +1413,7 @@ static int read_capacity_10(struct scsi_disk
> *sdkp, struct scsi_device *sdp,
>                 return -EOVERFLOW;
>         }
> 
> -       sdkp->capacity = lba + 1;
> +       sdkp->capacity = (sector_t)lba + 1;
>         return sector_size;
>  }

That's fine with me too.  This patch fixes my issue as well.

Signed-off-by: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
