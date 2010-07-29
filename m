From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 22:06:55 +0200
Message-ID: <20100729200655.GB17767@lst.de>
References: <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <20100729024334.GA21736@redhat.com> <20100729084225.GA30446@lst.de> <20100729200217.GD28704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43557 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0G2UHX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 16:07:23 -0400
Content-Disposition: inline
In-Reply-To: <20100729200217.GD28704@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Jul 29, 2010 at 04:02:17PM -0400, Vivek Goyal wrote:
> Looks like you still want to go with option 2 where you will scan the file
> system code for requirement of DRAIN semantics and everything is fine then for
> devices no supporting volatile caches, you will mark request queue as NONE.

The filesystem can't simply change the request queue settings. A request
queue is often shared by multiple filesystems that can have very
different requirements.

> This solves the problem on devices with WCE=0 but what about devices with
> WCE=1. If file systems anyway don't require DRAIN semantics, then we
> should not require it on devices with WCE=1 also?

Yes.

> If yes, then why not go with another variant of barriers which don't
> perform DRAIN and just do PREFLUSH + FUA (or post flush for devices not
> supporting FUA).

I've been trying to prototype it, but it's in fact rather hard to
get this right.  Tejun has done a really good job at the current
barrier implementation and coming up with something just half as
clever for the relaxed barriers has been driving me mad.

> And then file systems can slowly move to using this non
> draining barrier usage wherever appropriate.

Actually supporting different kind of barriers at the same time
is even harder.  We'll need two different state machines for them,
including the actual state in the request_queue.  And then make
sure when different filesystems on the same queue use different
types work well together.  If at all possible switching the semantics
on a flag day would make life a lot simpler.

