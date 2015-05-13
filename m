From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to RCU
 hlist
Date: Tue, 12 May 2015 22:41:03 -0700
Message-ID: <1431495663.26897.47.camel@haakon3.risingtidesystems.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
	 <1431422736-29125-2-git-send-email-nab@daterainc.com>
	 <5552696F.8080904@redhat.com>
	 <1431493731.26897.35.camel@haakon3.risingtidesystems.com>
	 <20150513053233.GA20663@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150513053233.GA20663@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-05-13 at 07:32 +0200, Christoph Hellwig wrote:
> On Tue, May 12, 2015 at 10:08:51PM -0700, Nicholas A. Bellinger wrote:
> > The series is bisectable.  With patch #1 in place ->device_list[] is
> > still kzalloc()'ed, but new RCU pointer assignments are made into
> > lun_entry_hlist[].
> > 
> > Squashing the RCU reader paths (#2-6) for merge is OK, but it's still
> > nice to break up reader / updater changes into separate patches.
> 
> Having the full data structure switch over in one patch really makes
> reviewing and understning the change a lot easier.  But changes to
> say move to a mutex should indeed stay separate.  So patches 1-6
> really should be mostly one.

Well, was thinking 1-6 is too big for one patch, but I guess it's not so
bad:

 drivers/target/target_core_device.c          | 268 +++++++++++++++++++++++++++---------------------
 drivers/target/target_core_fabric_configfs.c |  35 ++++---
 drivers/target/target_core_internal.h        |   1 +
 drivers/target/target_core_pr.c              |   1 +
 drivers/target/target_core_pscsi.c           |  17 ++-
 drivers/target/target_core_spc.c             |  27 +++--
 drivers/target/target_core_stat.c            | 180 ++++++++++++++++----------------
 drivers/target/target_core_tpg.c             |  59 +++--------
 drivers/target/target_core_ua.c              |  51 ++++++---
 include/target/target_core_base.h            |   8 +-
 10 files changed, 350 insertions(+), 297 deletions(-)
