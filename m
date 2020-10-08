Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D641C4727E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 04:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 581182173E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 04:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602132490;
	bh=l0qrHjPVsW78fE4iMqd/aK426rQMlUvVabMpWWXIv5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AOXXW5+Y8LRAB4EN0gzfZCyFKfm29AVgAZwFFOXfR3mzJPKpEhJKsBOxxOZ3xDmJp
	 Opx2Zg8JPvBY08m/izHCQjw/M/VCt7ZdfE5N3eeavCrUlAgZbm7JFkTX321x1X+0H2
	 FfNl0sW2B5+lEZ6JDvhYB36/w+ituqoKgfjCFhIg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgJHEsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 00:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgJHEsH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Oct 2020 00:48:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2E820789;
        Thu,  8 Oct 2020 04:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602132485;
        bh=l0qrHjPVsW78fE4iMqd/aK426rQMlUvVabMpWWXIv5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ABpoieSTLK2pGJRb7l8G+YYhkXZSdwzaOO/m7N+bSzrNFB4q+2EV+X0dRaOM4KHvd
         lHvfyyomiEY6Rc4IP3GqgBefL4UfaSAJ++GoZhbeQ96L4yo/sgkCfwO/j9RRJpm5U1
         SIK+0EYkm1skyFjC7mAvrEH0SyCMpX9GcNjisLow=
Date:   Thu, 8 Oct 2020 06:48:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tony Asleson <tasleson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, pmladek@suse.com,
        David Lehman <dlehman@redhat.com>,
        sergey.senozhatsky@gmail.com, jbaron@akamai.com,
        James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        martin.petersen@oracle.com, kbusch@kernel.org, axboe@fb.com,
        sagi@grimberg.me, akpm@linux-foundation.org, orson.zhai@unisoc.com,
        viro@zeniv.linux.org.uk
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
Message-ID: <20201008044849.GA163423@kroah.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <20200929175102.GA1613@infradead.org>
 <20200929180415.GA1400445@kroah.com>
 <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
 <20200930073859.GA1509708@kroah.com>
 <c6b031b8-f617-0580-52a5-26532da4ee03@redhat.com>
 <20201001114832.GC2368232@kroah.com>
 <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72be0597-a3e2-bf7b-90b2-799d10fdf56c@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 07, 2020 at 03:10:17PM -0500, Tony Asleson wrote:
> On 10/1/20 6:48 AM, Greg Kroah-Hartman wrote:
> > On Wed, Sep 30, 2020 at 09:35:52AM -0500, Tony Asleson wrote:
> >> On 9/30/20 2:38 AM, Greg Kroah-Hartman wrote:
> >>> On Tue, Sep 29, 2020 at 05:04:32PM -0500, Tony Asleson wrote:
> >>>> I'm trying to figure out a way to positively identify which storage
> >>>> device an error belongs to over time.
> >>>
> >>> "over time" is not the kernel's responsibility.
> >>>
> >>> This comes up every 5 years or so. The kernel provides you, at runtime,
> >>> a mapping between a hardware device and a "logical" device.  It can
> >>> provide information to userspace about this mapping, but once that
> >>> device goes away, the kernel is free to reuse that logical device again.
> >>>
> >>> If you want to track what logical devices match up to what physical
> >>> device, then do it in userspace, by parsing the log files.
> >>
> >> I don't understand why people think it's acceptable to ask user space to
> >> parse text that is subject to change.
> > 
> > What text is changing? The format of of the prefix of dev_*() is well
> > known and has been stable for 15+ years now, right?  What is difficult
> > in parsing it?
> 
> Many of the storage layer messages are using printk, not dev_printk.

Ok, then stop right there.  Fix that up.  Don't try to route around the
standard way of displaying log messages by creating a totally different
way of doing things.

Just use the dev_*() calls, and all will be fine.  Kernel log messages
are not "ABI" in that they have to be preserved in any specific way, so
adding a prefix to them as dev_*() does, will be fine.

thanks,

greg k-h
