Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DBBC34026
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 624F222B48
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SNf5w0nJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgBRRXt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 12:23:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgBRRXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 12:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L93uXmdo1WB0FttPt2OeEARmgFjlBb7DbeNFDjVlnbs=; b=SNf5w0nJ40hyIPTGzU9jLx7RpP
        ++jkwmG0HF+sV1aJLZKOnzCvYzR7qqQkFJe4xqg8qvqGTjcqXD3JlNlzlZw6T+v991Di+KM8WP8qf
        Df5Ry8y5nhWbfX8S64+XLRM0NjUA1FLZBdFvZyEvf9F+hOzZFHYKJ61lrjJCZi9zAgnpTHuzaz5Fb
        +NOoBNCach/FxA6/Q1qkqju59ezoHwJH3MdrOilCD2apvIapDQ0v5lY2Z48/a7n3Zc1ful6QTWc2m
        po0g+R1H70dY6bFgfrHEUZFKP9FHyWPdTmFG+79cflsqJL+wvVHl/nzgFVt3uHHYASFB2NzWDUhAs
        kOxmrGwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j46b5-00015A-OT; Tue, 18 Feb 2020 17:23:47 +0000
Date:   Tue, 18 Feb 2020 09:23:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Merlijn Wajer <merlijn@archive.org>, merlijn@wizzup.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: sr: get rid of sr global mutex
Message-ID: <20200218172347.GA3020@infradead.org>
References: <20200218143918.30267-1-merlijn@archive.org>
 <20200218171259.GA6724@infradead.org>
 <1582046428.16681.7.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582046428.16681.7.camel@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 18, 2020 at 09:20:28AM -0800, James Bottomley wrote:
> > > Replace the global mutex with per-sr-device mutex.
> > 
> > Do we actually need the lock at all?  What is protected by it?
> 
> We do at least for cdrom_open.  It modifies the cdi structure with no
> other protection and concurrent modification would at least screw up
> the use counter which is not atomic.  Same reasoning for cdrom_release.

Wouldn't the right fix to add locking to cdrom_open/release instead of
having an undocumented requirement for the callers?
