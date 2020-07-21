Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AA5C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 07:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5519E208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 07:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Mcp0tozY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgGUHRO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 03:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGUHRN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 03:17:13 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CC4C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 00:17:13 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d18so14519722edv.6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 00:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7/dOJc5jmerEnRXXZczoRYQXPneTN15Czk31dj7mf2s=;
        b=Mcp0tozYMsh+7pk58qBAUDvcd8CIa2EJM9XAfDdzx9X+jHGViWSb5j1DtC7QN2yyUw
         jFUm5VKVyWc8vehY2ODp13ntGcOI04vSbGfcJUJMdgxyB7+olT57MwDA3KReu6CNBWrF
         Veql+fs6icgCiNiBTKEAYJCmtIeX43lq68BjDoO14+HibWRjL9xkPKlv4cehiTa7Osq/
         BWuyVy3koeswI0iZHIyATFseTQDF4NYjWXjFfTjd0t9fTArFFqN6kmB74thkVm4EN9Bq
         uHiS7GRkG90nFKslwHsuaJos+I5YSzTBGpBmOJOCqFZAybAuytU8A/M43Q0oEycvpxe9
         tBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7/dOJc5jmerEnRXXZczoRYQXPneTN15Czk31dj7mf2s=;
        b=LOx9LsgDjlp+zHFgNVtyKuuRtBOcIUNcDd2XJis1z5Yo+aDcOFRUI1mUVOwLT/ntTG
         QFD2zJ5Yko17ESTk/eA+9ORIc4gFikSwUnPWGD2G8ysCUmOIUsblZe0Powkl47mne7rp
         d8NoZ+n3ENV2lfXX89l8mW0tZ19OvAoyV0T23PbtxJXhrvzr82pjDpFw6ob42llQPGAz
         NdohIDBg8lJb6qUrr1N07CIP2zYkVpCDKKQNk1TDrocGIU5RaQNyNRwq5rKL1S6n2YQi
         SX2Nin6e8j8OWU1q+cb2A/lgfyL0bk7drxkAQucyV/JM++P2K3Wzkp+zX8umhjGRx+F6
         6SPA==
X-Gm-Message-State: AOAM530n+91YumLXpR0+4Px3pPqeg4Y2aLHBS6JrLJec44I6QT6fBbXB
        RlyNFkMsRNYHNKOd+/XoVGGWLs7oiaOINL2ot/vgoA==
X-Google-Smtp-Source: ABdhPJykzWJXeYkLBJIy2mEurYXxK6H4tALei1c3q0y/Graa0QI490UH6FmgNqdsL3ONWEh76yU2vpKPjDAtceKYqcw=
X-Received: by 2002:a05:6402:176e:: with SMTP id da14mr25060809edb.262.1595315831988;
 Tue, 21 Jul 2020 00:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200720135303.6948-1-deepak.ukey@microchip.com> <20200720135303.6948-2-deepak.ukey@microchip.com>
In-Reply-To: <20200720135303.6948-2-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 21 Jul 2020 09:17:01 +0200
Message-ID: <CAMGffE=Aw-0u43HQoc6nN4xRDdrkgt0Cj6cynKsQRX7LFHgGYQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] pm80xx : Support for get phy profile functionality.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jinpu Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Deepak,
On Mon, Jul 20, 2020 at 3:43 PM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> Added the support to get the phy profile which gives information
> about the phy states, port and errors on phy.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
please check and fix the sparse warnings reported by test robot.

Thanks
