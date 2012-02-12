From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] SCSI: Fix 'Poison overwritten' warning caused by using
 freed 'shost'
Date: Sun, 12 Feb 2012 12:13:46 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202121212500.18114-100000@netrider.rowland.org>
References: <CA+v9cxamcsViUjg2G=vsLCFY3+KVk60TnqhNhJ_yf=ivc9Pxww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+v9cxamcsViUjg2G=vsLCFY3+KVk60TnqhNhJ_yf=ivc9Pxww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Huajun Li <huajun.li.lee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lud <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 12 Feb 2012, Huajun Li wrote:

> In do_scan_async(), calling scsi_autopm_put_host(shost) may reference
> freed shost, and cause Posison overwitten warning.
> Yes, this case can happen, for example, an USB is disconnected just
> when do_scan_async() thread starts to run, then scsi_host_put() called
> in scsi_finish_async_scan() will lead to shost be freed(because the
> refcount of shost->shost_gendev decreases to 1 after USB disconnects),
> at this point, if references shost again, system will show following
> warning msg.
> 
> To make scsi_autopm_put_host(shost) always reference a valid shost,
> put it just before scsi_host_put() in function
> scsi_finish_async_scan().

Good catch!

Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
