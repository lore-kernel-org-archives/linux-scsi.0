From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC 10/11] iser-target: Add logic for core
Date: Thu, 14 Mar 2013 13:58:35 +0200
Message-ID: <5141BB6B.9060708@mellanox.com>
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

We currently have here the following sequence of calls


isert_cq_rx_callback --> tasklet_schedule ...  --> ...
ib_poll_cq -->  isert_rx_completion --> isert_rx_queue_desc --> 
isert_rx_queue_desc --> queue_work (context switch)

isert_cq_tx_callback --> tasklet_schedule ...  --> ...
ib_poll_cq -->  isert_send_completion --> isert_completion_rdma_read 
-->  queue_work (context switch)

which means we have one context switch from the CQ callback to tasklet 
and then a PER IO context switch
from the tasklet to a kernel thread context which you might need for IO 
submission into the backing store.

This can be optimized by having one context switch from the isert cq 
callbacks to a kernel thread, with the work
item being "do polling" and then from the cq polling code do the 
submission into the backing store without
any further context switches.

Or.



> +
> +void
> +isert_cq_rx_callback(struct ib_cq *cq, void *context)
> +{
> +	struct isert_conn *isert_conn = context;
> +
> +	tasklet_schedule(&isert_conn->conn_rx_tasklet);
> +}
