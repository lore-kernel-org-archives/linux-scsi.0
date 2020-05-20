Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE64C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B236F204EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gke7e8hc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgETR5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 13:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETR5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 13:57:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC9BC061A0E;
        Wed, 20 May 2020 10:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uxw1/QK0of/MtC82wsvkOOs58ApKwQUqwL8DSgT1rYw=; b=gke7e8hcVPAL8UmC3CkcVaB+2R
        aJh0jlDpWsqyn0SxCH9z3vlRpnAwxZwvasdsg8IBVAt4CYxy6ybTVvZnJD/fcD38mCWx1sczTIUP5
        mrdkLGmFvJMAXClRcIUyQiDe+7jmn6UW/zhE/4Bn+be9mLSu2uDJNXLJj/3gkev1/HpNld/KYNygx
        dChVewpOXbEsFnC1OU381U2c3b1GwXXbpPVxlLgnytfkjpFH3BqcaQTkXKyu3SJIZumc2YaT2/J5h
        iSLkdklvEwBZ73TO3IwYZgWIqSNXYW2hNCC2kUnbfj5pFKED5NKN+b4EsXIIITpAM0QsIxw6Qw8U1
        47krPdLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbSyC-0004Nx-Vk; Wed, 20 May 2020 17:57:32 +0000
Date:   Wed, 20 May 2020 10:57:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     James Smart <james.smart@broadcom.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, linux-nvme@lists.infradead.org,
        Paul Ely <paul.ely@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH resend] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
Message-ID: <20200520175732.GA15911@infradead.org>
References: <yq1y2purqt1.fsf@oracle.com>
 <20200515101903.GJ3041@kadam>
 <20200520165557.GA9700@infradead.org>
 <20200520172433.GD30374@kadam>
 <20200520172844.GA21006@infradead.org>
 <yq1y2pmtsv7.fsf@ca-mkp.ca.oracle.com>
 <20200520173752.GA13546@infradead.org>
 <yq1sgfutsjd.fsf@ca-mkp.ca.oracle.com>
 <20200520174800.GA13253@infradead.org>
 <4693662b-60de-388e-d67f-722eabbba475@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4693662b-60de-388e-d67f-722eabbba475@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 20, 2020 at 10:51:48AM -0700, James Smart wrote:
> On 5/20/2020 10:48 AM, Christoph Hellwig wrote:
> > On Wed, May 20, 2020 at 01:39:55PM -0400, Martin K. Petersen wrote:
> > > Christoph,
> > > 
> > > > I'll pick it up.  Can you give me an ACK for it to show Jens you are
> > > > ok with that?
> > > Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Thanks,
> > 
> > applied to nvme-5.8.
> 
> Guess you didn't see Dan's response - we had replied, and Dick rejected it.
> Dick has created a new patch that I'll be posting shortly.

Oh well, I'll pull it again then.
