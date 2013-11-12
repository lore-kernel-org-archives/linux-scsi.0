From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Tue, 12 Nov 2013 13:15:48 -0800
Message-ID: <1384290948.12281.91.camel@haakon3.risingtidesystems.com>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com>
	 <1384204653.12281.7.camel@haakon3.risingtidesystems.com>
	 <1384216960.12281.24.camel@haakon3.risingtidesystems.com>
	 <1384217317.12281.26.camel@haakon3.risingtidesystems.com>
	 <1384219874.12281.42.camel@haakon3.risingtidesystems.com>
	 <B9FFC16A-0592-498D-A7C3-7ABB3EFA61FD@cs.wisc.edu>
	 <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu>
	 <1384230893.12281.72.camel@haakon3.risingtidesystems.com>
	 <52824B3C.10203@cs.wisc.edu>
	 <697D97E420EE024FB7451B574CD4991BCA064F17@NTXBOIMBX05.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <697D97E420EE024FB7451B574CD4991BCA064F17@NTXBOIMBX05.micron.com>
Sender: target-devel-owner@vger.kernel.org
To: "Moussa Ba (moussaba)" <moussaba@micron.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-11-12 at 18:18 +0000, Moussa Ba (moussaba) wrote:

<SNIP>

> > >
> > > Or to put it another way: what is preventing iscsi_data_xmit() from
> > > completely draining both conn->cmdqueue + conn->requeue, even when
> > the
> > > CmdSN window has potentially been closed again..?
> > >
> > 
> > If the window was not big enough we would have not accepted the cmd
> > from
> > scsi-ml in iscsi_queuecommand. We would have never put it on the list
> > above then.
> > 
> > In the initiator we have:
> > 
> > session->queued_cmdsn - It will always be less than or equal to the
> > max_cmdsn, but greater than or equal to session->cmdsn. Think of it
> > like
> > preallocating the sn we are going to give the cmd. Depending on
> > ordering
> > it might be different (3 instead of 4), but the final value it gets
> > will
> > be less than the max_cmdsn.
> > 
> > session->cmdsn - the sn we give the cmd when we actually put it on the
> > wire. It is always less than or equal to queued_cmdsn.
> > 
> > So we have cmdsn <= queued_cmdsn <= max_cmdsn.
> > 
> > The iscsi_queuecommand window check makes sure we will only have put a
> > cmd on the cmdqueue list if queued_cmdsn was less than or equal to the
> > max_cmdsn. And cmdsn is less than or equal to queued_cmdsn, so we can
> > run iscsi_data_xmit without checking the window values again, because
> > it
> > is not possible for something like max_cmdsn to decrease on us.
> 
> 
> 
> I am attaching error codes on the inititator that seem to coincide with the timeout errors.
> 
> [  261.855254]  connection6:0: pdu (op 0x65 itt 0x1) rejected. Reason code 0x4
> [  261.855266]  connection6:0: pdu (op 0xa itt 0x1) rejected. Reason code 0x4
> [  261.855268]  connection6:0: pdu (op 0x51 itt 0x1) rejected. Reason code 0x4
> 
> 

Hi Moussa,

After a bit more review, there may be a scenario introduced with v3.10
code that could cause something like the reported CmdSN > MaxCmdSN error
to occur..

Care to attempt to reproduce with the following target patch..?

Thanks,

--nab

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index bbd86e8..5661075 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2029,8 +2029,6 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
        if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
                data_left = se_cmd->data_length;
-               iscsit_increment_maxcmdsn(cmd, conn->sess);
-               cmd->stat_sn = conn->stat_sn++;
        } else {
                sg_off = cmd->write_data_done / PAGE_SIZE;
                data_left = se_cmd->data_length - cmd->write_data_done;
@@ -2242,8 +2240,6 @@ isert_reg_rdma_frwr(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
        if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
                data_left = se_cmd->data_length;
-               iscsit_increment_maxcmdsn(cmd, conn->sess);
-               cmd->stat_sn = conn->stat_sn++;
        } else {
                sg_off = cmd->write_data_done / PAGE_SIZE;
                data_left = se_cmd->data_length - cmd->write_data_done;
@@ -2352,7 +2348,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
         * Build isert_conn->tx_desc for iSCSI response PDU and attach
         */
        isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-       iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
+       iscsit_build_rsp_pdu(cmd, conn, true, (struct iscsi_scsi_rsp *)
                             &isert_cmd->tx_desc.iscsi_header);
        isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
        isert_init_send_wr(isert_conn, isert_cmd,
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_config
index 1eec37c..fde3624 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1790,6 +1790,11 @@ static int lio_queue_status(struct se_cmd *se_cmd)
        struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
        cmd->i_state = ISTATE_SEND_STATUS;
+
+       if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
+               iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+               return 0;
+       }
        cmd->conn->conn_transport->iscsit_queue_status(cmd->conn, cmd);
 
        return 0;
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 6c7a510..7087c73 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -58,11 +58,7 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess
 
        cmd->maxcmdsn_inc = 1;
 
-       if (!mutex_trylock(&sess->cmdsn_mutex)) {
-               sess->max_cmd_sn += 1;
-               pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
-               return;
-       }
+       mutex_lock(&sess->cmdsn_mutex);
        sess->max_cmd_sn += 1;
        pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
        mutex_unlock(&sess->cmdsn_mutex);
