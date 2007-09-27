From: Douglas Gilbert <dougg@torque.net>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 11:30:17 -0400
Message-ID: <46FBCC89.2030702@torque.net>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <46FBBBEB.4020605@garzik.org> <46FBBE52.1080507@sgi.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45097 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150AbXI0PcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 11:32:15 -0400
In-Reply-To: <46FBBE52.1080507@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Jeff Garzik <jeff@garzik.org>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Michael Reed wrote:
> 
> Jeff Garzik wrote:
>> James Smart wrote:
>>> Uh, although this may work very well for small constrained configs, as one
>>> who debugs larger environments (and things always grow or get connected in
>>> ways you don't expect), depending on a random number for uniqueness makes
>>> me very unsettled. Debugging that small-percentage potential, when/if it
>>> does occur can be an absolute nightmare with all kinds of weird behavior.
>>> Rarely will you solve it from the context of a single server. There are
>>> lots of ways to cheat, but I believe they all have to be based on some
>>> small part that is guaranteed to be unique (like the IEEE id's).
>> That's the ideal world, sure  :) 
>>
>> But the reality is, just like with ethernet MAC addresses, you don't always have one when you "supposed to" have one.
>>
> 
> I'm curious about the problem you're trying to solve.  Generally a missing WWN,
> as having a unique WWN should be a product requirement, is an indicator of
> a problem.  Shouldn't the proper solution be to have the card repaired?
> Arbitrarily assigning a WWN could mask or introduce other problems, in particular
> with regard to storage connectivity.

I have come across two types of problems:
  a) the scsi_debug driver looks like one or more logical units
     behind one or more dual ported SAS devices. All generated
     SAS address (for target ports, target devices and lus)
     should be distinct and preferably world wide unique.
     [My scsi_ses driver has a similar problem.]
  b) SAS HBAs that can run in target mode don't have enough
     unique SAS addresses allocated. A SAS initiator (the HBA's
     normal mode) only needs a couple a SAS addresses (e.g.
     3: one for the 4 internal phys, another for the 4
     external phys and 1 for the SAS initiator _device_
     (but I have never seen that done properly)). When you turn
     the SAS HBA around as a target (or initiator/target for
     bonus points) then each logical unit connected to or
     simulated by the SAS target needs a unique SAS address.

Years ago I asked for linux to get a IEEE OID. In the absence
of that perhaps we should use 0xffffff. FreeBSD, OpenBSD etc
face a similar problem.

Doug Gilbert

>> There are obvious limitations and problems arising from a generated WWN -- particularly for an HBA, where serial numbers and other unique identifiers are scarce.  But that doesn't wish the missing-WWN problem away.  Decades of networking experience have taught us a few things  :) 
>>
>> As an aside, we also need a way to override the HBA's WWN, just like we do with ethernet MAC address.
> 
> We do?  Perhaps if it's corrupt and you know the correct value.  But, in that case
> shouldn't the card be replaced?  When would you need to override the default WWN?
> 
> Linux: it's not just for desktops anymore.  :)
> 
> Mike
> 
> 
>>     Jeff
