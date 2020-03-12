Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28769C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 08:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED1B220650
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 08:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="dUOHvBzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCLIuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 04:50:01 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:42113 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLIuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 04:50:01 -0400
Received: by mail-il1-f193.google.com with SMTP id x2so4697293ila.9
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 01:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ICNtUPGhcGpems08Lz9Q39cK9OjLuNJLm6DxbXfvcB4=;
        b=dUOHvBzmG+1k5bJeQwd1OX85aH1faPG/9VSB6b/hPrXXhg4HpD+1vPrB3uqYiBovIU
         HON6ce93OH1D8a9g5T2sHBCO2Z6bNxqsHfj5cf4AIOIhUtKINfH13WN+YAMfUu0nk0XU
         zHKTv3YmIanHtuItolRYMmk4l2vFg3b0bvVqRc4Zb9gLAzgmAK674BEsr8ye5tXH6VkU
         U4ZR5UeXiboBhDN77zV9IF4d1C3avNyczOGbgCii03hBgYBVyCaobt2BuGVaxRWQtHW8
         TZ1VSvYUTiWBeKyR9AK7XsDCdoC9cuHLBih+5MPayQsOc2hpnHK1FWXoh2McJzowswq6
         t49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ICNtUPGhcGpems08Lz9Q39cK9OjLuNJLm6DxbXfvcB4=;
        b=J2SGwpXugmrS2czcQOBsFnLJT7sh0vmXRX2ocNN8Ybt0X43wtO1bzYWVxSUMdF4saU
         NblAXC4TDpzpKSERO5/pGaMnecB17wwRLVYKCIbZwzWSgHilnudXQsJCREuE/3vzz9+H
         YRW3ksI9z4Jik3Sc9Ch0js9i6Cx2OvQbia6r9zYv9Sc6Xne/lDSQiVBZS9iG2ygxbI83
         aOJJ3xQ4QK+P4tubqBk4Jl2Uc62WhMlcm79JJ5alnldNp3sP8HiuYExJA180p01fcbCB
         djWhWtOGpK08oo0p3oMZ6Fw4U4vMjB4gtSz7xq5g6mVeHHmkV713c+PXw9XDovFnpCKq
         STqg==
X-Gm-Message-State: ANhLgQ3Zcs4BerBtoThhU+AlD/qOaUau6q94BShyJzyiugsW3Uh9sBGp
        fAOsxS1xC3x69QD1Zt+/tieTKHsmLS8twlHLs0FS3A==
X-Google-Smtp-Source: ADFU+vtrg50HdKXXObnipFPXRHshk4tqlBtgE4UIm9zCzS70LWivm2+S/Tysc+i52/V6BkejiWxm07WUmql742y6Lxo=
X-Received: by 2002:a05:6e02:86:: with SMTP id l6mr7129624ilm.22.1584002997754;
 Thu, 12 Mar 2020 01:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-6-deepak.ukey@microchip.com> <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com> <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com> <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <3e76b6e1-9c3d-2e5c-896e-f1af9a785fe5@huawei.com> <MN2PR11MB35505927EB38FFD749E535CBEF0A0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <CAMGffEnHim9GD2F+7ueyoMWuYpdqghGGYqfLrWcAcN3WfXm_Ng@mail.gmail.com> <92a5ed32-eecb-dc1b-c485-1b691573f5de@interlog.com>
In-Reply-To: <92a5ed32-eecb-dc1b-c485-1b691573f5de@interlog.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 12 Mar 2020 09:49:46 +0100
Message-ID: <CAMGffEnxq9HTFZ3htbXMQoO4DQr5L+rOS5_KYUh2-edqFNWO1w@mail.gmail.com>
Subject: Re: [PATCH V2 05/13] pm80xx : Support for char device.
To:     Doug Gilbert <dgilbert@interlog.com>,
        Deepak Ukey <deepak.ukey@microchip.com>
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

