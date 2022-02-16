Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C01C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 01:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242809AbiBPB2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:28:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237686AbiBPB2f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 20:28:35 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43851CA70F
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 17:28:24 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id m185so575399iof.10
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 17:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z2OvqLfZl+hYuGhPphHFvWMwyNyMYmTbKrVX+fI0uIY=;
        b=l2L0Yq/MmnQcdQdl5uLE3DvfmVZ7xQ4V3ugwUP0tsrPIiMuoraWqh0rh6jrpr+TcwZ
         D9mw5ki2sJIdwu4PhOvpx0wwmZP8wkKyF9o1q9Jruvrn6CvdwNBxNnCt+jfOmDlqWUOM
         /gozfRwXNJiZujILSp9Pq4ag51oKWAyTCjO3d1DMPL6c0KiwcdaBVkq6GQ80OCOrrk4E
         zC6JGM4dsrItJxHHz4RYMA99MUnOvF4trl0RbVx0K6AR/oDO9wi3mG3qnxyFOyn2Jw5X
         GG3HRF5nUg69B4P4wkJVqqcGhMHW/ORw20nFzsPVN8ea2Xbyp9AAVlZEMJyUNSD761zl
         EUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z2OvqLfZl+hYuGhPphHFvWMwyNyMYmTbKrVX+fI0uIY=;
        b=ewaynu2Fflm+LLgkf49r+Xu737dbTT1d3hYEsZnkxaucTXEWQ6+HmQgoSnhJVRxxO+
         UMXUmE0FcB73KrAZCxFZ9I2+A3aznIfYVcaeMXiCNOGFmnQJO3DtYhhMGDGcwNI64iWC
         26CEud7Uj+T3S2ZCF216oUmnwldGvAjvIYPKBP1nRV2kKGjKwntj7HeQVeHbflLp1GLO
         iU3WlbfB7B2zMgJSeqQ6cvYyBhGUQUOYByM6PtKvsJsqW3r1knU/e4jd5t+DP9uX3MXf
         1jqp9bBJWZRvXWNcVlWHz9Ha0sOM06l9RcaecRGkQCT5jdRso2rvm9uMnC6+L6d5IuiR
         4STQ==
X-Gm-Message-State: AOAM5307qFf2vIjUtBLePbV4aMfJ6cpcndTAFu3NQOxC3kwMwi8i0CZP
        4bdO+KZVJjOlyculuD0HXx7mpw232cZd6QlGAZc=
X-Google-Smtp-Source: ABdhPJz7DsrPBvGZlDWuLBLGgUZa4AMDb918/ama7iYOx1jfyS9JIKqDPdJqnLBKyunjmRdBHfHe0u8pu28jtx7KyXc=
X-Received: by 2002:a6b:4f07:0:b0:613:f763:7d67 with SMTP id
 d7-20020a6b4f07000000b00613f7637d67mr374953iob.4.1644974903589; Tue, 15 Feb
 2022 17:28:23 -0800 (PST)
MIME-Version: 1.0
References: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
 <828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com>
In-Reply-To: <828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com>
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Wed, 16 Feb 2022 09:28:12 +0800
Message-ID: <CAOOPZo4Z2x_W7i=Vbnm-SsDgj5PndLVtOz6MqRzQxW-NeBwhRg@mail.gmail.com>
Subject: Re: Question about iscsi session block
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        open-iscsi <open-iscsi@googlegroups.com>, dm-devel@redhat.com,
        lduncan@suse.com, leech@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 16, 2022 at 12:31 AM Mike Christie
<michael.christie@oracle.com> wrote:
>
> On 2/15/22 9:49 AM, Zhengyuan Liu wrote:
> > Hi, all
> >
> > We have an online server which uses multipath + iscsi to attach storage
> > from Storage Server. There are two NICs on the server and for each it
> > carries about 20 iscsi sessions and for each session it includes about 50
> >  iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
> >  on the server). The problem is: once a NIC gets faulted, it will take too long
> > (nearly 80s) for multipath to switch to another good NIC link, because it
> > needs to block all iscsi devices over that faulted NIC firstly. The callstack is
> >  shown below:
> >
> >     void iscsi_block_session(struct iscsi_cls_session *session)
> >     {
> >         queue_work(iscsi_eh_timer_workq, &session->block_work);
> >     }
> >
> >  __iscsi_block_session() -> scsi_target_block() -> target_block() ->
> >   device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
> >  blk_mq_quiesce_queue()>synchronize_rcu()
> >
> > For all sessions and all devices, it was processed sequentially, and we have
> > traced that for each synchronize_rcu() call it takes about 80ms, so
> > the total cost
> > is about 80s (80ms * 20 * 50). It's so long that the application can't
> > tolerate and
> > may interrupt service.
> >
> > So my question is that can we optimize the procedure to reduce the time cost on
> > blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
> > workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.
>
> We need a patch, so the unblock call waits/cancels/flushes the block call or
> they could be running in parallel.
>
> I'll send a patchset later today so you can test it.

I'm glad to test once you push the patchset.

Thank you, Mike.
