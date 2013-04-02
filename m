From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC-v2 11/12] iser-target: Add logic for core
Date: Tue, 2 Apr 2013 11:33:33 +0300
Message-ID: <515A97DD.40507@mellanox.com>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org> <1363996536-30644-12-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363996536-30644-12-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 23/03/2013 01:55, Nicholas A. Bellinger wrote:
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

no need for externs here too, agree? also, any reason for these two 
header files not
to be merged into one or into one of the other header files?

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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
