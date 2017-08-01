From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/2] nvmet_fc: work around overalloc of queue elements
Date: Tue,  1 Aug 2017 15:12:38 -0700
Message-ID: <20170801221240.31723-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33686 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbdHAWNy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 18:13:54 -0400
Received: by mail-wm0-f66.google.com with SMTP id q189so4970120wmd.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2017 15:13:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>

At queue creation, the transport allocates a local job struct
(struct nvmet_fc_fcp_iod) for each possible element of the queue.
When a new CMD is received from the wire, a jobs struct is allocated
from the queue and then used for the duration of the command.
The job struct contains buffer space for the wire command iu. Thus,
upon allocation of the job struct, the cmd iu buffer is copied to
the job struct and the LLDD may immediately free/reuse the CMD IU
buffer passed in the call.

However, in some circumstances, due to the packetized nature of FC
and the api of the FC LLDD which may issue a hw command to send the
wire response, but the LLDD may not get the hw completion for the
command and upcall the nvmet_fc layer before a new command may be
asynchronously received on the wire. In other words, its possible
for the initiator to get the response from the wire, thus believe a
command slot free, and send a new command iu. The new command iu
may be received by the LLDD and passed to the transport before the
LLDD had serviced the hw completion and made the teardown calls for
the original job struct. As such, there is no available job struct
available for the new io. E.g. it appears like the host sent more
queue elements than the queue size. It didn't based on it's
understanding.

Rather than treat this temporarily overflow of the queue resources
as a hard connection failure, change the api slightly to temporarily
queue the new command until the job resource is freed up. The impact
to the LLDD is in the cases where release can't be immediate, the
LLDD must wait until a new callback is called notifying the release
of the cmd iu buffer. Support for this api change is indicated by a
non-null callback function, and the new buffer-held semantic is
indicated by an -EOVERFLOW status code return from
nvmet_fc_rcv_fcp_req().


James Smart (2):
  nvmet_fc: add defer_req callback for deferment of cmd buffer return
  lpfc: support nvmet_fc defer_rcv callback

 drivers/nvme/target/fc.c         | 212 +++++++++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_attr.c    |   4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |   5 +-
 drivers/scsi/lpfc/lpfc_nvmet.c   |  30 ++++++
 drivers/scsi/lpfc/lpfc_nvmet.h   |   1 +
 include/linux/nvme-fc-driver.h   |   7 ++
 6 files changed, 229 insertions(+), 30 deletions(-)

-- 
2.13.1
