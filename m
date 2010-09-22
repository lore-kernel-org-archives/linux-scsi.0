From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi_dh_alua: add missing transitioning state support
Date: Wed, 22 Sep 2010 12:13:07 +0200
Message-ID: <4C99D6B3.3090003@suse.de>
References: <1282071956-391-1-git-send-email-snitzer@redhat.com> <1282073039.30453.37.camel@haakon2.linux-iscsi.org> <4C7B7B9E.3020002@suse.de> <20100831151129.GA18855@redhat.com> <20100920153539.GA28284@redhat.com> <4C98180F.1020707@cs.wisc.edu> <20100921193320.GA5110@redhat.com> <4C992026.5080402@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090707060103070207080402"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0IVKNK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2010 06:13:10 -0400
In-Reply-To: <4C992026.5080402@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Snitzer <snitzer@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090707060103070207080402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Mike Christie wrote:
> On 09/21/2010 02:33 PM, Mike Snitzer wrote:
>> On Mon, Sep 20 2010 at 10:27pm -0400,
>> Mike Christie<michaelc@cs.wisc.edu>  wrote:
>>
>>> On 09/20/2010 10:35 AM, Mike Snitzer wrote:
>>>> Hi Hannes,
>>>>
>>>> On Tue, Aug 31 2010 at 11:11am -0400,
>>>> Mike Snitzer<snitzer@redhat.com>   wrote:
>>>>
>>>>> On Mon, Aug 30 2010 at  5:36am -0400,
>>>>> Hannes Reinecke<hare@suse.de>   wrote:
>>>>>
>>>>>> Nicholas A. Bellinger wrote:
>>>>>>> On Tue, 2010-08-17 at 15:05 -0400, Mike Snitzer wrote:
>>>>>>>> Handle transitioning in the prep_fn.
>>>>>>>> Handle transitioning in alua_rtpg's implicit alua code too.
>>>>>>>>
>>>>>>>> These gaps were identified during controller failover testing of an
>>>>>>>> ALUA array.
>>>>>>>>
>>>>>>>> Signed-off-by: Mike Snitzer<snitzer@redhat.com>
>>>>>>>> ---
>>>>>>>>   drivers/scsi/device_handler/scsi_dh_alua.c |   10 +++++++---
>>>>>>>>   1 files changed, 7 insertions(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>>>>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>>>>> index 1a970a7..c1eedc5 100644
>>>>>>>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>>>>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>>>>> @@ -616,6 +616,9 @@ static int alua_rtpg(struct scsi_device
>>>>>>>> *sdev, struct alua_dh_data *h)
>>>>>>>>               h->state == TPGS_STATE_STANDBY)
>>>>>>>>               /* Useable path if active */
>>>>>>>>               err = SCSI_DH_OK;
>>>>>>>> +        else if (h->state == TPGS_STATE_TRANSITIONING)
>>>>>>>> +            /* State transition, retry */
>>>>>>>> +            goto retry;
>>>>>>>>           else
>>>>>>>>               /* Path unuseable for unavailable/offline */
>>>>>>>>               err = SCSI_DH_DEV_OFFLINED;
>>>>>>>> @@ -698,13 +701,14 @@ static int alua_prep_fn(struct scsi_device
>>>>>>>> *sdev, struct request *req)
>>>>>>>>       struct alua_dh_data *h = get_alua_data(sdev);
>>>>>>>>       int ret = BLKPREP_OK;
>>>>>>>>
>>>>>>>> -    if (h->state != TPGS_STATE_OPTIMIZED&&
>>>>>>>> -        h->state != TPGS_STATE_NONOPTIMIZED) {
>>>>>>>> +    if (h->state == TPGS_STATE_TRANSITIONING)
>>>>>>>> +        ret = BLKPREP_DEFER;
>>>>>>>> +    else if (h->state != TPGS_STATE_OPTIMIZED&&
>>>>>>>> +         h->state != TPGS_STATE_NONOPTIMIZED) {
>>>>>>>>           ret = BLKPREP_KILL;
>>>>>>>>           req->cmd_flags |= REQ_QUIET;
>>>>>>>>       }
>>>>>>>>       return ret;
>>>>>>>> -
>>>>>>>>   }
>>>>>>>>
>>>>>>>
>>>>>>> Makes sense to me..
>>>>>>>
>>>>>>> Acked-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
>>>>>>>
>>>>>> Not so fast. There are two problems with this approach:
>>>>>>
>>>>>> The path is retried indefinitely. Arrays are _supposed_ to be in
>>>>>> 'transitioning'
>>>>>> only temporary; however, if the array is stuck due to a fw error
>>>>>> we're stuck in 'defer',
>>>>>> too.
>>>>>
>>>>> And what is the problem with that?  The IO will eventually time out.
>>>>
>>>> To restate as a question: even though we'll retry in alua_rtpg();
>>>> shouldn't the SCSI command eventually time out (via
>>>> scsi_attempt_requeue_command)?
>>>
>>> That function is only in RHEL. Requests that are prepd and sent to
>>> the scsi layer and driver would eventually timeout in
>>> scsi_softirq_done in upstream.
>>>
>>> alua_prep_fn prevents the IO from getting sent to the scsi layer so
>>> we do not hit the check in scsi_softirq_done though.
>>
>> That is only the case if alua_prep_fn were to return BLKPREP_DEFER
>> right?
> 
> Yeah. I misread the email above. Just to clarify..
> 
> For the alua case, we will always retry due the prep_fn issue I mentioned.
> 
> For the alua_rtpg() retry case you were discussing we will also always
> retry, because the timer check in
> scsi_attempt_requeue_command/scsi_softirq_done will break us from
> retrying forever in that execution of the request started by the
> submit_rtpg call. However, the added goto retry will would just end up
> starting a another execution. To handle Hannes comment I think you would
> want to add some retry/timer checks in alua_rtpg to prevent that from
> retrying forever.
> 
>>
>> 2) the patch also modified alua_rtpg() so implicit ALUA would retry
>>     (just like explicit ALUA currently does) if TPGS_STATE_TRANSITIONING
>>     - so why should we avoid retry for implicit but do it for explicit?
> 
> Leaving that for Hannes. I cannot think of a reason. Probably just did
> not do it.

