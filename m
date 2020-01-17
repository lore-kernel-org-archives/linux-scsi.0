Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B1DC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BFB82072B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="VLP9bNgG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgAQO0W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 09:26:22 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37565 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgAQO0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 09:26:22 -0500
Received: by mail-il1-f193.google.com with SMTP id t8so21436374iln.4
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 06:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CzsXK9jvJtwMqtiFKxaFDZohCZV2xLKfK0nNS/b0wx8=;
        b=VLP9bNgGUAjRPiPrv/coifJUFgfspSVk5G7WvvJQ65IMDvkCo/XDrcq9af4fCkInAd
         SSOaZf4C3LL1NxlpoA5IQ9N6GPYseo5VZfVxB6Y7XtuvMZC4qJ411FFXRYNsEQUkkQ+J
         6CIuIERFL6Etf5yYpYbxU9Z804IY3F5wPtsB/+2iK6XLE54xDKldVkljLxQh4wAYnndm
         pBto51KaaNMdKoDL4jFB7kv8Qbajp6hP9w+XYvs5toWJMtO5z/q7OJv+dqyZvNqg6hZI
         RdUIEmDgRFkuxbHFRqEthGZK2C09utzPc3XJoEgw06fzVrLzF8E24I7eKMWQJeZ96Vm9
         BwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CzsXK9jvJtwMqtiFKxaFDZohCZV2xLKfK0nNS/b0wx8=;
        b=WqPG7Pxvx+ZsYxT1qegy83FDVxnuQZKPwm9ct5blGt7FgqSJdpf4I9WrEAp/sGMirw
         lXFZ2u6ormf/f9iFdBqu5kq2QKOdMl5dTDLXPbJqSz24CvYeoyxoIzhJiIVCnaHanWuw
         7d+qCDXFk25FUoftfPdkqwc8U/q0DwfBQ4TvTaeRNAIRxYdlyCyS62sAsmqLaYvZMYUo
         TY3HxOsSgCHJYadUAJP6ZSjiksbDKqawHfjpl9g9RebeB0qQe7htCotyeu4O9Ka/nPD6
         Vg+bnosBJz0K8db7HR40+YNNDluP+QESToLLWGV/EfZmgqNeOKCLTD2MpYtWmzQjDgjh
         RuYQ==
X-Gm-Message-State: APjAAAVglz3Lvdx32AHwsxdtu6wXkphcsqdOtLcpk6HOpjVP+ncCBheI
        jTF4r6Mkvc8YWwRMZFCkRWUl1DBaq2xoX3lQw7+fNk/RGZg=
X-Google-Smtp-Source: APXvYqy8EQ2SdJSWI+0eAhSYjqpDqGAUCRep8XPr0fMPV5W/hMfjDl5d67lE6/3yOFkMHLVR0R+D/1vlO/HnHNP+ReQ=
X-Received: by 2002:a92:8d88:: with SMTP id w8mr3179896ill.71.1579271181334;
 Fri, 17 Jan 2020 06:26:21 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com> <20200117071923.7445-12-deepak.ukey@microchip.com>
In-Reply-To: <20200117071923.7445-12-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 17 Jan 2020 15:26:10 +0100
Message-ID: <CAMGffEmB-enhTZRVAcDOFdjjt8q4v3jifKqjgufVLpdtM+n18Q@mail.gmail.com>
Subject: Re: [PATCH V2 11/13] pm80xx : sysfs attribute for non fatal dump.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 8:10 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added the sysfs attribute for non fatal log so that management utility
> can get the non fatal dump from driver. The non-fatal error is an error
> condition or abnormal behavior detected by the host, or detected and
> reported by the controller to the host.The non-fatal error does not stop
> the controller firmware and enables it to still respond to host requests.
> A typical example of a non-fatal error is an I/O timeout or an unusual
> error notification from the controller. Since the firmware is operational,
> the error dump information is pushed to host memory (by firmware) upon
> request from the host.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>

Thanks
