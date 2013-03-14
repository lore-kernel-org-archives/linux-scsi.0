From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 09/11] iser-target: Add logic for verbs
Date: Thu, 14 Mar 2013 13:42:59 +0200
Message-ID: <5141B7C3.6090908@mellanox.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-10-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362707116-31406-10-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 08/03/2013 03:45, Nicholas A. Bellinger wrote:
> 	isert_conn->conn_rx_cq = ib_create_cq(ib_dev, isert_cq_rx_callback,
> +						isert_cq_event_callback,
> +						(void *)isert_conn,
> +						ISER_MAX_RX_CQ_LEN, 0);
[...]
> +
> +	isert_conn->conn_tx_cq = ib_create_cq(ib_dev, isert_cq_tx_callback,
> +						isert_cq_event_callback,
> +						(void *)isert_conn,
> +						ISER_MAX_TX_CQ_LEN, 0);

Two comments here:

1. This code always attaches the CQ to vector #0 of the IB device. 
Typically vectors are associated with IRQs and IRQs are
"affiniated" with cores, so processing of completions for all 
connections will be carried out on single core at a given time.

What can be done here is to use different vectors for different CQs. The 
possible vector values are from 0 to ib_dev->num_comp_vectors - 1

2. A dedicated CQ pair is used per connection which might not scale well.

What can be done here, is to use a global context per IB device which 
holds a pool of CQs (created on different vectors, per the previous item),
and for each new connection, attach its QP to a CQ pair from this pool, 
e.g as done in drivers/infiniband/ulp/iser/iser_verbs.c :: 
iser_create_device_ib_res()
note that FWIW this context can hold also a global PD and DMA_MR objects 
to be used by all the connections opened on the device. The context can 
be opened on demand (1st connection that hits this IB device) and closed 
on non-demand (last connection).


Or.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
