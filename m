From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: Fix endianness of task management response code
Date: Fri, 21 Sep 2012 09:02:56 +0100
Message-ID: <1348214576.2468.1.camel@dabdike.int.hansenpartnership.com>
References: <1348006256-23551-1-git-send-email-roland@kernel.org>
	 <1348041561.2479.14.camel@dabdike.int.hansenpartnership.com>
	 <CAG4TOxMffy5ygGJ2ba8jFNmLx49e6p72RRgt8t=Sts1ypQofkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57641 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297Ab2IUIC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2012 04:02:59 -0400
In-Reply-To: <CAG4TOxMffy5ygGJ2ba8jFNmLx49e6p72RRgt8t=Sts1ypQofkA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>

On Wed, 2012-09-19 at 07:09 -0700, Roland Dreier wrote:
> On Wed, Sep 19, 2012 at 12:59 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Is this also true on Big Endian Hardware?  Because the fix you have
> > assumes that the TIO IOCB with SCSI status mode 1 should be CPU
> > endian ... that doesn't look right since this is passed directly over
> > the PCI bus (and the PCI bus is little endian), so shouldn't the correct
> > fix be to replace cpu_to_be32 with cpu_to_le32?
> 
> After my patch the assignment is to a u8, and that byte is in the right
> place in memory.  So I don't think there's any endianness bug.

The data in status1 appears to get used a word at a time ... what about
the other three bytes you don't set; are they guaranteed to be zero? (in
which case this works, it just looks wrong from the way the thing is
used in the rest of the code).

James


