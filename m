Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C75C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 05:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245033AbiDAFPB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 01:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245028AbiDAFPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 01:15:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A64260C7A
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 22:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CA1hvW7WjyxnKKlRdWf58paIu3EClTu1cIQzyiNkgCY=; b=JB5TidCKPgXlyK4XAbIDeDnQXk
        Hx5XnqWLIpdi9LDhlY+wZznpvMxtsElL6/OQ0hbWS7a+D7YvCtDS9/NqU4O8kqpQxCILX08ovtz24
        3T9y0kQTl8G9J9WAuS9Q6dVs8BpRPQ28dwCsJ9C3lj6bfAB2mTenDDVGCfAL0dw+QdsgZwvWkLOI/
        m/EWKGgnvK5S4/8KpiUytZhxWJA0748jrnxT+Ia3V7s7iv+P3eYcDfm4bZ/8bdKfqyim/MpMddlVg
        QGPGG9r+UD48cDEE4dGnElqgNJ+N4RD3MXouWS/y7fDOWKHC6Xg/hPjpYsOV435l60kyqbq2AFUig
        tx7S8Emw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1na9aj-004WPb-6n; Fri, 01 Apr 2022 05:12:57 +0000
Date:   Thu, 31 Mar 2022 22:12:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ye Bin <yebin10@huawei.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Message-ID: <YkaJ2dapBN7XQgq/@infradead.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-30-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331223424.1054715-30-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This lacks a changelog.  And making such a mess of the directory and
creating annoyingly long paths better have a really good one.
