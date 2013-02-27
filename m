From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] dm: Avoid use-after-free of a mapped device
Date: Wed, 27 Feb 2013 15:45:26 +0100
Message-ID: <512E1C06.2000903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:35839 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab3B0Opb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2013 09:45:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

This mini-series of two patches avoids that the device mapper
implementation can trigger a use-after-free during removal of a
mapped device. The two patches in this series are:
- block: Convert blk_run_queue() recursion into iteration.
- dm: Avoid running the md queue after the last dm_put().

Note: these patches are the result of source reading. As far as I know 
this issue has not (yet) caused any harm.

Changes compared to v1:
- Invoking blk_run_queue() again guarantees that the queue will be run
   sooner or later.
- Refined patch descriptions and source code comments.
- Left out the "Cc: <stable@vger.kernel.org>" tags.
