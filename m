Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F339C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 16:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7270060FD9
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 16:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242049AbhHZQcg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhHZQcf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Aug 2021 12:32:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEEDC061757;
        Thu, 26 Aug 2021 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vwCaRlHdeFqTGdftXcHYxGmcrUpfebbr5m9LF/gvgDk=; b=bykCvx5QsfuXXmjZrcaoBhSpUt
        3dJb1z9QCYjDp2rreZvtVBhlWluqU3zc53DGBC6f7D5zMjjZDzjf/tWpFvLXZGIqwaIQizs/AMfFl
        q7t/qq3NMK5DT1OPqWnpFZq6dPvTFVhtwRuE+vyos0mGT3XV5i25QKy1c9w8FeHXnxFnuQaqbmLa/
        ohTjq/ktLWuiGjHz4UGxjDOumjISMERe509C11ppLyNfy2uokv0Fe/GbOyVJQUgjyDGzvclt4Azoy
        AhalNIBiSQfcQytfZP+dQLgnLluue+hr8kkGW9vo/v4jYLhr6cj9G6E38Daj2PK7vy5r/dsX4a9Bq
        /mtQaopw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJIHK-00DTRX-Vh; Thu, 26 Aug 2021 16:31:17 +0000
Date:   Thu, 26 Aug 2021 17:30:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc:     linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [next-20210820][ppc][nvme/raid] pci unbind WARNS at
 fs/kernfs/dir.c:1524 kernfs_remove_by_name_ns+
Message-ID: <YSfBwj1zo/w2GCH4@infradead.org>
References: <063e6cf0-94ab-26f2-4fed-aebf1499127c@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063e6cf0-94ab-26f2-4fed-aebf1499127c@linux.vnet.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Are you sure this is the very latest linux-next?  This should hav been
fixed by:

    "block: add back the bd_holder_dir reference in bd_link_disk_holder"
