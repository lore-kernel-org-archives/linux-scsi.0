Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7D7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 18:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3126260EE3
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 18:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhJYS2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 14:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhJYS2f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 14:28:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A4460EBB;
        Mon, 25 Oct 2021 18:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635186373;
        bh=Is70joizMHkD05NPEPzz4v7N6SFiDQAMrXy54zoXJqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YTNgDDQxw9fN+SZcLr4ha5MQ5cpZab22dnKUPsfKGk0rjlPjUKhm72ZmZhqnSMmLd
         c82TCNCYzJH/D9xzM7DrGpXHx0BOS8nsUjpRvORTA9xXh82miKxHTFuGO2d++drkKQ
         zPEBA43+vzWNWUm739C0H6DW3OrqGrcySnohXpCk=
Date:   Mon, 25 Oct 2021 20:26:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: revert HPB support
Message-ID: <YXb2uO55W33/6ZFq@kroah.com>
References: <20211022062011.1262184-1-hch@lst.de>
 <4199e780-32e5-a1ce-65ba-85e0b7a3eda5@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4199e780-32e5-a1ce-65ba-85e0b7a3eda5@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 25, 2021 at 09:12:14AM -0700, Bart Van Assche wrote:
> On 10/21/21 11:20 PM, Christoph Hellwig wrote:
> > The HPB support added this merge window is fundanetally flawed as it
> > uses blk_insert_cloned_request to insert a cloned request onto the same
> > queue as the one that the original request came from, leading to all
> > kinds of issues in blk-mq accounting (in addition to this API being
> > a special case for dm-mpath that should not see other users).
> 
> I do not agree with removing the UFS HPB code from the upstream kernel at
> this time.
> 
> One of the HPB users promised to look into removing the
> blk_insert_cloned_request() call from the UFS HPB code. Shouldn't that
> person be given the chance to come up with a patch before removal of the UFS
> HPB code is considered?
> 
> Additionally, removing the UFS HPB code from the upstream kernel won't
> affect UFS users much. As far as I know all HPB users use Android. UFS HPB
> is supported by Android 12 and will also be supported by Android 13. Whether
> or not this patch is goes upstream won't affect the Android kernel. I am not
> aware of any plans to make any changes in the Android kernel UFS HPB code if
> this patch would be integrated in the upstream kernel.

Under this line of reasoning, why would upstream take the code at all?

{sigh}

Is there a link to where the HPB developer said they would look into
this?  Perhaps until that happens this should be marked as BROKEN?

thanks,

greg k-h
