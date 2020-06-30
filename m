Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EBFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 03:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1943206A5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 03:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vx1hrdTo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgF3DcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 23:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729037AbgF3DcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 23:32:09 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E109CC061755;
        Mon, 29 Jun 2020 20:32:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so18581644wrw.12;
        Mon, 29 Jun 2020 20:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TYX9fWWYxc3NtQf6c1BiLPg4Xa2kcKSBAxmy39/nMi0=;
        b=Vx1hrdTou8GBP5cH9Qk8Yg41ImlQsua559dcHHD1XFdwrfonuvDuKal95+IWgxY556
         ESoIG/n7q9PhJuU5EXMuDhIcmPRRL6wnW4gTP1J5ljvtyx7LGbOUwQJh6Wgkbzv9fwho
         ferm6BbkAgQdPNjZF1cpvwRBf0wWN8hiVssct4aSArZHv9FF/gC3RZ3LM0mNKjoqucxK
         Jt5gB73pwLHU3xqfI/JLulX8C74Hziwzfv4Dd/pYx+GAxvEv51cEIufOqBq7AWcXRo0n
         xq94Mk9Nisy9RY1iH1OQKKrXPvkWJ+LtN+T4inkvYwpAyg5fWqrciuqFT7pdS3ldxsXU
         s2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TYX9fWWYxc3NtQf6c1BiLPg4Xa2kcKSBAxmy39/nMi0=;
        b=BDxCgZcFE+5nzjkiojpxGTuFnthsl6lcRAi78ORKPcK/EMCDKntPKdfYE37F4hPgB4
         cq/3bkAzcuKPqJHueUJfLH3W9ScXCrI3X0aSNiIq161NW4yhFGpzy3JhQ9S8OrKVOlWn
         x70/fSB0oXr05y/ctArLfpr3G7Vae6ZjO+btZx8uCVH1sDBC/g1TVUMDO2LX5YxO51Tp
         K2Z8WYokG0c8GViaYjy6XHke4C+nzT0Vh3oSa9k/botVChEWq+OHF0UhdWz6VoufUQv1
         9tFZRwAuPWxyt62195zirsCxpFiMTOXzjmobl4szfDX0fy/hGpq7HOj6wkhpzSJLvQTy
         vSow==
X-Gm-Message-State: AOAM5337vaNfC6k9gwGkF6jPu9sHxk9jqfBeezeD2VGKYTpv/pO4fGvS
        xdWKrv884ecJx31/9Xdya4qJ3MmSpYXn3GBfZdKNeu4S
X-Google-Smtp-Source: ABdhPJx7/HrwGyHbOivp0IOfLdGP20PJe4xs2riYe0Ai5imYypVM/HQuAYJLidAQ3YcvsVbLs/AN0VUtaG/voX3FftU=
X-Received: by 2002:adf:ef89:: with SMTP id d9mr21037920wro.124.1593487927011;
 Mon, 29 Jun 2020 20:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623204234.GA16156@khazad-dum.debian.net>
In-Reply-To: <20200623204234.GA16156@khazad-dum.debian.net>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Tue, 30 Jun 2020 11:31:55 +0800
Message-ID: <CACVXFVNdC1U-gXdMr-B6i0WJdiYF+JvBcF3MkhFApEw_ZPx7pA@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
To:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 24, 2020 at 5:01 AM Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
>
> On Thu, 18 Jun 2020, Damien Le Moal wrote:
> > Are you experiencing data loss or corruption ? If yes, since a clean reboot or
> > shutdown issues a synchronize cache to all devices, a corruption would mean that
> > your SSD is probably not correctly processing flush cache commands.
>
> Cache flushes do not matter that much when SSDs and sudden power cuts
> are involved.  Power cuts at the wrong time harm the FLASH itself, it is
> not about still-in-flight data.
>
> Keep in mind that SSDs do a _lot_ of background writing, and power cuts

What is the __lot__ of SSD's BG writing? GC?

> during a FLASH write or erase can cause from weakened cells, to much
> larger damage.  It is possible to harden the chip or the design against
> this, but it is *expensive*.  And even if warded off by hardening and no
> FLASH damage happens, an erase/program cycle must be done on the whole
> erase block to clean up the incomplete program cycle.

It should have been SSD's(including FW) responsibility to avoid data loss when
the SSD is doing its own BG writing, because power cut can happen any time
from SSD's viewpoint.

>
> Due to this background activity, an unexpected power cut could damage
> data *anywhere* in an SSD: it could hit some filesystem area that was
> being scrubbed in background by the SSD, or internal SSD metadata.
>
> So, you want that SSD to know it must be quiescent-for-poweroff for
> *real* before you allow the system to do anything that could power it
> off.
>
> And, as I have found out the hard way years ago, you also want to give
> the SSD enough *extra* time to actually quiesce, even if it claims to be
> already prepared for poweroff [1].
>
> When you do not follow these rules, well, excellent datacenter-class
> SSDs have super-capacitor power banks that actually work.  Most SSDs do
> not, although they hopefully came a long way and hopefully modern SSDs
> are not as easily to brick as they were reported to be three or four
> years ago.

I remember that DC SSDs often don't support BG GC.


Thanks,
Ming Lei
