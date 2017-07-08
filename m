From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 00/15] qla2xxx: Add Target Multiqueue support
Date: Fri, 07 Jul 2017 18:48:03 -0700
Message-ID: <1499478483.11042.8.camel@haakon3.risingtidesystems.com>
References: <20170614034730.15428-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170614034730.15428-1-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey guys,

Apologies for missing this earlier.  Comments below.

On Tue, 2017-06-13 at 20:47 -0700, Himanshu Madhani wrote:
> Hi Martin, Nic,
> 
> This patch series adds support for multiqueue for qla2xxx target mode driver.
> 
> This series depends on the seris applied to Martin's scsi/for-next branch
> (https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=for-next)
> 
> I've also added followig patch ("qla2xxx: Include Exchange offload/Extended
> Login into FW dump") which was dropped from earlier series for rework.
> 
> I am planning to send series for FC-NVME support as well which depends on this
> series, so I would like this series to be applied to scsi tree instead of
> target-pending for only this submission, as both series touches common code
> in qla2xxx driver. 
> 
> Please apply this series to for-next for inclusion in 4.13 merge window.
> 
> Note: Comment from Bart for patch#1 will be addresed as new patch after our 
>       FC-NVME series is posted. 
> 
> Changes from v1 --> v2
> 
> o Fixed 0-day kernel compile failure
> 
> Thanks,
> Himanshu 
> 
> Himanshu Madhani (1):
>   qla2xxx: Update driver version to 9.01.00.00-k
> 
> Quinn Tran (13):
>   qla2xxx: Combine Active command arrays.
>   qla2xxx: Preparation for Target MQ.
>   qla2xxx: Enable Target Multi Queue
>   qla2xxx: Add debug knob for user control workload
>   qla2xxx: Add fw_started flags to qpair
>   qla2xxx: move fields from qla_hw_data to qla_qpair
>   qla2xxx: use shadow register for ISP27XX
>   qla2xxx: Add function call to qpair for door bell
>   qla2xxx: Add debug logging routine for qpair
>   qla2xxx: Remove unused tgt_enable_64bit_addr flag
>   qla2xxx: Remove datasegs_per_cmd and datasegs_per_cont field
>   qla2xxx: Move target stat counters from vha to qpair.
>   qla2xxx: Include Exchange offload/Extended Login into FW dump
> 
> Sawan Chandak (1):
>   qla2xxx: Fix mailbox failure while deleting Queue pairs
> 
>  drivers/scsi/qla2xxx/qla_attr.c    |    4 +-
>  drivers/scsi/qla2xxx/qla_dbg.c     |  150 ++++++
>  drivers/scsi/qla2xxx/qla_dbg.h     |   17 +
>  drivers/scsi/qla2xxx/qla_def.h     |  119 ++++-
>  drivers/scsi/qla2xxx/qla_dfs.c     |  137 ++++-
>  drivers/scsi/qla2xxx/qla_gbl.h     |   19 +-
>  drivers/scsi/qla2xxx/qla_init.c    |   53 +-
>  drivers/scsi/qla2xxx/qla_inline.h  |   44 ++
>  drivers/scsi/qla2xxx/qla_iocb.c    |   32 +-
>  drivers/scsi/qla2xxx/qla_isr.c     |   93 +++-
>  drivers/scsi/qla2xxx/qla_mid.c     |   44 +-
>  drivers/scsi/qla2xxx/qla_os.c      |  156 ++++--
>  drivers/scsi/qla2xxx/qla_target.c  | 1028 +++++++++++++++++++++---------------
>  drivers/scsi/qla2xxx/qla_target.h  |   50 +-
>  drivers/scsi/qla2xxx/qla_version.h |    4 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    8 +-
>  16 files changed, 1348 insertions(+), 610 deletions(-)
> 

If it hasn't already been merged to MKP's tree, then:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

Btw, I don't think my missing ACK should hold up qla2xxx patches from
being merged in the future, especially ones that are exposing new
qla2xxx specific functionality.

The only ones that would really need my ACK are ones specific to
interaction with target-core.
