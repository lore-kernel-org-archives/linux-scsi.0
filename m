From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC-v2 11/12] iser-target: Add logic for core
Date: Wed, 3 Apr 2013 00:24:48 +0300
Message-ID: <CAJZOPZK888O4Hjjhf9=BMbdM8kM7sF56uFYPPaM1LV1gn5DJ=w@mail.gmail.com>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
	<1363996536-30644-12-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363996536-30644-12-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 23, 2013 at 1:55 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> +static int
> +isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
> +{
> +       struct isert_cmd *isert_cmd = container_of(cmd,
> +                                       struct isert_cmd, iscsi_cmd);
> +       struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> +       struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr, *wr_failed;
> +       struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)
> +                               &isert_cmd->tx_desc.iscsi_header;
> +       int ret;
> +
> +       isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
> +       iscsit_build_rsp_pdu(cmd, conn, true, hdr);
> +       isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
> +       /*
> +        * Attach SENSE DATA payload to iSCSI Response PDU
> +        */
> +       if (cmd->se_cmd.sense_buffer &&
> +           ((cmd->se_cmd.se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
> +           (cmd->se_cmd.se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
> +               struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> +               struct ib_sge *tx_dsg = &isert_cmd->tx_desc.tx_sg[1];
> +               u32 padding, sense_len;
> +
> +               put_unaligned_be16(cmd->se_cmd.scsi_sense_length,
> +                                  cmd->sense_buffer);
> +               cmd->se_cmd.scsi_sense_length += sizeof(__be16);
> +
> +               padding = -(cmd->se_cmd.scsi_sense_length) & 3;
> +               hton24(hdr->dlength, (u32)cmd->se_cmd.scsi_sense_length);
> +               sense_len = cmd->se_cmd.scsi_sense_length + padding;
> +
> +               isert_cmd->sense_buf_dma = ib_dma_map_single(ib_dev,
> +                               (void *)cmd->sense_buffer, sense_len,
> +                               DMA_TO_DEVICE);
> +
> +               isert_cmd->sense_buf_len = sense_len;
> +               ib_dma_sync_single_for_cpu(ib_dev, isert_cmd->sense_buf_dma,
> +                                          sense_len, DMA_TO_DEVICE);
> +               ib_dma_sync_single_for_device(ib_dev, isert_cmd->sense_buf_dma,
> +                                             sense_len, DMA_TO_DEVICE);
> +
> +               tx_dsg->addr    = isert_cmd->sense_buf_dma;
> +               tx_dsg->length  = sense_len;
> +               tx_dsg->lkey    = isert_conn->conn_mr->lkey;
> +               isert_cmd->tx_desc.num_sge = 2;
> +       }
> +
> +       isert_cmd->rdma_wr.iser_ib_op = ISER_IB_SEND;

[...]
> +       send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
> +       send_wr->opcode = IB_WR_SEND;
> +       send_wr->send_flags = IB_SEND_SIGNALED;
> +       send_wr->sg_list = &isert_cmd->tx_desc.tx_sg[0];
> +       send_wr->num_sge = isert_cmd->tx_desc.num_sge;
> +       send_wr->next = NULL;
[...]

These seven lines are repeated 3-5 times below, a quick question and suggestion:

1. can't we do it beforehand?
2. we can move to helper function and call it when needed.


















> +isert_put_tm_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
> +{
> +       struct isert_cmd *isert_cmd = container_of(cmd,
> +                               struct isert_cmd, iscsi_cmd);
> +       struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> +       struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr, *wr_failed;
> +       int ret;
> +
> +       isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
> +       iscsit_build_task_mgt_rsp(cmd, conn, (struct iscsi_tm_rsp *)
> +                                 &isert_cmd->tx_desc.iscsi_header);
> +       isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
> +
> +       isert_cmd->rdma_wr.iser_ib_op = ISER_IB_SEND;
> +       send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
> +       send_wr->opcode = IB_WR_SEND;
> +       send_wr->send_flags = IB_SEND_SIGNALED;
> +       send_wr->sg_list = &isert_cmd->tx_desc.tx_sg[0];
> +       send_wr->num_sge = isert_cmd->tx_desc.num_sge;
> +       send_wr->next = NULL;
> +
> +       pr_debug("Posting Task Management Response IB_WR_SEND >>>>>>>>>>>>>>>>>>>>>>\n");
> +
> +       atomic_inc(&isert_conn->post_send_buf_count);
> +
> +       ret = ib_post_send(isert_conn->conn_qp, &isert_cmd->tx_desc.send_wr,
> +                       &wr_failed);
> +       if (ret) {
> +               pr_err("isert_put_tm_rsp() failed to post wr: %d\n", ret);
> +               atomic_dec(&isert_conn->post_send_buf_count);
> +               return ret;
> +       }
> +       return 0;
> +}
> +
> +static int
> +isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
> +                   struct ib_sge *ib_sge, struct ib_send_wr *send_wr,
> +                   u32 data_left, u32 offset)
> +{
> +       struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
> +       struct scatterlist *sg_start, *tmp_sg;
> +       struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> +       u32 sg_off, page_off;
> +       int i = 0, sg_nents;
> +
> +       sg_off = offset / PAGE_SIZE;
> +       sg_start = &cmd->se_cmd.t_data_sg[sg_off];
> +       sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, isert_conn->max_sge);
> +       page_off = offset % PAGE_SIZE;
> +
> +       send_wr->sg_list = ib_sge;
> +       send_wr->num_sge = sg_nents;
> +       send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
> +       /*
> +        * Perform mapping of TCM scatterlist memory ib_sge dma_addr.
> +        */
> +       for_each_sg(sg_start, tmp_sg, sg_nents, i) {
> +               pr_debug("ISER RDMA from SGL dma_addr: 0x%16llx dma_len: %u, page_off: %u\n",
> +                        (unsigned long long)tmp_sg->dma_address,
> +                        tmp_sg->length, page_off);
> +
> +               ib_sge->addr = ib_sg_dma_address(ib_dev, tmp_sg) + page_off;
> +               ib_sge->length = min_t(u32, data_left,
> +                               ib_sg_dma_len(ib_dev, tmp_sg) - page_off);
> +               ib_sge->lkey = isert_conn->conn_mr->lkey;
> +
> +               pr_debug("RDMA ib_sge: addr: 0x%16llx  length: %u\n",
> +                        ib_sge->addr, ib_sge->length);
> +               page_off = 0;
> +               data_left -= ib_sge->length;
> +               ib_sge++;
> +               pr_debug("Incrementing ib_sge pointer to %p\n", ib_sge);
> +       }
> +
> +       pr_debug("Set outgoing sg_list: %p num_sg: %u from TCM SGLs\n",
> +                send_wr->sg_list, send_wr->num_sge);
> +
> +       return sg_nents;
> +}
> +
> +static int
> +isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
> +{
> +       struct se_cmd *se_cmd = &cmd->se_cmd;
> +       struct isert_cmd *isert_cmd = container_of(cmd,
> +                                       struct isert_cmd, iscsi_cmd);
> +       struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
> +       struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> +       struct ib_send_wr *wr_failed, *send_wr;
> +       struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> +       struct ib_sge *ib_sge;
> +       struct scatterlist *sg;
> +       u32 offset = 0, data_len, data_left, rdma_write_max;
> +       int rc, ret = 0, count, sg_nents, i, ib_sge_cnt;
> +
> +       pr_debug("RDMA_WRITE: data_length: %u\n", se_cmd->data_length);
> +
> +       sg = &se_cmd->t_data_sg[0];
> +       sg_nents = se_cmd->t_data_nents;
> +
> +       count = ib_dma_map_sg(ib_dev, sg, sg_nents, DMA_TO_DEVICE);
> +       if (unlikely(!count)) {
> +               pr_err("Unable to map put_datain SGs\n");
> +               return -EINVAL;
> +       }
> +       wr->sge = sg;
> +       wr->num_sge = sg_nents;
> +       pr_debug("Mapped IB count: %u sg: %p sg_nents: %u for RDMA_WRITE\n",
> +                count, sg, sg_nents);
> +
> +       ib_sge = kzalloc(sizeof(struct ib_sge) * sg_nents, GFP_KERNEL);
> +       if (!ib_sge) {
> +               pr_warn("Unable to allocate datain ib_sge\n");
> +               ret = -ENOMEM;
> +               goto unmap_sg;
> +       }
> +       isert_cmd->ib_sge = ib_sge;
> +
> +       pr_debug("Allocated ib_sge: %p from t_data_ents: %d for RDMA_WRITE\n",
> +                ib_sge, se_cmd->t_data_nents);
> +
> +       wr->send_wr_num = DIV_ROUND_UP(sg_nents, isert_conn->max_sge);
> +       wr->send_wr = kzalloc(sizeof(struct ib_send_wr) * wr->send_wr_num,
> +                               GFP_KERNEL);
> +       if (!wr->send_wr) {
> +               pr_err("Unable to allocate wr->send_wr\n");
> +               ret = -ENOMEM;
> +               goto unmap_sg;
> +       }
> +       pr_debug("Allocated wr->send_wr: %p wr->send_wr_num: %u\n",
> +                wr->send_wr, wr->send_wr_num);
> +
> +       iscsit_increment_maxcmdsn(cmd, conn->sess);
> +       cmd->stat_sn = conn->stat_sn++;
> +
> +       wr->isert_cmd = isert_cmd;
> +       rdma_write_max = isert_conn->max_sge * PAGE_SIZE;
> +       data_left = se_cmd->data_length;
> +
> +       for (i = 0; i < wr->send_wr_num; i++) {
> +               send_wr = &isert_cmd->rdma_wr.send_wr[i];
> +               data_len = min(data_left, rdma_write_max);
> +
> +               send_wr->opcode = IB_WR_RDMA_WRITE;
> +               send_wr->send_flags = 0;
> +               send_wr->wr.rdma.remote_addr = isert_cmd->read_va + offset;
> +               send_wr->wr.rdma.rkey = isert_cmd->read_stag;
> +
> +               ib_sge_cnt = isert_build_rdma_wr(isert_conn, isert_cmd, ib_sge,
> +                                       send_wr, data_len, offset);
> +               ib_sge += ib_sge_cnt;
> +
> +               if (i + 1 == wr->send_wr_num)
> +                       send_wr->next = &isert_cmd->tx_desc.send_wr;
> +               else
> +                       send_wr->next = &wr->send_wr[i + 1];
> +
> +               offset += data_len;
> +               data_left -= data_len;
> +       }
> +       /*
> +        * Build isert_conn->tx_desc for iSCSI response PDU and attach
> +        */
> +       isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
> +       iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
> +                            &isert_cmd->tx_desc.iscsi_header);
> +       isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
> +
> +       wr->iser_ib_op = ISER_IB_SEND;
> +       isert_cmd->tx_desc.send_wr.wr_id = (unsigned long)&isert_cmd->tx_desc;
> +       isert_cmd->tx_desc.send_wr.opcode = IB_WR_SEND;
> +       isert_cmd->tx_desc.send_wr.send_flags = IB_SEND_SIGNALED;
> +       isert_cmd->tx_desc.send_wr.sg_list = &isert_cmd->tx_desc.tx_sg[0];
> +       isert_cmd->tx_desc.send_wr.num_sge = isert_cmd->tx_desc.num_sge;
> +
> +       atomic_inc(&isert_conn->post_send_buf_count);
> +
> +       rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
> +       if (rc) {
> +               pr_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
> +               atomic_dec(&isert_conn->post_send_buf_count);
> +       }
> +       pr_debug("Posted RDMA_WRITE + Response for iSER Data READ\n");
> +       return 1;
> +
> +unmap_sg:
> +       ib_dma_unmap_sg(ib_dev, sg, sg_nents, DMA_TO_DEVICE);
> +       return ret;
> +}
> +
> +static int
> +isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
> +{
> +       struct se_cmd *se_cmd = &cmd->se_cmd;
> +       struct isert_cmd *isert_cmd = container_of(cmd,
> +                                       struct isert_cmd, iscsi_cmd);
> +       struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
> +       struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> +       struct ib_send_wr *wr_failed, *send_wr;
> +       struct ib_sge *ib_sge;
> +       struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> +       struct scatterlist *sg_start;
> +       u32 sg_off, sg_nents, page_off, va_offset = 0;
> +       u32 offset = 0, data_len, data_left, rdma_write_max;
> +       int rc, ret = 0, count, i, ib_sge_cnt;
> +
> +       pr_debug("RDMA_READ: data_length: %u write_data_done: %u\n",
> +                se_cmd->data_length, cmd->write_data_done);
> +
> +       sg_off = cmd->write_data_done / PAGE_SIZE;
> +       sg_start = &cmd->se_cmd.t_data_sg[sg_off];
> +       page_off = cmd->write_data_done % PAGE_SIZE;
> +
> +       pr_debug("RDMA_READ: sg_off: %d, sg_start: %p page_off: %d\n",
> +                sg_off, sg_start, page_off);
> +
> +       data_left = se_cmd->data_length - cmd->write_data_done;
> +       sg_nents = se_cmd->t_data_nents - sg_off;
> +
> +       pr_debug("RDMA_READ: data_left: %d, sg_nents: %d\n",
> +                data_left, sg_nents);
> +
> +       count = ib_dma_map_sg(ib_dev, sg_start, sg_nents, DMA_FROM_DEVICE);
> +       if (unlikely(!count)) {
> +               pr_err("Unable to map get_dataout SGs\n");
> +               return -EINVAL;
> +       }
> +       wr->sge = sg_start;
> +       wr->num_sge = sg_nents;
> +       pr_debug("Mapped IB count: %u sg_start: %p sg_nents: %u for RDMA_READ\n",
> +                count, sg_start, sg_nents);
> +
> +       ib_sge = kzalloc(sizeof(struct ib_sge) * sg_nents, GFP_KERNEL);
> +       if (!ib_sge) {
> +               pr_warn("Unable to allocate dataout ib_sge\n");
> +               ret = -ENOMEM;
> +               goto unmap_sg;
> +       }
> +       isert_cmd->ib_sge = ib_sge;
> +
> +       pr_debug("Using ib_sge: %p from sg_ents: %d for RDMA_READ\n",
> +                ib_sge, sg_nents);
> +
> +       wr->send_wr_num = DIV_ROUND_UP(sg_nents, isert_conn->max_sge);
> +       wr->send_wr = kzalloc(sizeof(struct ib_send_wr) * wr->send_wr_num,
> +                               GFP_KERNEL);
> +       if (!wr->send_wr) {
> +               pr_debug("Unable to allocate wr->send_wr\n");
> +               ret = -ENOMEM;
> +               goto unmap_sg;
> +       }
> +       pr_debug("Allocated wr->send_wr: %p wr->send_wr_num: %u\n",
> +                wr->send_wr, wr->send_wr_num);
> +
> +       isert_cmd->tx_desc.isert_cmd = isert_cmd;
> +
> +       wr->iser_ib_op = ISER_IB_RDMA_READ;
> +       wr->isert_cmd = isert_cmd;
> +       rdma_write_max = isert_conn->max_sge * PAGE_SIZE;
> +       offset = cmd->write_data_done;
> +
> +       for (i = 0; i < wr->send_wr_num; i++) {
> +               send_wr = &isert_cmd->rdma_wr.send_wr[i];
> +               data_len = min(data_left, rdma_write_max);
> +
> +               send_wr->opcode = IB_WR_RDMA_READ;
> +               send_wr->wr.rdma.remote_addr = isert_cmd->write_va + va_offset;
> +               send_wr->wr.rdma.rkey = isert_cmd->write_stag;
> +
> +               ib_sge_cnt = isert_build_rdma_wr(isert_conn, isert_cmd, ib_sge,
> +                                       send_wr, data_len, offset);
> +               ib_sge += ib_sge_cnt;
> +
> +               if (i + 1 == wr->send_wr_num)
> +                       send_wr->send_flags = IB_SEND_SIGNALED;
> +               else
> +                       send_wr->next = &wr->send_wr[i + 1];
> +
> +               offset += data_len;
> +               va_offset += data_len;
> +               data_left -= data_len;
> +       }
> +
> +       atomic_inc(&isert_conn->post_send_buf_count);
> +
> +       rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
> +       if (rc) {
> +               pr_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
> +               atomic_dec(&isert_conn->post_send_buf_count);
> +       }
> +       pr_debug("Posted RDMA_READ memory for ISER Data WRITE\n");
> +       return 0;
> +
> +unmap_sg:
> +       ib_dma_unmap_sg(ib_dev, sg_start, sg_nents, DMA_FROM_DEVICE);
> +       return ret;
> +}
> +
> +static int
> +isert_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
> +{
> +       int ret;
> +
> +       switch (state) {
> +       case ISTATE_SEND_NOPIN_WANT_RESPONSE:
> +               ret = isert_put_nopin(cmd, conn, false);
> +               break;
> +       default:
> +               pr_err("Unknown immediate state: 0x%02x\n", state);
> +               ret = -EINVAL;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +static int
> +isert_response_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
> +{
> +       int ret;
> +
> +       switch (state) {
> +       case ISTATE_SEND_LOGOUTRSP:
> +               ret = isert_put_logout_rsp(cmd, conn);
> +               if (!ret) {
> +                       pr_debug("Returning iSER Logout -EAGAIN\n");
> +                       ret = -EAGAIN;
> +               }
> +               break;
> +       case ISTATE_SEND_NOPIN:
> +               ret = isert_put_nopin(cmd, conn, true);
> +               break;
> +       case ISTATE_SEND_TASKMGTRSP:
> +               ret = isert_put_tm_rsp(cmd, conn);
> +               break;
> +       default:
> +               pr_err("Unknown response state: 0x%02x\n", state);
> +               ret = -EINVAL;
> +               break;
> +       }
> +
> +       return ret;
> +}
> +
> +static int
> +isert_setup_np(struct iscsi_np *np,
> +              struct __kernel_sockaddr_storage *ksockaddr)
> +{
> +       struct isert_np *isert_np;
> +       struct rdma_cm_id *isert_lid;
> +       struct sockaddr *sa;
> +       int ret;
> +
> +       isert_np = kzalloc(sizeof(struct isert_np), GFP_KERNEL);
> +       if (!isert_np) {
> +               pr_err("Unable to allocate struct isert_np\n");
> +               return -ENOMEM;
> +       }
> +       init_waitqueue_head(&isert_np->np_accept_wq);
> +       mutex_init(&isert_np->np_accept_mutex);
> +       INIT_LIST_HEAD(&isert_np->np_accept_list);
> +       init_completion(&isert_np->np_login_comp);
> +
> +       sa = (struct sockaddr *)ksockaddr;
> +       pr_debug("ksockaddr: %p, sa: %p\n", ksockaddr, sa);
> +
> +       isert_lid = rdma_create_id(isert_cma_handler, np, RDMA_PS_TCP,
> +                               IB_QPT_RC);
> +       if (IS_ERR(isert_lid)) {
> +               pr_err("rdma_create_id() for isert_listen_handler failed: %ld\n",
> +                      PTR_ERR(isert_lid));
> +               return PTR_ERR(isert_lid);
> +       }
> +
> +       ret = rdma_bind_addr(isert_lid, sa);
> +       if (ret) {
> +               pr_err("rdma_bind_addr() for isert_lid failed: %d\n", ret);
> +               return ret;
> +       }
> +
> +       ret = rdma_listen(isert_lid, ISERT_RDMA_LISTEN_BACKLOG);
> +       if (ret) {
> +               pr_err("rdma_listen() for isert_lid failed: %d\n", ret);
> +               return ret;
> +       }
> +
> +       isert_np->np_cm_id = isert_lid;
> +       np->np_context = isert_np;
> +       pr_debug("Setup isert_lid->context: %p\n", isert_lid->context);
> +
> +       return 0;
> +}
> +
> +static int
> +isert_check_accept_queue(struct isert_np *isert_np)
> +{
> +       int empty;
> +
> +       mutex_lock(&isert_np->np_accept_mutex);
> +       empty = list_empty(&isert_np->np_accept_list);
> +       mutex_unlock(&isert_np->np_accept_mutex);
> +
> +       return empty;
> +}
> +
> +static int
> +isert_rdma_post_recvl(struct isert_conn *isert_conn)
> +{
> +       struct ib_recv_wr rx_wr, *rx_wr_fail;
> +       struct ib_sge sge;
> +       int ret;
> +
> +       memset(&sge, 0, sizeof(struct ib_sge));
> +       sge.addr = isert_conn->login_req_dma;
> +       sge.length = ISER_RX_LOGIN_SIZE;
> +       sge.lkey = isert_conn->conn_mr->lkey;
> +
> +       pr_debug("Setup sge: addr: %llx length: %d 0x%08x\n",
> +                sge.addr, sge.length, sge.lkey);
> +
> +       memset(&rx_wr, 0, sizeof(struct ib_recv_wr));
> +       rx_wr.wr_id = (unsigned long)isert_conn->login_req_buf;
> +       rx_wr.sg_list = &sge;
> +       rx_wr.num_sge = 1;
> +
> +       isert_conn->post_recv_buf_count++;
> +       ret = ib_post_recv(isert_conn->conn_qp, &rx_wr, &rx_wr_fail);
> +       if (ret) {
> +               pr_err("ib_post_recv() failed: %d\n", ret);
> +               isert_conn->post_recv_buf_count--;
> +       }
> +
> +       pr_debug("ib_post_recv(): returned success >>>>>>>>>>>>>>>>>>>>>>>>\n");
> +
> +       return ret;
> +}
> +
> +static int
> +isert_rdma_accept(struct isert_conn *isert_conn)
> +{
> +       struct rdma_cm_id *cm_id = isert_conn->conn_cm_id;
> +       struct rdma_conn_param cp;
> +       int ret;
> +
> +       memset(&cp, 0, sizeof(struct rdma_conn_param));
> +       cp.responder_resources = isert_conn->responder_resources;
> +       cp.initiator_depth = isert_conn->initiator_depth;
> +       cp.retry_count = 7;
> +       cp.rnr_retry_count = 7;
> +
> +       pr_debug("Before rdma_accept >>>>>>>>>>>>>>>>>>>>.\n");
> +
> +       ret = rdma_accept(cm_id, &cp);
> +       if (ret) {
> +               pr_err("rdma_accept() failed with: %d\n", ret);
> +               return ret;
> +       }
> +
> +       pr_debug("After rdma_accept >>>>>>>>>>>>>>>>>>>>>.\n");
> +
> +       return 0;
> +}
> +
> +static int
> +isert_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
> +{
> +       struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
> +       int ret;
> +
> +       pr_debug("isert_get_login_rx before conn_login_comp conn: %p\n", conn);
> +
> +       ret = wait_for_completion_interruptible(&isert_conn->conn_login_comp);
> +       if (ret)
> +               return ret;
> +
> +       pr_debug("isert_get_login_rx processing login->req: %p\n", login->req);
> +       return 0;
> +}
> +
> +static void
> +isert_set_conn_info(struct iscsi_np *np, struct iscsi_conn *conn,
> +                   struct isert_conn *isert_conn)
> +{
> +       struct rdma_cm_id *cm_id = isert_conn->conn_cm_id;
> +       struct rdma_route *cm_route = &cm_id->route;
> +       struct sockaddr_in *sock_in;
> +       struct sockaddr_in6 *sock_in6;
> +
> +       conn->login_family = np->np_sockaddr.ss_family;
> +
> +       if (np->np_sockaddr.ss_family == AF_INET6) {
> +               sock_in6 = (struct sockaddr_in6 *)&cm_route->addr.dst_addr;
> +               snprintf(conn->login_ip, sizeof(conn->login_ip), "%pI6c",
> +                        &sock_in6->sin6_addr.in6_u);
> +               conn->login_port = ntohs(sock_in6->sin6_port);
> +
> +               sock_in6 = (struct sockaddr_in6 *)&cm_route->addr.src_addr;
> +               snprintf(conn->local_ip, sizeof(conn->local_ip), "%pI6c",
> +                        &sock_in6->sin6_addr.in6_u);
> +               conn->local_port = ntohs(sock_in6->sin6_port);
> +       } else {
> +               sock_in = (struct sockaddr_in *)&cm_route->addr.dst_addr;
> +               sprintf(conn->login_ip, "%pI4",
> +                       &sock_in->sin_addr.s_addr);
> +               conn->login_port = ntohs(sock_in->sin_port);
> +
> +               sock_in = (struct sockaddr_in *)&cm_route->addr.src_addr;
> +               sprintf(conn->local_ip, "%pI4",
> +                       &sock_in->sin_addr.s_addr);
> +               conn->local_port = ntohs(sock_in->sin_port);
> +       }
> +}
> +
> +static int
> +isert_accept_np(struct iscsi_np *np, struct iscsi_conn *conn)
> +{
> +       struct isert_np *isert_np = (struct isert_np *)np->np_context;
> +       struct isert_conn *isert_conn;
> +       int max_accept = 0, ret;
> +
> +accept_wait:
> +       ret = wait_event_interruptible(isert_np->np_accept_wq,
> +                       !isert_check_accept_queue(isert_np) ||
> +                       np->np_thread_state == ISCSI_NP_THREAD_RESET);
> +       if (max_accept > 5)
> +               return -ENODEV;
> +
> +       spin_lock_bh(&np->np_thread_lock);
> +       if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
> +               spin_unlock_bh(&np->np_thread_lock);
> +               pr_err("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
> +               return -ENODEV;
> +       }
> +       spin_unlock_bh(&np->np_thread_lock);
> +
> +       mutex_lock(&isert_np->np_accept_mutex);
> +       if (list_empty(&isert_np->np_accept_list)) {
> +               mutex_unlock(&isert_np->np_accept_mutex);
> +               max_accept++;
> +               goto accept_wait;
> +       }
> +       isert_conn = list_first_entry(&isert_np->np_accept_list,
> +                       struct isert_conn, conn_accept_node);
> +       list_del_init(&isert_conn->conn_accept_node);
> +       mutex_unlock(&isert_np->np_accept_mutex);
> +
> +       conn->context = isert_conn;
> +       isert_conn->conn = conn;
> +       max_accept = 0;
> +
> +       ret = isert_rdma_post_recvl(isert_conn);
> +       if (ret)
> +               return ret;
> +
> +       ret = isert_rdma_accept(isert_conn);
> +       if (ret)
> +               return ret;
> +
> +       isert_set_conn_info(np, conn, isert_conn);
> +
> +       pr_debug("Processing isert_accept_np: isert_conn: %p\n", isert_conn);
> +       return 0;
> +}
> +
> +static void
> +isert_free_np(struct iscsi_np *np)
> +{
> +       struct isert_np *isert_np = (struct isert_np *)np->np_context;
> +
> +       rdma_destroy_id(isert_np->np_cm_id);
> +
> +       np->np_context = NULL;
> +       kfree(isert_np);
> +}
> +
> +static void isert_free_conn(struct iscsi_conn *conn)
> +{
> +       struct isert_conn *isert_conn = conn->context;
> +
> +       pr_debug("isert_free_conn: Before isert_put_conn\n");
> +
> +       atomic_dec(&isert_conn->post_send_buf_count);
> +
> +       if (isert_conn->conn_cm_id)
> +               rdma_disconnect(isert_conn->conn_cm_id);
> +
> +       pr_debug("isert_free_conn: Before wait_event :%d\n", isert_conn->state);
> +       wait_event(isert_conn->conn_wait, isert_conn->state == ISER_CONN_DOWN);
> +       pr_debug("isert_free_conn: After wait_event >>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
> +
> +       isert_put_conn(isert_conn);
> +}
> +
> +static struct iscsit_transport iser_target_transport = {
> +       .name                   = "IB/iSER",
> +       .transport_type         = ISCSI_INFINIBAND,
> +       .owner                  = THIS_MODULE,
> +       .iscsit_setup_np        = isert_setup_np,
> +       .iscsit_accept_np       = isert_accept_np,
> +       .iscsit_free_np         = isert_free_np,
> +       .iscsit_free_conn       = isert_free_conn,
> +       .iscsit_alloc_cmd       = isert_alloc_cmd,
> +       .iscsit_get_login_rx    = isert_get_login_rx,
> +       .iscsit_put_login_tx    = isert_put_login_tx,
> +       .iscsit_immediate_queue = isert_immediate_queue,
> +       .iscsit_response_queue  = isert_response_queue,
> +       .iscsit_get_dataout     = isert_get_dataout,
> +       .iscsit_queue_data_in   = isert_put_datain,
> +       .iscsit_queue_status    = isert_put_response,
> +};
> +
> +static int __init isert_init(void)
> +{
> +       int ret;
> +
> +       isert_rx_wq = alloc_workqueue("isert_rx_wq", 0, 0);
> +       if (!isert_rx_wq) {
> +               pr_err("Unable to allocate isert_rx_wq\n");
> +               return -ENOMEM;
> +       }
> +
> +       isert_comp_wq = alloc_workqueue("isert_comp_wq", 0, 0);
> +       if (!isert_comp_wq) {
> +               pr_err("Unable to allocate isert_comp_wq\n");
> +               ret = -ENOMEM;
> +               goto destroy_rx_wq;
> +       }
> +
> +       iscsit_register_transport(&iser_target_transport);
> +       pr_debug("iSER_TARGET[0] - Loaded iser_target_transport\n");
> +
> +       pr_debug("ISER_HEADERS_LEN: %lu\n", ISER_HEADERS_LEN);
> +       pr_debug("ISER_RECV_DATA_SEG_LEN: %d\n", ISER_RECV_DATA_SEG_LEN);
> +       pr_debug("ISER_RX_PAYLOAD_SIZE: %lu\n", ISER_RX_PAYLOAD_SIZE);
> +       pr_debug("ISER_RX_PAD_SIZE: %lu\n", ISER_RX_PAD_SIZE);
> +
> +       return 0;
> +
> +destroy_rx_wq:
> +       destroy_workqueue(isert_rx_wq);
> +       return ret;
> +}
> +
> +static void __exit isert_exit(void)
> +{
> +       destroy_workqueue(isert_comp_wq);
> +       destroy_workqueue(isert_rx_wq);
> +       iscsit_unregister_transport(&iser_target_transport);
> +       pr_debug("iSER_TARGET[0] - Released iser_target_transport\n");
> +}
> +
> +MODULE_DESCRIPTION("iSER-Target for mainline target infrastructure");
> +MODULE_VERSION("0.1");
> +MODULE_AUTHOR("nab-mGRCEbBOV6Ml+7RC/bbRzw@public.gmane.org");
> +MODULE_LICENSE("GPL");
> +
> +module_init(isert_init);
> +module_exit(isert_exit);
> diff --git a/drivers/infiniband/ulp/isert/isert_core.h b/drivers/infiniband/ulp/isert/isert_core.h
> new file mode 100644
> index 0000000..f260ba6
> --- /dev/null
> +++ b/drivers/infiniband/ulp/isert/isert_core.h
> @@ -0,0 +1,11 @@
> +#include <linux/socket.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <rdma/ib_verbs.h>
> +#include <rdma/rdma_cm.h>
> +
> +extern void iser_cq_tx_tasklet(unsigned long);
> +extern void isert_cq_tx_callback(struct ib_cq *, void *);
> +extern void iser_cq_rx_tasklet(unsigned long);
> +extern void isert_cq_rx_callback(struct ib_cq *, void *);
> +extern void isert_free_rx_descriptors(struct isert_conn *);
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
