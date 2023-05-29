Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4342CC77B7A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 16:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjE2Qh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 12:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjE2QhZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 12:37:25 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACCC1BD;
        Mon, 29 May 2023 09:36:49 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-565eb83efe4so24202567b3.0;
        Mon, 29 May 2023 09:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378184; x=1687970184;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XGlmlfpGRhYW8HjfyI5EG9tKXwTbZGzHl2Gw/X6ax14=;
        b=gD4kPaLLf9pJV0lpw2cIWttEo9EVBn7x8f+92LW12OXCCFANe21Fg01PjDXO0UtxY2
         Ub5I5H1SdDWAoWmUFNeFLAYHmxDq8YTSmOaqguooZLFZobRrzvTxGbtaD72knDH23eOR
         MY6ARUPzlKzmyW1m+BBJysdYOhoJdDqFYBuSUXe+0EMClHkTcg4RjJwjoiWhoOTKM3Dt
         9K997gDZQsyxazGzIDcLguDZimyccw5IT7vyORCRBHtiqJDhUH/qSIl0d7GezyQg513/
         VW7HwcNry8jcfbS5LOs9BUzeIfyV4CP5ISfkACbfC7ABZjMV3VQHFd1Zf4JXCiU+XtDx
         EW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378184; x=1687970184;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XGlmlfpGRhYW8HjfyI5EG9tKXwTbZGzHl2Gw/X6ax14=;
        b=GsNNlAKbeXflSyaAa6v79IOGVeQxbnXU1jT7PQgFL7HfCIJLIn0ORbsSofuQ+8WE4X
         TUHtFu1vAFklN4LpJvxI2XwOF7lKxOrICDBk9tSqql2w69jZu+NN7c8X1w5f0RyvZdJd
         pdcWa3h4ppCrAtpuEilCU1rbR665Yj3UKjvcfOZzqjuabu62r32VXzBqP5ZJbSIQbEMH
         SFI4ZR2/NATus1f38WMMzSNzSfa31jmqF6MyxYHQN6FOXDaRX5xwQ3Xda+x/ns2ic8g+
         lmKB2qR7LT5ZBI0rBzqOAb0ghe7n14LwyuQy4Bn/ZGQykhlAwaKRMXmXd/ypSxqkDKtI
         hbbA==
X-Gm-Message-State: AC+VfDxdASf+QV70XbJiWXTY1CpTM1L1BdwawKGia5e+249t5YtYodcX
        b7D03l4EtXIVz6TuMUlQt5pPrCAMZd/eD6Bf9D8=
X-Google-Smtp-Source: ACHHUZ7InCRLGF330bSJ+LMuRh4g/NfzTfd2m8OEywQty5+b+eU+JLZRKLHh0ktsR3qbMPwu4QSHwqAz7Ha/ifAXWSw=
X-Received: by 2002:a0d:d88b:0:b0:565:bb04:53fa with SMTP id
 a133-20020a0dd88b000000b00565bb0453famr11663162ywe.10.1685378184319; Mon, 29
 May 2023 09:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230522104146.2856-1-nj.shetty@samsung.com> <CGME20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8@epcas5p2.samsung.com>
 <20230522104146.2856-3-nj.shetty@samsung.com> <20230524154049.GD11607@frogsfrogsfrogs>
In-Reply-To: <20230524154049.GD11607@frogsfrogsfrogs>
From:   Nitesh Shetty <nitheshshetty@gmail.com>
Date:   Mon, 29 May 2023 22:06:13 +0530
Message-ID: <CAOSviJ2-=U+Y2vFOq6=8n=uHqXgoud3=7gaH7H7sw2jiPXtNPA@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v11 2/9] block: Add copy offload support infrastructure
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Nitesh Shetty <nj.shetty@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <james.smart@broadcom.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        gost.dev@samsung.com, anuj20.g@samsung.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        ming.lei@redhat.com, James.Bottomley@hansenpartnership.com,
        linux-fsdevel@vger.kernel.org, dlemoal@kernel.org,
        joshi.k@samsung.com, bvanassche@acm.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +/*
> > + * @bdev_in: source block device
> > + * @pos_in:  source offset
> > + * @bdev_out:        destination block device
> > + * @pos_out: destination offset
> > + * @len:     length in bytes to be copied
> > + * @endio:   endio function to be called on completion of copy operation,
> > + *           for synchronous operation this should be NULL
> > + * @private: endio function will be called with this private data, should be
> > + *           NULL, if operation is synchronous in nature
> > + * @gfp_mask:   memory allocation flags (for bio_alloc)
> > + *
> > + * Returns the length of bytes copied or error if encountered
> > + *
> > + * Description:
> > + *   Copy source offset from source block device to destination block
> > + *   device. Max total length of copy is limited to MAX_COPY_TOTAL_LENGTH
> > + */
> > +int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
>
> I'd have thought you'd return ssize_t here.  If the two block devices
> are loopmounted xfs files, we can certainly reflink "copy" more than 2GB
> at a time.
>
> --D
>

Sure we will add this to make API future proof, but at present we do have
a limit for copy. COPY_MAX_BYTES(=128MB) at present. This limit is based
on our internal testing, we have plans to increase/remove with this
limit in future phases.

Thank you,
Nitesh Shetty
