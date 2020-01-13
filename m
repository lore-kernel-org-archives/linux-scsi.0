Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18222C33CA8
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD4E62075B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 09:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="UYG9r3Kx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgAMJjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 04:39:25 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40019 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAMJjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2020 04:39:25 -0500
Received: by mail-il1-f196.google.com with SMTP id c4so7581077ilo.7
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2020 01:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OYdey8UvaJ0vYPEz55GIl/UCCf/sv0yW/vPTIpu/qyA=;
        b=UYG9r3Kxc4GsWz7k46LX1tuINi5m8E7x4wWbBAKTC1AWI7seHUxSklVrPYQbZdtnvN
         5X1QVUteGPdsocQQ3/5xyHRPqwpYs1hjQ+p/xjsooNxyU5hSRQ0iCs+tCjfI8uhyKqno
         EdGywV2K0xci5V+QrnI9vrmkauu+onhZVOWhoXh0AKZZEQpqGrAw+vUFKJcCfCWZnfIs
         2h4H+wK+mSuWeCxVyO/n1l+RoiyHM6TLhWdyn4ef/5dy7X6P4eXBHU3z5b8oUAKf3Az9
         TveIdHeUtty+9s19pgL4thHF7n6ND/fyBFpWsJH0pxyxj+qtLo7LevISAbrW5uTpj5be
         pIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OYdey8UvaJ0vYPEz55GIl/UCCf/sv0yW/vPTIpu/qyA=;
        b=OvjhbaLFxq3dj6Brnsq8M6ALBRCcQitfhfLDm256DDVAQjP/zx0r3gVWNIALMb9CRD
         LzuutqlCJW/A66Yk5Xt+WcQaNQVRCgCdS9S45GF7yNdOrqYHQt2PoiCP4I15rDEFM3fC
         m5kkWrJL4dGWgW5uK2TT4tBqWEkqCMgEDPTzkqHTMrFQi2oNfQCuSxG2lCOyFloyjvCQ
         hyEvlUzVccItYswtZJXDQLMbGVbE6REbGtbIoBloX27adjtre/RS2WqDhwkUgY0RtSr/
         +e6ObKHpekRnauPJNR/WCD77IQATHdULDzaZISeCvmag+A63GeHOVyudVwfmFncfXGKq
         J9gg==
X-Gm-Message-State: APjAAAUal2rOZxjxJWp0icZ2tVTkw1mbe4bVpcPO6d/nyIlksQ+2blxx
        0tzM8PP9dgaWiUo5F+fRdv8L1pGztBp9pKQZHUPRRQ==
X-Google-Smtp-Source: APXvYqxYVcsETFACsFY/oNQi4ZRcJmjhFaWY5Q1QDNjZfoT79q0ql8Uf32tZ6rGkOonv1fLad+0l1ZoI+mlDKkaLMj0=
X-Received: by 2002:a92:d2:: with SMTP id 201mr14433502ila.22.1578908364737;
 Mon, 13 Jan 2020 01:39:24 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-7-deepak.ukey@microchip.com> <CAMGffEkzAt4FrP2DbhZhGE20nFWPpuGkN83t7Tvw6+LsQg=m3Q@mail.gmail.com>
 <32f47ddd-72c5-7846-f0a7-cba3ad1e0c6b@huawei.com> <BL0PR11MB29804B87E0768D41793E15A49D200@BL0PR11MB2980.namprd11.prod.outlook.com>
 <MN2PR11MB35500F70F6F82FE1C57D99E5EF350@MN2PR11MB3550.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB35500F70F6F82FE1C57D99E5EF350@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 13 Jan 2020 10:39:13 +0100
Message-ID: <CAMGffE=W9Ln5QrtP1LSe0OneLg5Zxqv4EWjTnpYo4ZHGJz9ojQ@mail.gmail.com>
Subject: Re: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
To:     Deepak Ukey <Deepak.Ukey@microchip.com>
Cc:     Viswas G <Viswas.G@microchip.com>,
        John Garry <john.garry@huawei.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 13, 2020 at 10:26 AM <Deepak.Ukey@microchip.com> wrote:
>
> Hi Jinpu,
>
> please use pm8001_ctl_num_phys_show as function name, so it follows
> > same conversion as other functions.
> > Better also rename controller_fatal_error too.
>
> If I tried to keep the function name as pm8001_ctl_num_phys_show as other=
 function follows then checkpatch.pl gives the below warning.
>
> ------
> WARNING: Consider renaming function(s) 'pm8001_ctl_num_phys_show' to 'num=
_phys_show'
> #37: FILE: drivers/scsi/pm8001/pm8001_ctl.c:108:
> +}
>
> total: 0 errors, 1 warnings, 32 lines checked
> -------
>
> That=E2=80=99s the only reason  I have changes the function name. For mak=
ing the other function with same naming convention, I will change the funct=
ion name of all other function like num_phys_show' and we will submit this =
patch in  our upcoming patch set.
>
> Regards,
> Deepak


Thanks for checking, then we can do it later.
PS: please avoid top-posting.
