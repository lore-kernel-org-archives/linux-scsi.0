Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 02:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbiAJC7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jan 2022 21:59:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238272AbiAJC7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jan 2022 21:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641783561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qsVRCGINFxG1uoQFIbSbogfeREV/xKD6CIV4zZBvqE=;
        b=dLmB3WpzXl5eMncKfxc8UCOZ0Y4iFDgZVIL3zmAwkGRgnNATy48InD6YFZwDbcbfX41WTS
        dJXeOrggCY7w4CI23s92+hwLc8PuWCJV686aVNkGX0QJa0PuRDThfELPckxYf9NPnKNVfk
        8L0UrZLgtWDYmwe9ybWIBjOyDRiTou8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-JP5UK2u8OGCJvWR8lsbE3Q-1; Sun, 09 Jan 2022 21:59:20 -0500
X-MC-Unique: JP5UK2u8OGCJvWR8lsbE3Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69E9380D680;
        Mon, 10 Jan 2022 02:59:18 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E83275BE19;
        Mon, 10 Jan 2022 02:59:07 +0000 (UTC)
Date:   Mon, 10 Jan 2022 10:59:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Message-ID: <Ydug9nWg4loEVkJw@T590>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
 <YdZcABq/pxMMh3X0@T590>
 <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
 <YdcEJngPYrZk691Q@T590>
 <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
 <YdcNrSJJGllQzWOB@T590>
 <5fffbc9191d1f1b3db1d51ce991591c9c6d91785.camel@suse.com>
 <YdcZwVUFGUPgkbLn@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdcZwVUFGUPgkbLn@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 07, 2022 at 12:33:05AM +0800, Ming Lei wrote:
> On Thu, Jan 06, 2022 at 04:19:03PM +0000, Martin Wilck wrote:
> > On Thu, 2022-01-06 at 23:41 +0800, Ming Lei wrote:
> > > On Thu, Jan 06, 2022 at 03:22:53PM +0000, Martin Wilck wrote:
> > > > > 
> > > > > I'd suggest to fix mpt3sas for avoiding this memory waste.
> > > > 
> > > > Let's wait for Sreekanth's comment on that.
> > > > 
> > > > mpt3sas is not the only driver using a low value. Qlogic drivers
> > > > set
> > > > cmd_per_lun=3, for example (with 3, our logic would use shift=6, so
> > > > the
> > > > issue I observed wouldn't occur - but it would be prone to cache
> > > > line
> > > > bouncing).
> > > 
> > > But qlogic has smaller .can_queue which looks at most 512, .can_queue
> > > is
> > > the depth for allocating sbitmap, since each sdev->queue_depth is <=
> > > .can_queue.
> > 
> > I'm seeing here (on an old kernel, admittedly) cmd_per_lun=3 and
> > can_queue=2038 for qla2xxx and cmd_per_lun=3 and can_queue=5884 for
> > lpfc. Both drivers change the queue depth for devices to 64 in their
> > slave_configure() methods.
> > 
> > Many drivers do this, as it's recommended in scsi_host.h. That's quite
> > bad in view of the current bitmap allocation logic - we lay out the
> > bitmap assuming the depth used will be cmd_per_lun, but that doesn't
> > match the actual depth when the device comes online. For qla2xxx, it
> > means that we'd allocate the sbitmap with shift=6 (64 bits per word),
> > thus using just a single cache line for 64 requests. Shift=4 (16 bits
> > per word) would be the default shift for depth 64.
> > 
> > Am I misreading the code? Perhaps we should only allocate a preliminary
> > sbitmap in scsi_alloc_sdev, and reallocate it after slave_configure()
> > has been called, to get the shift right for the driver's default
> > settings?
> 
> That looks fine to reallocate it after ->slave_configure() returns,
> but we need to freeze the request queue for avoiding any in-flight
> scsi command. At that time, freeze should be quick enough.

Hello Martin Wilck,

Can you test the following change and report back the result?

From 480a61a85e9669d3487ebee8db3d387df79279fc Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 10 Jan 2022 10:26:59 +0800
Subject: [PATCH] scsi: core: reallocate scsi device's budget map if default
 queue depth is changed

Martin reported that sdev->queue_depth can often be changed in
->slave_configure(), and now we uses ->cmd_per_lun as initial queue
depth for setting up sdev->budget_map. And some extreme ->cmd_per_lun
or ->can_queue won't be used at default actually, if we they are used
to allocate sdev->budget_map, huge memory may be consumed just because
of bad ->cmd_per_lun.

Fix the issue by reallocating sdev->budget_map after ->slave_configure()
returns, at that time, queue_depth should be much more reasonable.

Reported-by: Martin Wilck <martin.wilck@suse.com>
Suggested-by: Martin Wilck <martin.wilck@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_scan.c | 56 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 23e1c0acdeae..9593c9111611 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -214,6 +214,48 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 			 SCSI_TIMEOUT, 3, NULL);
 }
 
+static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
+					unsigned int depth)
+{
+	int new_shift = sbitmap_calculate_shift(depth);
+	bool need_alloc = !sdev->budget_map.map;
+	bool need_free = false;
+	int ret;
+	struct sbitmap sb_back;
+
+	/*
+	 * realloc if new shift is calculated, which is caused by setting
+	 * up one new default queue depth after calling ->slave_configure
+	 */
+	if (!need_alloc && new_shift != sdev->budget_map.shift)
+		need_alloc = need_free = true;
+
+	if (!need_alloc)
+		return 0;
+
+	/*
+	 * Request queue has to be freezed for reallocating budget map,
+	 * and here disk isn't added yet, so freezing is pretty fast
+	 */
+	if (need_free) {
+		blk_mq_freeze_queue(sdev->request_queue);
+		sb_back = sdev->budget_map;
+	}
+	ret = sbitmap_init_node(&sdev->budget_map,
+				scsi_device_max_queue_depth(sdev),
+				new_shift, GFP_KERNEL,
+				sdev->request_queue->node, false, true);
+	if (need_free) {
+		if (ret)
+			sdev->budget_map = sb_back;
+		else
+			sbitmap_free(&sb_back);
+		ret = 0;
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	}
+	return ret;
+}
+
 /**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  * @starget: which target to allocate a &scsi_device for
@@ -306,11 +348,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
 	 */
-	if (sbitmap_init_node(&sdev->budget_map,
-				scsi_device_max_queue_depth(sdev),
-				sbitmap_calculate_shift(depth),
-				GFP_KERNEL, sdev->request_queue->node,
-				false, true)) {
+	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
@@ -1017,6 +1055,14 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			}
 			return SCSI_SCAN_NO_RESPONSE;
 		}
+
+		/*
+		 * queue_depth is often changed in ->slave_configure, so
+		 * setup budget map again for getting better memory uses
+		 * since memory consumption of the map depends on queue
+		 * depth heavily
+		 */
+		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
 	}
 
 	if (sdev->scsi_level >= SCSI_3)
-- 
2.31.1



-- 
Ming

