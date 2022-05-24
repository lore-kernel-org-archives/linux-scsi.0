Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C1AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiEXG3i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiEXG3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:29:37 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53C472209
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:29:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f2so24239202wrc.0
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0KfzzJTrDnu9+V7St5lQ99gi7CdINuYwUWUnVmQOYI=;
        b=bCN0nJmuyXhckyqgk+s2/3WaeQUfEIZ97ZZMRWXw9kqvKXgoC2f5Kk8AM1ufLCN5TF
         ep0nQoWc2xWfWshSFmiFcW/ysf8/fTkoty/rIjcC6vnBZ3/DYv/ChEi90Wxla0/ri84B
         Ka+obEdgu/BhF9MhH04tFf0eDX22n6k/HzN4w8IL9m44UbHoB32emTAtOex6MO9FayUf
         qV0g6pLOFirTKMhezJO3vJMJ0yyl0qG3Zq99RsN8WfbD5P6j0Vq19ZClfge5E2/RkE9M
         n4Nbob+nuFTvMl9S1E8IuRwqrgxfyODM1IT7aIzbFNxRJ3F3QY/AQbsXjs/qjZVwopt+
         MDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0KfzzJTrDnu9+V7St5lQ99gi7CdINuYwUWUnVmQOYI=;
        b=Q7jU2KJ9ZgAEMV4u2wMFC1qF+nt7YHHVBSvn8bBo4JR8iVbjED/VmigQs71McE/+Ni
         E7tEVl1+fhg1QDpZcUv/H6R+wPyQRZouXFKKPE0CEbAL8qtq/CqTACV9G44P4mprMqxP
         HwoQBNZiPIxoJ6RwVk0uZ6JSsfa/4yFx4Ag3BFB6H6vTiaZ7sUdtx8o0EJ+zmP4qXA/w
         QiP6QfdJLUrJdwNdvCJ3c5LM4g3aT11Zzoer1MyI28HumC8+Nfce2+ya6EBxHnAqw/0M
         5d38VBtQSJFhNCV4bHR78W9VJrKzCN7rzoWO2KyvHW7dWwwmLDIoOpiO2/8wRg3zCPsw
         pm1Q==
X-Gm-Message-State: AOAM531CN3UgjgWr/xOmeYnTNRcEAYr9lZL9Huyimzc13kEamRLkVeVE
        yz3VZKR8xePDtqOuHbyiEJOE7Rl4ScMR6dFA5ho=
X-Google-Smtp-Source: ABdhPJzoc8SJzNK/+30i+3SovXvrcAvAJQfZIg0PL7ZISuVlVsZo9PDmjZD6+1/2I+JaOXOBXIShmAtRptw4HPqfj1s=
X-Received: by 2002:a5d:6b07:0:b0:20d:97f:ca6b with SMTP id
 v7-20020a5d6b07000000b0020d097fca6bmr21420959wrw.390.1653373774400; Mon, 23
 May 2022 23:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
 <828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com> <CAOOPZo4Z2x_W7i=Vbnm-SsDgj5PndLVtOz6MqRzQxW-NeBwhRg@mail.gmail.com>
 <be26ef80-c3cf-713d-2a9f-4fb73cec7e17@oracle.com> <ec8d0b97-e94a-21e1-acdb-e90a7df39b72@oracle.com>
In-Reply-To: <ec8d0b97-e94a-21e1-acdb-e90a7df39b72@oracle.com>
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Tue, 24 May 2022 14:29:22 +0800
Message-ID: <CAOOPZo58sfhqFEMvpUfnoU1ceHDpPnagMbPvDGrDXHZHq7bZLg@mail.gmail.com>
Subject: Re: Question about iscsi session block
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        open-iscsi <open-iscsi@googlegroups.com>, dm-devel@redhat.com,
        lduncan@suse.com, leech@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Mike,

Sorry for the delayed reply since I have no  environment to check your
bellow patcheset untile recently

https://lore.kernel.org/all/20220226230435.38733-1-michael.christie@oracle.com/

After applied those series, the total time has dropped from 80s to
nearly 10s, it's a great improvement.

Thanks, again

On Sun, Feb 27, 2022 at 7:00 AM Mike Christie
<michael.christie@oracle.com> wrote:
>
> On 2/15/22 8:19 PM, michael.christie@oracle.com wrote:
> > On 2/15/22 7:28 PM, Zhengyuan Liu wrote:
> >> On Wed, Feb 16, 2022 at 12:31 AM Mike Christie
> >> <michael.christie@oracle.com> wrote:
> >>>
> >>> On 2/15/22 9:49 AM, Zhengyuan Liu wrote:
> >>>> Hi, all
> >>>>
> >>>> We have an online server which uses multipath + iscsi to attach storage
> >>>> from Storage Server. There are two NICs on the server and for each it
> >>>> carries about 20 iscsi sessions and for each session it includes about 50
> >>>>  iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
> >>>>  on the server). The problem is: once a NIC gets faulted, it will take too long
> >>>> (nearly 80s) for multipath to switch to another good NIC link, because it
> >>>> needs to block all iscsi devices over that faulted NIC firstly. The callstack is
> >>>>  shown below:
> >>>>
> >>>>     void iscsi_block_session(struct iscsi_cls_session *session)
> >>>>     {
> >>>>         queue_work(iscsi_eh_timer_workq, &session->block_work);
> >>>>     }
> >>>>
> >>>>  __iscsi_block_session() -> scsi_target_block() -> target_block() ->
> >>>>   device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
> >>>>  blk_mq_quiesce_queue()>synchronize_rcu()
> >>>>
> >>>> For all sessions and all devices, it was processed sequentially, and we have
> >>>> traced that for each synchronize_rcu() call it takes about 80ms, so
> >>>> the total cost
> >>>> is about 80s (80ms * 20 * 50). It's so long that the application can't
> >>>> tolerate and
> >>>> may interrupt service.
> >>>>
> >>>> So my question is that can we optimize the procedure to reduce the time cost on
> >>>> blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
> >>>> workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.
> >>>
> >>> We need a patch, so the unblock call waits/cancels/flushes the block call or
> >>> they could be running in parallel.
> >>>
> >>> I'll send a patchset later today so you can test it.
> >>
> >> I'm glad to test once you push the patchset.
> >>
> >> Thank you, Mike.
> >
> > I forgot I did this recently :)
> >
> > commit 7ce9fc5ecde0d8bd64c29baee6c5e3ce7074ec9a
> > Author: Mike Christie <michael.christie@oracle.com>
> > Date:   Tue May 25 13:18:09 2021 -0500
> >
> >     scsi: iscsi: Flush block work before unblock
> >
> >     We set the max_active iSCSI EH works to 1, so all work is going to execute
> >     in order by default. However, userspace can now override this in sysfs. If
> >     max_active > 1, we can end up with the block_work on CPU1 and
> >     iscsi_unblock_session running the unblock_work on CPU2 and the session and
> >     target/device state will end up out of sync with each other.
> >
> >     This adds a flush of the block_work in iscsi_unblock_session.
> >
> >
> > It was merged in 5.14.
>
> Hey, I found one more bug when max_active > 1. While fixing it I decided to just
> fix this so we can do the sessions recoveries in parallel and the user doesn't have
> to worry about setting max_active.
>
> I'll send a patchset and cc you.
