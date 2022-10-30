Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4170FC38A02
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Oct 2022 11:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ3L57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Oct 2022 07:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3L57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Oct 2022 07:57:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B56AC764
        for <linux-scsi@vger.kernel.org>; Sun, 30 Oct 2022 04:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WQEopg038l2f1D1wNKLv8U5Si4Bbp1Fg1sFDYkcITEU=; b=Ex93bDVUYoluC/9psua0wzVOtk
        dbYkEC2ngFzbqJaqOHjbazEaZ8rtIrigUSXlc41nl5+dZ5wlUpzjjyD7hVt8ApP7sCAdlVEWmJvMa
        DOG+Cep0KUZfLhUNHIguuVirkM6POju60hDPg2RGjFNWWbXP/QwYlrb0dwKN0ev9IODde9dcqD23J
        bMYUE6OD2tFog5kl1hvynlkdipOd0aOauxj1fJMEmWKUlC2E7XaNNWD+V79ePN+oDVQ2tNjbBN3bc
        E25Uu4E78bwU2uijJNfgEyZQm8enLo8QtNZIXRxXgihhKe/VKPHlTlIWeelhK53vx9ElJHMmzXkRd
        VdJpah2w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1op6wv-00FnY5-Uh; Sun, 30 Oct 2022 11:57:57 +0000
Date:   Sun, 30 Oct 2022 04:57:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
Message-ID: <Y15mxaWDn3G9Y/rb@infradead.org>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
 <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
 <Y15lk+CPsjJ801iY@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y15lk+CPsjJ801iY@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Oct 30, 2022 at 04:52:51AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 28, 2022 at 02:46:55PM +0530, Sreekanth Reddy wrote:
> > Remove the usage of dma_get_required_mask() API.
> > Directly set the DMA mask to 63/64 if the system
> > is a 64bit machine.
> > 
> > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, it seems like mpi3mr will need similar treatment.
