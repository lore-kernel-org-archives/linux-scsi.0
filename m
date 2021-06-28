Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0416DC2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 14:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA196140E
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 14:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhF1PCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 11:02:08 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54816 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbhF1PAB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 11:00:01 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6B4C621AFB;
        Mon, 28 Jun 2021 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624892254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOklfwJa2r1peTZ8DfyshLs4Ux5Vf4CYeVHE/Vn3sTM=;
        b=EDXLTn8ngzpJ1BZ2I3csbLvFQfG3xKT4WBQtHqI0fCHDVYz0mK0z3aBb2N7aXM2ou5xoir
        rkTtH/gs7YPh9LfN8p5c2Mb/HUBrIuvfkE4COIrnCdYq9rrcQsG+/9JCVawDRUbm7PoyRU
        +r+mHomOiXqKsfchyy57zixr6mXWH7o=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id EE16711906;
        Mon, 28 Jun 2021 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624892254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOklfwJa2r1peTZ8DfyshLs4Ux5Vf4CYeVHE/Vn3sTM=;
        b=EDXLTn8ngzpJ1BZ2I3csbLvFQfG3xKT4WBQtHqI0fCHDVYz0mK0z3aBb2N7aXM2ou5xoir
        rkTtH/gs7YPh9LfN8p5c2Mb/HUBrIuvfkE4COIrnCdYq9rrcQsG+/9JCVawDRUbm7PoyRU
        +r+mHomOiXqKsfchyy57zixr6mXWH7o=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id cwJuOF3j2WDqHAAALh3uQQ
        (envelope-from <mwilck@suse.com>); Mon, 28 Jun 2021 14:57:33 +0000
Message-ID: <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
Date:   Mon, 28 Jun 2021 16:57:33 +0200
In-Reply-To: <20210628095341.GA4105@lst.de>
References: <20210628095210.26249-1-mwilck@suse.com>
         <20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Christoph,

On Mo, 2021-06-28 at 11:53 +0200, Christoph Hellwig wrote:
> On Mon, Jun 28, 2021 at 11:52:08AM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > This makes it possible to use scsi_result_to_blk_status() from
> > code that shouldn't depend on scsi_mod (e.g. device mapper).
> 
> This really has no business being used outside of low-level SCSI
> code.

And this is where my patch set uses it. Can you recommend a better
way how to access this algorithm, without making dm_mod.ko or dm-
mpath.ko depend on scsi_mod.ko, and without open-coding it
independently in a different code path?

The sg_io-on-multipath code needs to answer the question "is this a
path or a target error?". Therefore it calls blk_path_error(), which
requires obtaining a blk_status_t first. But that's not available in
the sg_io code path. So how should I deal with this situation?

The first approach - inlining scsi_result_to_blk_status() - has been
rejected before.

Regards,
Martin


