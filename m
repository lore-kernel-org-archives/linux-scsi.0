From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Tue, 19 Feb 2008 10:06:39 -0600
Message-ID: <1203437199.3103.15.camel@localhost.localdomain>
References: <20080218073134A.tomof@acm.org>
	 <20080217233701.GA30994@tpepper-t42p.dolavim.us>
	 <20080218223246I.tomof@acm.org>  <20080219170100D.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35701 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbYBSQGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 11:06:46 -0500
In-Reply-To: <20080219170100D.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, Jeff Garzik <jeff@garzik.org>

On Tue, 2008-02-19 at 17:02 +0900, FUJITA Tomonori wrote:
> ips did scsi_add_host(sh, NULL) so scsi_dma_map uses
> shost_gendev.parent that isn't initialized properly, then the kernel
> crashes. 2.6.23 and 2.6.24 have this bug.
> 
> We can fix this by calling scsi_add_host with pdev->dev, in the
> standard way (like the following way) but this bug was fixed in the
> current Linus tree by:
> 
> commit 2551a13e61d3c3df6c2da6de5a3ece78e6d67111
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Thu Dec 13 16:14:10 2007 -0800
> 
> [SCSI] ips: handle scsi_add_host() failure, and other err cleanups
> 
> 
> James, the legitimate way to fix stable trees is sending this commit
> (not sending a patch that was not committed upstream)?

Well, the upstream patch doesn't look so bad as a stable candidate to my
eye.  Just because it's an unintended bugfix doesn't automatically
invalidate it.

The reason stable likes backports of existing upstream patches is
because they've supposedly been well tested in upstream.  Although that
doesn't apply in this case because the other bug rather prevented
testing, the principle is still sound.

So, would there be any problems simply backporting this?

James


