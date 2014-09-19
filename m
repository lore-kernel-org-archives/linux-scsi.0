From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC 0/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 14:55:27 +0200
Message-ID: <541C27BF.6070609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:46467 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaISMze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 08:55:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

Hello,

Although the SRP protocol supports multichannel operation, although 
since considerable time RDMA HCA's are available that support multiple 
completion vectors and although multichannel operation yields better 
performance than using a single channel, the Linux SRP initiator does 
not yet support multichannel operation. While adding multichannel 
support in the SRP initiator I encountered a few challenges of which I 
think these need wider discussion. The topics I would like invite wider 
discussion about are as follows:
- How to avoid unneeded inter-socket cache traffic. Should the blk-mq
   layer e.g. assign CPU cores to hardware queues such that all CPU cores
   associated with a single hardware queue reside on the same CPU socket?
   (see also patch 1/8)
- How to pass the hardware context selected by the block layer to the
   SCSI LLD queuecommand() callback function ? (see also patches 2/8 and
   3/8).
- Which approach should a SCSI LLD follow for selection of an MSI-X
   completion vector to ensure that the interrupt handler is invoked on
   the same CPU socket as the blk-mq hardware context data structures ?
   As one can see patch 8/8 relies on the assumption that completion
   vectors have been spread evenly over CPU sockets. If a HCA e.g.
   supports eight completion vectors then that means that in a system
   with two CPU sockets vectors 0-3 are associated with a CPU core on
   the first CPU socket and vectors 4-7 with a CPU core on the second CPU
   socket.

The patches in this series are:
0001-blk-mq-Use-all-available-hardware-queues.patch
0002-scsi-mq-Add-support-for-multiple-hardware-queues.patch
0003-scsi-mq-Pass-hctx-to-low-level-SCSI-drivers.patch
0004-IB-srp-Move-ib_destroy_cm_id-call-into-srp_free_ch_i.patch
0005-IB-srp-Remove-stale-connection-retry-mechanism.patch
0006-IB-srp-Avoid-that-I-O-hangs-due-to-a-cable-pull-duri.patch
0007-IB-srp-Separate-target-and-channel-variables.patch
0008-IB-srp-Add-multichannel-support.patch

Note: a predecessor of this patch series has been used to measure the 
performance of Christoph's scsi-mq patches that have been merged in 
kernel version v3.17-rc1.
