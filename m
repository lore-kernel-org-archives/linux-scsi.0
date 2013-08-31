From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL -v2] target fixes for v3.11
Date: Sat, 31 Aug 2013 16:14:45 -0700
Message-ID: <1377990885.32763.335.camel@haakon3.risingtidesystems.com>
References: <1377921190.32763.327.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377921190.32763.327.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, CAD <cad.ext@larioja.org>
List-Id: linux-scsi@vger.kernel.org

Hi again Linus,

On Fri, 2013-08-30 at 20:53 -0700, Nicholas A. Bellinger wrote:
> Hi Linus,
> 
> Here is a -v2 PULL request for the current set of target-pending fixes
> for v3.11.  These fixes have not hit mainline yet, so I'm resending them
> now to be sure they hit v3.11 before the merge window opens.  Please let
> me know if you have any concerns with the series.
> 
> The original PULL request from last Saturday is here:
> 
> http://marc.info/?l=linux-kernel&m=137737916904812&w=2
> 
> Please go ahead and pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
> 
> The first patch is to address a long standing issue where INQUIRY vendor
> + model response data was not correctly padded with ASCII spaces,
> causing MSFT and Falconstor multipath stacks to not function with our
> LUNs.
> 
> The remaining patches are additional iscsi-target regression fixes for
> the post >= v3.10 iser-target changes.  The second and third are failure
> cases that have appeared during further testing, and the forth is only
> reproducible with malformed NOP packets.
> 
> The last three patches are CC'ed to stable, and the first one will be
> sent to Greg-KH separately.
> 

One more late v3.11 specific regression fix has been pushed into
target-pending/master for this series.

The updated diffstat should read:

Nicholas Bellinger (5):
  target: Fix trailing ASCII space usage in INQUIRY vendor+model
  iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10
  iscsi-target: Fix iscsit_transport reference leak during NP thread
    reset
  iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject
  target: Fix se_cmd->state_list leak regression during WRITE failure

 drivers/target/iscsi/iscsi_target.c       |   17 ++++++++++-------
 drivers/target/iscsi/iscsi_target_login.c |    9 ++++-----
 drivers/target/target_core_spc.c          |    9 ++++++---
 drivers/target/target_core_transport.c    |   11 +++++++++++
 4 files changed, 31 insertions(+), 15 deletions(-)

The full diff is included below.

Please PULL.

Thank you,

--nab

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f73da43..3a17930 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1086,7 +1086,6 @@ int iscsit_process_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
                if (cmd->reject_reason)
                        return 0;
 
-               target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
                return 1;
        }
        /*
@@ -1124,14 +1123,10 @@ after_immediate_data:
                 */
                cmdsn_ret = iscsit_sequence_cmd(cmd->conn, cmd,
                                        (unsigned char *)hdr, hdr->cmdsn);
-               if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER) {
+               if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
                        return -1;
-               } else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
-                       target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
-                       return 0;
-               }
 
-               if (cmd->sense_reason) {
+               if (cmd->sense_reason || cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
                        int rc;
 
                        rc = iscsit_dump_data_payload(cmd->conn,
@@ -1527,6 +1522,10 @@ int iscsit_setup_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
        if (hdr->itt == RESERVED_ITT && !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
                pr_err("NOPOUT ITT is reserved, but Immediate Bit is"
                        " not set, protocol error.\n");
+               if (!cmd)
+                       return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
+                                                (unsigned char *)hdr);
+
                return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
                                         (unsigned char *)hdr);
        }
@@ -1536,6 +1535,10 @@ int iscsit_setup_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
                        " greater than MaxXmitDataSegmentLength: %u, protocol"
                        " error.\n", payload_length,
                        conn->conn_ops->MaxXmitDataSegmentLength);
+               if (!cmd)
+                       return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
+                                                (unsigned char *)hdr);
+
                return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
                                         (unsigned char *)hdr);
        }
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 3402241..bc788c5 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1163,12 +1163,11 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
                if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
                        spin_unlock_bh(&np->np_thread_lock);
                        complete(&np->np_restart_comp);
-                       if (ret == -ENODEV) {
-                               iscsit_put_transport(conn->conn_transport);
-                               kfree(conn);
-                               conn = NULL;
+                       iscsit_put_transport(conn->conn_transport);
+                       kfree(conn);
+                       conn = NULL;
+                       if (ret == -ENODEV)
                                goto out;
-                       }
                        /* Get another socket */
                        return 1;
                }
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 4cb667d..9fabbf7 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -97,9 +97,12 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 
        buf[7] = 0x2; /* CmdQue=1 */
 
-       snprintf(&buf[8], 8, "LIO-ORG");
-       snprintf(&buf[16], 16, "%s", dev->t10_wwn.model);
-       snprintf(&buf[32], 4, "%s", dev->t10_wwn.revision);
+       memcpy(&buf[8], "LIO-ORG ", 8);
+       memset(&buf[16], 0x20, 16);
+       memcpy(&buf[16], dev->t10_wwn.model,
+              min_t(size_t, strlen(dev->t10_wwn.model), 16));
+       memcpy(&buf[32], dev->t10_wwn.revision,
+              min_t(size_t, strlen(dev->t10_wwn.revision), 4));
        buf[4] = 31; /* Set additional length to 31 */
 
        return 0;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7172d00..d8e49d7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2134,6 +2134,7 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
+       unsigned long flags;
        int ret = 0;
 
        if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
@@ -2144,6 +2145,16 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
        } else {
                if (wait_for_tasks)
                        transport_wait_for_tasks(cmd);
+               /*
+                * Handle WRITE failure case where transport_generic_new_cmd()
+                * has already added se_cmd to state_list, but fabric has
+                * failed command before I/O submission.
+                */
+               if (cmd->state_active) {
+                       spin_lock_irqsave(&cmd->t_state_lock, flags);
+                       target_remove_from_state_list(cmd);
+                       spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+               }
 
                if (cmd->se_lun)
                        transport_lun_remove_cmd(cmd);
