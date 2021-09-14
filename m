Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B8EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD12861108
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhINJcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 05:32:20 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39772 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhINJcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 05:32:19 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 58102220C5;
        Tue, 14 Sep 2021 09:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631611861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kleTtUGI4frcW5XKf0ZIxvfz5xt9nURnbuxlPNVmvo8=;
        b=U8edeJvigDZ7TzGBT0NYlq3AjoOqHVGf2/YmKc0MLoNVSlgJcXAaZoHRjNcWWqIPYNVONw
        /JhjDKQRMxwfjeaCeC0oXgdYQkpdac7eC/FLUVucT5Tb+PES1hK4Z/MaSn1cAYoVZViCHq
        EwPXnO6aILYNy6N5FPLJ/EjhPBoa3Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631611861;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kleTtUGI4frcW5XKf0ZIxvfz5xt9nURnbuxlPNVmvo8=;
        b=/re32NDJ9OT94bTHYyMIOKeUALOy97/QRCnJ8AKRq4UpdGrLY+jV4SVKfiLs5AaJ8PAykk
        jCRn9TPlR/f4f5CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 45B5B13E55;
        Tue, 14 Sep 2021 09:31:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YDtxEdVrQGH5RQAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 14 Sep 2021 09:31:01 +0000
Date:   Tue, 14 Sep 2021 11:31:00 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Message-ID: <20210914093100.oeunl6q3kp4f34ab@carbon>
References: <20210823125649.16061-1-njavali@marvell.com>
 <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
 <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
 <YSRrmOmrwm5olk0D@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSRrmOmrwm5olk0D@T590>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 11:46:32AM +0800, Ming Lei wrote:
> OK, got it. Even though without this patchset, nvme-fc actually relies
> on managed irq since qla2xxx driver uses pci_alloc_irq_vectors_affinity.
> 
> Now the patchset[1] isn't good for addressing the issue in
> blk_mq_alloc_request_hctx().
> 
> [1] https://lore.kernel.org/linux-block/YR7demOSG6MKFVAF@T590/T/#t

Ming, do you have any ideas/suggestions how to address it? I can work
on it.
