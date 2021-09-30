Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14602C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E835C619E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350712AbhI3MNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:13:02 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:38721 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbhI3MMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 08:12:54 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MJV9M-1mGZsM01wu-00Jpnq; Thu, 30 Sep 2021 14:11:10 +0200
Received: by mail-wr1-f42.google.com with SMTP id s21so9658408wra.7;
        Thu, 30 Sep 2021 05:11:09 -0700 (PDT)
X-Gm-Message-State: AOAM532TGwusiQ2Z4WAoYi6SJvHu8HnoiPailz+PYI3kf0P/z7EdO9p6
        OsSA7x8aXZvNInNTgVY6gxTKcgdh7AulzdmNogo=
X-Google-Smtp-Source: ABdhPJw43i720iDwtKJKHQKfEZ1hwEj3ybgHUNR9mn1jgOZ1bnBaDlFWx7CsSfID1K4RyoqfawGZVxIOtD3Oo3WKfDs=
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr5677913wrs.71.1633003869682;
 Thu, 30 Sep 2021 05:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <1633002717-79765-1-git-send-email-john.garry@huawei.com>
In-Reply-To: <1633002717-79765-1-git-send-email-john.garry@huawei.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 Sep 2021 14:10:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1ytv5okZZhdGYfecLkO+WPQESdDibtu5io5+nB6jygqQ@mail.gmail.com>
Message-ID: <CAK8P3a1ytv5okZZhdGYfecLkO+WPQESdDibtu5io5+nB6jygqQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: acornscsi: Remove scsi_cmd_to_tag() reference
To:     John Garry <john.garry@huawei.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:dx4v/FEUBXbun64vOPb1jkhFc6WgjzXJuZgXl8rs4DCmwlG6Ww8
 w1aUvnn3qrkEiQs3DvsKF4uFbxlnX2GWXUwfBU6KDYM1DstyTW6xsZPCJFjDuZ9DC/8xl+/
 ciFbw9BPLwCdWOxVnPGoTWTh9Ofga3XjmXv4hZIWhqY/64GXkEVoqCcTxA4Viu3IyObzVCV
 UeElWERBG7OESdD36MNNw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fkuZlr8H0sY=:5Qs3lLtVL0XEgp/8fN8978
 qpA9U+OsOls61YQwSN+tAxWCySRFkkVU9AKfZarTTkn+pcfzYj2SfRy/Zwcu/pQCnsZL2GOUC
 GtyG5Oj9cN/UQDKg3RBS04dCjX12MbxpXZxoEFRjkaQB6og1XMc7cpuvtU7gzgxI6eomDD0Va
 lV6YwFBbEjJwCpBsvEcBIsRT6Cs7An+8KsHK4ZQvWHWq+J4hgEbTXwNyInfbMXeu5r035TMl0
 PNvadWsUOsNRP/ZQsD/6h8z97FrLit04VGhqPyoDDoHjo3nl89y8Mtl5iBAsfBFoVlZgCC5h7
 WtmZh6NvvGFs3GA/P5ZEHG+EyBXu/JrUh+QtJj4jRnmg+APy+ckmvriDuy437WuZtdEV8ZBZ6
 0as/2cjNjN6oZ+B9lUtpJGBtXkDrKpGEVnwHQBhIgoHIOCznS+/RUCAvRQrJXJMod55uRUHzg
 ZMBCdyokvBS+X78cG5zw9OYAYvetayFl42h/FyNj+y5w5DSyF/QxBDI90g6P6yLkvE4HLd+dH
 gEGRrFFYvb+YFUi1lg0LV1pt+USPbz+YIzN/pZH9rA9sN+IMmCvvtEb23d0VVHdsxDtx0oo/s
 MgnJz+iNYhcFghnXeO7H45iRgS57cs/s7mFgiduN2CCSxVjyHGmT/e1WfIHaVPkZW4OFWhdpA
 M9wL4nJiA+wYK7msCfMAF9tTzTOtqDWzWuyEZK5Vkc9UxSqhv/19zxEIYlfpITelhpPOJwECa
 ERPImGO/EA+dlMbX/BJreC7kJ+hHdBr3AcYAqw==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 1:51 PM John Garry <john.garry@huawei.com> wrote:
>
> Commit 756fb6a895afb ("scsi: acornscsi: Remove tagged queuing vestiges")
> mistakenly introduced a reference to function scsi_cmd_to_tag(). This
> function does not exist as it was removed from an earlier series version
> when I upstreamed the named commit - originally authored By Hannes - but
> this reference still remained.
>
> Fix by replacing the reference to scsi_cmd_to_tag() with
> scsi_cmd_to_rq(scsi_scmd)->tag, which scsi_cmd_to_tag() was a wrapper for.
>
> Fixes: 756fb6a895afb ("scsi: acornscsi: Remove tagged queuing vestiges")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: John Garry <john.garry@huawei.com>

Thanks, that fixes the build regression and looks sensible.

Tested-by: Arnd Bergmann <arnd@arndb.de>
