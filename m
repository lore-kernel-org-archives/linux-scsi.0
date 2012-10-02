From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] target: Add target_submit_cmd_map_mem and convert tcm_loop+tcm_vhost
Date: Tue,  2 Oct 2012 07:15:43 +0000
Message-ID: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57832 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JBHVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 03:21:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi hch & Co,

This series adds a new target_submit_cmd_map_mem() caller to accept
pre-allocated SGL memory within the core generic I/O submission path.
Patch #1 contains the core I/O changes, patch #2 + #4 includes the
conversion of tcm_loop+tcm_vhost to use this new caller -> drop their
internal open-coded equivalents using transport_generic_map_mem_to_cmd().

Patch #3 carries forward a work-around for tcm_loop w/ scsi-generic with
user-space code that does not zero out it's READ payload buffer + ends
up passing a payload filled with random data into target core's control CDB
emulation.  Since we're not using bounce buffers any more for control
CDB emulation in modern v3.x code, AFAICT tcm_loop still requires this
extra bit to function properly with some legacy user-space code.

Regardless, the main I/O path changes end up being very mechnical in
nature for existing core and fabric code, and has been running as expected
with fio small-block workloads last hours.

Please review.

Thanks Christoph!

--nab

Nicholas Bellinger (4):
  target: Add target_submit_cmd_map_mem for SGL fabric memory
    passthrough
  tcm_loop: Convert I/O path to use target_submit_cmd_map_mem
  target: Add TARGET_SCF_MAP_CLEAR_MEM work-around for tcm_loop
  tcm_vhost: Convert I/O path to use target_submit_cmd_map_mem

 drivers/target/loopback/tcm_loop.c     |   62 ++-------------
 drivers/target/target_core_transport.c |  129 ++++++++++++++++++++++++++------
 drivers/vhost/tcm_vhost.c              |   68 ++++-------------
 drivers/vhost/tcm_vhost.h              |    8 ++
 include/target/target_core_base.h      |    2 +
 include/target/target_core_fabric.h    |    3 +
 6 files changed, 141 insertions(+), 131 deletions(-)

-- 
1.7.2.5

