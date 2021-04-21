Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA6AC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 10:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C350D61427
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 10:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhDUKTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 06:19:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:59764 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239206AbhDUKTe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 06:19:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619000341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTn9QSknfZfEjonwhcp903U2RKsbPI3o1K1harhdpro=;
        b=Rl/zuusu5EjVDs/wl3+Sivh8vRzrHxj44onCBWyJv8A4BHXBb/S8+hGnnlkpQXwrtaAyBe
        4QW5fUeROr36/WPnrSVmDkwjs5vO9vYY3gDtN6H3mMNg6jS0WfiKlauxHeCfdn/1eUcEu4
        WwK2Y5NI/Grn2NdyZuWCVk4qqo13myI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 34F99AEE6;
        Wed, 21 Apr 2021 10:19:01 +0000 (UTC)
Message-ID: <fce30dfdee0eed3959358d4b8b826ecc20f5f7bd.camel@suse.com>
Subject: Re: [PATCH 0/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk
 scsi commands
From:   Martin Wilck <mwilck@suse.com>
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc:     Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>,
        Daniel Wagner <dwagner@suse.de>
Date:   Wed, 21 Apr 2021 12:19:00 +0200
In-Reply-To: <20210421075543.1919826-1-ming.lei@redhat.com>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-21 at 15:55 +0800, Ming Lei wrote:
> Hello Guys,
> 
> fnic uses the following way to walk scsi commands in failure handling,
> which is obvious wrong, because caller of scsi_host_find_tag has to
> guarantee that the tag is active.
> 
>         for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
>                                 ...
>                 sc = scsi_host_find_tag(fnic->lport->host, tag);
>                                 ...
>                 }
> 
> Fix the issue by using blk_mq_tagset_busy_iter() to walk
> request/scsi_command.

How does this relate to Hannes' previous patch?
https://marc.info/?l=linux-scsi&m=161400059528859&w=2

Regards
Martin


