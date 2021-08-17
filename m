Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F3BC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C36360F58
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbhHQMVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:21:40 -0400
Received: from verein.lst.de ([213.95.11.211]:58302 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235897AbhHQMVj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 08:21:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5E37567357; Tue, 17 Aug 2021 14:21:04 +0200 (CEST)
Date:   Tue, 17 Aug 2021 14:21:03 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 05/51] snic: reserve tag for TMF
Message-ID: <20210817122103.GD30436@lst.de>
References: <20210817091456.73342-1-hare@suse.de> <20210817091456.73342-6-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817091456.73342-6-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
> index 14f4ce665e58..65f50057c66e 100644
> --- a/drivers/scsi/snic/snic_main.c
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
>  
>  	snic->max_tag_id = shost->can_queue;
> +	/* Reserve one reset command */
> +	shost->can_queue--;
> +	snic->tmf_tag_id = shost->can_queue;

So this decrements can_queue before calling scsi_add_host..

> +	sc = scsi_host_find_tag(shost, snic->tmf_tag_id);
> +	if (!sc) {

... but this expects to find a scsi_cmnd there.  How is that going
to work?
