From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 18 Feb 2003 14:46:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E528DA9.1000209@splentec.com>
References: <Pine.LNX.4.10.10302172136210.3880-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Andre Hedrick wrote:
 > Luben,
 >
 > You are trying to make the mid-layer to the work of iSCSI where your
 > driver needs to do it.  Everyone else gets how to do target portal groups
 > without dorking the kernel.  Maybe you should try harder.

Andre,

1. What we're discussing here is 2.7 (3.1) stuff which *may* be
into a 2.8 (3.1) kernel -- which would be how many *YEARS* into the future?

This discussion has *NOTHING* to do with iSCSI in particular or with
FC or with SAS, or with...

It has _only_ to do with SAM-2/3.


2. You seem to be confused into thinking that (iSCSI Target) Portal
Groups have something to do with the ``portals'' I'm talking about.
They have _nothing_ to do with each other.

You see, a (iSCSI Target) Portal Group has a Portal Group Tag,
and NOWHERE do I talk about such a Tag, which should show you
that the choice of the word ``portal'' is unfortunate for you
since you got confused...

I encourage *EVERYONE* here to read the definitions of
	- ``Portal Group'',
	- ``Portal Group Tag'' and
	- ``Network Portal'',
from the iSCSI draft, and decide for themselves.
The doc is here:
http://www.haifa.il.ibm.com/satran/ips/
version 20 is what you want to read, the 2.1 Definitions section.

Then I encourage everyone to check out Eddy Quicksall's
iSCSI-in-diagrams at the bottom of the aforementioned
link -- it clearly demonstrates what a (iSCSI Target)
Portal Group and its Tag is.

You see, Andre, (iSCSI Target) Portal Group has nothing to do
with a ``SCSI Target _Device_'', but with connection management
and device access over network portals and session management
for the specific node -- all iSCSI specific concepts.

What I'm basically trying to represent is a target
being a collection of LUs, as is in SAM-3r04, 4.7.2, figure 12.

And a portal being an abstraction of the controller, which may
be *any* kind of controller (FC, SPI, SAS, etc).  But some
protocols will *not* have a controller, per se, or ``host'',
so the most appropriate word would be to call it a ``portal'' since
it provides access to the SCSI Initiator Port to the Service
Delivery Subsystem to the Interconect, and thus access to the
device.  But you see, that stuff in the middle is supposed to
be transparent to the Application Client (SCSI Core), and thus
you have LLDDs.

LLDDs will not be abstractions over ``make of physical controller''
anymore, but much more, abstractions over the *method* of connection,
i.e. we assumed it was SPI, and now we cannot assume even that,
with newer transports like SAS, iSCSI, SRP, etc.


3. Sorry to confuse you with the word ``portal''.  If you knew
SCSI, you'd see right away that what I mean is ``SCSI Domain''
(SAM-3r04, 4.4, figure 8, 4.5, figure 9) but the problem with
this is that ``SCSI Domain'' *in a computer/kernel* would be a
collection of all the ``SCSI adapters'' of a _certain_ Service
Delivery Subsystem, and this isn't _representative__enough_ of the
real world, to use James's and Doug's words.  So for this reason
the most approriate word for a ``device which provides access
to (specific/any) service delivery subsystem'' is ``portal''.
And inside that portal structure we keep info on what the SDS is.

Do not confuse the use of ``portal'' in my most recent emails with
its other uses in various other SCSI Service Delivery Protocol docs.


On a personal note:

4. I find it extremely personally insulting of your assumptions
about an iSCSI driver of mine, what it needs and what it doesn't?

How do you know if such a driver exists?  How do you know what my
real job is?  Do you really know me in order to post such speculation
and FUD?

I find it extrememly personally insulting in that you assume that
I have an ``agenda'' into changing SCSI Core to fit some non-existant
personal purpose.

Your message is speculative and defamatory.  I hope you resist from
posting any more such messages involving myself.

Hope this clears it up for you,
-- 
Luben



