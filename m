From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Thu, 27 Aug 2009 09:46:43 -0400
Message-ID: <1251380803.6426.16.camel@mulgrave.site>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	 <4A95226E.8030504@panasas.com> <yq1my5l934u.fsf@sermon.lab.mkp.net>
	 <4A9656B6.5060100@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZH0Nqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 09:46:49 -0400
In-Reply-To: <4A9656B6.5060100@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Thu, 2009-08-27 at 12:49 +0300, Boaz Harrosh wrote:
> On 08/27/2009 09:34 AM, Martin K. Petersen wrote:
> >>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> > 
> > Boaz> I know that we also have the above problem with iscsi and
> > Boaz> data-digest such that when we come to sign the data it might
> > Boaz> change on us before the target receives it.
> > 
> > Yep, I have the same problem.  I talked to Andrew Morton a couple of
> > months ago and he said that modifying pages in flight is "a feature" as
> > far as ext[234] is concerned.
> > 
> 
> As you might know, I have a filesystem copied from the ext2 code base.
> I'm experimenting with altering the behavior so that pages written to
> while been IOed will page fault, then sleep, until IO is done.
> Clearly this is a good "feature" until such systems like mirror or signed-
> data that are forced to reallocate-copy all IO do to the 2% optimization
> that thing gives you.

What about reads to the page?  If you allow them, you get the situation
where something signals a write intent, tries to write and gets put into
wait, then the readers get the old data still.

> At the final outcome I hope for a VFS support on a flip of a flag or
> something. So under laying device can turn that "feature" off when it
> means grate performance gains in it's operations.
> 
> If any one has thought about that problem, and as some preliminary strategies,
> please I'm all hears. I've just started on this subject and currently I do not
> have a clue.

The correct way to handle this is simply to dump the page being written.
It's dirty and was updated after the last write attempt, so it gets
re-written out.  It costs nothing and it's incredibly fast.

What you likely want is a way of telling that the page got re-written so
you don't need to print out scary warning messages about parity
problems.

James


