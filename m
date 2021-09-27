Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757BFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 08:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B2826108E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 08:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhI0IrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 04:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhI0IrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 04:47:02 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B35C061714
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 01:45:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v18so30864150edc.11
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 01:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DGKA8rTEAQu8OeSpTEqYi/Di78F+wnsXdQCPCwN2vKk=;
        b=wfW2kJHVTtt809o2M23kBVvhmZwKgap19KW7HrDgtbeeY/gyr0ryebb0HMrnO5T++d
         FVhBbGkjD5FBL7pCntEpyRbY+zn4+q7wYRiFQ1CDfYS0MJA6Rjabb/UW6Gw4Le/28rCe
         qnaQY2tUnGNnySaYDmvmhvCLTtgIJ61CExWO+wsNsq835sFdGGnxaI8Prq2R5NjR1I0U
         6IN7D8sp1I0Zn9Wd8e/XDGYLdSnZKUQHLf1rOWgX8lr4TSi60NilAoz6F/mOmerKY9YI
         raqSwGb/sRwrCUVg4EFmjqyHEd8Lyru8VxD6K6HDxcwNDOmEeH6+h/Q9Y7azDE5pZweJ
         Phmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DGKA8rTEAQu8OeSpTEqYi/Di78F+wnsXdQCPCwN2vKk=;
        b=CxpF3DWhlrYTeOVhYW4iqq5JduQfUMP/qnneCVBDHXo7bkZbWlp3X45KdxSw8jLI4l
         UevT6+5oun/4jSInn0bO2iFzV8AYldDh30iv2uEV1/eueB363+yELyHJFFof47NP2DN3
         we8O0Pj2zikXfyoHTmwFcR+UuUnWCgi2N3MpkFuETf5KcDqtPk8Y/Yxr/xiqDnacUAnC
         QyZEKF17jfjYmZFCuUc1+ag0PmAA1qyWY4+kEPthpHwXglpvYfTuekwebUFBtEfXsFh8
         JUJE6o0jbOGznY9C4AoH0t3eA3wihQIcfBSbzK/P3LY8BZP5+2q/4XkzZD52SARUBLcr
         LymQ==
X-Gm-Message-State: AOAM531Qo9jkDZNS1QHWrmF7TfSL6WiItUHqNzlWftxYhDj1DUIOC4d5
        B+BGqazbf1TrkBoSrJj4bXRiwnWjJBl4kxscO2VRGA==
X-Google-Smtp-Source: ABdhPJwDKj+aNcnCL/GUS68QPp1qX8UZdCAC1/ZeGTly+mo3wl7fQ4Ub0l/IxZ4EPPX8fBtxfV2cbXjDH+Ebj6GjHzo=
X-Received: by 2002:a17:906:3a84:: with SMTP id y4mr4319372ejd.340.1632732322981;
 Mon, 27 Sep 2021 01:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210924164530.1754128-1-anders.roxell@linaro.org>
 <c3bdc145-70e7-b504-0437-f451a3e1c5a8@infradead.org> <DM6PR04MB6575F2F6841B0573560E10ADFCA49@DM6PR04MB6575.namprd04.prod.outlook.com>
 <5dab9890-6142-3ac3-424a-1fc169734464@infradead.org>
In-Reply-To: <5dab9890-6142-3ac3-424a-1fc169734464@infradead.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Mon, 27 Sep 2021 10:45:11 +0200
Message-ID: <CADYN=9K=DsJh+ozL1pJyPScSyZvKDTMgZa_aamEU4YRvWYsC9w@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jdelvare@suse.com" <jdelvare@suse.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Sept 2021 at 21:53, Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 9/24/21 11:59 AM, Avri Altman wrote:
> >>> Since fragment 'SCSI_UFS_HWMON' can't be build as a module,
> >>> 'SCSI_UFS_HWMON' has to depend on 'HWMON=y'.
> >>>
> >>> Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature
> >>> notification support")
> >>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> >>> ---
> >>>    drivers/scsi/ufs/Kconfig | 2 +-
> >>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index
> >>> 565e8aa6319d..30c6edb53be9 100644
> >>> --- a/drivers/scsi/ufs/Kconfig
> >>> +++ b/drivers/scsi/ufs/Kconfig
> >>> @@ -202,7 +202,7 @@ config SCSI_UFS_FAULT_INJECTION
> >>>
> >>>    config SCSI_UFS_HWMON
> >>>        bool "UFS  Temperature Notification"
> >>> -     depends on SCSI_UFSHCD && HWMON
> >>> +     depends on SCSI_UFSHCD && HWMON=y
> >>>        help
> >>>          This provides support for UFS hardware monitoring. If enabled,
> >>>          a hardware monitoring device will be created for the UFS device.
>
> Thinking about this, it should be possible to do it like this
> so that both SCSI_UFSHCD=m ad SCSI_HFS_HWMON=m would also work.
> I.e., this would allow more combinations of Kconfig settings to
> work. It only excludes SCSI_UFSH_HWMON=y and HWMON=m
>
> +       depends on SCSI_UFSHCD=HWMON || HWMON=y
>
> OK, I have verified that this works (builds) in all allowed
> combinations.  Anders, would you please resubmit the patch?

Yeah, I'll send the patch.

Cheers,
Anders
