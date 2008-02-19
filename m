From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Wed, 20 Feb 2008 05:29:14 +0900
Message-ID: <20080220052915V.tomof@acm.org>
References: <20080218223246I.tomof@acm.org>
	<20080219170100D.tomof@acm.org>
	<1203437199.3103.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:40731 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbYBSUby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 15:31:54 -0500
In-Reply-To: <1203437199.3103.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: tomof@acm.org, lnxninja@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, jeff@garzik.org

On Tue, 19 Feb 2008 10:06:39 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-02-19 at 17:02 +0900, FUJITA Tomonori wrote:
> > ips did scsi_add_host(sh, NULL) so scsi_dma_map uses
> > shost_gendev.parent that isn't initialized properly, then the kernel
> > crashes. 2.6.23 and 2.6.24 have this bug.
> > 
> > We can fix this by calling scsi_add_host with pdev->dev, in the
> > standard way (like the following way) but this bug was fixed in the
> > current Linus tree by:
> > 
> > commit 2551a13e61d3c3df6c2da6de5a3ece78e6d67111
> > Author: Jeff Garzik <jeff@garzik.org>
> > Date:   Thu Dec 13 16:14:10 2007 -0800
> > 
> > [SCSI] ips: handle scsi_add_host() failure, and other err cleanups
> > 
> > 
> > James, the legitimate way to fix stable trees is sending this commit
> > (not sending a patch that was not committed upstream)?
> 
> Well, the upstream patch doesn't look so bad as a stable candidate to my
> eye.  Just because it's an unintended bugfix doesn't automatically
> invalidate it.
> 
> The reason stable likes backports of existing upstream patches is
> because they've supposedly been well tested in upstream.  Although that
> doesn't apply in this case because the other bug rather prevented
> testing, the principle is still sound.
> 
> So, would there be any problems simply backporting this?

Thanks, I see. There is no problem. Please backport this.
