Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9303C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2B9206BE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gtGqRi+F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgETRsC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 13:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETRsC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 13:48:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A265C061A0E;
        Wed, 20 May 2020 10:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5hxO0EeSab5NuvqzOm6rAcLJzVQqKi4assCgvJZMejI=; b=gtGqRi+FtKJpVh2bOZPJNMWRkV
        ughKxH21ZDC5rAELyhBz3qRKRoyRLW5KzQCZNDhmgri6D2Pvkd3Tw/WrdIyB5m/z49CBsepA6Apgx
        4h1uYTXzT7yotho5HBY8VMtjPzlYcIxKIPPE5LKcuzJI0WuZQxYIhYdcAbg+UtkoEJagcscVBLpfP
        PySMrO++DzvAnEIkNyqWZ6M6p0btAiuVVmWIJBhYlLTCFvyCtbxtwJMoU5y0OWX9OP4WwGDdrXbxP
        BKd2VdR46fYyn3bGhd6Uu/+knb8bbMKdOZGciKWXbhb6oT3bfU5hQHn+Di9aNWzccXb+AMLnRxsDL
        t97wK3Ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbSoy-0003T7-LL; Wed, 20 May 2020 17:48:00 +0000
Date:   Wed, 20 May 2020 10:48:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        linux-nvme@lists.infradead.org, Paul Ely <paul.ely@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH resend] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
Message-ID: <20200520174800.GA13253@infradead.org>
References: <yq1y2purqt1.fsf@oracle.com>
 <20200515101903.GJ3041@kadam>
 <20200520165557.GA9700@infradead.org>
 <20200520172433.GD30374@kadam>
 <20200520172844.GA21006@infradead.org>
 <yq1y2pmtsv7.fsf@ca-mkp.ca.oracle.com>
 <20200520173752.GA13546@infradead.org>
 <yq1sgfutsjd.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1sgfutsjd.fsf@ca-mkp.ca.oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 20, 2020 at 01:39:55PM -0400, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > I'll pick it up.  Can you give me an ACK for it to show Jens you are
> > ok with that?
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks,

applied to nvme-5.8.
