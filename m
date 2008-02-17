From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] scsi_debug: disable clustering
Date: Sun, 17 Feb 2008 23:52:23 +0900
Message-ID: <20080217235244N.tomof@acm.org>
References: <20080217141045.GB21012@parisc-linux.org>
	<1203257892.3082.11.camel@localhost.localdomain>
	<20080217142848.GD21012@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52958 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbYBQOwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 09:52:33 -0500
In-Reply-To: <20080217142848.GD21012@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: James.Bottomley@HansenPartnership.com, tomof@acm.org, dougg@torque.net, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jpfujita.tomonori@lab.ntt.co.jp

On Sun, 17 Feb 2008 07:28:48 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sun, Feb 17, 2008 at 08:18:11AM -0600, James Bottomley wrote:
> > No, he means that kmap_atomic can only map a page of data.  This makes
> > single page only sg list entries and input assumption into this loop.
> > with ENABLE_CLUSTERING, that's potentially not true.   Of course, this
> > accidentally works most of the time because of the way kmap functions.
> 
> Ah, right.  I'm on the verge of releasing a ram-based scsi driver I've
> been working on ... this loop should work fine with clustering as it
> takes account of the sg potentially having multiple pages:
> 
>         scsi_for_each_sg(cmnd, sg, scsi_sg_count(cmnd), i) {
>                 struct page *sgpage = sg_page(sg);
>                 unsigned int to_off = sg->offset;
>                 unsigned int sg_copy = sg->length;
>                 if (sg_copy > len)
>                         sg_copy = len;
>                 len -= sg_copy;

stex driver has a similar function to copies data between a buffer and
a scatter list. I think that scsi_kmap_atomic_sg is a bit primitive
(and not very popular).  I'll send a patch to add a helper function to
scsi_lib.c that copies data between a buffer and a scatter list. It
would be useful for several drivers.
