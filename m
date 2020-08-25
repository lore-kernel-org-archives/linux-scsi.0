Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC98C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 13:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51EDF20639
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 13:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHYN0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 09:26:20 -0400
Received: from verein.lst.de ([213.95.11.211]:58839 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgHYN0S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 09:26:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6E33E68BEB; Tue, 25 Aug 2020 15:26:12 +0200 (CEST)
Date:   Tue, 25 Aug 2020 15:26:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org
Subject: Re: a saner API for allocating DMA addressable pages
Message-ID: <20200825132612.GA22318@lst.de>
References: <CGME20200819065610eucas1p2fde88e81917071b1888e7cc01ba0f298@eucas1p2.samsung.com> <20200819065555.1802761-1-hch@lst.de> <8fa1ce36-c783-1a02-6890-211eb504a33b@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fa1ce36-c783-1a02-6890-211eb504a33b@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 25, 2020 at 01:30:41PM +0200, Marek Szyprowski wrote:
> I really wonder what is the difference between this new API and 
> alloc_pages(GFP_DMA, n). Is this API really needed? I thought that this 
> is legacy thing to be removed one day...

The difference is that the pages returned are guranteed to be addressable
by the devie.  This is a very important difference that matters for
a lot of use cases.
