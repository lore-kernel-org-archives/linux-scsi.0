Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FA3C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 08:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2298864E32
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 08:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhBJIrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 03:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhBJIng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 03:43:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EE8C061756;
        Wed, 10 Feb 2021 00:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Z4Mk8otGK+jpyE+StMgkefLnz/H6FEtC0tGXbTOrCcA=; b=ht2N0i/MJmJfUxBYS4DSB0ToA4
        AvVXqyhKHoWzR8bgAT/uWcESaqTCYQJw+YeBO0xEVsPP8biT2qJ3rWFLVHlx/hLEpZTBe2dVkSJ8a
        9+D3zum/+F0m9f7AhSIDddf13HqpregqTEKZ53DOKZDn7Mb9ieDzeBSqvhnLV9aY8ianrP9IL4yus
        OPaXZf2YLZc8FPI0sMrEaZzAxUsHeZMeOTsO7SU+mFcraO3Negnc9cFneXej01FbRqYizMB7LT5NH
        FJ6OZvwl0HCqECaYhxKaJ+AjeAMg4jHGDwFyhLIgAO6OyL1gAuQBHNaTxRYAqp5HYVmqONTQ84aMP
        C7iQIXsg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9l57-008b7U-Gt; Wed, 10 Feb 2021 08:42:41 +0000
Date:   Wed, 10 Feb 2021 08:42:41 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 11/13] target: replace work per cmd in completion path
Message-ID: <20210210084241.GE2045726@infradead.org>
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-12-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209123845.4856-12-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 09, 2021 at 06:38:43AM -0600, Mike Christie wrote:
> Doing a work per cmd can lead to lots of threads being created.
> This patch just replaces the completion work per cmd with a per cpu
> list. Combined with the first patches this allows tcm loop on top of
> initiators like iser to go from around 700K IOPs to 1000K and reduces
> the number of threads that get created when the system is under heavy
> load and hitting the initiator drivers tagging limits.

OTOH it does increase completion latency, which might be the preference
for some workloads.  Do we need a tunable here?

> +static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
> +				  int cpu, struct workqueue_struct *wq)
>  {
> -	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
> +	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
> +	queue_work_on(cpu, wq, &q->work);
> +}

Do we need this helper at all?  Having it open coded in the two callers
would seem easier to follow to me.

