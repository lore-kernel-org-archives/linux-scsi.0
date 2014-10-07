From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 0/12] IB/srp: Add multichannel support
Date: Tue, 07 Oct 2014 15:01:49 +0200
Message-ID: <5433E43D.3010107@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Although the SRP protocol supports multichannel operation, although 
since considerable time RDMA HCA's are available that support multiple 
completion vectors and although multichannel operation yields better 
performance than using a single channel, the Linux SRP initiator does 
not yet support multichannel operation. Hence this patch series that 
adds multichannel support to the SRP initiator driver.

The changes compared to the previous version of this patch series are as 
follows:
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
0001-blk-mq-Use-all-available-hardware-queues.patch
0002-blk-mq-Add-blk_mq_unique_tag.patch
0003-scsi-mq-Add-support-for-multiple-hardware-queues.patch
0004-scsi_tcq.h-Add-support-for-multiple-hardware-queues.patch
0005-IB-srp-Move-ib_destroy_cm_id-call-into-srp_free_ch_i.patch
0006-IB-srp-Remove-stale-connection-retry-mechanism.patch
0007-IB-srp-Avoid-that-I-O-hangs-due-to-a-cable-pull-duri.patch
0008-IB-srp-Introduce-two-new-srp_target_port-member-vari.patch
0009-IB-srp-Separate-target-and-channel-variables.patch
0010-IB-srp-Use-block-layer-tags.patch
0011-IB-srp-Eliminate-free_reqs-list.patch
0012-IB-srp-Add-multichannel-support.patch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
