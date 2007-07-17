From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] dm-mpath-rdac: don't stomp on a request's transfer bit.
Date: Tue, 17 Jul 2007 14:07:06 -0700
Message-ID: <20070717210706.GA2277@plap.qlogic.org>
References: <4696D6CB.6050504@csupomona.edu> <1184292400.5146.45.camel@linuxchandra> <20070713023743.GA5350@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25600 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761568AbXGQVHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 17:07:10 -0400
Content-Disposition: inline
In-Reply-To: <20070713023743.GA5350@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian De Wolf <bldewolf@csupomona.edu>
Cc: linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, sekharan@us.ibm.com, Mike Anderson <andmike@us.ibm.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

	On Thu, 12 Jul 2007, Mike Anderson wrote:

	> Copying this mail to linux-scsi and Ccing Andrew Vasquez to possibly
	> provide input on the Qlogic behavior.
	...

	> > > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: ISP System Error - mbx1=0h
	> > > mbx2=8012h mbx3=8002h.
	> > > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: Firmware has been previously
	> > > dumped (ffffc2000171d000) -- ignoring request...
	> > > Jul 12 17:11:16 jimbo kernel: qla2xxx 0000:02:01.1: Performing ISP error
	> > > recovery - ha= ffff81007e85c530.

	So what's happening here is the firmware is detecting a Xfer-ready
	from the storage when in fact the data-direction for a mode-select
	should be a write (DATA_OUT).

	The following patch fixes the problem (typo).  Verified by Brian, as
	well.

diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
index 8b776b8..16b1613 100644
--- a/drivers/md/dm-mpath-rdac.c
+++ b/drivers/md/dm-mpath-rdac.c
@@ -292,7 +292,7 @@ static struct request *get_rdac_req(struct rdac_handler *h,
 	rq->end_io_data = h;
 	rq->timeout = h->timeout;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags = REQ_FAILFAST | REQ_NOMERGE;
+	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
 	return rq;
 }
 

