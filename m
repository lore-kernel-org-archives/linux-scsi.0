From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC 09/11] iser-target: Add logic for verbs
Date: Thu, 14 Mar 2013 13:19:28 +0200
Message-ID: <5141B240.2090100@mellanox.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-10-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1362707116-31406-10-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 08/03/2013 03:45, Nicholas A. Bellinger wrote:
> +++ b/drivers/infiniband/ulp/isert/isert_verbs.c
> +#define ISERT_ADDR_ROUTE_TIMEOUT 1000

remove this define, its irrelevant and you don't use that anywhere

> +static void
> +isert_qp_event_callback(struct ib_event *e, void *context)
> +{
> +	pr_err("isert_qp_event_callback event: %d\n", e->event);
> +}

To be on the safe side, when the event is IB_EVENT_COMM_EST (which means 
that the login request was received by the HCA before the connection was 
fully established), call rdma_notify (id, IB_EVENT_COMM_EST) with the id 
being the one pointed from qp->qp_context->isert_conn


> +
> +static int
> +isert_query_device(struct ib_device *ib_dev, struct ib_device_attr *devattr)
> +{
> +	int ret;
> +
> +	ret = ib_query_device(ib_dev, devattr);
> +	if (ret) {
> +		pr_err("ib_query_device() failed: %d\n", ret);
> +		return ret;
> +	}
> +	pr_debug("devattr->max_mr_size: 0x%016Lx\n", devattr->max_mr_size);

running user space "ibv_devinfo -v" will give the same effect... no need 
to dump this here, maybe
except for max_sge that you need.

> +	pr_debug("devattr->page_size_cap: 0x%016Lx\n", devattr->page_size_cap);
> +	pr_debug("devattr->max_qp: %d\n", devattr->max_qp);
> +	pr_debug("devattr->max_qp_wr: %d\n", devattr->max_qp_wr);
> +	pr_debug("devattr->device_cap_flags: 0x%08x\n", devattr->device_cap_flags);
> +	pr_debug("devattr->max_sge: %d\n", devattr->max_sge);
> +	pr_debug("devattr->max_sge_rd: %d\n", devattr->max_sge_rd);
> +	pr_debug("devattr->max_cq: %d\n", devattr->max_cq);
> +	pr_debug("devattr->max_cqe: %d\n", devattr->max_cqe);
> +	pr_debug("devattr->max_mr: %d\n", devattr->max_mr);
> +	pr_debug("devattr->max_pd: %d\n", devattr->max_pd);
> +	pr_debug("devattr->max_rdd: %d\n", devattr->max_rdd);
> +	pr_debug("devattr->max_mw: %d\n", devattr->max_mw);
> +	pr_debug("devattr->max_srq: %d\n", devattr->max_srq);
> +	pr_debug("devattr->max_srq_wr: %d\n", devattr->max_srq_wr);
> +	pr_debug("devattr->max_srq_sge: %d\n", devattr->max_srq_sge);
> +
> +	return 0;
> +}
[...]
> +
> +
> +int
> +isert_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
> +{
> +	int ret = 0;
> +
> +	pr_debug("isert_cma_handler: event %d status %d conn %p id %p\n",
> +		event->event, event->status, cma_id->context, cma_id);
> +
> +	switch (event->event) {
> +	case RDMA_CM_EVENT_CONNECT_REQUEST:
> +		pr_debug("RDMA_CM_EVENT_CONNECT_REQUEST: >>>>>>>>>>>>>>>\n");
> +		ret = isert_connect_request(cma_id, event);
> +		break;
> +	case RDMA_CM_EVENT_ESTABLISHED:
> +		pr_debug("RDMA_CM_EVENT_ESTABLISHED >>>>>>>>>>>>>>\n");
> +		isert_connected_handler(cma_id);
> +		break;
> +	case RDMA_CM_EVENT_DISCONNECTED:
> +		pr_debug("RDMA_CM_EVENT_DISCONNECTED: >>>>>>>>>>>>>>\n");
> +		isert_disconnected_handler(cma_id);
> +		break;
> +	case RDMA_CM_EVENT_DEVICE_REMOVAL:
> +	case RDMA_CM_EVENT_ADDR_CHANGE:
> +		break;
> +	case RDMA_CM_EVENT_ADDR_ERROR:
> +	case RDMA_CM_EVENT_ROUTE_ERROR:
> +	case RDMA_CM_EVENT_CONNECT_ERROR:
> +	default:
> +		pr_err("Unknown RDMA CMA event: %d\n", event->event);
> +		break;
> +	}
> +

ADDR_ERROR and ROUTE_ERROR you can remove from here, since you don't 
call rdma_resolve_addr nor rdma_resolve_route, they
will not be delivered to you.
