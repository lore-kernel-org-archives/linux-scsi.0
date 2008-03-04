From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] modify the type of element of MessageUnit_B in arcmsr
Date: Tue, 04 Mar 2008 10:39:47 -0600
Message-ID: <1204648787.3091.25.camel@localhost.localdomain>
References: <005e01c87ddd$1c22db70$8800a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47263 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765016AbYCDQjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 11:39:53 -0500
In-Reply-To: <005e01c87ddd$1c22db70$8800a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk


On Tue, 2008-03-04 at 17:49 +0800, nickcheng wrote:
> Subject: [PATCH] scsi: modify the element type of MessageUnit_B in
> arcmsr-1.20.00.15-80227
> From: Nick Cheng <nick.cheng@areca.com.tw>
> Description:
> *** modify the element type of MessageUnit_B in arcmsr-1.20.00.15-80227 to
> keep off the error while doing iounmap in arcmsr_free_ccb_pool()

What's the actual error this causes?

Looking at the code, all of these registers are genuinely 32 bits long,
so having them defined as uint32_t __iomem * is fine; so is having them
defined as void __iomem *, because void * can be transparently cast to
any pointer.

Because the readX/writeX routines are prototyped in terms of void
__iomem *, they do the casting transparently (and without warning), so
there's no useful typechecking with the uint32_t __iomem * definition,
thus I only have a tiny marginal preference for labelling the registers
with their correct width.  But I would like to understand what the error
is you're seeing.

Thanks,

James


