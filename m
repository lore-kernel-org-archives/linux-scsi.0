Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5526FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 17:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324FD610E8
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 17:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhJ1RM5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 13:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhJ1RM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 13:12:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC91C061570;
        Thu, 28 Oct 2021 10:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QZ+Ok3QSmenqeVI6Z1A7VRMrFdlOCkIcageNVExYylc=; b=b2hbSrdSC0kGmPAhfihD5iFS0Q
        xz/h1wVwG3l0wjyGPDn4YAAtuKOtQ9x+bQ3wVFvZiDGH3o8HlSOHP+gz3WCTmIn/69AA8Vyqpy+fN
        Iu+62AgQfjLPPG0K2D3BOaJynv5YvbD37iTiOlaWWJO2TXVNJE6IUmbpj/Zepisz82jJEuIUBOz8h
        mXZpPq45AYhp1cwsiMTGEmeloKiBcbj2IIx4BmqeqG+iYWzdEbeoSntsjTvD+XS8mnl9aApe+QncE
        SClPthXIkFRJr1xViXlPWTER1itjHWNMZGNpFCb0oRlXCkVAVvlVivwk8eQ2yLbJT4Snd3d+ylmTH
        u72ZVHtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mg8v2-008gjq-Fp; Thu, 28 Oct 2021 17:10:24 +0000
Date:   Thu, 28 Oct 2021 10:10:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        James Bottomley <jejb@linux.ibm.com>, daejun7.park@samsung.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Message-ID: <YXrZgC7mYVQS+CE6@infradead.org>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
 <YXrBTHmu/fiAaZH5@infradead.org>
 <54b45df9-9339-c69d-73b5-9c293449b849@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b45df9-9339-c69d-73b5-9c293449b849@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 28, 2021 at 10:07:52AM -0700, Bart Van Assche wrote:
> I spent some time looking around for other examples of allocating and
> inserting a request from inside block layer callbacks. I only found one
> such example, namely in the NVMe core. nvme_timeout() calls
> nvme_alloc_request() and blk_execute_rq_nowait(). The difference between
> what the UFS HPB code is doing and what nvme_timeout() does doesn't seem
> that big to me.

The difference is that nvme_timeout allocates a request on the
admin queue, and only does so for commands on the I/O queues.
