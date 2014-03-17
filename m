From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] DIF fixes for kernel 3.15
Date: Mon, 17 Mar 2014 11:16:18 -0700
Message-ID: <1395080178.28843.5.camel@haakon3.risingtidesystems.com>
References: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43176 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaCQSQ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2014 14:16:59 -0400
In-Reply-To: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: oren@mellanox.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2014-03-17 at 12:52 +0200, Sagi Grimberg wrote:
> Hey Nic,
> 
> So here are a couple of fixes for iSER target DIF on top of latest
> for-next for 3.15.
> 
> Patch #1 fixes suppressed completions for REG_SIG_MR work requests.
> 
> Patch #2 fixes accounting of post_send_buf_count when RDMA_READs may
> get a completion (required in the DIF case).
> 
> Patch #3 moves the DIF status check to a function to avoid code
> duplication (was fixed before but I'm not sure where it got lost).
> 
> Patch #4 adds the protection-passthrough-only mode that we agreed on
> for loopback/vhost_scsi transports.
> 
> This set survived a couple of hours of:
> - Stress IO (with/without DIF)
> - Live target shutdown & resume (during traffic)
> - Login/Logout
> 
> I can try and split Patch #2 if you want to squash it in.
> 
> Sagi Grimberg (4):
>   Target/iser: Fix signature work requests accounting
>   Target/iser: Consider DIF and RDMA_READ completions when calculating
>     post_send counter
>   Target/iser: Move check signature status to a function
>   Target/dif: Introduce protection-passthough-only mode
> 
>  drivers/infiniband/ulp/isert/ib_isert.c |  164 +++++++++++++++++-------------
>  drivers/target/loopback/tcm_loop.c      |    4 +
>  drivers/target/target_core_sbc.c        |    3 +
>  drivers/target/target_core_transport.c  |   13 ---
>  include/target/target_core_base.h       |    1 +
>  5 files changed, 101 insertions(+), 84 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Sagi!

--nab

