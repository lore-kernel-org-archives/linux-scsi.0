From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new
	version of iscsi target?
Date: Thu, 08 Dec 2005 14:47:48 -0500
Message-ID: <1134071268.3259.29.camel@mulgrave>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>
	 <43972C2D.9060500@cs.wisc.edu>  <43987F75.2000301@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20360 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932294AbVLHTse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 14:48:34 -0500
In-Reply-To: <43987F75.2000301@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Thu, 2005-12-08 at 21:46 +0300, Vladislav Bolkhovitin wrote:
>   - Scst has some performance advantages over stgt, at least, on 
> hardware targets, because it allows internal handling in SIRQ context as 
> well as doesn't need user space program, so it eliminates additional 
> context switches (at least 3 per command for WRITEs and 2 per command 
> for reads plus switches to user space daemon, probably, 2 per command). 
> 5 context switches per command looks too much for me, especially 
> considering how little work is done on each context. It means ~15000 
> CS/sec on regular 200Mb/sec link with 64K block size. Additionally, 
> kernel only commands execution allows direct access to page cache, which 
> is GREAT performance improvement, because in architecture with user 
> space daemon the data should be copied several times between kernel and 
> user space. Or, do I miimpss anything?

I do have to say that I consider operation in interrupt context (or even
kernel context) to be a disadvantage.  Compared with the response times
that most arrays have to SCSI commands, the kernel context switch time
isn't that significant.

Additionally, it's perfectly possible for all of this to be done zero
copy on the data.  A user space target mmaps the data on its storage
device and then does a SG_IO type scatter gather user virtual region
pass to the underlying target infrastructure.  We already have this
demonstrated in the SG_IO path, someone just needs to come up with the
correct implementation for a target path.

The great advantage of doing SCSI state machines in user space is that
you can prototype anything you want, and user space has much better
state machine implementation (and debugging) tools available than the
kernel does.

James


