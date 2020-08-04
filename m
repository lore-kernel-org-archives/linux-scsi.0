Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3071AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 06:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3505320781
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 06:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ImQJLxAR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgHDGCi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 02:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgHDGCh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 02:02:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CCEC06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 23:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ULPczTvfdrUTmx0uy351+OFl63l2vBN1CtbZaGISveQ=; b=ImQJLxARxOcY5a5h24e6mzpfkD
        QoSsbPWRBoed+YfZBCnMqXGiXADjbISoyeyD7uuwpVFO0xVr5WHR8YaUZUGvkm6Y86C3rbYQnfeDF
        Ih8O4IhDap/wmywxAkrALrps1QTqQKWMWk3/TicKBvZUxJ5Gxfo3pQfIBIAY2AKrFhj/DWShzdRKI
        ZXjxIXkWKUiUk0yitJ/Ep7Oef97VNfPCNFI+as9dhP+o2duQnTP147JzdlK/fqUnGhuzv222ENaRO
        EDHQoeZbyE6Ac+G2PcZCL+UlDTosR/3cGbeFe3a1gwC6d2t1hAM4UIu/NiZR141AfcEh++ashdbWT
        qzksxFcA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k2q1z-0007c7-8P; Tue, 04 Aug 2020 06:02:35 +0000
Date:   Tue, 4 Aug 2020 07:02:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        jinpu.wang@profitbricks.com, martin.petersen@oracle.com,
        yuuzheng@google.com, auradkar@google.com, vishakhavc@google.com,
        bjashnani@google.com, radha@google.com, akshatzen@google.com
Subject: Re: [PATCH V6 2/2] pm80xx : Staggered spin up support.
Message-ID: <20200804060235.GA28428@infradead.org>
References: <20200804045628.6590-1-deepak.ukey@microchip.com>
 <20200804045628.6590-3-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804045628.6590-3-deepak.ukey@microchip.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As mentioned before - this should be a libsas or transport class policy,
and not a module parameter hack in one driver.
