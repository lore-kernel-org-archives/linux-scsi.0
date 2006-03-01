From: Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Wed, 1 Mar 2006 16:39:03 -0500
Message-ID: <20060301213903.GJ14884@devserv.devel.redhat.com>
References: <8C064C48AB104B428CBA524C342357CA34CFC5@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58850 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751274AbWCAVjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 16:39:09 -0500
Content-Disposition: inline
In-Reply-To: <8C064C48AB104B428CBA524C342357CA34CFC5@aime2k05.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jgarzik@pobox.com>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Wed, Mar 01, 2006 at 01:22:56PM -0800, Tarte, Robert wrote:
> > From: Matthew Wilcox [mailto:matthew@wil.cx]
> > You're saying that you do an 8-byte non-DMA write to an address
> > that's congruent to 4 mod 8?  Based on briefly skimming the internal
> > documentation for zx1, I'd say you're invoking undefined behaviour.

> Thanks for the confirmation.  Internal documentation for zx1?  Where can
> I locate this?  Thanks in advance.

Overall, I would say that -- for any arch, not just zx1 -- you need to
make sure your write[bwlq]() calls are always naturally aligned in the
given register space.  Anything else invites problems.

It sounds like you are already on the right track, though, converting
non-aligned writeq() to write[bwl]...

	Jeff



