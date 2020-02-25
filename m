Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D252BC35E0C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 18:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A151A20CC7
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 18:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ePFigL3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgBYSbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:31:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731421AbgBYSbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Feb 2020 13:31:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t1WwF6n5tlSQpBDc9p0ipDbK2PUTnPwKxTI3G43a4OY=; b=ePFigL3beOPsFb5YkFshOrTnwx
        1XnRYuP8NYZorurDnGX+HqVbeX7bhRn/1yi6Y2eSwBa15nRxxfBu6HQhWr0Nf94GjXoAT/ijy3P3X
        zNbom69nxsBf7GPMPG5VAmSSlguaXxZMaoVRUzgLkUH47yYjyROg2H0rY/AM86NUHTn83icT44X84
        J8HrdDAElr+TtqwtdjiLidgizveYKlR5cJlmBV0FEvqDyLP7+QUr9bhobQe0ZJCRr76VSwG3GTj/m
        O5h9iNu2gPjop3N5znW0clkw3GcUkJpsJ/z/BshndD9vNHX2qsavmoOQRqgRa2cec7vzt9DyQKoMH
        PB70wumg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6ezO-0001nC-8k; Tue, 25 Feb 2020 18:31:26 +0000
Date:   Tue, 25 Feb 2020 10:31:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     AlexChen <alex.chen@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, zhengchuan@huawei.com,
        jiangyiwen@huawei.com, robin.yb@huawei.com
Subject: Re: [PATCH V2] scsi: add a new flag to set whether SCSI disks
 support WRITE_SAME_16 by default
Message-ID: <20200225183126.GA6261@infradead.org>
References: <5E28118F.3070706@huawei.com>
 <5E3520A7.5030501@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E3520A7.5030501@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Feb 01, 2020 at 02:54:31PM +0800, AlexChen wrote:
> When the SCSI device is initialized, check whether it supports
> WRITE_SAME_16 or WRITE_SAME_10 in the sd_read_write_same(). If
> the back-end storage device does not support queries, it will not
> set sdkp->ws16 as 1.
> 
> When the WRITE_SAME io is issued through the blkdev_issue_write_same(),
> the WRITE_SAME type is set to WRITE_SAME_10 by default in
> the sd_setup_write_same_cmnd() since of "sdkp->ws16=0". If the storage
> device does not support WRITE_SAME_10, then the SCSI device is set to
> not support WRITE_SAME.
> 
> Currently, some storage devices do not provide queries for WRITE_SAME_16
> support, and only WRITE_SAME_16 is supported, not WRITE_SAME_10.
> Therefore, we need to provide a new flag for these storage devices. When
> initializing these devices, we will no longer query for support for
> WRITE_SAME_16 in the sd_read_write_same(), but set these SCSI disks to
> support WRITE_SAME_16 by default. In that way, we can add
> 'vendor:product:flag' to the module parameter 'dev_flags' for these
> storage devices.

Please send this along with the patch that actually sets the flag
somewhere..
