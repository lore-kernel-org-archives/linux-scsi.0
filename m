Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA673C41621
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 09:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFD7B20842
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 09:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jbHkQoJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgCXJXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 05:23:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46844 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgCXJXY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2020 05:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6Wy8iZQZzV70sRVTL817gfHxZa0T86F9cB+ut4HSzmc=; b=jbHkQoJW1ml81vD2Pgx0J2HAYA
        JYiB26BZKDnuBEQMlJSxowAYwq7PfOPOcd8mNkibYQzZzawPNrw045HkTxSJ5P2ksOeEerLhH1XvI
        M8nCJkCHCGdgJ16EEUIRqRzPxLsPjMUK4T9i3sYUYCUTtIKstN8RXqLP8tyoEWRcN+hM1Z1sM26FS
        myRJgtQTGleqFqqkDytd5S8Wjl6Mr/N8Ovde7V8x4AViDt9sYWV0+GgNSDYqv7843aepMRttuk5H8
        qJJdFzb9ag8Cn6tWiZMOjmn4gQqqq/TXYtQBBDLfktdRLREmnSXJOXRYUe0ix9Y4DokBoNHI6w5BO
        twFz1OUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGfmN-0002Yg-Kb; Tue, 24 Mar 2020 09:23:23 +0000
Date:   Tue, 24 Mar 2020 02:23:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Subject: Re: [RFC PATCH 5/5] scsi: target: avoid XCOPY per-loop read/write
 cmd allocations
Message-ID: <20200324092323.GE18399@infradead.org>
References: <20200323165410.24423-1-ddiss@suse.de>
 <20200323165410.24423-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323165410.24423-6-ddiss@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 23, 2020 at 05:54:10PM +0100, David Disseldorp wrote:
> Reads and writes in the XCOPY loop are synchronous, so needn't be
> allocated / freed with each loop.

That is true, but I think with your previous cleanups we can easily
go one step further and just allocate a single command and sense buffer
directly in struct xcopy_op, and just have local completions on the
stack.
