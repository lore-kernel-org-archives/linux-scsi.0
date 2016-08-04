From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: IB/isert: Return value of iser target transport handlers ignored by
 iscsi target
Date: Thu, 4 Aug 2016 16:05:07 +0530
Message-ID: <20160804103506.GA29543@t5fpga-b1.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:39726 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757192AbcHDKjE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2016 06:39:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sagi@grimberg.me, nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, swise@opengridcomputing.com, varun@chelsio.com, rajur@chelsio.com

Hi,
In iSER target during iwarp connection tear-down due to ping timeouts, the rdma
queues are set to error state and subsequent queued iscsi session commands posted 
shall fail with corresponding errno returned by ib_post_send/recv. 
At this stage iser target handlers (Ex: isert_put_datain())
return the error to iscsci target, but these errors are 
not being handled by the iscsi target handlers(Ex: lio_queue_status()).

-> While closing the session in case of ping timeouts, isert_close_connection()-> 
isert_wait_conn()->isert_wait4cmds() checks for the queued session commands 
and waits infinitely for command completion 'cmd_wait_comp' in target_wait_for_sess_cmds().
'cmd_wait_comp' will be never complete as the kref on the session command is 
not derefed, due to which target_release_cmd_kref() is not called by kref_put().
Due to this, the older session is not cleared causing the next login negotiation to fail
as the older session is still active(Older SID exists).

[Query 1] If the return value of ib_post_send/recv() are handled to deref the
corresponding queued session commands, the wait on cmd_wait_comp will be
complete and clears off the session successfully. Is this the rightway to
do it here?

[Query 2] An extra deref is done in case of transport_status CMD_T_TAS 
in target_wait_for_sess_cmds(), can similar 
implementation be done for transport state CMD_T_FABRIC_STOP?

Can someone shed some light on these aspects.
Thanks in advance.


Thanks,
Bharat.
