Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136BEC432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 14:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E567A2075E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 14:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKROXB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 09:23:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:34250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbfKROXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 09:23:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C3533B249;
        Mon, 18 Nov 2019 14:22:59 +0000 (UTC)
Date:   Mon, 18 Nov 2019 15:22:59 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] lpfc: fixup out-of-bounds access during CPU hotplug
Message-ID: <20191118142259.nszyqku5pewuu6st@beryllium.lan>
References: <20191118123012.99664-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118123012.99664-1-hare@suse.de>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

On Mon, Nov 18, 2019 at 01:30:12PM +0100, Hannes Reinecke wrote:
> The lpfc driver allocates a cpu_map based on the number of possible
> cpus during startup. If a CPU hotplug occurs the number of CPUs
> might change, causing an out-of-bounds access when trying to lookup
> the hardware index for a given CPU.
> 
> Suggested-by: Daniel Wagner <daniel.wagner@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index ba26df90a36a..2380452a8efd 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -642,7 +642,8 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
>  	int tag;
>  	struct fcp_cmd_rsp_buf *tmp = NULL;
>  
> -	cpu = raw_smp_processor_id();
> +	cpu = min_t(u32, raw_smp_processor_id(),
> +		    phba->sli4_hba.num_possible_cpu);

The index is limited by phba->cfg_hdw_queue and not the number of CPUs.

Thanks,
Daniel
