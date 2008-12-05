From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 00/12] st: remove scsi_execute_async usage (the first half)
Date: Fri,  5 Dec 2008 15:25:19 +0900
Message-ID: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53442 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYLEGZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This is the second version of the following patchset to remove
scsi_execute_async (and scsi_req_map_sg) usage in st:

http://marc.info/?l=linux-scsi&m=122803306431009&w=2

This depends on the following patch, adds residual argument to
scsi_execute and scsi_execute_req:

http://marc.info/?l=linux-scsi&m=122836830920741&w=2

I changed only the second patch to add a helper function to perform
SCSI commands synchronously. Previously, I implemented it by using
blk_get_request, blk_rq_map_kern, and blk_execute_rq. This time I just
use scsi_execute(). The above 'residual' patch enables me to do it. As
discussed, I also changed the helper function to return -EBUSY in case
of internal failure as st_do_scsi does.

The 12th patch is newly added, convert st_int_ioctl to use
st_scsi_kern_execute:

http://marc.info/?l=linux-scsi&m=122826408814126&w=2


Kai, can I get your ACK on the second patch?


Thanks,



