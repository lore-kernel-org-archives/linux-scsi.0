From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 22:57:43 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2D35B7.4070909@torque.net>
References: <10426732153816@kroah.com> <200301201923.50467.oliver@neukum.name> <1043119913.13397.14.camel@dhcp22.swansea.linux.org.uk> <200301210817.12096.oliver@neukum.name>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
 > <snip/>
 >
> I simply don't trust the SCSI layer. I've had to much trouble with it
> already.

Hopefully we have some better building blocks and
clearer code in 2.5 to look at this problem in the SCSI
subsystem again.

The first thing a LLDD should do when it _knows_ the device
is gone is set scsi_device::online=0 ** which should stop all
new commands being queued. Now if scsi_device::access_count
is zero then we have no problems *** and most of the code
we need is in place in latter half of scsi_remove_single_device().

The hard case is when scsi_device::access_count>0 which means
open()s or mounts are active on that device. So sd, sr, st, osst
and/or sg know about a file descriptor (or the block equivalent)
that is associated with that "departed" scsi_device instance. I
have code in sg in lk 2.4 to partially handle the case when
detach is called on a device for which sg holds an open fd.
Sg can handle this because it shadows scsi_device and
scsi_cmnd instances. The next time an app tries to access
that fd it gets a ENODEV (even sends out a SIGIO/POLL_HUP for
advanced apps). I suspect life would not be so simple for sd
and sr due to their close binding with the block subsystem.
Another approach to this problem is to keep the scsi_device
instances for departed devices around until the access_count
drops to zero. One silly idea I had was to change the seldom
used channel number to 1024 (or the next free number above that)
to maintain the uniqueness of the host/channel/id/lun tuple ****
and keep the original tuple available for the re-appearance
of the departed device.

Compounding the hard case is when commands are queued. Can
these simply be ENODEV-ed back to the apps that own them?
If so, that may help the access_count drop to zero facilitating
scsi_device removal.


Question: do we need to worry about hot unplugging of hosts?


** Since 'online' already has a usage (i.e. error recovery
couldn't resurrect this device) perhaps something stronger
like 'departed' is needed as well (or some sysfs mechanism).
BTW sg sidesteps 'online' when a file descriptor is opened
non-blocking.

*** As Oliver has pointed out to me before, there are still
opportunities for races when access_count is zero and an
open()/mount is about to happen.

**** We need a new, enhanced version of the
SCSI_IOCTL_GET_IDLUN ioctl which as it stands can only
convey 8 bit quantities for host, channel, target and lun;
especially if we go to 64 bit luns.



... just some random thoughts ... fire away

Doug Gilbert




