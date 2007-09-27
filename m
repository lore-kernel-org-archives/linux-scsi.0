From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 18:48:14 -0400
Message-ID: <46FC332E.2040001@garzik.org>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <CE7B1A4EF22E704CBFFD9A35BA5C822252505C@ausx3mpc110.aus.amer.dell.com> <20070927144649.GV3899@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43822 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbXI0WsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 18:48:22 -0400
In-Reply-To: <20070927144649.GV3899@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Patrick_Boyd@Dell.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Sep 27, 2007 at 09:16:13AM -0500, Patrick_Boyd@Dell.com wrote:
>> Unfortunately, it looks like IEEE doesn't have any OID's registered for
>> Linux or other reserved areas
>> (http://standards.ieee.org/regauth/oui/oui.txt). However, it does look
>> like they go in order... so maybe if you used an OID of 0xFFFFFF you
>> could at least guarantee that you didn't conflict with any company's SAS
>> WWNs.
> 
> It's something that happens frequently enough that we should come up
> with a proper way of handling this.  I heard a story of someone at HP
> taking an old computer, reading the MAC address from the motherboard,
> then snapping the board in half.  I suppose if you're going to use a MAC
> address from a 10Mbit ethernet card for a SAS WWN, there's no chance of
> conflict, but still ... 3com might choose to do the same thing, and then
> we're in trouble.
> 
> I don't have a good solution for WWN assignment.  Even if we get a
> 24-bit OID assignment for 'software use' or something, how do we control
> the use withi the SAN to be sure we get no overlapping WWNs?

To a perfectionist, there are no good answers besides "try your best."

The popular solutions I've seen are:

1) Random bytes, or fixed id + random bytes.  Even on a worldwide net, 
collisions are highly unlikely.

2) [pseudo-]hash of reasonably static properties of your platform.

3) Admin makes a site-specific decision, blending cases #1 and #2 with 
other schemes such as site-defined numbering.

In the ethernet world, all the drivers permit programmable MAC 
addresses, and many generate a random MAC if one is unavailable through 
other means.  In practice this is deployed rarely, though things like 
bonding and seamless failover are making much more use of programmable 
MAC addresses than ever before.

For case #2, one might consider creating a WWN for an ATA device that 
lacks one (they often do, even with a defined WWN field), by hashing the 
vendor id, firmware rev, and media serial number together.  But even 
with such hueristics, persistence and uniqueness are difficult to recreate.

With either case 1 or 2 -- both have seen success in the field -- you 
are essentially relying on luck after a certain point.  And that's life.

	Jeff