On Wed, Mar 11, 2020 at 11:13 PM Douglas Gilbert <dgilbert@interlog.com> wr=
ote:
>
> On 2020-03-11 1:08 p.m., Jinpu Wang wrote:
> > On Tue, Jan 28, 2020 at 10:43 AM <Deepak.Ukey@microchip.com> wrote:
> >>
> >>
> >> EXTERNAL EMAIL: Do not click links or open attachments unless you know=
 the content is safe
> >>
> >> On 22/01/2020 08:50, Deepak.Ukey@microchip.com wrote:
> >>> -r--r--r-- 1 root root 4096 Jan 21 12:05 running_disparity_error_coun=
t
> >>> ***
> >>> -r--r--r-- 1 root root 4096 Jan 21 12:05 sas_address
> >>> lrwxrwxrwx 1 root root    0 Jan 21 11:45 subsystem ->
> >>> ../../../../../../../class/sas_phy
> >>> -r--r--r-- 1 root root 4096 Jan 21 12:05 target_port_protocols
> >>> -rw-r--r-- 1 root root 4096 Jan 21 11:45 uevent
> >>>
> >>> Maybe the other stuff provided in the patches are useful, I don't kno=
w.
> >>> But debugfs seems better for that.
> >>>
> >>>        - 0006-pm80xx-sysfs-attribute-for-number-of-phys
> >>>        - 0007-pm80xx-IOCTL-functionality-to-get-phy-status gets thing=
s like Programmed Link Rate, Negotiated Link Rate, PHY Identifier
> >>>        - 0008-pm80xx-IOCTL-functionality-to-get-phy-error provides ot=
her things like Invalid Dword Error Count, Disparity Error Count
> >>>        - Thanks for addressing it. We can get this info from /sys/cla=
ss/sas_phy and /sys/class/sas_port so we will drop these above mentioned th=
ree patches from the next              - patch series.
> >>>
> >
> >>>
> >>>        - 0009-pm80xx-IOCTL-functionality-for-GPIO
> >>>        - 0013-pm80xx-IOCTL-functionality-for-TWI-device
> >>>        - For the above patches management utility passes command spec=
ific information to driver through IOCTL structure, which used by driver to=
 frame the command and         - send to FW.  We are using the IOCTL interf=
ace for the same. Please let us know your thought.
> >>
> >> So I specifically questioned the SGPIO patch and why it would have an =
IOCTL, as this function is supported in kernel libsas/SAS transport code as=
 an SMP function.
> >>>   Thank you for your suggestions. We will make use of function suppor=
ted in libsas.
> >
> > So basically you only need IOCTL for GPIO and TWI devices, others can
> > implement via libsas interface or from sysfs directly.
> >
> > I would like to suggest you do send out other changes without the
> > IOCTL parts first, and consider again Is it really needed by the user
> > to control GPIO and TWI, and if there is other way to do it?
> >
> > Sorry, I don't have a better suggestion!
>
> LSI SAS HBAs (LSI now owned by Broadcom) implement an internal ** SMP
> target. It can be seen here:
>
> # ls /dev/bsg
> 3:0:0:0  3:0:3:0  8:0:0:0  8:0:0:3           end_device-3:1    expander-3=
:0
> 3:0:1:0  4:0:0:0  8:0:0:1  8:0:0:4           end_device-3:1:0  expander-3=
:1
> 3:0:2:0  7:0:0:0  8:0:0:2  end_device-3:0:1  end_device-3:2    sas_host3
>
> It is the last device node: "sas_host3". How do I know it is a SMP target=
?
> Because this works:
>
> # smp_read_gpio /dev/bsg/sas_host3
> Read GPIO register response:
>    GPIO_CFG[0]:
>      version: 0
>      GPIO enable: 1
>      cfg register count: 2
>      gp register count: 1
>      supported drive count: 16
>
> When you work out what LSI are doing with this, perhaps you could write
> an article about it and make it publicly available.
> It is always a good idea to see how your competitors solve problems :-)
This sounds indeed a better solution, thanks for the info, Doug

@Deepak Ukey can you check if you guys can also do it this way?

Regards,
Jack Wang