Finally I got around to answering this.

I've attached a patch which I made the other day which seems to work
reasonably well.
Looks better from my side, so if you agree I'll be sending it
upstream properly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------090707060103070207080402
Content-Type: text/plain;
 name="scsi-dh-alua-handle-all-states"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-dh-alua-handle-all-states"

>From d3f02c90db3e3177309b78726d082e17dd772ee2 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Wed, 22 Sep 2010 12:09:07 +0200
Subject: [PATCH] scsi_dh_alua: Handle all states correctly

For ALUA we should be handling all states, independent of whether
is explicit or implicit. For 'Transitioning' we should be retry
for a certain amount of time; after that an error should be
returned.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 1a970a7..c6f57e3 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -31,6 +31,7 @@
 #define TPGS_STATE_NONOPTIMIZED		0x1
 #define TPGS_STATE_STANDBY		0x2
 #define TPGS_STATE_UNAVAILABLE		0x3
+#define TPGS_STATE_LBA_DEPENDENT	0x4
 #define TPGS_STATE_OFFLINE		0xe
 #define TPGS_STATE_TRANSITIONING	0xf
 
@@ -39,6 +40,7 @@
 #define TPGS_SUPPORT_NONOPTIMIZED	0x02
 #define TPGS_SUPPORT_STANDBY		0x04
 #define TPGS_SUPPORT_UNAVAILABLE	0x08
+#define TPGS_SUPPORT_LBA_DEPENDENT	0x10
 #define TPGS_SUPPORT_OFFLINE		0x40
 #define TPGS_SUPPORT_TRANSITION		0x80
 
@@ -460,6 +462,8 @@ static char print_alua_state(int state)
 		return 'S';
 	case TPGS_STATE_UNAVAILABLE:
 		return 'U';
+	case TPGS_STATE_LBA_DEPENDENT:
+		return 'L';
 	case TPGS_STATE_OFFLINE:
 		return 'O';
 	case TPGS_STATE_TRANSITIONING:
@@ -542,7 +546,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	int len, k, off, valid_states = 0;
 	char *ucp;
 	unsigned err;
+	unsigned long expiry, interval = 10;
 
+	expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT);
  retry:
 	err = submit_rtpg(sdev, h);
 
@@ -553,7 +559,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			return SCSI_DH_IO;
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE)
+		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
 			goto retry;
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: rtpg sense code %02x/%02x/%02x\n",
@@ -587,38 +593,36 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	}
 
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x state %c supports %c%c%c%c%c%c\n",
+		    "%s: port group %02x state %c supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
 		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
 		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
 		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
 		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
 		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
 		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT) {
-		switch (h->state) {
-		case TPGS_STATE_TRANSITIONING:
+	switch (h->state) {
+	case TPGS_STATE_TRANSITIONING:
+		if (time_before(jiffies, expiry)) {
 			/* State transition, retry */
+			interval *= 10;
+			msleep(interval);
 			goto retry;
-			break;
-		case TPGS_STATE_OFFLINE:
-			/* Path is offline, fail */
-			err = SCSI_DH_DEV_OFFLINED;
-			break;
-		default:
-			break;
 		}
-	} else {
-		/* Only Implicit ALUA support */
-		if (h->state == TPGS_STATE_OPTIMIZED ||
-		    h->state == TPGS_STATE_NONOPTIMIZED ||
-		    h->state == TPGS_STATE_STANDBY)
-			/* Useable path if active */
-			err = SCSI_DH_OK;
-		else
-			/* Path unuseable for unavailable/offline */
-			err = SCSI_DH_DEV_OFFLINED;
+		/* Transitioning time exceeded */
+		err = SCSI_DH_RETRY;
+		break;
+	case TPGS_STATE_OFFLINE:
+	case TPGS_STATE_UNAVAILABLE:
+		/* Path unuseable for unavailable/offline */
+		err = SCSI_DH_DEV_OFFLINED;
+		break;
+	default:
+		/* Useable path if active */
+		err = SCSI_DH_OK;
+		break;
 	}
 	return err;
 }
@@ -672,7 +676,9 @@ static int alua_activate(struct scsi_device *sdev,
 			goto out;
 	}
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED) {
+	if (h->tpgs & TPGS_MODE_EXPLICIT &&
+	    h->state != TPGS_STATE_OPTIMIZED &&
+	    h->state != TPGS_STATE_LBA_DEPENDENT) {
 		h->callback_fn = fn;
 		h->callback_data = data;
 		err = submit_stpg(h);
@@ -698,8 +704,11 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int ret = BLKPREP_OK;
 
-	if (h->state != TPGS_STATE_OPTIMIZED &&
-	    h->state != TPGS_STATE_NONOPTIMIZED) {
+	if (h->state == TPGS_STATE_TRANSITIONING)
+		ret = BLKPREP_DEFER;
+	else if (h->state != TPGS_STATE_OPTIMIZED &&
+		 h->state != TPGS_STATE_NONOPTIMIZED &&
+		 h->state != TPGS_STATE_LBA_DEPENDENT) {
 		ret = BLKPREP_KILL;
 		req->cmd_flags |= REQ_QUIET;
 	}

--------------090707060103070207080402--
