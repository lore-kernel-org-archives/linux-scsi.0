From: James.Smart@Emulex.Com
Subject: RE: Adaptec SAS integration notes
Date: Sat, 15 Oct 2005 10:21:31 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7AED@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
content-class: urn:content-classes:message
Sender: linux-ide-owner@vger.kernel.org
To: ltuikov@yahoo.com, jgarzik@pobox.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, luben_tuikov@adaptec.com, James.Bottomley@steeleye.com, hch@infradead.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Luben,

> > * Adaptec SAS abuses Scsi_Host_Template.  The host template 
> is a set of
> > ops for various layers, and it is fine as an interface.  No need to
> > avoid it.
> 
> Neither the Host Adapter, nor the FW, implements anything which has
> to do with the scsi host template.  What the Host Adapter 
> (the hardware) and
> the FW implement is access to the transport -- that' all.
> 
> So in effect the LLDD is _access to the (SAS) transport_. Cf. 
> the USB Storage
> code and SBP code.
> 
> Putting the host template back into the LLDD is a step 
> _backwards_, i.e.
> it's just a workaround, not a step forward.

This statement absolutely amazes me....

Your first comment "Host Adapter, nor the FW ..." is true of every
adapter.

The job of a Device Driver is to map between the interface presented
by the Host Adapter/FW and the interfaces of the host os. This is true
of whatever the technology is - SCSI, Ethernet, rs232, whatever.

As the current design of the scsi subsystem has SCSI-hba's attaching
via the host template - of course the LLDD will contain the host
template.

So - if you want to change this there are only 2 options:
A) Change the scsi subsystem LLDD interface
B) Work within the existing scsi subsystem hba interface

As this list has repeatedly stated:

If you choose to do A :
  As you are the one motivated for change, you better be able to 
    back it up by effort (aka the coding).

  The resulting work had better:
    Support the midlayer and above to the same extent that
      the existing LLDD interface does.
    Be extensible to other LLDDs.
      Minimally this means at least 2 LLDDs.
      In the best world, this means any LLDD, supporting any
        type of transport.
      And what better way to prove extensible than by providing
        an example!  (a 2nd LLDD)

  As this is "new" and unproven, expect this work to evolve 
    outside of the upstream kernel (in a parallel git tree).
    It integrates upstream only when it is generally accepted by
    the community that it meets the requirements of midlayer 
    support and extensibility.

If you choose B :
  You are free to partition the implementation of your driver
    in any way you want, which can include an upper "layer" that
    contains the host template, but no hardware/fw knowledge,
    leaving that for lower "layer".

  And if other drivers can reuse those layers - great.
  
  Two thoughts to remember though:
    This really is a driver implementation choice, not a mandated
      "Specification" choice.  It may or may not be, for various
      reasons, be based on an example in an external specification.

    Every layer in the driver makes an expectation on what can
      and cannot be done at that level. It is truth that
      different adapters will have hardware/FW interfaces with
      different capabilities. Not all adapters may align well with
      all layers. Thus, the best re-use scenario is one
      in which the layers are selectable, not all mandated.
    
    For it to become part of the upstream kernel, it must meet a
      "style" that is acceptable to the community, as you will not
      be the only one that will attempt to support the driver.


> Before we start messing with what you suggest above, SCSI Core has a
> _long_ way to go.
> 
> (BTW, we're already doing this.)

I assume from this statement, you are creating an implementation for A.


> You cannot care about "remote" ports -- some types of device have _no_
> port layer, as well you only care about the port "half" on your end.
> SAS is quite clear on that.

Not quite true - you actually care about the other "half" as well. In other
words, is it a SSP Target, etc.  If you start interacting (sending i/o)
with that other half - of course you care about it.  There are functional
levels that will care about phy's, and other functional levels that care
about ports.


> > * duplicates HCIL mapping code
> 
> True.  I've been meaning to remove that somehow, but calling
> scsi_scan_target() and passing HCIL to _it_ is also ugly.
> Ideally I'd like to see struct scsi_domain_device { ... }; in place.
> My comments in sas_discover.c and sas_scsi_host.c are pretty 
> clear on that.

Agreed. But this is another example of chosing option A or option B.


> Yeah, I agree with you: the political BS is just overflowing 
> and hitting
> the fan all the time.

IMHO - if you're going to ask for "specific" answers, replies, etc,
the best way to obtain that is to lead by example....  These words
provide no value.

> A true SAM layer would be *much* _smaller_ and would have a more
> straightforward path for tasks. (as does the SAS layer)

IMHO - rarely does expectations meet reality when you go to truly
make it work. Consider CAM and CAM-3, both are SAM-based scsi
core implementations. [granted, it all depends on where you set
your boundaries]

> > * Using scsi_scan_target() would allow us to use the normal LUN scan
> 
> Again not my code.  Normal LUN "scan" is done through REPORT LUNS
> as shown in sas_discover.c as I posted both functions to this list
> in a recent email.

FYI - in looking at SAS-1.1, I see nothing that describes LUN scanning.
What I do see are things that state "may be" a SCSI Domain or SCSI
Device - and use a general "see SAM-3" as a reference. No where
do I see the spec stating that a SCSI Device "shall" be a SCSI Device
as defined by SAM-3.

Example: please look at the definition of "SCSI Target Device" and
see if that definition could not apply to a SAM-1, or even a SCSI-2
device.

It should be evident what I'm highlighting. The spec is not as literal
as your convictions. It may not be appropriate to base things on the
literal assumptions.

> You don't see the _big_ picture: ...
> ...
> "Helper libs" makes the code ugly and spaghetti like.
> ...
> Look at the big picture and how the layers interact with each other.
> You need an _overall_ picture.

Initially, I wanted to reitterate the "lead by example" statement.
But quite frankly, the language used repeatedly in these threads with
people that do not have the same opinion as you is repulsive. In this
case it's a bit subtle, in others it has not been.

Jeff is a very smart individual, as are you, and many others on this list.
Please try to treat everyone with dignity and respect. There are many
many ways to phrase things.

-- james s
