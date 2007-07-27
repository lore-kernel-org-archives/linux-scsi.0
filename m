From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/21] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 08:16:52 -0600
Message-ID: <20070727141652.GE21219@parisc-linux.org>
References: <11854705772-git-send-email-matthew@wil.cx> <46A8F850.3070102@garzik.org> <20070726203748.GR19275@parisc-linux.org> <46A9F842.6040209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53233 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879AbXG0OQx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:16:53 -0400
Content-Disposition: inline
In-Reply-To: <46A9F842.6040209@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 09:50:58AM -0400, Jeff Garzik wrote:
> >Would it make sense to put in a comment that says "No idea why we do this"?
> 
> IMO, yes.  It should be noticeable at the very least.

Added to todo for next spin of these patches.

> >>5) I would suggest putting a "remove inpw/outpw pointless wrappers" 
> >>cleanup patch before patches #2 .. #N.
> >
> >Next thing on my todo list is to convert the driver over to ioread8 and
> >friends.  Currently, only the wide boards get accessed through PCIMEM,
> >but the narrow boards also have PCIMEM BARs.  It would also allow the wide 
> >boards to be used on machines where PCIMEM is broken, like the VisWS.
> 
> PCIMEM versus PCIMEM... huh?

This driver is really two drivers in one -- the wide boards and the
narrow boards.  Christoph is working on a new driver for the wide boards
only, and once he's finished that, I'll delete the support for the wide
boards in this driver.

Right now, only the wide boards get to take advantage of PCIMEM.  I want
to give the narrow boards (like the one I have) the opportunity to take
advantage of PCIMEM, if they have it.  There's also a pending todo for
wide boards to fall back to ioports if PCIMEM doesn't work.

If that doesn't answer your question, I need something more detailed
than "huh?" ;-)

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
