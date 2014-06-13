From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target updates for v3.16-rc1
Date: Fri, 13 Jun 2014 11:07:48 -0700
Message-ID: <1402682868.16525.18.camel@haakon3.risingtidesystems.com>
References: <1402607116.18202.46.camel@haakon3.risingtidesystems.com>
	 <20140613133901.GC7371@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140613133901.GC7371@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-13 at 15:39 +0200, Christoph Hellwig wrote:
> On Thu, Jun 12, 2014 at 02:05:16PM -0700, Nicholas A. Bellinger wrote:
> > The first is with virtio-scsi between what has been merged in scsi.git
> > for "virtio_scsi: use cmd_size", and the "virtio-scsi: Enable DIF/DIX
> > modes in SCSI host LLD" below.  (Adding Paolo + hch CC')
> 
> Just curious, why did we decide to take the virtio-scsi patches
> through the target tree?  Seems like taking them through the scsi
> tree would have been a lot simpler.
> 

It's a matter of keeping changes together so they could be run from a
single branch, without having to merge the entirety of scsi.git in order
to test a new target features involving some manner of LLD changes.

Stuff like the qla2xxx target T10 PI where OK to go through scsi.git,
because they really didn't depend on target changes, but for things like
virtio-scsi + vhost-scsi T10 PI, or the iser-initiator + iser-target T10
PI data_length changes where one can't function without the other,
breaking up initiator / target patches across trees will just end up
making my work-flow unnecessarily more difficult.

I'd say identifying these types of merge conflicts is what linux-next is
supposed to be for, and at least this time around the conflicts ended up
being straight-forward to resolve with srf's patches.

--nab
