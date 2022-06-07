Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF13C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 11:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbiFGLVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 07:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243022AbiFGLVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 07:21:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC43DDB3;
        Tue,  7 Jun 2022 04:21:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8454F1F95B;
        Tue,  7 Jun 2022 11:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654600868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=FGOr6ZW+LuXWdIrxm6Lg7LwccqxRSi7+KGesQzK/UH4=;
        b=eUp730d3QK+N5oF2PUdNw3HUfrgQTrk6ZGXGMxNhgRQXJLrOkdO/IEC/E4NpnGJIKZl7XQ
        ZOODC6TGKg34qas5YGJJ8G8yuWStwAtO9K1B337k5aHDpCKRIJVb4OahZjBPFByfBIQswU
        nIsjEUJFfPj+UhTTaR5bQo64oTpvfKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654600868;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=FGOr6ZW+LuXWdIrxm6Lg7LwccqxRSi7+KGesQzK/UH4=;
        b=KiAMCoAjjaLSXvSefzY96F182jXwGpZvbBtq7cKkScktHsonp92lN4thTquRnbAAlaQfTX
        r4DwpJHkFU0Hk9BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A2FD13638;
        Tue,  7 Jun 2022 11:21:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RaNdO6M0n2IRaAAAMHmgww
        (envelope-from <iluceno@suse.de>); Tue, 07 Jun 2022 11:21:07 +0000
Date:   Tue, 7 Jun 2022 13:21:18 +0200
From:   Ismael Luceno <iluceno@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 4/5] nvme: quiesce namespace queue in parallel
Message-ID: <20220607132118.0bbb230b@pirotess>
In-Reply-To: <20211130073752.3005936-1-ming.lei@redhat.com>
Organization: SUSE
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

Has this patch been dropped/abandoned?

On Tue, 30 Nov 2021 15:37:51 +0800
Ming Lei <ming.lei@redhat.com> wrote:
> Chao Leng reported that in case of lots of namespaces, it may take
> quite a while for nvme_stop_queues() to quiesce all namespace queues.
>
> Improve nvme_stop_queues() by running quiesce in parallel, and just
> wait once if global quiesce wait is allowed.
>
> Link:
> https://lore.kernel.org/linux-block/cc732195-c053-9ce4-e1a7-e7f6dcf762ac@huawei.com/
> Reported-by: Chao Leng <lengchao@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
<...>
