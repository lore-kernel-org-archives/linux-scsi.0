Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC89C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E12120872
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FzetrCAq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgETR2v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 13:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETR2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 13:28:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2996CC061A0E;
        Wed, 20 May 2020 10:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QPRZ5oOi93BtgVgAMDgDFMlUrDlihYH3dyP+pgIHDYA=; b=FzetrCAq3U7yjGKfVo00pT6NNB
        TTnz9HyikuuC1yNirM2VOoa+ZcTUiNkx2G+8vnu5k+XwN9iippsEuIrytJy8thkVJaM+VvOBa2s5Z
        bRpQpm2Eag1GHQhC4GY2VSGSi1fS2Z3oH1d1Zxb1f1Iz+g4g9NFYR6IftKMJQcmudBz6O5n13HuTs
        cdU7OZzZ7U+xdlUDDRzlOVsQbpQsDQHPHHRqwigRIMcGv1fVfM5nxUn2dIg5EcNDErjo4zPoel5Hs
        eb4B/hr3s0g7QnQS+b7YfSohaEWiSL7oJ9MRYMkQ7mkAkkcAB+kf743WdI3oSrMvTeJvQhVMsps0j
        DD/Yst+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbSWK-0005a3-HY; Wed, 20 May 2020 17:28:44 +0000
Date:   Wed, 20 May 2020 10:28:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        James Smart <james.smart@broadcom.com>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, Paul Ely <paul.ely@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH resend] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
Message-ID: <20200520172844.GA21006@infradead.org>
References: <yq1y2purqt1.fsf@oracle.com>
 <20200515101903.GJ3041@kadam>
 <20200520165557.GA9700@infradead.org>
 <20200520172433.GD30374@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520172433.GD30374@kadam>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 20, 2020 at 08:24:33PM +0300, Dan Carpenter wrote:
> On Wed, May 20, 2020 at 09:55:57AM -0700, Christoph Hellwig wrote:
> > James, can you review this patch?
> 
> He already reviewed it in a different thread.  I copied his R-b tag.

James, should this go into the nvme or scsi tree?
