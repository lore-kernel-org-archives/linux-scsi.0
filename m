Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A719C54EE9
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 13:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiI1NYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbiI1NYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 09:24:04 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7BDA1D04;
        Wed, 28 Sep 2022 06:24:03 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id p4so12659592vsa.9;
        Wed, 28 Sep 2022 06:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=M84FFzTMi9h6oICE7y6YgmOmaedFbJztaEjMgsP60GA=;
        b=UQq3nN3gztbrniSqexDrn4v7PkItW7CpPH/KcfuYAUD26dpvM6A+Z1ppytRi9QJU0h
         SibNAUP3E5PUR0VD6A8+2jFi4423oDZEAOFCtrSDMAef7fvfR/dQUGQqgwK97vv69/+S
         03CeucNoQ6I2JlzDRTVoX5DD2n3plcFbnIY9YYBTOSVfsXS3eqI0t+ZZffTWaMrrBOwE
         rIlnK2bsPqtsj+/cBEJtft7eEaYssu86yFAeBDzcSKKK04SPYynDvy68ynAhFS8TjSxW
         XXmEx8dRxbnSyxtAdqp3PSrlsQtT3pQDiln4s3FZY8k5Wfx0CLF8Qo5A6kezx6P6Wba1
         NmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=M84FFzTMi9h6oICE7y6YgmOmaedFbJztaEjMgsP60GA=;
        b=VeT3lEAPzGDREQcYp8gvUvmHIafq+iXnNjwv4e+uvjsatPewMxjidnAtQM1Zl/3P1i
         wGcjJ3LSFESc3bWpukuCEPcncIvI70Y7lEfNsdamyedvb/EP9BYC0OnzIaEFmbOYJCla
         2aXiTlRbNbWYKMyuHhS4o2Hxlb28RmYHkyYZH1RviEgTHEIcVLe5IlIhpdxZjzl+S/kh
         tVV7yyrko5SkLjB2I24sUA77A2hp3t7PGfAQbWPoP3/DDr2OOyY79kFN/iJLIrywKQCl
         FkDlhdw8U2z96qfPNEZKNJ3k196TlxNyw5gt8/4wbja5CJGl5zbhPcuJQvDj2CB7fqY1
         imzQ==
X-Gm-Message-State: ACrzQf1jyvDpOVGY+GUQmQuC21CXYWa0BXA0XB4zRDBojNY44HNWMBkl
        M6Uz2+2hZq3Zcq0s1O00swjPIAKIN9vmTXWYMg==
X-Google-Smtp-Source: AMsMyM6/5w8wyMAkWnRZyW1kzS8Or+a2Mjp2kGlSOJEyaCX+PfkjFmwnO3J6PHWhJ61G1pDVoEEBVAv1tBoX1pc+Ov4=
X-Received: by 2002:a05:6102:21db:b0:398:28b9:5c0c with SMTP id
 r27-20020a05610221db00b0039828b95c0cmr13561532vsg.56.1664371442093; Wed, 28
 Sep 2022 06:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220927014420.71141-1-axboe@kernel.dk>
In-Reply-To: <20220927014420.71141-1-axboe@kernel.dk>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Wed, 28 Sep 2022 18:53:25 +0530
Message-ID: <CACzX3AumYMDVPwvRYpMi6vvcPTzR0W0bUT1-545HvArpH+7Uwg@mail.gmail.com>
Subject: Re: [PATCHSET v2 0/5] Enable alloc caching and batched freeing for passthrough
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 27, 2022 at 7:14 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Hi,
>
> The passthrough IO path currently doesn't do any request allocation
> batching like we do for normal IO. Wire this up through the usual
> blk_mq_alloc_request() allocation helper.
>
> Similarly, we don't currently supported batched completions for
> passthrough IO. Allow the request->end_io() handler to return back
> whether or not it retains ownership of the request. By default all
> handlers are converted to returning RQ_END_IO_NONE, which retains
> the existing behavior. But with that in place, we can tweak the
> nvme uring_cmd end_io handler to pass back ownership, and hence enable
> completion batching for passthrough requests as well.
>
> This is good for a 10% improvement for passthrough performance. For
> a non-drive limited test case, passthrough IO is now more efficient
> than the regular bdev O_DIRECT path.
>
> Changes since v1:
> - Remove spurious semicolon
> - Cleanup struct nvme_uring_cmd_pdu handling
>
> --
> Jens Axboe
>
>
I see an improvement of ~12% (2.34 to 2.63 MIOPS) with polling enabled and
an improvement of ~4% (1.84 to 1.92 MIOPS) with polling disabled using the
t/io_uring utility (in fio) in my setup with this patch series!

--
Anuj Gupta
