From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 23:20:31 +0200
Message-ID: <4644DE1F.8050107@s5r6.in-berlin.de>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38492 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463AbXEKVUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 17:20:41 -0400
In-Reply-To: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, =?ISO-8859-1?Q?Kristian_H=F8?= =?ISO-8859-1?Q?gsberg?= <krh@bitplanet.net>

James Bottomley wrote:
> Right at the moment, we're planning to clean up the way SCSI drivers
> process commands.  The proposals are essentially:
> 
>      1. Get rid of the now unnecessary map_single path (every command is
>         either zero transfer or scatter/gather)
>      2. use accessors to manipulate the SG lists (mainly so that we can
>         alter the implementation without affecting the drivers)

Should be fine with the old and the new SBP-2 driver.

> It strikes me that in all of this, we could also consider doing the DMA
> mapping inside the mid layer (instead of in every driver).  This is
> essentially what libata is already doing ... leading to confusion in
> SCSI drivers that use libata for SATA.
> 
> So what do people think about this?

The old SBP-2 driver needs the virtual addresses of S/G elements if
compiled with a certain config option.  This option is meant for use
with FireWire controllers which do not implement OHCI-1394, or to run
the IEEE 1394 stack in a more secure mode.   However, sbp2 seems to be
broken in multiple ways with this option at the moment, and I don't plan
to fix it anytime soon.

So in short, moving the DMA mapping into mid layer should also be fine
with the old and the new SBP-2 driver.
-- 
Stefan Richter
-=====-=-=== -=-= -=-==
http://arcgraph.de/sr/
