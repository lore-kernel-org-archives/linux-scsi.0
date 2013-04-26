From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [nhorman@tuxdriver.com: [PATCH] libcxgbi: supress warning when we request to much space from kmalloc]
Date: Fri, 26 Apr 2013 08:20:53 -0700
Message-ID: <8A71B368A89016469F72CD08050AD3340CBE8487@maui.asicdesigners.com>
References: <20130426110203.GA13204@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:27509 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3DZPWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Apr 2013 11:22:03 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, JBottomley@parallels.com, linux-kernel@vger.kernel.org



-----Original Message-----
From: Neil Horman [mailto:nhorman@tuxdriver.com] 
Sent: Friday, April 26, 2013 4:02 AM
To: Karen Xie
Subject: [nhorman@tuxdriver.com: [PATCH] libcxgbi: supress warning when
we request to much space from kmalloc]

The patch looks fine to me.

Thanks,
Karen
----- Forwarded message from Neil Horman <nhorman@tuxdriver.com> -----

Date: Tue, 23 Apr 2013 11:20:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, "James E.J. Bottomley"
<JBottomley@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] libcxgbi: supress warning when we request to much space
from kmalloc
X-Mailer: git-send-email 1.8.1.4

cxgbi_alloc_big_mem allocates large chunks of memory, and can
occasionally request amounts from kmalloc that exceed the allocators
capacity.  This typically leads to a stack trace from the zoned buddy
allocator in the message log.  But if kmalloc fails, cxgbi_alloc_big_mem
backs off and uses vmalloc instead.  Given that, and the fact that the
two calls sites have their own error messages if both kmalloc and
vmalloc fail, I think the stack trace printing isn't really needed.

Modify the call to kmalloc to pass __GFP_NOWARN in as well, so that
internal kmalloc warnings are suppressed.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Honggang LI <honli@redhat.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/cxgbi/libcxgbi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.h
b/drivers/scsi/cxgbi/libcxgbi.h index 80fa99b..3daf996 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -658,7 +658,7 @@ static inline u32 cxgbi_tag_nonrsvd_bits(struct
cxgbi_tag_format *tformat,  static inline void
*cxgbi_alloc_big_mem(unsigned int size,
 					gfp_t gfp)
 {
-	void *p = kmalloc(size, gfp);
+	void *p = kmalloc(size, gfp | __GFP_NOWARN);
 	if (!p)
 		p = vmalloc(size);
 	if (p)
--
1.8.1.4



----- End forwarded message -----
