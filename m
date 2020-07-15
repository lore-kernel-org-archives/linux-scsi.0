Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.9 required=3.0 tests=BAYES_20,DEAR_SOMETHING,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8831C433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB8EF2072E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zkv9mDsr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbgGOHsu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728888AbgGOHsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:48:50 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65D7C061755
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 00:48:49 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id a21so760248otq.8
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 00:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7GSwzg4/G8ZTisnVMvFeiEj4CPY2y3zUUQFbMieHgak=;
        b=Zkv9mDsreajv/poxEmvgSF0CaQuXVueHslq3itw9WaC6lFijrDyVdVwyqs4/+D45xu
         Ns/nx0sTyoRi5d2RHh2NXfH7efKUGUtKuBg43Nsx9m87WfVB5Jv/XjevH3PlxPJbgRlz
         dIGAv9LW1m811Z8tup6CfS+4QraLgytwMuW4uemXgFT5KCUXtGzAiTSyON9+9bvNPJqD
         NgN8DSlM7Vx86nLh+1ScyaNVV+6ZLFQ6mKj4jkGKNAbTF4n0z+2ncBmk4Po/LNd+UATl
         A9rQxyuIXbFhpdZUuCjfnpc+IK7Vgh9AQXLzDMSZSZvx/ih6kXhRV9YnxEWjnr1tSECX
         udTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7GSwzg4/G8ZTisnVMvFeiEj4CPY2y3zUUQFbMieHgak=;
        b=sAAXZlTa2pyatnOiXRIAfm5XSCG3WjFrJdRAnEb1TeQLLJboTDZv/f4etDIgVFVlFa
         LL9zDHVtX0irsNywQJQ172j8abrzxEvGwCSJBAu8GkEO/KV949kJlCPYy9fOhdDR+jm8
         KJJosvS77ouM8rVqen2Na9Mdf9QaRTMBnyxnwCc/t5MFaNewyGWeHYdoNqkxWea8KYDt
         OqMssi9b1ilyr4Tewa5nSkgwx+mJfD4gyviVeFPg8VNeZAGrGt8/CmAtgybGR1jp16bX
         hJByDW6tqGqINfwVUa2DdhvH0Cv1mJIf7VJWTnrngvIYyzwqqxBSlqbCQbELnmvz4iy9
         E7CQ==
X-Gm-Message-State: AOAM532VedkLs/hCjViraYNaoJFcC6Q7EfnI0XpWweHJYKCURtt0JETg
        6oxw6eQPx2ZwPZ2Rc8tOPY1SsHSWaegN5xq1gaE33zSYnZc=
X-Google-Smtp-Source: ABdhPJzRZitk3n6tt31kDqA2t4Z+/nc3/0niGthtaFuSXGg87W1JMWzo0u40zFHPqY3yYPKPZpKSMv3+9qXIZSciMKA=
X-Received: by 2002:a9d:2261:: with SMTP id o88mr8024786ota.334.1594799329130;
 Wed, 15 Jul 2020 00:48:49 -0700 (PDT)
MIME-Version: 1.0
From:   Sadegh Ali <sadegh.ali.2084@gmail.com>
Date:   Wed, 15 Jul 2020 12:18:14 +0430
Message-ID: <CA+RHgKLt=ZOu_nnL6oX=LJVtJWE9i+ARE6A_VmGLeJaU1mYtSg@mail.gmail.com>
Subject: LIO Scsi Target
To:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear sir

we are considering to build SCSI Target system with ZFS filesystem
backend using Linux
I searched that two modules are available for Linux SCSI target, LIO, and SCST
but it seems LIO project that streamed to the kernel is not updated
for a while (about 7 years)
Is the LIO module project dead? or suspended?
Is any person or community available to respond to technical problems
and fix bugs or develop new features or support new hardware?

with best regards
