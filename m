From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [KJ] [PATCH 11/14] scsi/lpfc_scsi: use msleep() instead of schedule_timeout()
Date: Sun, 10 Jul 2005 22:38:13 -0700
Message-ID: <20050711053813.GB14070@us.ibm.com>
References: <20050709000324.GD2596@us.ibm.com> <20050709001458.GQ2596@us.ibm.com> <20050710162009.GA2468@homer.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:42952 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262243AbVGKFqG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2005 01:46:06 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j6B5k5OM552296
	for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2005 01:46:05 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j6B5k52D424952
	for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2005 23:46:05 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j6B5k5gH013758
	for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2005 23:46:05 -0600
Content-Disposition: inline
In-Reply-To: <20050710162009.GA2468@homer.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Domen Puncer <domen@coderock.org>
Cc: James.Bottomley@SteelEye.com, Kernel-Janitors <kernel-janitors@lists.osdl.org>, linux-scsi@vger.kernel.org

On 10.07.2005 [18:20:10 +0200], Domen Puncer wrote:
> On 08/07/05 17:14 -0700, Nishanth Aravamudan wrote:
> > From: Nishanth Aravamudan <nacc@us.ibm.com>
> > 
> > Description: Replace schedule_timeout() with msleep() to guarantee the
> > task delays as expected.
> > 
> > Patch is compile-tested.
> > 
> > Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> > 
> > ---
> > 
> >  lpfc_scsi.c |   13 +++++--------
> >  1 files changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff -urp 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c
> > --- 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 07:57:19.000000000 -0700
> > +++ 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 19:20:41.000000000 -0700
> ...
> > @@ -1110,8 +1108,7 @@ __lpfc_reset_bus_handler(struct scsi_cmn
> >  				&phba->sli.ring[phba->sli.fcp_ring],
> >  				0, 0, LPFC_CTX_HOST))) {
> >  		spin_unlock_irq(phba->host->host_lock);
> > -		set_current_state(TASK_UNINTERRUPTIBLE);
> > -		schedule_timeout(LPFC_RESET_WAIT*HZ);
> > +		msleep(LPFC_RESET_WAIT * HZ);
> 
> 					^^ ??
> I assume you meant 1000.

Gah! You are right. Fixed below. Thanks, Domen!

-Nish

Description: Replace schedule_timeout() with msleep() to guarantee the
task delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---

 lpfc_scsi.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff -urp 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c
--- 2.6.13-rc2-kj/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 07:57:19.000000000 -0700
+++ 2.6.13-rc2-kj-dev/drivers/scsi/lpfc/lpfc_scsi.c	2005-07-06 19:20:41.000000000 -0700
@@ -24,6 +24,7 @@
 
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -885,8 +886,7 @@ __lpfc_abort_handler(struct scsi_cmnd *c
 		while (cmnd->host_scribble)
 		{
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(LPFC_ABORT_WAIT*HZ);
+			msleep(LPFC_ABORT_WAIT * 1000);
 			spin_lock_irq(phba->host->host_lock);
 			if (++loop_count
 			    > (2 * phba->cfg_nodev_tmo)/LPFC_ABORT_WAIT)
@@ -952,8 +952,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 
 		if (pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 			spin_unlock_irq(phba->host->host_lock);
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout( HZ/2);
+			msleep(500);
 			spin_lock_irq(phba->host->host_lock);
 		}
 		if ((pnode) && (pnode->nlp_state == NLP_STE_MAPPED_NODE))
@@ -1011,8 +1010,7 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 				       cmnd->device->id, cmnd->device->lun,
 				       LPFC_CTX_LUN))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		msleep(LPFC_RESET_WAIT * 1000);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
@@ -1110,8 +1108,7 @@ __lpfc_reset_bus_handler(struct scsi_cmn
 				&phba->sli.ring[phba->sli.fcp_ring],
 				0, 0, LPFC_CTX_HOST))) {
 		spin_unlock_irq(phba->host->host_lock);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(LPFC_RESET_WAIT*HZ);
+		msleep(LPFC_RESET_WAIT * 1000);
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
