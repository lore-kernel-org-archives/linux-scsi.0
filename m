Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D108C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 14:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22873206F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 14:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="p0jZ56gG";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="w1hvheYV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgEKOle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 10:41:34 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49480 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729143AbgEKOle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 10:41:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 4E26B8EE151;
        Mon, 11 May 2020 07:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1589208094;
        bh=XyLPQji5d2d7WjRo3RldEPNbf6Gl5PpJiGEOv6Kyr1o=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=p0jZ56gGM3poIVtThvFKXQ6VleUD5foGFryJgusaIhPISn2YVbCOh5INGEjMf+x+D
         x+EHyZssvI4lBTaU6Ny8KXa/wc1rJdPQ75GFkmxwXjP6QIvW/nz4MUh1Hp0YF6bAe7
         Wsx5wRYzc/UmueqYRulY649o9rjuy0DtEZDu137s=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uIE0IM36AWdG; Mon, 11 May 2020 07:41:33 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3E2538EE100;
        Mon, 11 May 2020 07:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1589208093;
        bh=XyLPQji5d2d7WjRo3RldEPNbf6Gl5PpJiGEOv6Kyr1o=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=w1hvheYV3m0ZDOICrnCnXPdA1rdl7Mu8WHrdsyZjXesn8FE05t0R4vimIsAfhtvHw
         mciDm74ZqBO4DuT0mY2CsEQgAPq1xaFjGITupyDJoGOhMEXjsHajAeTBKAF/UjOIqc
         n9JQIMpzCfjx/M7CEYdoHKcda7f/nFuTTPziycmI=
Message-ID: <1589208092.3505.9.camel@HansenPartnership.com>
Subject: Re: scsi_alloc_target: parent of the target (need not be a scsi
 host)
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     dgilbert@interlog.com,
        SCSI development list <linux-scsi@vger.kernel.org>
Date:   Mon, 11 May 2020 07:41:32 -0700
In-Reply-To: <5425d3ef-1cf8-fee0-58a5-fbf702d30562@interlog.com>
References: <59d462c4-ceab-041a-bbb5-5b509f13a123@interlog.com>
         <1589136759.9701.25.camel@HansenPartnership.com>
         <5425d3ef-1cf8-fee0-58a5-fbf702d30562@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-05-10 at 17:50 -0400, Douglas Gilbert wrote:
> On 2020-05-10 2:52 p.m., James Bottomley wrote:
> > On Sun, 2020-05-10 at 14:32 -0400, Douglas Gilbert wrote:
> > > This gem is in scsi_scan.c in the documentation of that
> > > function's first argument. "need not be a scsi host" should read
> > > "it damn well better be a scsi host" otherwise that function will
> > > crash and burn!
> > 
> > It shouldn't: several transport classes, like SAS and FC have
> > intermediate devices between the host and the target and they all
> > work just fine using the non-host parent.  Since you don't give the
> > error this is just guesswork, but the host has to be somewhere in
> > the parent chain otherwise dev_to_shost(parent) will return NULL
> > ... is that your problem?
> 
> May be that "need not be a scsi host" should be expanded to something
> that suggests dev_to_shost(first_arg) can resolve to a non-NULL
> pointer.
> 
> Are there restrictions on those intermediate object(s)? Can there be
> more than one? If so, can those intermediate objects only form a
> linear chain or could it be more complex, an object subtree for
> example?

I think you can read the current code as well as I can:

static inline struct Scsi_Host *dev_to_shost(struct device *dev)
{
	while
(!scsi_is_host_device(dev)) {
		if (!dev->parent)
			return NULL;
		dev =
dev->parent;
	}
	return container_of(dev, struct Scsi_Host,
shost_gendev);
}

The broad point is that this is open source, not some proprietary OS. 
I'm not giving you an API set in stone and you have to figure out the
use cases, I'm telling you how the current API behaves and the reason
why it behaves this way.  If there's an expansion or change you need,
provided it supports the current uses and is maintainable, it can be
done.  What you have to tell me is what you're trying to do.

> > > I'm trying to work out why the function:
> > > starget_for_each_device() in scsi.c does _not_ use that
> > > collection right in front of it (i.e. scsi_target::devices).
> > > Instead, it step up to the host level, and iterates over all
> > > devices (LUs) on that host and only calls the given function for
> > > those devices that match the channel and target numbers.
> > > That is bizarrely wasteful if scsi_target::devices could be
> > > iterated over instead.
> > >  
> > > Anyone know why this is?
> > 
> > Best guess would be it wasn't converted over when the target list
> > was introduced.
> 
> Okay, I'll change it and see what breaks.
> 
> 
> If you are not familiar with "mark"s in xarrays, they are binary
> flags hidden inside the pointers that xarray holds to form a
> container. With these flags (two available per xarray) one can make
> iterations much more efficient with xa_for_each_marked() { }. The win
> is that there is no need to dereference the pointers of collection
> members that are _not_ marked. After playing with these in my rework
> of the sg driver, I concluded that the best thing to mark was object
> states. Unfortunately there are only 2 marks *** per xarray but
> scsi_device, for example, has 9 states in scsi_device_state. Would
> you like to hazard a guess of which two (or two groups), if any, are
> iterated over often enough to make marking worthwhile?
> 
> Those two marks could be stretched to four, sort of, as scsi_device
> objects are members of two xarrays in my xarray rework: all sdev
> objects in a starget, and all sdev objects in a shost.

I've got to say that sounds like a solution looking for a problem.

The fast path of SCSI is pretty rigorously checked with high iops
devices these days.  The fact that this iterator is really lock heavy
but has never been fingered in any of the traces indicates that it's
probably not really a problem that needs solving.

James

