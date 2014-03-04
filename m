From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 0/6] iser-target: Fix active I/O shutdown related issues
Date: Tue, 04 Mar 2014 17:17:16 +0200
Message-ID: <5315EE7C.3030806@dev.mellanox.co.il>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50818 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaCDPRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2014 10:17:22 -0500
Received: by mail-ee0-f45.google.com with SMTP id d17so4869387eek.32
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2014 07:17:21 -0800 (PST)
In-Reply-To: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 3/4/2014 2:00 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Hi Or & Sagi,
>
> This series addresses a number of active I/O shutdown related issues
> in iser-target code that have come up recently during stress testing.
>
> Note there is still a seperate iser-target network portal shutdown
> bug being tracked down, but this series addresses all existing issues
> related to active I/O session shutdown.
>
> The patch breakdown looks like:
>
> Patch #1 fixes a long-standing bug where TPGs in shutdown incorrectly
> could be referenced by new login attempts.
>
> Patch #2 converts list_del -> list_del_init for iscsi_cmd->i_conn_node
> so that list_empty works correctly.
>
> Patch #3 addresses isert_conn->state related bugs resulting in hung
> shutdown, and splits isert_free_conn() into seperate code that is
> called earlier during shutdown to ensure that all outstanding I/O
> has completed.
>
> Patch #4 fixes incorrect accounting of ->post_send_buf_count during
> active I/O shutdown with outstanding RDMA WRITE + RDMA READ work
> requests.
>
> Patch #5 addresses a bug related to active I/O shutdown with
> outstanding FRMR work requests.  Note this patch is specific to
> v3.12+ code.
>
> Patch #6 addresses bugs related to active I/O shutdown with
> outstanding completion interrupt coalescing batches. Note this patch
> is specific to v3.13+ code.
>
> Please review.

Hey Nic,

So besides a minor comment, you have my Ack on this set.

More on cleanup flow. isert_cma_handler does not handle 
RDMA_CM_EVENT_TIMEWAIT_EXIT.
To be more specific, according to IB spec, when initiating disconnect 
(rdma_disconnect/ib_send_cm_dreq),
one should not destroy a used qp until getting TIMEWAIT_EXIT CM event. 
We are working on this in iSER initiator.
It might lead to "stale connection" CM rejects on future connections 
(SRP also does not do that).

Sagi.

> --nab
>
> Nicholas Bellinger (6):
>    iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
>    iscsi/iser-target: Use list_del_init for ->i_conn_node
>    iscsi/iser-target: Fix isert_conn->state hung shutdown issues
>    iser-target: Fix post_send_buf_count for RDMA READ/WRITE
>    iser-target: Ignore completions for FRWRs in isert_cq_tx_work
>    iser-target: Fix command leak for tx_desc->comp_llnode_batch
>
>   drivers/infiniband/ulp/isert/ib_isert.c  |  180 ++++++++++++++++++------------
>   drivers/infiniband/ulp/isert/ib_isert.h  |    7 +-
>   drivers/target/iscsi/iscsi_target.c      |   10 +-
>   drivers/target/iscsi/iscsi_target_erl2.c |   16 +--
>   drivers/target/iscsi/iscsi_target_tpg.c  |    2 +-
>   include/target/iscsi/iscsi_transport.h   |    1 +
>   6 files changed, 129 insertions(+), 87 deletions(-)
>

