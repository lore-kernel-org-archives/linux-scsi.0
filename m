From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Linux doesn't support bigger than 2TB IEEE-1394 disk
Date: Mon, 4 May 2009 09:06:16 -0600
Message-ID: <20090504150616.GY8822@parisc-linux.org>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw> <49FEFF7A.3090603@s5r6.in-berlin.de> <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41051 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZEDPGQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 11:06:16 -0400
Content-Disposition: inline
In-Reply-To: <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ronald <Ronald@ioi.com.tw>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, May 04, 2009 at 02:51:26PM +0000, James Bottomley wrote:
> > It is only part of the more general SBC (SCSI Block Commands) 
> > specification.  But Linux won't also send READ CAPACITY (16) to disks 
> > which claim SBC support, unless they also claim conformance to a 
> > reasonably recent SCSI revision (I don't remember which one and am too 
> > lazy to check).  This is because older firmwares may crash if they 
> > receive READ CAPACITY (16).
> 
> Again, no.  Standards conformance alters the way we probe.  Recently we
> altered this at Intel's request

Um.  My request, not Intel's.  I put forward the argument that T10 were
adding more and more features that were reported by READ CAPACITY 16
(and obviously can't be added to RC10).  You appeared convinced by
the argument.

I don't know how 'Intel' makes a request.  I can only assume there's
a process that involves meetings.  And stakeholders.  And buy-ins.
Let's never go there.

It'd be more honest to say that T10 are forcing Linux to try RC16 in
preference to RC10, even for devices <2TB.  If they put bits like TPE
in the VPD pages instead of the return from RC16, I don't think Linux
would care about RC16.

> because some details of thin
> provisioning (TRIM support) are only available in READ CAPACITY (16)
> response.

As far as I know, Intel has no stake in SCSI's Thin Provisioning.
I'm just trying to be a good Linux citizen and sort out issues relating
to TRIM while I'm implementing TRIM.  If I get this kind of response,
I'm going to stop doing that.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
