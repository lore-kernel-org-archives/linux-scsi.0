Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF311C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 06:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B932D61077
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 06:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbhJMGdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238006AbhJMGdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 02:33:08 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1A7C061762
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 23:31:04 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 21so1090235plo.13
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 23:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IqFCee932yXff3g8S22IMIonv/32fuT5szLU0pggDNY=;
        b=a1xXRGShMNUcH1NESAktZXUgL3mFc7wQIYKmmv8/Y/ALepXHOWmmTvT8XSj6vOg/M+
         MbhM/ene3FaZLDFtmRSFfGBcWZN2IWLJwqUk7lw7SQibDKaQXujif5Kg826b1uwy92rp
         BE9pd9q6ethHDDGyjRig6Cy//vFmfRqzEgWkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IqFCee932yXff3g8S22IMIonv/32fuT5szLU0pggDNY=;
        b=RQlUg5QvtE3XruADpGwIfP7nPbtHGP2me4UZM7Tow24gcrVr9uskAkANntZFLRtdvZ
         j6sFakda/pmso69BDifhuxZwFGgVc2dbRNdonD65OFcx7C8FkiomtfjTUhTFUgDl4TjK
         isOl3JWSwLLBpNVeQeFg4ihgTcQ7kLb+8TRQj5toddBbaQdCaUbqMucQzrXEhgx0hTnm
         B1e/xtRU+mt4E8Tg7nK8gQqV+BG5/ULU9Jk66vHZriuBfyBi6pesYeEIHq1u/v6v8oKm
         CNl0mevesr3kIymoOEH3c4gavHNbr/5XNxemvdwdj4/BPnKkZWGDvDoURy+1Y0n8I2tC
         CgcQ==
X-Gm-Message-State: AOAM532BYjHGXIyOSEVrRaAoi/H+j5tr69Izo7GYVButk0JOJPJdcqF6
        BIUH6jFa1NtzvZuQ1GGI84dPFg==
X-Google-Smtp-Source: ABdhPJzPpkxK9ZnBKhTayH/eUQdncp8qkTzuStqH3wv1NooRt0u8SlJ26bmKBvTPalBAv9kwTDH0GQ==
X-Received: by 2002:a17:902:f683:b0:13f:a79:52de with SMTP id l3-20020a170902f68300b0013f0a7952demr32121054plg.43.1634106664061;
        Tue, 12 Oct 2021 23:31:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k6sm13945349pfg.18.2021.10.12.23.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:31:03 -0700 (PDT)
Date:   Tue, 12 Oct 2021 23:31:03 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 26/29] jfs: use sb_bdev_nr_blocks
Message-ID: <202110122331.C020EA7@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-27-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-27-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 13, 2021 at 07:10:39AM +0200, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
