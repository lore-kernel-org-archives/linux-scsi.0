From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] usb/uas: use scsi_host_find_tag() to find command from a
 tag
Date: Mon, 19 Dec 2011 14:50:50 -0500
Message-ID: <20111219195050.GQ14291@linux.intel.com>
References: <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
 <20111216203146.GN14291@linux.intel.com>
 <20111216204241.GA30915@linutronix.de>
 <20111216213628.GA5509@xanatos>
 <1324072059.10429.27.camel@dabdike>
 <20111219193955.GA2060@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111219193955.GA2060-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 08:39:55PM +0100, Sebastian Andrzej Siewior wrote:
> In "usb/uas: use unique tags for all LUNs" we make sure to create unique
> tags across all LUNs. This patch uses scsi_host_find_tag() to obtain the
> correct command which is associated with the tag.
> The following changes were required:
> - don't use sdev->current_cmnd anymore
>   Since be can have devices which don't support command tagging we must
>   ensure that we can tell the two commands apart. devinfo->cmnd is used
>   for this.

I don't understand.  There's one devinfo per sdev.  How does moving the
untagged command anchor from sdev to devinfo change anything?

It's my understanding that the SCSI core will only send either a single
untagged command, or tagged commands.  ie any outstanding tagged command
will cause an untagged command to be deferred, and an outstanding untagged
command will prevent any other command from being sent to the driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
