From: Laurence Oberman <loberman@redhat.com>
Subject: Chasing possible Intel driver issue on Intel Soft FCOE CNA card
Date: Sat, 11 Mar 2017 10:01:12 -0500 (EST)
Message-ID: <1565267428.909001.1489244472826.JavaMail.zimbra@redhat.com>
References: <1244470724.907349.1489243132066.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:46570 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdCKPBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Mar 2017 10:01:23 -0500
In-Reply-To: <1244470724.907349.1489243132066.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>, nab <nab@daterainc.com>
Cc: Curtis Taylor <cjt@us.ibm.com>, "James Forson (Global Solutions Support Engineering, HP Master
        Technologist)" <jim.forson@hpe.com>, Claus Vestergaard <claus.vestergaard@hpe.com>, Robert Pais <robert.pais@hpe.com>

Hello Nicholas

I am chasing the possibility of an OX_ID being prematurely re-used in the ixgbe and software fcoe stack
when we have congestion.
We have a situation where we have F/C traces showing this happening and in trying to track this down using LIO target as the array.

I bumped into this stack below for tcm_qla2xxx during the efforts.

Running performance tests via FCOE on the Intel card due to known issues in the resources of this card.
  See prior http://www.spinics.net/lists/linux-scsi/msg100505.html

Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)

We will get into blk_requeue_request() here because of the limited pool which is not unexpected

On the LIO array I see this and trying to understand if this is the software fcoe stack initiator causing this.
I can add whatever instrumentation needed to make progress.


static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
{
        struct qla_tgt_cmd *cmd = container_of(se_cmd,
                                struct qla_tgt_cmd, se_cmd);
        int xmit_type = QLA_TGT_XMIT_STATUS;

        cmd->bufflen = se_cmd->data_length;
        cmd->sg = NULL;
        cmd->sg_cnt = 0;
        cmd->offset = 0;
        cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
        if (cmd->cmd_flags &  BIT_5) {
                pr_crit("Bit_5 already set for cmd = %p.\n", cmd);              ********
                dump_stack();
        }

[ 3216.602652] Bit_5 already set for cmd = ffff928007b95a50.
[ 3216.628736] CPU: 8 PID: 396 Comm: kworker/8:1 Not tainted 4.9.0tcm_debug+ #1
[ 3216.662893] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 07/01/2015
[ 3216.694389] Workqueue: events target_qf_do_work [target_core_mod]
[ 3216.723595]  ffffb75c9a157db0 ffffffffbb3e924e ffff928007b95a50 ffff927584b8e058
[ 3216.758911]  ffffb75c9a157dc8 ffffffffc098fa57 ffff928007b95a50 ffffb75c9a157e18
[ 3216.794563]  ffffffffc0af2ca1 ffffb75c9a157dd8 ffffb75c9a157dd8 00000000a47f17db
[ 3216.829762] Call Trace:
[ 3216.841338]  [<ffffffffbb3e924e>] dump_stack+0x63/0x85
[ 3216.865694]  [<ffffffffc098fa57>] tcm_qla2xxx_queue_status+0xf7/0x110 [tcm_qla2xxx]
[ 3216.902302]  [<ffffffffc0af2ca1>] target_qf_do_work+0x1b1/0x300 [target_core_mod]
[ 3216.938148]  [<ffffffffbb0c3f6f>] process_one_work+0x15f/0x430
[ 3216.966349]  [<ffffffffbb0c428e>] worker_thread+0x4e/0x490
[ 3216.993094]  [<ffffffffbb0c4240>] ? process_one_work+0x430/0x430
[ 3217.021825]  [<ffffffffbb0c4240>] ? process_one_work+0x430/0x430
[ 3217.050700]  [<ffffffffbb0c9ab9>] kthread+0xd9/0xf0
[ 3217.073733]  [<ffffffffbb0c99e0>] ? kthread_park+0x60/0x60
[ 3217.100765]  [<ffffffffbb805cd5>] ret_from_fork+0x25/0x30

typedef enum {
        /*
         * BIT_0 - Atio Arrival / schedule to work
         * BIT_1 - qlt_do_work
         * BIT_2 - qlt_do work failed
         * BIT_3 - xfer rdy/tcm_qla2xxx_write_pending
         * BIT_4 - read respond/tcm_qla2xx_queue_data_in
         * BIT_5 - status respond / tcm_qla2xx_queue_status                *************
         * BIT_6 - tcm request to abort/Term exchange.
         *      pre_xmit_response->qlt_send_term_exchange
         * BIT_7 - SRR received (qlt_handle_srr->qlt_xmit_response)
         * BIT_8 - SRR received (qlt_handle_srr->qlt_rdy_to_xfer)
         * BIT_9 - SRR received (qla_handle_srr->qlt_send_term_exchange)
         * BIT_10 - Data in - hanlde_data->tcm_qla2xxx_handle_data

         * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
         * BIT_13 - Bad completion -
         *      qlt_ctio_do_completion --> qlt_term_ctio_exchange
         * BIT_14 - Back end data received/sent.
         * BIT_15 - SRR prepare ctio
         * BIT_16 - complete free
         * BIT_17 - flush - qlt_abort_cmd_on_host_reset
         * BIT_18 - completion w/abort status
         * BIT_19 - completion w/unknown status
         * BIT_20 - tcm_qla2xxx_free_cmd
         */
        CMD_FLAG_DATA_WORK = BIT_11,
        CMD_FLAG_DATA_WORK_FREE = BIT_21,
} cmd_flags_t;

Thanks
Laurence
