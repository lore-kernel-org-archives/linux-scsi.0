From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 14:24:41 -0600
Message-ID: <20070727202441.GS21219@parisc-linux.org>
References: <20070727150420.GL21219@parisc-linux.org> <46AA0B70.9060108@garzik.org> <20070727152520.GM21219@parisc-linux.org> <46AA150A.5090804@garzik.org> <20070727173613.GN21219@parisc-linux.org> <46AA2DB7.4010707@garzik.org> <20070727180447.GP21219@parisc-linux.org> <46AA4951.3040102@garzik.org> <20070727194652.GR21219@parisc-linux.org> <46AA4EAB.4000203@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40858 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbXG0UYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 16:24:42 -0400
Content-Disposition: inline
In-Reply-To: <46AA4EAB.4000203@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 03:59:39PM -0400, Jeff Garzik wrote:
> EISA can do shared interrupts and VLB cannot, according to some quick 
> Googling.

Fascinating!  I didn't know that.

> Are you certain you're not confusing adapters with channels?  I don't 
> see where the same I/O port is registered multiple times.  Or does EISA 
> present multiple channels via multiple I/O ports (multiple 
> advansys_board_found calls)?

Multiple calls to advansys_board_found.  The old code alternated between
adding 0x20 and 0xfd0 to the iobase that it was testing.  My new code
probes base+0xc30 and base+0xc50, but calls advansys_board_found() for
each of them.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
