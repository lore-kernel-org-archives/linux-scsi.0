From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 12:53:23 -0700
Message-ID: <1402430003.19972.6.camel@haakon3.risingtidesystems.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	 <20140609133026.GA6239@redhat.com>
	 <1402383912.5774.13.camel@haakon3.risingtidesystems.com>
	 <20140610094254.GC7423@redhat.com>
	 <20140610215217.495d5476@canb.auug.org.au>
	 <20140610130208.GA27702@redhat.com>
	 <1402421957.23024.15.camel@haakon3.risingtidesystems.com>
	 <20140610193519.GA29609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48258 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaFJTxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 15:53:34 -0400
In-Reply-To: <20140610193519.GA29609@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, 2014-06-10 at 22:35 +0300, Michael S. Tsirkin wrote:
> On Tue, Jun 10, 2014 at 10:39:17AM -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2014-06-10 at 16:02 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Jun 10, 2014 at 09:52:17PM +1000, Stephen Rothwell wrote:
> > > > Hi Michael,
> > > > 
> > > > On Tue, 10 Jun 2014 12:42:54 +0300 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > >
> > > > > So I see two options:
> > > > > - I go ahead with my changes and you with yours and let Linus resolve
> > > > >   the conflict.  This means bisect build will be broken since the
> > > > >   breakage will likely not be noticed until after the merge.
> > > > 
> > > > Well, since the resolution is known, the one who submits their tree
> > > > later should tell Linus (as suggested by Nicholas).  That is part of
> > > > the point of the linux-next tree ... and therefore there would be no
> > > > bisect problem.
> > > > 
> > > > > > Stephen (CC'ed) has included a fix in today's linux-next for the merge
> > > > > > conflict here:
> > > > > > 
> > > > > > https://lkml.org/lkml/2014/6/10/3
> > > > > > 
> > > > > > Please confirm, as it will be a pointer to Linus within the
> > > > > > target-pending/for-next PULL request.
> > > > > 
> > > > > Yes but this does mean people trying to bisect will
> > > > > hit build breakages, not nice.
> > > > 
> > > > Not necessarily.
> > > > 
> > > > -- 
> > > > Cheers,
> > > > Stephen Rothwell                    sfr@canb.auug.org.au
> > > 
> > > 
> > > I don't see how that's possible.
> > > Here's a point you might have missed.
> > > Nicholas's patch isn't just introducing a merge conflict.
> > > It is also buggy.
> > > Replacing bit access with has_feature silently fixes the bug.
> > > 
> > > So if we want to avoid bisect breakage target tree will
> > > have to be rebased.
> > > 
> > > And if doing that anyway, I don't see any reason not
> > > to merge everything through the vhost tree, esp
> > > since I already put the patches there. Less work for
> > > everyone involved.
> > > 
> > 
> > The problem is with Sagi's recent changes wrt to including T10 PI bytes
> > into expected data transfer length in target-core, you'll end up
> > introducing a different bug into your tree..  ;)
> 
> I thought you wanted to fix it after -rc1 anyway?
> 

I've merged Sagi's patches and fixed up the resulting vhost-scsi
breakage in target-pending/for-next here:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=4101fc0abffeef604b14a707a3f9c9e2a8e39085

Only the qla2xxx target DIF related breakage remains, because those
patches are going through the scsi/for-next tree and will need to be
fixed in -rc2.

> > Why don't I simply add Stephen's patch to use vhost_has_feature() in
> > target-pending/for-next, and we just make sure that the vhost PULL
> > request goes out after target-pending..?
> > 
> > --nab
> 
> I can drop the PI feature bit in rc1. You will apply Sagi's changes and
> then enable the feature in rc2?

That is not necessary.  I'll just apply Stephen's patch to use
vhost_has_feature(), and then we make sure that target-pending is merged
before vhost to avoid the build breakage.

I'll be sending out the target-pending PULL request tomorrow afternoon
and will CC' you.

--nab

