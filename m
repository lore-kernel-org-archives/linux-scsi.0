From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDDreentrancy
Date: Tue, 27 Aug 2002 09:52:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF3E535470.2D9A9A9D-ONC1256C22.002A3928@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


> Aron Zeh wrote:
> >
> > I currently don't know of a way that SCSI devices (LUNs) generate
hotplug
> > notifications by. (FC sends RSCNs and other nasty stuff for ports,
which
> > are one level higher up. I don't think reconfiguring the LUNs behind a
port
> > would generate any message, would it?)
>
> Unit Attention condition should be generated.
>
> Some (all?) transports allow for the target sending an asynchronous
> message to the initiator, but in SAM-3, an initiator being
> a real such and a target being a real target, the target is the passive
> device and the initiator is the active one, thus Unit Attention
> condition is generated (SAM-3, 5.8.5).
>
That's exactly where my question comes in. How do we see that an
asynchronous
reconfiguration on unit level has taken place? Unit Attentions are only
reported
in piggy-back fashion on top of a command per the standard you quoted (if I
did not misread it).
If a unit was just added to the configuration (and holds "unit was just
powered on" attention)
then I cannot see how Linux could find out.

> > Even of messages are generated, they'd probably differ according to the
> > underlying hardware. Would HBA drivers have to catch them and use more
> > generic callbacks to tell the SCSI stack?
>
> Forget about HBAs. In order to get anything working it has to be
> at SAM-3 level.
>
> It's ok when we plug into the PCI bus, but what happens
> when SAN box number XXXX comes up and you're connected to
> the farm over with iSCSI. How are you to know?...
>
> That is, we cannot assume that it's an HBA there anymore,
> just as we stopped assuming that the HBA is SPI, some time ago.
> (It could be FCP, iSCSI, etc.)

So you're ruling out the use of transport specific hotplug notifications
like RSCN on FC?
I currently cannot quite see how this would work. Isn't there always the
need to interpret reconfigurations of the hardware used to transport SAM-3
data on a lower level? Or has SAM-3 some capabilites for doing just that
that I have missed?

Aron

> --
> Luben
> -

