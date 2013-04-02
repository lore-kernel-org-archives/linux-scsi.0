From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 11/12] iser-target: Add logic for core
Date: Tue, 02 Apr 2013 15:23:35 -0700
Message-ID: <1364941415.3898.190.camel@haakon2.linux-iscsi.org>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
	 <1363996536-30644-12-git-send-email-nab@linux-iscsi.org>
	 <515A97DD.40507@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33884 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762011Ab3DBWXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Apr 2013 18:23:39 -0400
In-Reply-To: <515A97DD.40507@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>

On Tue, 2013-04-02 at 11:33 +0300, Or Gerlitz wrote:
> On 23/03/2013 01:55, Nicholas A. Bellinger wrote:
> > +++ b/drivers/infiniband/ulp/isert/isert_core.h
> > @@ -0,0 +1,11 @@
> > +#include <linux/socket.h>
> > +#include <linux/in.h>
> > +#include <linux/in6.h>
> > +#include <rdma/ib_verbs.h>
> > +#include <rdma/rdma_cm.h>
> > +
> > +extern void iser_cq_tx_tasklet(unsigned long);
> > +extern void isert_cq_tx_callback(struct ib_cq *, void *);
> > +extern void iser_cq_rx_tasklet(unsigned long);
> > +extern void isert_cq_rx_callback(struct ib_cq *, void *);
> > +extern void isert_free_rx_descriptors(struct isert_conn *);
> 
> no need for externs here too, agree? also, any reason for these two 
> header files not
> to be merged into one or into one of the other header files?
> 

<nod>, merging into a single source/include for RFC-v3 code.

> > diff --git a/drivers/infiniband/ulp/isert/isert_verbs.h b/drivers/infiniband/ulp/isert/isert_verbs.h
> > new file mode 100644
> > index 0000000..da7924d
> > --- /dev/null
> > +++ b/drivers/infiniband/ulp/isert/isert_verbs.h
> > @@ -0,0 +1,5 @@
> > +extern void isert_connect_release(struct isert_conn *);
> > +extern void isert_put_conn(struct isert_conn *);
> > +extern int isert_cma_handler(struct rdma_cm_id *, struct rdma_cm_event *);
> > +extern int isert_post_recv(struct isert_conn *, u32);
> > +extern int isert_post_send(struct isert_conn *, struct iser_tx_desc *);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


