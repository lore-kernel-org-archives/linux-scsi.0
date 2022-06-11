Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE11C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jun 2022 08:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiFKIeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jun 2022 04:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiFKIeT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jun 2022 04:34:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A398B61614
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jun 2022 01:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654936456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/nj+eyQDOKupY5Gm0LaROjAymDtcr/UJJJ5aW9KO+7o=;
        b=FNcH+RrOxh2OapHNMLvVhL4Zykwk3UdLQq/Xkb8tGPewZvjoGdTOGRjX89PkRvdoDdlc+V
        HHir3IKRSH8BgZ7RlJQQ2NFw/60JMKpwa3xmxMWhdVlpQaT5Qcnlqnv6LrW2nCc7ypMV/K
        u0ok3Mu+nOqBfk69LEO4bgGyW3Atbtk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-BGncYn_MPjO69bZV2lIrGQ-1; Sat, 11 Jun 2022 04:34:15 -0400
X-MC-Unique: BGncYn_MPjO69bZV2lIrGQ-1
Received: by mail-pg1-f199.google.com with SMTP id g129-20020a636b87000000b00401b8392ac8so728807pgc.4
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jun 2022 01:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/nj+eyQDOKupY5Gm0LaROjAymDtcr/UJJJ5aW9KO+7o=;
        b=so2+eHZMQ61Us5i08ZMtpSFTUKkcYNZuTTJlJoidEOsrryw/VAQ4ripufxac19JnXb
         4fwunzmdH/rQtlgVcbYIZiudY+nhNC8D14W7wjcjs++jy5X6EXOC1n4sIoOpmnsSC5I+
         XFMrhiOWfOhsdl2etU3sAezP4o7zqZAq8PQ6m0uRxIKo74qAl/ElxatmAyHdSQWe0TuN
         rWDCs+NZG8GLPovFa0TbDrUPoS376B9xv4ZNBseXQyHGzOPRdGfrcruOLUW2YGstOd99
         YPLGabvQv64nC4N6v28OHqCJhnSmUQKAiUuGb4qE7IFajSn/UuWZLQn+wa7urRLLMabt
         ZqMg==
X-Gm-Message-State: AOAM5301SDgMmHw3+nGfnwjd7xvNw0otdNXpiV5icAwiRPqn/WJVtBHU
        uqPUYLzS8eUyPuD2f69X9IE4IX/3bo/URh3PXs5FrZthZb720aWP/GsklhMB2DfEczshxREsbWA
        sZtt/6nyrwP+4qyz3lDlov/8h1BM+T0+KvNl+FQ==
X-Received: by 2002:a17:902:db0a:b0:165:1299:29ea with SMTP id m10-20020a170902db0a00b00165129929eamr48944638plx.15.1654936454243;
        Sat, 11 Jun 2022 01:34:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfWWDvxzi4zRM2HC5pva6+1ZddS5YtzIfpQd2mOSo+97x+Ci2mnxI88oS4vUcT4M5duK0ikun/yAmArwpjtg0=
X-Received: by 2002:a17:902:db0a:b0:165:1299:29ea with SMTP id
 m10-20020a170902db0a00b00165129929eamr48944619plx.15.1654936453917; Sat, 11
 Jun 2022 01:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220609235329.4jbz4wr3eg2nmzqa@shindev> <717734c9-c633-fb48-499e-7e3e15113020@nvidia.com>
 <19d09611-42cc-5a81-d676-c5375865c14c@nvidia.com> <20220610122517.6pt5y63hcosk5mes@shindev>
 <YqNZiMw+rH5gyZDI@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <YqNZiMw+rH5gyZDI@kbusch-mbp.dhcp.thefacebook.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Sat, 11 Jun 2022 16:34:03 +0800
Message-ID: <CAHj4cs9G0WDrnSS6iVZJfgfOcRR0ysJhw+9yqcbqE=_8mkF0zw@mail.gmail.com>
Subject: Re: blktests failures with v5.19-rc1
To:     Keith Busch <kbusch@kernel.org>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        mstowe@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 10, 2022 at 10:49 PM Keith Busch <kbusch@kernel.org> wrote:
>
> On Fri, Jun 10, 2022 at 12:25:17PM +0000, Shinichiro Kawasaki wrote:
> > On Jun 10, 2022 / 09:32, Chaitanya Kulkarni wrote:
> > > >> #6: nvme/032: Failed at the first run after system reboot.
> > > >>                 Used QEMU NVME device as TEST_DEV.
> > > >>
> > >
> > > ofcourse we need to fix this issue but can you also
> > > try it with the real H/W ?
> >
> > Hi Chaitanya, thank you for looking into the failures. I have just run the test
> > case nvme/032 with real NVME device and observed the exactly same symptom as
> > QEMU NVME device.
>
> QEMU is perfectly fine for this test. There's no need to bring in "real"
> hardware for this.
>
> And I am not even sure this is real. I don't know yet why this is showing up
> only now, but this should fix it:

