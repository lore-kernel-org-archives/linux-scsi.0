From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] remove name length check in a workqueue
Date: Wed, 10 Aug 2005 10:37:33 -0700
Message-ID: <20050810103733.42170f27.akpm@osdl.org>
References: <1123683544.5093.4.camel@mulgrave>
	<Pine.LNX.4.58.0508101044110.31617@devserv.devel.redhat.com>
	<20050810100523.0075d4e8.akpm@osdl.org>
	<1123694672.5134.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35552 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965230AbVHJRjH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 13:39:07 -0400
In-Reply-To: <1123694672.5134.11.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Wed, 2005-08-10 at 10:05 -0700, Andrew Morton wrote:
> > Ingo Molnar <mingo@redhat.com> wrote:
> > > yeah ... cannot remember why i have done it originally :-|
> 
> > Might it be to do with sizeof(task_struct.comm)?
> 
> But that's 16 bytes not 10;

Well we stick a "/%d" at the end, which gets us up to 14 chars, assuming
NR_CPUS < 1000

> and anyway, it doesn't have to be unique;
> set_task_comm just does a strlcpy from the name, so it will be truncated
> (same as for a binary with > 15 character name).

Yup.  But it'd be fairly silly to go adding the /%d, only to have it
truncated off again.

We could truncate the name before adding the CPU number, but it sounds
saner to just prevent anyone passing in excessively long names.  Via
BUG_ON, say ;)

What's the actual problem?
