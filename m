Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC3AC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 17:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB0E3221EC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 17:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GeUf1MNh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgIQRdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 13:33:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726202AbgIQRdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 13:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600363981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rmBUT/pYvgtK96UoWJYzCla0EiXSKgDJX1lzo9cTEeU=;
        b=GeUf1MNhIEofyAmkfugEO/Yk0LLfeExw/siQ19wp0KgyYeB+gxZO5l7zvEc9pJVVp2p7d1
        a/WUZwUg4KjqOqJijftfgnFnYTVGyabX2ngIeH5FZ5OeLKs9eFit7EtkyKY1H07Nk+q7xf
        Ql5DAIxz70kpTNrKdlHgfinU3l0IfBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-d3C2VEkeONmoXRS--YAquA-1; Thu, 17 Sep 2020 13:30:48 -0400
X-MC-Unique: d3C2VEkeONmoXRS--YAquA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A36910BBED9;
        Thu, 17 Sep 2020 17:30:46 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B92710023A7;
        Thu, 17 Sep 2020 17:30:45 +0000 (UTC)
Message-ID: <c5e0700bb192a422541d1328db7ca0146edf7a81.camel@redhat.com>
Subject: Re: [PATCH] scsi: alua: fix the race between alua_bus_detach and
 alua_rtpg
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Jitendra Khasdev <jitendra.khasdev@oracle.com>,
        martin.petersen@oracle.com, jejb@linux.ibm.com, hare@suse.com,
        loberman@redhat.com
Cc:     joe.jin@oracle.com, junxiao.bi@oracle.com,
        gulam.mohamed@oracle.com, RITIKA.SRIVASTAVA@ORACLE.COM,
        linux-scsi@vger.kernel.org
Date:   Thu, 17 Sep 2020 13:30:44 -0400
In-Reply-To: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
References: <1600167537-12509-1-git-send-email-jitendra.khasdev@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-09-15 at 16:28 +0530, Jitendra Khasdev wrote:
> This is patch to fix the race occurs between bus detach and alua_rtpg.
> 
> It fluses the all pending workqueue in bus detach handler, so it can avoid
> race between alua_bus_detach and alua_rtpg.
> 
> Here is call trace where race got detected.
> 
> multipathd call stack:
> [exception RIP: native_queued_spin_lock_slowpath+100]
> --- <NMI exception stack> ---
> native_queued_spin_lock_slowpath at ffffffff89307f54
> queued_spin_lock_slowpath at ffffffff89307c18
> _raw_spin_lock_irq at ffffffff89bd797b
> alua_bus_detach at ffffffff8984dcc8
> scsi_dh_release_device at ffffffff8984b6f2
> scsi_device_dev_release_usercontext at ffffffff89846edf
> execute_in_process_context at ffffffff892c3e60
> scsi_device_dev_release at ffffffff8984637c
> device_release at ffffffff89800fbc
> kobject_cleanup at ffffffff89bb1196
> kobject_put at ffffffff89bb12ea
> put_device at ffffffff89801283
> scsi_device_put at ffffffff89838d5b
> scsi_disk_put at ffffffffc051f650 [sd_mod]
> sd_release at ffffffffc051f8a2 [sd_mod]
> __blkdev_put at ffffffff8952c79e
> blkdev_put at ffffffff8952c80c
> blkdev_close at ffffffff8952c8b5
> __fput at ffffffff894e55e6
> ____fput at ffffffff894e57ee
> task_work_run at ffffffff892c94dc
> exit_to_usermode_loop at ffffffff89204b12
> do_syscall_64 at ffffffff892044da
> entry_SYSCALL_64_after_hwframe at ffffffff89c001b8
> 
> kworker:
> [exception RIP: alua_rtpg+2003]
> account_entity_dequeue at ffffffff892e42c1
> alua_rtpg_work at ffffffff8984f097
> process_one_work at ffffffff892c4c29
> worker_thread at ffffffff892c5a4f
> kthread at ffffffff892cb135
> ret_from_fork at ffffffff89c00354
> 
> Signed-off-by: Jitendra Khasdev <jitendra.khasdev@oracle.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index f32da0c..024a752 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1144,6 +1144,9 @@ static void alua_bus_detach(struct scsi_device *sdev)
>  	struct alua_dh_data *h = sdev->handler_data;
>  	struct alua_port_group *pg;
>  
> +	sdev_printk(KERN_INFO, sdev, "%s: flushing workqueues\n", ALUA_DH_NAME);
> +	flush_workqueue(kaluad_wq);
> +
>  	spin_lock(&h->pg_lock);
>  	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>  	rcu_assign_pointer(h->pg, NULL);

I'm not sure this is the best solution.  The current code
references h->sdev when the dh_list is traversed.  So it needs
to remain valid.  Fixing it by flushing the workqueue to avoid
the list traversal code running leaves open the possibility that
future code alterations may expose this problem again.

-Ewan


