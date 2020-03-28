Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C887EC43331
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EC7E2071B
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EtJDoNND"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgC1IbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 04:31:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgC1IbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Mar 2020 04:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NPsAavR4Spwf1M/IvsDV4LOYaoMtEawAGmGEXeKYd8o=; b=EtJDoNNDsDbvIK/4zaBgQtpaN9
        Pjb6Uqb2bExYKQkHwkAQmtnc5uwasa0bNxtaEh5qzy7yWrbFvvmM2yZBqH6mIXR3IHCAwe8NC/949
        ja9vQDMcZXLUbyitPiHdQ+mJUETtw3qRSaE7GKXAUkPxfRkHZr20l1Y09WeK3RyLx8IqVU4+WXXJk
        IDkMivbYcwmZiSTH/B0bOmwZ1vj89YjHJSGAFjah3jCVKzWmRh91V1SQRbO2LiMwU0DQh+Nvx63oJ
        TvcVaHYDIyCfkV8l4opLzUIUqSnbshiVoEDhsVGheAKJxh8rtjwDpoklY5CvpWK3CW3ICtSw5HABP
        rQb9oZBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jI6rt-0005mb-BD; Sat, 28 Mar 2020 08:31:01 +0000
Date:   Sat, 28 Mar 2020 01:31:01 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: all zones zone management operations
Message-ID: <20200328083101.GA17417@infradead.org>
References: <20200326043012.600187-1-damien.lemoal@wdc.com>
 <20200326072800.GA21082@infradead.org>
 <CO2PR04MB23433C37660B9A8B53D95790E7CF0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200326093049.GB6478@infradead.org>
 <CO2PR04MB234368B6701C041B292DC872E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200328082211.GA32518@infradead.org>
 <CO2PR04MB234357A7ED343AD22375CD00E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR04MB234357A7ED343AD22375CD00E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 28, 2020 at 08:27:09AM +0000, Damien Le Moal wrote:
> On 2020/03/28 17:22, hch@infradead.org wrote:
> > On Sat, Mar 28, 2020 at 08:13:26AM +0000, Damien Le Moal wrote:
> >> In any case, I think that the patch has value as a nice cleanup of the reset vs
> >> reset all request operations (the latter going away). The side effect of it
> >> being that open/close/finish all come for free with it. I would like to get it
> >> in just for this nice cleanup.
> > 
> > Well, this keeps about the same amount of core code (and I'm not sure
> > it really is cleaner) while adding significantly more code in sd and
> > null_blk.  Not my classic definition of a cleanup.
> 
> sd is simplified (one less argument for setup of zone mgmt commands). But yes,
> agreed that null_blk does need more code.
> 
> OK. Let's drop this for now then.

FYI, if you think the flag is cleaner than a new op you could resubmit
this but keep the flag reset specific for now.  That won't require new
code in null_blk for a use cases no callers uses anyway.
