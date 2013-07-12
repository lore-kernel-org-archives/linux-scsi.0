From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ATTEND] scsi-mq prototype discussion
Date: Thu, 11 Jul 2013 17:23:32 -0700
Message-ID: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42240 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab3GLAS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jul 2013 20:18:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ksummit-2013-discuss@lists.linuxfoundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, kmo@daterainc.com, scameron@beardog.cce.hp.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <James.Smart@Emulex.Com>

Hello,

I would like to attend the 2013 Kernel Summit.

At the summit, I would like to discuss scsi-mq, a high performance SCSI
initiator prototype that utilizes the next-generation blk-mq effort by
Jens Axboe.  The long-term goal is a path to move beyond the
long-standing small block random I/O limitations vs. raw make_request
based drivers of the existing Linux/SCSI client stack.

Along with using blk-mq's excellent native per-cpu primitive + NUMA
local friendly queuing of pre-allocated struct request descriptor
memory, the scsi-mq prototype currently avoids all I/O fast-path access
of legacy scsi_host->host_lock, and bypasses existing scsi_request_fn()
dispatch into scsi-mq enabled LLD code.

It also allows scsi-core to eliminate all fast-path memory allocations
using struct scsi_cmnd + $LLD_CMD pre-allocations based on a per struct
blk_mq_hw_ctx -> scsi_device->sdev_mq_req context, along with per
scsi_cmnd descriptor pre-allocation of SGL and sense buffer memory.

So far the initial conversion of virtio-scsi + scsi-debug LLDs has been
completed.  Also, the intention is to keep the conversion requirements
for existing LLDs to scsi-mq as simple as possible.

There are still many areas that have been conveniently left out of the
initial prototype, including proper fast-path get_device() +
put_device() reference counting, a functioning scsi-generic IOCTL,
anything close to per struct scsi_device error handling, amongst other
things..

Drilling down the work items ahead of a real mainline push is high on
priority list for discussion.

The parties to be included in such a discussion are:

  - Jens Axboe (blk-mq author)
  - James Bottomley (scsi maintainer)
  - Christoph Hellwig (scsi)
  - Martin Petersen (scsi)
  - Tejun Heo (block + libata)
  - Hannes Reinecke (scsi error recovery)
  - Kent Overstreet (block, per-cpu ida)
  - Stephen Cameron (scsi-over-pcie driver)
  - Andrew Vasquez (qla2xxx LLD)
  - James Smart (lpfc LLD)

Thank you,

--nab

