From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/11] IB/srp: Add multichannel support
Date: Thu, 30 Oct 2014 14:44:14 +0100
Message-ID: <545240AE.6060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:52385 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760029AbaJ3No0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 09:44:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

Although the SRP protocol supports multichannel operation, although 
since considerable time RDMA HCA's are available that support multiple 
completion vectors and although multichannel operation yields better 
performance than using a single channel, the Linux SRP initiator does 
not yet support multichannel operation. Hence this patch series that 
adds multichannel support to the SRP initiator driver.

Changes between v2 and v3:
* Eliminated the new function blk_mq_build_unique_tag() from patch 1.
* Elaborated the nr_hw_queues documentation in patch 2 as requested by
   Martin.
* Merged patches v2/10 and v2/11 into a single patch (v3/9).
* Removed a debug statement from the patch that adds multichannel
   support, and added another new debug statement
   (WARN_ON_ONCE(scmnd->request->tag < 0) in srp_queuecommand()).
* Added a new patch (v3/11) that fixes a recently reported race
   condition. Although that patch is unrelated to adding multichannel
   support, that patch has been added to this series to avoid merge
   conflicts by submitting patches for the same driver to different
   maintainers.

Changes between v1 and v2:
* Added a function to the block layer that allows SCSI LLDs to query
   the blk-mq hardware context index chosen by the block layer. Removed
   the mq_queuecommand callback again.
* Added support for multiple hardware queues in the TCQ functions in
   the SCSI core.
* Split a few patches and elaborated the patch descriptions to make it
   easier to review this patch series.
* Added two new patches: one patch that makes the SRP initiator always
   use block layer tags and another patch that realizes a micro-
   optimization, namely elimination of the free requests list.

The patches in this series are:
0001-blk-mq-Add-blk_mq_unique_tag.patch
0002-scsi-mq-Add-support-for-multiple-hardware-queues.patch
0003-scsi_tcq.h-Add-support-for-multiple-hardware-queues.patch
0004-IB-srp-Move-ib_destroy_cm_id-call-into-srp_free_ch_i.patch
0005-IB-srp-Remove-stale-connection-retry-mechanism.patch
0006-IB-srp-Avoid-that-I-O-hangs-due-to-a-cable-pull-duri.patch
0007-IB-srp-Introduce-two-new-srp_target_port-member-vari.patch
0008-IB-srp-Separate-target-and-channel-variables.patch
0009-IB-srp-Use-block-layer-tags.patch
0010-IB-srp-Add-multichannel-support.patch
0011-IB-srp-Fix-a-race-condition-triggered-by-destroying-.patch
