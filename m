From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx:  Re: fc remote port timeout with qla2xxx driver
Date: Tue, 20 Sep 2005 13:32:11 -0700
Message-ID: <20050920203211.GA22417@plap.qlogic.org>
References: <20050831060134.GA26115@usyd.edu.au> <20050831224409.GL11577@plap.qlogic.org> <20050901025838.GI27270@usyd.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:9418 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S964920AbVITUcQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 16:32:16 -0400
Content-Disposition: inline
In-Reply-To: <20050901025838.GI27270@usyd.edu.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Rudolph Pereira <rudolph@usyd.edu.au>

On Thu, 01 Sep 2005, Rudolph Pereira wrote:

> On Wed, Aug 31, 2005 at 03:44:09PM -0700, Andrew Vasquez wrote:
> > Hmm, could you try the attached small patch?  This should close that
> > whole where the fc_remote_port state is restored to a correct state.
> This seems to fix the problem. The debug now shows:
> ...
> 
> Sep  1 10:05:15 baku kernel: scsi(0): LOOP READY
> Sep  1 10:05:15 baku kernel: scsi(0): qla2x00_loop_resync - end
> Sep  1 10:05:36 baku kernel: scsi(0): Port Update -- creating RSCN fcport f7c2a080 for 81/7/6000.
> Sep  1 10:05:36 baku kernel: scsi(0): Handle RSCN -- process RSCN for fcport [ffffff].
> Sep  1 10:05:36 baku kernel: scsi(0): Handle RSCN -- attempting login to [81/ffffff].
> Sep  1 10:05:36 baku kernel: scsi(0): Sending Login IOCB (a0004000) to [81/ffffff].
> Sep  1 10:05:36 baku kernel: scsi(0): Port login retry: 210000d02367d125, id = 0x0081 retry cnt=10
> Sep  1 10:05:36 baku kernel: scsi(0): Process IODesc -- processing a0004000.
> Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- loop id [81] used by port id [0b1132].
> Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- retrying login to [81/0b1132] (2).
> Sep  1 10:05:36 baku kernel: scsi(0): Sending Login IOCB (a0005000) to [81/0b1132].
> Sep  1 10:05:36 baku kernel: scsi(0): Process IODesc -- processing a0005000.
> Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- status=0 mb1=0 pn=210000d02367d125.
> Sep  1 10:05:36 baku kernel: scsi(0): fcport-0 - port retry count: 29 remaining
> Sep  1 10:05:36 baku kernel: scsi(0): qla2x00_port_login()
> Sep  1 10:05:36 baku kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 for port 0b1132.
> Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- found RSCN fcport in fcports list [f7db8100].
> Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- marking existing fcport [81/0b1132] online.
> Sep  1 10:05:36 baku kernel: scsi(0): Login IOCB -- Freeing RSCN fcport f7c2a080 [81/0b1132].
> Sep  1 10:05:36 baku kernel: scsi(0): port login OK: logged in ID 0x81
> Sep  1 10:05:36 baku kernel: scsi(0): qla2x00_port_login - end

James,


Please apply the attached patch which fixes a hole in the rport
unblock handling when processing fabric events via the ADISC/PLOGI
device state machine.  Original code would not properly 'unblock' the
port upon the port reloging into the fabric.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---
diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -330,6 +330,8 @@ qla2x00_update_login_fcport(scsi_qla_hos
 	fcport->flags &= ~FCF_FAILOVER_NEEDED;
 	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
 	atomic_set(&fcport->state, FCS_ONLINE);
+	if (fcport->rport)
+		fc_remote_port_unblock(fcport->rport);
 }
 
 
