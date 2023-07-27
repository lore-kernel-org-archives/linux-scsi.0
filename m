Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20685C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 16:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjG0Q5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjG0Q47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 12:56:59 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22942696;
        Thu, 27 Jul 2023 09:56:54 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-785ccd731a7so15003539f.0;
        Thu, 27 Jul 2023 09:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690477014; x=1691081814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2TbDyUZsWzsObspTjv/7qDRWOVn/FC/GQiLADatzNto=;
        b=QVWXff1MHGFzKeu2yMSop5DgLF/mnGt7ujiUK+cK7qgU25t4z0pQLC3LLk1cBb9Fao
         ICDs5FS4uyyYYYSXZIj6AVAXLV8cXjT9xYUA0iwxzklJqzxG+4G8s8p2Y308gHg1u8vV
         nUMY3P3tHoHGmKuw7jAe4mVs5hOfFokPoIOjqkAucjNiC/q8j4P0R+26bksNpAN10G31
         aSH5whNcEwF+qzt9ECVIPo6MvqRhQExufVKQhNWHJr/y+xhMCdDUBYIU8KnOq9hyF9jV
         yPQk9EJS0SiO8Ja616+hmibeUeLXOfQfPl9hevhwxbjVGYM96ztaU59Xnz9m7zkEMEte
         GSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690477014; x=1691081814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2TbDyUZsWzsObspTjv/7qDRWOVn/FC/GQiLADatzNto=;
        b=ME5ywya4Ul4bcl95nLmbJhm970b6Y1CAeLtqmkmpl8pafkbDgobi6IlOsW5g+RUD91
         anWwoqiLO1bsbXFV0MyDFUyVw2MIPo5X9arRvuNYr/r78giN2R2CNwn1En25Xi8vtrN4
         bgc+1EWP9cqiA+aYioG4XOmtcNezIrq5gygi2vZGXHvX1z0WSrsb7dwPlKo8t23+pU3d
         n2lKvzRxl3z4XLpfhppJjVNufWXlPqQueaodHT6AahGE9+TY8vjY/KQJoze9meVPFvCN
         i885covzazORRYq9nITngDF+S2PlB8f6pzOOc0P3NrX8+DK4HeRTuAOTX5n4f2kjLOql
         OoAA==
X-Gm-Message-State: ABy/qLZIc3B0z5LX1S224SsrdrmHh782YA6T35u+zxZsglSPGIjZI9gQ
        xoiRaSufMn0KGAkzTVm+BREW2xTZHtL/OMRrbuY=
X-Google-Smtp-Source: APBJJlEoSCoL8q7efvULtSRO2w2U+hoIsFGnoOvtgrvlFGhkvFEEEYatzDufiBpbn8t4TXFCvNwzhUkmsGojgXJVZOw=
X-Received: by 2002:a05:6602:2d89:b0:780:d65c:d78f with SMTP id
 k9-20020a0566022d8900b00780d65cd78fmr90887iow.2.1690477014246; Thu, 27 Jul
 2023 09:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230726094027.535126-1-ming.lei@redhat.com> <20230726094027.535126-5-ming.lei@redhat.com>
 <CABPRKS-0GQqMRiGh6akOgk3BKpx5kqTd0QVhH4nPe=fUdi7DbQ@mail.gmail.com> <ZMHGLyg2bRY6S35i@ovpn-8-16.pek2.redhat.com>
In-Reply-To: <ZMHGLyg2bRY6S35i@ovpn-8-16.pek2.redhat.com>
From:   Justin Tee <justintee8345@gmail.com>
Date:   Thu, 27 Jul 2023 09:56:43 -0700
Message-ID: <CABPRKS-vnvOUOhZzc6yghKV4RjTTsZMQphR=TEs-S-OD5Ap29Q@mail.gmail.com>
Subject: Re: [PATCH V2 4/9] scsi: lpfc: use blk_mq_max_nr_hw_queues() to
 calculate io vectors
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 26, 2023 at 6:20=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
> Strictly speaking, the above change is better, but non-managed irq
> doesn't have such issue, that is why I just apply the change on managed
> irq branch.
>
>
> Thanks,
> Ming

Sure, thanks Ming.

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
