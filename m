From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 13:09:44 -0700
Message-ID: <1402430984.2185.116.camel@dabdike.int.hansenpartnership.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	 <20140609133026.GA6239@redhat.com>
	 <1402383912.5774.13.camel@haakon3.risingtidesystems.com>
	 <20140610094254.GC7423@redhat.com>
	 <20140610215217.495d5476@canb.auug.org.au>
	 <20140610130208.GA27702@redhat.com>
	 <1402421957.23024.15.camel@haakon3.risingtidesystems.com>
	 <20140610184531.GA27760@redhat.com>
	 <1402430265.19972.9.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59028 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460AbaFJUJr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 16:09:47 -0400
In-Reply-To: <1402430265.19972.9.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, 2014-06-10 at 12:57 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2014-06-10 at 21:45 +0300, Michael S. Tsirkin wrote:
> > On Tue, Jun 10, 2014 at 10:39:17AM -0700, Nicholas A. Bellinger wrote:
> > > On Tue, 2014-06-10 at 16:02 +0300, Michael S. Tsirkin wrote:
> > > > On Tue, Jun 10, 2014 at 09:52:17PM +1000, Stephen Rothwell wrote:
> > > > > Hi Michael,
> > > > > 
> > > > > On Tue, 10 Jun 2014 12:42:54 +0300 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > >
> > > > > > So I see two options:
> > > > > > - I go ahead with my changes and you with yours and let Linus resolve
> > > > > >   the conflict.  This means bisect build will be broken since the
> > > > > >   breakage will likely not be noticed until after the merge.
> > > > > 
> > > > > Well, since the resolution is known, the one who submits their tree
> > > > > later should tell Linus (as suggested by Nicholas).  That is part of
> > > > > the point of the linux-next tree ... and therefore there would be no
> > > > > bisect problem.
> > > > > 
> > > > > > > Stephen (CC'ed) has included a fix in today's linux-next for the merge
> > > > > > > conflict here:
> > > > > > > 
> > > > > > > https://lkml.org/lkml/2014/6/10/3
> > > > > > > 
> > > > > > > Please confirm, as it will be a pointer to Linus within the
> > > > > > > target-pending/for-next PULL request.
> > > > > > 
> > > > > > Yes but this does mean people trying to bisect will
> > > > > > hit build breakages, not nice.
> > > > > 
> > > > > Not necessarily.
> > > > > 
> > > > > -- 
> > > > > Cheers,
> > > > > Stephen Rothwell                    sfr@canb.auug.org.au
> > > > 
> > > > 
> > > > I don't see how that's possible.
> > > > Here's a point you might have missed.
> > > > Nicholas's patch isn't just introducing a merge conflict.
> > > > It is also buggy.
> > > > Replacing bit access with has_feature silently fixes the bug.
> > > > 
> > > > So if we want to avoid bisect breakage target tree will
> > > > have to be rebased.
> > > > 
> > > > And if doing that anyway, I don't see any reason not
> > > > to merge everything through the vhost tree, esp
> > > > since I already put the patches there. Less work for
> > > > everyone involved.
> > > > 
> > > 
> > > The problem is with Sagi's recent changes wrt to including T10 PI bytes
> > > into expected data transfer length in target-core, you'll end up
> > > introducing a different bug into your tree..  ;)
> > > 
> > > Why don't I simply add Stephen's patch to use vhost_has_feature() in
> > > target-pending/for-next, and we just make sure that the vhost PULL
> > > request goes out after target-pending..?
> > > 
> > > --nab
> > 
> > Because that depends on vhost API changes :)
> > 
> 
> Ugh, right.
> 
> In that case, let's see what Linus (CC'ed) prefers to do..

Build a branch with all the patches dependent on the new API based on
top of the vhost tree.  Then you send it to Linus after the vhost tree
is merged (otherwise you end up being the person sending the vhost
tree).

That way there's no API breakage and we get a consistent always
buildable tree.

James

