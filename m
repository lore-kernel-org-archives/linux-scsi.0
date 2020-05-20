Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3499EC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 16:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EBF20709
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 16:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BQDaGBsp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgETQ4C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgETQ4B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 12:56:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E9EC061A0E;
        Wed, 20 May 2020 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IghXcCDK0cEq/Kj0CX/Mm43AHbJSZlDSkk+jenubsNQ=; b=BQDaGBspyP167GjL2cQ6d5nYLD
        AZ6i8M4iloyuqf7rJPi3xaEjhZ8sg98tXuZelUK5kQV/n2kscQCoNEQXqDPRNb0KZ+HTrwNsQoJUW
        GNnZkkshlOPFtAMxINd9zLARk/fVY+pNjkTkVcG/cw60pz108g+QhXQaCvpaqPTzz23i+XsGlHdeg
        y9pVlPVqmacuJxuZYm7IakGkDpcTYWjVieB40HumuUQzP6s+s6JwFxmHbyjTVlJ78X1+T8Nwc+l0u
        S0Ns0NEyWHg92ygZEHUG8PyovrEWcotmbkN8+muw/qDUBZkJgCbOlBPeEGX+OP8Mlck8cxMJi/h0E
        otDXNaHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbS0b-0005MA-9e; Wed, 20 May 2020 16:55:57 +0000
Date:   Wed, 20 May 2020 09:55:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     James Smart <james.smart@broadcom.com>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, Paul Ely <paul.ely@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH resend] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
Message-ID: <20200520165557.GA9700@infradead.org>
References: <yq1y2purqt1.fsf@oracle.com>
 <20200515101903.GJ3041@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515101903.GJ3041@kadam>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

James, can you review this patch?
