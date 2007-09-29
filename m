From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 5/6] mptlan: bug fix, only half the message frame is dma'd resulting in corruption
Date: Sat, 29 Sep 2007 10:17:49 -0600
Message-ID: <20070929161748.GA4376@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42064 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbXI2QRt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 12:17:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

NB = number of blocks.  This represents the number of blocks to transfer.
The block size is based on the message frame size provided in the ioc_facts. A value of zero indicates the entire message frame should be copied. This is two bit value.  So by setting this to non-zero vaule, you increase performance by reducing amount of data needing to be dma'd.   The value that is stored in ioc->ReqeustNB is sometimes a non-zero vaule, which  creates a bug in mptlan, where not the entire message frame is getting transfer to firware, resulting in corruption.  This fix sets the default to zero, thus entire message frame is copied.


Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptlan.c a/drivers/message/fusion/mptlan.c
--- b/drivers/message/fusion/mptlan.c	2007-09-17 17:17:50.000000000 -0600
+++ a/drivers/message/fusion/mptlan.c	2007-09-28 17:36:04.000000000 -0600
@@ -1224,6 +1224,8 @@ mpt_lan_post_receive_buckets(struct mpt_
 		}
 		pRecvReq = (LANReceivePostRequest_t *) mf;
 
+		i = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
+		mpt_dev->RequestNB[i] = 0;
 		count = buckets;
 		if (count > max)
 			count = max;
