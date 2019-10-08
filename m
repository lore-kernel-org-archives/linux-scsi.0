Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F132AC4360C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 06:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F102067B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 06:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfJHGVi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 02:21:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:54074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730013AbfJHGVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 02:21:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2287AB150;
        Tue,  8 Oct 2019 06:21:35 +0000 (UTC)
Subject: Re: [PATCH] scsi_dh_alua: handle RTPG sense code correctly during
 state transitions
To:     "Ewan D. Milne" <emilne@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20191007135701.32389-1-hare@suse.de>
 <4ff5beeae5092d313d0e90a83f04a222400180f1.camel@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <220f6ffe-1657-f95f-c948-219b45f9496f@suse.de>
Date:   Tue, 8 Oct 2019 08:21:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4ff5beeae5092d313d0e90a83f04a222400180f1.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/19 10:45 PM, Ewan D. Milne wrote:
> See below.
> 
> On Mon, 2019-10-07 at 15:57 +0200, Hannes Reinecke wrote:
>> From: Hannes Reinecke <hare@suse.com>
>>
>> Some arrays are not capable of returning RTPG data during state
>> transitioning, but rather return an 'LUN not accessible, asymmetric
>> access state transition' sense code. In these cases we
>> can set the state to 'transitioning' directly and don't need to
>> evaluate the RTPG data (which we won't have anyway).
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 21 ++++++++++++++++-----
>>  1 file changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 4971104b1817..f32da0ca529e 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -512,6 +512,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>>  	unsigned int tpg_desc_tbl_off;
>>  	unsigned char orig_transition_tmo;
>>  	unsigned long flags;
>> +	bool transitioning_sense = false;
>>  
>>  	if (!pg->expiry) {
>>  		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
>> @@ -572,13 +573,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>>  			goto retry;
>>  		}
>>  		/*
>> -		 * Retry on ALUA state transition or if any
>> -		 * UNIT ATTENTION occurred.
>> +		 * If the array returns with 'ALUA state transition'
>> +		 * sense code here it cannot return RTPG data during
>> +		 * transition. So set the state to 'transitioning' directly.
>>  		 */
>>  		if (sense_hdr.sense_key == NOT_READY &&
>> -		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
>> -			err = SCSI_DH_RETRY;
>> -		else if (sense_hdr.sense_key == UNIT_ATTENTION)
>> +		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
>> +			transitioning_sense = true;
>> +			goto skip_rtpg;
>> +		}
>> +		/*
>> +		 * Retry on any other UNIT ATTENTION occurred.
>> +		 */
>> +		if (sense_hdr.sense_key == UNIT_ATTENTION)
>>  			err = SCSI_DH_RETRY;
>>  		if (err == SCSI_DH_RETRY &&
>>  		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
>> @@ -666,7 +673,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>>  		off = 8 + (desc[7] * 4);
>>  	}
>>  
>> + skip_rtpg:
>>  	spin_lock_irqsave(&pg->lock, flags);
>> +	if (transitioning_sense)
>> +		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
>> +
>>  	sdev_printk(KERN_INFO, sdev,
>>  		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
>>  		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
> 
> The patch itself looks OK, but I was wondering about a couple of things:
> 
>   - There are other places in scsi_dh_alua where the ASC/ASCQ 04 0A is checked
>     and we retry, I understand that this is a particular case you are solving
>     but is the changing of the state to -> transitioning (because that's what
>     the device said the state was) applicable in those other cases?
No. The original code was built around the assumption that RTPG would
return the status of the device; consequently we would have to retry
RTPG until we get a final status. But as mentioned, there are arrays
which cannot return RTPG data during transitioning, so the code would
never be able to detect a transitioning state.
With this patch we set the state directly once the said sense code is
received.
But this applies _only_ to the RTPG command, as this is required to move
the state machine along.
None of the other commands are affected.

>   - The code originally seems to have been under the assumption that the
>     transitioning state was a transient event, so the retry would pick up
>     the eventual state.  Now, some storage arrays spend a long time in the
>     transitioning state, but if we don't send another command are we going to
>     get the sense (or the UA) that triggers entry to the eventual ALUA state?
> 
Note, there are two types of retries.
The one is the 'normal' command retry, where we resend a command a given
number of times to retrieve the final status.
This is precisely the error which caused this patch.

And then there is a scheduled retry; here we essentially poll the array
with sending RTPG in regular intervals until the 'transitioning' state
is gone. (Check for 'alua_rtpg()' and the handling of the SCSI_DH_RETRY
return value). With the patch we continue to trigger that second type of
retries, which will eventually clear the transitioning state.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
