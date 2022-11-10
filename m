Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD30C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 08:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiKJITR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbiKJITQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 03:19:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5E61CB1A
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 00:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DAT3dq57X9oMwpbf8Tr7IdxJczkHIVmJSZ1mkR4v/ro=; b=G267cKsHn8pr092smElDeJm1po
        xPs4oIW63wkUAzuy5V7axrM3UllTcdgO9sY5Yn4zGAhoyChnH5KT8BsuKV16UjDtDuqUQD7vKOo5x
        GQFCT6Uwa+R6A30vj1KW84sZDDaRAoLlrnRx+0fO26iCryDhl3fZP4yNZQbulLP7YXGYvfBcNyglE
        5lB+hslTJfofZTsyDJpZLi30FI3evfVWiqB15TMhhpLv9OFQSy5VfNoiM7M+tPHXp0H1R83GBprIu
        amH5vVhUrDxavLDQ08vUbcPgFquV55YPtABPAj6rB6iJZ2P4eZfGNIMuy8TgESEfZj5QzYbFUnylX
        nqO7CjsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ot2mI-004Feq-Kg; Thu, 10 Nov 2022 08:19:14 +0000
Date:   Thu, 10 Nov 2022 00:19:14 -0800
From:   "hch@infradead.org" <hch@infradead.org>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 0/2] scsi: sd: use READ/WRITE/SYNC (16) commands per ZBC
Message-ID: <Y2y0AhBCm+O4HoRg@infradead.org>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
 <Y2ue2rZzf74/1V+U@infradead.org>
 <20221110022009.xdfmlpdpw2kyu32x@shindev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110022009.xdfmlpdpw2kyu32x@shindev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 10, 2022 at 02:20:09AM +0000, Shinichiro Kawasaki wrote:
> My point was to make the check strictly follow the ZBC spec. But now I see that
> it's the better to keep enforcing 16 byte commands to host-aware devices. I will
> drop the first patch and revise the second patch to enforce SYNC 16 on both
> host-aware and host-managed devices.

We don't "enforce" anything.  We just don't send the legacy commands for
devices that are guaranteed to be modern.  What is the advantage of
ever sending 10 bytes commands (inluding SYNCHRONIZE CACHE) to a modern
device?
