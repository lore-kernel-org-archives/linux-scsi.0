From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 03/28] libfc: IO errors on link down due to cable unplug
Date: Wed, 28 Jul 2010 02:32:06 -0500
Message-ID: <4C4FDCF6.2070105@cs.wisc.edu>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>	 <20100720221920.17116.59505.stgit@localhost.localdomain>	 <4C466986.5040801@cs.wisc.edu> <1280266320.31061.2590.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030405050601080004020707"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34086 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab0G1Hcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 03:32:45 -0400
In-Reply-To: <1280266320.31061.2590.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Robert Love <robert.w.love@intel.com>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, devel@open-fcoe.org

This is a multi-part message in MIME format.
--------------030405050601080004020707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/27/2010 04:32 PM, Vasu Dev wrote:
>> This isn't one of those races where you are blocking the rport, but the
>> IO keeps coming around so the retries are used really quickly right (the
>> driver looks like it has the fc class and internal state checks to
>> prevent this but I wanted to make sure).
>

I think I am hitting the above problem.

>
> This tiny time windows can be further reduced by use of wmb() on rport
> state change to block and lport getting out of ready since their states
> are checked w/o lock in queuecommand path.

I think you need something like this for the lport queue ready check. 
It looks like the initial failure from __fc_linkdown->fc_fcp_cleanup 
burned a timeout. Then because it missed the lport ready check, it will 
use an extra retry just sitting there timing out.

For the rport state check, I think you are supposed to call the fc 
chkready function under the host lock. The port state and flags are set 
under it. I did the attached patch for that.

--------------030405050601080004020707
Content-Type: text/x-patch;
 name="libfc-hold-host-lock-when-checking-rport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="libfc-hold-host-lock-when-checking-rport.patch"

libfc: call fc_remote_port_chkready under the host lock.

The rport port state and flags are set under the host lock,
so this patch calls fc_remote_port_chkready with the host lock
held like is also done in the other fc drivers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index eac4d09..a116846 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1765,14 +1768,14 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	struct fcoe_dev_stats *stats;
 
 	lport = shost_priv(sc_cmd->device->host);
-	spin_unlock_irq(lport->host->host_lock);
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
 		done(sc_cmd);
-		goto out;
+		return 0;
 	}
+	spin_unlock_irq(lport->host->host_lock);
 
 	if (!*(struct fc_remote_port **)rport->dd_data) {
 		/*

--------------030405050601080004020707--
