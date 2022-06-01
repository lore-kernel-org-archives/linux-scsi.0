Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEFCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 15:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355379AbiFAP0M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 11:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354236AbiFAP0L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 11:26:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF258BD1F
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 08:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E77/WXWOyqWzZHMuvqn6u4ViSJAIoDEYBKBzEd54GKE=; b=kUJiKMeoHpdvUSd9mZ1Id2uKRY
        oxYkVN6g/b2sCh7/B93/uR4ikZrex9It03Si1rRQq6ikZwUbx7JtLYIqMvwaNozfHZLWsQJPtZ6WH
        TLCeSPyHO0fKWoCfhPVca7uEbEWpX8ldGHuquGTp2kOO94nPj5v8WxQSH0qAFTKfS24I5hGo2AgNQ
        2rPp5IeVJhAmSVPs1mK9Ggltj1vOwo/1mClCXZZINtzLmbRR+NrV74Ab7H+syCFz6sbKWgZeMM3S4
        +54KAVcT3FFOuZNzUfn1eBHYWP0uN0LAke5JSPKgXHJJq21vNWba7yX2xuwq4sIQK+nGPg8Enbbip
        n7rtRExg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwQEa-00Gsjr-FX; Wed, 01 Jun 2022 15:26:08 +0000
Date:   Wed, 1 Jun 2022 08:26:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: sd: Fix potential NULL pointer dereference
Message-ID: <YpeFEMWC48tPISK1@infradead.org>
References: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
 <20220601062544.905141-2-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601062544.905141-2-damien.lemoal@opensource.wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 01, 2022 at 03:25:43PM +0900, Damien Le Moal wrote:
> If sd_probe() sees an early error before sdkp->device is initialized,
> sd_zbc_release_disk() is called. This causes a NULL pointer dereference
> when sd_is_zoned() is called inside that function. Avoid this by
> removing the call to sd_zbc_release_disk() in sd_probe() error path.
> 
> This chnage is safe and does not result in zone information memory
> leakage because the zone information for a zoned disk is allocated only
> when sd_revalidate_disk() is called, at which point sdkp->disk_dev is
> fully set, resulting in sd_disk_release() being called when needed to
> cleanup a disk zone information using sd_zbc_release_disk().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
