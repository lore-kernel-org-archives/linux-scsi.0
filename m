From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 14:48:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301211448.37377.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301210817.12096.oliver@neukum.name> <3E2D35B7.4070909@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2D35B7.4070909@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Dienstag, 21. Januar 2003 12:57 schrieb Douglas Gilbert:
> Oliver Neukum wrote:
>  > <snip/>
> >
> > I simply don't trust the SCSI layer. I've had to much trouble with it
> > already.
>
> Hopefully we have some better building blocks and
> clearer code in 2.5 to look at this problem in the SCSI
> subsystem again.

I surely hope so. Let's discuss it.

> The first thing a LLDD should do when it _knows_ the device
> is gone is set scsi_device::online=0 ** which should stop all

The SCSI should export functions to do that and to do it to all
a host's devices.

> new commands being queued. Now if scsi_device::access_count
> is zero then we have no problems *** and most of the code
> we need is in place in latter half of scsi_remove_single_device().

Yes. And scsi_device_get() should check for a device having been
unplugged.

> The hard case is when scsi_device::access_count>0 which means
> open()s or mounts are active on that device. So sd, sr, st, osst
> and/or sg know about a file descriptor (or the block equivalent)

What is the block equivalent?

> that is associated with that "departed" scsi_device instance. I
> have code in sg in lk 2.4 to partially handle the case when
> detach is called on a device for which sg holds an open fd.
> Sg can handle this because it shadows scsi_device and
> scsi_cmnd instances. The next time an app tries to access
> that fd it gets a ENODEV (even sends out a SIGIO/POLL_HUP for
> advanced apps). I suspect life would not be so simple for sd
> and sr due to their close binding with the block subsystem.
> Another approach to this problem is to keep the scsi_device
> instances for departed devices around until the access_count
> drops to zero. One silly idea I had was to change the seldom

That looks like a workable approach.

> used channel number to 1024 (or the next free number above that)
> to maintain the uniqueness of the host/channel/id/lun tuple ****
> and keep the original tuple available for the re-appearance
> of the departed device.
>
> Compounding the hard case is when commands are queued. Can
> these simply be ENODEV-ed back to the apps that own them?
> If so, that may help the access_count drop to zero facilitating
> scsi_device removal.

The LLDD can certainly return an error for the commands already queued.

> Question: do we need to worry about hot unplugging of hosts?

Yes, definitely yes. A USB storage device is a virtual host, since
scsi ids would otherwise collide. Besides, PCMCIA SCSI host are
not exactly brandnew either.

> ** Since 'online' already has a usage (i.e. error recovery
> couldn't resurrect this device) perhaps something stronger
> like 'departed' is needed as well (or some sysfs mechanism).
> BTW sg sidesteps 'online' when a file descriptor is opened
> non-blocking.

Good idea.

So a disconnection would look like this:

scsi_set_offline_host(...);
synchronize_kernel();
error_queied_commands(...);
scsi_remove_host();

	Regards
		Oliver


