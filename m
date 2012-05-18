From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 2/3] alua: retry alua rtpg extended header for illegal
 request response
Date: Thu, 17 May 2012 22:00:36 -0400
Message-ID: <4FB5AD44.2030705@redhat.com>
References: <1337177705-17114-1-git-send-email-revers@redhat.com> <1337177705-17114-2-git-send-email-revers@redhat.com> <77471C95FAFD844C8CA02DD4F4C5FE2B06775B@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966571Ab2ERCAm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 22:00:42 -0400
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B06775B@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/17/2012 05:02 PM, Moger, Babu wrote:
> Rob, Minor comments below.

Thanks for looking.

>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Rob Evers
>> Sent: Wednesday, May 16, 2012 9:15 AM
>> To: linux-scsi@vger.kernel.org
>> Subject: [PATCH 2/3] alua: retry alua rtpg extended header for illegal request
>> response
>>
>> From: Rob Evers<revers@redhat.com>
>>
>> Some storage arrays are known to return 'illegal request'
>> when an rtpg extended header request is made.  T10 says the
>> array should ignore the bit, and return the non-extended
>> rtpg as the array doesn't support the request.  Working
>> around this by retrying the rtpg request without the extended
>> header bit set when the extended rtpg request results in
>> illegal request.
>>
>> Signed-off-by: Rob Evers<revers@redhat.com>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_alua.c |   25
>> ++++++++++++++++++++++---
>>   1 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 6a7efd3..ca414ae 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -173,7 +173,8 @@ done:
>>    * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>>    * @sdev: sdev the command should be sent to
>>    */
>> -static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data
>> *h)
>> +static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data
>> *h,
>> +			    bool rtpg_ext_hdr_req)
>>   {
>>   	struct request *rq;
>>   	int err = SCSI_DH_RES_TEMP_UNAVAIL;
>> @@ -184,7 +185,10 @@ static unsigned submit_rtpg(struct scsi_device
>> *sdev, struct alua_dh_data *h)
>>
>>   	/* Prepare the command. */
>>   	rq->cmd[0] = MAINTENANCE_IN;
>> -	rq->cmd[1] = MI_REPORT_TARGET_PGS |
>> MI_EXT_HDR_PARAM_FMT;
>> +	if (rtpg_ext_hdr_req)
>> +		rq->cmd[1] = MI_REPORT_TARGET_PGS |
>> MI_EXT_HDR_PARAM_FMT;
>> +	else
>> +		rq->cmd[1] = MI_REPORT_TARGET_PGS;
>>   	rq->cmd[6] = (h->bufflen>>  24)&  0xff;
>>   	rq->cmd[7] = (h->bufflen>>  16)&  0xff;
>>   	rq->cmd[8] = (h->bufflen>>   8)&  0xff;
>> @@ -517,6 +521,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct
>> alua_dh_data *h)
>>   	int len, k, off, valid_states = 0;
>>   	unsigned char *ucp;
>>   	unsigned err;
>> +	bool rtpg_ext_hdr_req = 1;
>>   	unsigned long expiry, interval = 1000;
>>   	unsigned int tpg_desc_tbl_off;
>>   	unsigned char orig_transition_tmo;
>> @@ -527,7 +532,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct
>> alua_dh_data *h)
>>   		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
>>
>>    retry:
>> -	err = submit_rtpg(sdev, h);
>> +	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
>>
>>   	if (err == SCSI_DH_IO&&  h->senselen>  0) {
>>   		err = scsi_normalize_sense(h->sense,
>> SCSI_SENSE_BUFFERSIZE,
>> @@ -535,6 +540,20 @@ static int alua_rtpg(struct scsi_device *sdev, struct
>> alua_dh_data *h)
>>   		if (!err)
>>   			return SCSI_DH_IO;
>>
>> +		/*
>> +		 * submit_rtpb() has failed on existing arrays
> There is a typo.  Should be submit_rtpg.

yes.

>
>> +		 * when requesting extended header info, and
>> +		 * the array doesn't support extended headers,
>> +		 * even though it shouldn't according to T10.
>> +		 * The retry without the ALUA_RTPG_EXT_HDR_REQ

typo here too, ALUA_RTPG_EXT_HDR_REQ should be rtpg_ext_hdr_req

>> +		 * handles this.
>> +		 */
>> +		if (sense_hdr.sense_key == ILLEGAL_REQUEST&&
>> +		    sense_hdr.asc == 0x24&&  sense_hdr.ascq == 0) {
>> +			rtpg_ext_hdr_req = 0;
>> +			goto retry;
> We should probably have an exit criteria here.  What if target misbehaves
> (with ILLEGAL_REQUEST) even with rtpg_ext_hdr_req = 0.

Do you have a more detailed suggestion on the
exit criteria?

What I can say is that this works for the only case I know of where
an array doesn't work as it is supposed to according to T10 w.r.t.
extended rtpg format request.

>
>> +		}
>> +
>>   		err = alua_check_sense(sdev,&sense_hdr);
>>   		if (err == ADD_TO_MLQUEUE&&  time_before(jiffies,
>> expiry))
>>   			goto retry;
>> --
>> 1.7.7.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

