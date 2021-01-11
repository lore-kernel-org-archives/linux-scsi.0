Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E1CC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 11:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C2D224F9
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 11:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbhAKL6j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 06:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729411AbhAKL6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 06:58:39 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13C8C061795
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 03:57:58 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lt17so24368907ejb.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 03:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3a/SOwrE/x7Mq5AUuCGgo7i/Ivq/zLoasPchczS3M28=;
        b=Cmc+HjMnVzrq6oOxdAKbM4c8V4K6hquq83tInn6NRIcboLbWsL1uRsj5KmvQ9bo8BP
         RTIjYdBy17ttiEfD8LaSkV86q2Jx847myJQJgaoEll0b4IbCUThHFxQDcxe0fD/RntyD
         5RuE6/PI5YzJiuuFF7+l7iBvASL+v5eycw4d+4DQ2SLcphVbBdR+K41xCQvfiisVJrVJ
         XPJuVMRppkDdlI0cqHjr27ZycGQ4KnooSqwAB6XQvo4o727OiikKGftqwxuClvJoeYhm
         mhvF1oGg/pA7e+psl2d/ddMOrW7HS20IyKWxozxvm+k053hInp3zQ7cIL2/kh57HTB+b
         X9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3a/SOwrE/x7Mq5AUuCGgo7i/Ivq/zLoasPchczS3M28=;
        b=XZhO2364NpNbGpeMXY9qiHK/WE38mofu6UCxXK9YYgSNO/JRBom7USlKjysaM/84Jb
         cQtGdz1N70vJCifFaBhNn41Ne4/8glFvdss2qDbSA0Imzaq+N2XOPXmKqIGIVHtz0MU4
         zmSAT8NwXbNLMGmExUYobgXzUMaQh7AwiTWXBJzXCTL3T5vcBR2KJdHBibYahyv6iKbe
         0M7pmCddlkgpHDwEZ8DdtofipgDdos8TuaDYy+NxRwFbACzGY4txT1t6xsiheVtn+aVs
         DzDZ7SGswFDEOvrbnNFjh9ICO2iEornQVB9nduV2+PfjD+rrOb2C9Hec7qFavTg/Nhhe
         9vFw==
X-Gm-Message-State: AOAM53284+uH9SlhzJKaAaTttTzhmdXy9gZQblKuzZb5LEM91h4EKqtc
        gbtkBX5D6cclmCYfQGvXFJffemqIrQ0nuhEALtET6g==
X-Google-Smtp-Source: ABdhPJzjvAJyhnPGJa6/jwakn6sEHqZYlszuq0LdKrFo/l1fgIZiR9I/yK/OjdKd8zNBmRNaD+K4zQCwTITj23VRYqk=
X-Received: by 2002:a17:906:94ca:: with SMTP id d10mr10062461ejy.62.1610366277600;
 Mon, 11 Jan 2021 03:57:57 -0800 (PST)
MIME-Version: 1.0
References: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
In-Reply-To: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 11 Jan 2021 12:57:46 +0100
Message-ID: <CAMGffEmJwH26VJm+Pr8FA5Dk0HxZstcuj+3S_5zK+RM9SahU0w@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
To:     John Garry <john.garry@huawei.com>,
        Viswas G <Viswas.G@microchip.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        akshatzen@google.com, Ruksar.devadi@microchip.com,
        Radha Ramachandran <radha@google.com>, bjashnani@google.com,
        vishakhavc@google.com, Ashokkumar.N@microchip.com,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>, ming.lei@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,


On Tue, Jan 5, 2021 at 12:21 PM John Garry <john.garry@huawei.com> wrote:
>
> In commit 05c6c029a44d ("scsi: pm80xx: Increase number of supported
> queues"), support for 80xx chip was improved by enabling multiple HW
> queues.
>
> In this, like other SCSI MQ HBA drivers, the HW queues were not exposed
> to upper layer, and instead the driver managed the queues internally.
>
> However, this management duplicates blk-mq code. In addition, the HW queue
> management is sub-optimal for a system where the number of CPUs exceeds
> the HW queues - this is because queues are selected in a round-robin
> fashion, when it would be better to make adjacent CPUs submit on the same
> queue. And finally, the affinity of the completion queue interrupts is not
> set to mirror the cpu<->HQ queue mapping, which is suboptimal.
>
> As such, for when MSIX is supported, expose HW queues to upper layer. Flag
> PCI_IRQ_AFFINITY is set for allocating the MSIX vectors to automatically
> assign affinity for the completion queue interrupts.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
>
> ---
> I sent as an RFC/RFT as I have no HW to test. In addition, since HW queue
> #0 is used always for internal commands (like in send_task_abort()), if
> all CPUs associated with HW queue #0 are offlined, the interrupt for that
> queue will be shutdown, and no CPUs would be available to service any
> internal commands completion. To solve that, we need [0] merged first and
> switch over to use the new API. But we can still test performance in the
> meantime.
>
> I assume someone else is making the change to use the request tag for IO
> tag management.
>
> [0] https://lore.kernel.org/linux-scsi/47ba045e-a490-198b-1744-529f97192d3b@suse.de/
Thanks for the patch, maybe Viswas can help to test?

Regards!
