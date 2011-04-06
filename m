From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Date: Wed, 6 Apr 2011 03:06:20 -0700
Message-ID: <20110406100620.GA4142@mtj.dyndns.org>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
 <20110405065129.GC2872@amit-x200.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110405065129.GC2872@amit-x200.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 05, 2011 at 12:21:30PM +0530, Amit Shah wrote:
> > But I don't think this is the correct place to do it.  The problem
> > happens because block layer consumes the event but doesn't remember it
> > when the time for revalidation comes.  It should be done by block
> > layer, not sr.  Hmmm... looking at the code, the new disk event code
> > should handle this correctly.  Was 2.6.38 showing the problem too?
> 
> Yes, 2.6.38 shows the same problem.  I went back to ancient kernels
> (2.6.31 on Fedora 11-alpha) which had the previous media_changed
> infrastructure and those places too show the same behaviour (with the
> TEST_UNIT_READY way of detecting media changes).

Can you please the patch attached in the following bz and see whether
it makes any difference?

 https://bugzilla.kernel.org/show_bug.cgi?id=13029

Thanks.

-- 
tejun
