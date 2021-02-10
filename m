Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6E0C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 08:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EAAF64E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 08:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhBJIhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 03:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBJIgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 03:36:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23085C061574;
        Wed, 10 Feb 2021 00:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IZKqDIwBA9Z7X8ejRUmkcmCCTw1KCnYEp9Ve7/mBumQ=; b=ujR89gDJ65rxUd4tUItIFlgXof
        OOsJnuLYZHOTWs03vysbW8ZkYO5pwAF7CW64oHiZpkCACb/R2A1ZkAOziDAKembK+tSGDOtkvfNg7
        MbwezwIqA4QQjlydlqyyS8fkXAsdM3UV5PSLV4qaQIc/W1RGS69iFshPsdkkp4f6B5VH8gauTA1A9
        mdA0c0X7X2l2n/SdrNumUYWCVyi4ygRrsithpki4zzH/UTvTWKOl2sZGwtXCWYV8CnnAH9yG/51zZ
        6eAHY0cV2BT2XuVxMzmJjvfomy7ZLoMkNEjYNHRHp7co75W47OJfsPSYJVzAqQ0L05eJq6RGV7L2h
        zyNr0lww==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9kxu-008aOj-9I; Wed, 10 Feb 2021 08:35:16 +0000
Date:   Wed, 10 Feb 2021 08:35:14 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 01/13] target: move t_task_cdb initialization
Message-ID: <20210210083514.GA2045726@infradead.org>
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209123845.4856-2-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 09, 2021 at 06:38:33AM -0600, Mike Christie wrote:
> The next patch splits target_submit_cmd_map_sgls so the initialization
> and submission part can be called at different times. If the init part
> fails we can reference the t_task_cdb early in some of the logging
> and tracing code. This moves it to transport_init_se_cmd so we don't
> hit NULL pointer crashes.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
