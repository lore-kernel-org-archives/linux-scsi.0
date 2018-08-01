From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for Aug 1
Date: Wed, 01 Aug 2018 15:52:45 -0700
Message-ID: <1533163965.3158.1.camel@HansenPartnership.com>
References: <20180801175852.36549130@canb.auug.org.au>
         <20180801224813.GA13074@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801224813.GA13074@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-08-01 at 15:48 -0700, Guenter Roeck wrote:
> On Wed, Aug 01, 2018 at 05:58:52PM +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20180731:
> > 
> > The pci tree gained a conflict against the pci-current tree.
> > 
> > The net-next tree gained a conflict against the bpf tree.
> > 
> > The block tree lost its build failure.
> > 
> > The staging tree still had its build failure due to an interaction
> > with
> > the vfs tree for which I disabled CONFIG_EROFS_FS.
> > 
> > The kspp tree lost its build failure.
> > 
> > Non-merge commits (relative to Linus' tree): 10070
> >  9137 files changed, 417605 insertions(+), 179996 deletions(-)
> > 
> > -----------------------------------------------------------------
> > -----------
> > 
> 
> The widespread kernel hang issues are still seen. I managed
> to bisect it after working around the transient build failures.
> Bisect log is attached below. Unfortunately, it doesn't help much.
> The culprit is reported as:
> 
> 2d542828c5e9 Merge remote-tracking branch 'scsi/for-next'
> 
> The preceding merge,
> 
> 453f1d821165 Merge remote-tracking branch 'cgroup/for-next'
> 
> checks out fine, as does the tip of scsi-next (commit 103c7b7e0184,
> "Merge branch 'misc' into for-next"). No idea how to proceed.

This sounds like you may have a problem with this patch:

    commit d5038a13eca72fb216c07eb717169092e92284f1
     Author: Johannes Thumshirn <jthumshirn@suse.de>
     Date:   Wed Jul 4 10:53:56 2018 +0200

         scsi: core: switch to scsi-mq by default

To verify, boot with the additional kernel parameter

scsi_mod.use_blk_mq=0

Which will reverse the effect of the above patch.

We already have one report of this patch causing boot failures:

https://marc.info/?t=153305327000002

So I've added linux-scsi to see if they want any more information.

James

> 
> Guenter
> 
> ---
> bisect (mips:malta_defconfig and i386):
> 
> # bad: [d9bd94c0bcaa42d9cace337590718afd22c47bcc] Add linux-next
> specific files for 20180801
> # good: [acb1872577b346bd15ab3a3f8dff780d6cca4b70] Linux 4.18-rc7
> git bisect start 'HEAD' 'v4.18-rc7'
> # good: [f7952a1210bce43e88d69f371c6226aed481f307] Merge remote-
> tracking branch 'spi-nor/spi-nor/next'
> git bisect good f7952a1210bce43e88d69f371c6226aed481f307
> # good: [fa3bb608cd0d41a02583a7ceb3d162c4dee7e0e4] Merge remote-
> tracking branch 'spi/for-next'
> git bisect good fa3bb608cd0d41a02583a7ceb3d162c4dee7e0e4
> # good: [39c5cce976449c934b60e31cec9cea6986531b94] Merge remote-
> tracking branch 'char-misc/char-misc-next'
> git bisect good 39c5cce976449c934b60e31cec9cea6986531b94
> # good: [453f1d8211658b75542f4581759f022420bdaea8] Merge remote-
> tracking branch 'cgroup/for-next'
> git bisect good 453f1d8211658b75542f4581759f022420bdaea8
> # bad: [f11e9f9af170533e660c5deddccc4c494784c1fa] Merge remote-
> tracking branch 'nvdimm/libnvdimm-for-next'
> git bisect bad f11e9f9af170533e660c5deddccc4c494784c1fa
> # bad: [d8a758324b2e012cdba05b82ecbda6b84905f6ec] Merge remote-
> tracking branch 'rpmsg/for-next'
> git bisect bad d8a758324b2e012cdba05b82ecbda6b84905f6ec
> # good: [97fe222524f8fdbcc528b44d160d1df71d96af86] scsi: arcmsr: Fix
> error of resuming from hibernation for adapter type E
> git bisect good 97fe222524f8fdbcc528b44d160d1df71d96af86
> # bad: [2d542828c5e94490480b2900f8a0cb7a8c46afb0] Merge remote-
> tracking branch 'scsi/for-next'
> git bisect bad 2d542828c5e94490480b2900f8a0cb7a8c46afb0
> # good: [cc74e31d4147f26ead6ea06e4649d63a14edc0fe] scsi: lpfc: remove
> null check on nvmebuf
> git bisect good cc74e31d4147f26ead6ea06e4649d63a14edc0fe
> # good: [dc335a995527fb1ee9ec5649162b22cd1ce728ee] scsi: tcmu: unmap
> if dev is configured
> git bisect good dc335a995527fb1ee9ec5649162b22cd1ce728ee
> # good: [d92f5db64445ac4e2ce9a2cb7e6c929a5f4e712b] Merge branch
> 'misc' into for-next
> git bisect good d92f5db64445ac4e2ce9a2cb7e6c929a5f4e712b
> # good: [0e0d75267107e6a557ea9314d55bcff05a6ede44] scsi: tcmu: use
> u64 for dev_size
> git bisect good 0e0d75267107e6a557ea9314d55bcff05a6ede44
> # good: [c8a75afbf72ee4c16dad5339f55f62095879f207] Revert "scsi:
> target/iscsi: Reduce number of __iscsit_free_cmd() callers"
> git bisect good c8a75afbf72ee4c16dad5339f55f62095879f207
> # good: [103c7b7e01849d3c5bc998168ccd4df2c443d24b] Merge branch
> 'misc' into for-next
> git bisect good 103c7b7e01849d3c5bc998168ccd4df2c443d24b
> # first bad commit: [2d542828c5e94490480b2900f8a0cb7a8c46afb0] Merge
> remote-tracking branch 'scsi/for-next'
> 
