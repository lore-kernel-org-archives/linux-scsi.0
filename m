From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for Aug 1
Date: Wed, 01 Aug 2018 16:00:54 -0700
Message-ID: <1533164454.3158.3.camel@HansenPartnership.com>
References: <20180801175852.36549130@canb.auug.org.au>
         <20180801224813.GA13074@roeck-us.net>
         <1533163965.3158.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533163965.3158.1.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-08-01 at 15:52 -0700, James Bottomley wrote:
> On Wed, 2018-08-01 at 15:48 -0700, Guenter Roeck wrote:
> > On Wed, Aug 01, 2018 at 05:58:52PM +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20180731:
> > > 
> > > The pci tree gained a conflict against the pci-current tree.
> > > 
> > > The net-next tree gained a conflict against the bpf tree.
> > > 
> > > The block tree lost its build failure.
> > > 
> > > The staging tree still had its build failure due to an
> > > interaction
> > > with
> > > the vfs tree for which I disabled CONFIG_EROFS_FS.
> > > 
> > > The kspp tree lost its build failure.
> > > 
> > > Non-merge commits (relative to Linus' tree): 10070
> > >  9137 files changed, 417605 insertions(+), 179996 deletions(-)
> > > 
> > > -----------------------------------------------------------------
> > > -----------
> > > 
> > 
> > The widespread kernel hang issues are still seen. I managed
> > to bisect it after working around the transient build failures.
> > Bisect log is attached below. Unfortunately, it doesn't help much.
> > The culprit is reported as:
> > 
> > 2d542828c5e9 Merge remote-tracking branch 'scsi/for-next'
> > 
> > The preceding merge,
> > 
> > 453f1d821165 Merge remote-tracking branch 'cgroup/for-next'
> > 
> > checks out fine, as does the tip of scsi-next (commit 103c7b7e0184,
> > "Merge branch 'misc' into for-next"). No idea how to proceed.

So what seems to be happening to cause this is that there's a patch
somewhere between the merge base of my scsi-next series and the next
tree and the patch just before scsi-next was actually merged that
actually causes a boot failure with blk-mq enabled.  Could you try to
find this patch?  I think the way to do it is to try to bisect this
range of linux-next using the command line

scsi_mod.use_blk_mq=1

Which forces block mq to be the default and seeing where the first boot
failure is (you don't need my scsi-next tree merged to do this because
all the offending patch does is flip the default state of the above
flag).

James
