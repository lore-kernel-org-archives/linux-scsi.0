Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481D7C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2534D20702
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 19:19:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Axwkw4M4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgGFTTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGFTTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 15:19:08 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39A5C061794
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 12:19:07 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di5so12813009qvb.11
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2020 12:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=IMTEDx3OLD2t+CwoQ4fSNXOiFFIP3cldbJArfJAQ1Dc=;
        b=Axwkw4M4Nqeq+0OqefJs4AMublNX/R6QwjD48x1PYEXRfi44yMuaONRIAmXP48tjMq
         Bw1LfM0x7cM2+KEOJAQwC24vHqpx3Z0aD/zdoovd4jRL443bKnNgAcNF1F1huHp6QD44
         4fkpwVLOUnyHfugIqjylh4+Ix6sEbrV14g5dE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=IMTEDx3OLD2t+CwoQ4fSNXOiFFIP3cldbJArfJAQ1Dc=;
        b=lveaGj9ja9DWboYHT30t5+yFSsULUSjpJfnfsaWFs2g3L4dHDdMlc3pXLIaGeBqWpU
         bpxeEi9yaGLqp8po4wxsA/0kw9MA+dlxp19qkxhQCMocTnzqEImpucP8CgCJczmLesye
         oJet8Iqh4twSQ4QBNx1b1jU1P3Dz+ks1VSe0+9YV4HCuNLiIIfxu/QdkqDXe+NZnL27A
         i/+SBkLvTyggUzfxEMnvzu3BjEB8gB+h2wIws5e90mo+t4i7NRbw38gk0o45RKNFXUoW
         H6VH3tAj9yWGOlJh3YWB/29jd22ZsVvE5W2NY8QIF9eoSdxOWZ5qToxvyVbq1EuV+n8d
         0dKA==
X-Gm-Message-State: AOAM533kQP36ly6grOgn4Bk5G8kEDwh960b2cSOhxrxfOcukvi96fedt
        qhg8EAHmP32MsKOB31mcK0Be4smBypoPnLW1tsLnGA==
X-Google-Smtp-Source: ABdhPJwOvfTw19EJFLnptFhR7TaEABT23useSDZasSgmY+L6LTELtXeRvDdaiXkaXetMdG7ufW+sutfVTGacw/q4tSM=
X-Received: by 2002:ad4:57c7:: with SMTP id y7mr49686587qvx.124.1594063146034;
 Mon, 06 Jul 2020 12:19:06 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com> <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
In-Reply-To: <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgFIs823Ad7lfqMBmFaE1KvWc1SA
Date:   Tue, 7 Jul 2020 00:49:03 +0530
Message-ID: <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
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

>
> On 02/07/2020 11:23, Kashyap Desai wrote:
> >>
> >> From: Hannes Reinecke <hare@suse.com>
> >>
> >> Fusion adapters can steer completions to individual queues, and we
> >> now
> > have
> >> support for shared host-wide tags.
> >> So we can enable multiqueue support for fusion adapters and drop the
> > hand-
> >> crafted interrupt affinity settings.
> >
> > Shared host tag is primarily introduced for completeness of CPU
> > hotplug as discussed earlier - https://lwn.net/Articles/819419/
> >
> > How shall I test CPU hotplug on megaraid_sas driver ?
>
> I have scripts like this:
>
> ----8<-----
>
> # hotplug.sh
> # enable all cpus in the system
> ./enable_all.sh
>
> for((i = 0; i < 50 ; i++))
> do
> echo "Looping ... number $i"
> # run fio on all cpus with 40 second runtime ./create_fio_task_cpu.sh 4k
> read
> 2048 1& echo "short sleep, then disable"
> sleep 5
> # disable some set of cpus which means managed interrupts get shutdown #
> like cpu1-50 from 0-63 ./disable_all.sh echo "long sleep $i"
> sleep 50
> echo "long sleep over number $i"
> ./enable_all.sh
> sleep 3
> done
>
> ----->8-----
>
> # enable_all.sh
> for((i=0; i<63; i++))
> do
> echo 1 > /sys/devices/system/cpu/cpu$i/online
> done
>
> --->8----
>
> I hope to add such a test to blktests when I get a chance.
>
> > My understanding is
> > - This RFC + patch set from above link is required for it. I could not
> > see above series is committed.
>
> It is committed and part of 5.8-rc1
>
> The latest rc should have some scheduler fixes also.
>
> I also note that there has been much churn on blk-mq tag code lately, and
> something may be broken, so I plan to verify latest rc myself soon.

Thanks. I will try merging 5.8-rc1 and RFC and see how CPU hot plug works.

>
> > Am I missing anything. ?
>
> You could also add this from Hannes (and add megaraid sas support):
>
> https://lore.kernel.org/linux-scsi/20200629072021.9864-1-
> hare@suse.de/T/#t
>
> That is, if it is required. I am not sure if megaraid sas uses "internal"
> commands which needs to be guarded against cpu hotplug. Nor would any of
> these commands be used during a test. For hisi_sas testing, I did not
> bother
> adding support, and I guess that you don't need to either.

