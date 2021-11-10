Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71928C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 06:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 540F56112F
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 06:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhKJGpR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 01:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhKJGpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 01:45:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3A5C061764
        for <linux-scsi@vger.kernel.org>; Tue,  9 Nov 2021 22:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vf/07pP4G3bhbIsuYh46Pcr1Z+VmGZBaV4ijvRVoo4c=; b=ip7tsprwDVoQZI+3tLyArNAfB4
        hWMAZsc1Gus5FmVaBoj8xZgXtQgnAD0iyoh+JtPw72OQxcwc+vAxYe/CYvQCv1ugiwV62kBQ9zE9R
        UZMQEljVCfAjXjAyT0PCWmXGBYEmDZ2GA13YHiHEH2oYaG+T4/JP8+aNSb3pwOpMl4shC5sgvhe3O
        hXleLW5kAs8cTLX+IVHV5Yq8xALvmyPtI2SGw61lvZE1CVI48Q+oCJf0dpsTUsLFf0FaeNSNJ/tE8
        rml3vgnqPY8jWt0ZBcadUV14y/K2ZwYDCt8jnE/Cr9JMR0lsDe3BD/IiLloQNbAPnv3+B5RiSCrvX
        lc65UySg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkhJU-004ccE-3B; Wed, 10 Nov 2021 06:42:28 +0000
Date:   Tue, 9 Nov 2021 22:42:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH 07/11] scsi: ufs: Fix a deadlock in the error handler
Message-ID: <YYtp1OSKI3w9dRvh@infradead.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-8-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110004440.3389311-8-bvanassche@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

as pointed out last time: LLDDS have no business directy allocating
tags.  Please work with Hannes and John on the proper APIs, as metnioned
last time as well.
