From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC] Disable disk spinup during system resume
Date: Fri, 22 Jul 2011 10:05:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107220951280.1923-100000@iolanthe.rowland.org>
References: <4E293D20.3080403@draigBrady.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59242 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754452Ab1GVOFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2011 10:05:16 -0400
In-Reply-To: <4E293D20.3080403@draigBrady.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 22 Jul 2011, P=C3=A1draig Brady wrote:

> On 21/07/11 17:49, Alan Stern wrote:
> > On Thu, 21 Jul 2011, P=C3=A1draig Brady wrote:
> >=20
> >> On 21/07/11 15:49, Alan Stern wrote:
> >>> On Thu, 21 Jul 2011, P=C3=A1draig Brady wrote:
> >>>
> >>>> Hi,
> >>>>
> >>>> I have a secondary sata disk (sda)  in my system that
> >>>> I would like not to spinup on resume.
> >>
> >>
>=20
> > What happens if you kill all the running processes (or as many as=20
> > possible) before starting the suspend?
> >=20
> > Also, how do you initiate the suspend?  Do you use a program, or do=
 you=20
> > simply "echo mem >/sys/power/state"?
>=20
> I just rebooted with init=3D/bin/sh and did
>=20
> sdparm -r -C STOP /dev/sda
> echo 0 > /sys/block/sda/device/scsi_disk/*/manage_start_stop
> echo mem > /sys/power/state
>=20
> When I hit the power button to resume
> sda started spinning again :(

I have no idea why.  Unless maybe the BIOS started the drive.

Here's another test you can try.  Before starting the suspend, make=20
sure no filesystems are mounted on sda and do:

	echo scsi remove-single-device 0 0 0 0 >/proc/scsi/scsi

(replace the "0 0 0 0" with the appropriate Host, Channel, ID, and LUN=20
values for your sda drive).  This will erase all knowledge of that=20
drive from the kernel.  If it still spins up during resume, you can be=20
sure the kernel isn't responsible.

> There kernel logs about sata ports starting up.
> Maybe I need to put the drive into a different
> sleep state or something to stop it starting.

I really don't know what's going on.  Maybe somebody on the linux-scsi
mailing list can explain this.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
