Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B753EC433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C2620679
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pi07YhB/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfHLOcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:32:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45588 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHLOcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+iypCIFRzSe0EUeDqETCIJfYnROpUQGhgCY1C/z64Ow=; b=pi07YhB/o/axqWLBdN6yzZDr1
        QF4l/SNN9ecBlFBov5KHeY/TTliKwAuH6QxRc/uacWapfeFDegVtUv+eppTQ9FuaGqmeAAdDofSlI
        jh61v2LjPVrSRqXtmMuqsX1W24SiInG7cBV9i7GfyVte4h0r4pVC0HywkWBm2L5syDdDTP5v/A5Je
        b54/9++JjITFh4rk+YTaYxU45vNOvfRi6u7W2Wuj1tk5ct2XDi1HCBQ7gc9b3gchumj6DAr+GMioB
        0Z8qN+jXJoZkWZesD0+H/s2MF66/a19aEAwX4/dcTrJUrPMWM95PyL6xxfYbEbN1z3xlyMUotOD0g
        OtXvTdoeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBMx-0002HH-7b; Mon, 12 Aug 2019 14:32:19 +0000
Date:   Mon, 12 Aug 2019 07:32:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH v3 10/20] sg: remove most access_ok functions
Message-ID: <20190812143219.GC16127@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-11-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-11-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 07, 2019 at 01:42:42PM +0200, Douglas Gilbert wrote:
> Since access_ok() has lost it direction (3rd) parameter there
> seems to be no benefit in calling access_ok() before
> __copy_{to|from}_user(). Simplify code by using the variant of
> these functions that do not start with "__".

Even before there was not much of a benefit.  In general a normal
driver should never use access_ok directly, so this looks like
a good improvement.  But which access_ok calls do you want to keep
and why?
