From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Linux 2.6.38-rc4 (target_core: rmmod GP fault)
Date: Wed, 09 Feb 2011 12:20:35 -0800
Message-ID: <1297282835.18212.57.camel@haakon2.linux-iscsi.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	 <20110209092851.bba6c40c.randy.dunlap@oracle.com>
	 <AANLkTikvGppAi1JCGY1vjAugzpk3g5rDriBjc8k6M9Qg@mail.gmail.com>
	 <1297281744.18212.44.camel@haakon2.linux-iscsi.org>
	 <1297282433.3016.43.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297282433.3016.43.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>, Joel Becker <jlbec@evilplan.org>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-02-09 at 14:13 -0600, James Bottomley wrote:
> On Wed, 2011-02-09 at 12:02 -0800, Nicholas A. Bellinger wrote:
> > On Wed, 2011-02-09 at 11:00 -0800, Linus Torvalds wrote:
> > > On Wed, Feb 9, 2011 at 9:28 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > > x86_64, nearly allmodconfig.  No target hardware.

<SNIP>

> > <nod>  I believe the above patch resolves the specific rmmod issue.
> > However, during SLUB poisioning testing we also came across errors with
> > the incorrect use of struct config_item_operations->release() in
> > target_core_configfs.c and target_core_fabric_configfs.c code.  The
> > series to address these was included in the last series to James here:
> > 
> > [PATCH 00/12] target: Updates for .38-rc4
> > http://marc.info/?l=linux-scsi&m=129680191624837&w=2
> > 
> > Note that this series for-38 mainline needs to be applied on top of the
> > original update series after the drivers/target/ mainline merge:
> > 
> > [PATCH 00/24] target updates for .38-rc3 (v2)
> > http://marc.info/?l=linux-scsi&m=129632617326015&w=2
> > 
> > The entire series is available from
> >      
> >    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc4
> > 
> > James, please review + sign-off so we can get these updates into mainline.
> 
> Firstly, could we get the serious bug fixes identified and separated
> from the general enhancement updates, so they can go in a fixes tree
> without depending on enhancements?  The former category would include
> the /proc interface removal, since we don't want the legacy interface to
> be in a released kernel.
> 

Everything in those two series should be considered bug fixes and
immediate for-38 mainline material.

The target_core_mib.c statistics logic using procfs seq_list() has been
removed in [PATCH 12/12] of the most recent series above.

Thanks,

--nab
