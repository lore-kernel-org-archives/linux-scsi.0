From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 23 Nov 2015 08:44:05 -0600
Message-ID: <000501d125fd$674231c0$35c69540$@opengridcomputing.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-4-git-send-email-hch@lst.de> <564851BB.1020004@dev.mellanox.co.il> <564A067B.8030504@opengridcomputing.com> <003001d1209c$ecb70760$c6251620$@opengridcomputing.com> <564A2270.1040004@dev.mellanox.co.il> <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com> <5652EA67.1000707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.opengridcomputing.com ([72.48.136.20]:43212 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbbKWOoE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Nov 2015 09:44:04 -0500
In-Reply-To: <5652EA67.1000707@dev.mellanox.co.il>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sagi Grimberg' <sagig@dev.mellanox.co.il>, 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig@dev.mellanox.co.il]
> Sent: Monday, November 23, 2015 4:29 AM
> To: Steve Wise; 'Christoph Hellwig'; linux-rdma@vger.kernel.org
> Cc: bart.vanassche@sandisk.com; axboe@fb.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
> 
> 
> > That won't work for iWARP.  Is this code new?  I didn't see any errors that would result from this code when I tested iSER over
> > cxgb4 with the old iwarp support patches.
> 
> Steve,
> 
> I think I figured out why this works with iWARP.
> 
> For iWARP, rdma_disconnect() calls iw_cm_disconnect() with abrupt=0
> which would make iw_cm_disconnect() move the QP into SQ_DRAIN state"
>

Yes.  Note:  SQ_DRAIN == CLOSING state for iWARP QPs.   CLOSING state means the transport will try and do an orderly shutdown.
More on this below.
 
> int iw_cm_disconnect(struct iw_cm_id *cm_id, int abrupt)
> {
> 	...
> 
>          if (qp) {
>                  if (abrupt)
>                          ret = iwcm_modify_qp_err(qp);
>                  else
>                          ret = iwcm_modify_qp_sqd(qp);
> 
>                  /*
>                   * If both sides are disconnecting the QP could
>                   * already be in ERR or SQD states
>                   */
>                  ret = 0;
> 	}
> }
> 
> IFAIK, SQD state allows the ULP to post work requests on the send
> queue and expect these work requests to FLUSH.
> 

The iWARP QP states are different from IB unfortunately.  And the way iWARP was plugged into the original IB-centric RDMA subsystem,
this difference is not very visible.  Moving an iWARP to CLOSING/SQD begins an "orderly close" of the TCP connection.  IE TCP FIN,
FIN/ACK, ACK.   

> So Maybe we should have:
> void ib_drain_qp(struct ib_qp *qp)
> {
>      struct ib_qp_attr attr = { };
>      struct ib_stop_cqe rstop, sstop;
>      struct ib_recv_wr rwr = {}, *bad_rwr;
>      struct ib_send_wr swr = {}, *bad_swr;
>      enum ib_qp_state state;
>      int ret;
> 
>      if rdma_cap_ib_cm(id->device, id->port_num) {
> 	state = IB_QPS_ERR;
>      else if rdma_cap_iw_cm(id->device, id->port_num)
>          state = IB_QPS_SQD;
>      else
>         return;
> 
>      rwr.wr_cqe = &rstop.cqe;
>      rstop.cqe.done = ib_stop_done;
>      init_completion(&rstop.done);
> 
>      swr.wr_cqe = &sstop.cqe;
>      sstop.cqe.done = ib_stop_done;
>      swr.send_flags = IB_SEND_SIGNALED;
>      init_completion(&sstop.done);
> 
>      attr.qp_state = state;
>      ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>      if (ret) {
>          WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
>          return;
>      }
> 
>      ret = ib_post_recv(qp, &rwr, &bad_rwr);
>      if (ret) {
>          WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
>          return;
>      }
> 
>      ret = ib_post_send(qp, &swr, &bad_swr);
>      if (ret) {
>          WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
>          return;
>      }
> 
>      wait_for_completion(&rstop.done);
>      wait_for_completion(&sstop.done);
> }
> 
> Thoughts?

The problem with moving the QP -> CLOSING (aka SQD) is this:  as per the iWARP Verbs spec, ULPS _must_ quiesce the SQ before moving
it to CLOSING.  IE make sure there are no outstanding SQ WRs.  So the drain operation really has to be done _before_ the move to
CLOSING/SQD. :(  If there _are_ outstanding SQ WRs when an attempt to move the QP to CLOSING, or an ingress RDMA operation arrives
while the QP is in CLOSING (and doing a TCP fin/fin-ack exchange), the QP is immediately moved to ERROR.   Also, no WR posts are
allowed while the QP is in CLOSING, unlike the IB SQD state.

The valid drain logic that I think needs to be implemented to support iWARP is one of two methods:

1) as I said before, enhance the ib_qp struct to have a "flush complete" completion object, changes the providers to all complete
that object when a) they are in ERROR and b) the SQ and RQ become empty (or is already empty).  Then ib_drain_qp() just waits for
this completion.

2) change the iwarp providers to allow posting WRs while in ERROR.  One way is do this and still support the requirement that "at
some point while in error, the provider must synchronously fail posts", is to allow the posts if the SQ or RQ still has pending WRs,
but fail immediately if the SQ or RQ is already empty.  Thus the "drain" WRs issued by iw_drain_qp() would work if they were needed,
and fail immediately if they are not needed.  In either case, the flush operation is complete.

I really wish the iWARP spec architects had avoided these sorts of diversions from the IB spec....

Steve.



