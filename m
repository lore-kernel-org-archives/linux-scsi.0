Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D1DC6FD19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 02:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCNCRo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 22:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjCNCRn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 22:17:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9023865
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 19:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678760214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDI9a4PGMS7v7dYkqxakinptlAmRw+fHRtslDR4dFEQ=;
        b=e5cmYHmgspsO+N8sa5KfM5VIpDmtkSJzWBXaq6VvUgPuWNMV98X0PdWXYDKGe4pg3dXe9P
        R6ot4IYs5/Nj6ZJQO86+F/qd6uA3qVuhmmtSgLXukd3X/RKYTzRC6ciDD98B++JIEI00gj
        qdewOLTKzYduWK8WkD9G+JwT3vjxkEg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-E3YgXtFhM22xC23WQwz2bg-1; Mon, 13 Mar 2023 22:16:51 -0400
X-MC-Unique: E3YgXtFhM22xC23WQwz2bg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB6E7811E9C;
        Tue, 14 Mar 2023 02:16:50 +0000 (UTC)
Received: from [10.22.8.166] (unknown [10.22.8.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63B07C164E7;
        Tue, 14 Mar 2023 02:16:50 +0000 (UTC)
Message-ID: <ad5185d5-f363-f49f-6d77-90e3a0ade2f0@redhat.com>
Date:   Mon, 13 Mar 2023 22:16:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] qla2xxx: perform lockless command completion in abort
 path
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com, emilne@redhat.com
References: <20230313043711.13500-1-njavali@marvell.com>
 <20230313043711.13500-2-njavali@marvell.com>
From:   John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20230313043711.13500-2-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has been tested at Red Hat and found to fix the reported problem.

Test-by: Lin Li <lilin@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>


On 3/13/23 00:37, Nilesh Javali wrote:
> While adding and removing the controller, call trace was observed,
> 
> WARNING: CPU: 3 PID: 623596 at kernel/dma/mapping.c:532 dma_free_attrs+0x33/0x50
> CPU: 3 PID: 623596 Comm: sh Kdump: loaded Not tainted 5.14.0-96.el9.x86_64 #1
> RIP: 0010:dma_free_attrs+0x33/0x50
> 
> Call Trace:
>     qla2x00_async_sns_sp_done+0x107/0x1b0 [qla2xxx]
>     qla2x00_abort_srb+0x8e/0x250 [qla2xxx]
>     ? ql_dbg+0x70/0x100 [qla2xxx]
>     __qla2x00_abort_all_cmds+0x108/0x190 [qla2xxx]
>     qla2x00_abort_all_cmds+0x24/0x70 [qla2xxx]
>     qla2x00_abort_isp_cleanup+0x305/0x3e0 [qla2xxx]
>     qla2x00_remove_one+0x364/0x400 [qla2xxx]
>     pci_device_remove+0x36/0xa0
>     __device_release_driver+0x17a/0x230
>     device_release_driver+0x24/0x30
>     pci_stop_bus_device+0x68/0x90
>     pci_stop_and_remove_bus_device_locked+0x16/0x30
>     remove_store+0x75/0x90
>     kernfs_fop_write_iter+0x11c/0x1b0
>     new_sync_write+0x11f/0x1b0
>     vfs_write+0x1eb/0x280
>     ksys_write+0x5f/0xe0
>     do_syscall_64+0x5c/0x80
>     ? do_user_addr_fault+0x1d8/0x680
>     ? do_syscall_64+0x69/0x80
>     ? exc_page_fault+0x62/0x140
>     ? asm_exc_page_fault+0x8/0x30
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The command was completed in abort path during driver unload
> with a lock held causing the warning in abort path.
> Hence complete the command without any lock held.
> 
> Reported-by: Lin Li <lilin@redhat.com>
> Tested-by: Lin Li <lilin@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 545167627e48..d2f6c0546587 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1858,6 +1858,17 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
>   	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
>   		sp = req->outstanding_cmds[cnt];
>   		if (sp) {
> +			/*
> +			 * perform lockless completion while driver unload
> +			 */
> +			if (qla2x00_chip_is_down(vha)) {
> +				req->outstanding_cmds[cnt] = NULL;
> +				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
> +				sp->done(sp, res);
> +				spin_lock_irqsave(qp->qp_lock_ptr, flags);
> +				continue;
> +			}
> +
>   			switch (sp->cmd_type) {
>   			case TYPE_SRB:
>   				qla2x00_abort_srb(qp, sp, res, &flags);

