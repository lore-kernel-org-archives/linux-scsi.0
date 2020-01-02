Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875B7C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BA3C21655
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="V/9rv6rC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgABMLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 07:11:06 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35890 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbgABMLF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 07:11:05 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so33950342iln.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jan 2020 04:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKkfWTZwvIBe+Q/V2IgxEh9fm2XSR+QDHIMa8KEvNlY=;
        b=V/9rv6rCM3IcQA++6EHZFpoN0l5Kew6YbEdlb5tQCobxmF+YlbAnp/ykIJt8d4ToA/
         AWR3ELvZdcRyPk/uvc2WaS0os75UvRpXVxQjAcXdMD6JJnMfCbi5fZcCKIzATQNi9i3s
         WF+6b7MDj+gjvP8/ybHG32KdrfGgNYSZmX3H9MUAHc81uogByWDThC0MUQVABC5xrKAr
         OAGOjlPWv8PA3jnKLPhe7l63NydHhtcMNR0lbYq1dlllxSbRvGh/KrrEXDxCC+kR94Rr
         3bYXRT6RBT17PiA05JrQJjHf6M8hmHw87N7OfuouAEzbKm5RrrpMyPy8Rg5mkPZEeaLj
         w+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKkfWTZwvIBe+Q/V2IgxEh9fm2XSR+QDHIMa8KEvNlY=;
        b=LCoMKX9/YjSA0DW4uceyP1BURbfYNGrCBhsO/fP8PQsSM5WRByrJiKccEjhe9Go+Yh
         LXpvrXL0lPEhUw3xMY6NbBj0B+/+qoNyZnhS9noCHegEQpegZFgoliRPETI9jx/wqDrJ
         939gW/CDP9VZjvBCanBi+cvGbpUiSvyWGbfIUxaLwTlQHJdXcr5vPr4GmWMEsGayeqMj
         XTQrIiCmwf0hYDRFVuAM+5ii6xdWTi2yMiqj2NQrde4kNk7UpdGvNk11Wd8XEHzHUJcg
         b2+r/EzL6xWEWUrK1brXGhXWmXn1L5cg0kWoWaCEni4IEuy6G4m87aqhgrjivyQtsg8q
         j6+g==
X-Gm-Message-State: APjAAAU2Y2NLUhp2gpcyBYWnSna0WeZk+O4T1BUHsFV/1SPkdTSSufb8
        gh695vaU2767UEem8txhRZzmbT78yPGvjb2JF1l6Wg==
X-Google-Smtp-Source: APXvYqx6tdcsyL1UmzTYbKZDlmZaPb2rSWq+t9ELgMVmKbMU7amfAGW3sUwXomCMg3khlSusUqgz2tfwtWdbxmz0zY0=
X-Received: by 2002:a92:d2:: with SMTP id 201mr72721689ila.22.1577967065203;
 Thu, 02 Jan 2020 04:11:05 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-8-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-8-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 2 Jan 2020 13:10:54 +0100
Message-ID: <CAMGffEng1=4KJbNheW4gX562FU+1qfh-HU_Qfm0R_Jw6OWrORA@mail.gmail.com>
Subject: Re: [PATCH 07/12] pm80xx : IOCTL functionality to get phy profile.
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
> From: Viswas G <Viswas.G@microchip.com>
>
> Added the ioctl functionality to collect phy status and phy error.

Please split it to 2 patches, one for phy status and one for phy error

Thanks
