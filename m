Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E64C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C1B6121D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhFGGfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhFGGfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:35:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1326AC061766;
        Sun,  6 Jun 2021 23:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5RUpGXMX4B3J1RSt3/98n+4qt36B8ax16+0GdPzXMoI=; b=L4cMz+FEqGPW0DmtDY5xEENsd+
        sHdAbCAOIcpym5MyutP4pNh7zTpt1QJeU3WwVtrbSkpzDaKHLYJKW5dX11Vq80FgMWC4voPTF/m5+
        msvmuXJnAZFX4tBvcJZDvS+P3xdsZM9RVODI2uLTAJpdFWSmwWmryQK9GCcURedpAuA5z8ZHFwxq8
        U9qwGrRR6LoeHm6Sk0qMoJI3zRK/x765or9BB9Q7oKwG0VKNUYQgzckerLiF9weRs8ALGuhV7vTNW
        b/1oAciZG6tx7wzDQs6veKdu41mn5BPA0J3lrAF0D5UOFn5ZcjvIyrtcKYkW0hXRQK90MjU02uOtH
        gKVYP1Ew==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lq8oK-00FRbT-UF; Mon, 07 Jun 2021 06:32:39 +0000
Date:   Mon, 7 Jun 2021 07:32:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Changheun Lee <nanich.lee@samsung.com>
Cc:     Johannes.Thumshirn@wdc.com, alex_y_xu@yahoo.ca,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        cang@codeaurora.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        bvanassche@acm.org, damien.lemoal@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org, jaegeuk@kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com, osandov@fb.com,
        patchwork-bot@kernel.org, tj@kernel.org, tom.leiming@gmail.com,
        yi.zhang@redhat.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, mj0123.lee@samsung.com,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        woosung2.lee@samsung.com, yt0928.kim@samsung.com
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Message-ID: <YL29gP0j1qmVuzyy@infradead.org>
References: <20210604050324.28670-1-nanich.lee@samsung.com>
 <CGME20210604052159epcas1p4370bee98aad882ab335dda1565db94fb@epcas1p4.samsung.com>
 <20210604050324.28670-2-nanich.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604050324.28670-2-nanich.lee@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NAK.  As discussed countless time we already have an actual limit.
And we can look it as advisory before building ever bigger bios,
but the last thing we need is yet another confusing limit.
