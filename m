From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: IB/isert: Return value of iser target transport handlers ignored
 by iscsi target
Date: Sun, 7 Aug 2016 20:09:08 +0300
Message-ID: <8f3ad0ed-a17d-571a-7e1a-eb61caa263c9@grimberg.me>
References: <20160804103506.GA29543@t5fpga-b1.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160804103506.GA29543@t5fpga-b1.asicdesigners.com>
Sender: target-devel-owner@vger.kernel.org
To: Potnuri Bharat Teja <bharat@chelsio.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, swise@opengridcomputing.com, varun@chelsio.com, rajur@chelsio.com
List-Id: linux-scsi@vger.kernel.org

> Hi,

Hi Baharat,

> In iSER target during iwarp connection tear-down due to ping timeouts, the rdma
> queues are set to error state and subsequent queued iscsi session commands posted
> shall fail with corresponding errno returned by ib_post_send/recv.
> At this stage iser target handlers (Ex: isert_put_datain())
> return the error to iscsci target, but these errors are
> not being handled by the iscsi target handlers(Ex: lio_queue_status()).

Indeed looks like lio_queue_data_in() assumes that
->iscsit_queue_data_in() cannot fail. This either mean
that isert_put_data_in() should take care of
the extra put in this case, or the iscsi should correctly
handle a queue_full condition (because we should not be hitting
this in the normal IO flow).

Does this (untested) patch help?
--
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c 
b/drivers/infiniband/ulp/isert/ib_isert.c
index a990c04208c9..ff5dfc0f7c50 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1810,6 +1810,7 @@ isert_put_response(struct iscsi_conn *conn, struct 
iscsi_cmd *cmd)
         struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
         struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)
                                 &isert_cmd->tx_desc.iscsi_header;
+       int ret;

         isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
         iscsit_build_rsp_pdu(cmd, conn, true, hdr);
@@ -1848,7 +1849,10 @@ isert_put_response(struct iscsi_conn *conn, 
struct iscsi_cmd *cmd)

         isert_dbg("Posting SCSI Response\n");

-       return isert_post_response(isert_conn, isert_cmd);
+       ret = isert_post_response(isert_conn, isert_cmd);
+       if (ret)
+               target_put_sess_cmd(&cmd->se_cmd);
+       return 0;
  }

  static void
@@ -2128,7 +2132,7 @@ isert_put_datain(struct iscsi_conn *conn, struct 
iscsi_cmd *cmd)
         struct isert_conn *isert_conn = conn->context;
         struct ib_cqe *cqe = NULL;
         struct ib_send_wr *chain_wr = NULL;
-       int rc;
+       int ret;

         isert_dbg("Cmd: %p RDMA_WRITE data_length: %u\n",
                  isert_cmd, se_cmd->data_length);
@@ -2148,34 +2152,41 @@ isert_put_datain(struct iscsi_conn *conn, struct 
iscsi_cmd *cmd)
                 isert_init_send_wr(isert_conn, isert_cmd,
                                    &isert_cmd->tx_desc.send_wr);

-               rc = isert_post_recv(isert_conn, isert_cmd->rx_desc);
-               if (rc) {
-                       isert_err("ib_post_recv failed with %d\n", rc);
-                       return rc;
+               ret = isert_post_recv(isert_conn, isert_cmd->rx_desc);
+               if (ret) {
+                       isert_err("ib_post_recv failed with %d\n", ret);
+                       goto out;
                 }

                 chain_wr = &isert_cmd->tx_desc.send_wr;
         }

-       isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
+       ret = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
         isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ\n", 
isert_cmd);
-       return 1;
+out:
+       if (ret)
+               target_put_sess_cmd(&cmd->se_cmd);
+       return 0;
  }

  static int
  isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool 
recovery)
  {
         struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
+       int ret;

         isert_dbg("Cmd: %p RDMA_READ data_length: %u write_data_done: 
%u\n",
                  isert_cmd, cmd->se_cmd.data_length, cmd->write_data_done);

         isert_cmd->tx_desc.tx_cqe.done = isert_rdma_read_done;
-       isert_rdma_rw_ctx_post(isert_cmd, conn->context,
+       ret = isert_rdma_rw_ctx_post(isert_cmd, conn->context,
                         &isert_cmd->tx_desc.tx_cqe, NULL);

         isert_dbg("Cmd: %p posted RDMA_READ memory for ISER Data WRITE\n",
                  isert_cmd);+out:
+       if (ret)
+               target_put_sess_cmd(&cmd->se_cmd);
         return 0;
  }

--

>
> -> While closing the session in case of ping timeouts, isert_close_connection()->
> isert_wait_conn()->isert_wait4cmds() checks for the queued session commands
> and waits infinitely for command completion 'cmd_wait_comp' in target_wait_for_sess_cmds().
> 'cmd_wait_comp' will be never complete as the kref on the session command is
> not derefed, due to which target_release_cmd_kref() is not called by kref_put().
> Due to this, the older session is not cleared causing the next login negotiation to fail
> as the older session is still active(Older SID exists).

Makes sense...

> [Query 1] If the return value of ib_post_send/recv() are handled to deref the
> corresponding queued session commands, the wait on cmd_wait_comp will be
> complete and clears off the session successfully. Is this the rightway to
> do it here?

I think that given that ->iscsit_queue_data_in() and
->iscsit_queue_status() are never expected to fail we probably
should take care of it in isert...

Nic, any input on the iscsit side?

>
> [Query 2] An extra deref is done in case of transport_status CMD_T_TAS
> in target_wait_for_sess_cmds(), can similar
> implementation be done for transport state CMD_T_FABRIC_STOP?

I think that can work also given that target_sess_cmd_list_set_waiting()
is indeed set when we are starting teardown. Not sure how this will
affect other transports though...
