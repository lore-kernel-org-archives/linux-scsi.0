From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
Date: Mon, 07 Jun 2010 17:19:48 -0700
Message-ID: <1275956389.6498.8.camel@haakon2.linux-iscsi.org>
References: <1275882615-5354-1-git-send-email-nab@linux-iscsi.org>
	 <20100607154432Y.fujita.tomonori@lab.ntt.co.jp>
	 <1275899236.26888.40.camel@haakon2.linux-iscsi.org>
	 <20100608084443C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:30792 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751670Ab0FHAT5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2010 20:19:57 -0400
In-Reply-To: <20100608084443C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com

On Tue, 2010-06-08 at 08:45 +0900, FUJITA Tomonori wrote:
> On Mon, 07 Jun 2010 01:27:16 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Mon, 2010-06-07 at 15:45 +0900, FUJITA Tomonori wrote:
> > > On Sun,  6 Jun 2010 20:50:15 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > 
> > > > Greeting STGT folks,
> > > > 
> > > > This is the third round of patches for adding proper LUN passthrough support into STGT
> > > > using struct scsi_lu->cmd_perform() and struct scsi_lu->cmd_done() callers with existing
> > > > SG_IO and the new BSG v4 backstores.
> > > > 
> > > > Following Tomo-san's input, the changelog between v2 -> v3 is as follows:
> > > > 
> > > > 1) Add struct device_type_template sg_template for SG_IO and BSG in usr/bs_sg.c instead
> > > >    of making changes to usr/sbc.c
> > > > 
> > > > 2) Add struct backingstore_template->bs_passthrough member of type int for SG_IO and BSG.
> > > > 
> > > > 3) In usr/target.c:tgt_device_create() pass bst->bs_passthrough into device_type_lookup()
> > > >    and for passthrough case use the new device_type_passthrough() to locate
> > > >    struct device_type_template sg_template.
> > > > 
> > > > 4) Remove unnecessary post_cmd_done() from usr/target.c:__cmd_done_passthrough()
> > > > 
> > > > This patch series has been tested with STGT/iSCSI using 'sg'+'bsg' and 'rdwr' for non
> > > > passthrough mode backstores into TCM_Loop LLD emulated iSCSI target ports.
> > > > 
> > > > Best,
> > > > 
> > > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org
> > > > 
> > > > Nicholas Bellinger (3):
> > > >   [tgt]: Add proper STGT LUN backstore passthrough support (rev 3)
> > > >   [tgt]: Add bs_sg struct device_type_template sg_template and struct
> > > >     backingstore_template->bs_init()
> > > >   [tgt]: Add BSG v4 backstore support to usr/bs_sg.c
> > > > 
> > > >  usr/bs_sg.c     |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  usr/scsi_cmnd.h |    7 ++
> > > >  usr/target.c    |  113 +++++++++++++++++++++++---
> > > >  usr/tgtd.h      |   16 ++++
> > > >  4 files changed, 362 insertions(+), 21 deletions(-)
> > > 
> > > The first and second patches Look fine overall. I have some comments
> > > and wrote some cleanup patches.
> > > 
> > > I've put the first two patches with my cleanups:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/tgt.git pass
> > > 
> > > Can you confirm that it works for you? Then I can merge them into
> > > master.
> > 
> > The pass branch works fine using '-E sg -Y pt' for SG_IO backstore <->
> > fabric LUN assocation with TCM_Loop LLD Target Ports.  Thanks for
> > cleaning things up to use TYPE_PT btw, I should have asked about that
> > earlier. ;)
> 
> Thanks for the confirmation. I've merged these patches into master.
> 
> I'll merge your bsg patch if nobody complains about dropping sg
> support in a few days.
> 

Perfect, thank you Tomo-san.

Best,

--nab

