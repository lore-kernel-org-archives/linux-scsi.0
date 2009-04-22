From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
Date: Wed, 22 Apr 2009 10:32:59 +0300
Message-ID: <49EEC82B.5040603@panasas.com>
References: <1240347174.10627.20.camel@nimitz>	 <20090421211858.GA1926@parisc-linux.org> <1240351210.10627.30.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1240351210.10627.30.camel@nimitz>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/22/2009 01:00 AM, Dave Hansen wrote:
> Here's a patch implementing Al's suggestion.  Not quite as trivial as
> Matthew's, but even nicer aesthetically.  (Description stolen from
> Matthew's patch).  I have verified that this fixes my issue.
> 
> --
> 
> Shifting an unsigned char implicitly casts it to a signed int.  This
> caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> which was not supported by at least one drive.  Using the
> get_unaligned_be*() helpers keeps us from having to worry about how the
> extension might occur.
> 
> Signed-off-by: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3fcb64b..c50142b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -50,6 +50,7 @@
>  #include <linux/string_helpers.h>
>  #include <linux/async.h>
>  #include <asm/uaccess.h>
> +#include <asm/unaligned.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -1344,12 +1345,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> -	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
> -			(buffer[10] << 8) | buffer[11];
> -	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
> -		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
> -		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
> -		((u64)buffer[6] << 8) | (u64)buffer[7]);
> +	sector_size = get_unaligned_be32(&buffer[8]);
> +	lba =  get_unaligned_be64(&buffer[0]);

These are actually aligned access it might be worth sacrificing a cast
to be32/64 for sake of speed.

>  
>  	sd_read_protection_type(sdkp, buffer);
>  
> @@ -1400,10 +1397,8 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> -	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
> -			(buffer[6] << 8) | buffer[7];
> -	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
> -		(buffer[2] << 8) | buffer[3];
> +	sector_size = get_unaligned_be32(&buffer[4]);
> +	lba = get_unaligned_be32(&buffer[0]);
>  

Here too, both are actually aligned.

>  	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
>  		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
> 
> 
> -- Dave
> 

I'm not 100% convinced just a thought.
Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
