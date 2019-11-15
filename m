Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1550BC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 08:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E807E20733
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 08:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKOIvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 03:51:31 -0500
Received: from verein.lst.de ([213.95.11.211]:43533 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbfKOIvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 03:51:31 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8150468AFE; Fri, 15 Nov 2019 09:51:28 +0100 (CET)
Date:   Fri, 15 Nov 2019 09:51:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/4] dpt_i2o: make adpt_i2o_to_scsi() a void function
Message-ID: <20191115085128.GB24954@lst.de>
References: <20191115080555.146710-1-hare@suse.de> <20191115080555.146710-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115080555.146710-3-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 15, 2019 at 09:05:53AM +0100, Hannes Reinecke wrote:
> The return value is never used anywhere, and returning it
> risks a use-after-free crash.

The function is also badly misnamed.  Can you renamed it to
adpt_i2o_complete_cmd or something that actually describes
the function if you touch it?

> -static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
> +static void adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
>  {
>  	adpt_hba* pHba;
>  	u32 hba_status;

And fix the * placement at least in the actual line you touch anyway?
