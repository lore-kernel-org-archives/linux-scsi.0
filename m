Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C9EC2D0DB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 07:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E57A24125
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 07:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="ap/wvHTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgAUHzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 02:55:23 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:36177 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgAUHzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2020 02:55:23 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so1651779iln.3
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2020 23:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wkUX6a6cV6+p+WpnXGF3nMbUuco/vYfXwXYwaWZkEhY=;
        b=ap/wvHTnprmx2r41jGBvPGp33qfdz6Ge7CBbBWIyXzxcU9snVd3H0aTIsZzCfpDHug
         j7G9CoxK64TlzfB7pDlzzVk9JnSo/AFfdoCs3B6e85+Pcz3+Wr4iQTBVp7nVIuQw5/Py
         d0fBVVPuOOn5iSLWMOKo+qtV3LcRAxVojvpim6reoXxIlT3N8lyGLxjO6SBK3TxLt8hD
         /vbrmXvnhlEi1hO0zUv7mA9hUynmLoscmFJhm83EEW5GfqUwElo4kYXA7s/lHXPW1G9n
         5ZEnbMRqkVqd1z/MRWIB+EB2TqtTyk+bri1q779A5BEN9ns6fXpk0f/odiBC5dn3upMj
         Rk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wkUX6a6cV6+p+WpnXGF3nMbUuco/vYfXwXYwaWZkEhY=;
        b=Ir5F1BsmrDAPDRuXK5Tvt+OAAh4JUj17r8furq40xP2DJlLYyXHCLl7WT9Smyyr1f2
         Ux2gbkeIuxLxHa0pDzynjM1aQpeiME0IZkWXFGkqvjF4uUAZSyi0YGtPZBYbJYFprl2p
         AxselBzNByOOX0KFXSPe2eUOqQE0xgeO4ZuueItmzleWR+czy+cf6XOASJ/BzDSpmICV
         9NWh/avQvC0WE3Cp2yyzeduebEGagseblstQVFQ81nbhpFWcmY6xXj/UeIL3Ox6ic9+Z
         2MZk3XqJB3u7KQkNALg4YC+rlYZHbpP3r3+dxidSBcC4nx13BamE5HWvUcDMEz44Z9OB
         31OQ==
X-Gm-Message-State: APjAAAXdAvGlkHr711ZmsLG6wCF/ZBYfEH7EFGAIj/3R8mbuPAwJaZT7
        IQ04fwgTfh4Scn1EJXKZaoWtcoiyxhE+bDyYjhGQ3g==
X-Google-Smtp-Source: APXvYqw4R2e9Vm1rv2/r4zfsJdtTbxk5Ur0Gm4dFFnq5otyoXQM1oH292/rA8+NgFOeo6++IoOSSpGTPOC5r2Bl5VnA=
X-Received: by 2002:a05:6e02:4d2:: with SMTP id f18mr2521384ils.54.1579593322834;
 Mon, 20 Jan 2020 23:55:22 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-7-deepak.ukey@microchip.com> <CAMGffEmBVJcDxZ1mkwzHwhsocvwHUxbZ-Xvvs4U+BGk7duxR7A@mail.gmail.com>
 <MN2PR11MB355086B3596903D935F678DCEF320@MN2PR11MB3550.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB355086B3596903D935F678DCEF320@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 21 Jan 2020 08:55:12 +0100
Message-ID: <CAMGffEnhmJ-7k0YDNCy9jppm_3bypLLn-XbDN1McxaVYtcEOgQ@mail.gmail.com>
Subject: Re: [PATCH V2 06/13] pm80xx : sysfs attribute for number of phys.
To:     Deepak Ukey <Deepak.Ukey@microchip.com>
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

On Mon, Jan 20, 2020 at 5:50 AM <Deepak.Ukey@microchip.com> wrote:
>
>
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
> On Fri, Jan 17, 2020 at 8:10 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
> >
> > From: Viswas G <Viswas.G@microchip.com>
> >
> > Added sysfs attribute to show number of phys.
> >
> > Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> > Signed-off-by: Viswas G <Viswas.G@microchip.com>
> > Signed-off-by: Radha Ramachandran <radha@google.com>
> I agree with John Gary, the mgmt tool can get the info from /sys/class/sas_phy, no need to add an extra sysfs.
>
> I suggest dropping the patch.
> > We have HBA application already in use by customer which uses this sysfs entry. So is it fine to keep this patch?
> Thanks!

How much effort to convert the HBA application to use general sas_phy
information? IMHO converting HBA application to use general interface
is the right way to go.

Thanks
