Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB351C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BDE520738
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="h9KJJm0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGGOpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGGOpl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:45:41 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744CDC08C5E1
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:45:41 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id u12so31877845qth.12
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=5D+pvkC5aJUjwZoNWdXeCSBjk1BaS4KK9hwaSABQcc8=;
        b=h9KJJm0cr1VS63a9OEj6A5qixzQ81j1c3nldTSyVIqfkTLwwvEwRiuL/Abq/ybBh5E
         O55VEt//SAfXPkIpp9Fu/zF6QtghZ66UBzajHKiczNuNSI36f7XaKoGUMKJmzybX7vqu
         hvASI7ZEjfaGIfPErEOi0GL8dXtj/qCebZQ8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=5D+pvkC5aJUjwZoNWdXeCSBjk1BaS4KK9hwaSABQcc8=;
        b=Dl2hkHQTVvTfjB/aSQ39KjyxeZZPWbLJIIv4Xq7UaheQ6p0InlUPg8KNqecwh88YU4
         bajJi7SPit3eKnxPtZI+8lnPPOCsolNEuuzb5K67ZVt0TkmSxswgB+x/iKfY/PQ8Umrd
         o7BTattWv3gs+APAMHVvXDuW508Xk/9uI0S7hoJ8ORXIgq4jb21PHjzvqM236QWRoUn/
         BrVJNjcsPeySVr3erz+xOGC55sc7r8B59KkBOkw44CmARk0FF3HH3tk/TOT9zEF746Rs
         +7ahVeZoPvxW1GGupu+P4E0sAA3Fokshtsw2cH8PGkaQ7bl9KI98bXeEQmdAza+McPFm
         O1Zw==
X-Gm-Message-State: AOAM5337HFxP0tpRc+Y3hLtEE0bj3hdRo/ln8XlDkPFWy11n4ZbDOEpk
        n0fkpUkRkhBrgakkYDC9NtHDa7oKiGkqMWb9lWgjOg==
X-Google-Smtp-Source: ABdhPJxhcsjBQeImWRnQbmyn2NgtRg7hC21L/JP4pMQ9PEYdh6zGtLr7Url5l0IQgb5y3q9VrrA7aurSWj36VaDNego=
X-Received: by 2002:ac8:44ad:: with SMTP id a13mr48534643qto.387.1594133140334;
 Tue, 07 Jul 2020 07:45:40 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com> <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com> <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
In-Reply-To: <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgFIs823Ad7lfqMBmFaE1AGZowweAlKrFcWruFpUEA==
Date:   Tue, 7 Jul 2020 20:15:34 +0530
Message-ID: <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com>
Subject: RE: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        ming.lei@redhat.com, bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >>>
> >>>    #include <scsi/scsi.h>
> >>>    #include <scsi/scsi_cmnd.h>
> >>> @@ -113,6 +114,10 @@ unsigned int enable_sdev_max_qd;
> >>>    module_param(enable_sdev_max_qd, int, 0444);
> >>>    MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as
> >> can_queue.
> >>> Default: 0");
> >>>
> >>> +int host_tagset_disabled = 0;
> >>> +module_param(host_tagset_disabled, int, 0444);
> >>> +MODULE_PARM_DESC(host_tagset_disabled, "Shared host tagset
> >> enable/disable
> >>> Default: enable(1)");
> >> The logic seems inverted here: for passing 1, I would expect Shared
> >> host tagset enabled, while it actually means to disable, right?
> > No. passing 1 means shared_hosttag support will be turned off.
>
> Just reading "Shared host tagset enable/disable Default: enable(1)"
> looked inconsistent to me.

I will change to "host_tagset_enable" that will be good for readability.
Default value will of host_tagset_enable will be 1 and user can turnoff
passing 0.

>
> >>> +
> >>>    MODULE_LICENSE("GPL");
> >>>    MODULE_VERSION(MEGASAS_VERSION);
> >>>    MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
> >>> @@ -3115,6 +3120,18 @@ megasas_bios_param(struct scsi_device
> *sdev,
> >> struct
> >>> block_device *bdev,
> >>>           return 0;
> >>>    }
> >>>
> >>> +static int megasas_map_queues(struct Scsi_Host *shost) {
> >>> +       struct megasas_instance *instance;
> >>> +       instance = (struct megasas_instance *)shost->hostdata;
> >>> +
> >>> +       if (instance->host->nr_hw_queues == 1)
> >>> +               return 0;
> >>> +
> >>> +       return
> >>> blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> >>> +                       instance->pdev,
> >>> instance->low_latency_index_start);
> >>> +}
> >>> +
> >>>    static void megasas_aen_polling(struct work_struct *work);
> >>>
> >>>    /**
> >>> @@ -3423,8 +3440,10 @@ static struct scsi_host_template
> >> megasas_template =
> >>> {
> >>>           .eh_timed_out = megasas_reset_timer,
> >>>           .shost_attrs = megaraid_host_attrs,
> >>>           .bios_param = megasas_bios_param,
> >>> +       .map_queues = megasas_map_queues,
> >>>           .change_queue_depth = scsi_change_queue_depth,
> >>>           .max_segment_size = 0xffffffff,
> >>> +       .host_tagset = 1,
> >> Is your intention to always have this set for Scsi_Host, and just
> >> change nr_hw_queues?
> > Actually I wanted to turn off  this feature using host_tagset and not
> > through nr_hw_queue. I will address this.
> >
> > Additional request -
> > In MR we have old controllers (called MFI_SERIES). We prefer not to
> > change behavior for those controller.
> > Having host_tagset in template does not allow to cherry pick different
> > values for different type of controller.
>
> Ok, so it seems sensible to add host_tagset to Scsi_Host structure also,
> to
> allow overwriting during probe time.
>
> If you want to share an updated megaraid sas driver patch based on that,
> then
> that's fine. I can incorporate that change in the patch where we add
> host_tagset to the scsi host template.

If you share git repo link of next submission, I can send you megaraid_sas
driver patch which you can include in series.

Kashyap
>
> > If host_tagset is part of Scsi_Host OR we add check in scsi_lib.c that
> > host_tagset = 1 only make sense if nr_hw_queues > 1, we can cherry
> > pick in driver.
> >
> >
>
>
