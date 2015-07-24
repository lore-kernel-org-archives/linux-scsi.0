From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 0/8] qla2xxx: Updates for Target Mode driver
Date: Fri, 24 Jul 2015 00:38:51 -0700
Message-ID: <1437723531.8929.43.camel@haakon3.risingtidesystems.com>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: jbottomley@parallels.com, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-07-14 at 16:00 -0400, Himanshu Madhani wrote:
> Hi James,
> 
> This series is applied on top of patch series sent on June 10
>    [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch
> (http://marc.info/?l=linux-scsi&m=143395156920505&w=2)
> 
> These set of patches addresses issue with reuse of stale command found
> in a customer enviorment. Here's sequence of events which could result
> into this reuse of stale command which could potentially lead to data
> corruption.
>   - Backend driver goes out of sync with front end driver due to session
>     management problem.
>   - During this time a session receives a NEW login by the same initiator.
>   - All the commands from previous session are not flushed before establishing
>     a new session/connection.
>   - These stale commands leaks into new session resulting into case
>     where they could potentially share same Exchange ID.
> In such case data can cross path between old and new session when the frontend
> driver/fabric driver allows a new connection to be established without backend
> knowledge. To fix this problem, old session is destroyed first before creating
> new session. The session destroy process would wait for all existing commands
> to finish.
> 
> The Changes from v1 of this series are:
> 
> - Rebased patch series on top of v4.2.0-rc1+.
> - Dropped following patches and will be sent as seperate series.
>   qla2xxx: Added interface to send ELS commands from driver.
>   qla2xxx: delete session if initiator is gone from FW
>   qla2xxx: wait for all conflicts before ack'ing PLOGI 
> 
> Please apply these patches to scsi tree at your earliest for inclusion in the
> next mainline merge window.
> 
> Thanks,
> Himanshu
> 
> Alexei Potashnik (6):
>   qla2xxx: delay plogi/prli ack until existing sessions are deleted
>   qla2xxx: Abort stale cmds on qla_tgt_wq when plogi arrives
>   qla2xxx: added sess generations to detect RSCN update races
>   qla2xxx: disable scsi_transport_fc registration in target mode
>   qla2xxx: drop cmds/tmrs arrived while session is being deleted
>   qla2xxx: terminate exchange when command is aborted by LIO
> 
> Roland Dreier (1):
>   qla2xxx: kill sessions/log out initiator on RSCN and port down events
> 
> Swapnil Nagle (1):
>   qla2xxx: cleanup cmd in qla workqueue before processing TMR
> 
>  drivers/scsi/qla2xxx/qla_dbg.c     |    6 +-
>  drivers/scsi/qla2xxx/qla_def.h     |   12 +
>  drivers/scsi/qla2xxx/qla_init.c    |  188 ++++++++--
>  drivers/scsi/qla2xxx/qla_iocb.c    |    3 +
>  drivers/scsi/qla2xxx/qla_os.c      |   11 +-
>  drivers/scsi/qla2xxx/qla_target.c  |  714 +++++++++++++++++++++++++++++++++---
>  drivers/scsi/qla2xxx/qla_target.h  |   69 +++-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   23 +-
>  8 files changed, 906 insertions(+), 120 deletions(-)
> 

Thanks for re-submitting the patches that only address outstanding
qla2xxx target mode bugs.

Normally I would be apprehensive about merging this for v4.2-rc code,
given the size of the changes involved..

However, the changes are localized to qla2xxx target, are submitted by
the hardware LLD maintainer(s), contributed by an serious customer of
the code, and are all marked for CC' stable.  Given these circumstances,
it doesn't make sense to wait another 6 weeks to get these real-world
bug-fixes into mainline.

That said, I'm applying this series to target-pending/master now, and
will be planning to include in the v4.2-rc fixes PULL request to Linus
sometime next week.  Please let me know if the series has issues, and
should not be merged up.

As mentioned in the previous email, also please let me know which
patches in the series preceding this one need to be marked for stable
too, as they will be a stable dependency for this series.

Thank you QLogic + Pure Storage folks.

--nab
