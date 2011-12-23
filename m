From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Fri, 23 Dec 2011 17:34:56 -0500
Message-ID: <1324679698.3004.12.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012011.45444.bvanassche@acm.org>
	 <1324255806.17849.68.camel@obelisk.thedillows.org>
	 <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
	 <1324333931.7043.52.camel@lap75545.ornl.gov>
	 <CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>
	 <1324436736.7621.38.camel@obelisk.thedillows.org>
	 <CAO+b5-p=01KyDv7swOP_K39+i1rSMDsd_VVvSi5rBWveMaov1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:47955 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab1LWWfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2011 17:35:16 -0500
In-Reply-To: <CAO+b5-p=01KyDv7swOP_K39+i1rSMDsd_VVvSi5rBWveMaov1Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Wed, 2011-12-21 at 14:07 +0000, Bart Van Assche wrote:
> On Wed, Dec 21, 2011 at 3:05 AM, David Dillow <dillowda@ornl.gov> wrote:
> > We don't want to leave a target blocked indefinitely -- commands caught
> > in the blocked queue won't be reissued until the queue is unblocked --
> > but we may want to keep the sdX mappings around for a long time.
> > fast_io_fail_tmo gives us the ability to do that -- the expiration of
> > fast_io_fail_tmo unblocks the queue and allows commands to be failed due
> > to the transport error. See commit f2818663.
> 
> Our opinions may differ here. My opinion is that for some use cases it
> is crucial to be able to block a target indefinitely, e.g. when there
> is only a single path between initiator and target and when the user
> prefers that I/O blocks instead of encountering I/O errors. See e.g.
> the "iSCSI settings for iSCSI root" section in the iSCSI README
> (http://www.open-iscsi.org/docs/README).

I can see admins desiring that option, but it's also handled by putting
your root on a dm-multipath volume. Either way, I'm open to letting
things block indefinitely, but I do think we should look into why the
SCSI stack has a concept of the maximum blocking time.

> Regarding commit f2818663: as far as I can see what that commit does
> is to make it impossible for a user to set fast_io_fail_tmo == -1

I was pointing to the commit message as evidence of more prominent SCSI
developer's line of thought on handling missing devices. As you note,
the actual diff is uninteresting.

We should match the rest of the SCSI stack unless there is good reason
to go our own way. The iSCSI transport can do what it does because it
has a native ping, but I'm not convinced they should have introduced new
semantics and/or names when taking advantage of that. As far as I can
tell without deeply studying it, replacement_timeout is equivalent to
fast_io_fail_tmo.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

