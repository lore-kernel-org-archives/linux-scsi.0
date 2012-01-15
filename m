From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: sniffing scsi
Date: Sun, 15 Jan 2012 12:13:06 +0000
Message-ID: <1326629586.2903.10.camel@dabdike.sthat4.btopenzone.com>
References: <CAAMvbhEcheTpAU1kX9nR=D+p3X6uWCu1uXEr6xaH3Wuezpcn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41078 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761Ab2AOMNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2012 07:13:09 -0500
In-Reply-To: <CAAMvbhEcheTpAU1kX9nR=D+p3X6uWCu1uXEr6xaH3Wuezpcn+g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2012-01-15 at 11:54 +0000, James Courtier-Dutton wrote:
> Is it possible to monitor scsi messages on a particular bus.
> E.g. Attach to /dev/sda or /dev/sr0 and capture all messages going between them.
> Ideally, in such a way that wireshark can capture it.
> We can do this for Ethernet and USB, but I cannot find SCSI bus capture.

The answer is that it depends.  You need to modify the target mode
driver for the card you have, so it doesn't quite work out of the box:
for the Obsolete parallel SCSI bus, yes if you modify the target mode
driver to pass up all packets.  For all other target mode drivers, you
can still modify them to pass up all packets they can see (this might
involve firmware programming in the HBA to put it into what networks
call promiscuous mode), but that's not necessarily all packets on the
bus: modern transport busses are effectively packet switched networks
and not all end points see all the traffic (much like modern switched
ethernet networks).

If you want to interface to wireshark, I believe you then have to write
a PCAP interface for the target driver.  It's been done for the IP
protocols and for one of the IBM target drivers, but not for STGT or LIO
I think.

James


