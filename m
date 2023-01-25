Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379D2C27C76
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 06:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbjAYGtO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 01:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbjAYGtN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 01:49:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D08B45225
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 22:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0WPMAQSseBlTzHXFNhofBUcTmm0UQ3Sb6d8ev0WNI8c=; b=SUyHHXqcXP3afzptodngcoT40t
        mIsZ+4grTkwpqWG02WrM5jMhkknjx59JJ191Or/LHpyZVNYBSH9OXjhUf6ODgkt/VhhZKjcSe8KLL
        5TE8Rifq8CF3afiulOHwTHiGYAFgHyqhZU9bu4Rdgtl32QlZR2S+8Dqvx4Mg310jsn4vCw8UULR8I
        EO9udfqHyq5ozNbeGshRm2WQ0aDmTk087a/BLvMYPKqCtKry0jX+Sm46qFiSOklgj5gUgN4HFcC+3
        iw/J5UAGbIXhoJ2LV/JQZFT7iwiOlJY0FSptWuvakmrpwqRdkd/pkPyczMcpLdi4Z8vi2DcCoy3fL
        VLFOdZKA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKZan-006BNx-Pn; Wed, 25 Jan 2023 06:49:09 +0000
Date:   Tue, 24 Jan 2023 22:49:09 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     mwilck@suse.com
Cc:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: add non-sleeping variant of scsi_device_put()
 and use it in alua
Message-ID: <Y9DQ5VEdr2fDZwic@infradead.org>
References: <20230124143025.3464-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124143025.3464-1-mwilck@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2023 at 03:30:25PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since the might_sleep() annotation was added in scsi_device_put() and
> alua_rtpg_queue(), we have seen repeated reports of "BUG: sleeping function
> called from invalid context" [1], [2]. alua_rtpg_queue() is always called
> from contexts where the caller must hold at least one reference to the scsi
> device in question. This means that the reference taken by
> alua_rtpg_queue() itself can't be the last one, and thus can be dropped
> without entering the code path in which scsi_device_put() might actually
> sleep.

If there is always guaranteed to be another reference, why does this
code even grab one?  The pattern of dropping a reference that can't be
the last is pretty nonsensical.

