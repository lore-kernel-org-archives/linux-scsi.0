Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FE9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 10:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB01A61175
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 10:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbhKIKGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 05:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238163AbhKIKGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 05:06:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B43C061764;
        Tue,  9 Nov 2021 02:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JNGqVmgLfbMzRY+ISMQcGKvjfCrSOfIWsFR9dyf30Hw=; b=uhmT1IFJnAG1xPZMdJH5AH5yAn
        4ohzSdYONmmYj6IjT7sc/TFtZEkrCf+WTcRvfyAA2+V2RYszDfnIqGo8n/JzmkBTDHJKlALcaYiTw
        5eeVKOBvTbwVBaDuZ4qgNFQ9hsx8fb8s8XJJQ2eqnyZCwoa4JD5KdxESHJsb//+Zq4BmhjR166z/m
        8ZQbwgTPn9Wfcxpw+z8TknOKHZiiQSHWK4u48L05ScNGVLsrj5ZV/GUV/b4Y+Kwm4K09BdGqyEOqX
        tGeAHmKi9znn3CHMZYNabl9Okv/QMSKs43bzQY8D2LUP7cjDf3jGO6ickyjKYuG7N3gOskjSBV04g
        aC+tH8oQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkNyT-001OkX-6A; Tue, 09 Nov 2021 10:03:29 +0000
Date:   Tue, 9 Nov 2021 02:03:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     brookxu <brookxu.cn@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] scsi: core: use eh_timeout to timeout start_unit
 command
Message-ID: <YYpHcRi0TnjSpQqg@infradead.org>
References: <1636337956-26088-1-git-send-email-brookxu.cn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636337956-26088-1-git-send-email-brookxu.cn@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 08, 2021 at 10:19:16AM +0800, brookxu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
> 
> In some abnormal scenarios, STU may timeout. The recovery time
> of 30 seconds is relatively long. Now we need to adjusting
> rq_timeout to adjust STU timeout value, but it will affect the
> actual IO.
> 
> ptach 9728c081(make scsi_eh_try_stu use block timeout) uses
> rq_timeout to timeout the STU command, but after pathc 0816c92(

patch is mispelled in two different ways here.  But you probably
want to use commit anyway and use 12 charater commit hashes.

> -			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
> +			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->eh_timeout, 0);

Both the old and new coe is completely unreadable.  Please wrap lines
after 80 characters

Otherwise this looks good.
