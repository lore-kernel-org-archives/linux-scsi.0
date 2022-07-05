Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF8AC43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 03:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiGEDi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 23:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiGEDi0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 23:38:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C43F3113B
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 20:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656992303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jYELZJdJtbBBZ8E1ctzFuWbeRh51icMF2i3QiP3BTlM=;
        b=UnZQAGtFlb+zeJoaWaoGvSc3SpduY+3G7NbA8z6H1DIJE6uI0uIJuf5rxOF+KBXrZC3s1j
        tDnQE202Ojhh+YYTqwMoWFPRZRhy8BWizcpJX+CtlZ+2wP7l6id3FthrlO3aDP/bthaMUE
        piRLOCYYm0xJyubNpYd1vpEAlPbJYgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-hC1a_oBfN8S4gxtInRXxFw-1; Mon, 04 Jul 2022 23:38:19 -0400
X-MC-Unique: hC1a_oBfN8S4gxtInRXxFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4CE2811E75;
        Tue,  5 Jul 2022 03:38:18 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2766C2166B26;
        Tue,  5 Jul 2022 03:38:11 +0000 (UTC)
Date:   Tue, 5 Jul 2022 11:38:06 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>, ming.lei@redhat.com
Subject: Re: [PATCH v2 2/3] scsi: Make scsi_forget_host() wait for request
 queue removal
Message-ID: <YsOyHnIydqVdRVnQ@T590>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630213733.17689-3-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 30, 2022 at 02:37:32PM -0700, Bart Van Assche wrote:
> Prepare for freeing the host tag set earlier by making scsi_forget_host()
> wait until all activity on the host tag set has stopped.

I think it is correct to free the host tag during removing host.

> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_scan.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 5c3bb4ceeac3..c8331ccdde95 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1961,6 +1961,16 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  }
>  EXPORT_SYMBOL(scsi_scan_host);
>  
> +/**
> + * scsi_forget_host() - Remove all SCSI devices from a host.
> + * @shost: SCSI host to remove devices from.
> + *
> + * Removes all SCSI devices that have not yet been removed. For the SCSI devices
> + * for which removal started before scsi_forget_host(), wait until the
> + * associated request queue has reached the "dead" state. In that state it is
> + * guaranteed that no new requests will be allocated and also that no requests
> + * are in progress anymore.
> + */
>  void scsi_forget_host(struct Scsi_Host *shost)
>  {
>  	struct scsi_device *sdev;
> @@ -1970,8 +1980,21 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   restart:
>  	spin_lock_irq(shost->host_lock);
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> +		if (sdev->sdev_state == SDEV_DEL &&
> +		    blk_queue_dead(sdev->request_queue)) {
>  			continue;
> +		}
> +		if (sdev->sdev_state == SDEV_DEL) {
> +			get_device(&sdev->sdev_gendev);
> +			spin_unlock_irq(shost->host_lock);
> +
> +			while (!blk_queue_dead(sdev->request_queue))
> +				msleep(10);

Thinking of further, this report on UAF on SRP resource and Changhui's
report on UAF of host->hostt should belong to same kind of issue:

1) after scsi_remove_host() returns, either the HBA driver module can be
unloaded and hostt can't be used, or any HBA resources can be freed, both
may cause UAF in scsi_mq_exit_request, so moving freeing host tagset to
scsi_remove_host() is correct.

static void scsi_mq_exit_request()
{
	...
    if (shost->hostt->exit_cmd_priv)
		shost->hostt->exit_cmd_priv(shost, cmd);
}


2) checking request queue dead here isn't good, which not only relies
on block layer implementation detail, but also can't avoid UAF on ->hostt,
I'd suggest to fix them all. The attached patch may drain all sdevs, which
can replace the 2nd patch if you don't mind, but the 3rd patch is still needed:


diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e1cb187402fd..6445718c2b18 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -189,6 +189,14 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
+
+	/*
+	 * Once returning, the scsi LLD module can be unloaded, so we have
+	 * to wait until our descendants are released, otherwise our host
+	 * device reference can be grabbed by them, then use-after-free
+	 * on shost->hostt will be triggered
+	 */
+	wait_for_completion(&shost->targets_completion);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -393,6 +401,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	init_completion(&shost->targets_completion);
 
 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
 	if (index < 0) {
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 10e5bffc34aa..b6e6354da396 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -545,10 +545,8 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	struct module *mod = sdev->host->hostt->module;
-
+	module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
-	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2ef78083f1ef..931333a48372 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -406,9 +406,14 @@ static void scsi_target_destroy(struct scsi_target *starget)
 static void scsi_target_dev_release(struct device *dev)
 {
 	struct device *parent = dev->parent;
+	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct scsi_target *starget = to_scsi_target(dev);
 
 	kfree(starget);
+
+	if (!atomic_dec_return(&shost->nr_targets))
+		complete_all(&shost->targets_completion);
+
 	put_device(parent);
 }
 
@@ -521,6 +526,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	atomic_inc(&shost->nr_targets);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 94091d5281ba..28c51ef0ea54 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -449,12 +449,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	unsigned long flags;
-	struct module *mod;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
-	mod = sdev->host->hostt->module;
-
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -505,17 +502,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
-	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-
-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
-
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 37718373defc..d0baffd62287 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -710,6 +710,9 @@ struct Scsi_Host {
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
 
+	atomic_t nr_targets;
+	struct completion   targets_completion;
+
 	/*
 	 * Points to the transport data (if any) which is allocated
 	 * separately


Thanks,
Ming

