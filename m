Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928ADC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 21:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7000C61056
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 21:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbhINVyL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 17:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234724AbhINVyL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 17:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415C660EE9;
        Tue, 14 Sep 2021 21:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631656373;
        bh=MT0QDti90yAUW615dduHxzBWKFdzxixlvP0VmxYG+5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXraGuY7oG56gKqqdzSNSN3Rh0Lt6tRcGPwELw0zzas5jF5Xrf5szv4PXaxJako62
         eQXB4Xcq/kPUj4EWko8qH/DLG88oiFAFaSwQ9eVxZUq9u+4Ee6y5Lewy6w8h19z4uM
         C1fMGEThU6YwoOmavENq+bBie2AOTrPkzHZvTyak/vhLRJrMLrjDsZ5nKomMKTQFje
         FF/I30F9Qwjk62agNyhx5B9JhFURRgTyMHZt57J9bviYMv2P/BRa4vH4qTQs3z3E+A
         pMFJLS360rM/tMjPfSF9x0jR+t80FcgbKH6X9GgOgEmGOLlHU/oWI5vgq3R2y8QD70
         7FU+US8N4T8IQ==
Date:   Tue, 14 Sep 2021 14:52:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [PATCH 4/5] blk-crypto: rename blk_keyslot_manager to
 blk_crypto_profile
Message-ID: <YUEZs5/9Ao2/KhDw@sol.localdomain>
References: <20210913013135.102404-1-ebiggers@kernel.org>
 <20210913013135.102404-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913013135.102404-5-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Sep 12, 2021 at 06:31:34PM -0700, Eric Biggers wrote:
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index 69a12177dfb62..db656d12050f7 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -411,7 +411,7 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
>  #ifdef CONFIG_BLK_INLINE_ENCRYPTION
>  	if (disk->queue->ksm) {
>  		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
> -		blk_ksm_unregister(disk->queue);
> +		blk_crypto_unregister(disk->queue);
>  	}
>  #endif
>  }

Note, there is a build error here when CONFIG_BLK_DEV_INTEGRITY=y, so I'll have
to send a new version even if there are no other comments.

- Eric
