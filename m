From: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH resend 1/4] scsi/sr: add no_read_disc_info scsi_device
 flag
Date: Wed, 28 Jul 2010 08:19:55 -0500
Message-ID: <1280323195.30808.58.camel@mulgrave.site>
References: <1279875174-2905-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279875174-2905-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-07-23 at 10:52 +0200, Hans de Goede wrote:
> Some USB devices emulate a usb-mass-storage attached (scsi) cdrom device,
> usually this fake cdrom contains the windows software for the device.
> While working on supporting Appotech ax3003 based photoframes, which do
> this I discovered that they will go of into lala land when ever they
> see a READ_DISC_INFO scsi command.
> 
> Thus this patch adds a scsi_device flag (which can then be set by the
> usb-storage driver through an unsual-devs entry), to indicate this, and
> makes the sr driver honor this flag.
> 
> I know this sucks, but as discussed on linux-scsi list there is no other
> way to make this device work properly.
> 
> Looking at usb traces made under windows, windows never sends a
> READ_DISC_INFO during normal interactions with a usb cdrom device. So as
> this cdrom emulation thingie becomes more common we might see more of
> this problem.

So, I suppose we can do this.  I dislike threading device bugs like this
up and down the stack.  The usb stor_control_thread already does some
command filtering; if it just rejected this command and READ
CAPACITY(16) on the flags, I think it would be far less code and the
SCSI subsystem would just do the right thing.

I'd actually like to hear from USB what they'd prefer to do.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
