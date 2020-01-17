Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85BCC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 700D32083E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 14:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="IJp706F+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgAQOVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 09:21:24 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33324 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAQOVY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 09:21:24 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so26160664ioh.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 06:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xbuo5nFh7G3AbBhiHz/zNZv1v5d4Ywk1Eq9kgmaO2o=;
        b=IJp706F+PEkdyGlY4StN2Kx2mbOYxeherG3umJyO93EqCoK1iLw9odbAn9edfLPAPl
         pkLIE5z6xFAYoNhkdKWUb4Rt8UzX+R6HxJEPLorBURov45UQ0yCzXlaCMvf0ilXC4SxC
         tuFp7ge/UDTKQwlmVJZdxcv1VRRmYCNpKE2mIyofSWXjlRkDngiupjYC5tXLvzBAp7A/
         /KmbDbr+yOz0OfZMN9SOmoXl0mP3iixGpSIIHg0lT+JriQzMg/306qUVLxyQ54NVsEfv
         BbzAZX5dILGor2tlCBRLZ/oItVDJ4sU6Uc7FC5ojzwJKCSteudogebpncbN6fUFxa05s
         wcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xbuo5nFh7G3AbBhiHz/zNZv1v5d4Ywk1Eq9kgmaO2o=;
        b=fYfPHKqq9cwH1qrTHj00gZvWo9Urc6uWJF2QpnxrqVq+eui0/UmTGSPdTYTPMAmxoI
         a8can6+pU1F+QdUuACkVdCrqvtfqSRKHQdw+xvvfaQ4d52CKJz/BWptnpjMSHBFFWscv
         hFizSyTkhs9n2dDH80CaCCBajCsJ+Zp7ay899XoC7c4HgOmTIi1dvbdzpJfQVKa0UOUG
         mAFGA4zy9h5s/ySK2u0DFvamXFuLUCIBErd/g/L1fBiliPE/cjw3IxeoA2Gf/Mwv/ksI
         c13Kz2Kp93qyGqVXBu+oWn4WXDpaVqCertZjrpscoCEcwNVgtTxMSqUyU1icumuhqPB0
         sXzg==
X-Gm-Message-State: APjAAAWw8LJBc5KWGLbaKWA0ojVPbZty3tNSj6rMpfWg3uCsv/OyGgpl
        Cw6f0qZYjDf+BegLHNanJD7Y5j2CePu74S2VHW9zbw==
X-Google-Smtp-Source: APXvYqwa4DMoP1PSkPScpDEnCCSwcTy8iDZaOYOzONd8MCCer9o9i++K24cPrPZfZ2A3+n/JUuWqmu3/JcPDjX58hoU=
X-Received: by 2002:a6b:6e02:: with SMTP id d2mr32371272ioh.22.1579270883266;
 Fri, 17 Jan 2020 06:21:23 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com> <20200117071923.7445-7-deepak.ukey@microchip.com>
In-Reply-To: <20200117071923.7445-7-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 17 Jan 2020 15:21:12 +0100
Message-ID: <CAMGffEmBVJcDxZ1mkwzHwhsocvwHUxbZ-Xvvs4U+BGk7duxR7A@mail.gmail.com>
Subject: Re: [PATCH V2 06/13] pm80xx : sysfs attribute for number of phys.
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
> From: Viswas G <Viswas.G@microchip.com>
>
> Added sysfs attribute to show number of phys.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
I agree with John Gary, the mgmt tool can get the info from
/sys/class/sas_phy, no need to add an extra sysfs.

I suggest dropping the patch.

Thanks!
