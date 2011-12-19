From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/24] workqueue: defer work to a draining queue
Date: Mon, 19 Dec 2011 14:08:41 -0800
Message-ID: <20111219220841.GB6256@google.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
 <20111217023318.15036.77389.stgit@localhost6.localdomain6>
 <20111219214924.GA6256@google.com>
 <CAA9_cmffHn0tqjF55ZAYi_xG=JakwK28QP=Vj=irP9MwoqWBSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmffHn0tqjF55ZAYi_xG=JakwK28QP=Vj=irP9MwoqWBSw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Dec 19, 2011 at 02:01:47PM -0800, Dan Williams wrote:
> > Dan, as I replied before, I'm not a big fan of this approach.
> 
> Sorry I must have missed it, I can't seem to find a reply in the archives?

Yeah, I can't find it either.  I definitely remember writing it.
Hmmm... weird.  Either I'm finally losing my mind or it didn't get out
for some reason.  Sorry. :)

> > For
> > now, I think it would be best to add private wrapper in libsas to
> > support deferring unchained work items while draining.
> 
> Ok, a form of this was nak'd by James before [1], but I can try again
> with pushing this chained submission checking down into scsi.

The issues I see with the proposed change is,

* There doesn't seem to be high demand for it.

* It isn't implemented the right way - it introduces unnecessary and
  hidden ordering between chained work items being drained and newly
  queued unchained ones.  We can try to do it properly without
  affecting new unchained work items but I'm not sure the added
  complexity is justified given the first issue.

I don't think adding a wrapper which defers queueing while draining is
going on would be too complex, right?

Thank you.

-- 
tejun
