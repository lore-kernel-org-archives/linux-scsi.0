Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A889C33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B4C208C4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ZcL60Nsw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgAFQaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:30:16 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46364 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgAFQaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 11:30:16 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so49220373ioi.13
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2020 08:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHGh57EX7CzpL9/6ui997i6oyhV6V12Dl3+hy3ot/xo=;
        b=ZcL60NswZya265VAy7RVF2WdNvpWUY1LPb8RaQu38j+i/dsAjv9D4YqXR5jE0Msr9l
         ME3V52XL9HX759ojLTJyMbm5xsELwW3vE5CEcGqzz7kbv7c3fHatMu/BeYOISQFvWmQE
         7ctSQjAjLmUtXydmoHGP0qwY1E7TjYJbjbEeOxmg0oRVTzcfy991MOe26YmLI4vTzKY/
         sPmyVzldI7iFKMaKnfB8asOpH8maQ7/Hx30Ld7W+ODA72DRfILwUNJVU57zz+kw+Na3c
         jAAuGKhOD844L97pg99OkbZMOB6by9XOARHinWaOcCx8Y5sN0WFJn7axN41pKgXfV33e
         MelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHGh57EX7CzpL9/6ui997i6oyhV6V12Dl3+hy3ot/xo=;
        b=Ebjx/PWiN6230ulg5xrpSI9ZxMEzJgN1vSqoOehhM2gXdr2LbnYG6TSfwnApGnuxLQ
         FBwofTtNdFglRK3/2KpebrAA5QZOWukcN+LXII5ZemGXwEcT2CVoJUqaV9PKVbIBlc46
         dQ5j8LbYnDJP7nSAocLQFhhqD0nSgFGN6bojsMDmuMP9AAa1UPsXWtS6uOdIbbI7Yx0g
         TfYxTYICpF6LEV2XuySfBttpmHmnFz3LSRQU/bB1mN5yl3Rtu60U+NpXi2ZIcBC+MUOT
         cH5Z3TVI3dWjGv439EGZcCXs2KXazYqpPzj7j9H2a9dGZdd319xPuQIyUH3DoRa/VD+l
         setQ==
X-Gm-Message-State: APjAAAWqYVqjzZMf1DG8lWr7ZMn25GajWcOaJQaHuIEDYFzIWJGl7GMB
        lLh33t1diyGfqTNQ12lrFRpWD8b11Rkr96EVUxo1lg==
X-Google-Smtp-Source: APXvYqyQ4pz7mNmnDgNNJQUlOfKXj7ilzjD3JCK60b2PjyoVxIo61RWYMo8HpZxdFTdsmIATPWhdU50yv+S9M6/myHI=
X-Received: by 2002:a05:6602:25d3:: with SMTP id d19mr57859454iop.217.1578328215347;
 Mon, 06 Jan 2020 08:30:15 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-10-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-10-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 6 Jan 2020 17:30:04 +0100
Message-ID: <CAMGffEkgMObCoNYRQiUhRZveDNRS7JHhjJVVZ+AtVOPYXi7JAg@mail.gmail.com>
Subject: Re: [PATCH 09/12] pm80xx : IOCTL functionality for SGPIO.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added the IOCTL functionality for SGPIO.
>
Please extends your commit message, what's the use case, please fix
the warnings Nathan reported.

Thanks
