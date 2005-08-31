From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: fc remote port timeout with qla2xxx driver
Date: Wed, 31 Aug 2005 15:44:09 -0700
Message-ID: <20050831224409.GL11577@plap.qlogic.org>
References: <20050831060134.GA26115@usyd.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:46402 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932538AbVHaWoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 18:44:14 -0400
Content-Disposition: inline
In-Reply-To: <20050831060134.GA26115@usyd.edu.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rudolph Pereira <rudolph@usyd.edu.au>
Cc: linux-scsi@vger.kernel.org

On Wed, 31 Aug 2005, Rudolph Pereira wrote:

> Aug 31 15:55:16 baku kernel: scsi(0): Sending Login IOCB (a0005000) to [81/0b1132].
> Aug 31 15:55:16 baku kernel: scsi(0): Process IODesc -- processing a0005000.
> Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- status=0 mb1=0 pn=210000d02367d125.
> Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- found RSCN fcport in fcports list [f7c84600].
> Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- marking existing fcport [81/0b1132] online.
> Aug 31 15:55:16 baku kernel: scsi(0): Login IOCB -- Freeing RSCN fcport f5c12d80 [81/0b1132].
> Aug 31 15:55:16 baku kernel: scsi(0): port login OK: logged in ID 0x81
> Aug 31 15:55:16 baku kernel: scsi(0): qla2x00_port_login - end
> Aug 31 15:55:50 baku kernel:  rport-0:0-0: blocked FC remote port time out: removing target
> 
> at this point, the path is no longer unavailable, whereas it should be
> (everything's physically connected). The most worrying indication is the
> final "blocked FC remote port time out" which seems like the port is not
> being unblocked when it should.
> 
> Has anyone seen this issue, and is it known, and if so, are there any
> fixes for it?

Hmm, could you try the attached small patch?  This should close that
whole where the fc_remote_port state is restored to a correct state.

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
 
 
