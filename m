From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [RFC-v2 10/12] iser-target: Add logic for verbs
Date: Tue, 2 Apr 2013 23:09:30 +0300
Message-ID: <CAJZOPZL3WreQjbaeGgaUi3QxEuEAXFCcuMA6C3rEibzmRp7fUQ@mail.gmail.com>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
	<1363996536-30644-11-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:62458 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761364Ab3DBUJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Apr 2013 16:09:31 -0400
In-Reply-To: <1363996536-30644-11-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Sat, Mar 23, 2013 at 1:55 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
[...]
> +static void
> +isert_qp_event_callback(struct ib_event *e, void *context)
> +{
> +       struct isert_conn *isert_conn = (struct isert_conn *)context;
> +
> +       pr_err("isert_qp_event_callback event: %d\n", e->event);
> +       switch (e->event) {
> +       case IB_EVENT_COMM_EST:
> +               rdma_notify(isert_conn->conn_cm_id, IB_EVENT_COMM_EST);
> +               break;
> +       default:
> +               break;
> +       }
> +}
[...]
> +static void
> +isert_cq_event_callback(struct ib_event *e, void *context)
> +{
> +       pr_debug("isert_cq_event_callback event: %d\n", e->event);
> +
> +       switch (e->event) {
> +       case IB_EVENT_QP_LAST_WQE_REACHED:
> +               pr_warn("Reached TX IB_EVENT_QP_LAST_WQE_REACHED:\n");
> +               break;
> +       default:
> +               pr_warn("Unknown e->event; %d\n", e->event);
> +               break;
> +       }
> +}

This is QP not CQ event, move the case for it to QP event hander
isert_qp_event_callback




















