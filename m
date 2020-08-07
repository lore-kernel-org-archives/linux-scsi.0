Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C5EC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 12:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200782224D
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 12:15:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezqPwBxL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgHGMPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:15:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29333 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726940AbgHGMPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 08:15:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596802451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amiV8KRhFRw/6Okuy1H2mzA9jooDV2f9cn04FqbC9Os=;
        b=ezqPwBxLFKZ8qEKU5+UyC1BDI8YP/zo2k0jjdZY6O1bHA4/0esZDlbDxTRNGCPKdnPjQng
        aoXjKptFZeSjNVUW8hcz1BG2MErWAyHbrretOQmNBYO7x+eIcRFFP5r6Dyy+/UT4LLhaom
        rTlTn2xc5A10K8dZCmjxpRM02wD4ek0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-sUaJV6bEPme6EtEI4O8rqg-1; Fri, 07 Aug 2020 08:14:09 -0400
X-MC-Unique: sUaJV6bEPme6EtEI4O8rqg-1
Received: by mail-wr1-f69.google.com with SMTP id z12so686608wrl.16
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 05:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=amiV8KRhFRw/6Okuy1H2mzA9jooDV2f9cn04FqbC9Os=;
        b=Dw+Uo5oYjTHBe3Yv10WKz6HltppxiY6q+yeIc2Rg7L+LtwVdAH7pu+crncu0Ez0G1V
         UCEj3LuWeYrdMWdAafKkmiEfkLXaW+10i9l/FigIXF4fLNYUt9Oyscz6phkqb7xbN1ha
         JucFV6ENkUTCJRDVir6gfpJZFj80KJY68ysD6c2uvxUUN6nnlsOAGbl4d6rqjRobRAOt
         32TZ8z93cLSO6QV+j9gMAHhfLphTNRP/+RwJaxMUK0opi3/ec+WLqxBaTCtwNWSq1KqN
         x9z3LcsXbfo4O0CgVQ3bkb/1CgGei9zxrAzsu0wL3EnVnfpVgPd40P+yn6WcGl/kyI//
         3I4g==
X-Gm-Message-State: AOAM533bDQDwcfX7gIG6RPluUKCVJrGxwU64EX6UxdCwqU4oQH2XHJYo
        sMltO+LnSHD4ICaXFd5fqlFFCqGbrwvqFU+DFinxsMwSGmJyJ431pZVaE0XPcgOEqlzdKXQk3Uq
        BURAp/j8Aor6yeegN7/rH6g==
X-Received: by 2002:a1c:7d55:: with SMTP id y82mr12370054wmc.186.1596802447637;
        Fri, 07 Aug 2020 05:14:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwV/PnOUuW0ltXRou9nLXpbjcF25f7kDHHMa9FcLcVXFdbz4BKMSD4QOozM9nNCwtbGcrU4bA==
X-Received: by 2002:a1c:7d55:: with SMTP id y82mr12370028wmc.186.1596802447334;
        Fri, 07 Aug 2020 05:14:07 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.136.3])
        by smtp.gmail.com with ESMTPSA id 32sm10682192wrn.86.2020.08.07.05.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 05:14:06 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Tejun Heo <tj@kernel.org>
Cc:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
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
 <20200806193238.GH4520@mtj.thefacebook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4b9d80bd-ca06-dbe3-642c-98f2cee32d71@redhat.com>
Date:   Fri, 7 Aug 2020 14:14:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200806193238.GH4520@mtj.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/08/20 21:32, Tejun Heo wrote:
> On Thu, Aug 06, 2020 at 09:20:38PM +0200, Paolo Bonzini wrote:
>> On 06/08/20 20:49, Tejun Heo wrote:
>>>> perf and bpf have file descriptors, system calls and data structures of
>>>> their own, here there is simply none: it's just an array of chars.  Can
>>>> you explain _why_ it doesn't fit in the cgroupfs?
>>> What's the hierarchical or delegation behavior?
>>
>> If a cgroup does not have an app identifier the driver should use the
>> one from the closes parent that has one.
>>
>>> Why do the vast majority of
>>> people who don't have the hardware or feature need to see it? We can argue
>>> but I can pretty much guarantee that the conclusion is gonna be the same and
>>> it's gonna be a waste of time and energy for both of us.
>>
>> I don't want to argue, I want to understand.  My standard is that a
>> maintainer that rejects code explains a plan for integrating with his
>> subsystem and/or points to existing code that does something similar,
>> rather than handwaving it away as something "that I can't remember off
>> the top of my head".
> 
> I could be misreading you but my general sense is that you tend to be
> antagonistic in sometimes underhanded way, like above - you lifted that part
> from a sentence which was listing two examples prior to that phrase.

Yes, I did, but I already explained that they are irrelevant.  If I ask
you to buy me something, asking an extra question and saying "you might
want to ask XYZ instead" would make me happier than "you might want to
buy that on Amazon or ask someone else I can't remember off the top of
my head".  Perhaps I needed icecream that Amazon doesn't even sell. :)

I do apologize for being too blunt, but here are the reasons you brought up:

- "I'm not sure it makes sense to introduce custom IDs for these given
that there already are unique per-host cgroup IDs which aren't recycled"
(VM IDs are recycled, that's the idea, so I don't think this applies?)

- "There are basic problems with e.g. delegation as these things are at
odds with everything else sharing the interface" (this I cannot parse at
all: what is delegation, who is the everything else that's sharing the
interface?  why would the problem not be there if you put the interface
somewhere in the SCSI layer?)

- "people who don't need app_identifier don't see them and preferably
can disable them" (ok this I get, but then the same applies to a lot of
stuff in sysfs).

- "the proposed is akin to adding per-thread application ID to procfs
[...] which wouldn't fly well either given the specialized and (at least
for now) niche nature of the feature" (so it is basically that it is too
specialized; cache allocation technology comes to mind then, it is also
very specialized but we _did_ add resctrl hooks into procfs).


My feeling (it's a feeling---it doesn't have to be that way!) was that
you didn't try too hard to understand the problem and to help the
submitter reframe it.  As you said very properly, apologies if I'm
misunderstanding you, but I would like to be clear about what I perceived.

Thanks,

Paolo

