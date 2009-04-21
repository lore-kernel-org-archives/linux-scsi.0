From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC][PATCH] fix sign extension with 1.5TB usb-storage LBD=y
Date: Tue, 21 Apr 2009 22:01:45 +0100
Message-ID: <20090421210145.GF8633@ZenIV.linux.org.uk>
References: <1240347174.10627.20.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1240347174.10627.20.camel@nimitz>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 21, 2009 at 01:52:54PM -0700, Dave Hansen wrote:
> This is with current git as of this morning, which is at v2.6.30-rc2.
> 
> I have a 1.5TB USB device which gets a bit angry when I plug it in.  It
> ends up with a scsi_disk->capacity of ffffffffaea87b30.  I tracked it
> down to the lba calculation in read_capacity_10():
> 
> 	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
>  		(buffer[2] << 8) | buffer[3];
> 
> lba is getting all 0xf's in its high 32 bits.  It seems odd that this
> would happen since 'buffer' is an 'unsigned char', but that is
> apparently what is going on.

Nothing odd here; you get unsigned char promoted to int (since the entire
range fits into the range of int), then calculations are carried within
int and in the end you have (overflown into negative) int sign-extended
into u64.

Solution is correct, but perhaps use of get_unaligned_be32(buffer) would be
better.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
