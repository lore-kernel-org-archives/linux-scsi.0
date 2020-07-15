Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,DEAR_SOMETHING,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9EFC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE022072E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:58:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZgCneT8J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgGOS6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:58:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726356AbgGOS6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 14:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594839515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GfN5FrFwoPZiuEJ7K6Xen4CKWGB8Kx4OmilKIATqRi4=;
        b=ZgCneT8JXy2TmzTdsNWLiJpTfrQVq3F0JazjiWOIM9K8Sj+S8ZKqc6EdLphdKHbexlcR9r
        vPYETIA7uo0/UlEro3LfRSpk0p0cZ6o6sXwWy0KkprybnLB5GHKNwcbiaR/ZfWhySt6W4R
        qIUSGyuhTlJN6+KuJRIqv1yW7AnQYok=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-RweWh1kaNYO4PmVRta210Q-1; Wed, 15 Jul 2020 14:58:29 -0400
X-MC-Unique: RweWh1kaNYO4PmVRta210Q-1
Received: by mail-oi1-f199.google.com with SMTP id v77so1296890oie.7
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 11:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GfN5FrFwoPZiuEJ7K6Xen4CKWGB8Kx4OmilKIATqRi4=;
        b=kXbrDaysyJmBnKZ9muHPtn1o77VKQwhFyGUSLgilU8RfcXW2slv1wMUElLz809EDnz
         dxuZpcYBiQZlxQ5HNkBnfHZ92g3Ob57dWXSuEfVefd0Olrn85ZNJHq0FPYXzCUd935Y3
         R9zfqOJ5RFbVBv1sL40PfDWrM2/JAoHxVcomYiUsP1c0uLJ7P44FRFfk3CS1TUWRLbx6
         kg4OiEXff592JXvxNttd700P7qOHVNz5NsMkot6UomyMBjSxE+JT5lYhUMAQZ8sraMjO
         Jv8gMlk61a3yNiJFvSi4En0aZ/kuT3P6Y4XZK9mb4BrEmrfLDeo51E2AfZgv0OQxwFD1
         PnYQ==
X-Gm-Message-State: AOAM531jpz8XCrhYn9bpW3QJ9qtP8+yaT6R1F4KNWaaiXwMUy0FogsMq
        qjKdWKBVJ3gjV0eKn86pMexaEblm2zNqxC3Uoj/Fyrm22G0DXkDVXdnfBxd7oP0iEFPsPVYMkv0
        zfOh4QTDDThLzABKQEOGj6Q==
X-Received: by 2002:aca:b809:: with SMTP id i9mr1017804oif.174.1594839508419;
        Wed, 15 Jul 2020 11:58:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUMLSZWOmUvNQJ95SnZwddIaMf5Effm0NK3kHRaT2syjr3l/N1FcQnITnQX8bM/dKfPl6m/A==
X-Received: by 2002:aca:b809:: with SMTP id i9mr1017788oif.174.1594839508089;
        Wed, 15 Jul 2020 11:58:28 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id u144sm534910oia.40.2020.07.15.11.58.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 11:58:27 -0700 (PDT)
Message-ID: <1918fb75221de129f39fd1d2b889010afd9347ff.camel@redhat.com>
Subject: Re: LIO Scsi Target
From:   Laurence Oberman <loberman@redhat.com>
To:     Lee Duncan <lduncan@suse.com>,
        Sadegh Ali <sadegh.ali.2084@gmail.com>,
        linux-scsi@vger.kernel.org
Date:   Wed, 15 Jul 2020 14:58:25 -0400
In-Reply-To: <43b31e85-9d9c-c3ef-a008-83510a968ee7@suse.com>
References: <CA+RHgKLt=ZOu_nnL6oX=LJVtJWE9i+ARE6A_VmGLeJaU1mYtSg@mail.gmail.com>
         <43b31e85-9d9c-c3ef-a008-83510a968ee7@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-15 at 11:16 -0700, Lee Duncan wrote:
> On 7/15/20 12:48 AM, Sadegh Ali wrote:
> > Dear sir
> > 
> > we are considering to build SCSI Target system with ZFS filesystem
> > backend using Linux
> > I searched that two modules are available for Linux SCSI target,
> > LIO, and SCST
> > but it seems LIO project that streamed to the kernel is not updated
> > for a while (about 7 years)
> > Is the LIO module project dead? or suspended?
> > Is any person or community available to respond to technical
> > problems
> > and fix bugs or develop new features or support new hardware?
> > 
> > with best regards
> > 
> 
> 
> targetcli-fb and friends has replaced the lio-utils for interfacing
> with
> the LIO subsystem in the kernel. All targetcli-fb really does is make
> interacting with LIO much easier. But you could theoretically roll
> your
> own LIO commands, since the interface is sysfs. Targetcli-fb is in
> python, and quite user-friendly IMHO.
> 
> SCST is still around, but I believe it's user-space only. (Forgive me
> if
> I'm wrong here, but it's been a while since I looked at SCST.)
> 
> I'd suggest using something like btrfs instead of zfs, since btrfs is
> getting much better now -- even Debian has taken the hint from SUSE
> and
> started using it. :)
> 
> Check out the "Kernel Target Devel" list (target-devel at vger).
> 
> Much of the kernel target development recently has been to include
> other
> non-iSCSI target support IMHO.
> 
> There is also a cool new extension to targetcli called tcmu-runner,
> that
> allows you to add new functionality to targetcli without having to
> hack
> on the kernel.
> 

Thanks Lee, I will check it out.
The issues I was having are mainly qla2xxx target in the kernel, and I
had been working with Marvell to stabilize that in upstream.
various lockups and other workqueue relateed issues. It been a while.
I will try latest upstream and see if its any better than it was for me
a couple years back.


