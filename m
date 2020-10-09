Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CA7C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 06:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB19C206CA
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 06:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xSFb4vWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbgJIGhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 02:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730219AbgJIGhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 02:37:08 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD50C0613D2
        for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2020 23:37:07 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q9so9023962iow.6
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2020 23:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cyazkbg4cgt8IejFCULFJenu7SF6ihBhQ80CX59pV/o=;
        b=xSFb4vWp8/+d1P1HcF1vshlK5OgdZ1wUf3ZuYvdcVQVmFzwLwqm5nflTqoiNtlL+uO
         vbNquE/29I0pmibSdcmO/n1Q0HU40otvP0qy++k7qkk+gQvetc+yOSjqoTQ4hSsCFKQ2
         ZK2Fgj/QO74YedQcVszHCwQ9WSjtxs8Gx9QHqJA89Vu5/xSW4FpLANTlNbZW8Oap9Sy9
         kmLknaOJIkmrNxLPT86C2u1Z0bRzFZwzGtFoB0Lygzi9E7ok2kNnTI593E5GHTMNsVBB
         epUpiV+K5U/znZfR4mLF6hD/t5iuXOuGT9WH0YKCx6h4jpY5PQKgdxTAoy6cHH1Xbm5S
         Z6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cyazkbg4cgt8IejFCULFJenu7SF6ihBhQ80CX59pV/o=;
        b=nG2koO0rYxu/PwHTeDT6L8Ip/9laeUM4TeJJes3J8678FQiTDr8jUB6aEhdHrbQlt0
         xM1cvZu3/WjX0HO/G4IY1gQ0x0cnA4YQfucEhvl9Dg5iZSd+EetmcIKtT+1O7qjHMHOI
         P8vZRigtdzavQZv6ix6VBxm8z5UY77HOZCB9dzIHIY8/LVy4R8l3jMV95oebqnjjN66X
         W/OJ8SWY5RKg9mRlE6SrwkXvkl24FwN8zjmeUW8oTHFJ7GFI6Y7FUCwvYfbJ3QPV8Nyh
         raYuO3VRRULT2jzA8f3xs6mPbnpthyWqLoEBxWm+KZLj5pLkE9NC6lkynfXBJkRek+UQ
         J4Cw==
X-Gm-Message-State: AOAM530+TY1MgWYlwAJTamL+d0ASfASXeVnmnl5M0VDlGn4w7Pjm2IwB
        kDzaIM9wGfb/P05c+39DrYyitGA9VZVDQPfpC37vlTrVtnBA2JE9
X-Google-Smtp-Source: ABdhPJz0tiQf1PcNiHmO4uVyWVepu8036QBujcTF/OoYl7ITANEWOUhtlTL2KzmUynD5wHoBKNRgucuxlpFLtrlq8Pw=
X-Received: by 2002:a6b:b208:: with SMTP id b8mr8587125iof.36.1602225426995;
 Thu, 08 Oct 2020 23:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201008200611.1818099-1-hch@lst.de> <20201008200611.1818099-2-hch@lst.de>
In-Reply-To: <20201008200611.1818099-2-hch@lst.de>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 9 Oct 2020 12:06:55 +0530
Message-ID: <CA+G9fYvSfmoOG3zhs11bUhXrAt5w7RsxNnMadQiQmPm+rz=oUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] sr: initialize ->cmd_len
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Qian Cai <cai@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 9 Oct 2020 at 01:36, Christoph Hellwig <hch@lst.de> wrote:
>
> Ensure the command length is properly set.  Previously the command code
> tried to find this out using the command opcode.

The reported problem [1] is fixed by applying this set of two patches on top
of linux next 20201008 tag kernel and tested on arm64, arm and x86_64
and i386 devices and qemu.

Here is the two patches applied on linux next 20201008 tag
[PATCH 1/2] sr: initialize ->cmd_len[PATCH 1/2] sr: initialize ->cmd_len
[PATCH 2/2] scsi: set sc_data_direction to DMA_NONE for no-transfer commands


- Boot test PASS
- mkfs -t ext4 /dev/sda1 test PASS

>
> Fixes: 2ceda20f0a99 ("scsi: core: Move command size detection out of the fast path")
> Reported-by: Qian Cai <cai@redhat.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

> ---
>  drivers/scsi/sr.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index b74dfd8dc1165e..c20b4391837898 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -503,6 +503,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
>         SCpnt->transfersize = cd->device->sector_size;
>         SCpnt->underflow = this_count << 9;
>         SCpnt->allowed = MAX_RETRIES;
> +       SCpnt->cmd_len = 10;
>
>         /*
>          * This indicates that the command is ready from our end to be queued.
> --
> 2.28.0
>


[1] https://lore.kernel.org/linux-block/yq1zh4w1mrq.fsf@ca-mkp.ca.oracle.com/T/#m4fe8f4ccc1f54d93740f310ce80230a92929e94b
