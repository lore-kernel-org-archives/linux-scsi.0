From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Megaraid: Use of outb_p
Date: Fri, 18 Jan 2008 13:41:13 -0700
Message-ID: <20080118204113.GF20490@parisc-linux.org>
References: <9738BCBE884FDB42801FAD8A7769C26501E5FD9C@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49423 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760227AbYARUlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jan 2008 15:41:14 -0500
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501E5FD9C@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>

On Fri, Jan 18, 2008 at 01:32:12PM -0700, Yang, Bo wrote:
> Alan, 
> 
> The in/outb_p in MegaRAID scsi driver is used for our old io mapped
> megaraid controller.  There are still some customers are using those old
> controller.  Please keep them.

Hi Bo,

I think you've misunderstood the question.  The '_p' versions of
inb/outb introduce a delay after each access.  The current Linux
implementation of _p provokes bugs on some chipsets, so Alan is looking
for alternatives.  Let's ask the question like this:

Replacing outb_p() with outb(); udelay(x);
How large does 'x' need to be for these megaraid controllers?

> Thanks.
>  
> Bo Yang  
> 
> -----Original Message-----
> From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> Sent: Friday, January 18, 2008 7:36 AM
> To: linux-scsi@vger.kernel.org; DL-MegaRAID Linux
> Subject: Megaraid: Use of outb_p
> 
> 
> I notice the MegaRAID driver uses outb_p. Can someone at LSI confirm
> that the delays between each I/O are required, and if so how long they
> must be.
> 
> I'm trying to sort out the use of in/outb_p and where it is unneccessary
> or used for non ISA devices.
> 
> (Please cc me on the reply)
> Alan
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