Hi Keith

Confirmed the WARNING issue was fixed with the change, here is the log:

# ./check nvme/032
nvme/032 => nvme0n1 (test nvme pci adapter rescan/reset/remove during
I/O) [passed]
    runtime  5.165s  ...  5.142s
nvme/032 => nvme1n1 (test nvme pci adapter rescan/reset/remove during
I/O) [passed]
    runtime  6.723s  ...  6.635s
nvme/032 => nvme2n1 (test nvme pci adapter rescan/reset/remove during
I/O) [passed]
    runtime  7.708s  ...  7.808s

[  307.477948] run blktests nvme/032 at 2022-06-11 04:27:46
[  312.603452] pcieport 0000:40:03.1: bridge window [io
0x1000-0x0fff] to [bus 42] add_size 1000
[  312.603599] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  312.603603] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  312.603729] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  312.603733] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  313.397440] run blktests nvme/032 at 2022-06-11 04:27:51
[  318.732273] nvme nvme1: Shutdown timeout set to 16 seconds
[  318.785945] nvme nvme1: 16/0/0 default/read/poll queues
[  319.268544] pci 0000:44:00.0: Removing from iommu group 33
[  319.326814] pci 0000:44:00.0: [1e0f:0007] type 00 class 0x010802
[  319.326866] pci 0000:44:00.0: reg 0x10: [mem 0xa4900000-0xa4907fff 64bit]
[  319.483234] pci 0000:44:00.0: 31.504 Gb/s available PCIe bandwidth,
limited by 8.0 GT/s PCIe x4 link at 0000:40:03.3 (capable of 63.012
Gb/s with 16.0 GT/s PCIe x4 link)
[  319.531324] pci 0000:44:00.0: Adding to iommu group 33
[  319.547381] pcieport 0000:40:03.1: bridge window [io
0x1000-0x0fff] to [bus 42] add_size 1000
[  319.547448] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  319.547453] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  319.547547] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  319.547550] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  319.547607] pci 0000:44:00.0: BAR 0: assigned [mem
0xa4900000-0xa4907fff 64bit]
[  319.556620] nvme nvme1: pci function 0000:44:00.0
[  319.838233] nvme nvme1: Shutdown timeout set to 16 seconds
[  319.911826] nvme nvme1: 16/0/0 default/read/poll queues
[  320.900025] run blktests nvme/032 at 2022-06-11 04:27:59
[  326.311357] nvme nvme2: 16/0/0 default/read/poll queues
[  327.771945] pci 0000:45:00.0: Removing from iommu group 34
[  327.839066] pci 0000:45:00.0: [8086:0b60] type 00 class 0x010802
[  327.839106] pci 0000:45:00.0: reg 0x10: [mem 0xa4800000-0xa4803fff 64bit]
[  328.011204] pci 0000:45:00.0: 31.504 Gb/s available PCIe bandwidth,
limited by 8.0 GT/s PCIe x4 link at 0000:40:03.4 (capable of 63.012
Gb/s with 16.0 GT/s PCIe x4 link)
[  328.058523] pci 0000:45:00.0: Adding to iommu group 34
[  328.072575] pcieport 0000:40:03.1: bridge window [io
0x1000-0x0fff] to [bus 42] add_size 1000
[  328.072628] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  328.072632] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  328.072685] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  328.072688] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  328.072741] pci 0000:45:00.0: BAR 0: assigned [mem
0xa4800000-0xa4803fff 64bit]
[  328.079857] nvme nvme2: pci function 0000:45:00.0
[  328.153256] nvme nvme2: 16/0/0 default/read/poll queues
>
> ---
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index fc804e08e3cb..bebd816c11e6 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -476,7 +476,7 @@ static ssize_t dev_rescan_store(struct device *dev,
>         }
>         return count;
>  }
> -static struct device_attribute dev_attr_dev_rescan = __ATTR(rescan, 0200, NULL,
> +static struct device_attribute dev_attr_dev_rescan = __ATTR_IGNORE_LOCKDEP(rescan, 0200, NULL,
>                                                             dev_rescan_store);
>
>  static ssize_t remove_store(struct device *dev, struct device_attribute *attr,
> --
>


-- 
Best Regards,
  Yi Zhang

