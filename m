Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C423C3DA78
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbjAQHZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbjAQHZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:25:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92AC22DCB;
        Mon, 16 Jan 2023 23:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5FIyY14pRnhJEpdZCuHOeoBy7HQiVxLwLTFyFTYNdGs=; b=TUBimPwb53CI8cXX4s7UddrwjZ
        A8LIBt29/NR80GijPfP1hcAvXdJrPEO2evxAfg1R9m+X04dEgLABe+TRVXbolbB7V93jSyP5ryliW
        zVQCgd7dDpSzh9KqokL43GMwI6rSavtdyJGevT/UADjuxwxLgaRovSs5Z3HKpiWYmk22NDxCvHbPQ
        hiyCSZcFmNDEASx5VSBoxM1gtD8Ncpd9JmswoHsoOH7kSJ+wY+H4+QN0CwDNe3ty+9wV7JphpaYi2
        KNPyTeojw7TasuHAp6BnuWE665B/Wit1z0PwGnHwBCNoPfzz/jvPjQIzzY+KBKsS/LPCYdZnM2aSg
        dW3JyL6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHgLu-00D9g0-V2; Tue, 17 Jan 2023 07:25:50 +0000
Date:   Mon, 16 Jan 2023 23:25:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2 07/18] block: introduce duration-limits priority class
Message-ID: <Y8ZNftvsEIuPqMFP@infradead.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-8-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112140412.667308-8-niklas.cassel@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2023 at 03:03:56PM +0100, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Introduce the IOPRIO_CLASS_DL priority class to indicate that IOs should
> be executed using duration-limits targets. The duration target to apply
> to a command is indicated using the priority level. Up to 8 levels are
> supported, with level 0 indiating "no limit".
> 
> This priority class has effect only if the target device supports the
> command duration limits feature and this feature is enabled by the user.
> In BFQ and mq-deadline, all requests with this new priority class are
> handled using the highest priority class RT and priority level 0.

Hmm, does it make sense to force a high priority?  Can't applications
use CDL to also fore a lower priority?
