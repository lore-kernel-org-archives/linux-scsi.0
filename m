From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] i2o_block Fix, possible CFQ elevator problem?
Date: Tue, 20 Apr 2004 12:56:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420105622.GK25806@suse.de>
References: <4083BA03.1090606@redhat.com> <20040419121225.GT1966@suse.de> <408471E2.8060201@redhat.com> <40848159.7090605@togami.com> <20040420070805.GC25806@suse.de> <4084D83D.8060405@redhat.com> <20040420080325.GD25806@suse.de> <4084E671.4090509@redhat.com> <20040420090523.GE25806@suse.de> <40850143.1090709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:16862 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262606AbUDTK43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 06:56:29 -0400
Content-Disposition: inline
In-Reply-To: <40850143.1090709@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Warren Togami <wtogami@redhat.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>, Arjan van de Ven <arjanv@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>

On Tue, Apr 20 2004, Warren Togami wrote:
> Jens Axboe wrote:
> >>>Not necessarily, it's most likely a CFQ bug. Otherwise it would have
> >>>surfaced before :-)
> >>>
> >>
> >>I forgot to mention in the previous reports:
> >>
> >>Prior to three of your original suggested cleanups of i2o_block, four 
> >>simultaneous bonnie++'s on four independent arrays would almost 
> >>immediately cause the crash while running elevator=cfq.  After those 
> >>three cleanups four simultaneous bonnie++ would survive for a while 
> >>without crashing... until you run "sync" in another terminal.  We 
> >>however did not test it enough times to determine if without "sync" it 
> >>can survive the test run.  Do you want this tested without "sync"?
> >
> >
> >Repeat the tests that made it crash. The last patch I sent should work
> >for you, at least until the real issue is found.
> >
> 
> Tested your patch, it indeed does seem to keep the system stable.  If I 
> am understanding it right, the patch disables merging in the case where 
> it would have caused a BUG condition?  (Less efficiency.)

Not quite, it just removes the crq from the hash before it can do any
damage. It doesn't impact efficiency, the request is removed from the io
scheduler at this point anyway.

> In any case, for now we are doing our i2o development using the other 
> schedulers like deadline.  Let us know if you have updated cfq patches 
> to try, and we will.

I'll see if I can reproduce it here.

-- 
Jens Axboe

