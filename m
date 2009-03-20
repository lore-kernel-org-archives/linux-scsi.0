From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Fri, 20 Mar 2009 13:41:29 -0400
Message-ID: <49C3D549.6010904@redhat.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>	 <1237402051.3350.29.camel@localhost.localdomain>	 <1237403542.14147.23.camel@chandra-ubuntu> <1237406940.3350.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZCTRl5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2009 13:41:57 -0400
In-Reply-To: <1237406940.3350.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sekharan@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 03/18/2009 04:09 PM, James Bottomley wrote:
> On Wed, 2009-03-18 at 12:12 -0700, Chandra Seetharaman wrote:
>> On Wed, 2009-03-18 at 18:47 +0000, James Bottomley wrote:
>>> On Tue, 2009-03-17 at 18:36 -0700, Chandra Seetharaman wrote:
>>>> From: Peter Jones <pjones@redhat.com>
>>>>
>>>> This patch allows the use of modaliases on scsi targets to correctly
>>>> load scsi device handler modules when the devices are found.
>>>>
>>>> Signed-off-by: Peter Jones <pjones@redhat.com>
>>>> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
>>> I have to say this is a bit icky.
>>>
>>> overloading the modalias type like this produces several nasty effects:
>>>
>>>      1. You don't actually care about type for any of the scsi_dh
>>>         handlers, so they all have it as a useless extra field
>>>      2. TYPE_ANY is a bogus (non SAM) definition ... I suppose it's
>>>         unlikely ever to clash, but you never know

Yeah, I wasn't really enthusiastic about this hack when I wrote it,
either.  More on that below.

>> >From (1) and (2) are you suggesting _not_ to use the TYPE field for
>> scsi_dh handlers ?
> 
> Well, you don't ever set it to anything other than TYPE_ANY, do you? so
> it's completely superfluous as far as you're concerned.  That's why
> overloading the SCSI ULD modalias looks rather contrived.

To be honest, I only used that particular modalias because it seemed
like the most natural place for it; so TYPE_ANY is really only there
because it already was.  Though I could imagine somebody writing a device
handler for e.g. a tape robot.  Or we could make the structure have
another field that says how to treat the type field, but that seems
sloppy.

If there's a /different/ object on which you think the modalias for
the scsi target itself should go, that'd be fine by me, I just didn't
see anywhere that looked better.

[...]
>> BTW, dm-multipath currently have code to insert appropriate modules if
>> needed (if they are not already made available).
> 
> So all of this is just to keep the initrd boot quiet?

Well, really it's so that we don't have to add /extra/ code in userland
to decide which device handlers to load and to load them.  Especially
since that's what modaliases are *for*.

--
  Peter
