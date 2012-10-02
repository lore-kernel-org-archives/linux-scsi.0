From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 0/4] target: Add target_submit_cmd_map_sgls + convert tcm_loop+tcm_vhost
Date: Tue,  2 Oct 2012 21:16:54 +0000
Message-ID: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here is a -v2 of the series to allow target_submit_cmd() logic to accept SGL
passthrough memory using existing transport_generic_map_mem_to_cmd() code
based upon hch's feedback this morning.

The changelog from v1 -> v2 includes:

- Rename target_submit_cmd_map_mem() -> target_submit_cmd_map_sgls()
  and export kernel symbol to fabrics.
- Drop TARGET_SCF_MAP_MEM flag in favor of non zero sgl_count check
- Drop TARGET_SCF_MAP_CLEAR_MEM flag, and zero control CDB READ payload
  for all fabrics doing SGL passthrough
- Update tcm_loop+tcm_vhost to use target_submit_cmd_map_sgls

All of the v2 changes are straight-forward enough, but please let us know
if there are any more concerns here.

Thank you!

--nab

Nicholas Bellinger (4):
  target: Add target_submit_cmd_map_sgls for SGL fabric memory
    passthrough
  tcm_loop: Convert I/O path to use target_submit_cmd_map_sgls
  target: Add control CDB READ payload zero work-around
  tcm_vhost: Convert I/O path to use target_submit_cmd_map_sgls

 drivers/target/loopback/tcm_loop.c     |   62 +++--------------------
 drivers/target/target_core_transport.c |   84 ++++++++++++++++++++++++++++++--
 drivers/vhost/tcm_vhost.c              |   68 +++++--------------------
 drivers/vhost/tcm_vhost.h              |    8 +++
 include/target/target_core_fabric.h    |    3 +
 5 files changed, 112 insertions(+), 113 deletions(-)

-- 
1.7.2.5
