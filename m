From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: scsi_dh_alua: add missing transitioning state support
Date: Mon, 20 Sep 2010 21:27:27 -0500
Message-ID: <4C98180F.1020707@cs.wisc.edu>
References: <1282071956-391-1-git-send-email-snitzer@redhat.com> <1282073039.30453.37.camel@haakon2.linux-iscsi.org> <4C7B7B9E.3020002@suse.de> <20100831151129.GA18855@redhat.com> <20100920153539.GA28284@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39504 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0IUCVz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2010 22:21:55 -0400
In-Reply-To: <20100920153539.GA28284@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 09/20/2010 10:35 AM, Mike Snitzer wrote:
> Hi Hannes,
>
> On Tue, Aug 31 2010 at 11:11am -0400,
> Mike Snitzer<snitzer@redhat.com>  wrote:
>
>> On Mon, Aug 30 2010 at  5:36am -0400,
>> Hannes Reinecke<hare@suse.de>  wrote:
>>
>>> Nicholas A. Bellinger wrote:
>>>> On Tue, 2010-08-17 at 15:05 -0400, Mike Snitzer wrote:
>>>>> Handle transitioning in the prep_fn.
>>>>> Handle transitioning in alua_rtpg's implicit alua code too.
>>>>>
>>>>> These gaps were identified during controller failover testing of an
>>>>> ALUA array.
>>>>>
>>>>> Signed-off-by: Mike Snitzer<snitzer@redhat.com>
>>>>> ---
>>>>>   drivers/scsi/device_handler/scsi_dh_alua.c |   10 +++++++---
>>>>>   1 files changed, 7 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>> index 1a970a7..c1eedc5 100644
>>>>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>>>>> @@ -616,6 +616,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
>>>>>   		    h->state == TPGS_STATE_STANDBY)
>>>>>   			/* Useable path if active */
>>>>>   			err = SCSI_DH_OK;
>>>>> +		else if (h->state == TPGS_STATE_TRANSITIONING)
>>>>> +			/* State transition, retry */
>>>>> +			goto retry;
>>>>>   		else
>>>>>   			/* Path unuseable for unavailable/offline */
>>>>>   			err = SCSI_DH_DEV_OFFLINED;
>>>>> @@ -698,13 +701,14 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>>>>>   	struct alua_dh_data *h = get_alua_data(sdev);
>>>>>   	int ret = BLKPREP_OK;
>>>>>
>>>>> -	if (h->state != TPGS_STATE_OPTIMIZED&&
>>>>> -	    h->state != TPGS_STATE_NONOPTIMIZED) {
>>>>> +	if (h->state == TPGS_STATE_TRANSITIONING)
>>>>> +		ret = BLKPREP_DEFER;
>>>>> +	else if (h->state != TPGS_STATE_OPTIMIZED&&
>>>>> +		 h->state != TPGS_STATE_NONOPTIMIZED) {
>>>>>   		ret = BLKPREP_KILL;
>>>>>   		req->cmd_flags |= REQ_QUIET;
>>>>>   	}
>>>>>   	return ret;
>>>>> -
>>>>>   }
>>>>>
>>>>
>>>> Makes sense to me..
>>>>
>>>> Acked-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
>>>>
>>> Not so fast. There are two problems with this approach:
>>>
>>> The path is retried indefinitely. Arrays are _supposed_ to be in 'transitioning'
>>> only temporary; however, if the array is stuck due to a fw error we're stuck in 'defer',
>>> too.
>>
>> And what is the problem with that?  The IO will eventually time out.
>
> To restate as a question: even though we'll retry in alua_rtpg();
> shouldn't the SCSI command eventually time out (via
> scsi_attempt_requeue_command)?

That function is only in RHEL. Requests that are prepd and sent to the 
scsi layer and driver would eventually timeout in scsi_softirq_done in 
upstream.

alua_prep_fn prevents the IO from getting sent to the scsi layer so we 
do not hit the check in scsi_softirq_done though.
