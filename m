From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_tcp: fix potential lockup with write commands
Date: Thu, 25 Oct 2007 17:17:43 -0500
Message-ID: <47211607.5090801@cs.wisc.edu>
References: <4720F358.8030307@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52440 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbXJYWRu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 18:17:50 -0400
In-Reply-To: <4720F358.8030307@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org

Tony Battersby wrote:
> There is a race condition in iscsi_tcp.c that may cause it to forget
> that it received a R2T from the target.  This race may cause a data-out
> command (such as a write) to lock up.  The race occurs here:
> 
> static int
> iscsi_send_unsol_pdu(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
> {
> 	struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
> 	int rc;
> 
> 	if (tcp_ctask->xmstate & XMSTATE_UNS_HDR) {
> 		BUG_ON(!ctask->unsol_count);
> 		tcp_ctask->xmstate &= ~XMSTATE_UNS_HDR; <---- RACE
> 		...
> 
> static int
> iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
> {
> 	...
> 	tcp_ctask->xmstate |= XMSTATE_SOL_HDR_INIT; <---- RACE
> 	...
> 
> While iscsi_xmitworker() (called from scsi_queue_work()) is preparing to
> send unsolicited data, iscsi_tcp_data_recv() (called from
> tcp_read_sock()) interrupts it upon receipt of a R2T from the target.
> Both contexts do read-modify-write of tcp_ctask->xmstate.  Usually, gcc
> on x86 will make &= and |= atomic on UP (not guaranteed of course), but
> in this case iscsi_send_unsol_pdu() reads the value of xmstate before
> clearing the bit, which causes gcc to read xmstate into a CPU register,
> test it, clear the bit, and then store it back to memory.  If the recv
> interrupt happens during this sequence, then the XMSTATE_SOL_HDR_INIT
> bit set by the recv interrupt will be lost, and the R2T will be
> forgotten.
> 
> The patch below (against 2.6.24-rc1) converts accesses of xmstate to use
> set_bit, clear_bit, and test_bit instead of |= and &=.  I have tested
> this patch and verified that it fixes the problem.  Another possible
> approach would be to hold a lock during most of the rx/tx setup and
> post-processing, and drop the lock only for the actual rx/tx.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

We are going to remove that code in 2.6.25. Your patch looks good for 
2.6.24. Nice debugging, and thanks for the patch and nice write up. I 
think someone else was in the middle of hunting for this right now too.

James, could you please apply for the next round of 2.6.24 bug fixes?

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
