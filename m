Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E0AC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22DCA20825
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgH1Phv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:37:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36371 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725814AbgH1Phr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 11:37:47 -0400
Received: (qmail 472255 invoked by uid 1000); 28 Aug 2020 11:37:45 -0400
Date:   Fri, 28 Aug 2020 11:37:45 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
Message-ID: <20200828153745.GB470612@rowland.harvard.edu>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
 <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
 <20200826015159.GA387575@rowland.harvard.edu>
 <af1b1f57-59ff-0133-8108-0f3d1e1254e1@acm.org>
 <20200827203321.GB449067@rowland.harvard.edu>
 <5da883fe-b5ec-b98d-ae0c-bc053b6e22cb@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5da883fe-b5ec-b98d-ae0c-bc053b6e22cb@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 27, 2020 at 08:27:49PM -0700, Bart Van Assche wrote:
> On 2020-08-27 13:33, Alan Stern wrote:
> > It may not need to be that complicated.  what about something like this?

> I think this patch will break SCSI domain validation. The SCSI domain
> validation code calls scsi_device_quiesce() and that function in turn calls
> blk_set_pm_only(). The SCSI domain validation code submits SCSI commands with
> the BLK_MQ_REQ_PREEMPT flag. Since the above code postpones such requests
> while blk_set_pm_only() is in effect, I think the above patch will cause the
> SCSI domain validation code to deadlock.

Yes, you're right.

There may be an even simpler solution: Ensure that SCSI domain 
validation is mutually exclusive with runtime PM.  It's already mutually 
exclusive with system PM, so this makes sense.

What do you think of the patch below?

Alan Stern


Index: usb-devel/drivers/scsi/scsi_transport_spi.c
===================================================================
--- usb-devel.orig/drivers/scsi/scsi_transport_spi.c
+++ usb-devel/drivers/scsi/scsi_transport_spi.c
@@ -1001,7 +1001,7 @@ spi_dv_device(struct scsi_device *sdev)
 	 * Because this function and the power management code both call
 	 * scsi_device_quiesce(), it is not safe to perform domain validation
 	 * while suspend or resume is in progress. Hence the
-	 * lock/unlock_system_sleep() calls.
+	 * lock/unlock_system_sleep() and scsi_autopm_get/put_device() calls.
 	 */
 	lock_system_sleep();
 
@@ -1018,10 +1018,13 @@ spi_dv_device(struct scsi_device *sdev)
 	if (unlikely(!buffer))
 		goto out_put;
 
+	if (scsi_autopm_get_device(sdev))
+		goto out_free;
+
 	/* We need to verify that the actual device will quiesce; the
 	 * later target quiesce is just a nice to have */
 	if (unlikely(scsi_device_quiesce(sdev)))
-		goto out_free;
+		goto out_autopm_put;
 
 	scsi_target_quiesce(starget);
 
@@ -1041,6 +1044,8 @@ spi_dv_device(struct scsi_device *sdev)
 
 	spi_initial_dv(starget) = 1;
 
+ out_autopm_put:
+	scsi_autopm_put_device(sdev);
  out_free:
 	kfree(buffer);
  out_put:


