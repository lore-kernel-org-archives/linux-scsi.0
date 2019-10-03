Return-Path: <SRS0=749Z=X4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9AFC32792
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 16:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1B3420830
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 16:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cmd.nu header.i=@cmd.nu header.b="E/ch69Pj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404801AbfJCQiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 12:38:19 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:35039 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404794AbfJCQiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 12:38:18 -0400
Received: by mail-ed1-f54.google.com with SMTP id v8so3151309eds.2
        for <linux-scsi@vger.kernel.org>; Thu, 03 Oct 2019 09:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmd.nu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYbIUJQw8sMG43GSbAMepmkPrzPSQsWqqsS4PagbXNI=;
        b=E/ch69PjCszOhkW7dUzevAAcYhEu4285Q0K5LqOpDxijeGcj3vfCBW849T9c1FtD9z
         GU0q0ACkY3Ij6RZkpnE3N6gDY1CgX6KVDG97k8U9kH/TT7e1kUutDTdP7IIpU7BOQK56
         ZUwxZ40gyI0jWIxPo949aqbDR8naKmi/FrDqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYbIUJQw8sMG43GSbAMepmkPrzPSQsWqqsS4PagbXNI=;
        b=Jf0g/jQf5styFhFa8nc89fxujsIogk7G1xJQWRzIN4ejQb/xzjpFHhLru1pXr8H/Lb
         5pPOF+Am6z3FD8vyl2ReteG46qsqwQbz6r+cCyav6JpQv/OY2vmX+XgXFGHEBPcXUB8D
         wrBtLL+oqVvXMGMIBw0yQFGo0UNUEsYqopyB/ewSXwwE/apTFEIdImefAYnt7DmfRowI
         MLWCz869EXiYbDHu729Ptv8ye6jaFgIXEi0eTK6JMiMszz5k2Kfb4FXR8CsYoFsH73Dk
         VqUzJc1XsaS7iwJjyCSuUgBoWZoX0lT5zKdS7y3UjqIRPum5LoBGWh+iOJyjSMdrBWln
         JDAg==
X-Gm-Message-State: APjAAAXxrXS7FulREUpQvH5A/pe7ViKwp6OOt5+l46d/z3jEugS0fgY9
        3Y3JUY0Jw3AEPrBTPkrCZcPgjQ/Pjpdh5QCCd1tkFcFmjxynHw==
X-Google-Smtp-Source: APXvYqyu8riM9FE4pcW9nfEzZAJv3LJwtDJRbfs+aYtxNRBa6KLZcAE/AaPUbX2oqw/uSPxjhtxo9FQBZ0Zj8hMdSQ4=
X-Received: by 2002:a50:f09d:: with SMTP id v29mr10373312edl.4.1570120696589;
 Thu, 03 Oct 2019 09:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <CADiuDASOCJbnwLs-LEp0aCX+T4dMvFfKQv_zsypHW-iSF8wW=Q@mail.gmail.com>
 <5c5609d8-e4b4-3561-ece9-93746fd46206@acm.org> <69308786-81d8-a9df-2d7b-df37c3f93026@suse.de>
 <CADiuDATRN_85Tu3uw1WBtY=m8KrqKV5zpYrsggYdAOH23dwU=Q@mail.gmail.com>
 <9612602b-29c0-04d7-b76e-5593d0936eba@suse.de> <CADiuDARPit+kKtQe-UGktUuxEXRMvoq7PGVPKo9DrLRkSTwNAA@mail.gmail.com>
 <17f0639d-bd44-c193-af29-df539be722fe@suse.de> <CADiuDASfjq=xyuTEF2VZtb+dV78_VdMRkfFrr4ujs0zPXjv7Ew@mail.gmail.com>
In-Reply-To: <CADiuDASfjq=xyuTEF2VZtb+dV78_VdMRkfFrr4ujs0zPXjv7Ew@mail.gmail.com>
From:   Christian Svensson <christian@cmd.nu>
Date:   Thu, 3 Oct 2019 18:38:04 +0200
Message-ID: <CADiuDASkpY_2HD4rfc2hxDOQPkbxKpgVv1EeSS60ZZhwqag_2w@mail.gmail.com>
Subject: Re: [Open-FCoE] FICON target support
To:     Hannes Reinecke <hare@suse.de>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        fcoe-devel@open-fcoe.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

An update if you're curious about this. I found that DE5-Net FPGA
cards are reasonably priced right now on eBay, so I started a project
to implement FICON target support. You can find more information on
github: https://github.com/bluecmd/fejkon

Essentially it's a 4x SFP+ port card for $300-$400 that I will export
as "fc0-3" netdev's using ARPHRD_FCFABRIC type.
This allows libpcap to capture raw FC directly on the netdev. The
devices will be fully TX/RX capable.

FICON and normal FCP will be implemented in userspace by reading /
writing packets straight to the netdev.
I assume this will be CPU intensive but for my purposes it should be
fine. Maybe it is a good solution for people that want a more modern
Fibre Channel analyzer as well.

Regards,
Christian
