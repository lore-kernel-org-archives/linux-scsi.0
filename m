Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B35CE7A81
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Sep 2023 14:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjIYOz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Sep 2023 10:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjIYOz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2023 10:55:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F04810C;
        Mon, 25 Sep 2023 07:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wJKSHvRX2JxkhPx/HsYL92E1VTGeWyXM9NmRTnd2dkM=; b=KMgCFdcYzdi4gJvjK3P/sbbm3j
        WY1MDli4qbflqNzaQAQ4MI0hGRJunn+B/+4PUyReklOdHF9lVO8ix/vQjT2pcYI7At97OILvsSP1m
        anl6QjfMJ/OQ68+T6S2Ng9OcCVmtmfN2vkNm8BTYEAjSTe86zgL2l65ogXqeJTLk6GYethIbJ6eih
        q90vhS8qP7LHFe298SL/48kJ1oiHSduLIXykGeKNx47B4t955qe1Rmmw0XW7vRuzOVob08iKcPgET
        0+BZQrFImlnb+7OREtu+G3JQNwaPYL9zE9AK4isuXxM9R9HukQ1jeQg93Ujowqmvts7m0G4TQUZ+H
        Yy6BaiFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qkmzz-00EU4W-2A;
        Mon, 25 Sep 2023 14:55:47 +0000
Date:   Mon, 25 Sep 2023 07:55:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Wenchao Hao <haowenchao2@huawei.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        linux-kernel@vger.kernel.org, louhongxiang@huawei.com,
        lixiaokeng@huawei.com
Subject: Re: [RFC PATCH v2 00/18] scsi: scsi_error: Introduce new error
 handle mechanism
Message-ID: <ZRGfc73BSW0yyUtI@infradead.org>
References: <20230901094127.2010873-1-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901094127.2010873-1-haowenchao2@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before we add another new error handling mechanism we need to fix the
old one first.  Hannes' work on not passing the scsi_cmnd to the various
reset handlers hasn't made a lot of progress in the last five years and
we'll need to urgently fix that first before adding even more
complexity.

