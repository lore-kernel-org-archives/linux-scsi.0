Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0514C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 03:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B94882077D
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 03:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gpiccoli-net.20150623.gappssmtp.com header.i=@gpiccoli-net.20150623.gappssmtp.com header.b="Pr3qbHoE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgFCDZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFCDY7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 23:24:59 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB0FC08C5C0
        for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2020 20:24:59 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i16so883733qtr.7
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2020 20:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gpiccoli-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BXmCBfyCWBLJ8/sk/iuZv1hV1FI7bZPNvbpxPPDsSrw=;
        b=Pr3qbHoE/XjCIaqP7dlsDSIMPAazmDW9tHTHFWkAXq7xEc17VVgUj5l0TtXxGue6z/
         mx7jPyCjA6XYbxLQZLWU4Q8LXt+WBI5Qy/ZSQJVccOVCyq8RmkJImXtZWzUms/jHdOr0
         /9D9QOPiSqyl8hbYu6Cu5Z/eFKYitVKoSO05V6B14iGdvobgtq+dculwlRHcCJa05xjQ
         Dp60o96utYkCHkzWCjnqYXGZiU069VIQSNAtvbix8KYfP84OLInAVmpAuaV91nIUKmOn
         NYgqXv69N1+bEuSH8bf5buigkBNPKs+0oZ7k8IXpFE8/pZGWSas6BvEzIH/cEI1xOtoh
         9O1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BXmCBfyCWBLJ8/sk/iuZv1hV1FI7bZPNvbpxPPDsSrw=;
        b=U2/Ta28qYnZn/D72Rq/I7tPb1ZzMUEq4t95mUQ0aReK2dsCwpXmV4rRNFk02hodThe
         n+MQp85gqQbjZNvedJgY4kp1k3qE5v3rojERCajNJBWbu3m1ft33j2d0QorRrwyp6iJ2
         2QCNUzxhlVfsRvMIDuW+5QQXRq7i2A6O8hHEXa8yfvOlGc2Y1hHp2mmAADM1QXJCAFd+
         /Q+mFTjfooVQAF8iTjDsCAjg3UM7qZwAb0BEiKUJU+c01Cxg0uKvMbOwBtSNdkcEghLd
         IJPYylOrLTepBnKdFHwcEiZCPW7UrrPTmMFdtl9eaoh6RYo8f9DHnjL5E2U3966tnOcb
         jxUA==
X-Gm-Message-State: AOAM533KHuoRdN5duE+py4A6L/FeR6kFXGFUxWfNFOwwAgtr0K4XP+qt
        xfTdyiYeAvUPHy8YtY+uDOj7b57lyudmyXzrFNzwHw==
X-Google-Smtp-Source: ABdhPJycYUOYhoObzTOamww+3Mmgy1O9ppXhzPVe9/ry0aYrYn3BhdV1Qo/FrpfDcbyEh6+9kWeUUyvNdeX4U+rbU9o=
X-Received: by 2002:aed:31a1:: with SMTP id 30mr32221789qth.366.1591154698875;
 Tue, 02 Jun 2020 20:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <DM6PR18MB30346814DE1F5807188A844CD2B80@DM6PR18MB3034.namprd18.prod.outlook.com>
 <DM6PR18MB3034B8373D1AF280C18593CCD2B60@DM6PR18MB3034.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB3034B8373D1AF280C18593CCD2B60@DM6PR18MB3034.namprd18.prod.outlook.com>
From:   "Guilherme G. Piccoli" <kernel@gpiccoli.net>
Date:   Wed, 3 Jun 2020 00:24:22 -0300
Message-ID: <CALJn8nNv3pEF2G3AfukziYZ2W8Hb94iguY=TUfxnKYsbjBrBiA@mail.gmail.com>
Subject: Re: Regarding - Patch - Fix crash on qla2x00_mailbox_command
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     "rosattig@linux.vnet.ibm.com" <rosattig@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Arun Easi <aeasi@marvell.com>,
        Girish Basrur <gbasrur@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Mauro Rodrigues <maurosr@linux.vnet.ibm.com>,
        maurosr@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IIRC Rodrigo's email does not work anymore...looping Mauro, he should
be able to forward to appropriate folks at IBM.
Cheers,


Guilherme


On Wed, May 20, 2020 at 3:33 AM Saurav Kashyap <skashyap@marvell.com> wrote:
>
> Hi Rodrigo,
> Any updates on this?
>
> Thanks,
> ~Saurav
>
> > -----Original Message-----
> > From: Saurav Kashyap
> > Sent: Monday, May 18, 2020 12:20 PM
> > To: rosattig@linux.vnet.ibm.com
> > Cc: linux-scsi@vger.kernel.org; Arun Easi <aeasi@marvell.com>; Girish Basrur
> > <gbasrur@marvell.com>; Nilesh Javali <njavali@marvell.com>
> > Subject: Regarding - Patch - Fix crash on qla2x00_mailbox_command
> >
> > Hi  Rodrigo,
> > We are seen regression introduced by below patch for QLA 82XX HBAs. On
> > unload, the disable interrupt, mailbox command (MBX 0x10) fails because of
> > this patch and leaves the FW/HW in unstable state. The next load fails with
> > initialization FW timing out.
> > The only way out of this is to reboot the server. I  and  test team have tried to
> > reproduce an original problem that is fixed by below patch but we don't have
> > any luck.
> >
> > We would like to revert the below patch but would like to address original
> > problem as well. Can you share more details about the NULL pointer
> > dereference? Which data structure was NULL and what was the test case?
> >
> > ==============================
> > git show 3cb182b3fa8b7a61f05c671525494697cba39c6a
> > commit 3cb182b3fa8b7a61f05c671525494697cba39c6a
> > Author: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
> > Date:   Mon May 28 14:58:44 2018 -0300
> >
> >     scsi: qla2xxx: Fix crash on qla2x00_mailbox_command
> >
> >     This patch fixes a crash on qla2x00_mailbox_command caused when the
> > driver
> >     is on UNLOADING state and tries to call qla2x00_poll, which triggers a
> >     NULL pointer dereference.
> >
> >     Signed-off-by: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
> >     Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
> >     Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> >     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> > index d8a36c1..7e875f5 100644
> > --- a/drivers/scsi/qla2xxx/qla_mbx.c
> > +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> > @@ -292,6 +292,14 @@ static int is_rom_cmd(uint16_t cmd)
> >                         if (time_after(jiffies, wait_time))
> >                                 break;
> >
> > +                       /*
> > +                        * Check if it's UNLOADING, cause we cannot poll in
> > +                        * this case, or else a NULL pointer dereference
> > +                        * is triggered.
> > +                        */
> > +                       if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags)))
> > +                               return QLA_FUNCTION_TIMEOUT;
> > +
> >                         /* Check for pending interrupts. */
> >                         qla2x00_poll(ha->rsp_q_map[0]);
> > ====================
> >
> > Thanks,
> > ~Saurav
