Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C95DC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A97611C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241775AbhJOQ4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 12:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241778AbhJOQ4K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 12:56:10 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94199C061778
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 09:54:02 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g184so9110154pgc.6
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 09:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+MbYp/9I6HwSPkAmORgtqKp7aAXKpROAHsI0KkahVSk=;
        b=ikEdVtNf9eRQss1RELdYd+gQGtRkJJNUyxABmsyhavxmXS/GWW1GmjaIFqcZC+V7d0
         jxPVuirO3PDa+xeNqLrVJO8s8KcCPrKVcuz5mnU+QJTWjswUytrClmIjf52ECv87VZwj
         IWYURypnyInULxZ6QO8cmc8sNxz7IQsLEMu78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+MbYp/9I6HwSPkAmORgtqKp7aAXKpROAHsI0KkahVSk=;
        b=f3v0p7CkKAdhn7UQ9LKpmP5qVnxm+5ynCaFr4wY8DWxwl/TixdpAjYj1qVJqHfyyJX
         h5IYNCMgr8ULAUeQaz5OGTL/1k1n0rPQiudw2Vo9+wl60kL/m+YRDbt5V1gDIqNzlQ/U
         LdgAoYh/KQW3n/ADukCo5sO0K3m97Gtg/Na+WerQ9ntvT/zLv+Ntgw8F9BagWC/XeQ0O
         fdHqoAzO3Jk8ShkdZDaxoh2Tr8vx7P0SGFSu+AjRHhEPQnc4RpBGdra3tBsHS/7Cckr5
         5eIvYeLjn4RRz/Ej3D8SYY5glR5wnYKjwMkx4gu+amoOL99M04RKn76UwUwHBwAD43mx
         3ozw==
X-Gm-Message-State: AOAM531zXOUt7BG37lvwaZEM6iDN+JwiT24qjuFeioSWzbAgHjVkXpxy
        q1EQbtBW2sn0SDuJLPMl8RFT+g==
X-Google-Smtp-Source: ABdhPJxRzD0WBfqSsRnsWWctoiC4ZL/68Vbzs2wYW5pL6AgqTKpTz7zCXFAYZWzBRrc637AgBAl43A==
X-Received: by 2002:a63:7f0e:: with SMTP id a14mr3656783pgd.390.1634316842164;
        Fri, 15 Oct 2021 09:54:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b8sm5387267pfi.103.2021.10.15.09.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:54:01 -0700 (PDT)
Date:   Fri, 15 Oct 2021 09:54:01 -0700
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
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ntfs3@lists.linux.dev, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 18/30] nfs/blocklayout: use bdev_nr_bytes instead of open
 coding it
Message-ID: <202110150953.4A7CC49DC@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-19-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:31PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
