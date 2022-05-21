Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DD5C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 13:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240907AbiEUNcW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 09:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbiEUNcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 09:32:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A232F6A067;
        Sat, 21 May 2022 06:32:19 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso9920673pjb.3;
        Sat, 21 May 2022 06:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rOZc26P/AawBI79fmyAuEjRloPhm1mfxzfm+SDknsl4=;
        b=CVG8lXKZxNqlH40n39FAl3jhEfK5DObWSjW+NL0hWdzPzqOPhS+W4GVQkZOcq4IgRG
         vXr4xUN2KB/DO8BbEicpuD0c3cvldNj+NuPVVFkvthrByoL/dX0k0XG7v9zzRuQy5QiE
         pHtj7rhp/ecVHWLcEmcwtf5usUlY9jqN3rdZVK6Q4rl8mZ6a44W8LEXvQpTzehuWtm9P
         oOoEXBsUEvSiMZCs5e4dz9mMbfTZX1Nv3OCnUi7rrb0Y6CAF90kbtGx7BFEtO3tn+hFD
         LJRgF00wVzGH6D1Hk5u1QOT2TI84ZZD/OkDQC+gUr+9UaLuAPIjFmS83x2DbesNB7ij/
         +Utw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rOZc26P/AawBI79fmyAuEjRloPhm1mfxzfm+SDknsl4=;
        b=1vx+YkIM2nWQSDO49+jhjTUlaF+eHSUJVRpd95wfoHaopGie+sXN7/1+GVfiKQH3uT
         pyF6DSB3IFlwVYmNw095VYbkqY6diFTM1HJt7lSzf1vvs0R5QvVgncgv6IdNrD/+QG/v
         4F2fCO3W4ye0UZ+bs3GEp66WoOrj2uAQhmO13cj7nDrwdEJj2VH6EcpW0GiNd/d3KqoP
         pY1Xsvi82+1losi0Osb7/klObVLa8hshzuBLEW1HMJiEuhBavraEa70qzQlFYXSnBlNt
         6Z4NfFCIRNrzrdKqZX3B1vX7jD6KA1MZn2mhWOuEJE47SqlGytrCyP1rViXTkboV9m4N
         7wUw==
X-Gm-Message-State: AOAM531PhP4Br4qTfJXAiDq52Gikg7LnNtH/XFo7o/KijttVVbc42Yei
        ijzydUeYZQQe7Aa9cTcpE72qfVZ1SHnNLl25TQ==
X-Google-Smtp-Source: ABdhPJzBrQ1+384CkiSu9lDhv92p5hBvjz4SeNw5RqjCZKw5Fs9oyVJ1ykaRcLJqbaHouGMvrSH+EfUv6YV6bUFzfQg=
X-Received: by 2002:a17:902:d711:b0:161:f859:bed7 with SMTP id
 w17-20020a170902d71100b00161f859bed7mr6509846ply.31.1653139939214; Sat, 21
 May 2022 06:32:19 -0700 (PDT)
MIME-Version: 1.0
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Sat, 21 May 2022 21:32:08 +0800
Message-ID: <CAMhUBjmVvALtNANHOv-H1dBJ4MpHWhVVrxkzQSg_Zz9RwqTgsA@mail.gmail.com>
Subject: [BUG] scsi: myrb: null-pointer-dereference in myrb_cleanup
To:     hare@kernel.org, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

I found a bug in the driver myrb when probing the module.
The following log can reveal it:

[    0.985741] myrb 0000:00:05.0: Unknown Initialization Error 49
[    0.986078] myrb 0000:00:05.0: Failed to initialize Controller
[    0.986376] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    0.987368] Call Trace:
[    0.987368]  myrb_cleanup+0x4ad/0x7b0
[    0.987368]  myrb_probe.cold+0x95/0x12a0

The reason is that the driver does not initialize the disable_intr,
resulting in a null-pointer-dereference bug.

Zheyu Ma
