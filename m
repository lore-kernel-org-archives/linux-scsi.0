From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: scsi build breakage
Date: Wed, 19 Mar 2008 18:05:28 +1100
Message-ID: <20080319180528.0ebcabe7.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:55748 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765974AbYCSUSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 16:18:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-next@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

I need the following patch to make various powerpc configs build.
sg_copy_buffer is introduced by commit
d9c3ddd20a2a1fca9655937d4fc636fcb8e9f59e ("[SCSI] block: add sg buffer
copy helper functions") in the scsi/master branch included into
yesterday's (and today's) linux-next tree.

I have applied this patch to today's linux-next tree.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Mar 2008 17:26:13 +1100
Subject: [PATCH] [SCSI] don't export static functions

They cause powerpc builds to fail.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 lib/scatterlist.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 475fe9d..b80c211 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -360,7 +360,6 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 
 	return buf_off;
 }
-EXPORT_SYMBOL(sg_copy_buffer);
 
 /**
  * sg_copy_from_buffer - Copy from a linear buffer to an SG list
-- 
1.5.4.4
