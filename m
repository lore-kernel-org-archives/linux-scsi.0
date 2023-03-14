Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86792C6FD19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 02:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCNCT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 22:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjCNCT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 22:19:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825D0233D9
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 19:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678760347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CJhxKziaWlGSeufHjeh9nQWugjoxcfZeQ5ZOCwVqDpM=;
        b=KPJRIZ4n4rjh8evoms3ulF3OH5f+FvdE9ejdha0LDh+6hCJIdQJAu+9iDr05LK762I4Qfq
        Aa04Fi56GlUiOvYtjVJCUHkCI0cSS28sv1bcemhwcpGimtEJqA0Qfr18XR2Cq3Pq5aSLtG
        OsIR3WQNyHSHwDoIF2XSpt7ACqqjBw4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-HAmhGBvSN5q75D9_pYnyUw-1; Mon, 13 Mar 2023 22:19:03 -0400
X-MC-Unique: HAmhGBvSN5q75D9_pYnyUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43F6A101A52E;
        Tue, 14 Mar 2023 02:19:02 +0000 (UTC)
Received: from [10.22.8.166] (unknown [10.22.8.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6B4A40C6E67;
        Tue, 14 Mar 2023 02:19:01 +0000 (UTC)
Message-ID: <8e68d42b-9bee-8454-f077-04cafea5e3a4@redhat.com>
Date:   Mon, 13 Mar 2023 22:19:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] qla2xxx: synchronize the iocb count to be in order
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com, emilne@redhat.com
References: <20230313043711.13500-1-njavali@marvell.com>
 <20230313043711.13500-3-njavali@marvell.com>
From:   John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20230313043711.13500-3-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has been tested at Red Hat and found to fix the reported problem.

Test-by: Lin Li <lilin@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>

On 3/13/23 00:37, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> The system hang observed with below call trace,
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 15 PID: 86747 Comm: nvme Kdump: loaded Not tainted 6.2.0+ #1
> Hardware name: Dell Inc. PowerEdge R6515/04F3CJ, BIOS 2.7.3 03/31/2022
> RIP: 0010:__wake_up_common+0x55/0x190
> Code: 41 f6 01 04 0f 85 b2 00 00 00 48 8b 43 08 4c 8d
>        40 e8 48 8d 43 08 48 89 04 24 48 89 c6\
>        49 8d 40 18 48 39 c6 0f 84 e9 00 00 00 <49> 8b 40 18 89 6c 24 14 31
>        ed 4c 8d 60 e8 41 8b 18 f6 c3 04 75 5d
> RSP: 0018:ffffb05a82afbba0 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: ffff8f9b83a00018 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffff8f9b83a00020 RDI: ffff8f9b83a00018
> RBP: 0000000000000001 R08: ffffffffffffffe8 R09: ffffb05a82afbbf8
> R10: 70735f7472617473 R11: 5f30307832616c71 R12: 0000000000000001
> R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f815cf4c740(0000) GS:ffff8f9eeed80000(0000)
> 	knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010633a000 CR4: 0000000000350ee0
> Call Trace:
>      <TASK>
>      __wake_up_common_lock+0x83/0xd0
>      qla_nvme_ls_req+0x21b/0x2b0 [qla2xxx]
>      __nvme_fc_send_ls_req+0x1b5/0x350 [nvme_fc]
>      nvme_fc_xmt_disconnect_assoc+0xca/0x110 [nvme_fc]
>      nvme_fc_delete_association+0x1bf/0x220 [nvme_fc]
>      ? nvme_remove_namespaces+0x9f/0x140 [nvme_core]
>      nvme_do_delete_ctrl+0x5b/0xa0 [nvme_core]
>      nvme_sysfs_delete+0x5f/0x70 [nvme_core]
>      kernfs_fop_write_iter+0x12b/0x1c0
>      vfs_write+0x2a3/0x3b0
>      ksys_write+0x5f/0xe0
>      do_syscall_64+0x5c/0x90
>      ? syscall_exit_work+0x103/0x130
>      ? syscall_exit_to_user_mode+0x12/0x30
>      ? do_syscall_64+0x69/0x90
>      ? exit_to_user_mode_loop+0xd0/0x130
>      ? exit_to_user_mode_prepare+0xec/0x100
>      ? syscall_exit_to_user_mode+0x12/0x30
>      ? do_syscall_64+0x69/0x90
>      ? syscall_exit_to_user_mode+0x12/0x30
>      ? do_syscall_64+0x69/0x90
>      entry_SYSCALL_64_after_hwframe+0x72/0xdc
>      RIP: 0033:0x7f815cd3eb97
> 
> The iocb counts are out of order that would block any commands from
> going out and hang the system. Synchronize the iocb count to be in
> correct order.
> 
> Fixes: 5f63a163ed2f ("scsi: qla2xxx: Fix exchange oversubscription for management commands")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 030625ebb4e6..71feda2cdb63 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1900,6 +1900,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
>   	}
>   
>   	req->outstanding_cmds[index] = NULL;
> +
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
>   	return sp;
>   }
>   
> @@ -3112,7 +3114,6 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
>   	}
>   	bsg_reply->reply_payload_rcv_len = 0;
>   
> -	qla_put_fw_resources(sp->qpair, &sp->iores);
>   done:
>   	/* Return the vendor specific reply to API */
>   	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;

