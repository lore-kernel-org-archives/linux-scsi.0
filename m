From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 0/9] target: Add support for EXTENDED_COPY (VAAI)
 offload emulation
Date: Mon, 26 Aug 2013 17:02:21 -0700
Message-ID: <1377561741.32763.205.camel@haakon3.risingtidesystems.com>
References: <1377554588-28394-1-git-send-email-nab@daterainc.com>
	 <20130826224628.GJ26818@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20130826224628.GJ26818@lenny.home.zabbo.net>
Sender: target-devel-owner@vger.kernel.org
To: Zach Brown <zab@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-08-26 at 15:46 -0700, Zach Brown wrote:
> On Mon, Aug 26, 2013 at 10:02:59PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@daterainc.com>
> > 
> > Hi folks,
> > 
> > This -v2 series adds support to target-core for generic EXTENDED_COPY offload
> > emulation as defined by SPC-4 using virtual (IBLOCK, FILEIO, RAMDISK)
> > backends.
> 
> Cool, thanks for sending this out.  I'll just stare blankly but
> supportively at the SCSI details.
> 
> I've been experimenting with the reasonable suggestion of using splice
> as the entry point into the high level fs methods that'd be backed by
> this stuff.  Let me get it cleaned up and sent out for review.
> 
> Hopefully with a few iterations of that we could test some block file
> systems on top of this.

Looking forward to seeing your copy offload work at the fs level, along
with the block -> SCSI client copy offload pieces from MKP.

Along with having proper VAAI support in target-core for ESX clients,
the larger intention behind getting this upstream is to seed the KVM
ecosystem with storage primitives previously out of reach to most users.

> 
> > This implemenation fully supports copy offload between the same device
> > backend, and across multiple device backends.  It supports copy offload
> > transparently across multiple target ports of different fabrics, eg:
> > iSCSI -> FC, FC -> iSER, iSER -> FCoE and so on.
> 
> That's exciting!  I doubt that we want to be derailed by getting this
> working in the first pass, but it'd be fun to enable cross-fs copying
> once we got the fundamentals worked out
> 

Indeed, a single filesystem -> single device case is a reasonable place
to start.

For the multiple filesystem -> multiple device case, a potential
interface needs to plumb the block device and it's underlying NAA IEEE
WWNs down to SCSI.  The target side EXTENDED_COPY logic uses this
information in target descriptors of type 0xe4 to locate destination /
source devices, depending on if the PUSH / PULL copy method is employed.

For using physical SCSI devices below the filesystem, this would seem
straight-forward enough.  For the stacking raw block device cases
however, this poses alot more interesting set of problems..

MKP, have you thought about how copy offload might work with stacking
block devices..?

--nab
