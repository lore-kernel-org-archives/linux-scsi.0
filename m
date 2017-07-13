From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.13-rc1
Date: Thu, 13 Jul 2017 13:29:29 -0700
Message-ID: <1499977769.7987.55.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-x7WE1E9N8FaVXYlps79c"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Himanshu Madhani <himanshu.madhani@cavium.com>, Quinn Tran <quinn.tran@cavium.com>
List-Id: linux-scsi@vger.kernel.org


--=-x7WE1E9N8FaVXYlps79c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Linus,

Here are the target-pending updates for v4.13-rc1.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Note there is a qla2xxx conflict with scsi.git as reported by SFR, which
should be straight-forward to resolve:

https://lkml.org/lkml/2017/6/28/45

Note there was two additional qla2xxx conflicts with scsi.git:

https://lkml.org/lkml/2017/7/3/22
https://lkml.org/lkml/2017/7/3/23

However, the patch that caused these has since been reverted:

  55dd8cf Revert "qla2xxx: Fix incorrect tcm_qla2xxx_free_cmd use during TMR ABORT"

as it caused other problems, so these conflicts can be ignored.

Attached is v4.13-rc1-resolution.diff if there are any questions wrt to
how the resolution should look.  Adding Himanshu + Quinn CC'.

That said, it's been usually busy for summer, with most of the efforts
centered around TCMU developments and various target-core + fabric
driver bug fixing activities.  Not particularly large in terms of LoC,
but lots of smaller patches from many different folks.

The highlights include:

- ibmvscsis logical partition manager support (Michael Cyr + Bryant Ly)
- Convert target/iblock WRITE_SAME to blkdev_issue_zeroout (hch + nab)
- Add support for TMR percpu LUN reference counting (nab)
- Fix a potential deadlock between EXTENDED_COPY and iscsi shutdown (Bart)
- Fix COMPARE_AND_WRITE caw_sem leak during se_cmd quiesce (Jiang Yi)
- Fix TMCU module removal (Xiubo Li)
- Fix iser-target OOPs during login failure (Andrea Righi + Sagi)
- Breakup target-core free_device backend driver callback (mnc)
- Perform TCMU add/delete/reconfig synchronously (mnc)
- Fix TCMU  multiple UIO open/close sequences (mnc)
- Fix TCMU CHECK_CONDITION sense handling (mnc)
- Fix target-core SAM_STAT_BUSY + TASK_SET_FULL handling (mnc + nab)
- Introduce TYPE_ZBC support in PSCSI (Damien Le Moal)
- Fix possible TCMU memory leak + OOPs when recalculating cmd base size
  (Xiubo Li + Bryant Ly + Damien Le Moal + mnc)
- Add login_keys_workaround attribute for non RFC initiators
  (Robert LeBlanc + Arun Easi + nab)

Thank you,

--nab

Bart Van Assche (17):
  target: Use symbolic value for WRITE_VERIFY_16
  target: Remove se_device.dev_list
  target: Fix transport_init_se_cmd()
  target: Use {get,put}_unaligned_be*() instead of open coding these
    functions
  target: Fix a deadlock between the XCOPY code and iSCSI session
    shutdown
  IB/srpt: Make a debug statement in srpt_abort_cmd() more informative
  xen/scsiback: Fix a TMR related use-after-free
  xen/scsiback: Replace a waitqueue and a counter by a completion
  xen/scsiback: Make TMF processing slightly faster
  target: Introduce a function that shows the command state
  target/tcm_loop: Merge struct tcm_loop_cmd and struct tcm_loop_tmr
  target/tcm_loop: Replace a waitqueue and a counter by a completion
  target/tcm_loop: Use target_submit_tmr() instead of open-coding this
    function
  target/tcm_loop: Make TMF processing slightly faster
  target/iscsi: Remove second argument of __iscsit_free_cmd()
  target/iscsi: Simplify iscsit_free_cmd()
  target/iscsi: Remove dead code from iscsit_process_scsi_cmd()

Bryant G. Ly (7):
  ibmvscsis: Use tpgt passed in by user
  tcmu: Support emulate_write_cache
  tcmu: Add netlink for device reconfiguration
  tcmu: Make dev_size configurable via userspace
  tcmu: Make dev_config configurable
  tcmu: Add Type of reconfig into netlink
  tcmu: Fix dev_config_store

