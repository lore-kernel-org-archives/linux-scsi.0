From: "Knight, Frederick" <Frederick.Knight@netapp.com>
Subject: RE: [Lsf] Notes from the four separate IO track sessions at LSF/MM
Date: Thu, 28 Apr 2016 16:19:19 +0000
Message-ID: <d8e572ba7c9a46aaa3af4c5703ec07e3@hioexcmbx07-prd.hq.netapp.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
	<20160428121108.GA9903@redhat.com>
	<1461858038.2307.16.camel@HansenPartnership.com>
 <5722320E.5080202@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx144.netapp.com ([216.240.21.25]:63027 "EHLO mx144.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcD1QT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2016 12:19:28 -0400
In-Reply-To: <5722320E.5080202@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

There are multiple possible situations being intermixed in this discussion.  First, I assume you're talking only about random access devices (if you try transport level error recover on a sequential access device - tape or SMR disk - there are lots of additional complexities).

Failures can occur at multiple places:
a) Transport layer failures that the transport layer is able to detect quickly;
b) SCSI device layer failures that the transport layer never even knows about.

For (a) there are two competing goals.  If a port drops off the fabric and comes back again, should you be able to just recover and continue.  But how long do you wait during that drop?  Some devices use this technique to "move" a WWPN from one place to another.  The port drops from the fabric, and a short time later, shows up again (the WWPN moves from one physical port to a different physical port). There are FC driver layer timers that define the length of time allowed for this operation.  The goal is fast failover, but not too fast - because too fast will break this kind of "transparent failover".  This timer also allows for the "OH crap, I pulled the wrong cable - put it back in; quick" kind of stupid user bug.

For (b) the transport never has a failure.  A LUN (or a group of LUNs) have an ALUA transition from one set of ports to a different set of ports.  Some of the LUNs on the port continue to work just fine, but others enter ALUA TRANSITION state so they can "move" to a different part of the hardware.  After the move completes, you now have different sets of optimized and non-optimized paths (or possible standby, or unavailable).  The transport will never even know this happened.  This kind of "failure" is handled by the SCSI layer drivers.

There are other cases too, but these are the most common.

	Fred

-----Original Message-----
From: lsf-bounces@lists.linux-foundation.org [mailto:lsf-bounces@lists.linux-foundation.org] On Behalf Of Bart Van Assche
Sent: Thursday, April 28, 2016 11:54 AM
To: James Bottomley; Mike Snitzer
Cc: linux-block@vger.kernel.org; lsf@lists.linux-foundation.org; device-mapper development; linux-scsi
Subject: Re: [Lsf] Notes from the four separate IO track sessions at LSF/MM

On 04/28/2016 08:40 AM, James Bottomley wrote:
> Well, the entire room, that's vendors, users and implementors
> complained that path failover takes far too long.  I think in their
> minds this is enough substance to go on.

The only complaints I heard about path failover taking too long came 
from people working on FC drivers. Aren't SCSI transport layer 
implementations expected to fail I/O after fast_io_fail_tmo expired 
instead of waiting until the SCSI error handler has finished? If so, why 
is it considered an issue that error handling for the FC protocol can 
take very long (hours)?

Thanks,

Bart.
_______________________________________________
Lsf mailing list
Lsf@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/lsf
