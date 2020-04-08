Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78496C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46584206F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O+Ik7Sos"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgDHPvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:51:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729176AbgDHPvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 11:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3TVQ8OuCOqm5u7QKIVuMFaQ6Kl80j1kU+GJpUrmQSYw=; b=O+Ik7Sos0/y1kNJXRJYyD5cPo+
        6WG1mou84xehUfjuoD5fzcKyA/u+8mXpUE9wexoieq3Wt9jOuO/HL4cjfme196967buYKUzc6RDJs
        tKQL5SrY8H9ldiaaVYCtau9JggCoTXAtPgevVW85dc5rn+Hvn2JLCfLg1RCKcIQKs7WDn/6UdJugC
        67rfoRMoD7sf8Yc4Hjft6u4jozi5LVARVfa0sUxWxB5VmD6way6TIsB41ZKfrvxF+xp80dezYUV1z
        IpH0BPWoMA1ZFgKvIH9iBLlSqBbSiVFXChh6aQFj1Tyay5eC9KLdVuhcEivLDR5slcZy1S4yPT8wY
        EOy5T/VA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMCyi-00030t-Ef; Wed, 08 Apr 2020 15:51:00 +0000
Date:   Wed, 8 Apr 2020 08:51:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4 02/10] block: Introduce REQ_OP_ZONE_APPEND
Message-ID: <20200408155100.GA29029@infradead.org>
References: <20200403101250.33245-1-johannes.thumshirn@wdc.com>
 <20200403101250.33245-3-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403101250.33245-3-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Another nitpick - op is only used once in __bio_iov_iter_get_pages,
we can just call bio_op there directly.
