From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH 1/3] scsi: set to WCE if usb cache quirk is present.
Date: Wed, 6 Jun 2012 11:29:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1206061126280.1788-100000@iolanthe.rowland.org>
References: <1338985224-9684-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338985224-9684-1-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 6 Jun 2012, Namjae Jeon wrote:

> Make use of USB quirk method to identify such HDD while reading the cache status in sd_probe(). If cache quirk is present for the HDD, lets assume that cache is enabled and make WCE bit equal to 1.

Your lines should be wrapped after 72 columns or so.

Calling this a "quirk" sounds strange.  Really, your new flag indicates 
that WCE should default to "on" instead of "off".  How about calling it 
"wce_default_on" instead of "wce_quirk"?

> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -152,6 +152,7 @@ struct scsi_device {
>  	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
>  	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
>  	unsigned is_visible:1;	/* is the device visible in sysfs */
> +	unsigned wce_quirk:1; /* cache read page is not available */

The comment is wrong.  There's no need for a quirk to indicate the
cache page is unavailable; the driver already knows when the page is
unavailable.  Rather, the quirk indicates that WCE should default to
"on".

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
