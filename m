From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Mon, 17 Feb 2003 16:12:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E515035.2080207@splentec.com>
References: <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com> <20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com> <20030213192440.A6660@redhat.com> <20030214165827.GA1165@beaverton.ibm.com> <3E4D44EB.1090402@splentec.com> <1045257640.1726.23.camel@mulgrave> <3E5119EC.7080907@splentec.com> <20030217151729.A21987@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Doug Ledford wrote:
> 
> It is the right behaviour for that controller, no more.  The right
> behaviour is determined by the controller in question, not philosophical
> beliefs.  In the case of the 2742T controllers there are two busses on one
> scsi chip, you have to flip a bit in the chip to switch control regs
> between busses, the chip has a maximum number of commands it can handle
> and those are shared between the two busses, etc.  Representing that as
> one host is the right thing to do because that's how all the resource
> limits, etc. have to be calculated.

Yes, it is the right thing to do (represent it as a host).  But here
``host'' is a software abstraction and somewhere else
it is a host adapter/controller, in effect ``host'' meaning a physical
device.

``Portal'' is what is used in current service delivery transport standards
since it provides a ``portal'' to the interconnect.

>>IOW, it already is hinting that those are ``portals''.  There is no
>>such thing as a ``host'' in SCSI-3.  ``host'' is an SPI term, and is gone
>>from SAM and SPC (which is what scsi-core should represent).
> 
> 
> I disagree with that last statement strongly!  I've mentioned this in
> private email before.  The scsi core should represent reality, not any

I never got it.

Just to show the ambiguity which might arise:
SOT---------------------------------------------
> version of any spec!  It should *implement* the scsi protocol, but it need
> not and should not try to emulate any specific version of the scsi spec in

This meaning that it should *not* stick to SPI?

> design and it needs to and should try to represent the reality of the
> hardware you are working with.  And reality is that no matter what

And this meaning it should stick to SPI, just because SPI HBAs are most
abundant?

> interconnect we are using there is a host in that chain and that host is
> some piece of hardware that handles our interconnect.

Here ``host'' means the physical entity.

>  Hosts have their
> own set of resource requirements, concurrency issues, limitations, etc.  

Here ``host'' means a software abstraction, as is the case for my Adaptec
card exporting two ``hosts'' with their limitaions, etc, but being one
physical host adaptor.
EOT----------------------------------------------

> 
>>Not anymore, you don't.
>>
>>You queue at LU level, and control parameters
>>	- at LU level, for the device server itself (i.e. the thingy
>>which executes scsi commands),
>>	- at Target level, (for target specific parameters),
>>	- at Portal level, for the service delivery subsystem (i.e.
>>controls specific for SPI, FC, etc.).
> 
> 
> Really, in the above list, just replace portal with host and you have what 
> we are doing today.  By creating a separate struct target and putting the 
> target specific params into it you aren't changing *what* we are doing, 
> just *how* we are doing it (which I have no objection to).

Well, I'm certainly glad to hear that.

What would change is the scsi core _representation_ of what is
out there.

A target is addressible, has a name and a few other things. A LU
has no name and is addressible only within a target.

And by having a better representation we get more versatile manipulation
of the devices which are out there.

>  By changing 
> the name of host to portal, well, your just changing the name to match 
> some document but without any real purpose.

Well, we call it ``host'' now just because that is what SPI/SCSI-2 calls it.
I.e. the naming is legacy.

But, really, from a scsi core point of view it is a ``portal''.  It is a ``host''
only from LLDDs point of vew.

I.e. scsi core doesn't really know about it being an SPI or FC or iSCSI.

What I'm trying to achieve here is better representation (in scsi core)
of the way SCSI-3 is forming up to become and the things which are to come.
How far away are we from a target whose LUs are all CPUs?

> However, what I would like to see is a service delivery subsystem specific 
> set of routines in the scsi core.  For example, the new scsi eh code is 
> mostly wasted on pretty much all the intelligent RAID controllers that act 
> like scsi controllers (megaraid, serveraid, etc.) and a *much* simpler 
> error recovery setup could be used on those controllers.  On the other 
> hand, iscsi and fc both need a bit more in the way of error recovery 
> intelligence than spi does.

Right.  iSCSI closely sticks to SAM-2 and the Task Management Functions
(TMF) therein.

> So I could see using 3 different error 
> recovery strategies depending on the interconnect type (I'm not sure where 

This may be the case, but the interface could be the same as far as TMFs
are concerned.  I.e. they would all have to offer it ``by law''.

> usb and ieee1394 would fit in here) and also due to interconnect 
> differences I could see each of these same 3 groups of interconnects 
> needing different default disk timeout parameters.  These different 

I've said this before: portals/targets should suggest timeout values to
scsi core on per LU basis.

> interconnects also offer totally different device scan capabilities.  SPI 
> needs a manual "are you there?" scan, most fc/usb/ieee1394/intelligent 
> raid controllers can all tell the scsi layer "here are my devices, set 
> them up" and avoid manual scanning.

Right.  The portal will tell scsi core about its targets as is the case
with iSCSI and most newer protocols, but this is controllable by
the user directly.  I.e. a user process may ``initiate'' target
discovery of the LLDD.

> So, based upon interconnect in use 
> and driver capabilities, I'd like to see the ability to select the right 
> settings for a controller at controller init time.

This is nice, but not with the current infrastructre of scsi core.

In order to get this ``unity'' in selecting the right settings
for a portal, we need to have some ``unity'' in the structures
which represent them.

Something like this maybe:

struct scsi_portal {
	...
	int ic_type;
	union scsi_interconnect {
		struct SPI spi;
		struct FC  fc;
		struct iSCSI is;
		struct SAS sas;
		...
	} ic;
	...
};

(Does this remind one of a certain other subsystem?)

>  To that extent, the 
> "portal" abstraction has a use, but I still don't like the name.  No one 
> goes out and buys a fiber channel portal, they go buy a fiber channel host 
> adapter board or controller.

Right, they do.  And when they plug it in they get a representation not
of the single ``fiber channel host adapter board or controller'' which they
bought but maybe of two ``hosts''.

Regarding the choice of the word ``portal'', this is what SCSI-3 uses in
its literature.

-- 
Luben


