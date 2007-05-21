From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] FC Transport support for vports based on NPIV
Date: Mon, 21 May 2007 11:45:13 -0400
Message-ID: <4651BE89.7020200@emulex.com>
References: <1176408091.19824.20.camel@localhost.localdomain> <20070514121239.GA23620@schmichrtp> <464886B6.8050509@emulex.com> <20070521152718.GA15212@schmichrtp>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35769 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbXEUPp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 11:45:29 -0400
In-Reply-To: <20070521152718.GA15212@schmichrtp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, duane.grigsby@qlogic.com


>> PS: One thing I didn't call out in the vport patches was the
>> expectation that the vport-supporting driver had to set the PPN
>> attribute appropriately.  And... did you see that T11 is trying to
>> change what the PPN is set to - the fabric port_name not the physical
>> N_Port port_name.
> 
> No, i did not follow the T11 change. Do you have a link to a
> draft document or something similar?

Here's the "problem statement" from the t11.org web site. I've attached
the email thread from the T11.3 reflector below.
http://www.t11.org/ftp/t11/pub/fc/gs-4/03-175v0.pdf

> zfcp uses the FC tranport class attributes port_name and
> permanent_port_name. PPN is the fixed WWPN of the physical
> adapter, while PN is the one virtual one used by each Linux
> guest and is assigned via NPIV. Both WWPNs are passed back
> via the "virtual" device, so i guess this would be only
> a matter of reporting the correct one in zfcp.
> 
> Christof
> 

True - so this means that who-ever is setting the subchannel device
permanent_port_name value needs to take into account this conversation,
when T11.3 actually makes a choice on what it should be.

-- james






-------- Original Message --------
Subject: 	RE: [T11.3] Using F_Port_Name as the Permanent Port Name
Date: 	Wed, 25 Apr 2007 17:56:26 -0600
From: 	Scott Kipp <skipp@brocade.com>
To: 	<Bob.Nixon@emulex.com>, <t11_3@t11.org>

Bob and all,

I'm sorry for the misunderstanding, but I am not proposing solution a)
that appends the F_Port_Name to the FLOGI Name.  Brocade would not like
to use 128-bit objects for the PPN.  I am proposing option b) that you
note below.  The definition of PPN seems vague now since it does not say
to use the Port Name, but just a "Name Identifier associated with that
Nx_Port at Fabric Login". The PPN definition seems vague since it could
be interpreted as using the Node_Name (another Name Identifier) while I
thought it was intended to say that the Port_Name should be used.  We
propose that the PPN definition change to something like this:

The Permanent Port Name is a Name_Identifier associated with a physical
Nx_Port. If multiple Name_Identifier are associated with a single
Nx_Port via FDISC (see FC-FS), the Permanent Port Name should be the
F_Port_Name and may be the Port_Name of the Nx_Port at Fabric Login.

As you state, we would like to hear input as to how the PPN is being
used.  If implementations are using the PPN, then option b) sounds
good.  If no one is using the PPN for management, then we could use
option c) and have management applications find the attached ports via
Get Attached Port Name List (GAPNL) by entering the F_Port_Name.

If you have implementations using PPN, please let the group know how the
PPN is being used today.

Thanks,
Scott

------------------------------------------------------------------------
*From:* Bob.Nixon@Emulex.Com [mailto:Bob.Nixon@Emulex.Com]
*Sent:* Wednesday, April 25, 2007 10:48 AM
*To:* Scott Kipp; t11_3@t11.org
*Subject:* RE: [T11.3] Using F_Port_Name as the Permanent Port Name

Hi, Scott and T11.3,

The FC-GS-6 work group actually discussed (at least) three options:

a) As you reported, extend the PPN to a 128-bit object, concatenating
the FLOGI name and the F_Port_Name;
b) Redefine the PPN to be the F_Port_Name instead of the FLOGI name; and
c) Deprecate use of the PPN as reliable correlator for N_Ports at the
same physical port, and note that the existing Fabric Port Name object
is an unambiguous correlator.

I believe all of these options should be left open for community input,
though the meeting minutes suggest only option b was intended (that
could have been the secretary's haste to catch the action before the
meeting moved on  8-)

To me, option a has the most impact: Since Name Server objects have
fixed length, using option a would force a backward
incompatibility, therefore a need to change the CT Revision value (and
this presumes that current implementations take account of the Revision
field). Is there any perceived countervailing advantage of option a over
options b and c?

Option b preserves PPN in its current format, while correcting its
possible ambiguity. Does anyone see a flaw in it that the work group missed?

If the Fabric Port Name is sufficient, why mess with PPN? It works
for many implementations, and some of them may actually rely on it
matching the FLOGI name.  Option c would simply note that the existing
Fabric Port Name object is an unambiguous correlator, so new
implementatons should use that instead of PPN.

Anyway, I believe all of these options need to be on the table, not just
option a.

    - bob

------------------------------------------------------------------------
*From:* t11_3-bounces@listserve.com [mailto:t11_3-bounces@listserve.com]
*On Behalf Of *Scott Kipp
*Sent:* Tuesday, April 24, 2007 5:00 PM
*To:* t11_3@t11.org
*Subject:* [T11.3] Using F_Port_Name as the Permanent Port Name

T11.3,

I have been tasked by the FC-GS-6 workgroup to find out if there is an
objection to associating the Permanent Port Name to the F_Port_Name.

The Permanent Port Name is defined as "the Name_Identifier associated
with a physical Nx_Port. If multiple
Name_Identifier are associated with a single Nx_Port via FDISC (see
FC-FS) the Permanent Port Name is the original Name_Identifier
associated with that Nx_Port at Fabric Login."

The group would like to expand the PPN definition to include the
F_Port_Name if there are no objections.  Please respond to the reflector
if you have a problem with this change.

Thanks,
Scott

