Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF59C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 18:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536AB6113E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 18:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhHTSfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 14:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhHTSfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 14:35:51 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37A4C061756
        for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2021 11:35:12 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id t190so11814480qke.7
        for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2021 11:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:from:to:cc:subject;
        bh=20/a0sZ2dzFKeddKBSkNEVtv2AMo9NoJrHJmvABR31k=;
        b=iraa4Yg2ZIyDuLWjWxoz7XhaITVgAYkL2+UmLSFrqzMB3Uvs29V23Zg5ZWoo3nSrSZ
         b0dXIrjTqoCGqlt1bugRacT5AbM7T5760fHd5UgMw48rJMdz4pQCKgkQqu+1q6icd7Lh
         tR4z5xVyYZXDdAyNdKWuDuKWkAVefKGJAU+UbRIwopG6QmTsWlPBx9e+xAAOzGooNbGA
         /5NPhzg0yAMk99xz4CasbFUmtvV3ciy4mALUH8pW1BZ0fEBCJlOUuEc8VXFVTaPaSSfd
         lX0gEIIFctA+XwIkf/dWjE4RhQP77SJUbdLGVanMyBnf0sf3Vbd62+dQ9ux2O4jgxyRK
         V1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:subject;
        bh=20/a0sZ2dzFKeddKBSkNEVtv2AMo9NoJrHJmvABR31k=;
        b=Awz0dwslqE2DqFEP4t7oSUII3dsOBe/ScPTNP3dHQkibl3M/WA/ntO2AhawvtSkT1n
         C3jwqUXwQyOVv6RFNynttngTUY747oLp83I2ZBngCB3HV8INWyfs+Ixzx/iYG7GW6MYY
         V3rICyKpVHygATYapCysVAk31qTgItJRDYdaeTjhU0kjT98q1Eb3bJrrS7vo8H6oeejo
         hOM2rbgcoBin0qywhA8hcYlO4YhwFSRPF8kjXGS2aLSlm0zEKs0fih6qaBvg24yYhLmP
         tn4a0Yatn8AQtpUN7X1ISfx2a/Jec+H1yOp3MpK63hmDh1TNCyWo0h4nzx1z5Q8te0A4
         XzBg==
X-Gm-Message-State: AOAM530GE2nAly9C411lnrdbmfqHGwf6A6QNG/QFbpPld7wJesk+2nl7
        REycBx41tLy3S9RcRuFoWvRsyQ==
X-Google-Smtp-Source: ABdhPJyu6VME/MSR6isTYWyYplihN92JlMd+BYrZuko4mFZdVnneppsOXB+uYbKpE5mJc8NKjPKd6A==
X-Received: by 2002:a37:9481:: with SMTP id w123mr10382554qkd.75.1629484511800;
        Fri, 20 Aug 2021 11:35:11 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id p187sm3584045qkd.101.2021.08.20.11.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 11:35:11 -0700 (PDT)
Message-ID: <611ff5df.1c69fb81.43234.a478@mx.google.com>
Date:   Fri, 20 Aug 2021 14:35:09 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     lsf-pc@lists.linuxfoundation.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [REMINDER] LSF/MM/BPF: 2021: Cancellation announcement
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Due to the continal assessments and growing concerns around the spiking COVID-19
infections worldwide we have made the decision to cancel the Linux Storage,
Filesystem, Memory Management, and BPF summit this year.

We are investigating dates for 2022 with the hopes that we can finally hold a
safe and productive conference.  When we have finalized those plans and are
ready to begin planning again we will send out a new call for participation.
The current board will stay in place until we can successfully host the next
conference.

We thank you for your patience and understanding while we continue to work
through this very unpredictable situation.

The linux plumbers conference is being held virtually, and there are several
micro conferences that cover the various topics that we cover at LSF.  If you
have the desire to still talk with your fellow colleagues I encourage you to
look into participating in linux plumbers and possibly submitting talks for the
appropriate micro conference.

Thank you again for your support.  Our sincere sympathies are with all those
who continue to be affected by this pandemic and wish for good health and safety
for all.

Thank you on behalf of the program committe:

        Josef Bacik (Filesystems)
        Amir Goldstein (Filesystems)
        Martin K. Petersen (Storage)
        Omar Sandoval (Storage)
        Michal Hocko (MM)
        Dan Williams (MM)
        Alexei Starovoitov (BPF)
        Daniel Borkmann (BPF)
