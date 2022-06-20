Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C330C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 06:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbiFTGxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 02:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbiFTGxN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 02:53:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2D9FF0
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jun 2022 23:53:12 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e2so2766343edv.3
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jun 2022 23:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M7viZKPAV4Udgzu930yRnMV9UFvypFU/FwQw+uEjxc4=;
        b=eVmT7ZV+vM2II32DTtz5GqubTfh3OndN6nOFEooR0Kf91HSg1bUq5g6LKqo6OGrf65
         1RyBEaxsOyjajY5ncLzu2E5cFg4vjEXyqj/A/4iXxmokDVwjmlTpIyP7l64t8E1aJiIh
         Q939pmf4PKCf+YJgTzMstsfQaQNe25FUknT6U7exaNMRU4FtS9zwQh48UeCcWv7ZOe6k
         cy4Y373g0yoLzxg/Cu+r16/0U7sqYAeBe/xex5pMRDx2aTNMDyqyGZLXctR9CfEkTduc
         cwHnFhfvD2dVHwmUcDI5qK7yBGK0o4Qzbxst+rb9fkUI9CBwdrGgCrT7meKWRQsLK+sL
         /2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M7viZKPAV4Udgzu930yRnMV9UFvypFU/FwQw+uEjxc4=;
        b=FgI01lnaa3Cesy54gnQg6Wu2oaiZaYN4W8ofUM7gVMwfyqIcns7VaslUDK5M0LIj/d
         PWqo/5fjtI94RVi0DRuL5EI0HDrHldLrMUgOmThqkcZW3o9jnwsSh2FDFbSJFLZgrWvx
         0iln08ijCYvoFWGfX/Ep+vWYwCkJd10JhauB1LuaazIrV6e2Gowh7nNRjpV0n0DOAAUY
         gNfZl/5F9hYkcwfrYPB2d15mcdqtdTemb2SYPIYB8WMHgl+CAmahjuqnX0wsWriPoqga
         eOEQjB5ulqlh/0yKWAhG9ZK3ysD8BokaCTgPHtYAJ9+WaxJrmIzXPoVz6M8DWjmkhsRJ
         0PXA==
X-Gm-Message-State: AJIora+z1ufqn4zia3Dl+rMSkQPMe3bGsbeNTUQKZqalEHtZHnYnyxaW
        9Vb9n127sODHAfUewXfWtoomPWcxwUSldoOH4q6HIg==
X-Google-Smtp-Source: AGRyM1tX+kIwSZtiyS5mINPLo+SLQ7bV4Fy/nrzz8/+LACEiu9IMg/gg6HtQuLdC2A872rohhFpuBSFF//aG02QfXFw=
X-Received: by 2002:a05:6402:3688:b0:42d:d3ba:4725 with SMTP id
 ej8-20020a056402368800b0042dd3ba4725mr28112661edb.212.1655707991145; Sun, 19
 Jun 2022 23:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <1654879602-33497-1-git-send-email-john.garry@huawei.com>
 <1654879602-33497-4-git-send-email-john.garry@huawei.com> <303bbfad-edde-1197-679e-4a09175fb1f3@suse.de>
 <594ac0c9-a55b-bec7-77e3-a6c7e9525f6b@opensource.wdc.com>
In-Reply-To: <594ac0c9-a55b-bec7-77e3-a6c7e9525f6b@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 20 Jun 2022 08:53:00 +0200
Message-ID: <CAMGffEm8qgRzs8epMgBiJ-Ma2AGEynwXc0dSTB8k5cj2+1GhCA@mail.gmail.com>
Subject: Re: [PATCH 3/4] scsi: pm8001: Use non-atomic bitmap ops for tag alloc
 + free
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        jinpu.wang@ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajish.Koshy@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>
> After the patch, spinlock guarantees atomicity for both alloc and free.
>
> Not sure there is any gain from this.
+1
