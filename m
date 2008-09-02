From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] older SG interface fixes (for the block layer conversion)
Date: Tue,  2 Sep 2008 16:20:18 +0900
Message-ID: <1220340020-4855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:57312 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYIBHVs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 03:21:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jpy

I messed up the older SG interface's READ commands.

With READ commands via the older SG interface, we don't know a
user-space address to transfer the result data when executing a SCSI
command. So we can't pass a user-space address to blk_rq_map_user.

This changes blk_rq_map_user to takes a NULL user-space address. That
is, sg uses blk_rq_map_user to just set up a request and bios with
page frames without data transfer (similar to what scsi_req_map_sg
does for sg now).

blk_rq_map_user doesn't map a user space address so the name,
blk_rq_map_user, might be odd but I leave it alone.


