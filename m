From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] cciss: use only one scan thread
Date: Wed, 15 Jul 2009 21:33:48 -0700
Message-ID: <20090715213348.0805073f.akpm@linux-foundation.org>
References: <20090714220239.22282.44414.stgit@bob.kio>
	<20090714220250.22282.69385.stgit@bob.kio>
	<20090715150637.6f171759.akpm@linux-foundation.org>
	<1247717759.25954.75.camel@grinch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753368AbZGPEd7@vger.kernel.org>
In-Reply-To: <1247717759.25954.75.camel@grinch>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 16 Jul 2009 04:15:59 +0000 Andrew Patterson <andrew.patterson@hp.com> wrote:

> > > +}
> > 
> > We already did init_completion(h->scan_wait) at startup time?  Doing
> > the INIT_COMPLETION() here looks unusual and is hopefully unnecessary.
> > 
> 
> I am following the text in the "Linux Device Drivers 3rd Edition section
> 5.4:
> 
> "A completion is normally a one-shot device; it is used once then
> discarded. It is possible, however, to reuse completion structures if
> proper care is taken. If complete_all is not used, a completion
> structure can be reused without any problems as long as there is no
> ambiguity about what event is being signalled. If you use complete_all,
> however, you must reinitialize the completion structure before reusing
> it. The macro:
> 
> INIT_COMPLETION(struct completion c);
> 
> can be used to quickly perform this reinitialization."
> 
> It there are better way to do this? INIT_COMPLETION() currently just
> sets done = 0.

OK, I'd assumed that a full wait_for_completion()/complete() operation
would leave the completion in ready-to-use-again state.

But wait_for_completion_interruptible() can indeed leave
completion.done in a non-zero state if it was interrupted by a signal.
hm.  Perhaps so the caller can run wait_for_completion*() again.
