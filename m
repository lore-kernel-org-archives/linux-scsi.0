From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/5] Do an agent reset on error recovery.
Date: Wed, 11 Apr 2007 22:31:50 +0200
Message-ID: <461D45B6.60807@s5r6.in-berlin.de>
References: <1176243080579-git-send-email-krh@redhat.com>	
	<11762430853030-git-send-email-krh@redhat.com>	
	<11762430863671-git-send-email-krh@redhat.com>	
	<11762430863077-git-send-email-krh@redhat.com>	
	<461C1D11.7070003@s5r6.in-berlin.de>	
	<59ad55d30704110949x7bd26dder9e6f999b10354de7@mail.gmail.com>	
	<461D2491.1010806@s5r6.in-berlin.de>
	<59ad55d30704111145p472282ew612646dcb6927c13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <59ad55d30704111145p472282ew612646dcb6927c13@mail.gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Cc: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Kristian H=F8gsberg wrote:
> On 4/11/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Forget the "host bus adapters" which are mentioned in Linux SCSI core.
>> What are meant there are cards which connect SCSI Parallel Interconnect
>> with a local bus.
> =

> Or maybe more generally bridge chipsets that connect SCSI Parallel
> interconnect with a non-SCSI, but not necessarily local, bus (PCI or
> IEEE1394)?

No. Those "host bus adapters" are "initiator-internal bus to SPI adapter
cards".  They have little to nothing to do with the various non-SPI
incarnations of the SCSI Architecture Model.

>> The target's fetch agents are _not_ elements between the SCSI
>> interconnect and a local bus, like "host bus adapters" are.
> =

> Why not though?  I mean, IEEE1394 isn't a local bus, but other than
> that the architechture looks a lot like the PCI adaptor case.

The SBP-2 fetch agent is an target-side element at the transport level.
 It is neither part of the initiator, nor does it implement
functionality at the interconnect level.

>> One scsi_device maps to one SBP-2 Logical Unit (LU).  SBP-2 always
>> deals only with individual LUs, except that a target's configuration ROM
>> is first examined as a whole to discover LUs.
> =

> Yeah, and that's broken.  sbp2.c adds two scsi_hosts for each lun
> found but they both try to access the same fetch agent registers.
> There's no way that can work.

I don't follow you.
  - It's correct to instantiate one scsi_device for each SCSI Logical
    Unit.
  - sbp2 instantiates one Scsi_Host for each scsi_device.  That's
    awkward but not incorrect.  (The target dosn't know, initiator-side
    side command set layer doesn't care, and initiator-side application
    clients have to put up with it.  For the latter, it would be nice if
    Scsi_Host had a well-defined meaning for all transports, e.g. the
    meaning of a SCSI Initiator Port.  But it doesn't.)
  - sbp2 logs in to each SCSI Logical Unit separately, and talks to the
    command block agent CSRs it is pointed to by the respective login
    responses.  (By necessity, each LU has a separate area of command
    block agent registers.)
What's wrong with that?

I have a dual LU SBP-2 to IDE bridge which is fully supported by sbp2. I
haven't checked though if it poses as a node with one SCSI target with
two LUs, or as a node with two SCSI targets with one LU each.  It does
contain only a single 1394 link and IDE controller though.

(BTW, I'm saying LU all the time because LUN means Logical Unit Number
and is merely something used to identify a LU.)

> In fw-sbp2.c I just don't support that
> yet (I have no devices that have that configuration), but I want to
> add both LUNs to the same scsi_host, because that's the only thing
> that can work.

No, it's doesn't make a difference if LUs of the same target hang on
different instances of Scsi_Host, except that application clients can't
figure out in a transport-agnostic way that the LUs belong to the same
target.  But to correct that, (1.) all LUs of the same target have to be
added to the same scsi_target or whatever Linux SCSI core artifact is
meant to represent a target, or/and (2.) SAM compliant target
identifiers etc. had to be supported by the Linux SCSI core.

> SBP-2 (the protocol) has a task management request for resetting a LUN
> which could be used for device_reset in this situation.

Yes; we should look into whether that's useful together with more than
one implemented level of .eh callbacks.  What we have so far only issues
ABORT TASK SET; what we could add is LOGICAL UNIT RESET (but SBP-2
targets are not required to support that) and TARGET RESET (which would
be the bigger hammer onto all LUs of a target).  The Linux SCSI core
however doesn't support the notion of task management functions; it's up
to implementers of transport layer drivers to figure out which TMF to do
when.

LOGICAL UNIT RESET does not look appropriate for
scsi_try_bus_device_reset though, because LOGICAL UNIT RESET will not
cause a unit attention condition for the initiator who requested the reset.

...
>> _device_reset comes close to a fetch agent reset;

Or rather not, because expecting_cc_ua should apparently be left off
after a fetch agent reset.

>> but as I said I'm not
>> sure about the rest which happens in scsi_try_bus_device_reset if
>> hostt->eh_device_reset_handler(scmd) =3D=3D SUCCESS.

(I meant I'm not sure about what scsi_error.c does, and I still am not
sure. :-)

> Well, fetch agent resets all the LUNs controlled by the fetch agents,
> and thus has a broader scope than just device_reset.

That would be true for a TARGET RESET, but not for any of the other
TMFs.  Particularly, fetch agent reset affects the state of only one LU;
the one to which the command block agent registers belong to.
-- =

Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D-- -=3D-=3D=3D
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=3Djoin.php&p=3Dsourceforge&CID=3DDE=
VDEV
