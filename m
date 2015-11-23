From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 23 Nov 2015 12:28:55 +0200
Message-ID: <5652EA67.1000707@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
 <564851BB.1020004@dev.mellanox.co.il>
 <564A067B.8030504@opengridcomputing.com>
 <003001d1209c$ecb70760$c6251620$@opengridcomputing.com>
 <564A2270.1040004@dev.mellanox.co.il>
 <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


> That won't work for iWARP.  Is this code new?  I didn't see any errors that would result from this code when I tested iSER over
> cxgb4 with the old iwarp support patches.

Steve,

I think I figured out why this works with iWARP.

For iWARP, rdma_disconnect() calls iw_cm_disconnect() with abrupt=0
which would make iw_cm_disconnect() move the QP into SQ_DRAIN state"

int iw_cm_disconnect(struct iw_cm_id *cm_id, int abrupt)
{
	...

         if (qp) {
                 if (abrupt)
                         ret = iwcm_modify_qp_err(qp);
                 else
                         ret = iwcm_modify_qp_sqd(qp);

                 /*
                  * If both sides are disconnecting the QP could
                  * already be in ERR or SQD states
                  */
                 ret = 0;
	}
}

IFAIK, SQD state allows the ULP to post work requests on the send
queue and expect these work requests to FLUSH.

So Maybe we should have:
void ib_drain_qp(struct ib_qp *qp)
{
     struct ib_qp_attr attr = { };
     struct ib_stop_cqe rstop, sstop;
     struct ib_recv_wr rwr = {}, *bad_rwr;
     struct ib_send_wr swr = {}, *bad_swr;
     enum ib_qp_state state;
     int ret;

     if rdma_cap_ib_cm(id->device, id->port_num) {
	state = IB_QPS_ERR;
     else if rdma_cap_iw_cm(id->device, id->port_num)
         state = IB_QPS_SQD;
     else
        return;

     rwr.wr_cqe = &rstop.cqe;
     rstop.cqe.done = ib_stop_done;
     init_completion(&rstop.done);

     swr.wr_cqe = &sstop.cqe;
     sstop.cqe.done = ib_stop_done;
     swr.send_flags = IB_SEND_SIGNALED;
     init_completion(&sstop.done);

     attr.qp_state = state;
     ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
     if (ret) {
         WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
         return;
     }

     ret = ib_post_recv(qp, &rwr, &bad_rwr);
     if (ret) {
         WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
         return;
     }

     ret = ib_post_send(qp, &swr, &bad_swr);
     if (ret) {
         WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
         return;
     }

     wait_for_completion(&rstop.done);
     wait_for_completion(&sstop.done);
}

Thoughts?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
