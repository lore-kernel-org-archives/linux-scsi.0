Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB42C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 23:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F02160F21
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 23:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348010AbhIBXYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:24:45 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:57930 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236202AbhIBXYp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 19:24:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C99DB12805E9;
        Thu,  2 Sep 2021 16:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1630625025;
        bh=PO7CwzJQ/zn5mwua3vdiN/4ivp3a9axXXMQ7lC6aI5I=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=hlVjvZMhBYL3ZlbDwY24CmIbFOBjpOJhr8gpzN1XY9lL7RE5nuSV7KXFI8ma4X+u6
         nezyrV4g5QArQO0lZe1B91tYOPlXXc3sVp1aqZQA22/4YS8iRlJiYtjxaZQCpvQGqx
         OOUn5SAK4FYnhWogQCfsPkU+UcbPVjuAVlZPkrN0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pL9erFcXoI_9; Thu,  2 Sep 2021 16:23:45 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4E49A12805A5;
        Thu,  2 Sep 2021 16:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1630625025;
        bh=PO7CwzJQ/zn5mwua3vdiN/4ivp3a9axXXMQ7lC6aI5I=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=hlVjvZMhBYL3ZlbDwY24CmIbFOBjpOJhr8gpzN1XY9lL7RE5nuSV7KXFI8ma4X+u6
         nezyrV4g5QArQO0lZe1B91tYOPlXXc3sVp1aqZQA22/4YS8iRlJiYtjxaZQCpvQGqx
         OOUn5SAK4FYnhWogQCfsPkU+UcbPVjuAVlZPkrN0=
Message-ID: <26c12f13870a2276f41aebfea6e467d576f70860.camel@HansenPartnership.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.14+ merge
 window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Date:   Thu, 02 Sep 2021 16:23:43 -0700
In-Reply-To: <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
References: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
         <CAHk-=wi99u+xj93-pLG0Na7SZmjvWg6n60Pq9Wt9PgO6=exdUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-09-02 at 15:38 -0700, Linus Torvalds wrote:
> On Thu, Sep 2, 2021 at 9:50 AM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > We also picked up a non trivial conflict with the already upstream
> > block tree in st.c
> 
> Hmm. Resolving that conflict, I just reacted to how the st.c code
> passes in a NULL gendisk to scsi_ioctl() and then on to
> blk_execute_rq().
> 
> Just checking that was fine, and I notice how *many* places do that.
> 
> Should the blk_execute_rq() function even take that "struct gendisk
> *bd_disk" argument at all?
> 
> Maybe the right thing to do would be for the people who care to just
> set rq->rq_disk before starting the request..
> 
> But I guess it's traditional, and nobody cares.

It's certainly traditional, but Christoph has been caring a lot about
cleaning up our gendisks recently, so he might be interested in seeing
if he can fix it ...

James


