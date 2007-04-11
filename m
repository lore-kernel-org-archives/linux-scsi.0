From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/5] Do an agent reset on error recovery.
Date: Wed, 11 Apr 2007 20:10:25 +0200
Message-ID: <461D2491.1010806@s5r6.in-berlin.de>
References: <1176243080579-git-send-email-krh@redhat.com>	 <11762430853030-git-send-email-krh@redhat.com>	 <11762430863671-git-send-email-krh@redhat.com>	 <11762430863077-git-send-email-krh@redhat.com>	 <461C1D11.7070003@s5r6.in-berlin.de> <59ad55d30704110949x7bd26dder9e6f999b10354de7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:44065 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbXDKSKw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Apr 2007 14:10:52 -0400
In-Reply-To: <59ad55d30704110949x7bd26dder9e6f999b10354de7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>
Cc: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>, linux1394-devel <linux1394-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Kristian H=C3=B8gsberg wrote:
[hostt->eh_ flavors]
> The reason I made this change was that I was looking at sbp2.c, at th=
e
> way it handles cancellation looks wrong to me.  It implements both
> abort_handler and device_reset, but the only command it sends to the
> device in either case it an agent reset.  As I understand the SCSI
> error handling, the device_reset is only called if abort_handler fail=
s
> to abort the command.  What's an extra agent reset going to do then?
> And the sbp2.c abort_handler always returns SUCCESS, btw.

That's of course bogus, and it is that way because I didn't take the
time yet to clean this up. :-)

> So unless we want to implement "abort task" (finer grained) or target
> reset/write RESET_START to STATE_SET (coarser grained) it doesn't mak=
e
> sense to have more than one error handler callback.

Yes.

> And since we have one SCSI host per fetch agent, it doesn't make much
> of a difference which error handler we implement.

There are differences, if you look at scsi_error.c.  I'm just not sure
at the moment how relevant these differences for sbp2/ fw-sbp2 are.
(See below.)

Besides, one Scsi_Host per LU doesn't have to stay that way.  It's just
another thing which could be cleaned up.

>> The closest concept to "host bus adpaters" in SBP-2 are initiator po=
rts,
>> and there is no notion of resetting an SBP-2 initiator port.
>=20
> Could a fetch agent not be viewed as a host bus adapter?  The way I
> see it is that it has a set of registers that are available to the CP=
U
> through some bus.  In this case the bus is IEEE1394 but it could be
> the PCI bus.

=46orget the "host bus adapters" which are mentioned in Linux SCSI core=
=2E
What are meant there are cards which connect SCSI Parallel Interconnect
with a local bus.  The stuff that Linux SCSI core does with its "host
bus adapters" is stuff for SPI drivers.  It's in the Linux SCSI core no=
t
because it belongs there but because nobody took it out of there.  The
other transport drivers besides SPI drivers take what Linux SCSI core's
low-level API offers them and deal with it one way or another.

The SBP-2 fetch agent is part of the target.  Talking to it by means of
its registers and the initiator's status FIFO is part of an transport
driver on initiator side.  We talk to the fetch agent via the SCSI
interconnect, which is the IEEE 1394 Serial Bus.

The target's fetch agents are _not_ elements between the SCSI
interconnect and a local bus, like "host bus adapters" are.

>> But theoretic semantics aside:  Check drivers/scsi/scsi_error.c for =
what
>> comes after one or another hostt->eh_ handler was called.  Do you wa=
nt
>> the subsequent call to scsi_report_bus_reset()?  Probably not.  But
>> perhaps you want what comes after hostt->eh_device_reset_handler was=
 called.
>=20
> This is the call chain:
>=20
>         if (__scsi_try_to_abort_cmd(scmd) !=3D SUCCESS)
>                 if (scsi_try_bus_device_reset(scmd) !=3D SUCCESS)
>                         if (scsi_try_bus_reset(scmd) !=3D SUCCESS)
>                                scsi_try_host_reset(scmd);

Yes, and these stages do different things.

> We don't support aborting individual commands

Correct.

> or individual LUNs,

No. One scsi_device maps to one SBP-2 Logical Unit (LU).  SBP-2 always
deals only with individual LUs, except that a target's configuration RO=
M
is first examined as a whole to discover LUs.

> and we're not doing a SCSI bus reset...

Correct, because a "SCSI bus reset" is something specific to SCSI
Parallel Interconnect.  The term "SCSI bus reset" implies "SCSI bus" =3D=
=3D
SCSI Parallel Interconnect.

Some other interconnects, for example the Serial Bus, define bus resets
too.  However, such bus resets play entirely different roles for the
different transport protocols.

> I dunno, I think the host reset seems appropriate, but I don't really
> know much about SCSI :)

_device_reset comes close to a fetch agent reset; but as I said I'm not
sure about the rest which happens in scsi_try_bus_device_reset if
hostt->eh_device_reset_handler(scmd) =3D=3D SUCCESS.

The expecting_cc_ua bit becomes effective in scsi_error.c::scsi_check_s=
ense:
http://lxr.free-electrons.com/source/drivers/scsi/scsi_error.c?v=3D2.6.=
20#329
I don't know yet what to make of it.  Perhaps a kind reader at LSML can
give further pointers.

The was_reset bit has ramifications for the st (tape) driver.  That
should be looked into too.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D-- -=3D-=3D=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
