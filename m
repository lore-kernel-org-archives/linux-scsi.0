Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0CFC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 20:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E380A619C8
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 20:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhCWUCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 16:02:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:54132 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhCWUBq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 16:01:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616529705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2nH4eBFmmb845DbKELeZnF2FwGS1+JCzT4+3wcopkag=;
        b=XXT4b5iIaz2Kh3G2WpQd6zsDBuX61vjIVIz9wAqNkgWMZrlBpxQuOdFq1g4Ck3Q9MZ42za
        YwI5gNeNttEh5KUvFBr/vNQXxFblpAZ/mBMyrbNdPKXOUzLwkVaqGiimnErKDHTpSnWB3R
        9I/ne7hogEwi6OOE+VWDtjtv4W/ELUU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 24C31AF28;
        Tue, 23 Mar 2021 20:01:45 +0000 (UTC)
Message-ID: <40dacd0ec8d6b2e8db457e4cd6b7869193a83ec9.camel@suse.com>
Subject: Re: [PATCH] target: pscsi: avoid OOM in pscsi_map_sg()
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        David Disseldorp <ddiss@suse.com>,
        J??rgen Gro?? <jgross@suse.com>
Date:   Tue, 23 Mar 2021 21:01:44 +0100
In-Reply-To: <20210323162905.GA2449048@infradead.org>
References: <20210323162203.30942-1-mwilck@suse.com>
         <20210323162905.GA2449048@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-03-23 at 16:29 +0000, Christoph Hellwig wrote:
> On Tue, Mar 23, 2021 at 05:22:03PM +0100, mwilck@suse.com wrote:
> > Avoid this by simply not resetting nr_pages to 0 after allocating the
> > bio. This way, the client receives an IO error when it tries to send
> > requests exceeding the devices max_sectors_kb, and eventually gets
> > it right. The client must still limit max_sectors_kb e.g. by an udev
> > rule if (like in my case) the driver doesn't report valid block
> > limits, otherwise it encounters I/O errors.
> 
> FYI, I think the what you did here is correct, but not enough.
> When pscsi_get_bio (that is bio_kmalloc) fails, this function needs
> to unwind and return an error insted of blindly retrying the
> allocation,
> else we can't recover from a memory shortage.

I can try to do that, but in the tests I ran, I never observed
bio_kmalloc() failing. I saw it eat all memory, and various processes
being killed by the OOM killer, before the system eventually panicked
with OOM. It takes only fractions of a second until this happens:

[   57.356238] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/,task=lightdm-gtk-gre,pid=4586,uid=481
[   57.369635] Out of memory: Killed process 4586 (lightdm-gtk-gre) total-vm:1035752kB, anon-rss:0kB, file-rss:2936kB, shmem-rss:0kB
...
[   57.698656] Node 0 Normal free:54828kB min:55008kB low:68760kB high:82512kB active_anon:4kB inactive_anon:0kB active_file:936kB inactive_file:1164kB unevictable:58036kB writepending:720kB present:13631488kB managed:13310252kB mlocked:58036kB kernel_stack:5808kB pagetables:8972kB bounce:0kB free_pcp:564kB local_pcp:0kB free_cma:0kB
...
[   57.818978] Unreclaimable slab info:
[   58.254160] kmalloc-192         15683546KB   15683546KB

(system has 16GiB memory).

Martin


