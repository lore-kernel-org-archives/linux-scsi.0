From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Save command pool address of Scsi_Host
Date: Mon, 04 Aug 2014 07:31:14 -0700
Message-ID: <1407162674.4243.9.camel@jarvis.lan>
References: <1406874425-3528-1-git-send-email-jgross@suse.com>
	 <20140801120301.GA27198@infradead.org> <1406924674.2654.19.camel@jarvis>
	 <53DF0AA3.2040209@suse.com> <20140804110310.GA19109@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140804110310.GA19109@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Juergen Gross <jgross@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-08-04 at 04:03 -0700, Christoph Hellwig wrote:
> On Mon, Aug 04, 2014 at 06:22:59AM +0200, Juergen Gross wrote:
> > OTOH it would be possible to just delete .cmd_pool in the template when
> > deleting the pool. I'll send a patch doing this and you can decide
> > whether to take it or to use the other solution.
> > 
> > I'm not sure which to prefer: the init/remove version is simple, while
> > the dynamic version requires no changes in the driver's source and the
> > pool's resources are allocated only when really needed.
> 
> the init/remove version needs the driver to call a per-host template
> function/method from module_init/exit, something we've avoided
> successfully for the last 10 years.

Well, not exactly.

You're correct we eliminated the scsi module initialisatio which served
as per-template initialisation.  However, when we eliminated this, there
was one thing: the proc directory, that was still per-template not per
host.  If you look, it already has a ref counting mechanism similar to
the one you reinvented for the pools.  Since it's easy to get this
wrong, we should just generalise the existing mechanism for anything
today that wants to be per-host-template so people have more difficulty
getting it wrong and so we consolidate code that's the same.

However, this is way beyond a simple bug fix.  Do the bug fix first,
then we can consolidate the code as an enhancement.

James
