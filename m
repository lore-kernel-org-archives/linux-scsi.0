From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Mon, 22 Aug 2005 01:34:26 -0400
Message-ID: <430963E2.9010606@pobox.com>
References: <43085209.50405@torque.net> <430914C2.8030301@pobox.com> <43095EB3.2020202@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:21388 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751469AbVHVWnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 18:43:11 -0400
Received: from mail.dvmed.net (mail.dvmed.net [216.237.124.58])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7M5bhA2001975
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 22:37:44 -0700
In-Reply-To: <43095EB3.2020202@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Douglas Gilbert wrote:
> With repect to my libata TEST UNIT READY patch there
> is a good chance that can be dropped. The feedback
> from the t10 reflector seems to indicate the current
> definition may be changed, unfortunately the proposed
> changes may require some SAT state information being
> held for each libata device (e.g. pseudo "STOPPED"

Keeping some state is not a big deal.  If it grows beyond a single 
struct member, though, I would probably be inclined to encapsulate the 
state in a separate struct ata_scsi_xlat_state or somesuch.


> state to mimic SBC-2). It also seems some power up
> issues may need to involve the transport layer
> for resolution. For example, SSP's additional sense code
> of LOGICAL UNIT NOT READY, NOTIFY (ENABLE SPINUP)
> REQUIRED may also need to be issued by libata.

libata, in general, is pretty ignorant of PM issues :)


> Another potential issue that I didn't mention was support
> for the "IMMED" bit in commands like START STOP UNIT; i.e.
> issue the corresponding ATA command but return to the caller
> without waiting for the ATA command to finish.

No need to avoid the issue, I know all about it :)

No plans to support stuff such as IMMED; too much pain for little gain.


> Showing my aversion to writing something like:
>    u8 page[sizeof(def_caching_mpage)];
> 
> Using sizeof in an array declaration seems to be a grey area in C,
> but gcc accepts it so perhaps I shouldn't worry.

Your example (quoted) should be fine on all compilers we care about :)


>>>+/* FIXME: we may want to issue two SET FEATURES commands here */
>>>+        if (dra != !(ata_id_rahead_enabled(qc->dev->id))) {
>>
>>
>>bug: need one more '!' AFAICS
> 
> 
> More coffee needed (by you) IMO. The logical inversion is required

Whoops, indeed, sorry about that.



>>>+    case INQUIRY:
>>>+        if (((cmd[1] & 0x3) == 0x1) && (cmd[2] == 0x89)) {
>>
>>
>>what do these magic numbers indicate?
> 
> 
> Place holder for ATA Information VPD page [0x89]. Valid when
> CmdDt=0 and EVPD=1. That page is defined in sat-r05. I'm about to
> decode that page in sg_inq and sdparm. Its payload is the ATA
> IDENTIFY command's response and the ATA device's "signature"
> [whatever that is].

Let's not add such a placeholder.  I'd rather just wait until the real 
thing appears :)

	Jeff


