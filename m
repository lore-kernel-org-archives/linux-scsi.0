Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E43C3524F
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 03:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 341192087E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 03:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V35oksgS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBDDjX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 22:39:23 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36683 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgBDDjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 22:39:23 -0500
Received: by mail-pj1-f68.google.com with SMTP id gv17so738346pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2020 19:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mPedbGLBNu2L3k6HSm0HBzkbV9veK3pUwD/I6GC5AJI=;
        b=V35oksgSkm4ljAJXfpnCVS3GtTn17dSUeg2MvjUD8k9o4vbf9KU6/80bq/BynnK1Qf
         IsJGGcd5RzKRTU+nuDS2OYIOc9FrCpdpjRZyPBPFE4VGdh8TVYGf/KZWj18ekArH9rB1
         w8p1F8d+QpPkaiSpRGyBDkj03c0jf2DQ57xf2Mxcugwiy69Pm15KEyOVkkUu7FV9znsq
         UVvWnmAFcbKMwQUVUJe/J9SizvP5DudE2sXnJ5u1ewncR+bSgjEEpmtsP8PzxWChcBCK
         6pM/4UvjdlaLkbLMTSJpg7PKD37OS6sT9PM/ja7gJe1oJXxJfSA2WaA9rGwsQ7HAVGGd
         1tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mPedbGLBNu2L3k6HSm0HBzkbV9veK3pUwD/I6GC5AJI=;
        b=SX5qIJE0EIBceaOeEX9pIJt2kORB3LbmCUbJUzUWxBBemmxoknAU1eSWjexVKgzD6O
         9xYXglwki/Tq2HnvLnIKZplOZCpoCvVv0Uc5bGWHKQZ1KSPHKazej21JOHewL0roS5Sz
         3uS9dm5Gxhx/ds9jW6veSora/pKksSE5Z5yKEfLwWQi+4cMufOE+BwnKP8sC/Hhmx66O
         m0R0aD10lhV+Sl/AMMDJczRJcr3Bhjbio7QPeiJmLyL8j/h/BjypL58cxHMHRIddyzm3
         nK4VzJqZ82e/gFX+PsKBs0od2a7YADtWQUOkRF+0kLQ8/7pwyXRlQD1Q+P+70nDd4Isf
         rYxw==
X-Gm-Message-State: APjAAAWwoVzTiQnuaA6Oz3CejbEQCOCRZkvp53MsDwW2krhS4b9Wa8K9
        Y16t29PmTQsA6L7abF6DZHlX8g==
X-Google-Smtp-Source: APXvYqw1B1BjXGg0r30M6wu7yNLM6kBYQXBj/o7bHXB1/TSf0blx3HAUudnmN5lGww82QU4/vn4Bug==
X-Received: by 2002:a17:902:8b85:: with SMTP id ay5mr25055691plb.253.1580787560953;
        Mon, 03 Feb 2020 19:39:20 -0800 (PST)
Received: from google.com ([2620:15c:201:0:7f8c:9d6e:20b8:e324])
        by smtp.gmail.com with ESMTPSA id g10sm10397099pfo.166.2020.02.03.19.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 19:39:20 -0800 (PST)
Date:   Mon, 3 Feb 2020 19:39:15 -0800
From:   Satya Tangirala <satyat@google.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 0/9] Inline Encryption Support
Message-ID: <20200204033915.GA122248@google.com>
References: <20191218145136.172774-1-satyat@google.com>
 <20200108140556.GB2896@infradead.org>
 <20200108184305.GA173657@google.com>
 <20200117085210.GA5473@infradead.org>
 <20200201005341.GA134917@google.com>
 <20200203091558.GA28527@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203091558.GA28527@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 03, 2020 at 01:15:58AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 31, 2020 at 04:53:41PM -0800, Satya Tangirala wrote:
> > So I tried reading through more of blk-mq and the IO schedulers to figure
> > out how to do this. As far as I can tell, requests may be merged with
> > each other until they're taken off the scheduler. So ideally, we'd
> > program a keyslot for a request when it's taken off the scheduler, but
> > this happens from within an atomic context. Otoh, programming a keyslot
> > might cause the thread to sleep (in the event that all keyslots are in use
> > by other in-flight requests). Unless I'm missing something, or you had some
> > other different idea in mind, I think it's a lot easier to stick to letting
> > blk-crypto program keyslots and manage them per-bio...
> 
> But as far as I understand from reading the code it only sleeps because
> it waits for another key slot to be released.  Which is exactly like
> any other resource constraint in the storage device.  In that case
> ->queue_rq returns BLK_STS_RESOURCE (or you do the equivalent in the
> blk-mq code) and the queue gets woken again once the resource is
> available.
Wouldn't that mean that all the other requests in the queue, even ones that
don't even need any inline encryption, also don't get processed until the
queue is woken up again? And if so, are we really ok with that?

As you said, we'd need the queue to wake up once a keyslot is available.
It's possible that only some hardware queues and not others get blocked
because of keyslot programming, so ideally, we could somehow make the
correct hardware queue(s) wake up once a keyslot is freed. But the keyslot
manager can't assume that it's actually blk-mq that's being used
underneath, so if we want to get the keyslot manager to do something once
a keyslot was freed, it would need some generic way to signal that to
blk-mq. We can also just wait around for the queue to restart by itself
after some time delay and try to program the keyslot again at that point,
although I wouldn't want to do that because in the current design we know
exactly when a keyslot is freed, and we don't need to rely on potentially
inefficient guesswork about when we can successfully program a keyslot.
Maybe we're alright with waking up all the queues rather than only the
ones that really need it? But in any case, I don't know yet what the
best way to solve this problem is.

We would also need to make changes to handle programming keyslots in
some of the other make_request_fns besides blk_mq_make_request too
(wherever relevant, at least) which adds more complexity. Overall, it seems
to me like trying to manage programming of keyslots on a per-request basis
is maybe more code than what we have now, and I'm not sure what we're
really buying by doing it (other than perhaps the performance benefit of
having to get fewer refcounts on a variable and fewer comparisions of
cryptographic keys).

Also I forgot to mention this in my previous mail, but there may be some
drivers/devices whose keyslots cannot be programmed from an atomic context,
so this approach which might make things difficult in those situations (the
UFS v2.1 spec, which I followed while implementing support for inline
crypto for UFS, does not care whether we're in an atomic context or not,
but there might be specifications for other drivers, or even some
particular UFS inline encryption hardware that do).

So unless you have strong objections, I'd want to continue programming
keyslots per-bio for the above reasons.
