Return-Path: <SRS0=e6eI=52=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBE7C2BB85
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Apr 2020 06:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 060A020801
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Apr 2020 06:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XG4EL/7C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgDJGSX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Apr 2020 02:18:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgDJGSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2020 02:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Vd1LnDW74LEIAOjIFqooGW6tp/Rca5J0XyRGTCKSUCA=; b=XG4EL/7CIpfxUP3Bs95F3EluO4
        V+BmjeIhamdR1wz8cogPiMiOgWlpQaWNAy8puH6HGGSF0WWD0ynZsdmjm3wfUvdzA+RKk1q/dTwiO
        SjqkgdaLUsgntn8SZVSqm8JfJ5G/HMSixrCP3Y4ppDGl8eZ0E58rGCdEnujAPNLfq2EoC/KVZDRsK
        v7Kz3X0wCS0b/2VTMqJSK1b7OIipw5uItXcOM6tVV0Xk09oHJIp+4QH+q1daE19/rwbFEItr2OWBj
        iIFJCG1ZzLnF6Ty4pYF5dIZMVDAwjfhotlwFZwUTuuNR4A6t6gdWLnRTeJSsCbUE0Gyz28SXIw8AR
        78T5Z3tQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMmze-0006IO-W7; Fri, 10 Apr 2020 06:18:22 +0000
Date:   Thu, 9 Apr 2020 23:18:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v5 07/10] scsi: sd_zbc: emulate ZONE_APPEND commands
Message-ID: <20200410061822.GB4791@infradead.org>
References: <20200409165352.2126-1-johannes.thumshirn@wdc.com>
 <20200409165352.2126-8-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409165352.2126-8-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 10, 2020 at 01:53:49AM +0900, Johannes Thumshirn wrote:
> +	if (req_op(rq) == REQ_OP_ZONE_APPEND) {
> +		ret = sd_zbc_prepare_zone_append(cmd, &lba, nr_blocks);
> +		if (ret) {
> +			scsi_free_sgtables(cmd);
> +			return ret;
> +		}
> +	}

So actually.

I've been trying to understand the lifetime of the sgtables.  Shouldn't
we free them in the midayer ->init_command returned BLK_STS_*RESOURCE
instead?  It seems like this just catches one particular error instead
of the whole category?  The end of scsi_queue_rq seem like a particular
good place, as that also releases the resources for the "hard" errors.