Megaraid driver use internal command but it is excluded from can_queue.
All internal command are mapped to msix index 0, which is non-managed. So we
are good w.r.t internal command.

>
> >
> > We do not want to completely move to shared host tag. It will be shared
> > host tag support by default, but user should have choice to go back to
> > legacy path.
> > We will completely move to shared host tag path once it is stable and no
> > more field issue observed over a period of time. -
> >
> > Updated <megaraid_sas> patch will looks like this -
> >
> > diff --git a/megaraid_sas_base.c b/megaraid_sas_base.c
> > index 0066833..3b503cb 100644
> > --- a/megaraid_sas_base.c
> > +++ b/megaraid_sas_base.c
> > @@ -37,6 +37,7 @@
> >   #include <linux/poll.h>
> >   #include <linux/vmalloc.h>
> >   #include <linux/irq_poll.h>
> > +#include <linux/blk-mq-pci.h>
> >
> >   #include <scsi/scsi.h>
> >   #include <scsi/scsi_cmnd.h>
> > @@ -113,6 +114,10 @@ unsigned int enable_sdev_max_qd;
> >   module_param(enable_sdev_max_qd, int, 0444);
> >   MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as
> can_queue.
> > Default: 0");
> >
> > +int host_tagset_disabled = 0;
> > +module_param(host_tagset_disabled, int, 0444);
> > +MODULE_PARM_DESC(host_tagset_disabled, "Shared host tagset
> enable/disable
> > Default: enable(1)");
>
> The logic seems inverted here: for passing 1, I would expect Shared host
> tagset enabled, while it actually means to disable, right?

No. passing 1 means shared_hosttag support will be turned off.
>
> > +
> >   MODULE_LICENSE("GPL");
> >   MODULE_VERSION(MEGASAS_VERSION);
> >   MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
> > @@ -3115,6 +3120,18 @@ megasas_bios_param(struct scsi_device *sdev,
> struct
> > block_device *bdev,
> >          return 0;
> >   }
> >
> > +static int megasas_map_queues(struct Scsi_Host *shost)
> > +{
> > +       struct megasas_instance *instance;
> > +       instance = (struct megasas_instance *)shost->hostdata;
> > +
> > +       if (instance->host->nr_hw_queues == 1)
> > +               return 0;
> > +
> > +       return
> > blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> > +                       instance->pdev,
> > instance->low_latency_index_start);
> > +}
> > +
> >   static void megasas_aen_polling(struct work_struct *work);
> >
> >   /**
> > @@ -3423,8 +3440,10 @@ static struct scsi_host_template
> megasas_template =
> > {
> >          .eh_timed_out = megasas_reset_timer,
> >          .shost_attrs = megaraid_host_attrs,
> >          .bios_param = megasas_bios_param,
> > +       .map_queues = megasas_map_queues,
> >          .change_queue_depth = scsi_change_queue_depth,
> >          .max_segment_size = 0xffffffff,
> > +       .host_tagset = 1,
>
> Is your intention to always have this set for Scsi_Host, and just change
> nr_hw_queues?

Actually I wanted to turn off  this feature using host_tagset and not
through nr_hw_queue. I will address this.

Additional request -
In MR we have old controllers (called MFI_SERIES). We prefer not to change
behavior for those controller.
Having host_tagset in template does not allow to cherry pick different
values for different type of controller.
If host_tagset is part of Scsi_Host OR we add check in scsi_lib.c that
host_tagset = 1 only make sense if nr_hw_queues > 1, we can cherry pick in
driver.


>
> >   };
> >
> >   /**
> > @@ -6793,7 +6812,21 @@ static int megasas_io_attach(struct
> > megasas_instance *instance)
> >          host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
> >          host->max_lun = MEGASAS_MAX_LUN;
> >          host->max_cmd_len = 16;
> > +       host->nr_hw_queues = 1;
> >
> > +       /* Use shared host tagset only for fusion adaptors
> > +        * if there are more than one managed interrupts.
> > +        */
> > +       if ((instance->adapter_type != MFI_SERIES) &&
> > +               (instance->msix_vectors > 0) &&
> > +               !host_tagset_disabled &&
> > +               instance->smp_affinity_enable)
> > +               host->nr_hw_queues = instance->msix_vectors -
> > +                       instance->low_latency_index_start;
> > +
> > +       dev_info(&instance->pdev->dev, "Max firmware commands: %d"
> > +               " for nr_hw_queues = %d\n", instance->max_fw_cmds,
> > +               host->nr_hw_queues);
>
> note: it may be good for us to add a nr_hw_queues file to scsi host
> sysfs folder

I will accommodate this.

>
> >          /*
> >           * Notify the mid-layer about the new controller
> >           */
> > @@ -8842,6 +8875,7 @@ static int __init megasas_init(void)
> >                  msix_vectors = 1;
> >                  rdpq_enable = 0;
> >                  dual_qdepth_disable = 1;
> > +               host_tagset_disabled = 1;
> >          }
> >
>
> Thanks,
> John
