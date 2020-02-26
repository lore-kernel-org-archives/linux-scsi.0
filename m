Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796B1C4BA1E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54AD620801
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgBZRpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:45:05 -0500
Received: from verein.lst.de ([213.95.11.211]:50054 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgBZRpE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 12:45:04 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BFD5B68CEE; Wed, 26 Feb 2020 18:45:02 +0100 (CET)
Date:   Wed, 26 Feb 2020 18:45:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 10/13] scsi: add scsi_host_busy_iter()
Message-ID: <20200226174501.GG23141@lst.de>
References: <20200213140422.128382-1-hare@suse.de> <20200213140422.128382-11-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213140422.128382-11-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +/**
> + * scsi_host_busy_iter - Iterate over all busy commands
> + * @shost:	Pointer to Scsi_Host.
> + * @fn:		Function to call on each busy command
> + * @priv:	Data pointer passed to @fn
> + **/

Can you add the context information from the commit log to the kerneldoc
comment her?

> +typedef bool (scsi_host_busy_iter_fn)(struct scsi_cmnd *, void *, bool);

Is there much of a point in having this typedef?

> +
> +void scsi_host_busy_iter(struct Scsi_Host *,
> +			 scsi_host_busy_iter_fn *fn, void *priv);

Any reason to spell out to argument names, but not the third one?
