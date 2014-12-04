From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Thu, 04 Dec 2014 08:12:53 +0100
Message-ID: <54800975.2050606@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <201412031929.14767.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020402050205000609040500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaLDHMz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 02:12:55 -0500
In-Reply-To: <201412031929.14767.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020402050205000609040500
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 12/03/2014 07:29 PM, Ondrej Zary wrote:
> On Wednesday 03 December 2014 12:44:53 Hannes Reinecke wrote:
>> Hi all,
>>
>> it has been bugged me for ages that the advansys driver always
>> reported a compilation warning about not having been converted
>> to the DMA-API.
>> And even aggressive waiting hasn't made this warning go away.
>>
>> So here's a patchset to update the advansys driver to current
>> standards and use the DMA-API.
>> Tested on ABP940-U2W.
>>
>> As usual, reviews and comments are welcome.
>>
>> Hannes Reinecke (12):
>>   advansys: use host_reset
>>   advansys: use shared host tag map for command lookup
>>   advansys: use DMA-API for mapping sense buffer
>>   advansys: Use DMA-API for carrier buffer
>>   advansys: Use DMA-API for mapping request blocks
>>   advansys: Use dma_pool for sg elements
>>   advansys: use 'bool' instead of 'int'
>>   advansys: use standard data types
>>   advansys: Remove 'TRUE' and 'FALSE' definitions
>>   advansys: Remove 'ERR' definition
>>   advansys: cleanup function return codes
>>   advansys: Update to version 3.5 and remove compilation warning
>>
>>  MAINTAINERS             |    1 +
>>  drivers/scsi/advansys.c | 1073
>> +++++++++++++++++++++-------------------------- 2 files changed, 469
>> insertions(+), 605 deletions(-)
> 
> Seems to break narrow boards, at least mine ASB-3940UA :(
> 
> [    4.266292] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
> [    7.661374] scsi host2: AdvanSys SCSI 3.5: PCI Ultra: IO 0xA800-0xA80F, IRQ 0x9
> [   28.840078] scsi 2:0:0:0: SCSI bus reset started...
> [   28.846640] scsi 2:0:0:0: SCSI bus reset error: 0x2, status: 0x0
> [   28.846648] scsi 2:0:0:0: Device offlined - not ready after error recovery
> [   28.846803] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.852052] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.860051] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.868047] scsi 2:0:1:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.868249] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.876050] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.884048] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.892047] scsi 2:0:2:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.892243] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.900051] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.908048] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.916047] scsi 2:0:3:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.916241] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.924051] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.932048] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.940048] scsi 2:0:4:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.940240] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.948051] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.956049] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.964047] scsi 2:0:5:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.964239] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.972050] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.980048] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> [   28.988050] scsi 2:0:6:0: ExeScsiQueue() ASC_ERROR, err_code 0x2
> 
> Before the patch:
> [    4.226690] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
> [    7.644841] scsi host2: AdvanSys SCSI 3.4: PCI Ultra: IO 0xA800-0xA80F, IRQ 0x9
> [    8.072257] scsi 2:0:2:0: Processor         HP       C1790A           3226 PQ: 0 ANSI: 2
> [    8.919128] scsi 2:0:2:0: Attached scsi generic sg3 type 3
> 
Right. So _this_ was the mysterious command about srb_tag '0' being
reserved. Can you try with this patch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 21284 (AG Nürnberg)

--------------020402050205000609040500
Content-Type: text/x-patch;
 name="0001-advansys-do-not-use-srb_tag-0-for-narrow-boards.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-advansys-do-not-use-srb_tag-0-for-narrow-boards.patch"

>From 1a2ed278e20636a6b242d9450d36b433af44ddf4 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 4 Dec 2014 08:08:48 +0100
Subject: [PATCH] advansys: do not use srb_tag '0' for narrow boards

The srb_tag '0' is used by the chip internally, so we
need to increase the request tag by 1 to avoid using it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4f3f948..15c555f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7003,8 +7003,11 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	ASC_DBG(1, "asc_dvc_varp 0x%p, qdonep 0x%p\n", asc_dvc_varp, qdonep);
 	ASC_DBG_PRT_ASC_QDONE_INFO(2, qdonep);
 
+	/*
+	 * Decrease the srb_tag by 1 to find the SCSI command
+	 */
 	srb_tag = le32_to_cpu(qdonep->d2.srb_tag);
-	scp = scsi_host_find_tag(boardp->shost, srb_tag);
+	scp = scsi_host_find_tag(boardp->shost, srb_tag - 1);
 	if (!scp)
 		return;
 
@@ -7193,10 +7196,6 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 			scsiq->d3.done_stat = QD_WITH_ERROR;
 			goto FATAL_ERR_QDONE;
 		}
-		/*
-		 * Fixme: this doesn't look right.
-		 * We can easily get an srb_tag of 0.
-		 */
 		if ((scsiq->d2.srb_tag == 0UL) ||
 		    ((scsiq->q_status & QS_ABORTED) != 0)) {
 			return (0x11);
@@ -7775,13 +7774,16 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 {
 	struct asc_dvc_var *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 	int use_sg;
+	u32 srb_tag;
 
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
 
 	/*
-	 * Set the srb_tag to the command tag.
+	 * Set the srb_tag to the command tag + 1, as
+	 * srb_tag '0' is used internally by the chip.
 	 */
-	asc_scsi_q->q2.srb_tag = cpu_to_le32(scp->request->tag);
+	srb_tag = scp->request->tag + 1;
+	asc_scsi_q->q2.srb_tag = cpu_to_le32(srb_tag);
 
 	/*
 	 * Build the ASC_SCSI_Q request.
-- 
1.8.5.2


--------------020402050205000609040500--
