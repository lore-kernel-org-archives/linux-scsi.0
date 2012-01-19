From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/13] Misc patches leading to target_submit_tmr
Date: Thu, 19 Jan 2012 15:57:13 -0800
Message-ID: <1327017433.16983.277.camel@haakon2.linux-iscsi.org>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38095 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2ASX5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 18:57:15 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com

On Thu, 2012-01-19 at 13:39 -0800, Andy Grover wrote:
> Hi nab, Kiran, and all,
> 
> Here are some cleanup patches to target, scsi, and tcm_fc. The biggest
> change is adding a target_submit_tmr to match the new target_submit_cmd
> helper function. I've only changed tcm_fc to use it so far, if it looks ok
> I will change over the other fabrics.
> 

Nice work to get target_submit_tmr() added here..

> I'm especially looking for review of the error handling changes in the
> last few patches. Does transport_generic_free_cmd end up doing the
> same thing as ft_sess_put, for example?
> 
> Thanks -- Regards -- Andy
> 

After an initial review I think these look reasonable to merge into
lio-core for testing.

Kiran, could you have a look the tcm_fc pieces and us know if you have
concerns..?

Thanks Andy!

--nab

> The following changes since commit 7acd456a2fdae22d0f43db60f689ba3c57b69838:
> 
>   target: Fail INQUIRY commands with EVPD==0 but PAGE CODE!=0 (2012-01-17 22:54:29 -0800)
> 
> are available in the git repository at:
>   git://fedorapeople.org/home/fedora/grover/public_git/linux-2.6.git for-nab
> 
> Andy Grover (13):
>       scsi: Use struct scsi_lun in fc/fcp.h
>       target: fix comment typos
>       target: Remove unused struct se_queue_req
>       target/iscsi: Remove unneeded wrapper functions
>       target/fc: Simplify ft_send_work for tmr path
>       target/fc: Remove cmd->cdb data member
>       target: Inline struct se_tmr_req into se_cmd
>       target/fc: Move core->fc code conversion earlier in ft_send_tm()
>       target/fc: Call lookup_tmr_lun() for all TM types
>       target/fc: Use transport_generic_free_cmd for ft_sess_put in ft_send_tm
>       target: Add target_submit_tmr helper function
>       target/fc: Use target_submit_tmr()
>       target: Change target_submit_cmd() to return void
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c      |   18 +---
>  drivers/scsi/bnx2fc/bnx2fc_io.c            |    4 +-
>  drivers/scsi/libfc/fc_fcp.c                |    5 +-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c         |   22 ++---
>  drivers/target/iscsi/iscsi_target.c        |   12 +-
>  drivers/target/iscsi/iscsi_target_device.c |   19 ----
>  drivers/target/iscsi/iscsi_target_device.h |    2 -
>  drivers/target/iscsi/iscsi_target_tmr.c    |    6 +-
>  drivers/target/iscsi/iscsi_target_util.c   |    8 +-
>  drivers/target/loopback/tcm_loop.c         |   14 +--
>  drivers/target/target_core_device.c        |    2 +-
>  drivers/target/target_core_internal.h      |    2 -
>  drivers/target/target_core_tmr.c           |   20 +---
>  drivers/target/target_core_transport.c     |   77 +++++++++++-----
>  drivers/target/tcm_fc/tcm_fc.h             |    2 -
>  drivers/target/tcm_fc/tfc_cmd.c            |  142 ++++++++--------------------
>  include/scsi/fc/fc_fcp.h                   |    6 +-
>  include/target/target_core_base.h          |   47 ++++-----
>  include/target/target_core_fabric.h        |    7 +-
>  19 files changed, 164 insertions(+), 251 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


