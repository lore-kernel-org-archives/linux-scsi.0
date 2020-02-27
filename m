Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3131AC11D3D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE75B24692
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="D6x4UpXi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgB0Rmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 12:42:32 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39383 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgB0Rmc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Feb 2020 12:42:32 -0500
Received: by mail-ot1-f65.google.com with SMTP id x97so1111472ota.6
        for <linux-scsi@vger.kernel.org>; Thu, 27 Feb 2020 09:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8JF0Sq9TMHlIj6nNGPj9/FTICwVPrKDQH8lBEonhthM=;
        b=D6x4UpXioiVO0N+8syCQO4IWLQ0DOzAGN3eg1ttY1abydTr/0KmEqEy959onG+4p7U
         rmx2PLJw8kA53G8M/Qwd3nwxKhDZ3vmNqWClIbzrAvG9VU/K7S/wJZr/E7uuc+KS10u9
         VYq79Fx0NuO3lPZ1PNl7byYEmS8EnR8DO3JmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8JF0Sq9TMHlIj6nNGPj9/FTICwVPrKDQH8lBEonhthM=;
        b=CSirlH1ySoFFYP2R4xc0QE65zgo35I3JyjYeskVnZzEEG3ysR+M4h1lVxrsegRkaLu
         k0yedM2MKb/04FHeUjXzf1bSfNnC93Y4ZegGEdaCxWDRPfBT7FpEGP54hCJZHg3f5H82
         a3oWAoSYJYW0Q0E59aPlXHukSt1Wk5N3SHXQqM15jXszkgpqMx/dmBKke27Auy9UYaAX
         lQRCv6uiTQK4pqcbxDr7Dp+RaQ1yDNvfiFO3BEaDVZOHrAPUVQn+YB3fGuW6gytR8m5+
         G6OtFb7oTIgdmq4nW7cxveNa39jfRxHKHSB+DGanvdEPsvmepm3sBVaWyr3fNEgOAvAE
         DkWw==
X-Gm-Message-State: APjAAAUdWfPI02JVodBa3TgZhn1nqoHK6nwo7xr7Loe33yIcVCNSjZ9w
        ng1KF8J+stH62ba9HOV8xRhifIPzs5r9rJFtqxme9Mzj
X-Google-Smtp-Source: APXvYqzqLX38/qvLkJRfk1Ki+0Q2fbb8+HyF/v+JJcj2/U+7pt2xZdLk5ouvolOdu36/R5M/0OYQ7BCGn7YZLCBpmVg=
X-Received: by 2002:a9d:6b12:: with SMTP id g18mr22027otp.211.1582825351442;
 Thu, 27 Feb 2020 09:42:31 -0800 (PST)
MIME-Version: 1.0
References: <49751508-48b0-eab4-a371-1b9eded12a19@yandex.ru>
In-Reply-To: <49751508-48b0-eab4-a371-1b9eded12a19@yandex.ru>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Thu, 27 Feb 2020 23:12:07 +0530
Message-ID: <CAL2rwxpw+bPg24O4V71dqpyW3aCsOYEGycm0=skBgg8pyBzncQ@mail.gmail.com>
Subject: Re: Linux / mpt3sas support for PCI 1000:0014 (weird device?)
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     MPT-FusionLinux.pdl@broadcom.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 27, 2020 at 6:45 PM Dmitry Antipov <dmantipov@yandex.ru> wrote:
>
> Hello,
Hi Dmitry,
>
> my Debian 9.12 system with 4.9-based kernel reports the following device:
>
> # lspci | grep -i sas
> 04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID Tri-Mode SAS3516 (rev 01)
>
> # lspci -n | grep '04:00.0'
> 04:00.0 0104: 1000:0014 (rev 01)
>
> but 0014 is not listed in drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h among the supported device ids.
>
> Any ideas on who 1000:0014 is really are, and should it be supported by mpt3sas?
1000:0014 is LSI/Broadcom MegaRAID controller and supported by
megaraid_sas driver (drivers/scsi/megaraid).

Thanks,
Sumit
>
> Dmitry
