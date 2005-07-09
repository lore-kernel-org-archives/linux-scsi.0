From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 13:49:58 -0400
Message-ID: <20050709174958.GA29099@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709162712.GB27347@phunnypharm.org> <1120926901.5008.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:38112 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261644AbVGIRt7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 13:49:59 -0400
Content-Disposition: inline
In-Reply-To: <1120926901.5008.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, Jul 09, 2005 at 11:35:01AM -0500, James Bottomley wrote:
> On Sat, 2005-07-09 at 12:27 -0400, Ben Collins wrote:
> > THese changes break sbp2, and we'll need to revert them in the main stream
> > kernel until the patch is tested and fixed in our tree.
> 
> They cannot be simply reverted.  The API has changed from the EH
> routines being called with the host lock held to being called lockless.
> If you need the lock, you have to take it yourself, which is what the
> changes do from my reading of the code.

It's not the lock change that is breaking things, it's the RBC changes.
SBP2 simply doesn't work (incorrect information read from the driver,
which I assume is bad translation of the scsi commands caused by the
changes).

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
