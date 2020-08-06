Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AB5C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 19:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B45A2173E
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 19:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596742365;
	bh=/wJJewGkf2aZbQZWMpELR6P64yMzwhu70CYkw+/Eqd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fkkm4WkwOiD+xm3tu/EgW50V8tKYiv24Crl9VJaAKkqGni3xi9pkZqLBw6WZV3IN+
	 K4v6AUjvCWaKTSgq8mbL1KmWQLjub8qDWU6zOMR55eFfIQoDOLPN72XI940LCkvE6/
	 ldBE+WQiXcx+5Kb8YjYnxPttMbxSKWUSmrdN0CWU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgHFTcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 15:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHFTcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 15:32:41 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21DEC061574;
        Thu,  6 Aug 2020 12:32:41 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id dd12so17994065qvb.0;
        Thu, 06 Aug 2020 12:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1g6XQkc6y2zNvgF3tzkobuZcWQW/fi9bMXa/WU1ezUI=;
        b=M2AfsQDWo4Y+OGoQ1xgE7RtPaYksCUDraKumMLp5UeyZ47E3O+eritzdo9wkZDGbUi
         H5BMEJWW6qUUHdFreicxzhBuffwZ3rwwgs9hqH+15przrLNojJw23YGk9P5rDYQkHKXN
         QeSEAMn/cfviMR4setPkG+Rnw6cPDc6LR56ztuM3zNpLFmFpol/gEDkhQyIMwAQ2Dr83
         xlFGc28/H0GknrK6evPuZ8/lR6PInVrYmJinlQR212Ngr+Q8k1HWJKr/FONBtXpJ/1Ov
         dzbgBXCkG0VKqeWkXhjO5I0sfde+ewg1LALxkDJDX/FPYPj3kkXgBR+YthXdRm4YVb4e
         aOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1g6XQkc6y2zNvgF3tzkobuZcWQW/fi9bMXa/WU1ezUI=;
        b=Tw0vnW8wz5ZWb6XomPlVZ3jmU0tYCx3kOsf/dgGgTCnrCMn9yWkJ19TxlV/6MTNdDp
         mjmKwZYpx2p1y0/YUrJbymJOEfcHiAeQGZV7wjt4BBLr162/OBBhY/RSSbhdxulDFMUx
         n6OVCrC+TVp1MRVNVeSHUu+ynyUJt+nWFAxaA5SV8mtxwUwnpY0qTP9dC0HMukcWGPX4
         Tx8/I9ApKQVaqlAc4YSZjn9uGwomySYnc4XwcpstvWxHiixrdJh+fSVP24Jz0rQ2/dG9
         nFTKJofGG/alkzkZ0UuZTU55b+v2szhmi4QfPWhVv4ne96+YUWd3ggRoyF5JsXagwNgD
         acMg==
X-Gm-Message-State: AOAM531Ie95dFPKnJQzkHa5j7lUMx6+jHSFbVIT6cwtqEfiKzRj7kZyl
        AnqrZtAXN197e4nfOc9rgH8=
X-Google-Smtp-Source: ABdhPJz8djvV20z+DgXp59IrwnmCXDeYEfbzkLZCHRgdb2QSCocXc2vYnByq4kCaVZDDvuoRkhqm6A==
X-Received: by 2002:ad4:4cc3:: with SMTP id i3mr9382128qvz.17.1596742360729;
        Thu, 06 Aug 2020 12:32:40 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2e8b])
        by smtp.gmail.com with ESMTPSA id v28sm6394257qtk.28.2020.08.06.12.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 12:32:40 -0700 (PDT)
Date:   Thu, 6 Aug 2020 15:32:38 -0400
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
Message-ID: <20200806193238.GH4520@mtj.thefacebook.com>
References: <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <20200806144135.GC4520@mtj.thefacebook.com>
 <96930d0f-cb4d-94f4-9cbb-c82d2f0c3840@redhat.com>
 <20200806144804.GD4520@mtj.thefacebook.com>
 <b7fb1e9a-49c4-f639-475a-791a195be46b@redhat.com>
 <20200806145901.GE4520@mtj.thefacebook.com>
 <8850c528-725f-c89a-cdc6-a9abada80a69@redhat.com>
 <20200806184920.GG4520@mtj.thefacebook.com>
 <a2522463-daf1-ea45-1dbc-2e31eb8bced2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2522463-daf1-ea45-1dbc-2e31eb8bced2@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 06, 2020 at 09:20:38PM +0200, Paolo Bonzini wrote:
> On 06/08/20 20:49, Tejun Heo wrote:
> >> perf and bpf have file descriptors, system calls and data structures of
> >> their own, here there is simply none: it's just an array of chars.  Can
> >> you explain _why_ it doesn't fit in the cgroupfs?
> > What's the hierarchical or delegation behavior?
> 
> If a cgroup does not have an app identifier the driver should use the
> one from the closes parent that has one.
> 
> > Why do the vast majority of
> > people who don't have the hardware or feature need to see it? We can argue
> > but I can pretty much guarantee that the conclusion is gonna be the same and
> > it's gonna be a waste of time and energy for both of us.
> 
> I don't want to argue, I want to understand.  My standard is that a
> maintainer that rejects code explains a plan for integrating with his
> subsystem and/or points to existing code that does something similar,
> rather than handwaving it away as something "that I can't remember off
> the top of my head".

I could be misreading you but my general sense is that you tend to be
antagonistic in sometimes underhanded way, like above - you lifted that part
from a sentence which was listing two examples prior to that phrase. That's
an disingenious way to discuss regardless of the topic. To put in your way,
I find your way of communication failing to meet my standard for productive
discussions.

I've given brief reasons why I don't think it fits. If anyone else wants to
discuss that further, please raise it. I'd be happy to discuss. Paolo, if
I'm misunderstanding you, my aplogies but otherwise please do better.

Thanks.

-- 
tejun
