From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] remove name length check in a workqueue
Date: Wed, 10 Aug 2005 11:27:10 -0700
Message-ID: <20050810112710.47388a55.akpm@osdl.org>
References: <1123683544.5093.4.camel@mulgrave>
	<Pine.LNX.4.58.0508101044110.31617@devserv.devel.redhat.com>
	<20050810100523.0075d4e8.akpm@osdl.org>
	<1123694672.5134.11.camel@mulgrave>
	<20050810103733.42170f27.akpm@osdl.org>
	<1123696466.5134.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:52352 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965249AbVHJS2n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 14:28:43 -0400
In-Reply-To: <1123696466.5134.23.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> On Wed, 2005-08-10 at 10:37 -0700, Andrew Morton wrote:
> > > and anyway, it doesn't have to be unique;
> > > set_task_comm just does a strlcpy from the name, so it will be truncated
> > > (same as for a binary with > 15 character name).
> > 
> > Yup.  But it'd be fairly silly to go adding the /%d, only to have it
> > truncated off again.
> 
> Well, but the other alternative is that we hit arbitrary BUG_ON() limits
> in systems that create numbered workqueues which is rather contrary to
> our scaleability objectives, isn't it?

Another alternative is to stop passing in such long strings ;)

> > What's the actual problem?
> 
> What I posted originally; the current SCSI format for a workqueue:
> scsi_wq_%d hits the bug after the host number rises to 100, which has
> been seen by some enterprise person with > 100 HBAs.
> 
> The reason for this name is that the error handler thread is called
> scsi_eh_%d; so we could rename all our threads to avoid this, but one
> day someone will come along with a huge enough machine to hit whatever
> limit we squeeze it down to.

OK, well scsi is using single-threaded workqueues anyway.  So we could do:

	if (singlethread)
		BUG_ON(strlen(name) > sizeof(task_struct.comm) - 1);
	else
		BUG_ON(strlen(name) > sizeof(task_struct.comm) - 1 - 4);

which gets you 10,000,000 HBAs.   Enough?

Ho hum, OK, let's just kill the BUG_ON.
