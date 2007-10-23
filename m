From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC 1/2] scsi core: alloc_cmnd
Date: Tue, 23 Oct 2007 11:48:04 -0600
Message-ID: <20071023174804.GR27248@parisc-linux.org>
References: <20071019183331.GC30807@parisc-linux.org> <471E260D.6030605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52949 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXJWRsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 13:48:05 -0400
Content-Disposition: inline
In-Reply-To: <471E260D.6030605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 23, 2007 at 06:49:17PM +0200, Boaz Harrosh wrote:
> You know Matthew when you first talked about this, I envisioned
> something else.

Right, so did I.  Christoph felt that alloc_cmnd/destroy_cmnd a la the
VFS layer's alloc_inode/destroy_inode was a better route.  I didn't have
a strong feeling, so I implemented that.

> This serves the drivers well because all they need to do is set
> host_cmnd_extra_bytes = size_of(my_cmnd_stuff) and start using
> it. much more simple than setting up cache pools. It also keeps
> the Q per host vs Q per driver.

The allocation pool is currently for the whole subsystem, not per host.
I assumed you meant 'pool' rather than 'queue', since I didn't touch the
queues.

Hosts already have allocation pools (er, I think they all do anyway
... and any that don't, I'm quite happy to write a generic_alloc_cmnd
and stick it in scsi_lib).

> This also solves your problem with locks and allocation flags
> since nothing changes, and it is all private to the mid-layer.

It doesn't solve that problem -- we already have that problem; it's just
that it's kept in the midlayer.

> And it serves me, because when bidi comes I just do:
> sizeof(struct scsi_cmnd) + host_cmnd_extra_bytes + sizeof(bidi_stuff)
> for hosts that support bidi. And the rest of the work was done by you.

I have to admit to not having a clear picture of how bidi is supposed to
work.  Could we do it something like this?

struct bidi_cmnd {
	struct scsi_cmnd;
	...
};

struct qla_cmnd {
	struct bidi_cmnd bd_cmnd;
	...
};

We could also add an alloc_bidi_cmnd/destroy_bidi_cmnd to the shost
template.  Presumably most commands won't be bidi for any given host,
so it'd be a waste of space to allocate them for all commands.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
