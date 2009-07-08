From: <berthiaume_wayne@emc.com>
Subject: RE: [PATCH 0/3] scsi_dh: Make scsi device handler modulesautomatically inserted
Date: Wed, 8 Jul 2009 11:53:54 -0400
Message-ID: <8F08A56613D77044BD153E2AC5DA0F840242C09F@CORPUSMX40A.corp.emc.com>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu> <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site> <4A3BDFE8.3090003@redhat.com>  <4A44D37A.10903@redhat.com> <1246986723.6277.63.camel@mulgrave.site>  <4A538B13.8050809@redhat.com> <1246990464.6277.74.camel@mulgrave.site> <1246995401.9541.15.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:14218 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZGHPzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 11:55:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1246995401.9541.15.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: pjones@redhat.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, hare@suse.de

Hi Chandra.

	I can speak for EMC PowerPath in that it is affect by DM if both
are trying to control the same device. Another large multipathing
solution that may be affected would be Symantec's DMP.

Regards,
Wayne. 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Chandra
Seetharaman
Sent: Tuesday, July 07, 2009 3:37 PM
To: James Bottomley
Cc: Peter Jones; linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu;
hare@suse.de
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler
modulesautomatically inserted


On Tue, 2009-07-07 at 18:14 +0000, James Bottomley wrote:
> On Tue, 2009-07-07 at 13:51 -0400, Peter Jones wrote:
> > On 07/07/2009 01:12 PM, James Bottomley wrote:
> > > On Fri, 2009-06-26 at 09:56 -0400, Peter Jones wrote:
> > >> James, I think Chandra and I have responded to most if not all of
your points, 
> > >> and would appreciate your thoughts on what we've said.
> > > 
> > > Well, you didn't respond to the important one:
> > > 
> > > You're seeking to change the binding of these helpers from manual
to
> > > automatic.  This would mean that the modules are loaded in the
single
> > > controller case, for which they may not be wanted and also when
some
> > > multi path tool other than dm-mp is managing the device, in which
case
> > > they may actively interfere with operations.  Your basic
contention is
> > > that you "don't see any concern here".
> > 
> > I think Chandra addressed this in his reply to your previous email: 
> 
> I don't think so:
> 
> > [From him]
> > > This is by design (of SCSI DH). We do want the device to be
attached to
> > > its handler _irrespective_ of whether multipath comes along or
not.
> > > 
> > > BTW, there is _no_ infrastructure in multipath for handlers. They
were
> > > removed from multipath when scsi dh came along. So, no worries
about
> > > proprietary multipath handlers. Also, multipath _can_ attach a
device to
> > > a different (SCSI) device handler if it finds that the one that is
> > > already attached is not the right one.
> 
> I want to know what happens when some multipath system other than
dm-mp
> tries to use a system with a device handler attached ... I don't see
how
> that addresses the issue at all. The device handlers, when they're
> attached can alter sense and return code processing .. this has the
> potential to interfere with how the other multipath code is expecting
> things to happen

When I responded to your earlier email I thought you meant the
interaction between dm-mp and the hardware handler ( and not other
out-of-tree multipath solutions). My answer was in that context alone.

Yes, your conclusion is correct. There are few functionalities in the
hardware handler interface that might affect the above layers (block and
above). One is the prep_fn() function, second is the check_sense()
function, and third is the activate() function.

Since scsi_dh is designed for dm-mp :). 

I do not know of all the out-of-tree multipath solutions and how they
behave and at what layer they interact. In effect, I haven't tested
hardware handler with other multipath solutions.

> 
> If we have to get really concrete: what happens with something like
> powerpath and scsi_dh_emc attached?
> 

They _might_ be affected as mentioned above.

> > [From you again]
> > > When I ask what testing you've done for either of these, the
studied
> > > silence eloquently illustrates "none". A policy change like this
> > > can't be made without being incredibly sure we're not going to
screw
> > > up existing installations.
> > 
> > I'll let Chandra address this, as it is my understanding that he has
> > hardware and has tested this code with it.
> > 
> > > The second point I made speaks to the technical ugliness of this:
what
> > > you're basically doing is open coding multiple binding for a
device
> > > handler specific case.  If you can persuade me the policy above is
> > > correct, then technically all this should be done correctly via
multiple
> > > binding in the generic device core ... before this interface
nastiness
> > > you're constructing propagates outwards and becomes part of the
user
> > > ABI.
> > 
> > I'm willing to re-implement the functionality with a different
mechanism
> > if it has your blessing, if you can be specific about what it is you
think
> > would be better.  Obviously I'll hold off on that until we've come
to some
> > agreement about the other aspects.
> 
> Well, the two things aren't so dependent: this dh_state attribute that
> hannes just NAK'd is precisely a binding attribute for your hand
rolled

Just to clarify:

dh_state attribute is not added new, it was originally added by Hannes. 

I just fixed a problem to make it work as it is intended, and sent an
explanation (about my fix) for Hannes to reconsider is NAK.

> multiple driver attachment, so actually getting generic device
multiple
> binding sorted out would help out regardless of what the final
> attachment policy decision is.
> 
> James
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

