Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5E4C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 11:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B4CB61077
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 11:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhD3LhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 07:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhD3LhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 07:37:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0D5C06174A;
        Fri, 30 Apr 2021 04:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=reerZnOjvxm3GMx9XqqMTODNxQ861rsAvPAy5VxLa8c=; b=s5nC72gSvDbgfWEyNNPaN4COAB
        BgPktEAeUuOSG1lI4zCtbAH49IMFPNigDUheDdkykoZrLJr6SsXuUuCL0/mXpX4vSNIYySvTnmyeS
        M8jDcLndM/m49sN/6wezefjRz5HqqLkonHrFC1G6wKgnF7w2dc1I68y3KZawU5lpAialz1yAnRHM2
        gGCy3UBHOWhgUb4G9RygBhFvLWTZAN+DLTzpgFmosjhYkqZCvtXUYuIS9z1TpvfN++H5n06a7qovi
        VrIvi4Xc2lriDlXxChNF7edtJcVths2jf2Of3nojBTKIe1kqXK6/Xps3FXzuzjPb19WPPkNekioV7
        G2RE7IfA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lcRQq-00Awzm-QS; Fri, 30 Apr 2021 11:35:48 +0000
Date:   Fri, 30 Apr 2021 12:35:40 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] advansys: Remove redundant assignment to err and
 n_q_required
Message-ID: <20210430113540.GK1847222@casper.infradead.org>
References: <1619774728-120808-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619774728-120808-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 30, 2021 at 05:25:28PM +0800, Jiapeng Chong wrote:
> Variable err and n_q_required is set to '-ENOMEM' and '1', but they are
> either overwritten or unused later on, so these are redundant assignments
> that can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> drivers/scsi/advansys.c:11235:2: warning: Value stored to 'err' is never
> read [clang-analyzer-deadcode.DeadStores].
> 
> drivers/scsi/advansys.c:8091:2: warning: Value stored to 'n_q_required'
> is never read [clang-analyzer-deadcode.DeadStores].
> 
> drivers/scsi/advansys.c:11484:2: warning: Value stored to 'err' is never
> read [clang-analyzer-deadcode.DeadStores].

I don't want to spend any time figuring out if this is a legitimate patch
or not.  Please stop running these analysers on this driver, and thank
the University of Minnesota for making me suspicious.
