From: Sergey Panov <sipan@sipan.org>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally
	attached PHYs)
Date: Sat, 22 Oct 2005 11:28:30 -0400
Message-ID: <1129994910.6286.21.camel@sipan.sipan.org>
References: <4359395B.9030402@pobox.com> <43593FE1.7020506@adaptec.com>
	 <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com>
	 <435959BE.5040101@pobox.com> <43595CA6.9010802@adaptec.com>
	 <43596070.3090902@pobox.com> <43596859.3020801@adaptec.com>
	 <43596F16.7000606@pobox.com> <435A1793.1050805@s5r6.in-berlin.de>
	 <20051022105815.GB3027@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:45038 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S1751341AbVJVP3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 11:29:18 -0400
In-Reply-To: <20051022105815.GB3027@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

On Sat, 2005-10-22 at 11:58 +0100, Christoph Hellwig wrote:
> On Sat, Oct 22, 2005 at 12:42:27PM +0200, Stefan Richter wrote:
> > A. Post mock-ups and pseudo code about how to change the core, discuss.
> > B. Set up a scsi-cleanup tree. In this tree,
> >      1. renovate the core (thereby break all command set drivers and
> >         all transport subsystems),
> 
> No way.  Doing things from scatch is a really bad idea.  See how far we came
> with Linux 2.6 scsi vs 2.4 scsi without throwing everything away and break the
> world.  Please submit changes to fix _one_ thing at a time and fix all users.
> Repeat until done or you don't care anymore.

 It is a mistake to think that you can not do a big rework and keep SCSI
sub-system stable. You just have to make sure the OLD way is supported
for as log as it is needed.

 E.g. before moving in the RIGHT direction and weeding out parallel SCSI
atavism from the common SCSI layer (or should I say SAM, to please
Luben) you can insert "generic" transport layer at the bottom (just like
Luben inserted his SAS) and use it to keep all currently supported
drivers stable. SCSI mid-layer can be reworked in any number of steps,
even in one step, because is not a big thing, it is just 11k lines plus
4k of recently added transport modules.

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

