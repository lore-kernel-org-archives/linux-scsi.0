Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7223C2D0E8
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 09:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 935D32078B
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 09:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qTbZo+d/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgCZJat (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 05:30:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbgCZJat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 05:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8tkb1WKEFrN4NlRAe9psjXHXdTX1+caSXEXvCYJZuU8=; b=qTbZo+d/BiYSGraIOZBdnZwHOT
        R7Tqb2N8iJWTVCo2OxAHOgKgKurnIsmbrmNZBX5pLIeuYfXEgRbs5lYNDBVqLOgA90vfjlAtpudEl
        MbUSlZ0ZRTbUdU+RMznpNzpGDDxbuIBX1mQ/OSfh8Jn2HYDrXd81HErvi2m/WFImfwJsn8bQDKm/I
        in06Rq09XujahHKR2AwFKFvswFsbi5wGBj/2xFzCKpo7WsyYBrcg0pv0HtvzOvgTiMMY+CrWYIeOu
        ej6mS5i/lx6nNNaRS/Fw6Trf5tv5faIEuiv00vbIAoD8KUKV8Nsn5+9c0QMA27GH081a19yBYSpoV
        gu2WIx2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHOqf-000377-AA; Thu, 26 Mar 2020 09:30:49 +0000
Date:   Thu, 26 Mar 2020 02:30:49 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: all zones zone management operations
Message-ID: <20200326093049.GB6478@infradead.org>
References: <20200326043012.600187-1-damien.lemoal@wdc.com>
 <20200326072800.GA21082@infradead.org>
 <CO2PR04MB23433C37660B9A8B53D95790E7CF0@CO2PR04MB2343.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR04MB23433C37660B9A8B53D95790E7CF0@CO2PR04MB2343.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 26, 2020 at 08:23:34AM +0000, Damien Le Moal wrote:
> Open & Close all zones are indeed not super useful, at least on SMR drives. But
> finishing all zones does have some benefit, namely the ability to quickly change
> all incompletely written zones into "read-only" full zones. For drives with low
> zone resources (open or active zones), this can be useful to recover zone
> resources. Again, not so much on SMR drives, but this could come in handy for
> ZNS drives with low zone resources (max open zones etc).

What quantifies the "some benefit"?  If you have an application that
micro-manages the zone state it better knows what zones are open.  But
even if we want to add a finish all I'd rather wait for ZNS support
to land and real use cases, as it sounds all rather dubious.
