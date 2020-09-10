Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B210CC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 17:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590FB21D40
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 17:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OHYevH9q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgIJR4M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 13:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgIJRxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 13:53:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189A0C061756
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=04xRBOB+AoJRWqJxSCcL9dNVHexBeQMkgUOZJ5iV1sI=; b=OHYevH9q52Dr7EGwzomDRyV2nn
        9fLQENN9A1Rgu6AfBKXPta+QzZep6/gnItJzM278el2QslahDDvj0uFfnQ6sf+2/8oDaQGKd1FTgZ
        UkFuhnCH3WWfSzz7WaBmi+ARIfFxrcaDB0/uoCU+oKBgQZtoPZQv3kksvrgIFyXa/mMP9AofmlKp3
        HpUIdZXXqN17ECHymuRAjmg2RFVePPblANNiKa7KbPNdjgSNY0S8RsXZRc3IkOOEhvUP0m3reLJ0G
        o9FWQdX+uxGUWvZ7EToWoUi3RRFT+s37q6THVj+WtC6hwGqz/UTBRfiIm4vHxxkJhUYzYUXGosNBH
        V/HjKAUQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGQlT-0002am-Mn; Thu, 10 Sep 2020 17:53:43 +0000
Date:   Thu, 10 Sep 2020 18:53:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: handle zone resources errors
Message-ID: <20200910175343.GA9539@infradead.org>
References: <20200910073952.212130-1-damien.lemoal@wdc.com>
 <20200910073952.212130-4-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910073952.212130-4-damien.lemoal@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 10, 2020 at 04:39:52PM +0900, Damien Le Moal wrote:
> +		case DATA_PROTECT:
> +			sdev_printk(KERN_INFO, cmd->device,
> +				    "asc/ascq = 0x%02x 0x%02x\n",
> +				    sshdr.asc, sshdr.ascq);
> +			action = ACTION_FAIL;
> +			if ((sshdr.asc == 0x0C && sshdr.ascq == 0x12) ||
> +			    (sshdr.asc == 0x55 &&
> +			     (sshdr.ascq == 0x0E || sshdr.ascq == 0x0F))) {
> +				/* Insufficient zone resources */
> +				blk_stat = BLK_STS_DEV_RESOURCE;

BLK_STS_DEV_RESOURCE is a magic error code leading to a retry on the
particular request_queue once it isn't busy any more.  Please don't
abuse it for random other conditions.
