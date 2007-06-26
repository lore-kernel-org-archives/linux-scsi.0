From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 26 Jun 2007 12:44:14 +0200
Message-ID: <4680EDFE.4050808@s5r6.in-berlin.de>
References: <319583.29876.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:47136 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbXFZKoV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 06:44:21 -0400
In-Reply-To: <319583.29876.qm@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> --- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Do all these transports use the same *name* for the attribute holding
>> the target port identifier's?
> 
> Sure, it is "tpid".

In mainline's transport classes?  Or/and in your stack?  OK, I'm lazy, I
should look into the source.

>> In other words, is userspace able to find
>> the target port identifier without knowing which transport is at work?
> 
> How can that be?  The target port identifier is by definition
> a transport property?

Target Port Identifier is a property of targets.

Only /how its value looks like/ depends on transport protocols.  Doesn't it?

So let's put the can always in the same shelf, regardless of the flavor
of the soup in the can.

(That's really why I joined the discussion.  We already have all
userspace requirements covered in sbp2, regarding which properties to
expose how.  Except that we do it in sbp2's own place rather than a
place common to all transport layer implementations.)

> "Userspace" which you have in mind will be more interested in the
> device name and other ID properties as returned by the INQUIRY
> facilities.  Some are transport specific some are not.
> 
> Either way userspace can follow a pointer from the sysfs device
> entry to the transport, just as sg-utils and lsscsi does now for
> the SAS Stack (my version of it at least).

As a side note:  What I said was because I'm a lot SBP-2/3 biased and
didn't deal with other transports myself yet.  In SBP-2/3 we are only
interested in LUs, we are interested in the concatenation of TPI and LUN
for worldwide unique persistent identification of LUs, we get both from
IEEE 1212 facilities, and SPC support is not so extensive.

>> Regarding the TPID:  The /how/ should be left to the transport layer
>> implementation; but the /where/ should be uniform in all transports.
> 
> This maybe hard to do since the structure of the domain is different
> for different protocols.
> 
> Of course this can be hacked by using symlinks...

If there are going to be sysfs representations of targets, i.e. target
devices, can't we express the target--LU relationships as parent device
relationships?  Could also be grand-(grand-)parent device relationships.

If neither is possible with some transports, then we indeed have to
resort to explicit attributes, e.g. symlinks.
-- 
Stefan Richter
-=====-=-=== -==- ==-=-
http://arcgraph.de/sr/
