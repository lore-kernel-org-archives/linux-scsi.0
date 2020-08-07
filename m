Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147DEC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13F32177B
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LiSQcG8z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHGLYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgHGLYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:24:55 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1086C061574
        for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2020 04:24:54 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 93so1335804otx.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 04:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=SEylcO++jh6H4UFuQXl3wGYWeZyruF7IyI8rBTkepFk=;
        b=LiSQcG8z/iqeo/9A598jucjJAL73dvDRK6288yOYk3+YhQvFTtEVSBat23uBFXkap1
         lS85krg5lqaxHpXw7nXVc755Y5nNreleJHP+IDP0Y1rucikKliEoW0zWE5iquNeultN3
         LkH9DFUDfxaFrjJ+Q63wLXxboDxpA15KJ0W34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=SEylcO++jh6H4UFuQXl3wGYWeZyruF7IyI8rBTkepFk=;
        b=PuHVDZJt3w8LaxU3sz3wxzLsbs1Pc0zxMlGD7MmFhTj3xNK7B6cdu+zRWNZKpdiLBe
         I8KOeN2XmhDWxGCdsnG/euDU79VNff3K/OUq8GOE9DFdbbDG11gzfdolnY5UtO3OCxlk
         vd8+LRUkkzMGSAc7BM3w7ta3SMpwqfWGi9PWU9tPtw1F4xFWktuYRkKzPWOKCPuGXnTX
         mq+ZYVGgP4OP6oJL0gf7kQyFVB+cNhAT4nzAtah3xxUvoPFLyqVQiu/JVscYMDjxWvyZ
         9l7aR4lArfWz0xu630mhWlc7ONqnCkqiIudQ3B5WOBJBQ2k61J6lLAOXRAuzcfwguF3P
         Eebw==
X-Gm-Message-State: AOAM533P3a9HQbqJbqmcUadKHuIgBTniverhBRCBzvMYpcZZy2uG+sRB
        Ee2uKztoag69M5kSqYDEBUhajkSBuuNZj4LExsYTeQ==
X-Google-Smtp-Source: ABdhPJxIrUiQPh51NoyyrtH9vj7WBd2lxvcr4UhkIue4/0uNaPwU12z/bDdfaA+nM2WF2gX4SUWWO+oumjlhiSOQlfQ=
X-Received: by 2002:a05:6830:1e71:: with SMTP id m17mr11775246otr.188.1596799492006;
 Fri, 07 Aug 2020 04:24:52 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de> <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com> <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
 <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com> <eec84df0-1cee-e386-c18e-73ac8e0b89a3@redhat.com>
In-Reply-To: <eec84df0-1cee-e386-c18e-73ac8e0b89a3@redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
thread-index: AQIDyhmBPqdmqCKUdNTZliBUbPkt/AI5BKetAom9APICL6c0jAMHD3TmAjtZC5MBe/Ed2QIv9leoqFK+gzA=
Date:   Fri, 7 Aug 2020 16:54:48 +0530
Message-ID: <e76b12c664057adb51c14bf0663bb2f7@mail.gmail.com>
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
Below are my replies.

>> 3.As part of this interface user/deamon will provide the details of
>> VM such as UUID,PID on VM creation to the transport .
>> The VM process, or the container process, is likely to be
>> unprivileged and cannot obtain the permissions needed to do this;
>> therefore, you need to cope with the situation where there is no PID
>> yet in the cgroup, because the tool >that created the VM or container
>> might be initializing the cgroup, but it might not have started the
>> VM yet.  In that case there would be no PID.
>
> Agreed.A
> small doubt. If the VM is started (running)then we can have the PID and
> we
> can use the  PID?
>Yes, but it's too late when the VM is started.  In general there's no
>requirement that a cgroup is setup shortly before it is populated.
This should be ok .
The fabric  interface just provides a mechanism to store user specific data
into a pid blkcg
Before the daemon issues the UUID and pid to the fabric interface, it needs
to check whether the VM is in running state or not.
If it the VM is in running state then only it issues the VM details.
And if the  cgroup's are not setup as you mentioned the interface will
return a failure(with a proper logs) and the daemon will retry after some
time.
And this also helps us to keep track of PID to UUID mapping at daemon level.


>> Also what would the kernel API look like for this?  Would it have to
>> be driver-specific?
>
> The API should be generic and it should not be driver-specific.

>So it would be a new file in /dev, whose only function is to set up a UUID
>for a cgroup?

I will work with James Smart and check whether we can use any of the
existing interface for the same and will share the details.

>Paolo

Regards,
Muneendra.
