Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F95C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA8C611C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhFGGiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGGiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:38:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F18EC061766;
        Sun,  6 Jun 2021 23:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zg3Z5zg3zGE7efXmuaQFxaAI12lHroFjA1H1ShFPy3s=; b=TIBLuF9+KKCV6cBbPMYH8ikhVZ
        IR6tjJMCeklxGkFm5ZM3FtmR3KUBv4noW129cD6e7so/Cijd6+jdzs3DQZYN3Z4M5lrwMqmPIL2+1
        +X7HEGc8qCvCkV2Ilz06IMo9EHU+xsoVd5tNDi3xWfJoVB6iXvD8SGr2+atumIrHYeh08vktzEuw+
        dV0oozBDRcMO0B4xdczG04FaaijvmQ6ALlcct3gw17wmkEhOwanNFhcPS5R4JyWf+1dFdPvIK5tiy
        J1FKtGCCEeAqR4zptmCxzFueEtB9DbbELoTnfqRoz0ZasdREnC/309myai9kP8QSp5ZnlN0JLcqWE
        xPQbNbdA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lq8qs-00FRjs-0C; Mon, 07 Jun 2021 06:35:14 +0000
Date:   Mon, 7 Jun 2021 07:35:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Changheun Lee <nanich.lee@samsung.com>, damien.lemoal@wdc.com,
        Avri.Altman@wdc.com, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, alim.akhtar@samsung.com,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        cang@codeaurora.org, gregkh@linuxfoundation.org, hch@infradead.org,
        jaegeuk@kernel.org, jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        mj0123.lee@samsung.com, osandov@fb.com, patchwork-bot@kernel.org,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        tj@kernel.org, tom.leiming@gmail.com, woosung2.lee@samsung.com,
        yi.zhang@redhat.com, yt0928.kim@samsung.com
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Message-ID: <YL2+HeyKVMHsLNe2@infradead.org>
References: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CGME20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74@epcas1p1.samsung.com>
 <20210604073459.29235-1-nanich.lee@samsung.com>
 <63afd2d3-9fa3-9f90-a2b3-37235739f5e2@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63afd2d3-9fa3-9f90-a2b3-37235739f5e2@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 04, 2021 at 07:52:35AM -0700, Bart Van Assche wrote:
>  Damien is right. bd_disk can be NULL. From

bd_disk is initialized in bdev_alloc, so it should never be NULL.
bi_bdev OTOH is only set afer bio_add_page in various places or not at
all in case of passthrough bios.  Which is a bit of a mess and I have
plans to fix it.
