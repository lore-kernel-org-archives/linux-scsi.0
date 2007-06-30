From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Sat, 30 Jun 2007 23:26:37 +0200
Message-ID: <4686CA8D.20504@s5r6.in-berlin.de>
References: <712635.96237.qm@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50247 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbXF3V1H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jun 2007 17:27:07 -0400
In-Reply-To: <712635.96237.qm@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Swen Schillig <swen@vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> --- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> How about:
>>
>> union scsi_lun {
>> 	__u8	lun[8];
>> 	__be64	lun64;
>> 	__be16	lun16;
>> };
> 
> I'd rather not even hint that a LUN is to be viewed
> as anything integer-like.  Just use u8[8] aligned.
> 
> (I.e. it is u64 only at the time when printing it,
> but no one really needs to know this. It is u8[8].
> Not sure why this is hard to understand.)

SAM itself speaks of the LUN as 8 bytes quantity as well as 64 bits
quantity (and 2 bytes quantity as well as 16 bits quantity).  Of course
whether this dualism should be exposed in an API is another question.

[...]
>> 		__be64 sas_tpid;
> 
> Is it possible to stop with the u64 and its derivatives?
> __u8 sas_tpid[8] __aligned(8) would do just fine.

SAS defines the SAS address as fitting into eight bytes.  It furthermore
defines the SAS address as a bitfield consisting of 4, 24, and 36 bits
wide parts.  (And it defines the SAM object Target port identifier to be
implemented as SAS address.)

[u8 tpid[MAX_SIZE] or u8 tpid[] or union tpid]
> Neither. Inevitably a SCSI Core representation of a target
> port would contain a transport's layer opaque token (void* for
> example). That opaque token uniquely identifes a target's
> representation in the transport layer (target port), whose
> structure stores the tpid in protocol dependent form.
> 
> SCSI Core gives you /dev/sdXYZ, that's all. It needs to get
> out of knowing particulars of protocols.  This is the object
> oriented approach.

Target Port Identifier is a property of Target Port.  This has nothing
to do with transport protocols.

Of course the size, source, deeper meaning, and hence potential
human-readable representations of Target Port Identifier are transport
protocol dependent.  I acknowledge that this is a practical problem
which can easily be solved by /not/ storing tpid in midlayer's struct
scsi_target, thus also eliminating the need for a tpid datatype in
midlayer's API.

[...]
>> SAM says how many bits or bytes are in the
[target port identifier]
> 
> No, it does NOT.  The transport protocol does. SAM merely reproduces
> this information,

Well, it reproduces it, hence "says" it; but you are of course right in
that it does not /define/ it.

[...]
> Ask yourself these questions: "What does SCSI Core provide?", "What should
> SCSI Core provide?", "What should SCSI Core not provide?", "Why?".
> Give good justifications to your answers.

Among else:  It should provide a framework which enables userspace to
find the unique object identifiers (that are required to uniquely and
persistently identify logical units) always in the same place.  (That's
just my opinion.  Current userspace tools like e.g. udev scripts are
adapted to hunt those identifiers down in various places, and this works
too.)

I acknowledge that this can be accomplished by only passing string
representations of identifiers through to midlayer.  I also agree that
midlayer should contain as little transport-dependent details as
possible, and that much of what I wrote in my previous post was contrary
to that.  (And now back to driver debugging... :-)
-- 
Stefan Richter
-=====-=-=== -==- ====-
http://arcgraph.de/sr/
