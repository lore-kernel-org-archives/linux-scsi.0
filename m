From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 20:24:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E31E730.20903@splentec.com>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030124152540.B27859@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Oliver Neukum <oliver@neukum.name>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Matthew Dharm wrote:
> So, if I read this correctly, you're saying that the correct sequence is:
> 
> (1) get disconnect notification from USB
> (2) Call scsi_set_device_offline() (must hold host lock for this)
> (3) call scsi_done() for all command in queue (max: 1)

Right.  LLDD does (2) and (3), though, *and let's decide on this scsi ppl*
I'd rather (3) be initiated by SCSI Core, e.g. in recovery code.

> (4) Call scsi_remove_host(), which should now work because no commands are
> outstanding
> (5) Call scsi_unregister()

This is tricky.  I'd rather SCSI Core do those things.  I.e. when there
are no devices left, then SCSI Core could probably initiate the removal
of the host, just as it does for devices with slave_alloc().  Please
ppl, read Doug's original email *carefullly*, especially those who are
implementing this now (Mike?).

(You may decide to go over your queue and error them out, but the
error recovery thread should call your eh_abort() method -- this
is a more consistent way of doing this and you'd have *less*
code duplication in LLDD.)

The whole point is that when shared data is involved, i.e. hosts,
commands, devices, LLDD can tell SCSI Core what it (LLDD) wants
to be done eventually, (by, say telling scsi core about the unplug
event by calling scsi_set_device_offline()), and then when SCSI Core
decides that it is safe to do so, it will *remove* the device(s)
and/(or) host(s), the former by calling slave_destroy(), and the
latter by the release() method.

Please note, that a LLDD cannot ``run'' SCSI Core, and this is what
you've been inclined to do in all your emails.

For this I'm inclined to include in SHT/host, a host_volatile:1 flag
to mean whether the host is to be removed when there's no devices;
1 to mean that it is to be removed when # dev = 0, 0 to mean that
the host stays.

Some hosts may decide to stay even if there's no devices attached,
e.g. FC/SAN hosts. (since a device may come up any moment now, or
that the host has been authenticated and connected to a target
whos luns got pulled out at this moment in time -- and there's no
point in removing the host and then initiating a whole new
session/authenication/etc.)

USB Storage hosts will have .host_volatile = 1.
 
> And we're done, all structures can be freed.

SCSI Core will tell you when you're done, when your
release() method is called -- when SCSI Core decides
to do it.

>  And, as I understand it, the
> following is true:
> 
> (a) once (2) is done, no more commands will be queued

Ok, SCSI Core can take care of this.

> (b) once (3) is done, (4) is guaranteed to work

You shouldn't care of this -- your driver methods will get called.
You shouldn't know about how the layer above you implements it -- this
is the whole point of separating SCSI Core and LLDD as different
subsystems.

> (c) there is nothing the user can do to make this sequence take a long time

Right.
 
> Tho, this does leave me with a couple of questions:
> 
> (i) Doesn't scsi_set_device_offline() work on devices, not hosts?  How do I
> map from my host to my device list?

Doug answered this -- but it's even easier when you have one device per host.

> (ii) Do I need to call scsi_set_device_offline() for each device?  I
> presume 'yes'.

Mostly it would depend on USB.  Is it a normal host with several real
devices and just one of them is going away?  Or is it a bridge itself
which is going away and you must force unplug all device? I can imagine
this either way, though my knowledge of USB is limited. :-)

SCSI ppl: the transport may not be USB so let's not generalize if new
code is going into SCSI Core.


> (iii) What should I shove into the status field of the scsi command before
> I scsi_done() it?

DID_ERROR or DID_BAD_TARGET, since the device is gone.
 
> Oh, and as for my being a 'prick'.... my big problem is that the documented
> interface is synchronous.  Async is fine with me, but up until this e-mail,
> all I've seen is people arguing over what the sequence is, and theoretical
> issues of what users should and should not do.

Most of the things said were of interest and concern to SCSI ppl too.

>  And I also think that a
> large number of hotplugable hosts are going to replicate a whole bunch of
> code to do (2)+(3)+(4) in one, synchronous burst.

No, not quite -- those will be called by SCSI Core, depending on the
host.  Things may work differently for a host connected to a SAN, don't
you think?

For this reason we cannot lump up (2), (3) and (4).  They'll be separated
and SCSI Core will drive things up.

-- 
Luben





