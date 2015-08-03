From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3] target: Drop iSCSI use of mutex around max_cmd_sn
 increment
Date: Sun, 02 Aug 2015 23:21:47 -0700
Message-ID: <1438582907.16598.92.camel@haakon3.risingtidesystems.com>
References: <1437602898-15229-2-git-send-email-sbaugh@catern.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295AA03CD1@G9W0745.americas.hpqcorp.net>
	 <87r3nyg1km.fsf@ponos.purestorage.com>
	 <87egjyfsmb.fsf@ponos.purestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <87egjyfsmb.fsf@ponos.purestorage.com>
Sender: target-devel-owner@vger.kernel.org
To: Spencer Baugh <spencer.baugh@purestorage.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Spencer Baugh <sbaugh@catern.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Alexei Potashnik <alexei@purestorage.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, James Bottomley <JBottomley@Odin.com>, Evgenii Lepikhin <johnlepikhin@gmail.com>, Hannes Reinecke <hare@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-07-23 at 14:53 -0700, Spencer Baugh wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> In a performance profile, taking a mutex in iscsit_increment_maxcmdsn()
> shows up very high.  However taking a mutex around "sess->max_cmd_sn += 1"
> seems pretty silly: we're not serializing against other contexts in
> any useful way.
> 
> I did a quick audit and there don't appear to be any other places that
> use max_cmd_sn within the mutex more than once, so this lock can't be
> providing any useful serialization.
> 
> v2: Get correct values for logging
> v3: Fix whitespace damage
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Signed-off-by: Spencer Baugh <sbaugh@catern.com>
> ---
>  drivers/target/iscsi/iscsi_target.c          | 18 +++++++++---------
>  drivers/target/iscsi/iscsi_target_configfs.c |  6 ++++--
>  drivers/target/iscsi/iscsi_target_device.c   |  7 ++-----
>  drivers/target/iscsi/iscsi_target_login.c    |  2 +-
>  drivers/target/iscsi/iscsi_target_nego.c     |  9 +++------
>  drivers/target/iscsi/iscsi_target_tmr.c      |  2 +-
>  drivers/target/iscsi/iscsi_target_util.c     |  7 ++++---
>  include/target/iscsi/iscsi_target_core.h     |  2 +-
>  8 files changed, 25 insertions(+), 28 deletions(-)
> 

A nice optimization for iscsi-target + ib_isert on this patch.

Applied to target-pending/for-next. 

Thanks Roland & Co.
