Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D171C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 05:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF310221E3
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 05:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A2qLdrmK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgIPFWj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 01:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPFWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 01:22:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D027C06174A;
        Tue, 15 Sep 2020 22:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GglU7Jst5YrylNH8E8rXybYpRxWAxJhGu44zSFIItyw=; b=A2qLdrmKGSlnSVGhXVsLpmOYaG
        PU/mo0+3aOcgAF3+kzkhhko6qOnF8Bh+e/8B6nmKBKkrg66kJ616OYPGCLOp7ZJ2eBGmmOsEY+OJr
        FfazYYcfAipNrTGpzValh4MSVUgfqsOI6EuYZjCN5AlwGS34UfCJ0yishfzrh6ETYTkPgGcnxwVGA
        +VuB9OrQOtvNH6Q0mtm3okRYz5zGJW/NYtE1Axa657PfDEvG7yGsAakvmWIqbLK1yGNxqWXPPe9lq
        scDfRK8huC1wBorweaBDG8MZaJVTeNVA8rTlqP535AjV21Xgo4VCPv6OaG9WK18oZ2v6s7HpQnz5C
        X22bsE2A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIPtQ-0003ap-Q4; Wed, 16 Sep 2020 05:22:08 +0000
Date:   Wed, 16 Sep 2020 06:22:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v11 0/4] scsi: ufs: Add Host Performance Booster Support
Message-ID: <20200916052208.GB12923@infradead.org>
References: <231786897.01599016802080.JavaMail.epsvc@epcpadp1>
 <CGME20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe@epcms2p3>
 <231786897.01600211401846.JavaMail.epsvc@epcpadp1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <231786897.01600211401846.JavaMail.epsvc@epcpadp1>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 16, 2020 at 08:05:17AM +0900, Daejun Park wrote:
> Hi All,
> 
> I want to know how to improve this patch.

Drop it and fix the actual UFS feature to not be so horrible?
