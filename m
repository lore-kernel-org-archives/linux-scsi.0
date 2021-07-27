Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E72C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 19:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4732260F6B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 19:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhG0TgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbhG0TgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 15:36:10 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF7EC061757;
        Tue, 27 Jul 2021 12:36:08 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so107884wmb.5;
        Tue, 27 Jul 2021 12:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/T1UW9KKkDdZZxMp9zDH9Bd1AZKq8r2LawQzTZBFZfs=;
        b=i/3vFo5EM8cGwVykY8/0meuREc0TTeTSh1ZgS6lPAPGjTe3lrM9Pw7NVTHwGq6ga3o
         P4FjdbPAkNqazWV4IqMnSDK/rEjjyyZmzjh2Z+0sWoI/uIYl/vnL4Ii2VB1i0MaD+z0g
         LaqJTQXTVDD3z8rtOBF3ru7RUUhuLXXE8XhdzHQV06NyH0+zyJIo4dilvS0OF6Y89iT4
         FQorvY5Y4PVAqsNUGl0rOJxn5VZ3oXuj7TDox7DneMyis/LNvzqhSbYfAU8bEjaESPkd
         dyLcUklTsdVL6ZPdHpXeVAEoQMlFh09jMilAe+OyDvHmYswe3uyyi/ZwH73A/Aj3dL8k
         lEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/T1UW9KKkDdZZxMp9zDH9Bd1AZKq8r2LawQzTZBFZfs=;
        b=Sh/Czemz9aAFPeglrsvHe2t0MtJNnVVy/AU7ShdCP7YF219b2cetgLoqB0f4nRbUHc
         TsjcDXiwKmeMofh7mcH32rBh5Bl6qSBEKnmKGypj3dI+FjKmNrmoWPm/SMl9TI0fEg71
         8m5Fw+jEZ5yxe/kwaKTU+T2tFSzA1iu7ZQ7J6yNCSHtV1FPaKjsPJkjIQgh+WmMw6VXS
         fM4BDURWlMbQ3+TbqaKmvmySDxJeBjHd2V0HzHdv5c1C2+cNkbuBMQxWqauf03ivPN3J
         z/bUZATbiwiSJs5ilIaiApeDZnoCRN6BhaGah7hQ6vTzd+vjUKialT4+pO7npZ+Aeu4K
         qBSQ==
X-Gm-Message-State: AOAM5327cTFI0XRA1Cqgl2vnvB0UrV4WggD8O7nU58zjEBFoT2Dw9Rlg
        UHlN2OWUEIjlnSkNh96ursI=
X-Google-Smtp-Source: ABdhPJxf+CP6SZ2z5OI6IO/WcnAiffmHbp8wzi69RVmRzfTmVGunwIlDWuxkVA60qYWK6FnOiVujCw==
X-Received: by 2002:a05:600c:198f:: with SMTP id t15mr5660071wmq.60.1627414567175;
        Tue, 27 Jul 2021 12:36:07 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec25.dynamic.kabel-deutschland.de. [95.91.236.37])
        by smtp.googlemail.com with ESMTPSA id l41sm4423908wmp.23.2021.07.27.12.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 12:36:06 -0700 (PDT)
Message-ID: <8af01dbdfbecf2aa2f35e8c3a5240b2bcf76d9b0.camel@gmail.com>
Subject: Re: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
From:   Bean Huo <huobean@gmail.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        'Krzysztof Kozlowski' <krzk@kernel.org>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     'Can Guo' <cang@codeaurora.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Kiwoong Kim' <kwmad.kim@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        'Christoph Hellwig' <hch@infradead.org>,
        'Bart Van Assche' <bvanassche@acm.org>,
        'jongmin jeong' <jjmin.jeong@samsung.com>,
        'Gyunghoon Kwon' <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org
Date:   Tue, 27 Jul 2021 21:36:05 +0200
In-Reply-To: <004601d782d0$2f43cd20$8dcb6760$@samsung.com>
References: <20210714071131.101204-1-chanho61.park@samsung.com>
         <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
         <20210714071131.101204-15-chanho61.park@samsung.com>
         <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
         <000601d7820a$9aa11210$cfe33630$@samsung.com>
         <602ee8bc56891f0f0429afe274d7174ec325172e.camel@gmail.com>
         <004601d782d0$2f43cd20$8dcb6760$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-07-27 at 19:14 +0900, Chanho Park wrote:
> > > A PH has its own doorbell register and each VHs also has it as
> > > well.
> > > The TASK_TAG[7:5] can be used to distinguish the origin of the
> > > request among VHs and remaining TASK_TAG[4:0] will be used for
> > > supporting 32 tags.
> > > Best Regards,
> > > Chanho Park
> > Thanks for your reply.
> > so you split the "Task Tag" filed byte3 in the UPIU header to two
> > parts, bit7~bit5 is for the VHs ID, and bit4~bit0 is for the task
> > ID.
> > but this is not defined in the Spec 2.1. correct?
> 
> 
> You're right.
> 
> For PH, TASK_TAG[7:5] will be set to "0" but a VHID will be used in
> case of VH.
> 
> 
> 
> Best Regards,
> 
> Chanho Park

Hi Chanho Park,
Thansk for yoru reply.

I didn't see your changes about task_tag and IID. Having a look at
ufshcd_prepare_utp_scsi_cmd_upiu(), the task tag in the UPIU header
is still only task tag. and IID is always 0x00.

If you didn't add these changes, your patch is un-readable, and also
the driver doesn't have a real usage case.


Also, you mentioned there is no support/change needed from the UFS
device side. But, IMO, if you changed the UPIU header, there are
changes needed on the UFS device side in order to use your driver.


Kind regards,
Bean 


