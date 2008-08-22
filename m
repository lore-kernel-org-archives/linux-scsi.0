From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas and mptbase sas problems on fujitsu-siemens rx200-s3
	rack server
Date: Fri, 22 Aug 2008 09:16:29 -0500
Message-ID: <1219414589.3339.8.camel@localhost.localdomain>
References: <48AE9DFB.7070502@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50073 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbYHVOQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 10:16:34 -0400
In-Reply-To: <48AE9DFB.7070502@iki.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eero Volotinen <eero.volotinen@iki.fi>
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-08-22 at 14:07 +0300, Eero Volotinen wrote:
> I am (un)happy owner of FSC rx200-s3 server that contains internal
> sas hardware raid. Datasheet says that server is linux compatible,
> but it is using buggy hardware or software?
> 
> Mainly under write i/o load to internal sas raid, the server crashes
> or hangs.
> 
> Any fix for this issue? I reported it to manufacturer, but without
> commercial maintenace license, they don't want to fix this issue.
> 
> System is tested with SLES 10 and Centos 5 and almost latest Linux
> kernel with Centos LiveCd..
> 
> Of course it is possible to get server working using external
> raid controller, but this server is advertised as Linux compatible..
> Any help?

It sounds like a HW problem, I'm afraid:  most problems within the
firmware engine of the HBA are beyond the capacity of the kernel to fix
(we can work around them if LSI help, sometimes).

The first thing to note is that HBA based hardware RAID is not something
anyone should enable blindly.  The fusion isn't even a dedicated RAID
card, so its RAID engine is effectively jammed into left over firmware
space because it was available (HP, for instance, required this
capability to be removed on some of the HP OEM models).

Even for dedicated hardware RAID, the problem you have is that it
effectively puts the onboard processor in the direct I/O path.  Since
cards are (reasonably) cheap, these processors don't have the fastest
busses or highest processing capabilities, and often top out at
surprisingly low bandwidths, especially for compute intensive
transactions like RAID-5/RAID-6.

Conversely, with the rapid advances in multi-core and front side bus
speed, the percentage of CPU horsepower required to run software raid
(as expressed in terms of the total available CPU power of the system)
has been dropping pretty rapidly.

The upshot is that anyone wanting RAID should evaluate very carefully
whether it should be in SW or HW on their platform by running tests.

So, for you, the first question would be can you dismantle the RAID and
simply run your stress tests over the native disk?  That will give us an
idea whether it's the RAID firmware engine or some other HW problem with
the card.

James


