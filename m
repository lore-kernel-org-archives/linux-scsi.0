From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI device rescan, detection of disconnected	device,	or	switched
 devices.
Date: Thu, 31 Jul 2008 21:54:32 +0400
Message-ID: <4891FC58.6050805@vlnb.net>
References: <1217248348.4133.51.camel@galr-linux>	 <488DC55C.2050603@s5r6.in-berlin.de> <1217487434.25491.34.camel@galr-linux>	 <4891792C.6020304@s5r6.in-berlin.de> <1217504895.25491.69.camel@galr-linux>	 <1217513749.3333.7.camel@localhost.localdomain> <4891E149.8070805@vlnb.net> <1217521139.3333.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:42810 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751852AbYGaRyp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 13:54:45 -0400
In-Reply-To: <1217521139.3333.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Gal Rosen <galr@storwize.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

James Bottomley wrote:
> On Thu, 2008-07-31 at 19:59 +0400, Vladislav Bolkhovitin wrote:
>> James Bottomley wrote:
>>> Most of the hotplug we do depends on the transport model (because what's
>>> on the transport is changing).  Array reconfiguration has no hotplug
>>> event because SAM-3 has no real way of passing the information
>>> asynchronously.  The best it can do is Unit Attention/reported luns data
>>> has changed (asc=0x3f/ascq=0xe) on the next command.
>>>
>>> The problem is that there's no way to process the event correctly even
>>> when we get it.  All we can do is issue another report LUNS command and
>>> compare.  However, just because it looks like a single LUN disappeared
>>> doesn't mean the others weren't permuted or altered in some way (which
>>> data we cannot get).
>> But why don't do what's possible to do and for what there is complete 
>> information: add new LUN for new LUN and delete deleted LUN for reported 
>> luns data has changed UA? As well as get new capacity for a LU on 
>> capacity data has changed UA after, e.g., new space added to it?
> 
> Well, feel free to submit a patch, but it's an incredible mine field.
> We certainly can't do something that builds a trap for users (as in a
> policy which gets it right 10% of the time and wrong 90% of the time) so
> I'm strongly inclined to feel array reconfiguration is a manual process.
> If you think you can do it online, we don't panic or throw a spanner in
> the works, but we wait until you tell us what you did, but you'd be well
> advised to do it offline.
> 
> The point is that we can't distinguish LUN added from LUN split or space
> reapportioned or something ... even LUN renumbered would be seen as a
> remove followed by an add.

Sure, in cases, where it is impossible based of INQUIRY data 
unambiguously determine that, it's better don't do anything. But in 
cases if it is possible, which is true for most modern devices, it can 
be handled properly.

Vlad

