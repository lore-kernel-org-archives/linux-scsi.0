Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C5CC3A5A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 10:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 698C9233A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 10:55:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NGLGGDx2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387922AbfHVKzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 06:55:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40639 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731683AbfHVKzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 06:55:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id c5so5085232wmb.5;
        Thu, 22 Aug 2019 03:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BPmd91qz3a0HiNpHiRZCkjVJHjiYHrK/cHq1mbQuN28=;
        b=NGLGGDx2k7Rpo9b+f1V5n7eDS3u1cwHKo2Yw+ouspmGBrABNAuqgInxox6hPBe0a/1
         AjcoAYxQzyR4kLDAV7rBLknwSRQRlxwlfOcAmkoXhtLZ6LUvVkVyDUOAHfKrZCkdeNuv
         XJC3Ln+DikWpIeAOuI21u/ah0gPPWtY6WoDjWasea2rg7WhkVO9MXfVHZn0OnemkdSgE
         ruodghO5w+EuuCpauZmfwzsxXbxZlTYJmzCizJs3Owy+5hPqVGzJuTMinT1mD2KRQjvS
         n4BiPVifEiOwN3ZktAaP7hMDzJv++6D/Rlfeoe9+vespmtHpGsfNi6K5eQFrK8Zdnffb
         FdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BPmd91qz3a0HiNpHiRZCkjVJHjiYHrK/cHq1mbQuN28=;
        b=IIAcnWwXslyke6a75z5AF5kEDwpvbJOUiOWVPIr6gzfJU0sv2RDn3BjnQWEFcaI3mm
         OyrPcs1a+8aRMJ2kv9aET1gMH1eYKQgTWSIy065cnqAsmpn5zz5Wd2m+zsKpAsDZeRBT
         oFI2sslkELS4wH+pjVxmbtfaJRPp66440aSeVafPEx4+FUcG+XPIxdK5moewJVcUSCIz
         AoKBTStruFOrfCiNeA5PESik1NJdtvOzrJAnjSFZZELqGCTjkKauX8385zVzBVb/02Fr
         yDZ/+8GaEFoe0wiYfJP425nLJNcMLgwg184GggY6SxWhq8jWGB6aXpRq+8T56anUt1QU
         g0bA==
X-Gm-Message-State: APjAAAW3fUTDqKsdcLIv5UGnEYw1dEPnZJZ68r62zy7kSMnJbzwvIxaO
        z2hlzE/BW1gJf45Jw2COk+bsHuSZnxLWdghUAtJYAgLg97GVIA==
X-Google-Smtp-Source: APXvYqz6nmeITqN8OHhPeu8R9sb4KwCAE+cTx1cn/MvjCN0ye+3jhjA33DhB4gGWP3VRTlj9WwKWXc1YcWgPEkbiMgA=
X-Received: by 2002:a1c:a615:: with SMTP id p21mr5540001wme.121.1566471344250;
 Thu, 22 Aug 2019 03:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <1566243316-113690-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1566243316-113690-1-git-send-email-longli@linuxonhyperv.com>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Thu, 22 Aug 2019 18:55:32 +0800
Message-ID: <CACVXFVOGdvMDSZTUNH3DrXErm1E4LKBjzCFpL3r815JFJbvM4A@mail.gmail.com>
Subject: Re: [PATCH] storvsc: setup 1:1 mapping between hardware queue and CPU queue
To:     longli@linuxonhyperv.com
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hyperv@vger.kernel.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 20, 2019 at 3:36 AM <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> storvsc doesn't use a dedicated hardware queue for a given CPU queue. When
> issuing I/O, it selects returning CPU (hardware queue) dynamically based on
> vmbus channel usage across all channels.
>
> This patch sets up a 1:1 mapping between hardware queue and CPU queue, thus
> avoiding unnecessary locking at upper layer when issuing I/O.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index b89269120a2d..26c16d40ec46 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1682,6 +1682,18 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>         return 0;
>  }
>
> +static int storvsc_map_queues(struct Scsi_Host *shost)
> +{
> +       unsigned int cpu;
> +       struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
> +
> +       for_each_possible_cpu(cpu) {
> +               qmap->mq_map[cpu] = cpu;
> +       }

Block layer provides the helper of blk_mq_map_queues(), so suggest you to use
the default cpu mapping, instead of inventing a new one.

thanks,
Ming Lei
