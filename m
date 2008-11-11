From: "Shi, Harris" <Harris.Shi@lsi.com>
Subject: Question on block-layer timeout change
Date: Tue, 11 Nov 2008 09:26:01 -0700
Message-ID: <3568BBCB98C00041A9E622952FD5F24EA11CA00A@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53657 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYKKQ0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 11:26:39 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Due to the current timeout management change, LSI RDAC (failover) driver had some difficulties in handling SCSI I/O timeout. The RDAC driver is in the similar layer as HBA driver in that it will register into scsi mid-layer as scsi_host_template and stays below mid-layer. All SCSI I/Os coming to RDAC stack are routed by an available path then dispatched to the real HBA driver via mid-layer. We used to rely on the timer in scsi_cmnd->eh_timeout to deal with scsi i/o coming into the RDAC stack. Basically when I/O is coming to RDAC stack, we need to delete the timer for each individual I/O. Then after selecting a specific path for this I/O, we need to send the I/O back to mid-layer with a larger timeout value just to avoid the forced failover. When I/O completes successfully, we added the ori
 ginal timer back to the I/O and pass it over to upper block layer for further process.

However, with the current timeout management functions moving to block layer, it became difficult for us to explicitly control the timeout value for specific SCSI I/O, which ended up causing many issues on failover. Can you shed some lights on how to handle the I/O based timeout in this case?

Harris
