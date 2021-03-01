Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5120CC433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 06:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041DF64E40
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 06:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhCAGz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 01:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhCAGzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 01:55:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF755C06174A;
        Sun, 28 Feb 2021 22:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gBs6DNze8G5n1XddfCf4tpaY7/fmzfb1f0K+dmwmvuc=; b=dfzfy5stjvI7W7v3XjXRUOXOvK
        7J1UhRdmoct7nkH+fyCAiaaErmhozT+cKh3yHQaTBFeua10+89hUM7qzp490onUo2+Y9oyuBnlUYM
        urGMQCa5w2sotJ+1g82Oq773SI7lOvR+EdMeuj67UU1PYhbqeBpbFu2RgI7GoFioC1U0XUAV2Pap6
        /S7+aNK48TXenacgOF/kXY8swzIvAfK5CUbOyuAsUXZhZAyCdkon+0kpv7SlX5tpOvngNAQhYZ5FH
        aJEOQfQQC3jk5O6Y5nNNlmTbafKjRxCM0LTb01xKHz7/KS7LxgFXK38RckQeqVpP300O8/PDYcUkq
        GsBKIjQA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lGcSE-00FOax-Gd; Mon, 01 Mar 2021 06:54:55 +0000
Date:   Mon, 1 Mar 2021 06:54:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [RFC PATCH 12/12] HV/Storvsc: Add bounce buffer support for
 Storvsc
Message-ID: <20210301065454.GA3669027@infradead.org>
References: <20210228150315.2552437-1-ltykernel@gmail.com>
 <20210228150315.2552437-13-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210228150315.2552437-13-ltykernel@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This should be handled by the DMA mapping layer, just like for native
SEV support.