Byungchul Park (1):
  vhost/scsi: Don't reinvent the wheel but use existing llist API

Colin Ian King (2):
  tcmu: make array tcmu_attrib_attrs static const
  target: make device_mutex and device_list static

Damien Le Moal (2):
  target: Use macro for WRITE_VERIFY_32 operation codes
  target: pscsi: Introduce TYPE_ZBC support

Gustavo A. R. Silva (1):
  target: remove dead code

Jiang Yi (2):
  target: reject COMPARE_AND_WRITE if emulate_caw is not set
  target: Fix COMPARE_AND_WRITE caw_sem leak during se_cmd quiesce

Michael Cyr (1):
  ibmvscsis: Enable Logical Partition Migration Support

Mike Christie (17):
  tcmu: reconfigure netlink attr changes
  target: break up free_device callback
  target: use idr for se_device dev index
  target: add helper to find se_device by dev_index
  tcmu: perfom device add, del and reconfig synchronously
  target: add helper to iterate over devices
  xcopy: loop over devices using idr helper
  target: remove g_device_list
  tcmu: drop configured check in destroy
  tcmu: fix multiple uio open/close sequences
  target: do not require a transport_complete for
    SCF_TRANSPORT_TASK_SENSE
  target: add helper to copy sense to se_cmd buffer
  tcmu: fix sense handling during completion
  pscsi: finish cmd processing from pscsi_req_done
  target: remove transport_complete
  target: fix SAM_STAT_BUSY/TASK_SET_FULL handling
  target: export lio pgr/alua support as device attr

Nicholas Bellinger (12):
  target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout
  target/configfs: Kill se_device->dev_link_magic
  target/configfs: Kill se_lun->lun_link_magic
  iscsi-target: Avoid holding ->tpg_state_lock during param update
  target: Add support for TMR percpu reference counting
  target: Add TARGET_SCF_LOOKUP_LUN_FROM_TAG support for ABORT_TASK
  qla2xxx: Convert QLA_TGT_ABTS to TARGET_SCF_LOOKUP_LUN_FROM_TAG
  iscsi-target: Kill left-over iscsi_target_do_cleanup
  iser-target: Avoid isert_conn->cm_id dereference in
    isert_login_recv_done
  qla2xxx: Fix incorrect tcm_qla2xxx_free_cmd use during TMR ABORT
  Revert "qla2xxx: Fix incorrect tcm_qla2xxx_free_cmd use during TMR
    ABORT"
  iscsi-target: Add login_keys_workaround attribute for non RFC
    initiators

Tang Wenji (2):
  target: Fix cmd size for PR-OUT in passthrough_parse_cdb
  target: Fix return sense reason in target_scsi3_emulate_pr_out

