Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFF3C17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 14:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F27421D7F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 14:22:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Aqto3Grl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKMOWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:22:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKMOWN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 09:22:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z6v4nLsUw0L09vyumEvW5kAmrgoiKUojczjpjwUyStw=; b=Aqto3GrlTVZHwB/d4+Dx0xUcy
        TBiS42GfmRAmWNA1yBLtPMAzzGVhZ8AQ/KWh6yJYUC+2Pf7LoUdX8HjW60jb9H2szCw9aj2Z2qJrp
        OgjH6ovTs3o7xZCkEUFDfxbuORC44znKzhgHPIAJKZPMFeWFDdbZgKHOfy8V9sc4DJvcqQBdk5xaB
        AGbiy+Zz6O0lxCXIlp5mphyUpdLXd5iTgniud6LrhoMw8jDWzypQZZEL/+N6D7cxpXe9v/+7TVOsC
        fYiJG0DUxKUMCJEp2w8+DSmnK5nRAZoVNAlwXwnET3+QP81QOvWwxl6o4XPr0mUOfL7sng2nkPkrJ
        HFNrsr+iQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUtX6-0002iK-5G; Wed, 13 Nov 2019 14:22:08 +0000
Date:   Wed, 13 Nov 2019 06:22:08 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Kars de Jong <jongk@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com,
        fthain@telegraphics.com.au
Subject: Re: [PATCH 1/2] esp_scsi: Correct ordering of PCSCSI definition in
 esp_rev enum
Message-ID: <20191113142208.GA8269@infradead.org>
References: <20191029220503.7553-1-jongk@linux-m68k.org>
 <20191112185710.23988-1-jongk@linux-m68k.org>
 <20191112185710.23988-2-jongk@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112185710.23988-2-jongk@linux-m68k.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 12, 2019 at 07:57:09PM +0100, Kars de Jong wrote:
> The order of the definitions in the esp_rev enum is important. The values
> are used in comparisons for chip features.

Yikes.  Wouldn't it make much more sense to have a feature bitmap?
