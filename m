From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open
	file references
Date: Wed, 05 Mar 2008 15:30:18 -0600
Message-ID: <1204752618.3047.77.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803051608140.4161-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0803051608140.4161-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-03-05 at 16:24 -0500, Alan Stern wrote:
> On Wed, 5 Mar 2008, James Bottomley wrote:
> 
> > OK, I looked through the patch series.  It really looks like the
> > in-kernel thing is the wrong approach.
> > 
> > Why not export this want_persist flag via sysfs and then have hal and
> > udev update it when they see a filesystem on an underlying usb device
> > mounted (and zero it out on unmount)?  That way you always have the
> > exactly correct state and there's no need to go fishing for information
> > in layers that are difficult to get to.
> 
> The flag (or rather, a similar one named "persist_enabled") already is
> exported via sysfs.
> 
> Having hal+udev set it automatically as you describe never occurred 
> to me.  The reason for doing all of this within the kernel is that 
> Linus said (off-list) that the kernel should handle this automatically.  
> Whether he considered userspace tools taking over the responsibility, I 
> can't say.  (But he might object to having to wait for the tools to add 
> the extra functionality.)
> 
> Now, it has to be mentioned that mounted filesystems on a USB device
> account for something like 90% of the objections against USB-PERSIST.  
> If we go ahead and enable it automatically in that case, there is
> really very little reason not to enable it for every USB device, 
> mounted or not.
> 
> In fact, the only other important reason for not turning it on by
> default (or always!) is because the USB spec says not to.  By adding
> this check for mounted filesystems, we are trying to adhere as closely
> as possible to the spec -- but only in cases where we don't care since
> it doesn't matter!
> 
> Whether to enable USB-PERSIST for mounted devices is a policy decision.  
> Whether that policy should be set by the kernel or by userspace is
> outside my jursidiction.  If you think this approach is wrong-headed
> and you can convince Linus to go along, I'll be willing to drop the
> last three patches in this series.

So make it default to one now and also put the processes in train to
update hal and udev.  That way everything should work immediately and we
come back to spec compliance later.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
