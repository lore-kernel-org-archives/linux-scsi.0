From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_debug: disable clustering
Date: Sun, 17 Feb 2008 08:18:11 -0600
Message-ID: <1203257892.3082.11.camel@localhost.localdomain>
References: <20080216235714H.tomof@acm.org>
	 <20080217141045.GB21012@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55866 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556AbYBQOSQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 09:18:16 -0500
In-Reply-To: <20080217141045.GB21012@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: FUJITA Tomonori <tomof@acm.org>, dougg@torque.net, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp


On Sun, 2008-02-17 at 07:10 -0700, Matthew Wilcox wrote:
> On Sat, Feb 16, 2008 at 11:57:15PM +0900, FUJITA Tomonori wrote:
> > scsi_debug does at several places:
> > 
> > for_each_sg(sdb->table.sgl, sg, sdb->table.nents, k) {
> > 	kaddr = (unsigned char *)
> > 		kmap_atomic(sg_page(sg), KM_USER0);
> > 
> > 
> > We cannot do something like that with the clustering enabled (or we
> > can use scsi_kmap_atomic_sg).
> 
> Why not?  Is KM_USER0 used for something else with clstering enabled?

No, he means that kmap_atomic can only map a page of data.  This makes
single page only sg list entries and input assumption into this loop.
with ENABLE_CLUSTERING, that's potentially not true.   Of course, this
accidentally works most of the time because of the way kmap functions.

James


