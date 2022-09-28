Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CFAC04A95
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 13:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiI1Nz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiI1Nzv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 09:55:51 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324AF40547;
        Wed, 28 Sep 2022 06:55:49 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id p89so4684467uap.12;
        Wed, 28 Sep 2022 06:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=y4CRwJTCmV2dgd++IDqduezpwxwZIxQ6/WfR9v6lDDo=;
        b=U07gc71CMClhBjWhvOD3AT4pWZWDLqu1fCzni0cYkPNGKyArVQrAniK1jZ/xuLdBbm
         qzz4pVoUbjcQBEemuomaq6c8HSbvaiGWghG8n8CzZXwxPOrHfRVsEIuxA2Go4GsMt0N/
         uP1YwbGuPtFzhejseu+PbqZ1yCiRbvDGgZ67P9aNptnQNucdn+aaJ5cf0PnSg+0NM4Nw
         +ahXAxIY0fmHOCrsFlCdEQpdTZiqjiBmexd8f3S/5G++93R0AR60UDzUn6TKeZ5dQ/tc
         enRJtndELbhz/7asmC7nkF/zFzYnizyZelgD9ZztB2jKsbxp9osT6Zk4WDlczzOLA2e/
         YZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=y4CRwJTCmV2dgd++IDqduezpwxwZIxQ6/WfR9v6lDDo=;
        b=Te24SKUF6t42TDkrA9y0b5yf0YBBqbwXXku99Z13drnLBhxsPgvoVlmpf3gf3XjjDM
         BRgH15unm3lQ45V17u2AlFOVHTR8ZOkrNKC6UogJHo1en4jCPihatUJeQwjJPtTIZyQW
         n6sFO0MLydqOmT02mveuxKx2cXo9q4Hnp4Go83H7Nl744RwRLgRcyRe4+sChOh5o7h0d
         k9D/3YVi2wZSwa/c8ouU3nAvknunc56JpsE9v/0T89k2duTxj6B022d4uYhfWp9KeJM5
         k3JB9HSEcOGhygqqqbdJNyhXzKPxgji4lTNddPnF7P2T7aXg4JUWPVb+YTOVnG5WhQpw
         Wzpg==
X-Gm-Message-State: ACrzQf0H33YTKCCkQxTtX8gMEkChrKIiNwtb3mEWbye2L2R7HGnW+W52
        gmGfZbVup/xdMSeknstvhJrtIvD0PJS4/5xUdg==
X-Google-Smtp-Source: AMsMyM4j1OKkxAs1lqcZaiS1oPGxF9Yq2Hs4nWWihhfCK/srKXciqdLJOTvPxtuRjxOy9b+AEBYnopME2Xf/dc1kbIk=
X-Received: by 2002:ab0:3c93:0:b0:3c0:b089:1081 with SMTP id
 a19-20020ab03c93000000b003c0b0891081mr16558499uax.9.1664373348779; Wed, 28
 Sep 2022 06:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220927014420.71141-1-axboe@kernel.dk> <20220927014420.71141-6-axboe@kernel.dk>
In-Reply-To: <20220927014420.71141-6-axboe@kernel.dk>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Wed, 28 Sep 2022 19:25:11 +0530
Message-ID: <CACzX3AtYRa6avG5Gf8jgE4Mz1PdeSCri=Q+PvetR3dOOgbS7OA@mail.gmail.com>
Subject: Re: [PATCH 5/5] nvme: enable batched completions of passthrough IO
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, Stefan Roesch <shr@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 27, 2022 at 7:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Now that the normal passthrough end_io path doesn't need the request
> anymore, we can kill the explicit blk_mq_free_request() and just pass
> back RQ_END_IO_FREE instead. This enables the batched completion from
> freeing batches of requests at the time.
>
> This brings passthrough IO performance at least on par with bdev based
> O_DIRECT with io_uring. With this and batche allocations, peak performance
> goes from 110M IOPS to 122M IOPS. For IRQ based, passthrough is now also
> about 10% faster than previously, going from ~61M to ~67M IOPS.
>
> Co-developed-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/nvme/host/ioctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index 9e356a6c96c2..d9633f426690 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -423,8 +423,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
>         else
>                 io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
>
> -       blk_mq_free_request(req);
> -       return RQ_END_IO_NONE;
> +       return RQ_END_IO_FREE;
>  }
>
>  static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
> --
> 2.35.1
>
Looks good to me.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

--
Anuj Gupta
