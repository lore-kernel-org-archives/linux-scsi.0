From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 3/7] mptfusion: initChainBuffers should return errno
Date: Wed, 4 Jun 2014 12:49:45 -0400
Message-ID: <1401900589-19672-4-git-send-email-joe.lawrence@stratus.com>
References: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:36262 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaFDQuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 12:50:09 -0400
In-Reply-To: <1401900589-19672-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

The lone caller of initChainBuffers checks the return code for < 0, so
it is safe to appease smatch and return the proper errno value.

Fixes the following smatch warnings:

  drivers/message/fusion/mptbase.c:4328 initChainBuffers() warn:
    returning -1 instead of -ENOMEM is sloppy

  drivers/message/fusion/mptbase.c:4335 initChainBuffers() warn:
    returning -1 instead of -ENOMEM is sloppy

  drivers/message/fusion/mptbase.c:4402 initChainBuffers() warn:
    returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/message/fusion/mptbase.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5ef3f89..a70b873 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4325,14 +4325,14 @@ initChainBuffers(MPT_ADAPTER *ioc)
 		sz = ioc->req_depth * sizeof(int);
 		mem = kmalloc(sz, GFP_ATOMIC);
 		if (mem == NULL)
-			return -1;
+			return -ENOMEM;
 
 		ioc->ReqToChain = (int *) mem;
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ReqToChain alloc  @ %p, sz=%d bytes\n",
 			 	ioc->name, mem, sz));
 		mem = kmalloc(sz, GFP_ATOMIC);
 		if (mem == NULL)
-			return -1;
+			return -ENOMEM;
 
 		ioc->RequestNB = (int *) mem;
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "RequestNB alloc  @ %p, sz=%d bytes\n",
@@ -4399,7 +4399,7 @@ initChainBuffers(MPT_ADAPTER *ioc)
 	if (ioc->ChainToChain == NULL) {
 		mem = kmalloc(sz, GFP_ATOMIC);
 		if (mem == NULL)
-			return -1;
+			return -ENOMEM;
 
 		ioc->ChainToChain = (int *) mem;
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ChainToChain alloc @ %p, sz=%d bytes\n",
-- 
1.7.10.4

