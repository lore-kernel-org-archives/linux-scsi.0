From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.7-rc4
Date: Tue, 30 Oct 2012 21:29:24 -0700
Message-ID: <1351657764.1898.20.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Bernhard Kohl <bernhard.kohl@nsn.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

The following are the current target pending fixes headed for v3.7-rc4
code.  This includes the following highlights:

- Fix long-standing qla2xxx target bug where certain fc_port_t state
transitions could cause the internal session b-tree list to become
out-of-sync. (Roland)
- Fix task management double free of se_cmd descriptor in exception path
for users of target_submit_tmr(). (nab)
- Re-introduce simple NOP emulation of REZERO_UNIT, SEEK_6, and SEEK_10
SCSI-2 commands in order to support legacy initiators that still require
them.  (Bernhard)

Note these three patches are also CC'ed to stable.

Also, there a couple of outstanding (external) regressions that are
still being tracked down for tcm_fc(FCoE) and tcm_vhost fabrics for
v3.7.0 code, so please expect another PULL as these issues identified ->
resolved.

Thank you,

--nab

Bernhard Kohl (1):
  target: reintroduce some obsolete SCSI-2 commands

Nicholas Bellinger (2):
  qla2xxx: Add missing ->vport_slock while calling qlt_update_vp_map
  target: Fix double-free of se_cmd in target_complete_tmr_failure

Roland Dreier (2):
  tcm_qla2xxx: Format VPD page 83h SCSI name string according to SPC
  qla2xxx: Update target lookup session tables when a target session
    changes

 drivers/scsi/qla2xxx/qla_mid.c         |    3 +
 drivers/scsi/qla2xxx/qla_target.c      |   25 +++++------
 drivers/scsi/qla2xxx/qla_target.h      |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |   77 +++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h     |    2 +
 drivers/target/target_core_sbc.c       |   18 +++++++
 drivers/target/target_core_transport.c |    1 -
 7 files changed, 111 insertions(+), 16 deletions(-)
