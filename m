From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 5/6] iser-target: Ignore completions for FRWRs in
 isert_cq_tx_work
Date: Tue, 04 Mar 2014 15:56:34 -0800
Message-ID: <1393977394.30113.0.camel@haakon3.risingtidesystems.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
	 <1393891265-22910-6-git-send-email-nab@daterainc.com>
	 <5315E85F.2090904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5315E85F.2090904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-03-04 at 16:51 +0200, Sagi Grimberg wrote:
> On 3/4/2014 2:01 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> >
> > This patch changes IB_WR_FAST_REG_MR + IB_WR_LOCAL_INV related
> > work requests to include a ISER_FRWR_LI_WRID value in order to
> > signal isert_cq_tx_work() that these requests should be ignored.
> >
> > This is necessary because even though IB_SEND_SIGNALED is not
> > set for either work request, during a QP failure event the work
> > requests will be returned with exception status from the TX
> > completion queue.
> >
> > Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> > ---
> >   drivers/infiniband/ulp/isert/ib_isert.c |    8 ++++++--
> >   drivers/infiniband/ulp/isert/ib_isert.h |    1 +
> >   2 files changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> > index c9d488f..003b5d0 100644
> > --- a/drivers/infiniband/ulp/isert/ib_isert.c
> > +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> > @@ -1738,8 +1738,10 @@ isert_cq_tx_work(struct work_struct *work)
> >   			pr_debug("TX wc.status: 0x%08x\n", wc.status);
> >   			pr_debug("TX wc.vendor_err: 0x%08x\n", wc.vendor_err);
> >   
> > -			atomic_dec(&isert_conn->post_send_buf_count);
> > -			isert_cq_tx_comp_err(tx_desc, isert_conn);
> > +			if (wc.wr_id != ISER_FRWR_LI_WRID) {
> 
> Better to use ISER_FASTREG_LI_WRID - I changed it in the initiator.

<nod>, updating that bit now..

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
