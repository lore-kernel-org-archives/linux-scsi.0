Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F99FC352BE
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 19:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6E2208E4
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 19:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgDHTv7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 15:51:59 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:49414 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730187AbgDHTv7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 15:51:59 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id C5D1F838437F;
        Wed,  8 Apr 2020 19:51:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: point91_4b1a2c45aca56
X-Filterd-Recvd-Size: 3830
Received: from XPS-9350 (unknown [172.58.19.195])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Wed,  8 Apr 2020 19:51:55 +0000 (UTC)
Message-ID: <2de69a35463317f5eca2ce665b0ee8b90b8c717b.camel@perches.com>
Subject: Re: [PATCH] scsi: core: Rate limit "rejecting I/O" messages
From:   Joe Perches <joe@perches.com>
To:     "Ewan D. Milne" <emilne@redhat.com>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Wed, 08 Apr 2020 12:49:52 -0700
In-Reply-To: <120ce7f4cd1fd070e1f7c353223c21b8e4f29337.camel@redhat.com>
References: <20200408171012.76890-1-dwagner@suse.de>
         <120ce7f4cd1fd070e1f7c353223c21b8e4f29337.camel@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-04-08 at 15:16 -0400, Ewan D. Milne wrote:
> On Wed, 2020-04-08 at 19:10 +0200, Daniel Wagner wrote:
> > Prevent excessive logging by rate limiting the "rejecting I/O"
> > messages. For example in setups where remote syslog is used the link
> > is saturated by those messages when a storage controller/disk
> > misbehaves.
> > 
> > Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Signed-off-by: Daniel Wagner <dwagner@suse.de>
> > ---
> >  drivers/scsi/scsi_lib.c    |  4 ++--
> >  include/scsi/scsi_device.h | 10 ++++++++++
> >  2 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 47835c4b4ee0..01c35c58c6f3 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1217,7 +1217,7 @@ scsi_prep_state_check(struct scsi_device *sdev,
> > struct request *req)
> >  		 */
> >  		if (!sdev->offline_already) {
> >  			sdev->offline_already = true;
> > -			sdev_printk(KERN_ERR, sdev,
> > +			sdev_printk_ratelimited(KERN_ERR, sdev,
> >  				    "rejecting I/O to offline
> > device\n");
> 
> I would really prefer we not do it this way if at all possible.
> It loses information we may need to debug SAN outage problems.
> 
> The reason I didn't use ratelimit is that the ratelimit structure is
> per-instance of the ratelimit call here, not per-device.  So this
> doesn't work right -- it will drop messages for other devices.

Could add a ratelimit_state to struct scsi_device.

Something like:
---
 drivers/scsi/scsi_scan.c   | 2 ++
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a..938c83f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -279,6 +279,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
 					sdev->host->cmd_per_lun : 1);
 
+	ratelimit_state_init(&sdev->rs, DEFAULT_RATELIMIT_INTERVAL,
+			     DEFAULT_RATELIMIT_BURST);
 	scsi_sysfs_device_initialize(sdev);
 
 	if (shost->hostt->slave_alloc) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c3cba2..2600de7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
+#include <linux/ratelimit.h>
 
 struct device;
 struct request_queue;
@@ -233,6 +234,7 @@ struct scsi_device {
 	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
+	struct ratelimit_state	rs;
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 


