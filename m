From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/11] qla2xxx: Updates for Target Mode driver
Date: Mon, 06 Jul 2015 18:16:09 -0700
Message-ID: <1436231769.6297.7.camel@haakon3.risingtidesystems.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: jbottomley@parallels.com, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu & Co,

(Adding target-devel for the qla_target.c bits, please include this 
 list for future target patches :-)

On Thu, 2015-06-25 at 12:33 -0400, Himanshu Madhani wrote:
> Hi James, 
> 
> This series is applied on top of patch series sent on June 10
>   [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch 
> (http://marc.info/?l=linux-scsi&m=143395156920505&w=2)
> 
> These set of patches addresses issue with reuse of stale command found
> in a customer enviorment. Here's sequence of events which could result
> into this reuse of stale command which could potentially lead to data
> corruption.
> 
>  - Backend driver goes out of sync with front end driver due to session 
>    management problem.
>  - During this time a session receives a NEW login by the same initiator.
>  - All the commands from previous session are not flushed before establishing
>    a new session/connection. 
>  - These stale commands leaks into new session resulting into case
>    where they could potentially share same Exchange ID. 
> 
> In such case data can cross path between old and new session when the frontend
> driver/fabric driver allows a new connection to be established without backend
> knowledge. To fix this problem, old session is destroyed first before creating
> new session. The session destroy process would wait for all existing commands
> to finish. 
> 
> Please apply these patches to scsi tree at your earliest for inclusion in the
> next mainline merge window.
> 
> Thanks,
> Himanshu
> 
> Alexei Potashnik (8):
>   qla2xxx: delay plogi/prli ack until existing sessions are deleted
>   qla2xxx: Abort stale cmds on qla_tgt_wq when plogi arrives
>   qla2xxx: added sess generations to detect RSCN update races
>   qla2xxx: disable scsi_transport_fc registration in target mode
>   qla2xxx: drop cmds/tmrs arrived while session is being deleted
>   qla2xxx: terminate exchange when command is aborted by LIO
>   qla2xxx: delete session if initiator is gone from FW
>   qla2xxx: wait for all conflicts before ack'ing PLOGI
> 
> Himanshu Madhani (1):
>   qla2xxx: Added interface to send ELS commands from driver.
> 
> Roland Dreier (1):
>   qla2xxx: kill sessions/log out initiator on RSCN and port down events
> 
> Swapnil Nagle (1):
>   qla2xxx: cleanup cmd in qla workqueue before processing TMR
> 
>  drivers/scsi/qla2xxx/qla_attr.c    |   36 ++
>  drivers/scsi/qla2xxx/qla_dbg.c     |   13 +-
>  drivers/scsi/qla2xxx/qla_def.h     |   35 ++-
>  drivers/scsi/qla2xxx/qla_gbl.h     |    2 +
>  drivers/scsi/qla2xxx/qla_init.c    |  188 ++++++--
>  drivers/scsi/qla2xxx/qla_inline.h  |    2 +
>  drivers/scsi/qla2xxx/qla_iocb.c    |  192 ++++++++
>  drivers/scsi/qla2xxx/qla_isr.c     |    6 +
>  drivers/scsi/qla2xxx/qla_os.c      |   13 +-
>  drivers/scsi/qla2xxx/qla_target.c  |  930 +++++++++++++++++++++++++++++++++---
>  drivers/scsi/qla2xxx/qla_target.h  |   88 +++-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   23 +-
>  12 files changed, 1387 insertions(+), 141 deletions(-)
> 

Since this series addresses a real correctness problem and is destined
for stable backports, I don't see a reason to wait until the v4.3-rc1
merge window to merge this code, even though it's a pretty large change.

James, are you going to push this for v4.2-rc scsi-core fixes, or shall
I push via target-pending/master instead..?

Thank you,

--nab 
