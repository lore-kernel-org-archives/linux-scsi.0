From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Thin provisioning update
Date: Tue,  3 Nov 2009 23:25:38 -0500
Message-ID: <1257308740-4729-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:25265 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZKDE0i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 23:26:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

Christoph,

Here are some more recent bits for you to tinker with.

The first patch exports unmap granularity and alignment up the stack.  I have
also implemented support for topology stacking of these parameters.  A reported
discard granularity of 0 means fully provisioned.

In the second patch I made a few changes to the TP detection and extraction of
VPD values.

I have been hunting for heuristics for the WRITE SAME case but haven't found any
good ones.  I'm thinking we probably want to distinguish between a real array
with NV-backed unmap queueing and a thinly provisioned disk on a virtualization
server where there might be a real impact from having to zero out partial blocks.
I guess that's easy to handle with virtio but I'm not so sure how to do it when
emulating a SCSI disk.


