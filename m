Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7571EC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 15:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiGFPiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiGFPhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 11:37:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBDD27CED;
        Wed,  6 Jul 2022 08:34:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E9CC21FDC5;
        Wed,  6 Jul 2022 15:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657121664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99CJJVFpdXwZKjA8J/WZPHQwZBw2iYXjy5+4OpppZOM=;
        b=CzzbxJMzsUpdpgAbuCBHoZFy6NhaP8LgTnNIdWOz30kkPvcZC2AOf3FsFWguO9/kg8USZp
        XwEu6tOtZ/lB7/LaeLRb56supqWPeWH5AD5Zvjlua9KW9O0unAsr5sGhX3k1ZlySUb1U7O
        K0Y8X1EFlwHiNxtciwq6FPczLieS3Uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657121664;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99CJJVFpdXwZKjA8J/WZPHQwZBw2iYXjy5+4OpppZOM=;
        b=TLxnGJ6mBD6i03pQ24Gv+P/kGoeyoLC8ZGRnkL1DfndU11FVErsRTtASa0Djpg7UcCZZ26
        V989lFefUhJljcBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7298713A7D;
        Wed,  6 Jul 2022 15:34:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KZ3oGICrxWKkYwAAMHmgww
        (envelope-from <iluceno@suse.de>); Wed, 06 Jul 2022 15:34:24 +0000
Date:   Wed, 6 Jul 2022 17:37:36 +0200
From:   Ismael Luceno <iluceno@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 4/5] nvme: quiesce namespace queue in parallel
Message-ID: <20220706173736.2891776c@pirotess>
In-Reply-To: <Yp9avMfGDsOLIXeG@T590>
References: <20211130073752.3005936-1-ming.lei@redhat.com>
        <20220607132118.0bbb230b@pirotess>
        <Yp9avMfGDsOLIXeG@T590>
Organization: SUSE
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Jun 2022 22:03:40 +0800
Ming Lei <ming.lei@redhat.com> wrote:
> On Tue, Jun 07, 2022 at 01:21:18PM +0200, Ismael Luceno wrote:
> > Hi Ming,
> > 
> > Has this patch been dropped/abandoned?
> 
> Hi Ismael,
> 
> The whole patchset wasn't be accepted if I remember correctly, but
> finally we moved srcu out of hctx in another patchset.
> 
> If you think the patch of 'nvme: quiesce namespace queue in parallel'
> is useful, please provide a bit info about your case, then we may
> figure out similar patch if it is necessary.

Chao Leng's outgoing email (lengchao@huawei.com) permission is
restricted; I got from him (through a couple of indirections):
> Hi, Ismael and Ming, The case: When the multipathing software is used,
> if one path failed, fail over to other good path may take long time.
> This is important for scenarios that require low latency and high
> reliability, such as real-time deals.
>
> This patch can fix the bug.

Same thing he said here:
https://lore.kernel.org/linux-nvme/cc732195-c053-9ce4-e1a7-e7f6dcf762ac@huawei.com/

Huawei is still looking for a solution to be merged in mainline.

-- 
Ismael Luceno
SUSE L3 Support
