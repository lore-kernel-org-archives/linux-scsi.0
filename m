From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 16:19:50 +0100
Message-ID: <49A95616.3070502@s5r6.in-berlin.de>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net> <1235663301.19035.44.camel@localhost.localdomain> <yq1prh5ey7b.fsf@sermon.lab.mkp.net> <49A94FEB.6050400@s5r6.in-berlin.de> <20090228150633.GQ16891@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42950 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZB1PUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2009 10:20:12 -0500
In-Reply-To: <20090228150633.GQ16891@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Feb 28, 2009 at 03:53:31PM +0100, Stefan Richter wrote:
>> /Is/ the used transport protocol a good indicator for whether a
>> particular target breaks by READ CAPACITY 16?  I have doubts.  Command
>> set support is independent of transport protocol support.
> 
> You must admit there's a striking correlation between USB devices and
> completely failing to follow the SCSI spec.  Our current workaround of
> clamping USB devices at a SCSI_2 level does avoid much of the pain.

OK, but currently implementations typically are:
 1. transport layer driver detects device with known flaws, switches on
    a device quirk flag,
 2. transport layer enables quirk for all devices which it serves by,
    default, possibly disables quirk for some whitelisted devices.

Pulling the SCSI level down in usb-storage belongs into the latter category.

Martin's proposal for transport identifiers includes the suggestion of a
third strategy:
 3. transport layer identifies itself, upper layer enable some quirks
    based on that information (alone or in combination with whatever
    other information).

So, while it may be prudent to deduct "it's USB" -> "don't try READ
CAPACITY 16", why not keep implementing this in way #2?
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
