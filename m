From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.9-rc7
Date: Fri, 12 Apr 2013 15:18:54 -0700
Message-ID: <1365805134.26011.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are remaining target-pending items for v3.9-rc7 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The tcm_vhost patches are more than I'd usually include in a -rc7 PULL,
but are changes required for v3.9 to work correctly with the pending
vhost-scsi-pci QEMU upstream series merge.  (Paolo CC'ed)

Plus Asias's conversion to use vhost_virtqueue->private_data + RCU for
managing vhost-scsi endpoints has gotten alot of review + testing over
the past weeks, and MST has ACKed the full series.

Also, there is a target patch to fix a long-standing bug within control
CDB handling with Standby/Offline/Transition ALUA port access states,
that had been incorrectly rejecting the control CDBs required for LUN
scan to work during these port group states.  CC'ing to stable.

Thank you,

--nab

Asias He (7):
  tcm_vhost: Use ACCESS_ONCE for vs->vs_tpg[target] access
  tcm_vhost: Use vq->private_data to indicate if the endpoint is setup
  tcm_vhost: Initialize vq->last_used_idx when set endpoint
  tcm_vhost: Remove double check of response
  tcm_vhost: Fix tv_cmd leak in vhost_scsi_handle_vq
  tcm_vhost: Add vhost_scsi_send_bad_target() helper
  tcm_vhost: Send bad target to guest when cmd fails

Nicholas Bellinger (1):
  target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition
    CDBs

 drivers/target/target_core_alua.c |    3 +
 drivers/vhost/tcm_vhost.c         |  198 ++++++++++++++++++++++++-------------
 2 files changed, 133 insertions(+), 68 deletions(-)

-- 
1.7.2.5
