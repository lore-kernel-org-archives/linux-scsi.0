From: Coywolf Qi Hunt <coywolf@gmail.com>
Subject: Re: [PATCH] remove name length check in a workqueue
Date: Fri, 12 Aug 2005 00:22:53 +0800
Message-ID: <2cd57c9005081109222c6a5973@mail.gmail.com>
References: <1123683544.5093.4.camel@mulgrave>
	 <Pine.LNX.4.58.0508101044110.31617@devserv.devel.redhat.com>
	 <20050810100523.0075d4e8.akpm@osdl.org>
	 <1123694672.5134.11.camel@mulgrave>
	 <20050810103733.42170f27.akpm@osdl.org>
	 <1123696466.5134.23.camel@mulgrave>
	 <20050810112710.47388a55.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.198]:54887 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932297AbVHKQW5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 12:22:57 -0400
Received: by nproxy.gmail.com with SMTP id l37so96846nfc
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 09:22:53 -0700 (PDT)
In-Reply-To: <20050810112710.47388a55.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, mingo@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 8/11/05, Andrew Morton <akpm@osdl.org> wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> >
> > On Wed, 2005-08-10 at 10:37 -0700, Andrew Morton wrote:
> > > > and anyway, it doesn't have to be unique;
> > > > set_task_comm just does a strlcpy from the name, so it will be truncated
> > > > (same as for a binary with > 15 character name).
> > >
> > > Yup.  But it'd be fairly silly to go adding the /%d, only to have it
> > > truncated off again.
> >
> > Well, but the other alternative is that we hit arbitrary BUG_ON() limits
> > in systems that create numbered workqueues which is rather contrary to
> > our scaleability objectives, isn't it?
> 
> Another alternative is to stop passing in such long strings ;)
> 
> > > What's the actual problem?
> >
> > What I posted originally; the current SCSI format for a workqueue:
> > scsi_wq_%d hits the bug after the host number rises to 100, which has
> > been seen by some enterprise person with > 100 HBAs.
> >
> > The reason for this name is that the error handler thread is called
> > scsi_eh_%d; so we could rename all our threads to avoid this, but one
> > day someone will come along with a huge enough machine to hit whatever
> > limit we squeeze it down to.
> 
> OK, well scsi is using single-threaded workqueues anyway.  So we could do:
> 
>         if (singlethread)
>                 BUG_ON(strlen(name) > sizeof(task_struct.comm) - 1);
>         else
>                 BUG_ON(strlen(name) > sizeof(task_struct.comm) - 1 - 4);
> 
> which gets you 10,000,000 HBAs.   Enough?
> 
> Ho hum, OK, let's just kill the BUG_ON.

s/BUG_ON/WARN_ON/ ?

-- 
Coywolf Qi Hunt
http://ahbl.org/~coywolf/
