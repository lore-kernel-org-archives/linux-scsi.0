Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D08C3F68F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D1CB2082E
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ij6N7tAj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgBCJQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 04:16:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56466 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgBCJP7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 04:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2WbZ053ra9RftP4cOTLZDHvYMDipdLzrXoaF3acCxEw=; b=Ij6N7tAj9PNAsgWcYPONFwkGZF
        6/rsne7c76sZHSwBndrw6DFgF3uBY46PqcDbd+uKJmjLT9wDAVNDx8sRlDLgx5DhezaRIdS/dBRjB
        9giP2kzRCHbCjI8Mj06U8v5KNWqPCF3dEGOTL5qpFe721cYEOYoxEs3V4wOKHUJiLSlyBWdQc2GkB
        n80ACVEhQIaFwxrD6aoy8L6rbIihA+yFTg2OsA74L0ZLb/l1C5ZX0ILlQYpxyIj4lha7cqGPC4gKC
        d8Dd6GHgEQozCR0p+BobWCl6EVFm1aPrqM+NnSgBu/8CwEkE5hWgeXljriobRDRdgJwsCvR09tpa9
        vZpgFz5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyXpm-0000Mh-HM; Mon, 03 Feb 2020 09:15:58 +0000
Date:   Mon, 3 Feb 2020 01:15:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 0/9] Inline Encryption Support
Message-ID: <20200203091558.GA28527@infradead.org>
References: <20191218145136.172774-1-satyat@google.com>
 <20200108140556.GB2896@infradead.org>
 <20200108184305.GA173657@google.com>
 <20200117085210.GA5473@infradead.org>
 <20200201005341.GA134917@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201005341.GA134917@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 31, 2020 at 04:53:41PM -0800, Satya Tangirala wrote:
> So I tried reading through more of blk-mq and the IO schedulers to figure
> out how to do this. As far as I can tell, requests may be merged with
> each other until they're taken off the scheduler. So ideally, we'd
> program a keyslot for a request when it's taken off the scheduler, but
> this happens from within an atomic context. Otoh, programming a keyslot
> might cause the thread to sleep (in the event that all keyslots are in use
> by other in-flight requests). Unless I'm missing something, or you had some
> other different idea in mind, I think it's a lot easier to stick to letting
> blk-crypto program keyslots and manage them per-bio...

But as far as I understand from reading the code it only sleeps because
it waits for another key slot to be released.  Which is exactly like
any other resource constraint in the storage device.  In that case
->queue_rq returns BLK_STS_RESOURCE (or you do the equivalent in the
blk-mq code) and the queue gets woken again once the resource is
available.
