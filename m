From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC 10/11] iser-target: Add logic for core
Date: Thu, 14 Mar 2013 13:08:44 +0200
Message-ID: <5141AFBC.8000002@mellanox.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-11-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1362707116-31406-11-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 08/03/2013 03:45, Nicholas A. Bellinger wrote:
> +void
> +isert_dump_ib_wc(struct ib_wc *wc)
> +{
> +	pr_debug("wc->wr_id: %llu\n", wc->wr_id);
> +	pr_debug("wc->status: 0x%08x\n", wc->status);

This helper is called for a CQ completion with error, but when this 
happens all the WC fields except for the wr_id and the status aren't 
defined, so there's no point in dumping them (can be terribly misleading)

> +	pr_debug("wc->opcode: 0x%08x\n", wc->opcode);
> +	pr_debug("wc->vendor_err: 0x%08x\n", wc->vendor_err);
> +	pr_debug("wc->byte_len: %u\n", wc->byte_len);
> +	pr_debug("wc->qp: %p\n", wc->qp);
> +	pr_debug("wc->src_qp: %u\n", wc->src_qp);
> +	pr_debug("wc->wc_flags: 0x%08x\n", wc->wc_flags);
> +	pr_debug("wc->pkey_index: %hu\n", wc->pkey_index);
> +	pr_debug("wc->slid: %hu\n", wc->slid);
> +	pr_debug("wc->sl: 0x%02x\n", wc->sl);
> +	pr_debug("wc->dlid_path_bits: 0x%02x\n", wc->dlid_path_bits);
> +	pr_debug("wc->port_num: 0x%02x\n", wc->port_num);
> +}
> +
> +void
> +iser_cq_tx_tasklet(unsigned long data)
> +{
> +	struct isert_conn *isert_conn = (struct isert_conn *)data;
> +	struct ib_cq *tx_cq = isert_conn->conn_tx_cq;
> +	struct iser_tx_desc *tx_desc;
> +	struct ib_wc wc;
> +
> +	while (ib_poll_cq(tx_cq, 1, &wc) == 1) {
> +		tx_desc = (struct iser_tx_desc *)(unsigned long)wc.wr_id;
> +
> +		if (wc.status == IB_WC_SUCCESS) {
> +			isert_send_completion(tx_desc, isert_conn);
> +		} else {
> +			pr_debug("TX wc.status != IB_WC_SUCCESS >>>>>>>>>>>>>>\n");
> +			isert_dump_ib_wc(&wc);
> +			atomic_dec(&isert_conn->post_send_buf_count);
> +			isert_cq_comp_err(tx_desc, isert_conn);
> +		}
> +	}
> +
> +	ib_req_notify_cq(tx_cq, IB_CQ_NEXT_COMP);
> +}
> +
> +void
> +isert_cq_tx_callback(struct ib_cq *cq, void *context)
> +{
> +	struct isert_conn *isert_conn = context;
> +
> +	tasklet_schedule(&isert_conn->conn_tx_tasklet);
> +}
> +
> +void
> +iser_cq_rx_tasklet(unsigned long data)
> +{
> +	struct isert_conn *isert_conn = (struct isert_conn *)data;
> +	struct ib_cq *rx_cq = isert_conn->conn_rx_cq;
> +	struct iser_rx_desc *rx_desc;
> +	struct ib_wc wc;
> +	unsigned long xfer_len;
> +
> +	while (ib_poll_cq(rx_cq, 1, &wc) == 1) {
> +		rx_desc = (struct iser_rx_desc *)(unsigned long)wc.wr_id;
> +
> +		if (wc.status == IB_WC_SUCCESS) {
> +			xfer_len = (unsigned long)wc.byte_len;
> +			isert_rx_completion(rx_desc, isert_conn, xfer_len);
> +		} else {
> +			pr_debug("RX wc.status != IB_WC_SUCCESS >>>>>>>>>>>>>>\n");
> +			if (wc.status != IB_WC_WR_FLUSH_ERR)
> +				isert_dump_ib_wc(&wc);
> +
> +			isert_conn->post_recv_buf_count--;
> +			isert_cq_comp_err(NULL, isert_conn);
> +		}
> +	}
> +
> +	ib_req_notify_cq(rx_cq, IB_CQ_NEXT_COMP);
> +}
