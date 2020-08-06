Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ED6C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7348F22C9F
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596739765;
	bh=om1XmUVhz7ZMty4uGxbbslX7IWv5XVx1HKkAEaZGipA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CUg/URznTJ3cx5Ip7lJXsb/DBVDyj8Mz7doXwdLg/tNKa3vCNGnQA2IkI8MhTALEF
	 2dcBvyFhEo3kffIGMowTPp+NkaW1cxeleBZGc9B6SQRGV34tWWshSFOa90FINul7mV
	 hr4sodQ4R7ni+LQzc1Eh7h7skhzlX8Fr3XQIrNbg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgHFStY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 14:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbgHFStX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 14:49:23 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7EEC061574;
        Thu,  6 Aug 2020 11:49:23 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d14so45899727qke.13;
        Thu, 06 Aug 2020 11:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MJ8ccO9lbYktITW/o79WANtILwBL30qXbRqoE9ItXOo=;
        b=QbCdP6unh+l/hWMBO/NPIZ8fybGywwNRqzWhJqHKNhOvzCYSSHPeJlKtRVnvA7TsFS
         FIbLR5QWwjXHhzszE2O2/mFTWeGOlKkd9NoMixPPRrGoLcoahJExIkRoy6SMVQVTqubo
         Uh2cuB4TWonLlsZAwgIeqRAJkh5XYC6aAhxAN6/Kvf0eiUfhEGD16BUQtsOeLnpGW1fk
         f4AhLjg2VkLc+ALTE0PKLueU7xioS0x7jdX/bSeBPd2/Sacs0nNhugzL1iv0LDgT6gQQ
         ahBqNlZw3qgMCCyyiFy14XgcOyAmBvHcN+JaI9IbpMqzgWWkEwuBcm2thgffn+OJmOD4
         uzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MJ8ccO9lbYktITW/o79WANtILwBL30qXbRqoE9ItXOo=;
        b=RTHPCGMEzGTtKWckDiDrN6zB8/ivCVDfQhwyf25Iv710grJtF3eYOXb7tD0m4CVBmY
         Ir66aK9jjcXssg5e27/orU4b5dkdX2gnxZs22tzmT4X2lg4i9LscaZwtGd1GcOBAsqQC
         Re5EGUp650vrZ20UmPK5NDp792PShU0itrbU1GHUHu45xl2gvFPL5UddBF2A2yNgSl/y
         z0FqWNumUNtsSWsOzyJ4R5nIe/JKUzMsRJMnRKIM3KC6p7xffmH29ksKSezYpKdxXXVZ
         q25vAYkKAXcJbud20yT0+Fm66WeNwoICG/HSWh4uJ28e1tQgxUSfw1FZXecGeXy5zE3F
         2njA==
X-Gm-Message-State: AOAM530YRE/z3VqBAhpys5Sx64AH1q4Npbbqh4j4/i4emWy8Va9ZOOux
        DcQhvIJOjHNLqCWk48HBZv0=
X-Google-Smtp-Source: ABdhPJywOtekxMI0t0VU8N/DlILl7sl8pqy0Y6gmSpK/hzV34eQLoObVEaZ/XRiu9ATnVrQVSgf9KA==
X-Received: by 2002:a37:4f4a:: with SMTP id d71mr9529841qkb.385.1596739761897;
        Thu, 06 Aug 2020 11:49:21 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2e8b])
        by smtp.gmail.com with ESMTPSA id l66sm4642111qkd.62.2020.08.06.11.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 11:49:21 -0700 (PDT)
Date:   Thu, 6 Aug 2020 14:49:20 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
Message-ID: <20200806184920.GG4520@mtj.thefacebook.com>
References: <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <20200806144135.GC4520@mtj.thefacebook.com>
 <96930d0f-cb4d-94f4-9cbb-c82d2f0c3840@redhat.com>
 <20200806144804.GD4520@mtj.thefacebook.com>
 <b7fb1e9a-49c4-f639-475a-791a195be46b@redhat.com>
 <20200806145901.GE4520@mtj.thefacebook.com>
 <8850c528-725f-c89a-cdc6-a9abada80a69@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8850c528-725f-c89a-cdc6-a9abada80a69@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 06, 2020 at 08:39:26PM +0200, Paolo Bonzini wrote:
> On 06/08/20 16:59, Tejun Heo wrote:
> >> If I understand correctly, your only objection is that you'd rather not
> >> have it specified with a file under /sys/kernel/cgroup, and instead you
> >> would prefer to have it implemented as a ioctl for a magic file
> >> somewhere else in sysfs?  I don't think there is any precedent for this,
> >> and I'm not even sure where that sysfs file would be.
> > It just doesn't fit in the cgroupfs. I don't know where it should go for
> > this specific case. That's for you guys to figure out. There are multiple
> > precedences - e.g. how perf or bpf hooks into cgroup and others that I can't
> > remember off the top of my head.
> 
> perf and bpf have file descriptors, system calls and data structures of
> their own, here there is simply none: it's just an array of chars.  Can
> you explain _why_ it doesn't fit in the cgroupfs?

What's the hierarchical or delegation behavior? Why do the vast majority of
people who don't have the hardware or feature need to see it? We can argue
but I can pretty much guarantee that the conclusion is gonna be the same and
it's gonna be a waste of time and energy for both of us.

Thanks.

-- 
tejun
