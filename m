Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7102BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 05:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiEXFZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 01:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiEXFZn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 01:25:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4CF7523C
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 22:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tv/kVpWnrFhweB87b0xV87TRS6MZJrqj93SopUQSdng=; b=4T5xGVhwy/VKKCyCUtsJhlogxe
        O7nCDSCuBmERMOYs5ymZzoJMxQytGbbbEIRSsBwrD2IcnsDgu5PIDrcuAfjWVDCk6hjGD01FZn9B3
        kD0/elkRHVy0wUnvhwzCGPmDUPztc9VudzeJvOEuRWz5180bZEqpXaXgAf/Ws2wp0q9YoP/Z3G1qq
        csMOYiQ/lAarSJexvjBp+BN+Nz9NVFpeuApoTpIyaA5HXkqrorUEicRP6pzRmyw5vJ1Z3dzCtIJd0
        mGe4muXq5I5BL77SIfmW8mhzeoqD/BlixbVzvU+eSNhZtApHyxm12tuJv2EakBA2cPeQWTBlHGJsr
        s/C2zk7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntN38-006rOq-25; Tue, 24 May 2022 05:25:42 +0000
Date:   Mon, 23 May 2022 22:25:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
Message-ID: <YoxsVi0EYuWQxcoO@infradead.org>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 02, 2022 at 08:09:17AM -0700, Brian Bunker wrote:
>         case SCSI_ACCESS_STATE_ACTIVE:
>         case SCSI_ACCESS_STATE_LBA:
> -               return BLK_STS_OK;
>         case SCSI_ACCESS_STATE_TRANSITIONING:
> -               return BLK_STS_AGAIN;
> +               return BLK_STS_OK;

As there is a lot of discussion on BLK_STS_AGAIN in the thread:
Independent of the actul outcome here, BLK_STS_AGAIN is fundamentally
the wrong thing to return here.  BLK_STS_AGAIN must only be returned
for REQ_NOWAIT requests that would have to block.
