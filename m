From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
Date: Tue, 20 Jul 2010 16:39:08 -0700
Message-ID: <1279669148.18893.97.camel@haakon2.linux-iscsi.org>
References: <1275882615-5354-1-git-send-email-nab@linux-iscsi.org>
	 <20100607154432Y.fujita.tomonori@lab.ntt.co.jp>
	 <1275899236.26888.40.camel@haakon2.linux-iscsi.org>
	 <20100608084443C.fujita.tomonori@lab.ntt.co.jp>
	 <1275956389.6498.8.camel@haakon2.linux-iscsi.org>
	 <1279667820.6594.18.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1279667820.6594.18.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, bharrosh@panasas.com, dgilbert@interlog.com, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-07-20 at 16:17 -0700, James Bottomley wrote:
> On Mon, 2010-06-07 at 17:19 -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2010-06-08 at 08:45 +0900, FUJITA Tomonori wrote:
> > > On Mon, 07 Jun 2010 01:27:16 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > On Mon, 2010-06-07 at 15:45 +0900, FUJITA Tomonori wrote:
> > > > > On Sun,  6 Jun 2010 20:50:15 -0700
> > > > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > > > 
> > > > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > > > 
> > > > > > Greeting STGT folks,
> > > > > > 
> > > > > > This is the third round of patches for adding proper LUN passthrough support into STGT
> > > > > > using struct scsi_lu->cmd_perform() and struct scsi_lu->cmd_done() callers with existing
> > > > > > SG_IO and the new BSG v4 backstores.
> > > > > > 
> > > > > > Following Tomo-san's input, the changelog between v2 -> v3 is as follows:
> > > > > > 
> > > > > > 1) Add struct device_type_template sg_template for SG_IO and BSG in usr/bs_sg.c instead
> > > > > >    of making changes to usr/sbc.c
> > > > > > 
> > > > > > 2) Add struct backingstore_template->bs_passthrough member of type int for SG_IO and BSG.
> > > > > > 
> > > > > > 3) In usr/target.c:tgt_device_create() pass bst->bs_passthrough into device_type_lookup()
> > > > > >    and for passthrough case use the new device_type_passthrough() to locate
> > > > > >    struct device_type_template sg_template.
> > > > > > 
> > > > > > 4) Remove unnecessary post_cmd_done() from usr/target.c:__cmd_done_passthrough()
> > > > > > 
> > > > > > This patch series has been tested with STGT/iSCSI using 'sg'+'bsg' and 'rdwr' for non
> > > > > > passthrough mode backstores into TCM_Loop LLD emulated iSCSI target ports.
> > > > > > 
> > > > > > Best,
> > > > > > 
> > > > > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org
> > > > > > 
> > > > > > Nicholas Bellinger (3):
> > > > > >   [tgt]: Add proper STGT LUN backstore passthrough support (rev 3)
> > > > > >   [tgt]: Add bs_sg struct device_type_template sg_template and struct
> > > > > >     backingstore_template->bs_init()
> > > > > >   [tgt]: Add BSG v4 backstore support to usr/bs_sg.c
> > > > > > 
> > > > > >  usr/bs_sg.c     |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> > > > > >  usr/scsi_cmnd.h |    7 ++
> > > > > >  usr/target.c    |  113 +++++++++++++++++++++++---
> > > > > >  usr/tgtd.h      |   16 ++++
> > > > > >  4 files changed, 362 insertions(+), 21 deletions(-)
> > > > > 
> > > > > The first and second patches Look fine overall. I have some comments
> > > > > and wrote some cleanup patches.
> > > > > 
> > > > > I've put the first two patches with my cleanups:
> > > > > 
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/tgt.git pass
> > > > > 
> > > > > Can you confirm that it works for you? Then I can merge them into
> > > > > master.
> > > > 
> > > > The pass branch works fine using '-E sg -Y pt' for SG_IO backstore <->
> > > > fabric LUN assocation with TCM_Loop LLD Target Ports.  Thanks for
> > > > cleaning things up to use TYPE_PT btw, I should have asked about that
> > > > earlier. ;)
> > > 
> > > Thanks for the confirmation. I've merged these patches into master.
> > > 
> > > I'll merge your bsg patch if nobody complains about dropping sg
> > > support in a few days.
> > > 
> > 
> > Perfect, thank you Tomo-san.
> 
> Ping on this ... is it actually all working and we could remove the STGT
> code in favour of this?
> 

Hi James,

Using TCM_Loop with SG_IO and BSG with LUN level passthrough and explict
I_T nexus and port configuration
using /sys/kernel/config/target/loopback is still functioning as
expected with userspace STGT/iSCSI.  Note that TCM_Loop v4 supports
multi-fabric port level emulation for FC, SAS and iSCSI, and will
configure itself to return CDB level $PROTO_IDENT based on
the /sys/kernel/config/target/loopback/$WWPN prefix.  So it should work
with those the STGT/OpenFCoE userspace fabric as well.

Also just FYI, I am not planning to removing any STGT kernel code at
this point from lio-core-2.6.git with mainline push of TCM in order to
use userspace STGT fabric modules with TCM_Loop. Actually, I would like
to (eventually) adapt it to function as a seperate TCM backstore
subsystem plugin to allow fabric level ports access to userspace CDB
processing capability.

So yes, I think that drivers/scsi/scsi_tgt_* is still be of use for us
when doing kernel level fabric <-> userspace CDB processing.  If you
will recall there was some time spent trying to get userspace CDB
backstore passthrough as a seperate TCM subsystem module, but had been
left out the TCM scsi-misc.git tree for the v2.6.35 push, which is
here: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_stgt.c;hb=HEAD

I was hoping to get up this up running with drivers/scsi/scsi_tgt_* by
the end of the year for the next round so that the kernel -> userspace
CDB passthrough logic can be used for doing PCI and VirtIO HW target
mode emulation with QEMU/KVM.  Also, I know that jgarzik is interested
in something like this for HAIL as well.

Best,

--nab
