Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D50C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 01:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiGMBgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 21:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiGMBgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 21:36:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42BD7CC7B1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 18:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657676191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3corEyGUa7n76ZHzeb/ekE4eOj1Jvf2szUlr90eBJ1s=;
        b=LMSyMkxPCYVVgFVK4IupLaq6Qc2yJWRmamoJXb/SvCi84eW0Y1jiwkUXuCeeiYE0SktV0l
        clLUKR9583wQedJzmtDqV7bRpuF3cbr+xeOKQtPfe8EniaPuZ1JEI5MtgJiNTto1XVAvu5
        nBlaXwaK/jruhtF+MCLuzoJTjvbQrBw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-J5y37vDjOnmG0VWgOPk1cw-1; Tue, 12 Jul 2022 21:36:26 -0400
X-MC-Unique: J5y37vDjOnmG0VWgOPk1cw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DF85811E75;
        Wed, 13 Jul 2022 01:36:25 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1023CC1D38B;
        Wed, 13 Jul 2022 01:36:18 +0000 (UTC)
Date:   Wed, 13 Jul 2022 09:36:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v4 4/4] scsi: core: Call blk_mq_free_tag_set() earlier
Message-ID: <Ys4hjViRcK3F975M@T590>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712221936.1199196-5-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2022 at 03:19:36PM -0700, Bart Van Assche wrote:
> There are two .exit_cmd_priv implementations. Both implementations use
> resources associated with the SCSI host. Make sure that these resources are
> still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
> calls from scsi_host_dev_release() to scsi_forget_host(). Moving
> blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_forget_host() is
> safe because scsi_forget_host() waits until all SCSI devices associated
> with the host have been removed.
> 
> This patch fixes the following use-after-free:
> 
> ==================================================================
> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
> Read of size 8 at addr ffff888100337000 by task multipathd/16727
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x44
>  print_report.cold+0x5e/0x5db
>  kasan_report+0xab/0x120
>  srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>  scsi_mq_exit_request+0x4d/0x70
>  blk_mq_free_rqs+0x143/0x410
>  __blk_mq_free_map_and_rqs+0x6e/0x100
>  blk_mq_free_tag_set+0x2b/0x160
>  scsi_host_dev_release+0xf3/0x1a0
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  scsi_device_dev_release_usercontext+0x4c1/0x4e0
>  execute_in_process_context+0x23/0x90
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  scsi_disk_release+0x3f/0x50
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  disk_release+0x17f/0x1b0
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  dm_put_table_device+0xa3/0x160 [dm_mod]
>  dm_put_device+0xd0/0x140 [dm_mod]
>  free_priority_group+0xd8/0x110 [dm_multipath]
>  free_multipath+0x94/0xe0 [dm_multipath]
>  dm_table_destroy+0xa2/0x1e0 [dm_mod]
>  __dm_destroy+0x196/0x350 [dm_mod]
>  dev_remove+0x10c/0x160 [dm_mod]
>  ctl_ioctl+0x2c2/0x590 [dm_mod]
>  dm_ctl_ioctl+0x5/0x10 [dm_mod]
>  __x64_sys_ioctl+0xb4/0xf0
>  dm_ctl_ioctl+0x5/0x10 [dm_mod]
>  __x64_sys_ioctl+0xb4/0xf0
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Li Zhijian <lizhijian@fujitsu.com>
> Reported-by: Li Zhijian <lizhijian@fujitsu.com>
> Tested-by: Li Zhijian <lizhijian@fujitsu.com>
> Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

