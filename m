Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45BBC0044D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 17:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E35206BE
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 17:08:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="fGg1o5wA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgCKRIY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 13:08:24 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:44789 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730055AbgCKRIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 13:08:24 -0400
Received: by mail-il1-f194.google.com with SMTP id j69so2702953ila.11
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2020 10:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LEC5FP8mgBmFOtl8eI8FiHus35miS8R5/z+CCBwwGLo=;
        b=fGg1o5wANBQVIAqKSyWhyR4Ad4Zj56/g03T7j68Crvvpw3ixcFiJugESFTQc+LUWey
         2/1bjkM3C5V1/4q7sSY4mXn602Mw4iJjhbK2JqArV7r/MZSAA7d5SO8dlJZ2pm/NoNM9
         XBSo16KPvflI/C1MJU6PpmQcwZqNFINVz8IFuH/eoOASMWpZ6Ffl0cYpmNEKVwottOQo
         FFgIaxmSIofkXAwzjhTE8z5wRd5sY0zOWV99x1uZVynVxWfedX16n7l6h9V6tXLJCb8l
         FEXTVddlvrJ0pdwi2pDulQEioJBuyA/Q7w20OxbCb+jSxPyUd8sV4Jmtlvmn+q87/Kz5
         8Z3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LEC5FP8mgBmFOtl8eI8FiHus35miS8R5/z+CCBwwGLo=;
        b=oZNNp8Kd7WzxzWdsJK7tAn9gKOfmCZ56mFqI6glSohRYSCmoPIt6Y32gTr7mU+10qe
         UQ1p6Ii6a8hWaqjEY5YHbr9fo1xIHETZhEj6Bi1I5Ld3uGSfViVn/FwitrbsbYp/UWg/
         8K4NvOH0B+Mj4SKXwwKWZSv/oygWTbwjbxY1m7EBC2FaRVi4EpvXoOeP1ut3Cclh97rb
         3+68IIHE5BrL6rueJmDW9X3y5UQDSS2qEoVj4VzqfhXpvC0U9v/kuuDVJ2r798YaF5vc
         ftAXYMbOVHAT+zKUFigleSbM2rf6KSogaB+AX0kSHSMvep3WeJH6W14dHd2w3Xygnhuu
         8OyQ==
X-Gm-Message-State: ANhLgQ2G+UZLyNqg/6QipUfZoeaM6PPt9hwIF/TAZt5EEiYKxXthC6/p
        Vs4dTimq85QSOR9AFniEnlfjKaDEts8YOzyI5WjCLw==
X-Google-Smtp-Source: ADFU+vvhQgs0uL0Osu06t/R9n+xfJNWRNx9fQMqqBSwua+1ZTKf9cQ6DsNebymmPfO0rMIIJ9U6CAL+DenaSn2ZJ/dk=
X-Received: by 2002:a92:670f:: with SMTP id b15mr4081570ilc.71.1583946503296;
 Wed, 11 Mar 2020 10:08:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-6-deepak.ukey@microchip.com> <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com> <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com> <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <3e76b6e1-9c3d-2e5c-896e-f1af9a785fe5@huawei.com> <MN2PR11MB35505927EB38FFD749E535CBEF0A0@MN2PR11MB3550.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB35505927EB38FFD749E535CBEF0A0@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 11 Mar 2020 18:08:11 +0100
Message-ID: <CAMGffEnHim9GD2F+7ueyoMWuYpdqghGGYqfLrWcAcN3WfXm_Ng@mail.gmail.com>
Subject: Re: [PATCH V2 05/13] pm80xx : Support for char device.
To:     Deepak Ukey <Deepak.Ukey@microchip.com>
Cc:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>, yuuzheng@google.com,
        Vikram Auradkar <auradkar@google.com>, vishakhavc@google.com,
        bjashnani@google.com, Radha Ramachandran <radha@google.com>,
        akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 28, 2020 at 10:43 AM <Deepak.Ukey@microchip.com> wrote:
>
>
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>
> On 22/01/2020 08:50, Deepak.Ukey@microchip.com wrote:
> > -r--r--r-- 1 root root 4096 Jan 21 12:05 running_disparity_error_count
> > ***
> > -r--r--r-- 1 root root 4096 Jan 21 12:05 sas_address
> > lrwxrwxrwx 1 root root    0 Jan 21 11:45 subsystem ->
> > ../../../../../../../class/sas_phy
> > -r--r--r-- 1 root root 4096 Jan 21 12:05 target_port_protocols
> > -rw-r--r-- 1 root root 4096 Jan 21 11:45 uevent
> >
> > Maybe the other stuff provided in the patches are useful, I don't know.
> > But debugfs seems better for that.
> >
> >       - 0006-pm80xx-sysfs-attribute-for-number-of-phys
> >       - 0007-pm80xx-IOCTL-functionality-to-get-phy-status gets things l=
ike Programmed Link Rate, Negotiated Link Rate, PHY Identifier
> >       - 0008-pm80xx-IOCTL-functionality-to-get-phy-error provides other=
 things like Invalid Dword Error Count, Disparity Error Count
> >       - Thanks for addressing it. We can get this info from /sys/class/=
sas_phy and /sys/class/sas_port so we will drop these above mentioned three=
 patches from the next              - patch series.
> >

> >
> >       - 0009-pm80xx-IOCTL-functionality-for-GPIO
> >       - 0013-pm80xx-IOCTL-functionality-for-TWI-device
> >       - For the above patches management utility passes command specifi=
c information to driver through IOCTL structure, which used by driver to fr=
ame the command and         - send to FW.  We are using the IOCTL interface=
 for the same. Please let us know your thought.
>
> So I specifically questioned the SGPIO patch and why it would have an IOC=
TL, as this function is supported in kernel libsas/SAS transport code as an=
 SMP function.
> >  Thank you for your suggestions. We will make use of function supported=
 in libsas.

So basically you only need IOCTL for GPIO and TWI devices, others can
implement via libsas interface or from sysfs directly.

I would like to suggest you do send out other changes without the
IOCTL parts first, and consider again Is it really needed by the user
to control GPIO and TWI, and if there is other way to do it?

Sorry, I don't have a better suggestion!

Regards,
Jack Wang
