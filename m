Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D41C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 19:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2E2E61288
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 19:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhEKTnh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 15:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhEKTng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2021 15:43:36 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7FDC06174A
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 12:42:29 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id e190so27833109ybb.10
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 12:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4HaFVpEtFrWdih4zuNGE9Q1f9zE42ljQv2KzL0/SZg4=;
        b=DHC/+a4uNbTQF70FhiC5twYyGPonPbkff8n3WwAYu6EyqcatlgxR5vtMdZcRNYLDsk
         nihWYomR51WCKe3g5OUcE5LQozK07c+TGNixVd/iSA2flYALYjy0RKUHKaX1sXcxjXkp
         JW/4hAj4dHNGC8Hr1QTcE50s6e/MRJuttPjVLJ3I41uiXvQeUvZw2lrIg0aVhjm0BWC1
         SZP3J26zo1S9XcrDlrhX+6O06c5m3fNf7JWnAI/DuHdnjm/bc6dzneEX+vrkpQ5HqNe7
         HQbL/djmJGlaZVRuoFOw72WhaVzMN/f8/UHVrjJ/AWU/6sCV4pYIQRjDYK24lumCOzwE
         lf6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4HaFVpEtFrWdih4zuNGE9Q1f9zE42ljQv2KzL0/SZg4=;
        b=qgNZzmmAXFAT7dckVyygNEINvBGNS+PQaeDg2q8PSvwCQrvz5QVBYVCVZubeCzk0nm
         mbhU7IChgmf6sCTTc7qKNW7yzVybMqXgCVD4Dj0NADqWC2duQTUgwKR6k5AiUUzWUACc
         GNu/N7LloUAaN2l8QgrJssR4qrimhsb5bk2WItZJZyM5ltJORuF90PwRFMA46sXOdA/A
         FYXKd1OwtwU4re9Bh/eZ45127rD/lR5XaxoLI6hno9UrIeC1VgunY6lxV/AwoMpO5+7U
         GrbuLF2vcPdiTii/CAijWbjsfFmbBRZAnKCB6W6exWE1KcfUYdLHFiYCpb7v4UkmbJWX
         uKVA==
X-Gm-Message-State: AOAM531gv9nD56j0/3AJiH+4stbnO8nzf2dprgBIyrAHjNpZNEWn3Mhf
        BvvjQbWQQtKkVc0EEwM2ZEi/IsgWf9q3+dwXQFc+Xg==
X-Google-Smtp-Source: ABdhPJzY2muPky7bmsJLRqbQyPZeYYjZNpXbYjXPW66yL3be4Ruaq8grrpeZO14QJfwa7fGHMRtegwGoFphnUbuEdRE=
X-Received: by 2002:a25:aa14:: with SMTP id s20mr32344643ybi.228.1620762148772;
 Tue, 11 May 2021 12:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <3c88cf35-6725-1bfa-9e1e-8e9d69147e3b@hisilicon.com>
 <2e69efb9-a563-251f-2161-5546324a9587@hisilicon.com> <CAGETcx9FLixotMcyJmCATSoz7aB2VbYSr8o5jyM5HDd9-6LaYQ@mail.gmail.com>
 <11749ea2-777c-e200-9c5a-eab531c7e69a@intel.com>
In-Reply-To: <11749ea2-777c-e200-9c5a-eab531c7e69a@intel.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 11 May 2021 12:41:52 -0700
Message-ID: <CAGETcx_iXjYUOipQ1ky-J=4TSx+HJePeYcPkuGkuv7=JYsiaVQ@mail.gmail.com>
Subject: Re: Question about device link//Re: Qestion about device link
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>, linuxarm@huawei.com,
        linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 11, 2021 at 12:13 PM Rafael J. Wysocki
