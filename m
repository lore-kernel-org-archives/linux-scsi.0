From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 20:15:01 +0200
Message-ID: <20110702181501.GN23059@one.firstfloor.org>
References: <1309554818.2722.48.camel@mulgrave> <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org> <20110702060846.GH23059@one.firstfloor.org> <1309609482.2554.8.camel@mulgrave> <20110702170554.GJ23059@one.firstfloor.org> <1309626567.2554.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1309626567.2554.11.camel@mulgrave>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

> And the transition after unplug goes
> 
> 13->12->10->8->7->6->5->3
> 
> implying we're missing put events.

Don't know why. I used this check (with trace_scsi_dev containing the name)
in put_device:

if (trace_scsi && dev->type == &scsi_dev_type &&
     trace_scsi_dev[0] == 0 || !strcmp(dev_name(dev), trace_scsi_dev))) {
	dev_printk ...

If you want instrumentation somewhere else please let me know.

Maybe there simply isn't a put_device to 0 and the NULL pointer happens
for some other reason?

-Andi

-- 
ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
