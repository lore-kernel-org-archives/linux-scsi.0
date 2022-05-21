Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7232C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 14:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244005AbiEUOE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 10:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiEUOE5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 10:04:57 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB3B562C8;
        Sat, 21 May 2022 07:04:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so9491869plg.5;
        Sat, 21 May 2022 07:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XyfqUm4TxX35zElYj0/ucjrKotsj0icoZs/IkZSfKPc=;
        b=dI5Kz7r7aAUCNEokdevM7rSm88h2tUdJjrmjDnRKZuxHMlwD7py8TFOeAiA9LUaI16
         dpg96Aw5Gay/YnGtsGRUFQPs147LXVsZJwRbTkVaCuF5/K0xZQEsIcfaaPaL80UJJa1C
         rfEymgOrEhNMmVvZ/ZpN2qMqqtYQ5xCc/QYNh2+DzDtZhGued/OBsPPb84uTn//z5+Pc
         S5IQp01SrsYCNgmLVnI6ozxwd+q7jmk7k/2VvKgPZhI3qjtxVz0eKC2sWwlrOBcjZy5n
         pqCjvfbf4dde0FteK9XNoVVLAwxVhF99a1+NMLK3GabnPvC/c4G1R0+Sn6SSU4sciCI3
         xUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XyfqUm4TxX35zElYj0/ucjrKotsj0icoZs/IkZSfKPc=;
        b=2BGwT+NmCft1yxoc4EVOFIyb/CXrwC+pe2V1VXDir1pBkleJBPFPkjpsgemtLvTKpG
         3sMIykGS9+7LVrPy1cNcr2XV5wb/D8DZ1vtcG3GDpo1KNS98wARRJ5aMgiZ82sqK+1e9
         31vZSha8xm+T3jEEoKkLJ4aWccxbnoz5hSKMOTIHze3a0+HqR9FlPUrkAxDNdSYd3JSt
         CUK1t6TEYf3LzS0fUIELYe7T2aKJw6NDTBl4uWiN8yg1JC91+HVMRPVuvHAu27wcCdPH
         nTUanZXqcmyPQl9hZfONwYomTZit2LGfdOBQr8LBr5Pr1BVQ+uj6dmwK4YGRNKE+HnR4
         ITcg==
X-Gm-Message-State: AOAM533RlYXqp5DF0d2e8qjCIBdB/17JjpcGW1lJPtt1UcmeGjwxttYx
        3dcuaeUhfWbfx9RQJ13yYEwUhw3Dba5ACGFeMg==
X-Google-Smtp-Source: ABdhPJyo0VLMm3vrg7jAXuYZ3TR+z9yqeHFIViSODLl/Hq+rt81gqyPhGXhqsPD6kP5maJjQOVwwB31k5eWzQAlcmzo=
X-Received: by 2002:a17:902:d711:b0:161:f859:bed7 with SMTP id
 w17-20020a170902d71100b00161f859bed7mr6616910ply.31.1653141896019; Sat, 21
 May 2022 07:04:56 -0700 (PDT)
MIME-Version: 1.0
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Sat, 21 May 2022 22:04:44 +0800
Message-ID: <CAMhUBjnDdk7_bBzqgFhZ=xf-obJYMbsJf10wC_bsUeTzxXLK6A@mail.gmail.com>
Subject: [BUG] scsi: vmw_pvscsi: got a warning when failing at probe
To:     vbhakta@vmware.com, pv-drivers@vmware.com, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

I found a bug in the vmw_pvscsi driver.
When the driver fails to allocate the host, I get the following warning:

[   22.759652] VMware PVSCSI driver - version 1.0.7.0-k
[   22.766883] vmw_pvscsi: using 64bit dma
[   22.767357] vmw_pvscsi 0000:00:05.0: vmw_pvscsi: PVSCSI_CMD_CONFIG
failed. hostStatus = 0x1a, scsiStatus = 0x2
[   22.767859] vmw_pvscsi: max_id: 16
[   22.768029] vmw_pvscsi: setting ring_pages to 8
[   22.768263] vmw_pvscsi: failed to allocate host
[   22.768491] ------------[ cut here ]------------
[   22.768767] Trying to free already-free IRQ 21
[   22.769001] WARNING: CPU: 0 PID: 336 at kernel/irq/manage.c:1861
free_irq+0x3a4/0x7c0
[   22.771363] RIP: 0010:free_irq+0x3a4/0x7c0
[   22.775533] Call Trace:
[   22.775662]  <TASK>
[   22.775780]  pvscsi_shutdown_intr+0x50/0x70 [vmw_pvscsi]
[   22.776053]  pvscsi_probe+0x2b3/0xe50 [vmw_pvscsi]

The driver's error handling code should be refined.

Zheyu Ma
