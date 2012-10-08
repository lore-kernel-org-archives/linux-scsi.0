From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Request for improved commit tracking between fcoe and scsi trees
Date: Mon, 8 Oct 2012 09:25:53 -0400
Message-ID: <20121008132552.GA22939@hmsreliant.think-freely.org>
References: <20121003192346.GA15969@hmsreliant.think-freely.org>
 <1349607569.2541.23.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33222 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2JHN0S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2012 09:26:18 -0400
Content-Disposition: inline
In-Reply-To: <1349607569.2541.23.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, Robert Love <robert.w.love@intel.com>

On Sun, Oct 07, 2012 at 11:59:29AM +0100, James Bottomley wrote:
> On Wed, 2012-10-03 at 15:23 -0400, Neil Horman wrote:
> > James, Robert-
> > 	I've been doing lots of backports of FCoE code to the RHEL tree these
> > last few months, and I've noticed something fairly irritating, and I was
> > wondering if you two could help me out with it (in fact you two are the only two
> > which can).  I noticed that commits which are accepted into the FCoE tree that
> > get passed upstream through the scsi tree have their commit hashes altered.  I
> > can't find any examples currently, due to the fact that you, Robert, have
> > recently re-cloned your git tree at open-fcoe.org, so all this nastiness has
> > been covered up currently, but if things don't change, this issue will quickly
> > resurface.
> > 
> > Regardless, This makes it _really_ difficult to track a given patchs' traversal 
> > between trees upstream, and makes my life as a distro subsystem maintainer fairly
> > painful.  Normally I would just live with it, but I can't see any reason why it
> > should be this way, given that git can easily prevent this with a pull.  James,
> > Robert, could you two please work out a way to provide commit hash consistency
> > between your trees?  It would make mine (and I'm sure many other people's)
> > lives, much easier.
> 
> I'm reluctant to commit to any tracking process that relies on stable
> commit ids simply because they're illusory in git:  if we find a bug in
> a commit (or even worse a bisection failure) in a tree, we fix it there,
> which causes the commit id to change.
> 
> The way I do this type of tracking is via the Subject: line ... why
> can't you use that?
> 
Because git workflows are rooted in the notion that (illusory or not),
commits are immutable and stable.  Like it or not, its how changes (generally
speaking) get tracked.  Every time you rewrite history, that gets messed up.
And yes, I (and any one else) pulling changes from the scsi tree could track
things based on Subject line, but thats got its own problems, as multiple trees
run the risk of of having the same trivial subject line, which is far more
likely to occur than a sha collision.  It would also require a customization of
my workflow specifically for the scsi tree that differs from any other tree that
I follow.

I think in short, I would far prefer to see a pull/merge strategy from your
downtream contributing trees, with myself handling the risk of having to do a
whole series fixup should you need to fix something during a rewrite in the scsi
tree.  I'd gladly accept that risk in exchange for the ability to handle your
tree like I do others.  It seems from your previous note that you're will to go
that route, and I certainly appreciate that.

Thanks!
Neil

> James
> 
> 
> 
