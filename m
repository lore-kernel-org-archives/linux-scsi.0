From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing task
Date: Fri, 3 Sep 2010 17:13:03 -0500
Message-ID: <20100903221303.GA9527@localhost.localdomain>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab0ICWR5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:17:57 -0400
Content-Disposition: inline
In-Reply-To: <4C5C448C.2040509@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 06, 2010 at 08:21:16PM +0300, Konstantinos Skarlatos wrote:
>  Hello,
> 
> Does this patch fix any of the mvs_abort_task:rc= 5 and the other 
> problems that are being reported for this driver? for more info please 
> see http://marc.info/?l=linux-scsi&m=127583131805429&w=2
> 

Hello,

Can you see if this patch prevents the ata_qc_issue warning?

Thanks,
David

 drivers/scsi/libsas/sas_ata.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 042153c..ddbade7 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -347,6 +347,7 @@ static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
 static struct ata_port_operations sas_sata_ops = {
 	.phy_reset		= sas_ata_phy_reset,
 	.post_internal_cmd	= sas_ata_post_internal,
+	.qc_defer               = ata_std_qc_defer,
 	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= sas_ata_qc_issue,
 	.qc_fill_rtf		= sas_ata_qc_fill_rtf,
