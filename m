Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D023C63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9DC22249
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgLCFLY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 00:11:24 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40511 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgLCFLY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 00:11:24 -0500
Received: by mail-pf1-f196.google.com with SMTP id t7so513015pfh.7;
        Wed, 02 Dec 2020 21:11:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UVNRqn4yr7aqbyLDuyKA2SQWB67vbETBYZwjXRegDWQ=;
        b=unrISHiUN9kXj/9irvBzmNWfQgMJAafTXCkrS91ULA9zJAIjYWvSnZHXzJknWmHhZS
         qxmF5q9bjgPUTG/mbOz1xtHGQuFuUFR/gaACksRDa1wBba0HKdjnf5GiEZuhbuUQs2hB
         3LF894YwJa7eSlik0Ul6BR8e9/nRhzWR5yaZbE84UuUdaUa9aWddoi/UQJgO4dZQyshq
         Ji0xHBQrdjy1Rii9Uo5kZNnSg3dmUmGD8j95jLftnNmhvxg/F5NjsoI5sp0nJsbzNNQj
         ebM/5gLpBkjIgxsyHzs0qiff9fm6GKOmPvZpqIIbNau6TDYzwxiM2DBgzOOEsQpwTAGl
         GWzA==
X-Gm-Message-State: AOAM531GSUxfdePqbekvugo/wG66JnNH+xZoEZLhVPAFlUpRYdlEMXi5
        KrZS1RH1aOXYXIMab81EjFI=
X-Google-Smtp-Source: ABdhPJyCrbzcT2G4aOWIADWuq8RtqAT8R8vy9xUL/iXKGyI4aM1amhChNEy6DbC/A4BC7R8z3F7Qcg==
X-Received: by 2002:a63:67c2:: with SMTP id b185mr1609608pgc.102.1606972243549;
        Wed, 02 Dec 2020 21:10:43 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x7sm162929pfb.96.2020.12.02.21.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 21:10:42 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 5/9] scsi: Do not wait for a request in
 scsi_eh_lock_door()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20201130024615.29171-1-bvanassche@acm.org>
 <20201130024615.29171-6-bvanassche@acm.org>
 <bdadfbcd-76c4-4658-0b36-b7666fa1dc7b@suse.de>
Message-ID: <6e5fbc73-881e-69c7-54ce-381b8b695b3c@acm.org>
Date:   Wed, 2 Dec 2020 21:10:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <bdadfbcd-76c4-4658-0b36-b7666fa1dc7b@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/20 11:06 PM, Hannes Reinecke wrote:
> On 11/30/20 3:46 AM, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index d94449188270..6de6e1bf3dcb 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1993,7 +1993,12 @@ static void scsi_eh_lock_door(struct
>> scsi_device *sdev)
>>       struct request *req;
>>       struct scsi_request *rq;
>>   -    req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, 0);
>> +    /*
>> +     * It is not guaranteed that a request is available nor that
>> +     * sdev->request_queue is unfrozen. Hence the BLK_MQ_REQ_NOWAIT
>> below.
>> +     */
>> +    req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN,
>> +                  BLK_MQ_REQ_NOWAIT);
>>       if (IS_ERR(req))
>>           return;
>>       rq = scsi_req(req);
>>
>
> Well ... had been thinking about that one, too.
> The idea of this function is that prior to SCSI EH the device was locked
> via scsi_set_medium_removal(). And during SCSI EH the device might have
> become unlocked, so we need to lock it again.
> However, scsi_set_medium_removal() not only issues the
> PREVENT_ALLOW_MEDIUM_REMOVAL command, but also sets the 'locked' flag
> based on the result.
> So if we fail to get a request here, shouldn't we unset the 'locked'
> flag, too?

Probably not. My interpretation of the 'locked' flag is that it
represents the door state before error handling began. The following
code in the SCSI error handler restores the door state after a bus reset:

	if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
		scsi_eh_lock_door(sdev);
		sdev->was_reset = 0;
	}

> And what does happen if we fail here? There is no return value, hence
> SCSI EH might run to completion, and the system will continue
> with an unlocked door ...
> Not sure if that's a good idea.

How about applying the following patch on top of patch 5/9?

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6de6e1bf3dcb..feac7262e40e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1988,7 +1988,7 @@ static void eh_lock_door_done(struct request *req, blk_status_t status)
  * 	We queue up an asynchronous "ALLOW MEDIUM REMOVAL" request on the
  * 	head of the devices request queue, and continue.
  */
-static void scsi_eh_lock_door(struct scsi_device *sdev)
+static int scsi_eh_lock_door(struct scsi_device *sdev)
 {
 	struct request *req;
 	struct scsi_request *rq;
@@ -2000,7 +2000,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN,
 			      BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
-		return;
+		return PTR_ERR(req);
 	rq = scsi_req(req);

 	rq->cmd[0] = ALLOW_MEDIUM_REMOVAL;
@@ -2016,6 +2016,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	rq->retries = 5;

 	blk_execute_rq_nowait(req->q, NULL, req, 1, eh_lock_door_done);
+	return 0;
 }

 /**
@@ -2037,8 +2038,8 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * is no point trying to lock the door of an off-line device.
 	 */
 	shost_for_each_device(sdev, shost) {
-		if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
-			scsi_eh_lock_door(sdev);
+		if (scsi_device_online(sdev) && sdev->was_reset &&
+		    sdev->locked && scsi_eh_lock_door(sdev) == 0) {
 			sdev->was_reset = 0;
 		}
 	}

Thanks,

Bart.
