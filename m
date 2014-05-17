From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target fixes for v3.15-rc6
Date: Sat, 17 May 2014 15:56:00 -0700
Message-ID: <1400367360.16727.3.camel@haakon3.risingtidesystems.com>
References: <1400275930.7353.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400275930.7353.17.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-05-16 at 14:32 -0700, Nicholas A. Bellinger wrote:
> Hello Linus,
> 
> Here are the target-pending fixes for v3.15-rc6.  Please go ahead and
> pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
> 
> This series include:
> 
>   - Close race between iser-target network portal shutdown + accepting 
>     new connection logins (sagi)
>   - Fix free-after-use regression in tcm_fc post conversion to 
>     percpu-ida pre-allocation (nab)
>   - Explicitly disable Immediate + Unsolicited Data for iser-target 
>     connections when T10-PI is enabled (sagi + nab)
>   - Allow pi_prot_type + emulate_write_cache attributes to be set to
>     zero regardless of backend support (andy)
> 

Hi Linus,

One last minute bugfix from Mikulas has been included in this PULL
request.  Here is the updated short-log + diffstat.

Thank you,

--nab

Andy Grover (2):
  target: Allow non-supporting backends to set pi_prot_type to 0
  target: Don't allow setting WC emulation if device doesn't support

Mikulas Patocka (1):
  target: fix memory leak on XCOPY

Nicholas Bellinger (3):
  iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
  tcm_fc: Fix free-after-use regression in ft_free_cmd
  iscsi-target: Disable Immediate + Unsolicited Data with ISER
    Protection

Sagi Grimberg (3):
  Target/iser: Fix wrong connection requests list addition
  Target/iser: Fix iscsit_accept_np and rdma_cm racy flow
  Target/iscsi,iser: Avoid accepting transport connections during stop
    stage

 drivers/infiniband/ulp/isert/ib_isert.c   |   38 +++++++++++++----------------
 drivers/infiniband/ulp/isert/ib_isert.h   |    2 +-
 drivers/target/iscsi/iscsi_target.c       |    4 ++-
 drivers/target/iscsi/iscsi_target_core.h  |    1 +
 drivers/target/iscsi/iscsi_target_login.c |   28 ++++++++++++++++++++-
 drivers/target/iscsi/iscsi_target_tpg.c   |    1 +
 drivers/target/target_core_device.c       |   12 ++++++---
 drivers/target/target_core_transport.c    |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c           |    8 +++---
 9 files changed, 63 insertions(+), 33 deletions(-)

-- 
1.7.10.4
