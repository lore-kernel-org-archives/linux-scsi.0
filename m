From: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Tue, 07 Dec 2010 23:05:42 -0600
Message-ID: <1291784742.24312.40.camel@mulgrave.site>
References: <732182.60247.qm@web31816.mail.mud.yahoo.com>
	 <20101208001202.GA26530@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101208001202.GA26530-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-12-07 at 16:12 -0800, Greg KH wrote:
> On Tue, Dec 07, 2010 at 04:02:26PM -0800, Luben Tuikov wrote:
> > --- On Sun, 12/5/10, Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> > > --- On Wed, 11/24/10, Luben Tuikov
> > > <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > > wrote:
> > > > 
> > > > CBI/BBB isn't supposed to be, nor is designed to
> > > support
> > > > SAM-modern devices. So while REQUEST LUN /may/ work on
> > > some
> > > > devices which implement it in their firmware, it is
> > > NOT a
> > > > requirement for those devices as they are not required
> > > to
> > > > adhere to any SAM version. Those transport protocols
> > > define
> > > > a class-specific request to get the maximum LUN, and
> > > another
> > > > to reset the target port (instead of I_T Reset or LU
> > > Reset).
> > > > They also do not support SCSI Status completion of
> > > the
> > > > command, nor Autosense. They also do not provide TMFs.
> > > They
> > > > provide none of the SCSI transport protocol services
> > > in
> > > > support of the Execute Command procedure call. The
> > > SCSI
> > > > layer shouldn't be trying to guess their "SCSI
> > > version", and
> > > > or treat them as real SCSI devices sending REPORT
> > > LUNs, etc.
> > > > commands.
> > > > 
> > > > Newer, modern transport protocols over USB, are part
> > > of
> > > > SAM, and it is devices who connect via those protocols
> > > that
> > > > are being disadvantaged, due to the adoption
> > > (assumption) of
> > > > CBI/BBB well into the SCSI layer.
> > > > 
> > > > To this effect, the transport protocol can tell upper
> > > > layers if the device is true SCSI (new usb transports
> > > or
> > > > other) or hybrid (usb-storage). In the former case,
> > > the
> > > > device is a SCSI device, in the latter, only basic
> > > commands
> > > > should be attempted.
> > > > 
> > > > This isn't to say that firmware for those devices
> > > wouldn't
> > > > be buggy. Of course it will, and most will probably
> > > port
> > > > their legacy FW over to the new SPTL, but the
> > > protocol
> > > > requirements are there by design (i.e. there is no
> > > longer
> > > > Get Max Lun class-specific request, the application
> > > client
> > > > has to send REPORT LUNS, and FW has to answer it) and
> > > we
> > > > have to accommodate that.
> > > > 
> > > > It is in this spirit that this patch doesn't change
> > > wire
> > > > behavior, but simply parses data returned by a
> > > command
> > > > already supported by older protocols.
> > > 
> > > Did anyone pick up this patch?
> > 
> > It's been over 6 weeks now that this patch's been in these mailing lists.
> > Will anyone pick up this patch, or should I stop posting it every
> > week? Please let me know--it's been posted here 6 times in the last 6
> > weeks.
> 
> James, this is all you.  Any thoughts?

Well, not other than I've already said:  I think it looks OK, so I
marked it for my merge window queue.  I'd still rather like USB people
to confirm that the original reason why this was done (to prevent device
crashes on the mode sense) is no longer an issue ... but it's only USB
stuff, so suppose I'm OK with finding out in the field.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
