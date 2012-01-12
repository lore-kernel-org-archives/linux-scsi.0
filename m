From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Thu, 12 Jan 2012 13:54:27 -0600
Message-ID: <4F0F3A73.9060602@cs.wisc.edu>
References: <1325618414-26992-1-git-send-email-revers@redhat.com> <4F0EAB53.7020404@suse.de> <4F0F124D.3000708@redhat.com> <4F0F4F43.2010902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49472 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab2ALTyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 14:54:39 -0500
In-Reply-To: <4F0F4F43.2010902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Rob Evers <revers@redhat.com>, linux-scsi@vger.kernel.org

On 01/12/2012 03:23 PM, Hannes Reinecke wrote:
> On 01/12/2012 06:03 PM, Rob Evers wrote:
>> On 01/12/2012 04:43 AM, Hannes Reinecke wrote:
>>> On 01/03/2012 08:20 PM, Rob Evers wrote:
>>>> From: Rob Evers<revers@redhat.com>
>>>>
>>>> When alua targets are transitioning, the scsi midlayer retry mechanism
>>>> continuously retries the scsi commands that are returning with not
>>>> ready
>>>> transitioning status. The target is not capable of handling the
>>>> commands for time on the order of several seconds during these
>>>> transistions.
>>>>
>>>> This patch delays the device queue for 2 seconds, which is in the same
>>>> order of aas transition time.
>>>>
>>>> Also, handle all other cases where ADD_TO_MLQUEUE_DELAY could be
>>>> returned
>>>> instead of ADD_TO_MLQUEUE as if ADD_TO_MLQUEUE were being returned.
>>>>
>>>> Problem found by array partner testing
>>>>
>>>> change MLQUEUE_DEV_DLY_RTY to MLQUEUE_DELAYED_RETRY
>>>>
>>> I have been working on a different solution, whic
>>>> Signed-off-by: Rob Evers<revers@redhat.com>
>>>> ---
>>>> drivers/scsi/device_handler/scsi_dh_alua.c | 7 ++++---
>>>> drivers/scsi/scsi.c | 3 +++
>>>> drivers/scsi/scsi_error.c | 1 +
>>>> drivers/scsi/scsi_lib.c | 9 ++++++++-
>>>> include/scsi/scsi.h | 12 +++++++-----
>>>> 5 files changed, 23 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
>>>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>> index 4ef0212..33b8df7 100644
>>>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>>>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>> @@ -233,7 +233,7 @@ static void stpg_endio(struct request *req, int
>>>> error)
>>>> goto done;
>>>> }
>>>> err = alua_check_sense(h->sdev,&sense_hdr);
>>>> - if (err == ADD_TO_MLQUEUE) {
>>>> + if (err == ADD_TO_MLQUEUE || err == ADD_TO_MLQUEUE_DELAY) {
>>>> err = SCSI_DH_RETRY;
>>>> goto done;
>>>> }
>>>> @@ -443,7 +443,7 @@ static int alua_check_sense(struct scsi_device
>>>> *sdev,
>>>> /*
>>>> * LUN Not Accessible - ALUA state transition
>>>> */
>>>> - return ADD_TO_MLQUEUE;
>>>> + return ADD_TO_MLQUEUE_DELAY;
>>>> if (sense_hdr->asc == 0x04&& sense_hdr->ascq == 0x0b)
>>>> /*
>>>> * LUN Not Accessible -- Target port in standby state
>>>> @@ -521,7 +521,8 @@ static int alua_rtpg(struct scsi_device *sdev,
>>>> struct alua_dh_data *h)
>>>> return SCSI_DH_IO;
>>>>
>>>> err = alua_check_sense(sdev,&sense_hdr);
>>>> - if (err == ADD_TO_MLQUEUE&& time_before(jiffies, expiry))
>>>> + if ((err == ADD_TO_MLQUEUE || err == ADD_TO_MLQUEUE_DELAY)&&
>>>> + time_before(jiffies, expiry))
>>>> goto retry;
>>>> sdev_printk(KERN_INFO, sdev,
>>>> "%s: rtpg sense code %02x/%02x/%02x\n",
>>> Actually, this doesn't help if the RTPG command returns with the
>>> mentioned error; then you'll just continue flooding the array with
>>> RTPG commands. You'll need to delay the RTPG commands, too.
>>
>> I thought that the rtpg command would get requeued into the
>> device queue that is being delayed anyway.
>>
>> Isn't that true?
>>
> Nope.
> 
> rtpg is being send via the SG_IO path, for which the error is returned
> directly without being retried.
> 

It should get retried by the scsi_decide_disposition/scsi_softirq_done
code. It should be going from:

scsi_softirq_done->scsi_decide_disposition->scsi_check_sense->scsi_dh->check_sense->alua_check_sense

alua_check_sense will return ADD_TO_MLQUEUE_DELAY then scsi_check_sense
will pass that up and scsi_decide_disposition will return that right
away. And then in scsi_softirq_done we will just requeue in the code the
patch added:

+		case ADD_TO_MLQUEUE_DELAY:
+			scsi_queue_insert(cmd, SCSI_MLQUEUE_DELAYED_RETRY);
+			break;

