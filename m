Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05225C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Mar 2022 14:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350758AbiCXOPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Mar 2022 10:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345387AbiCXOPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2022 10:15:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BC61EAEF
        for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2022 07:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7Z/r82wa7w3msF4Kd/pgdAVu27ZJ9m0SnlLATLjkuHQ=; b=AZynSWR2M4KE4E+1dC49+XQjgI
        noQCHZmgLj4VS/YqTaz7K1GN2xW4UbtXSlbiWn9PxBnn8SuJT6R/pzUtSvLL7f+0Q5clOUuFORGEh
        fjORDPn/nY8r5A8srJrjrmrzQFdlvukmahcIif9irHhV9TxtcORBS+Dwv0bMSSxeyCj6lDAkR0Z0T
        PgodFNdUybR79e9UI4YRXqRYRoxhJnJYdljyK1ha5gABnjgekqUIo6cxfn5sL9fan/o71B63N0i38
        t48v+/vkWYq0uU/KM4hhA4AZoVOS29WgLdEQ2Ti/3FCEeWJZ0TY1u6mitceKjmPwORjYDw/C3s6Sa
        JGVjH/aA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nXODk-00Gnu5-If; Thu, 24 Mar 2022 14:13:48 +0000
Date:   Thu, 24 Mar 2022 07:13:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH] scsi_logging: fix a BUG
Message-ID: <Yjx8nJSI0cK+s3LA@infradead.org>
References: <20220324134603.28463-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324134603.28463-1-thenzl@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 24, 2022 at 02:46:03PM +0100, Tomas Henzl wrote:
> The request_queue may be NULL in a request, for example when it comes
> from scsi_ioctl_reset.
> Check it before before use.
> 
> Fixes: f3fa33acca9f ("block: remove the ->rq_disk field in struct request")
> 
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>

As a quick fix this look good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

but I really wonder if we should print some other identifier if the disk
name is not available.
