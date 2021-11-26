Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD77AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 21:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241499AbhKZVVm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 16:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241525AbhKZVTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 16:19:39 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF713C061748
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 13:11:23 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id j18so7830233ljc.12
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 13:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=aqddYKgvrKIjnsNy7fgZtdSjGzg1g5t92Kkkks8VwuU=;
        b=JqnqZPkmIyz3R1XDzWUxjr2udbre8Rzq4vAFai1pEThycYRdDCOwUD/iQi4lXWx2Ff
         Shnoj9uheP1Wo3FF3THKydD237D4iYKdO6lWJ9ED/w4TxUOrrttKf0dXTn3/oaqU9Pw4
         TwGB3XHZ3ndAGaqzZlIzhIOVj32yz4+J+q7KZJeAQnyw81tH5hMgWrSSk7bqG4UyESSl
         FbFYR8786J/wiL93wrrplEDelKnaB/AFjnn7eFHwXEwy7fKpbC4aT+60bN7/UCMiIpG8
         yOfdzc3wD1CI1CKcybgAWds0NTbjtCtc44CRTzw7VwYe+lr8CWuEGqx/c+OlMLatAcH7
         55eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aqddYKgvrKIjnsNy7fgZtdSjGzg1g5t92Kkkks8VwuU=;
        b=GBqBJREypx7DdD6V4mkUQl+OdedaO6xJf3pXoS2wnZlYkKmUDQyc6QJjLvx8+nVQec
         HIW7JTMv9JfFHFciK8ReJjjDjOIT7soiPD9Rhw1rlvPBD8ovNUYL1MuoeuMvx2XYfhAz
         Plpesj6lNMxH4d2CfqZq0NknkKNM6IiL3bat7LUfNEPROkThyvh+1vKToYE9DiWLBpcG
         OvKlKZvdNBEetIw6ysUC1SaqvXEhoktv4VyXcvQPXe+QNB/jZY48uusrQ1hFw9jpar8u
         1uKD+ZmKX5f/2jOqZl0Olq+lFUwTCzyCgFdutbVZsakjd1zL86X2TrZZNbmzg9HJB113
         RQTA==
X-Gm-Message-State: AOAM530snSk61g8mVDIau6YS9lqeD3GlWXQDMfuYOuhtGPvbh3VgkTEE
        PkKVyM6Sm5dDagig4CFb5pvkfbjqs5o3WEWnH4idxuGxUiw=
X-Google-Smtp-Source: ABdhPJwFso4+0S+XgBRUBat/HfxUidZ8PK3JKk9zNs6kgvQZVg9tlf9Cowlx/yd9W8rqMMwcKQIRvThrYcMwU9y6t5k=
X-Received: by 2002:a2e:740b:: with SMTP id p11mr34009058ljc.215.1637961082068;
 Fri, 26 Nov 2021 13:11:22 -0800 (PST)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sat, 27 Nov 2021 05:11:10 +0800
Message-ID: <CAGnHSE=uOEiLUS=Sx5xhSVrx-7kvdriC=RZxuRasZaM2cLmDeQ@mail.gmail.com>
Subject: [Regression][Stable] sd use scsi_mode_sense with invalid param
To:     linux-scsi@vger.kernel.org, damien.lemoal@wdc.com,
        martin.petersen@oracle.com, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

So with 17b49bcbf8351d3dbe57204468ac34f033ed60bc (upstream),
scsi_mode_sense now returns -EINVAL if len < 8, yet in sd, the first mode
sense attempted by sd_read_cache_type() is done with (first_)len being
4, which results in the failure of the attempt.

Since the commit is merged into stable, my SATA drive (that has
volatile write cache) is assumed to be a "write through" drive after I
upgraded from 5.15.4 to 5.15.5, as libata sets use_10_for_ms to 1.

Since sd does not (get to) determine which mode sense command to use,
should scsi_mode_sense at least accept a special value 0 (which
first_len would be set to), which is use to refers to the minimum len
to use for mode sense 6 and 10 respectively (i.e. 4 or 8)?

Regards,
Tom
