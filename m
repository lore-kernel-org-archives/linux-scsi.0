Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D613FC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 07:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiK3HNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 02:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiK3HNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 02:13:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB335E3F9
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2022 23:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A3KkRnYlHkdnclkz0JOhg2P938lHW5xIpB+mEEBN/68=; b=gTtTgAlrU08Y6654PwS0qyL05Q
        o7nllfpTopNvKMnNtIK50Tf7LcR4x4SVs71JjpUxX+Eeutxf1L5uaw2jRBG/5JQhVmcOHPXBpS53t
        RIN2dAVquYOvySqsb4xc9t7PiXBYzQBhjVEIV8jp4tlEIZS9E7nuG1E9P2W3k3vEGrfWigbmrgHn8
        nEupx5UEzI+KFuK9sDCvibv/4mdRxxM7VOCsT0YLQse9vOB5wZKwQdNHVpzQO1FDrGMdKarow6Ehl
        aTKnIjzvDBK1PuF8A2W7ddW2arJhS4TxW+QVkFpYUb6MkozQEOaRrie+MWuMgD+iV0fSSba/lbuU/
        Cvm0B4SQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0HHA-00E2Is-6q; Wed, 30 Nov 2022 07:13:00 +0000
Date:   Tue, 29 Nov 2022 23:13:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3] scsi: sd_zbc: trace zone append emulation
Message-ID: <Y4cCfN5eW/1Qqvse@infradead.org>
References: <53f2e206d85b99e8e2f2519beefc3e67262af67a.1669791411.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f2e206d85b99e8e2f2519beefc3e67262af67a.1669791411.git.johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 29, 2022 at 10:58:09PM -0800, Johannes Thumshirn wrote:
> +++ b/drivers/scsi/sd_zbc.c
> @@ -18,6 +18,11 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  
> +#if IS_MODULE(CONFIG_BLK_DEV_SD)
> +#define CREATE_TRACE_POINTS
> +#endif
> +#include <trace/events/scsi.h>

Urg, this will create duplicates of all the tracepoints if sd is
built modular.  Can't we just have a separate b/drivers/scsi/sd_trace.h
for sd-specific tracepoints?  If not, we'll just need
to EXPORT_TRACEPOINT_SYMBOL_GPL the tracepoints used in sd.
