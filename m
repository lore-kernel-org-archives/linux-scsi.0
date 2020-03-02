Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87191C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 11:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9E220842
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 11:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MzowjnZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgCBLSD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 06:18:03 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43884 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgCBLSC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2020 06:18:02 -0500
Received: by mail-ot1-f65.google.com with SMTP id j5so8398301otn.10
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2020 03:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUk/IcSq8isOQh3Dir06sBX4NifyxtSSnOiot2Pcrwo=;
        b=MzowjnZqKgSYI/D4tUZ8JS5zL/yAGWQ99RfLULxgEoZR2WN2NxUjTpAI+01rplDo4O
         aGwWWHuitJ0zf8Yg6KTYHPpprphEV2oaFZ+1a5BBpnZ/OW+c7yIfdefc27FDJeW3uLTr
         f0WNDMednzAH8SlWEVLjj4I3uczhYshXNq3n8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUk/IcSq8isOQh3Dir06sBX4NifyxtSSnOiot2Pcrwo=;
        b=ELdWaqjiKcp52wY+BQmUT6ZWpZef8NF9tnHB32wy3F/D6STPWX5t/XZCDpTJ2INMzn
         SYxaNCLo5LPsSuBXBMMqZ1NxkJ3uvwcz6WruHlrB73uxppmKJ9HOeRdmD+7BDy7LKgqL
         VE7E2N4dxxmKUbhSNgtj8jwogmlaM0imvDpFcnEiq0oXJ9DAD7IkGLoMSzz51GvHlwwG
         omAzxA64CdM/u4q39OG4rqTcp0fORDTpCUzfpxtxR3w5V1fcdCNpE9Q+FVGV8M3ZUokn
         2WE9RnD5f6Z2XPLtpfGC6USbQGwwXOcl2E4nlAtMuK8YZ569DM9lggcYmWpUrlr+o/7x
         AlWQ==
X-Gm-Message-State: ANhLgQ0bn5hEQBbxyY3f6pUjSCQUJQkxh55SWKpOPFU86Pfy8zZ8LuYZ
        wTTp2B0t6mBpUKxJkb2LNeUmDydyTUQyiExSm6JlBR1p
X-Google-Smtp-Source: ADFU+vs01Gab6MpBdyaYFxeTkKv23C5wYiqPX5KOyP+7DgLd3U2/MndyE8jfEdjx5H6034I9b7GuzgLVA9aKUKwaLzU=
X-Received: by 2002:a05:6830:2157:: with SMTP id r23mr5482405otd.98.1583147881881;
 Mon, 02 Mar 2020 03:18:01 -0800 (PST)
MIME-Version: 1.0
References: <49751508-48b0-eab4-a371-1b9eded12a19@yandex.ru>
 <CAL2rwxpw+bPg24O4V71dqpyW3aCsOYEGycm0=skBgg8pyBzncQ@mail.gmail.com> <483f502a-f8c6-79a7-86ba-6e544731b6b3@yandex.ru>
In-Reply-To: <483f502a-f8c6-79a7-86ba-6e544731b6b3@yandex.ru>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Mon, 2 Mar 2020 16:47:35 +0530
Message-ID: <CAL2rwxrOPZXXvOq2Rw1Yakvy_igxJaGNKLeGanP9ZHnTrwQ72A@mail.gmail.com>
Subject: Re: Linux / mpt3sas support for PCI 1000:0014 (weird device?)
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     MPT-FusionLinux.pdl@broadcom.com,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 28, 2020 at 2:14 PM Dmitry Antipov <dmantipov@yandex.ru> wrote:
>
> On 2/27/20 8:42 PM, Sumit Saxena wrote:
>
> > 1000:0014 is LSI/Broadcom MegaRAID controller and supported by
> > megaraid_sas driver (drivers/scsi/megaraid).
>
> Thanks. But lsiutil isn't expected to work with megaraid_sas, right?
Yes, "lsiutil" will not work with megaraid_sas. You may need to use "storcli"
application to manage megaraid_sas adapters. You can download "storcli"
from Broadcom website.

Thanks,
Sumit
>
> Dmitry
