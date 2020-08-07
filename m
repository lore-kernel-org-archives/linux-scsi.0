Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE5DC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 12:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218D12224D
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 12:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Q0+V5XR/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgHGMRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgHGMR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 08:17:29 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C61C061574
        for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2020 05:17:28 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id x24so1432666otp.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 05:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=cHhul6rH38ZNzpMfO6dKhe4PMghBWM5YOHqxidZYrEI=;
        b=Q0+V5XR/4DZ+5wlClLZ1wdvPnQGymcq+AEA9vNk3GT5nYPpmv58DEspYrmc6FiNwG6
         HZVm83pLAZ3ZeiIlLgK/IbQVMZVzv6qu7AB6UiNsTeZxWu5Y86nRuGaJngnk3deuh/ig
         xn/iaNrNlRCP7MleonoQ8dLd7PgzAYnu8lU0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=cHhul6rH38ZNzpMfO6dKhe4PMghBWM5YOHqxidZYrEI=;
        b=N5OM0AW2X/Sl/LdH1aCXjObJOG2eO3iWWrq8W61AhfGiQdXrk+7jJIZmjgYqbysgTU
         7Oh05QaXvHEPG9T/aWhuW1xn5UGJYREeX6lq7JgF99UldA6SdI6v/LBYnV2s1XMqXMls
         +8gEBnFOxopt+qifFoDKLdrXGJOtq3/d8s0hQX4FUBwZwsae+ii8t6RC0jOMnGHpHoRa
         X9KHgfxiu6qbs+OF/dJxr9owOn8fL2vpZSEF5kGVirbMbLoD+HdY+SYVQIrNfi/OgLJ+
         Dy17WHQatXkX20C94qoMqPWOOkXQcU+kI+/VE4FzQ97BFuPuGr1glSQb7Ib8hL+QuZge
         3JhQ==
X-Gm-Message-State: AOAM530eZPRLno+Zlu8XTjdjTvxISBPHdOTmTww6TPAwT9U5HOpt/587
        wa0dfbRXw8ToAV1gEq8eagrf8ttZxVYPDOGYxhWlxw==
X-Google-Smtp-Source: ABdhPJxSlo8R1h3b5kUUtUzcc4ngskWxE3KSllyHuXeEWvaU3H5D0l9U3v2y/vrWniDe4xXaPB/HCahji9/47i9sJaI=
X-Received: by 2002:a9d:7449:: with SMTP id p9mr11094677otk.360.1596802647241;
 Fri, 07 Aug 2020 05:17:27 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de> <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com> <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
 <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com> <eec84df0-1cee-e386-c18e-73ac8e0b89a3@redhat.com>
 <e76b12c664057adb51c14bf0663bb2f7@mail.gmail.com> <b471b84f-25e9-39cb-41e0-1cc1af409a8a@redhat.com>
In-Reply-To: <b471b84f-25e9-39cb-41e0-1cc1af409a8a@redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
thread-index: AQIDyhmBPqdmqCKUdNTZliBUbPkt/AI5BKetAom9APICL6c0jAMHD3TmAjtZC5MBe/Ed2QIv9leoAyMPjxIBrC+2XKgsTm3g
Date:   Fri, 7 Aug 2020 17:47:24 +0530
Message-ID: <7e76e1464e794a79861ea9846e0a5370@mail.gmail.com>
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

>
> Before the daemon issues the UUID and pid to the fabric interface, it
> needs to check whether the VM is in running state or not.
>
> If it the VM is in running state then only it issues the VM details.
>
> And if the  cgroup's are not setup as you mentioned the interface will
> return a failure(with a proper logs) and the daemon will retry after
> some time.
>
> And this also helps us to keep track of PID to UUID mapping at daemon
> level.

>Why would that be useful?  Again, the mapping of the UUID is _not_ to a
>PID, it is to a cgroup.  There is no concept of a VM PID; you could
>legitimately have I/O in a separate process than say the QEMU process, and
>that I/O >process could legitimately reside in a separate blkcg than QEMU.
Agreed .
When I run  ps  -aef  | grep <VMname > we got a pid.

ps -aef | grep mmkvm1
root      3627     1  0 04:20 ?        00:00:34 /usr/libexec/qemu-kvm -name
testmmkvm1 -S

And I was talking about at the below one PIDS(3627) .And with the help of
these PIDS I was able to reach blkcg.
Correct me if iam going in a wrong direction.
And even when I run the below command it pointed me to the same pid.
cat
/sys/fs/cgroup/blkio/machine.slice/machine-qemu\\x2d7\\x2dtestmmkvm1.scope/tasks
3627  -->/usr/libexec/qemu-kvm -name testmmkvm1
3655 --> [kvm-nx-lpage-re]
3658--> vhost-3627

And I was talking about the above PIDS(3627) to be passed to the interface
along with UUID.

>There is no need for any daemon, and I'm not even sure which daemon would
>be handling this.  App identifier should be purely a kernel concept with no
>userspace state.
Agreed App identifier is a pure kernel concept.
And the user can only provide the info what needs to be filled in it using
an interface.
Iam talking about FC transport daemon.
One of the feature of this daemon is to track all the running VM's and push
the appid information to the blk cgroup via the interface provided by the
fabric
And this feature is under development.


Paolo
