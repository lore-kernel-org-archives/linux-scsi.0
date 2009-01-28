From: Pete Zaitcev <zaitcev-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 14:10:35 -0700
Message-ID: <20090128141035.3a26ea60.zaitcev@redhat.com>
References: <20090127122641.1564fc46@infradead.org>
	<Pine.LNX.4.44L0.0901271548370.2286-100000@iolanthe.rowland.org>
	<20090127200607.369a1693@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090127200607.369a1693-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zaitcev-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Jan 2009 20:06:07 -0800, Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On a 64bit 2.6.29-rc2 system (and a few earlier kernels that I have
> tried) I can no longer use USB sticks.

So how do you know that you "no longer" can use USB sticks if you
did not find a kernel where it worked? It's either one or the other.

> > >From the middle of the log (after the partition table has been read):
> > 
> > > [   32.056855] usb-storage: queuecommand called
> > > [   32.056886] usb-storage: *** thread awakened.
> > > [   32.056888] usb-storage: Command START_STOP (6 bytes)

Middle huh. I _really_ wish people stopped editing their logs. How
am I supposed to determine if this was sent immediately after open
(e.g. your HAL is screwing with you), or it happened after a time
of inactivity?

In the latter case you might try to comment out
sdev->allow_restart = 1  from scsiglue.c.
It was added there for a specific reason: Seagate FreeAgent.
We can easily make it specific for Seagate, *IF* commenting it helps.

In the former case, well, complain to distro.

> The other one is "why isn't the USB stack filtering that command when
> it comes down from SCSI?"

GOD, NO. We went down that road before.

-- Pete

P.S. If userland were sending these commands, ub would fail too.
So it's not a heaven from this problem.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
