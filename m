Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958C1C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 03:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C72F2076A
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 03:40:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbvrYqU8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgFJDk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 23:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgFJDk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 23:40:27 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1429C05BD1E;
        Tue,  9 Jun 2020 20:40:25 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id l10so399505vsr.10;
        Tue, 09 Jun 2020 20:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HzgZ5bNHS75v5R+cw4d6Syf6V/t0Pw4htyNN2JEeeYs=;
        b=XbvrYqU8sC7FNRqDvf1pnZHmLDsxodqZOkBcwXk8R5JSiuQO91bHgDvHUdPvsgJR3K
         vnbBuaeqvrKfCf8QXG1UKEIrSRDG25UvhgaxWxX0ORLGHPa7/dR00OeEg8FdgPsOenj6
         xzdhHRZViu4/BZ7Qz+Vf1Tx0xtbqjnim2wdH8SeN/IEqO8Q9LgZuM+HtkoB8NxmYl0T9
         FWh2pfiE5+Yz65ONbXzyZPPGLqqDcJQChS4yPXt9n3dDMA6f5rTm9cR0obSpjbq3R0Gj
         JAlqnZQgrOnmmuK1kAlwYY6Q6bzEII1djO9RubnoDajCLkMlbykkS/FdccCICj4H0SRV
         2avA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HzgZ5bNHS75v5R+cw4d6Syf6V/t0Pw4htyNN2JEeeYs=;
        b=Qa6DGxRPtMZZmgVi9F+tAUJxcAQ3cQ9IU0u2PYaJpwHHAz3Mb39HDhum91i1t+JQhV
         mWXfpP0njTvoeB1vyYPSIgnGk0niEW2glb5MVIEXwWH9kgVHALCF0rorYCXEnerR53EZ
         fZ4CUX7F2oBmy+xnHCubvon/ASb9HI3nUBiI9R9hlfS0Sk199VUqj7zCXj5KPurT7+eT
         PVHY/EzqzndyfGGbhkCuFwZORFCFMEw+6R6MT1TyRSke0JUL65Ys2SgTDz68WREsSxz9
         bCx8hltFvRLFwZgli6LGPXj4yjatCSNy+gjTmEAf0gpDAEsjrPohxVCIObXOzp9l3L17
         Razg==
X-Gm-Message-State: AOAM530nTaaj1NMwnBIitqq/svlpY05bjWsnM79sliYbjZEyfQH7pIrJ
        q4sx01+DHSOKTChCVJPBXE5n1a54jm7Hq+MBYj4=
X-Google-Smtp-Source: ABdhPJyhqZ54WvYvS0LYMBlGPm9TS7rVETs2fmRZCH+RUJC/2o+OSVHuQT8pk7VLwPm8HV3kelYkUHNen+a3zY8P+oE=
X-Received: by 2002:a67:a64c:: with SMTP id r12mr1001131vsh.127.1591760424842;
 Tue, 09 Jun 2020 20:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587735561.git.Jose.Abreu@synopsys.com> <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
 <SN6PR08MB5693C397D88D16EC43E85490DBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
 <BN8PR12MB3266D1F9B038EF821FA8D503D3AD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN7PR08MB56847531D0EC603DD2C7B349DBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
 <BN8PR12MB32664256580771FA9102EB14D3AA0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB32664256580771FA9102EB14D3AA0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Wed, 10 Jun 2020 09:09:48 +0530
Message-ID: <CAGOxZ50qPoC0HPUdTiOzA+NhTo5FRZVk01uq40AaDNn4JkHi3Q@mail.gmail.com>
Subject: Re: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jose

On Thu, Apr 30, 2020 at 1:44 PM Jose Abreu <Jose.Abreu@synopsys.com> wrote:
>
> From: Bean Huo (beanhuo) <beanhuo@micron.com>
> Date: Apr/29/2020, 13:59:08 (UTC+00:00)
> > > Probably. I think we can leave them or change the dev_err to a dev_warn.
> > > This way we have logs in case someone is using a non-supported version.
> > >
> > > What do you think ?
> > >
> > Hi, Jose
> > Seems after your patch, all of current released UFS control versions will be supported except the
> > version suffix is non-zero. Right?
>
> I think we cover all versions with this patch.
>
Are you still on this?

> ---
> Thanks,
> Jose Miguel Abreu



-- 
Regards,
Alim
