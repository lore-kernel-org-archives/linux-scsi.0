From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 11/12] iser-target: Add logic for core
Date: Tue, 02 Apr 2013 15:36:25 -0700
Message-ID: <1364942185.3898.200.camel@haakon2.linux-iscsi.org>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
	 <1363996536-30644-12-git-send-email-nab@linux-iscsi.org>
	 <CAJZOPZK888O4Hjjhf9=BMbdM8kM7sF56uFYPPaM1LV1gn5DJ=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJZOPZK888O4Hjjhf9=BMbdM8kM7sF56uFYPPaM1LV1gn5DJ=w@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-04-03 at 00:24 +0300, Or Gerlitz wrote:
> On Sat, Mar 23, 2013 at 1:55 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > +static int
> > +isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
> > +{
> > +       struct isert_cmd *isert_cmd = container_of(cmd,
> > +                                       struct isert_cmd, iscsi_cmd);
> > +       struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> > +       struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr, *wr_failed;
> > +       struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)
> > +                               &isert_cmd->tx_desc.iscsi_header;
> > +       int ret;
> > +
> > +       isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
> > +       iscsit_build_rsp_pdu(cmd, conn, true, hdr);
> > +       isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
> > +       /*
> > +        * Attach SENSE DATA payload to iSCSI Response PDU
> > +        */
> > +       if (cmd->se_cmd.sense_buffer &&
> > +           ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
> > +           (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
> > +               struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> > +               struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
> > +               u32 padding, sense_len;
> > +
> > +               put_unaligned_be16(cmd->se_cmd.scsi_sense_length,
> > +                                  cmd->sense_buffer);
> > +               cmd->se_cmd.scsi_sense_length += sizeof(__be16);
> > +
> > +               padding = -(cmd->se_cmd.scsi_sense_length) & 3;
> > +               hton24(hdr->dlength, (u32)cmd->se_cmd.scsi_sense_length);
> > +               sense_len = cmd->se_cmd.scsi_sense_length + padding;
> > +
> > +               isert_cmd->sense_buf_dma = ib_dma_map_single(ib_dev,
> > +                               (void *)cmd->sense_buffer, sense_len,
> > +                               DMA_TO_DEVICE);
> > +
> > +               isert_cmd->sense_buf_len = sense_len;
> > +               ib_dma_sync_single_for_cpu(ib_dev, isert_cmd->sense_buf_dma,
> > +                                          sense_len, DMA_TO_DEVICE);
> > +               ib_dma_sync_single_for_device(ib_dev, isert_cmd->sense_buf_dma,
> > +                                             sense_len, DMA_TO_DEVICE);
> > +
> > +               tx_dsg->addr    = isert_cmd->sense_buf_dma;
> > +               tx_dsg->length  = sense_len;
> > +               tx_dsg->lkey    = isert_conn->conn_mr->lkey;
> > +               isert_cmd->tx_desc.num_sge = 2;
> > +       }
> > +
> > +       isert_cmd->rdma_wr.iser_ib_op = ISER_IB_SEND;
> 
> [...]
> > +       send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
> > +       send_wr->opcode = IB_WR_SEND;
> > +       send_wr->send_flags = IB_SEND_SIGNALED;
> > +       send_wr->sg_list = &isert_cmd->tx_desc.tx_sg[0];
> > +       send_wr->num_sge = isert_cmd->tx_desc.num_sge;
> > +       send_wr->next = NULL;
> [...]
> 
> These seven lines are repeated 3-5 times below, a quick question and suggestion:
> 
> 1. can't we do it beforehand?
> 2. we can move to helper function and call it when needed.
> 
> 

<nod>, adding common isert_init_send_wr() caller now.

--nab
