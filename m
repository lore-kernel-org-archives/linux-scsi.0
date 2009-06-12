From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC PATCH 4/4] drivers: convert fc drivers calling
	scsi_track_queue_full
Date: Fri, 12 Jun 2009 14:57:08 +0200
Message-ID: <20090612125708.GB8017@schmichrtp.de.ibm.com>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu> <12427123683166-git-send-email-michaelc@cs.wisc.edu> <1242712369913-git-send-email-michaelc@cs.wisc.edu> <12427123692457-git-send-email-michaelc@cs.wisc.edu> <1242712370448-git-send-email-michaelc@cs.wisc.edu> <1242712370737-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:39008 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760836AbZFLM5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 08:57:08 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id n5CCvAAi005480
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 12:57:10 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5CCvASv1478690
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 13:57:10 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5CCv98H019949
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 13:57:09 +0100
Content-Disposition: inline
In-Reply-To: <1242712370737-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Tue, May 19, 2009 at 12:52:47AM -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This converts the fc drivers that were using scsi_track_queue_full
> to track the queue full from the change_queue_depth callback.
> 
> I have not yet tested the qla2xxx or lpfc parts.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

In scsi-misc zfcp also implements the change_queue_depth callback, so
this has to be adjusted, too:
--
zfcp: Add reason attribute to scsi_change_queue_depth callback

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Now that zfcp implements the scsi_change_queue_depth callback, the
reason attribute is also required here.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-06-12 14:16:55.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-06-12 14:33:20.000000000 +0200
@@ -28,7 +28,8 @@ char *zfcp_get_fcp_sns_info_ptr(struct f
 	return fcp_sns_info_ptr;
 }
 
-static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth)
+static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
+					int reason)
 {
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
 	return sdev->queue_depth;