Xiubo Li (4):
  tcmu: Fix module removal due to stuck unmap_thread thread again
  tcmu: Fix flushing cmd entry dcache page
  tcmu: Fix possbile memory leak / OOPs when recalculating cmd base size
  tcmu: clean up the code and with one small fix

 drivers/infiniband/ulp/isert/ib_isert.c        |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   4 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c       | 156 ++++++++-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h       |  25 +-
 drivers/scsi/ibmvscsi_tgt/libsrp.h             |   5 +-
 drivers/scsi/qla2xxx/qla_target.c              |  39 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |   4 +-
 drivers/target/iscsi/iscsi_target.c            |  10 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   2 +
 drivers/target/iscsi/iscsi_target_nego.c       |  30 +-
 drivers/target/iscsi/iscsi_target_parameters.c |  41 ++-
 drivers/target/iscsi/iscsi_target_parameters.h |   2 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |  27 +-
 drivers/target/iscsi/iscsi_target_tpg.h        |   1 +
 drivers/target/iscsi/iscsi_target_util.c       |  60 +---
 drivers/target/iscsi/iscsi_target_util.h       |   2 +-
 drivers/target/loopback/tcm_loop.c             |  77 +----
 drivers/target/loopback/tcm_loop.h             |   6 +-
 drivers/target/target_core_alua.c              |   8 +-
 drivers/target/target_core_configfs.c          |  30 +-
 drivers/target/target_core_device.c            | 145 ++++++--
 drivers/target/target_core_fabric_configfs.c   |  25 +-
 drivers/target/target_core_fabric_lib.c        |   6 +-
 drivers/target/target_core_file.c              |   7 +-
 drivers/target/target_core_iblock.c            |  52 +--
 drivers/target/target_core_internal.h          |   5 +-
 drivers/target/target_core_pr.c                | 109 ++----
 drivers/target/target_core_pscsi.c             |  82 ++---
 drivers/target/target_core_pscsi.h             |   4 -
 drivers/target/target_core_rd.c                |  11 +-
 drivers/target/target_core_sbc.c               |  65 ++--
 drivers/target/target_core_spc.c               |  42 ++-
 drivers/target/target_core_tmr.c               |  18 +-
 drivers/target/target_core_tpg.c               |   1 -
 drivers/target/target_core_transport.c         | 222 ++++++++++--
 drivers/target/target_core_user.c              | 447 ++++++++++++++++++++++---
 drivers/target/target_core_xcopy.c             | 184 ++++++----
 drivers/vhost/scsi.c                           |  11 +-
 drivers/xen/xen-scsiback.c                     |  36 +-
 include/scsi/scsi_proto.h                      |   1 +
 include/target/iscsi/iscsi_target_core.h       |  10 +-
 include/target/target_core_backend.h           |  17 +-
 include/target/target_core_base.h              |  11 +-
 include/target/target_core_fabric.h            |   1 +
 include/uapi/linux/target_core_user.h          |  12 +
 45 files changed, 1356 insertions(+), 699 deletions(-)

--=-x7WE1E9N8FaVXYlps79c
Content-Disposition: attachment; filename="v4.13-rc1-resolution.diff"
Content-Type: text/x-patch; name="v4.13-rc1-resolution.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --cc drivers/scsi/qla2xxx/qla_target.c
index 2a0173e,401e245..0000000
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@@ -1874,36 -1847,13 +1874,13 @@@ static int __qlt_24xx_handle_abts(struc
  	struct abts_recv_from_24xx *abts, struct fc_port *sess)
  {
  	struct qla_hw_data *ha = vha->hw;
- 	struct se_session *se_sess = sess->se_sess;
  	struct qla_tgt_mgmt_cmd *mcmd;
- 	struct qla_tgt_cmd *cmd;
- 	struct se_cmd *se_cmd;
  	int rc;
- 	bool found_lun = false;
- 	unsigned long flags;
- 
- 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
- 	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
- 		if (se_cmd->tag == abts->exchange_addr_to_abort) {
- 			found_lun = true;
- 			break;
- 		}
- 	}
- 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
  
- 	/* cmd not in LIO lists, look in qla list */
- 	if (!found_lun) {
- 		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
- 			/* send TASK_ABORT response immediately */
- 			qlt_24xx_send_abts_resp(ha->base_qpair, abts,
- 			    FCP_TMF_CMPL, false);
- 			return 0;
- 		} else {
- 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
- 			    "unable to find cmd in driver or LIO for tag 0x%x\n",
- 			    abts->exchange_addr_to_abort);
- 			return -ENOENT;
- 		}
+ 	if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
+ 		/* send TASK_ABORT response immediately */
 -		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
++		qlt_24xx_send_abts_resp(ha->base_qpair, abts, FCP_TMF_CMPL, false);
+ 		return 0;
  	}
  
  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
@@@ -1919,14 -1869,16 +1896,17 @@@
  	}
  	memset(mcmd, 0, sizeof(*mcmd));
  
- 	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
  	mcmd->sess = sess;
  	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 -	mcmd->reset_count = vha->hw->chip_reset;
 +	mcmd->reset_count = ha->base_qpair->chip_reset;
  	mcmd->tmr_func = QLA_TGT_ABTS;
 +	mcmd->qpair = ha->base_qpair;
  
- 	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, cmd->unpacked_lun, mcmd->tmr_func,
+ 	/*
+ 	 * LUN is looked up by target-core internally based on the passed
+ 	 * abts->exchange_addr_to_abort tag.
+ 	 */
+ 	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, mcmd->tmr_func,
  	    abts->exchange_addr_to_abort);
  	if (rc != 0) {
  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,

--=-x7WE1E9N8FaVXYlps79c--
