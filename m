From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round two)
Date: Sun, 06 Nov 2011 18:59:38 -0800
Message-ID: <1320634778.18988.10.camel@haakon2.linux-iscsi.org>
References: <1320437345.5859.94.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320437345.5859.94.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

This is just a friendly reminder to please pull the two remaining
target-pending branches (for-next and for-next-merge) for -rc1.

Thank you,

--nab

On Fri, 2011-11-04 at 13:09 -0700, Nicholas A. Bellinger wrote:
> Hi Linus,
> 
> The following is the second round of target core updates for the v3.2
> merge window.  Please go ahead and pull from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> 
> A separate PULL request for the ib_srpt fabric merge will be going out
> shortly.
> 
> This series includes:
> 
> *) Bugfixes from Joern for TMR processing during LUN_RESET handling
> *) Bugfix for tcm_loop to explictly clear control CDB READ payload
> *) Conversion of TFO->check_stop_free to return status as a hint to
>    LUN_RESET processing
> *) Removal of TRANSPORT_FREE_CMD_INTR in favor of per fabric release
>    workqueues
> *) Initial pieces of generic active I/O shutdown tracking.  (Will be enabled
>    for ib_srpt in a seperate patch)
> *) Convert control CDB code to pass se_task into CDB emulation callback
> *) Refactoring of CDB emulation from Christoph to universally use
>    cmd->execute_task()
> 
> The generic active I/O shutdown bits and ->execute_task conversion got
> in a bit late, but I still think are suitable v3.2 material.  Also, we
> have one more bugfix+cleanup patch to remove legacy PYX_TRANSPORT_*
> return code usage still being discussed, and will be sent out post merge
> window to address existing breakage with se_cmd->scsi_sense_reason
> assignment and errno return code conversion.
> 
> Thanks!
> 
> --nab
> 
> Christoph Hellwig (7):
>   target: add back error handling in transport_complete_task
>   target: split core_scsi2_emulate_crh
>   target: split core_scsi3_emulate_pr
>   target: pass the se_task to the CDB emulation callback
>   target: refactor transport_emulate_control_cdb
>   target: remove SCF_EMULATE_CDB_ASYNC
>   target: use ->exectute_task for all CDB emulation
> 
> Dan Carpenter (1):
>   target/pscsi: blk_make_request() returns an ERR_PTR()
> 
> Joern Engel (4):
>   target: Fix incorrect se_cmd assignment in core_tmr_drain_tmr_list
>   target: Fix wrong se_tmr being added to drain_tmr_list
>   target: Minor cleanups to core_tmr_drain_tmr_list
>   target: Avoid double list_del for aborted se_tmr_req
> 
> Nicholas Bellinger (8):
>   target: Fix compile warning w/ missing module.h include
>   tcm_loop: Add explict read buffer memset for
>     SCF_SCSI_CONTROL_SG_IO_CDB
>   target: Check -ENOMEM to signal QUEUE_FULL from fabric callbacks
>   iscsi-target: Add missing CMDSN_LOWER_THAN_EXP check in
>     iscsit_handle_scsi_cmd
>   iscsi-target: Fix non-immediate TMR handling
>   target: Make TFO->check_stop_free return free status
>   target: Remove core TRANSPORT_FREE_CMD_INTR usage
>   target: Add generic active I/O shutdown logic
> 
>  drivers/target/iscsi/iscsi_target.c     |   11 +-
>  drivers/target/loopback/tcm_loop.c      |   23 ++-
>  drivers/target/target_core_alua.c       |   11 +-
>  drivers/target/target_core_alua.h       |    4 +-
>  drivers/target/target_core_cdb.c        |  217 +++++++-----------
>  drivers/target/target_core_cdb.h        |   14 +
>  drivers/target/target_core_device.c     |   14 +-
>  drivers/target/target_core_pr.c         |  349 ++++++++++++++++------------
>  drivers/target/target_core_pr.h         |    7 +-
>  drivers/target/target_core_pscsi.c      |    2 +-
>  drivers/target/target_core_tmr.c        |   23 +--
>  drivers/target/target_core_transport.c  |  392 ++++++++++++++++++++-----------
>  drivers/target/tcm_fc/tcm_fc.h          |    2 +-
>  drivers/target/tcm_fc/tfc_cmd.c         |    3 +-
>  include/target/target_core_base.h       |   13 +-
>  include/target/target_core_device.h     |    2 +-
>  include/target/target_core_fabric_ops.h |   11 +-
>  include/target/target_core_transport.h  |    7 +-
>  18 files changed, 630 insertions(+), 475 deletions(-)
>  create mode 100644 drivers/target/target_core_cdb.h
> 