<rafael.j.wysocki@intel.com> wrote:
>
> On 5/11/2021 8:23 PM, Saravana Kannan wrote:
> > On Tue, May 11, 2021 at 3:42 AM chenxiang (M) <chenxiang66@hisilicon.co=
m> wrote:
> >> Re-edit the non-aligned flowchart and add CC to Greg-KH and Saravanna.
> >>
> >>
> >> =E5=9C=A8 2021/5/11 11:59, chenxiang (M) =E5=86=99=E9=81=93:
> >>> Hi Rafael and other guys,
> >>>
> >>> I am trying to add a device link between scsi_host->shost_gendev and
> >>> hisi_hba->dev to support runtime PM for hisi_hba driver
> >>>
> >>> (as it supports runtime PM for scsi host in some scenarios such as
> >>> error handler etc, we can avoid to do them again if adding a
> >>>
> >>> device link between scsi_host->shost_gendev and hisi_hba->dev) as
> >>> follows (hisi_sas driver is under directory drivers/scsi/hisi_sas):
> >>>
> >>> device_link_add(&shost->shost_gendev, hisi_hba->dev,
> >>> DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)
> >>>
> >>> We have a full test on it, and it works well except when rmmod the
> >>> driver, some call trace occurs as follows:
> >>>
> >>> [root@localhost ~]# rmmod hisi_sas_v3_hw
> >>> [  105.377944] BUG: scheduling while atomic: kworker/113:1/811/0x0000=
0201
> >>> [  105.384469] Modules linked in: bluetooth rfkill ib_isert
> >>> iscsi_target_mod ib_ipoib ib_umad iptable_filter vfio_iommu_type1
> >>> vfio_pci vfio_virqfd vfio rpcrdma ib_is                         er
> >>> libiscsi scsi_transport_iscsi crct10dif_ce sbsa_gwdt hns_roce_hw_v2
> >>> hisi_sec2 hisi_hpre hisi_zip hisi_qm uacce spi_hisi_sfc_v3xx
> >>> hisi_trng_v2 rng_core hisi_uncore                         _hha_pmu
> >>> hisi_uncore_ddrc_pmu hisi_uncore_l3c_pmu spi_dw_mmio hisi_uncore_pmu
> >>> hns3 hclge hnae3 hisi_sas_v3_hw(-) hisi_sas_main libsas
> >>> [  105.424841] CPU: 113 PID: 811 Comm: kworker/113:1 Kdump: loaded
> >>> Tainted: G        W         5.12.0-rc1+ #1
> >>> [  105.434454] Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS
> >>> 2280-V2 CS V5.B143.01 04/22/2021
> >>> [  105.443287] Workqueue: rcu_gp srcu_invoke_callbacks
> >>> [  105.448154] Call trace:
> >>> [  105.450593]  dump_backtrace+0x0/0x1a4
> >>> [  105.454245]  show_stack+0x24/0x40
> >>> [  105.457548]  dump_stack+0xc8/0x104
> >>> [  105.460939]  __schedule_bug+0x68/0x80
> >>> [  105.464590]  __schedule+0x73c/0x77c
> >>> [  105.465700] BUG: scheduling while atomic: kworker/96:1/791/0x00000=
201
> >>> [  105.468066]  schedule+0x7c/0x110
> >>> [  105.468068]  schedule_timeout+0x194/0x1d4
> >>> [  105.474490] Modules linked in:
> >>> [  105.477692]  wait_for_completion+0x8c/0x12c
> >>> [  105.477695]  rcu_barrier+0x1e0/0x2fc
> >>> [  105.477697]  scsi_host_dev_release+0x50/0xf0
> >>> [  105.477701]  device_release+0x40/0xa0
> >>> [  105.477704]  kobject_put+0xac/0x100
> >>> [  105.477707]  __device_link_free_srcu+0x50/0x74
> >>> [  105.477709]  srcu_invoke_callbacks+0x108/0x1a4
> >>> [  105.484743]  process_one_work+0x1dc/0x48c
> >>> [  105.492468]  worker_thread+0x7c/0x464
> >>> [  105.492471]  kthread+0x168/0x16c
> >>> [  105.492473]  ret_from_fork+0x10/0x18
> >>> ...
> >>>
> >>> After analyse the process, we find that it will
> >>> device_del(&shost->gendev) in function scsi_remove_host() and then
> >>>
> >>> put_device(&shost->shost_gendev) in function scsi_host_put() when
> >>> removing the driver, if there is a link between shost and hisi_hba->d=
ev,
> >>>
> >>> it will try to delete the link in device_del(), and also will
> >>> call_srcu(__device_link_free_srcu) to put_device() link->consumer and
> >>> supplier.
> >>>
> >>> But if put device() for shost_gendev in device_link_free() is later
> >>> than in scsi_host_put(), it will call scsi_host_dev_release() in
> >>>
> >>> srcu_invoke_callbacks() while it is atomic and there are scheduling i=
n
> >>> scsi_host_dev_release(),
> >>>
> >>> so it reports the BUG "scheduling while atomic:...".
> >>>
> >>> thread 1                                                   thread2
> >>> hisi_sas_v3_remove
> >>>      ...
> >>>      sas_remove_host()
> >>>          ...
> >>>          scsi_remove_host()
> >>>              ...
> >>>              device_del(&shost->shost_gendev)
> >>>                  ...
> >>>                  device_link_purge()
> >>>                      __device_link_del()
> >>>                          device_unregister(&link->link_dev)
> >>>                              devlink_dev_release
> >>> call_srcu(__device_link_free_srcu)    ----------->
> >>> srcu_invoke_callbacks  (atomic)
> >>>          __device_link_free_srcu
> >>>      ...
> >>>      scsi_host_put()
> >>>          put_device(&shost->shost_gendev) (ref =3D 1)
> >>>                  device_link_free()
> >>>                                put_device(link->consumer)
> >>> //shost->gendev ref =3D 0
> >>>                                            ...
> >>>                                            scsi_host_dev_release
> >>>                                                        ...
> >>> rcu_barrier
> >>> kthread_stop()
> >> Re-edit the non-aligned flowchart
> >>       thread 1 thread 2
> >>       hisi_sas_v3_remove()
> >>               ...
> >>               sas_remove_host()
> >>                       ...
> >>                       device_del(&shost->shost_gendev)
> >>                               ...
> >>                               device_link_purge()
> >>                                       __device_link_del()
> >> device_unregister(&link->link_dev)
> >> devlink_dev_release
> >> call_srcu(__device_link_free_srcu)    ----------->
> >> srcu_invoke_callbacks  (atomic)
> >>               __device_link_free_srcu()
> >>               ...
> >>               scsi_host_put()
> >>                       put_device(&shost->shost_gendev) (ref =3D 1)
> >>                           device_link_free()
> >>                                       put_device(link->consumer)
> >> //shost->gendev ref =3D 0
> >>                                                   ...
> >> scsi_host_dev_release()
> >>                                                               ...
> >> rcu_barrier()
> >> kthread_stop()
> >>
> >>>
> >>> We can check kref of shost->shost_gendev to make sure scsi_host_put()
> >>> to release scsi host device in LLDD driver to avoid the issue,
> >>>
> >>> but it seems be a common issue:  function __device_link_free_srcu
> >>> calls put_device() for consumer and supplier,
> >>>
> >>> but if it's ref =3D0 at that time and there are scheduling or sleep i=
n
> >>> dev_release, it may have the issue.
> >>>
> >>> Do you have any idea about the issue?
> > Another report for the same issue.
> > https://lore.kernel.org/lkml/CAGETcx80xSZ8d4JbZqiSz4L0VNtL+HCnFCS2u3F9a=
NC0QQoQjg@mail.gmail.com/
> >
> > I don't have enough context yet about the need for SRCU (I haven't
> > read up all the runtime PM code), but this is a real issue that needs
> > to be solved.
> >
> > Dirty/terrible hack is to kick off another work to do the
> > put_device().
>
> I wouldn't call it dirty or terrible, but it may just be the thing that
> needs to be done here.
>
>
> > But is there any SRCU option that'll try to do the
> > release in a non-atomic context?
>
> No, the callbacks are run from a softirq if I'm not mistaken.

Right, I meant that this seems like a common thing some SRCU callbacks
might want to do. So, I thought that there might be a flag or option
to kick off work for srcu callbacks. Also, the stack trace shows that
this is already running in a work context but the callback is wrapped
with local_bh_disable/enable() and that's the reason for this warning.
But I don't know enough about SRCU implementation to make a comment on
whether "run stuff in a work queue" can be a generic SRCU feature.

Anyway, if kicking off a new work is what you want to do, I'm not
going to oppose that.

-Saravana
