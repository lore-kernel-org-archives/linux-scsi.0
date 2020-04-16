Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35590C2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 175FF2078B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439268AbgDPHcw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:32:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:58170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438944AbgDPHcs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 03:32:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 069E4AD08;
        Thu, 16 Apr 2020 07:32:45 +0000 (UTC)
Subject: Re: [PATCH v3 19/31] elx: efct: Hardware IO and SGL initialization
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-20-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f39bc2d6-bae6-bda7-a913-90a1a28cb17b@suse.de>
Date:   Thu, 16 Apr 2020 09:32:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-20-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines to create IO interfaces (wqs, etc), SGL initialization,
> and configure hardware features.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Request tag pool(reqtag_pool) handling fuctions.
> ---
>   drivers/scsi/elx/efct/efct_hw.c | 657 ++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_hw.h |  42 +++
>   2 files changed, 699 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 3e9906749da2..892493a3a35e 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
[ .. ]
> +enum efct_hw_rtn
> +efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
> +		 bool send_abts, void *cb, void *arg)
> +{
> +	enum sli4_abort_type atype = SLI_ABORT_MAX;
> +	u32 id = 0, mask = 0;
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	struct hw_wq_callback *wqcb;
> +	unsigned long flags = 0;
> +
> +	if (!io_to_abort) {
> +		efc_log_err(hw->os,
> +			     "bad parameter hw=%p io=%p\n",
> +			    hw, io_to_abort);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (hw->state != EFCT_HW_STATE_ACTIVE) {
> +		efc_log_err(hw->os, "cannot send IO abort, HW state=%d\n",
> +			     hw->state);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/* take a reference on IO being aborted */
> +	if (kref_get_unless_zero(&io_to_abort->ref) == 0) {
> +		/* command no longer active */
> +		efc_log_test(hw->os,
> +			      "io not active xri=0x%x tag=0x%x\n",
> +			     io_to_abort->indicator, io_to_abort->reqtag);
> +		return EFCT_HW_RTN_IO_NOT_ACTIVE;
> +	}
> +
> +	/* Must have a valid WQ reference */
> +	if (!io_to_abort->wq) {
> +		efc_log_test(hw->os, "io_to_abort xri=0x%x not active on WQ\n",
> +			      io_to_abort->indicator);
> +		/* efct_ref_get(): same function */
> +		kref_put(&io_to_abort->ref, io_to_abort->release);
> +		return EFCT_HW_RTN_IO_NOT_ACTIVE;
> +	}
> +
> +	/*
> +	 * Validation checks complete; now check to see if already being
> +	 * aborted
> +	 */
> +	spin_lock_irqsave(&hw->io_abort_lock, flags);
> +	if (io_to_abort->abort_in_progress) {
> +		spin_unlock_irqrestore(&hw->io_abort_lock, flags);
> +		/* efct_ref_get(): same function */
> +		kref_put(&io_to_abort->ref, io_to_abort->release);
> +		efc_log_debug(hw->os,
> +			       "io already being aborted xri=0x%x tag=0x%x\n",
> +			      io_to_abort->indicator, io_to_abort->reqtag);
> +		return EFCT_HW_RTN_IO_ABORT_IN_PROGRESS;
> +	}
> +
> +	/*
> +	 * This IO is not already being aborted. Set flag so we won't try to
> +	 * abort it again. After all, we only have one abort_done callback.
> +	 */
> +	io_to_abort->abort_in_progress = true;
> +	spin_unlock_irqrestore(&hw->io_abort_lock, flags);
> +
> +	/*
> +	 * If we got here, the possibilities are:
> +	 * - host owned xri
> +	 *	- io_to_abort->wq_index != U32_MAX
> +	 *		- submit ABORT_WQE to same WQ
> +	 * - port owned xri:
> +	 *	- rxri: io_to_abort->wq_index == U32_MAX
> +	 *		- submit ABORT_WQE to any WQ
> +	 *	- non-rxri
> +	 *		- io_to_abort->index != U32_MAX
> +	 *			- submit ABORT_WQE to same WQ
> +	 *		- io_to_abort->index == U32_MAX
> +	 *			- submit ABORT_WQE to any WQ
> +	 */
> +	io_to_abort->abort_done = cb;
> +	io_to_abort->abort_arg  = arg;
> +
> +	atype = SLI_ABORT_XRI;
> +	id = io_to_abort->indicator;
> +
> +	/* Allocate a request tag for the abort portion of this IO */
> +	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
> +	if (!wqcb) {
> +		efc_log_err(hw->os, "can't allocate request tag\n");
> +		return EFCT_HW_RTN_NO_RESOURCES;
> +	}
> +	io_to_abort->abort_reqtag = wqcb->instance_index;
> +
> +	/*
> +	 * If the wqe is on the pending list, then set this wqe to be
> +	 * aborted when the IO's wqe is removed from the list.
> +	 */
> +	if (io_to_abort->wq) {
> +		spin_lock_irqsave(&io_to_abort->wq->queue->lock, flags);
> +		if (io_to_abort->wqe.list_entry.next) {
> +			io_to_abort->wqe.abort_wqe_submit_needed = true;
> +			io_to_abort->wqe.send_abts = send_abts;
> +			io_to_abort->wqe.id = id;
> +			io_to_abort->wqe.abort_reqtag =
> +						 io_to_abort->abort_reqtag;
> +			spin_unlock_irqrestore(&io_to_abort->wq->queue->lock,
> +					       flags);
> +			return EFC_SUCCESS;
> +		}
> +		spin_unlock_irqrestore(&io_to_abort->wq->queue->lock, flags);
> +	}
> +
> +	if (sli_abort_wqe(&hw->sli, io_to_abort->wqe.wqebuf,
> +			  hw->sli.wqe_size, atype, send_abts, id, mask,
> +			  io_to_abort->abort_reqtag, SLI4_CQ_DEFAULT)) {

Wouldn't it be better if we were to pass the 'wqe' directly here?
That would cut down on the number of arguments required, and make the 
function more readable.
Not to mention that we'll be more efficient if we manage to cut down the 
number of arguments to '4' or even less, as then we wouldn't need to 
pass arguments on the stack.


Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
