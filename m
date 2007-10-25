From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Subject: [PATCH] tgt: use KMEM_CACHE
Date: Thu, 25 Oct 2007 15:33:07 +0900
Message-ID: <20071025153307F.fujita.tomonori@lab.ntt.co.jp>
References: <20071024235611B.tomof@acm.org>
	<20071024195755.14e9c37f@laptopd505.fenrus.org>
	<20071025032524.GJ27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:48480 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbXJYGda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 02:33:30 -0400
In-Reply-To: <20071025032524.GJ27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, James.Bottomley@SteelEye.com
Cc: arjan@infradead.org, tomof@acm.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 24 Oct 2007 21:25:24 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Oct 24, 2007 at 07:57:55PM -0700, Arjan van de Ven wrote:
> > On Thu, 25 Oct 2007 01:21:29 +0900
> > FUJITA Tomonori <tomof@acm.org> wrote:
> > > -	scsi_tgt_cmd_cache = kmem_cache_create("scsi_tgt_cmd",
> > > -					       sizeof(struct
> > > scsi_tgt_cmd),
> > > -					       0, 0, NULL);
> > > +	scsi_tgt_cmd_cache =  KMEM_CACHE(scsi_tgt_cmd, 0);
> > 
> > I have a question that is not described in your change log: why would
> > you want to do this change? kmem_cache_create() is THE linux API to
> > achieve this.... why would you not want to use it?? I'm sure you have a
> > good reason for this change, but I can't figure out what that is from
> > the changelog of your patch.
> 
> Looks like the preferred API was changed in May by clameter; see
> commit 0a31bd5f2bbb6473ef9d24f0063ca91cfa678b64

Yeah, I just thought that it would be better use new KMEM_CACHE macro.

Here's a bit better changelog.

-
From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] tgt: use KMEM_CACHE macro

This uses new KMEM_CACHE() macro instead of kmem_cache_create directly
to simplify slab cache creation.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_tgt_lib.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a91761c..d67ca14 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -640,9 +640,7 @@ static int __init scsi_tgt_init(void)
 {
 	int err;
 
-	scsi_tgt_cmd_cache = kmem_cache_create("scsi_tgt_cmd",
-					       sizeof(struct scsi_tgt_cmd),
-					       0, 0, NULL);
+	scsi_tgt_cmd_cache =  KMEM_CACHE(scsi_tgt_cmd, 0);
 	if (!scsi_tgt_cmd_cache)
 		return -ENOMEM;
 
-- 
1.5.2.4

