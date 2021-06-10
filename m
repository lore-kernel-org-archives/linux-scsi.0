Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77142C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FFFB61027
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhFJODo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 10:03:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60418 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhFJODo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 10:03:44 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 635361FD37;
        Thu, 10 Jun 2021 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623333707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fKONkR/kFyAL5fyxcxUGu4sbBeMiAxaKOlzYBnvpfBM=;
        b=n/bYyKgVi9XgajsJ6GgNZnBDqvUcdVPQiZBq4BVs5wW0b+eoE4cKujLVUPXBSvydEfCDF0
        FXC/APg6SDbiTdfTYLvrCH1saRv1xhqEOreAJhn1tsWWTYALutMc0xQAjawPUhBVLz2MqZ
        DU0JDis6JAQkhI4MGgcPsp39xFsBrHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623333707;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fKONkR/kFyAL5fyxcxUGu4sbBeMiAxaKOlzYBnvpfBM=;
        b=0Cb3kXsO18kmwL++A6uoHcgpg8RMBEYAYFP9wMxeKImp7Ej6FF4Pxs2oBqR9D+MfHxPHFK
        ybbroY+ATS8uYcCQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 4565A118DD;
        Thu, 10 Jun 2021 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623333707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fKONkR/kFyAL5fyxcxUGu4sbBeMiAxaKOlzYBnvpfBM=;
        b=n/bYyKgVi9XgajsJ6GgNZnBDqvUcdVPQiZBq4BVs5wW0b+eoE4cKujLVUPXBSvydEfCDF0
        FXC/APg6SDbiTdfTYLvrCH1saRv1xhqEOreAJhn1tsWWTYALutMc0xQAjawPUhBVLz2MqZ
        DU0JDis6JAQkhI4MGgcPsp39xFsBrHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623333707;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fKONkR/kFyAL5fyxcxUGu4sbBeMiAxaKOlzYBnvpfBM=;
        b=0Cb3kXsO18kmwL++A6uoHcgpg8RMBEYAYFP9wMxeKImp7Ej6FF4Pxs2oBqR9D+MfHxPHFK
        ybbroY+ATS8uYcCQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id +essEEsbwmBxVgAALh3uQQ
        (envelope-from <hare@suse.de>); Thu, 10 Jun 2021 14:01:47 +0000
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
To:     Jiri Slaby <jirislaby@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
 <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
 <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
 <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
 <e2c75feb-cd87-1681-a5ee-6aed7ee82e11@suse.de>
 <6d5c893d-61c1-fad9-78f5-17b41f19706d@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <723d9d8b-5dde-839f-efe6-164177f5c1ce@suse.de>
Date:   Thu, 10 Jun 2021 16:01:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <6d5c893d-61c1-fad9-78f5-17b41f19706d@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------E163DC3D490E3B45511F0041"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------E163DC3D490E3B45511F0041
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 6/10/21 12:52 PM, Jiri Slaby wrote:
> On 07. 06. 21, 15:02, Hannes Reinecke wrote:
>> On 6/7/21 2:30 PM, Martin K. Petersen wrote:
>>>
>>> Hannes,
>>>
>>>>> Any ideas?
>>>
>>>>> Can you enable SCSI logging via
>>>>
>>>> scsi.scsi_logging_level=216
>>>>
>>>> on the kernel commandline and send me the output?
>>>
>>> You now effectively set SAM_STAT_CHECK_CONDITION if the scsi_cmnd has a
>>> sense buffer.
>>>
>>> The original code only set DRIVER_SENSE if the adapter response actually
>>> contained sense information:
>>>
>>> @@ -161,8 +161,7 @@ static void virtscsi_complete_cmd(struct
>>> virtio_scsi *vscsi, void *buf)
>>>                         min_t(u32,
>>>                               virtio32_to_cpu(vscsi->vdev,
>>> resp->sense_len),
>>>                               VIRTIO_SCSI_SENSE_SIZE));
>>> -               if (resp->sense_len)
>>> -                       set_driver_byte(sc, DRIVER_SENSE);
>>> +               set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>>>          }
>>>
>> Oh, I know. But we're checking for a valid sense code during scanning:
>>
>>             if (scsi_status_is_check_condition(result) &&
>>                 scsi_sense_valid(&sshdr)) {
>>
>> so if that makes a difference it would mean that the virtio driver has
>> some stale sense data which then gets copied over.
>> Anyway.
>> Can you test with this patch?
> 
> Yes, that boots, but is somehow sloooow (hard to tell what is causing
> this).
> 
> Anyway, the new print is still there with the patch:
> [   11.549986] sd 0:0:0:0: Power-on or device reset occurred
> 
> Cool; one step further.
Can you check if the attached patch helps, too?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)

--------------E163DC3D490E3B45511F0041
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-scsi-do-not-assume-CHECK_CONDITION-is-set-for-valid-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-scsi-do-not-assume-CHECK_CONDITION-is-set-for-valid-.pa";
 filename*1="tch"

From f60b3ab985a555cd623b77f6da95cb094da08d2a Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 10 Jun 2021 15:46:56 +0200
Subject: [PATCH 2/2] scsi: do not assume CHECK_CONDITION is set for valid
 sense code

While the standard implies that a sense code should be returned in
response to CHECK CONDITION status, it _might_ be returned on other
status codes, too.
At least, that's what the original code assumed. So it's arguably
wrong to assume we only will have a valid sense code when CHECK
CONDITION is set.

Fixes: 464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE")
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 20739072f21a..821bbcfe68c9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1722,8 +1722,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		if (res < 0)
 			return res;
 
-		if (scsi_status_is_check_condition(res) &&
-		    scsi_sense_valid(sshdr)) {
+		if (scsi_sense_valid(sshdr)) {
 			sd_print_sense_hdr(sdkp, sshdr);
 
 			/* we need to evaluate the error return  */
@@ -1829,10 +1828,10 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
 			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 
-	if (scsi_status_is_check_condition(result) &&
-	    scsi_sense_valid(&sshdr)) {
+	if (result) {
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
-		scsi_print_sense_hdr(sdev, NULL, &sshdr);
+		if (scsi_sense_valid(&sshdr))
+			scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
 	return result;
@@ -2073,7 +2072,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (!scsi_status_is_check_condition(result) &&
+	if (result &&
 	    (!sense_valid || sense_deferred))
 		goto out;
 
@@ -2178,10 +2177,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			retries++;
 		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+			  (sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
-		if (!scsi_status_is_check_condition(the_result)) {
+		if (the_result < 0 || !sense_valid) {
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result)) {
-- 
2.26.2


--------------E163DC3D490E3B45511F0041--
