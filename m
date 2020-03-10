Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB70C10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 18:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871D5208C3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 18:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ed6zJKUM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCJScx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 14:32:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgCJScx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 14:32:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BM1rOj2mhNiPAl7HQ9Dqr15pnyhMXu6TgEmfxY4G2dE=; b=ed6zJKUMN0NHTWgGMZZSTBEMDJ
        ZDwYVpOOtBbWFiUHnmoG6GaShnCVBNtgLFdocdwwRDKj4qutRI2XnmiCFY3FvYu0H6LTim5ZMYG7l
        er2Lg68TxUnu7dgmzliLVYHYuWZlDRVJZnXxTrNbeyTmFNxMT/4eKfoklcs5lYKYFagBDGM3D1DXQ
        Mfob/seec8sdaZisq4mZffAyZUetOdUKq7p7SqhAx2aZ6sX/rk12t8fIAlAmkmzXB/Fu5MVzj1oNr
        3IDqAJiLb2d029n6cYMi7pHsO0hMT85id6WaFxFPrLWgXPuuRoplFfqkZd8EvysaP2+Sgd06AOwkD
        QGZb4vxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBjgJ-0005Yb-SK; Tue, 10 Mar 2020 18:32:43 +0000
Date:   Tue, 10 Mar 2020 11:32:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hare@suse.de, ming.lei@redhat.com, bvanassche@acm.org,
        hch@infradead.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved
 commands
Message-ID: <20200310183243.GA14549@infradead.org>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-3-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583857550-12049-3-git-send-email-john.garry@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 11, 2020 at 12:25:28AM +0800, John Garry wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Allocate a separate 'reserved_cmd_q' for sending reserved commands.

Why?  Reserved command specifically are not in any way tied to queues.
