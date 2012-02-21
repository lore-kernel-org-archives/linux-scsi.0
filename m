From: Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH 1/1] SCSI: Add rumtime pm in the sd_check_events()
Date: Tue, 21 Feb 2012 09:09:00 +0800
Message-ID: <4F42EEAC.5080401@intel.com>
References: <Pine.LNX.4.44L0.1202201538500.11040-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab2BUBJy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 20:09:54 -0500
In-Reply-To: <Pine.LNX.4.44L0.1202201538500.11040-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org


Great Thanks for review.

On 2012=E5=B9=B402=E6=9C=8821=E6=97=A5 04:41, Alan Stern wrote:
> On Mon, 20 Feb 2012, Lan Tianyu wrote:
>
>> The sd_check_event() will be called periodly even when the device is=
 in
>> the suspended status to check media event. The scsi_test_unit_ready(=
) in
>> the sd_check_event() will issue scsi cmd request. Issuing scsi reque=
st when
>> the device is in the suspeneded status will cause problem. For examp=
le, when
>> a usb flash disk in the suspended status, scsi_test_unit_ready() iss=
ues a
>> scsi request. The request will be returned as failed because the usb=
 device
>> is not active. The patch adds scsi_autopm_get_device() and scsi_auto=
pm_put_device()
>> around scsi_test_unit_ready() in the sd_check_event() to resolve suc=
h problem.
>>
>> Signed-off-by: Lan Tianyu<tianyu.lan@intel.com>
>> ---
>>   drivers/scsi/sd.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c691fb5..7913bd1 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1183,8 +1183,14 @@ static unsigned int sd_check_events(struct ge=
ndisk *disk, unsigned int clearing)
>>
>>   	if (scsi_block_when_processing_errors(sdp)) {
>>   		sshdr  =3D kzalloc(sizeof(*sshdr), GFP_KERNEL);
>> +
>> +		retval =3D scsi_autopm_get_device(sdp);
>> +		if (retval)
>> +			goto out;
>> +
>>   		retval =3D scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
>>   					      sshdr);
>> +		scsi_autopm_put_device(sdp);
>>   	}
>>
>>   	/* failed to execute TUR, assume media not present */
> You might as well put the _get_device call before the kzalloc; no poi=
nt
> in allocating memory if it's not going to be used.
Yeah. I will update and send out soon.
> Apart from that, this is fine.  Are there any other places where the
> block layer sends I/O requests even when the device isn't open?
Currently, I just find this place.
> Alan Stern
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
