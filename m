Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5581CC33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 21:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F68D24670
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 21:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579037051;
	bh=aGWleahYjUMp+oq+LHbLyk7aqRexeZp1Q7zVEa2V+PU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gGwyl6QFrlM0U9DErkCJn5hbW0gEbsopiAjnObhwW18d8TEj4XEhvxJ/0o74kdeBS
	 iQSGXjLkXAhbSijbJOpSUKeISRQOYEpGi5YmZSYz5ePIhQbwEjuo/co14zyUpZb/JR
	 EHrx6WJRjCACoiN4a4p9HRdDxwjcC+BZ+3g0TGzY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgANVYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANVYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 16:24:10 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F26E24656;
        Tue, 14 Jan 2020 21:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579037049;
        bh=aGWleahYjUMp+oq+LHbLyk7aqRexeZp1Q7zVEa2V+PU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BddM2F3HQyL+zyp/NCjh1ksC6Ks5xnobKc3HJiLEelHGXS6fRmiu4+TrQ9D+KxPuF
         ZxeMIbNC3YS5xU6MMKLUcIphzYNSt4c/BtgZcpe7ofl5xTZo2G2aQ73b2M3jzYsOUm
         lIACnPmJWBtg1/i5ywycEKS6N0GXbFf6eFtXjDJM=
Date:   Tue, 14 Jan 2020 13:24:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 2/9] block: Add encryption context to struct bio
Message-ID: <20200114212407.GF41220@gmail.com>
References: <20191218145136.172774-1-satyat@google.com>
 <20191218145136.172774-3-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218145136.172774-3-satyat@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 06:51:29AM -0800, Satya Tangirala wrote:
> +static inline void bio_crypt_set_ctx(struct bio *bio,
> +				     const struct blk_crypto_key *key,
> +				     u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
> +				     gfp_t gfp_mask)
> +{
> +	struct bio_crypt_ctx *bc = bio_crypt_alloc_ctx(gfp_mask);
> +
> +	bc->bc_key = key;
> +	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
> +	bc->bc_ksm = NULL;
> +	bc->bc_keyslot = -1;
> +
> +	bio->bi_crypt_context = bc;
> +}

The 'dun' argument should be const.

- Eric
