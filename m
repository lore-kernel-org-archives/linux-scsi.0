Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0B2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 15:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbiBOPt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 10:49:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239088AbiBOPt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 10:49:27 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59604C23
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 07:49:17 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id e11so14188450ils.3
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 07:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PAKLLZo4d0SXE1xp9xl26Jdcj+uTN+GVetCZ7RxOyN4=;
        b=cEUW/9AS7sJb6tjtjk3CZvsxYZKuTduFHKiRZcriKyMw2jnEFMxL9q/uI9zrMB4Fjh
         yJobRRUA50qRfHiCEeH4QJ4/TwPb04VAi+crIPwoJvYcrf89hFhHNT93qxYNs/XLrBYS
         8cbZFftzrg3w6VMxMDXAcAfr1x8wcihQdiTP5uv/giQ3SCLh8Ghjwx4Y9Prid9Vzz/jp
         9EqgskKq3u8nZAQsvM3md5sTLIRA6Q4pMymprOJ8kBIaAseVcRY6Nl3QklLWMJKm+HUm
         xVxsils4qdUjrK8CfNKtDxaYIFps+Z1Z6HLuynyETGh3glhnkarLXCcKlWkKGO34GXWu
         SvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PAKLLZo4d0SXE1xp9xl26Jdcj+uTN+GVetCZ7RxOyN4=;
        b=tJ3f3LN0ao/NaMWKN1tu78IZ7Ht96adft2DNJqMfeMyXxcdmal3IptvHMirl7psTSD
         CmH1aMlgY9A+vlgRHdN5zyZryRjYcUezXu4Nhb1S5XftVYbgGmNCgRwClaFgHGpWDGxp
         Z+7zpEpTiaY4b1Q7kkQIbKdrhIr1mAr6DGQozPobaja2uXDLmWGmLPs87WGNxAr4iM1y
         84FniD++QIXx3LdGOruiuoQa2erKRrbNRKxQB412me2AzS29IzY9a02TA/QadNN9GLHM
         bDc4PCEuMJ86gxB2zfap1xdIueZIqQlNakngIbCYyurdd6uUKuL3Om0mcS4tU5rcuHoh
         XjFQ==
X-Gm-Message-State: AOAM531kSy8ayDbInxqundyHszUWBe5IHNV2vzjjDZ+8UTtWUCiLvBH9
        fUkD5D23RUSlLKaDYpHtDrkeebJE4+noahlnENL5jxSecfI=
X-Google-Smtp-Source: ABdhPJyBbBvZmOMe+/H8pQFYg+ZvQ5o8Kgoz6qJc+VMjzJNOqAfk8ysifocmn9HLhTNqvNtlaJchErbrLWbOS4zxkr8=
X-Received: by 2002:a05:6e02:1bed:: with SMTP id y13mr2883374ilv.27.1644940156693;
 Tue, 15 Feb 2022 07:49:16 -0800 (PST)
MIME-Version: 1.0
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Tue, 15 Feb 2022 23:49:05 +0800
Message-ID: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
Subject: Question about iscsi session block
To:     linux-scsi@vger.kernel.org,
        open-iscsi <open-iscsi@googlegroups.com>, dm-devel@redhat.com
Cc:     lduncan@suse.com, leech@redhat.com, bob.liu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, all

We have an online server which uses multipath + iscsi to attach storage
from Storage Server. There are two NICs on the server and for each it
carries about 20 iscsi sessions and for each session it includes about 50
 iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
 on the server). The problem is: once a NIC gets faulted, it will take too long
(nearly 80s) for multipath to switch to another good NIC link, because it
needs to block all iscsi devices over that faulted NIC firstly. The callstack is
 shown below:

    void iscsi_block_session(struct iscsi_cls_session *session)
    {
        queue_work(iscsi_eh_timer_workq, &session->block_work);
    }

 __iscsi_block_session() -> scsi_target_block() -> target_block() ->
  device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
 blk_mq_quiesce_queue()>synchronize_rcu()

For all sessions and all devices, it was processed sequentially, and we have
traced that for each synchronize_rcu() call it takes about 80ms, so
the total cost
is about 80s (80ms * 20 * 50). It's so long that the application can't
tolerate and
may interrupt service.

So my question is that can we optimize the procedure to reduce the time cost on
blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.

Thanks in advance.
