Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C3DC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 12:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E332086A
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 12:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Mh5nMKCj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgHGMcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgHGMck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 08:32:40 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DDDC061575
        for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2020 05:32:39 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id k4so1767604oik.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 05:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=q7RheUlTMByPaCcnywC05Y9H+5X8uTAOJNxyUdwY1ao=;
        b=Mh5nMKCjFqN/gdSGvk0E2nhGYrPfUCeWiXQ6JLkTrT/6TbnhJhoQJuUEl3+6Me1x+8
         qeUnQ4a1MlhUkt9qCG+dv+5f7cl2YXTBznnNFt3laDhSoXRnfnTpsTUS9SivPPz+Ms/L
         +GrieMZHg1PboOVdHqWtC0CHf2LKDfuuXST/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=q7RheUlTMByPaCcnywC05Y9H+5X8uTAOJNxyUdwY1ao=;
        b=WM7ORlZQHRw3vazoUjHKL8H/BEQsXPbTxwgb8v1I59lKCu+Ni5akyblcpWuxkzKU+p
         jopGnDqquo6Gsl/BOHkmIom9hLIOxZ9FLn87iM/Etk+MhT1m3XT0xK9vstlzYZS8St2w
         53ZAuAyN5S1P1K1ETuZXg3Y114GqeEkx9dPNy2a8QLWkhYOLxIwTpI6afNdxz+NzJP36
         hJMoJk0FuuGeYa8ni17ysVXAGFh4GGNkURW4BQsozyo2dWJIfxYY7Q4JeY25lpEzZkbg
         ezlfAJ3FpKbhNZfCedccKXuyPLg4IOSWU6Uy6ySPHtEmFTL7Yg5ZhV91hEsL/O8vafQE
         wNQA==
X-Gm-Message-State: AOAM533N5rsHT2hYhpco6+9T5lN03Stp+/orDjJAtpWPvlZ4YSXnFKUz
        RKG5kiZAc4mfG3PfQGcpBTpEkeG8/MmEEp+79huwEg==
X-Google-Smtp-Source: ABdhPJx1VD4XWgrYM9RheSQUQ/FzJu0QC3Vl2RtJxpw5S7/uZR/7847UcnRllKmi3vQn/Q/y0OODghqT0yxGkROL2mA=
X-Received: by 2002:aca:1103:: with SMTP id 3mr7020073oir.104.1596803559217;
 Fri, 07 Aug 2020 05:32:39 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de> <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com> <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
 <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com> <eec84df0-1cee-e386-c18e-73ac8e0b89a3@redhat.com>
 <e76b12c664057adb51c14bf0663bb2f7@mail.gmail.com> <b471b84f-25e9-39cb-41e0-1cc1af409a8a@redhat.com>
 7e76e1464e794a79861ea9846e0a5370@mail.gmail.com
In-Reply-To: 7e76e1464e794a79861ea9846e0a5370@mail.gmail.com
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
thread-index: AQIDyhmBPqdmqCKUdNTZliBUbPkt/AI5BKetAom9APICL6c0jAMHD3TmAjtZC5MBe/Ed2QIv9leoAyMPjxIBrC+2XKgsTm3ggAAKkcA=
Date:   Fri, 7 Aug 2020 18:02:35 +0530
Message-ID: <7813884d02de8dfa81e777599a3df80e@mail.gmail.com>
Subject: RE: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Paolo Bonzini <pbonzini@redhat.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Paolo,


>Why would that be useful?  Again, the mapping of the UUID is _not_ to a
>PID, it is to a cgroup.  There is no concept of a VM PID; you could
>legitimately have I/O in a separate process than say the QEMU process, and
>that I/O >process could legitimately reside in a separate blkcg than QEMU.
>Agreed .
>When I run  ps  -aef  | grep <VMname > we got a pid.

>ps -aef | grep mmkvm1
root      3627     1  0 04:20 ?        00:00:34 /usr/libexec/qemu-kvm -name
testmmkvm1 -S

>And I was talking about at the below one PIDS(3627) .And with the help of
>these PIDS I was able to reach blkcg.
>Correct me if iam going in a wrong direction.

Also cross checked the same with the below comand
cat /proc/3627/cgroup
10:hugetlb:/
9:devices:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope
8:cpuset:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope/emulator
7:blkio:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope
6:freezer:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope
5:perf_event:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope
4:memory:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope
3:net_cls:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope
2:cpu,cpuacct:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope/emulator
1:name=systemd:/machine.slice/machine-qemu\x2d7\x2dtestmmkvm1.scope

Regards,
Muneendra.
