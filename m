Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CA0C54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 23:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjAYXLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 18:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAYXLs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 18:11:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DD8442E0;
        Wed, 25 Jan 2023 15:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B624B81B9D;
        Wed, 25 Jan 2023 23:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482F9C433EF;
        Wed, 25 Jan 2023 23:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674688305;
        bh=n9U8s+CZtjVsC/e+XiLtlYTtsY504p690F9g/fJQvRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vPmG7xG+JEc4MH26SHLt+Oyy0KSfp/rw40kMXVekRYUBjbVSoav7rk2TjagdL4tEr
         fTYSVEJTm2dtNtQMRctM1Y45zeg8ozoRvB3NWMKIH4q1WKfJie3W6HTuj2WarqfQ4t
         jmR/k7QWm1nHYD4KG/S2VKZBm2SwXsHebF99RbOfSSsbwojG8/cfXQfP37CwAXheip
         JKN81Y/tHHYqPvvhA+tOuQhWYHswdgSK6euxslxJsEPPjqW1z6WN6O+UHeksv/mhHw
         MoCSvgWdubJW5KITOva6/d4o67E1DLOnGil6OvJmMybc1koTkJKzk7+eyB5EVfmyMK
         oUHgUm9Bt+vvg==
Date:   Wed, 25 Jan 2023 16:11:41 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Message-ID: <Y9G3LUem6X/fUz22@kbusch-mbp.dhcp.thefacebook.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2023 at 10:19:45AM +0900, Damien Le Moal wrote:
> On 1/25/23 09:05, Bart Van Assche wrote:
> 
> > which it is not sure that it will be integrated in other storage 
> > standards (NVMe, ...). Isn't the purpose of the block layer to provide 
> > an interface that is independent of the specifics of a single storage 
> > standard? This is why I'm in favor of letting the ATA core translate one 
> > of the existing I/O priority classes into a CDL instead of introducing a 
> > new I/O priority class (IOPRIO_CLASS_DL) in the block layer.
> 
> We discussed CDL with Hannes in the context of NVMe over fabrics. Their
> may be interesting extensions to consider for NVMe in that context (the
> value for local PCI attached NVMe drive is more limited at best).

I wouldn't necessarily rule out CDL for PCI attached in some future TP. NVMe
does allow rotating media, and they'll want feature parity if CDL is considered
useful in other protocols.
