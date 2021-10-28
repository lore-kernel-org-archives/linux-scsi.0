Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640DAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 15:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8D0601FF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 15:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhJ1P3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 11:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhJ1P3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 11:29:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3772C061570;
        Thu, 28 Oct 2021 08:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C25FBrHsCS4SYuLkvj36k8rSA/hCmYxj6KRyZJNajPM=; b=o7THTnaL+L3FfKjMLmtHwiKh3K
        SfxqvG7VqrnusU2O/m3zIwbHf67bF2KwWWZYPgW4oJLG51CaaqwCL2OUU4/gRIqrHbMmW64c/atOI
        Y64srbXUmLbBuFGLel56CeFY4R7JqQIOz1Puo1ui8CeqHJty8oyrPNXyB3DoZCvISQIai0cmP8LPO
        cQnFhTDfQE8ox+7MSKHTDeqTc9c8RwCU9JQ1ZSkEhn731GlnrTHAuE2ht210qKNC8bFp8lVEiVaEQ
        rCW5JIJ5GBbeD+mOlJO3CN+CDrRMoew7IVyOS6L/zpBm58OfZeSfBncDr/GfMTZGpkYjt40xQ3jxA
        DV58QM1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mg7J6-008PEq-Do; Thu, 28 Oct 2021 15:27:08 +0000
Date:   Thu, 28 Oct 2021 08:27:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Message-ID: <YXrBTHmu/fiAaZH5@infradead.org>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 28, 2021 at 10:28:01AM -0400, James Bottomley wrote:
> If the block people are happy with this, then I'm OK with it, but it
> doesn't look like you've solved the fanout deadlock problem because
> this new mechanism is still going to allocate a new tag.

Yes, same problem as before.
