From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 03/15] lpfc: Add support for ELS LCB.
Date: Sun, 24 May 2015 14:28:03 +0200
Message-ID: <20150524142803.000063f5@localhost>
References: <555e1c06.2WPAB9vE6mCM5B9Z%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49584 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbbEXM2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 May 2015 08:28:04 -0400
In-Reply-To: <555e1c06.2WPAB9vE6mCM5B9Z%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> 
> Add support for ELS LCB.
> 
> Also has a little whitespace fixing.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |   1 +
>  drivers/scsi/lpfc/lpfc_els.c  | 239 +++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/lpfc/lpfc_hw.h   |  32 ++++++
>  drivers/scsi/lpfc/lpfc_hw4.h  |  27 ++++-
>  drivers/scsi/lpfc/lpfc_init.c |   2 +
>  drivers/scsi/lpfc/lpfc_sli4.h |  11 ++
>  6 files changed, 306 insertions(+), 6 deletions(-)

snip

> +/**
> + * lpfc_els_rcv_lcb - Process an unsolicited LCB
> + * @vport: pointer to a host virtual N_Port data structure.
> + * @cmdiocb: pointer to lpfc command iocb data structure.
> + * @ndlp: pointer to a node-list data structure.
> + *
> + * This routine processes an unsolicited LCB(LINK CABLE BEACON) IOCB.
> + * First, the payload of the unsolicited LCB is checked.
> + * Then based on Subcommand beacon will either turn on or off.
> + *
> + * Return code
> + * 0 - Sent the acc response
> + * 1 - Sent the reject response.
> + **/
> +static int
> +lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
> +		 struct lpfc_nodelist *ndlp)
> +{
> +	struct lpfc_hba *phba = vport->phba;
> +	struct lpfc_dmabuf *pcmd;
> +	IOCB_t *icmd;
> +	uint8_t *lp;
> +	struct fc_lcb_request_frame *beacon;
> +	struct lpfc_lcb_context *lcb_context;
> +	uint8_t state, rjt_err;
> +	struct ls_rjt stat;
> +
> +	icmd = &cmdiocb->iocb;
> +	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
> +	lp = (uint8_t *)pcmd->virt;
> +	beacon = (struct fc_lcb_request_frame *)pcmd->virt;
> +
> +	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
> +			"0192 ELS LCB Data x%x x%x x%x x%x sub x%x "
> +			"type x%x frequency %x duration x%x\n",
> +			lp[0], lp[1], lp[2],
> +			beacon->lcb_command,
> +			beacon->lcb_sub_command,
> +			beacon->lcb_type,
> +			beacon->lcb_frequency,
> +			be16_to_cpu(beacon->lcb_duration));
> +

checkpatch suggests to not split this user-visible string.

Sebastian
