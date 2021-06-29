Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5C6C11F68
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 19:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D7661DE3
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 19:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhF2TZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 15:25:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47604 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbhF2TZs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jun 2021 15:25:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 88B7C1FDAE;
        Tue, 29 Jun 2021 19:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624994599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MCow5Mmxjs5zmhll+3ZLV7+VbvmuHjxRbD+cMMG5nZ4=;
        b=b+FfdOPSjtxO0ditRdIHNiY3O11Sl4jSuHd2YvrJd5B3xR7AKq86TONGSarl6K/yjC8Rd3
        y4o0xx9shO/Fw9pm2i9CtQTGcWkinmxEWcjIpFbHgMBKmMk5PV72idkg6omZcwd7RHK2ix
        aM80PAgvdFkgiKYGinuyvWjRmC1+sak=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 15DA111906;
        Tue, 29 Jun 2021 19:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624994599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MCow5Mmxjs5zmhll+3ZLV7+VbvmuHjxRbD+cMMG5nZ4=;
        b=b+FfdOPSjtxO0ditRdIHNiY3O11Sl4jSuHd2YvrJd5B3xR7AKq86TONGSarl6K/yjC8Rd3
        y4o0xx9shO/Fw9pm2i9CtQTGcWkinmxEWcjIpFbHgMBKmMk5PV72idkg6omZcwd7RHK2ix
        aM80PAgvdFkgiKYGinuyvWjRmC1+sak=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id EG6yAydz22CzEAAALh3uQQ
        (envelope-from <mwilck@suse.com>); Tue, 29 Jun 2021 19:23:19 +0000
Message-ID: <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
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
Date:   Tue, 29 Jun 2021 21:23:18 +0200
In-Reply-To: <20210629125909.GB14372@lst.de>
References: <20210628095210.26249-1-mwilck@suse.com>
         <20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
         <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
         <20210629125909.GB14372@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Di, 2021-06-29 at 14:59 +0200, Christoph Hellwig wrote:
> On Mon, Jun 28, 2021 at 04:57:33PM +0200, Martin Wilck wrote:
> 
> > The sg_io-on-multipath code needs to answer the question "is this a
> > path or a target error?". Therefore it calls blk_path_error(),
> > which
> > requires obtaining a blk_status_t first. But that's not available
> > in
> > the sg_io code path. So how should I deal with this situation?
> 
> Not by exporting random crap from the SCSI code.

So, you'd prefer inlining scsi_result_to_blk_status()?

Thanks,
Martin


