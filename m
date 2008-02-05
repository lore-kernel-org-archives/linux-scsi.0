From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: 2.6.24 regression w/ QLA2300
Date: Tue, 5 Feb 2008 08:15:01 -0800
Message-ID: <20080205161501.GG19882@plap3.qlogic.org>
References: <47A88736.6090706@hp.com> <20080205160246.GF19882@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5181 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYBEQPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 11:15:04 -0500
Content-Disposition: inline
In-Reply-To: <20080205160246.GF19882@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Seokmann Ju <seokmann.ju@qlogic.com>

On Tue, 05 Feb 2008, Andrew Vasquez wrote:

> On Tue, 05 Feb 2008, Alan D. Brunelle wrote:
> 
> > commit 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
> > Merge: 50d9a12... 23c3e29...
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Fri Jan 25 17:19:08 2008 -0800
> > 
> >     Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
> > 
> >     * git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6: (200 commits)
> > 
> > I believe a regression was introduced. I'm running on a 4-way IA64,
> > with straight 2.6.24 and 2 dual-port cards:
> > 
> > 40:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> > 40:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> > c0:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> > c0:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
> > 
> > the adapters failed initialization. In particular, I narrowed it down
> > to failing the qla2x00_mbox_command call within qla2x00_init_firmware
> > function. I went and removed the qla2x00-related parts of this (large-ish)
> > merge, and the 4 ports initialized just fine.
> 
> Could you load the (default 2.6.24) driver with
> ql2xextended_error_logging modules parameter set:
> 
> 	# insmod qla2xxx ql2xextended_error_logging=1
> 
> and send the resultant kernel logs?

Could you tray the patch referenced here:

qla2xxx: Correct issue where incorrect init-fw mailbox command was used on non-NPIV capable ISPs.
http://article.gmane.org/gmane.linux.scsi/38240

Thanks, av

---

qla2xxx: Correct issue where incorrect init-fw mailbox command was used on non-NPIV capable ISPs.

BIT_2 of the firmware attributes is only valid on FW-interface-2
type HBAs.  Code in commit
c48339decceec8e011498b0fc4c7c7d8b2ea06c1 would cause the
incorrect initialize-firmware mailbox command to be issued for
non-NPIV capable ISPs.  Correct this by reverting to previously
used (and correct) pre-condition 'if' check.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0c10c0b..99d29ff 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -980,7 +980,7 @@ qla2x00_init_firmware(scsi_qla_host_t *ha, uint16_t size)
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
 	    ha->host_no));
 
-	if (ha->fw_attributes & BIT_2)
+	if (ha->flags.npiv_supported)
 		mcp->mb[0] = MBC_MID_INITIALIZE_FIRMWARE;
 	else
 		mcp->mb[0] = MBC_INITIALIZE_FIRMWARE;
-- 
1.5.4.rc5.5.gab98

