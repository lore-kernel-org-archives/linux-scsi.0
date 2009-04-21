From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
Date: Tue, 21 Apr 2009 17:03:09 -0600
Message-ID: <20090421230309.GC1926@parisc-linux.org>
References: <1240347174.10627.20.camel@nimitz> <20090421211858.GA1926@parisc-linux.org> <1240351210.10627.30.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1240351210.10627.30.camel@nimitz>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 21, 2009 at 03:00:10PM -0700, Dave Hansen wrote:
> Here's a patch implementing Al's suggestion.  Not quite as trivial as
> Matthew's, but even nicer aesthetically.  (Description stolen from
> Matthew's patch).  I have verified that this fixes my issue.

I prefer this approach, but I'm equally happy with whichever patch
James chooses.

> Shifting an unsigned char implicitly casts it to a signed int.  This
> caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> which was not supported by at least one drive.  Using the
> get_unaligned_be*() helpers keeps us from having to worry about how the
> extension might occur.
> 
> Signed-off-by: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Reviewed-by: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

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

The smallest of quibbles ... you have an excess space after the = ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
