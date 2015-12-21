From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 00/16]  qla2xxx: Patches for target-pending branch
Date: Sun, 20 Dec 2015 22:57:27 -0800
Message-ID: <1450681047.25674.32.camel@haakon3.risingtidesystems.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45520 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbbLUG53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 01:57:29 -0500
In-Reply-To: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Hi Himanshu & Co,

On Thu, 2015-12-17 at 14:56 -0500, Himanshu Madhani wrote:
> Hi Nic,
> 
> Please apply this series to target-pending at your earliest convenience.
> 
> changes from v1 -> v2
> 
> o Added Reviewed-by tag for reviewed patches.
> 
> o Dropped following patches for rework.
>   - qla2xxx: Change check_stop_free to always return 1
>   - qla2xxx: Fix interaction issue between qla2xxx and Target Core Module
>   - qla2xxx: Add TAS detection for kernel 3.15 n newer
>   - target/tmr: LUN reset cause cmd premature free.
> 

Thanks for dropping these for the moment.

I'll be following up on outstanding TMR LUN_RESET reference counting
bugs over the holiday.

> o Fixed patch description on following patches
>   - qla2xxx: Enable Extended Login support
>   - qla2xxx: Enable Exchange offload support.
> 
> o Fixed patch description as well as kbuild warning for
>   - qla2xxx: Added interface to send explicit LOGO.
> 
> o Fixed kbuild warning for
>   - qla2xxx: Remove dependency on hardware_lock to reduce lock
>     contention.
> 
> Thanks,
> Himanshu
> 
> Alexei Potashnik (2):
>   qla2xxx: Delete session if initiator is gone from FW
>   qla2xxx: Wait for all conflicts before ack'ing PLOGI
> 
> Dilip Kumar Uppugandla (1):
>   qla2xxx: Check for online flag instead of active reset when
>     transmitting responses
> 
> Himanshu Madhani (4):
>   qla2xxx: Enable Extended Logins support
>   qla2xxx: Enable Exchange offload support.
>   qla2xxx: Enable Target counters in DebugFS.
>   qla2xxx: Added interface to send explicit LOGO.
> 
> Quinn Tran (9):
>   qla2xxx: Add FW resource count in DebugFS.
>   qla2xxx: Replace QLA_TGT_STATE_ABORTED with a bit.
>   qla2xxx: Remove dependency on hardware_lock to reduce lock
>     contention.
>   qla2xxx: Add irq affinity notification
>   qla2xxx: Add selective command queuing
>   qla2xxx: Move atioq to a different lock to reduce lock contention
>   qla2xxx: Disable ZIO at start time.
>   qla2xxx: Set all queues to 4k
>   qla2xxx: Add bulk send for atio & ctio completion paths.
> 
>  drivers/scsi/qla2xxx/qla_attr.c        |   36 ++
>  drivers/scsi/qla2xxx/qla_dbg.c         |   19 +-
>  drivers/scsi/qla2xxx/qla_def.h         |   86 ++++-
>  drivers/scsi/qla2xxx/qla_dfs.c         |  106 +++++
>  drivers/scsi/qla2xxx/qla_gbl.h         |   18 +-
>  drivers/scsi/qla2xxx/qla_init.c        |   58 ++-
>  drivers/scsi/qla2xxx/qla_inline.h      |    2 +
>  drivers/scsi/qla2xxx/qla_iocb.c        |  188 +++++++++
>  drivers/scsi/qla2xxx/qla_isr.c         |  129 ++++++-
>  drivers/scsi/qla2xxx/qla_mbx.c         |  265 ++++++++++++-
>  drivers/scsi/qla2xxx/qla_os.c          |  165 ++++++++-
>  drivers/scsi/qla2xxx/qla_target.c      |  690 +++++++++++++++++++++++++-------
>  drivers/scsi/qla2xxx/qla_target.h      |   36 ++-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  107 ++++-
>  drivers/target/target_core_transport.c |    5 +-
>  include/target/target_core_base.h      |    1 +
>  16 files changed, 1671 insertions(+), 240 deletions(-)
> 

Applied patches #1 -> #14 + #16 to target-pending/for-next code.

Adding commenting inline for patch #15.

Thank you,

--nab