> +               ib_destroy_cq(device->dev_tx_cq[i]);
> +               device->dev_rx_cq[i] = NULL;
> +               device->dev_tx_cq[i] = NULL;
> +       }
> +
> +       ib_dereg_mr(device->dev_mr);
> +       ib_dealloc_pd(device->dev_pd);
> +       kfree(device->cq_desc);
> +}
> +
> +static void
> +isert_device_try_release(struct isert_device *device)
> +{
> +       mutex_lock(&device_list_mutex);
> +       device->refcount--;
> +       if (!device->refcount) {
> +               isert_free_device_ib_res(device);
> +               list_del(&device->dev_node);
> +               kfree(device);
> +       }
> +       mutex_unlock(&device_list_mutex);
> +}
> +
> +static struct isert_device *
> +isert_device_find_by_ib_dev(struct rdma_cm_id *cma_id)
> +{
> +       struct isert_device *device;
> +
> +       mutex_lock(&device_list_mutex);
> +       list_for_each_entry(device, &device_list, dev_node) {
> +               if (device->ib_device->node_guid == cma_id->device->node_guid) {
> +                       device->refcount++;
> +                       mutex_unlock(&device_list_mutex);
> +                       return device;
> +               }
> +       }
> +
> +       device = kzalloc(sizeof(struct isert_device), GFP_KERNEL);
> +       if (!device) {
> +               mutex_unlock(&device_list_mutex);
> +               return NULL;
> +       }
> +
> +       INIT_LIST_HEAD(&device->dev_node);
> +
> +       device->ib_device = cma_id->device;
> +       if (isert_create_device_ib_res(device)) {
> +               kfree(device);
> +               mutex_unlock(&device_list_mutex);
> +               return NULL;
> +       }
> +
> +       device->refcount++;
> +       list_add_tail(&device->dev_node, &device_list);
> +       mutex_unlock(&device_list_mutex);
> +
> +       return device;
> +}
> +
> +static int
> +isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
> +{
> +       struct iscsi_np *np = cma_id->context;
> +       struct isert_np *isert_np = np->np_context;
> +       struct isert_conn *isert_conn;
> +       struct isert_device *device;
> +       struct ib_device *ib_dev = cma_id->device;
> +       int ret;
> +
> +       pr_debug("Entering isert_connect_request cma_id: %p, context: %p\n",
> +                cma_id, cma_id->context);
> +
> +       isert_conn = kzalloc(sizeof(struct isert_conn), GFP_KERNEL);
> +       if (!isert_conn) {
> +               pr_err("Unable to allocate isert_conn\n");
> +               return -ENOMEM;
> +       }
> +       isert_conn->state = ISER_CONN_INIT;
> +       INIT_LIST_HEAD(&isert_conn->conn_accept_node);
> +       init_completion(&isert_conn->conn_login_comp);
> +       init_waitqueue_head(&isert_conn->conn_wait);
> +       kref_init(&isert_conn->conn_kref);
> +       kref_get(&isert_conn->conn_kref);
> +
> +       cma_id->context = isert_conn;
> +       isert_conn->conn_cm_id = cma_id;
> +       isert_conn->responder_resources = event->param.conn.responder_resources;
> +       isert_conn->initiator_depth = event->param.conn.initiator_depth;
> +       pr_debug("Using responder_resources: %u initiator_depth: %u\n",
> +                isert_conn->responder_resources, isert_conn->initiator_depth);
> +
> +       isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
> +                                       ISER_RX_LOGIN_SIZE, GFP_KERNEL);
> +       if (!isert_conn->login_buf) {
> +               pr_err("Unable to allocate isert_conn->login_buf\n");
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       isert_conn->login_req_buf = isert_conn->login_buf;
> +       isert_conn->login_rsp_buf = isert_conn->login_buf +
> +                                   ISCSI_DEF_MAX_RECV_SEG_LEN;
> +       pr_debug("Set login_buf: %p login_req_buf: %p login_rsp_buf: %p\n",
> +                isert_conn->login_buf, isert_conn->login_req_buf,
> +                isert_conn->login_rsp_buf);
> +
> +       isert_conn->login_req_dma = ib_dma_map_single(ib_dev,
> +                               (void *)isert_conn->login_req_buf,
> +                               ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
> +
> +       ret = ib_dma_mapping_error(ib_dev, isert_conn->login_req_dma);
> +       if (ret) {
> +               pr_err("ib_dma_mapping_error failed for login_req_dma: %d\n",
> +                      ret);
> +               isert_conn->login_req_dma = 0;
> +               goto out_login_buf;
> +       }
> +
> +       isert_conn->login_rsp_dma = ib_dma_map_single(ib_dev,
> +                                       (void *)isert_conn->login_rsp_buf,
> +                                       ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
> +
> +       ret = ib_dma_mapping_error(ib_dev, isert_conn->login_rsp_dma);
> +       if (ret) {
> +               pr_err("ib_dma_mapping_error failed for login_rsp_dma: %d\n",
> +                      ret);
> +               isert_conn->login_rsp_dma = 0;
> +               goto out_req_dma_map;
> +       }
> +
> +       device = isert_device_find_by_ib_dev(cma_id);
> +       if (!device)
> +               goto out_rsp_dma_map;
> +
> +       isert_conn->conn_device = device;
> +       isert_conn->conn_pd = device->dev_pd;
> +       isert_conn->conn_mr = device->dev_mr;
> +
> +       ret = isert_conn_setup_qp(isert_conn, cma_id);
> +       if (ret)
> +               goto out_conn_dev;
> +
> +       mutex_lock(&isert_np->np_accept_mutex);
> +       list_add_tail(&isert_np->np_accept_list, &isert_conn->conn_accept_node);
> +       mutex_unlock(&isert_np->np_accept_mutex);
> +
> +       pr_debug("isert_connect_request() waking up np_accept_wq: %p\n", np);
> +       wake_up(&isert_np->np_accept_wq);
> +       return 0;
> +
> +out_conn_dev:
> +       isert_device_try_release(device);
> +out_rsp_dma_map:
> +       ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
> +                           ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
> +out_req_dma_map:
> +       ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
> +                           ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
> +out_login_buf:
> +       kfree(isert_conn->login_buf);
> +out:
> +       kfree(isert_conn);
> +       return ret;
> +}
> +
> +static void
> +isert_connect_release(struct isert_conn *isert_conn)
> +{
> +       struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> +       struct isert_device *device = isert_conn->conn_device;
> +       int cq_index;
> +
> +       pr_debug("Entering isert_connect_release(): >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
> +
> +       if (isert_conn->conn_qp) {
> +               cq_index = ((struct isert_cq_desc *)
> +                       isert_conn->conn_qp->recv_cq->cq_context)->cq_index;
> +               pr_debug("isert_connect_release: cq_index: %d\n", cq_index);
> +               isert_conn->conn_device->cq_active_qps[cq_index]--;
> +
> +               rdma_destroy_qp(isert_conn->conn_cm_id);
> +       }
> +
> +       isert_free_rx_descriptors(isert_conn);
> +
> +       if (isert_conn->conn_cm_id != NULL)
> +               rdma_destroy_id(isert_conn->conn_cm_id);
> +
> +       if (isert_conn->login_buf) {
> +               ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
> +                                   ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
> +               ib_dma_unmap_single(ib_dev, isert_conn->login_req_dma,
> +                                   ISCSI_DEF_MAX_RECV_SEG_LEN,
> +                                   DMA_FROM_DEVICE);
> +               kfree(isert_conn->login_buf);
> +       }
> +       kfree(isert_conn);
> +
> +       if (device)
> +               isert_device_try_release(device);
> +
> +       pr_debug("Leaving isert_connect_release >>>>>>>>>>>>\n");
> +}
> +
> +static void
> +isert_connected_handler(struct rdma_cm_id *cma_id)
> +{
> +       return;
> +}
> +
> +static void
> +isert_release_conn_kref(struct kref *kref)
> +{
> +       struct isert_conn *isert_conn = container_of(kref,
> +                               struct isert_conn, conn_kref);
> +
> +       pr_debug("Calling isert_connect_release for final kref %s/%d\n",
> +                current->comm, current->pid);
> +
> +       isert_connect_release(isert_conn);
> +}
> +
> +void
> +isert_put_conn(struct isert_conn *isert_conn)
> +{
> +       kref_put(&isert_conn->conn_kref, isert_release_conn_kref);
> +}
> +
> +static void
> +isert_disconnect_work(struct work_struct *work)
> +{
> +       struct isert_conn *isert_conn = container_of(work,
> +                               struct isert_conn, conn_logout_work);
> +
> +       pr_debug("isert_disconnect_work(): >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
> +
> +       if (isert_conn->post_recv_buf_count == 0 &&
> +           atomic_read(&isert_conn->post_send_buf_count) == 0) {
> +               pr_debug("Calling wake_up(&isert_conn->conn_wait);\n");
> +               isert_conn->state = ISER_CONN_DOWN;
> +               wake_up(&isert_conn->conn_wait);
> +       }
> +
> +       isert_put_conn(isert_conn);
> +}
> +
> +static void
> +isert_disconnected_handler(struct rdma_cm_id *cma_id)
> +{
> +       struct isert_conn *isert_conn = (struct isert_conn *)cma_id->context;
> +
> +       INIT_WORK(&isert_conn->conn_logout_work, isert_disconnect_work);
> +       schedule_work(&isert_conn->conn_logout_work);
> +}
> +
> +int
> +isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
> +{
> +       int ret = 0;
> +
> +       pr_debug("isert_cma_handler: event %d status %d conn %p id %p\n",
> +                event->event, event->status, cma_id->context, cma_id);
> +
> +       switch (event->event) {
> +       case RDMA_CM_EVENT_CONNECT_REQUEST:
> +               pr_debug("RDMA_CM_EVENT_CONNECT_REQUEST: >>>>>>>>>>>>>>>\n");
> +               ret = isert_connect_request(cma_id, event);
> +               break;
> +       case RDMA_CM_EVENT_ESTABLISHED:
> +               pr_debug("RDMA_CM_EVENT_ESTABLISHED >>>>>>>>>>>>>>\n");
> +               isert_connected_handler(cma_id);
> +               break;
> +       case RDMA_CM_EVENT_DISCONNECTED:
> +               pr_debug("RDMA_CM_EVENT_DISCONNECTED: >>>>>>>>>>>>>>\n");
> +               isert_disconnected_handler(cma_id);
> +               break;
> +       case RDMA_CM_EVENT_DEVICE_REMOVAL:
> +       case RDMA_CM_EVENT_ADDR_CHANGE:
> +               break;
> +       case RDMA_CM_EVENT_CONNECT_ERROR:
> +       default:
> +               pr_err("Unknown RDMA CMA event: %d\n", event->event);
> +               break;
> +       }
> +
> +       if (ret != 0) {
> +               pr_err("isert_cma_handler failed RDMA_CM_EVENT: 0x%08x %d\n",
> +                      event->event, ret);
> +               dump_stack();
> +       }
> +
> +       return ret;
> +}
> +
> +int
> +isert_post_recv(struct isert_conn *isert_conn, u32 count)
> +{
> +       struct ib_recv_wr *rx_wr, *rx_wr_failed;
> +       int i, ret;
> +       unsigned int rx_head = isert_conn->conn_rx_desc_head;
> +       struct isert_rx_desc *rx_desc;
> +       struct iser_rx_desc *desc;
> +
> +       for (rx_wr = isert_conn->conn_rx_wr, i = 0; i < count; i++, rx_wr++) {
> +               rx_desc         = &isert_conn->conn_rx_descs[rx_head];
> +               desc            = &rx_desc->desc;
> +               rx_wr->wr_id    = (unsigned long)desc;
> +               rx_wr->sg_list  = &desc->rx_sg;
> +               rx_wr->num_sge  = 1;
> +               rx_wr->next     = rx_wr + 1;
> +               rx_head = (rx_head + 1) & (ISERT_QP_MAX_RECV_DTOS - 1);
> +       }
> +
> +       rx_wr--;
> +       rx_wr->next = NULL; /* mark end of work requests list */
> +
> +       isert_conn->post_recv_buf_count += count;
> +       ret = ib_post_recv(isert_conn->conn_qp, isert_conn->conn_rx_wr,
> +                               &rx_wr_failed);
> +       if (ret) {
> +               pr_err("ib_post_recv() failed with ret: %d\n", ret);
> +               isert_conn->post_recv_buf_count -= count;
> +       } else {
> +               pr_debug("isert_post_recv(): Posted %d RX buffers\n", count);
> +               isert_conn->conn_rx_desc_head = rx_head;
> +       }
> +       return ret;
> +}
> +
> +int
> +isert_post_send(struct isert_conn *isert_conn, struct iser_tx_desc *tx_desc)
> +{
> +       struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
> +       struct ib_send_wr send_wr, *send_wr_failed;
> +       int ret;
> +
> +       ib_dma_sync_single_for_device(ib_dev, tx_desc->dma_addr,
> +                                     ISER_HEADERS_LEN, DMA_TO_DEVICE);
> +
> +       send_wr.next    = NULL;
> +       send_wr.wr_id   = (unsigned long)tx_desc;
> +       send_wr.sg_list = tx_desc->tx_sg;
> +       send_wr.num_sge = tx_desc->num_sge;
> +       send_wr.opcode  = IB_WR_SEND;
> +       send_wr.send_flags = IB_SEND_SIGNALED;
> +
> +       atomic_inc(&isert_conn->post_send_buf_count);
> +
> +       ret = ib_post_send(isert_conn->conn_qp, &send_wr, &send_wr_failed);
> +       if (ret) {
> +               pr_err("ib_post_send() failed, ret: %d\n", ret);
> +               atomic_dec(&isert_conn->post_send_buf_count);
> +       }
> +
> +       return ret;
> +}
> diff --git a/drivers/infiniband/ulp/isert/isert_verbs.h b/drivers/infiniband/ulp/isert/isert_verbs.h
> new file mode 100644
> index 0000000..da7924d
> --- /dev/null
> +++ b/drivers/infiniband/ulp/isert/isert_verbs.h
> @@ -0,0 +1,5 @@
> +extern void isert_connect_release(struct isert_conn *);
> +extern void isert_put_conn(struct isert_conn *);
> +extern int isert_cma_handler(struct rdma_cm_id *, struct rdma_cm_event *);
> +extern int isert_post_recv(struct isert_conn *, u32);
> +extern int isert_post_send(struct isert_conn *, struct iser_tx_desc *);
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
