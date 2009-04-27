From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH] limit state change to SDEV_BLOCK devices in scsi_internal_device_unblock
Date: Mon, 27 Apr 2009 15:43:09 -0400
Message-ID: <49F60ACD.5030204@redhat.com>
References: <49F5E6E5.20904@redhat.com> <20090427180300.GH1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbZD0Tm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 15:42:57 -0400
In-Reply-To: <20090427180300.GH1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, mchristi@redhat.com, mbarrow@redhat.com

Matthew Wilcox wrote:
> On Mon, Apr 27, 2009 at 01:09:57PM -0400, Takahiro Yasui wrote:
>> @@ -2633,9 +2633,12 @@ scsi_internal_device_unblock(struct scsi
>>  	unsigned long flags;
>>  	
>>  	/* 
>> -	 * Try to transition the scsi device to SDEV_RUNNING
>> -	 * and goose the device queue if successful.  
>> +	 * Try to transition the scsi device to SDEV_RUNNING if it is
>> +	 * SDEV_BLOCK and goose the device queue if successful.
> 
> I think the code looks good, but the edit to the comment dilutes its
> flavour somewhat.  How about just moving the comment down below the
> check, and then you don't need to edit the comment at all?

Thank you for the suggestion. I updated the patch according to your
comment.

Regards,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/scsi/scsi_lib.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.29/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.29/drivers/scsi/scsi_lib.c
@@ -2631,7 +2631,10 @@ scsi_internal_device_unblock(struct scsi
 	struct request_queue *q = sdev->request_queue; 
 	int err;
 	unsigned long flags;
-	
+
+	if (sdev->sdev_state != SDEV_BLOCK)
+		return 0;
+
 	/* 
 	 * Try to transition the scsi device to SDEV_RUNNING
 	 * and goose the device queue if successful.  
