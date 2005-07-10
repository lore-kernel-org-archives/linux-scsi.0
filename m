From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 09 Jul 2005 23:21:47 -0500
Message-ID: <1120969307.5431.8.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:19591 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261845AbVGJEVx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 00:21:53 -0400
In-Reply-To: <20050709230656.GS29099@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, 2005-07-09 at 19:06 -0400, Ben Collins wrote:
> Alright, I need some explanation on these changes to sbp2. Lots of things
> ripped out.

The patch seems reasonably explanatory:

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=631e8a1398ce4cfef8b30678d51daf0c64313a09


> I can understand that TYPE_RDC is what we had as TYPE_SDAD. Now, in our
> tree for TYPE_RDC, we converted it to TYPE_DISK. We also did a lot of mode
> conversions for DISK/RDC/ROM types.
> 
> My question is, why were the conversions all removed? The conversions, as
> far as I know, are related to SBP protocol, and not SCSI, so why would the
> SCSI maintainers feel the need to rip out an important part of the SBP2
> driver? Note, this isn't really a SCSI device, or a scsi host controller.
> It's a protocol translation layer.

TYPE_RBC is essentially a TYPE_DISK but with a few weird quirks, mainly
in the mode page setups.  The object of the changes is to make sd.c
treat TYPE_RBC correctly without any need of translations.

I'm not sure where you get the idea that SBP isn't a SCSI protocol from:
it was defined and ratified by the T10 SCSI committee
(http://www.t10.org/ftp/t10/drafts/sbp2/sbp2r04.pdf).  The RBC command
set was designed for the SBP protocol, but not for exclusive use by it.
The idea of the changes is to treat SBP for what it is (a transport
protocol) and have the ULDs understand the actual command protocol (RBC)
so there's no need for a protocol translation layer at all (this is the
bit that got removed).  This has the added benefit that the sd ULD is
ready for the day USB or other device vendors adopt RBC.

James


