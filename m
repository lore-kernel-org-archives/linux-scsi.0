Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D29C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 13:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3AD60F9B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 13:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbhJZNGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 09:06:43 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51254 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236129AbhJZNGn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 09:06:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635253459;
        bh=VNpiwuvlu3wcbtCV3obWrd1KExtIuUa1np0HXZKsSbo=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=LCCCLK7Y2sQIDHsKyUGC/35Ajst1wXD/4mLKAJNo9jb6Qg2CS9AwaB3m3GaCEW8NK
         q05VbeQ/vA4zH1LHkj8bnrUViZMqj/bmg6g/oJyZlpyV67bwa+hQcqP1tlIE/XpbqC
         UR/mtBtK8fPtmO4kUGhkPbZ1ldDGkZy9XTzk8Tnc=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 3F1DF128049B;
        Tue, 26 Oct 2021 09:04:19 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BvZh_1pq-bvr; Tue, 26 Oct 2021 09:04:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635253459;
        bh=VNpiwuvlu3wcbtCV3obWrd1KExtIuUa1np0HXZKsSbo=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=LCCCLK7Y2sQIDHsKyUGC/35Ajst1wXD/4mLKAJNo9jb6Qg2CS9AwaB3m3GaCEW8NK
         q05VbeQ/vA4zH1LHkj8bnrUViZMqj/bmg6g/oJyZlpyV67bwa+hQcqP1tlIE/XpbqC
         UR/mtBtK8fPtmO4kUGhkPbZ1ldDGkZy9XTzk8Tnc=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 64A60128045F;
        Tue, 26 Oct 2021 09:04:18 -0400 (EDT)
Message-ID: <0ea55be8c300f098b17e21d185a49e24b81b9c2b.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Date:   Tue, 26 Oct 2021 09:04:16 -0400
In-Reply-To: <3088804d-16f0-8f19-590e-8651bb5ef949@opensource.wdc.com>
References: <20211026071204.1709318-1-hch@lst.de>
         <3088804d-16f0-8f19-590e-8651bb5ef949@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-26 at 16:24 +0900, Damien Le Moal wrote:
> On 2021/10/26 16:12, Christoph Hellwig wrote:
> > The HPB support added this merge window is fundanetally

And s/n/m/ while you're at it: fundamentally

Otherwise:

Reviewed-by: James E.J. Bottomley <jejb@linux.ibm.com>

James

> >  flawed as it uses blk_insert_cloned_request to insert a cloned
> > request onto the same queue as the one that the original request
> > came from, leading to all kinds of issues in blk-mq accounting (in
> > addition to this API being a special case for dm-mpath that should
> > not see other users).
> > 
> > Mark is as BROKEN as the non-intrusive alternative to a last minute
> 
> s/Mark is/Mark it
> 
> > large scale revert.
> > 
> > Fixes: f02bc9754a68 ("scsi: ufs: ufshpb: Introduce Host Performance
> > Buffer
> > feature")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/scsi/ufs/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> > index 432df76e6318a..7835d9082aae4 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > @@ -186,7 +186,7 @@ config SCSI_UFS_CRYPTO
> >  
> >  config SCSI_UFS_HPB
> >  	bool "Support UFS Host Performance Booster"
> > -	depends on SCSI_UFSHCD
> > +	depends on SCSI_UFSHCD && BROKEN
> >  	help
> >  	  The UFS HPB feature improves random read performance. It
> > caches
> >  	  L2P (logical to physical) map of UFS to host DRAM. The driver
> > uses HPB
> > 
> 
> Otherwise, looks good to me.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 


