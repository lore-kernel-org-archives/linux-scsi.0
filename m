From: wenxiong@linux.vnet.ibm.com
Subject: Re: [dm-devel] [PATCH 1/1] multipath-tools: Change path checker for
 IBM IPR devices
Date: Mon, 06 Oct 2014 17:50:32 -0400
Message-ID: <20141006175032.Horde.YOAhPr63sPbLDmxx24U30w9@ltc.linux.ibm.com>
References: <20140924195721.148637349@linux.vnet.ibm.com>
 <20140924195752.289011902@linux.vnet.ibm.com> <5423B664.2020007@suse.de>
 <5424472E.4060300@linux.vnet.ibm.com> <20140925165743.GA20621@infradead.org>
 <20140930140547.Horde.m7EONeG2u3AJYXxG2TLrmQ3@ltc.linux.ibm.com>
 <20141001125134.GB31067@infradead.org> <5432B3A5.4080001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43151 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJFVug (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2014 17:50:36 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Mon, 6 Oct 2014 15:50:35 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 4EC503E4003E
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2014 15:50:34 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s96LoYae38469718
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2014 23:50:34 +0200
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s96LoXx7029297
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2014 15:50:34 -0600
In-Reply-To: <5432B3A5.4080001@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>


Quoting Brian King <brking@linux.vnet.ibm.com>:

> On 10/01/2014 07:51 AM, Christoph Hellwig wrote:
>> Unfortunately the patch wasn't quite correct - all TEST_UNIT_READY
>> commands are sent as BLOCK_PC, so this would basically revert James'
>> original fix for the SATL case.
>>
>> Am I right to assume you only need the call to scsi_dh->check_sense and
>> not the rest of the handling for the multipath path checker?  If that's
>> the case something like the patch below sould work:
>
> This would work if we also duplicated the 02/04/02 K/C/Q check in  
> alua_check_sense
> handler.
>
> Wendy - can you try my patch below, along with Christoph's latest patch here
> and see if that resolves the issue?
>
> Thanks,
>
> Brian
>
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 5db8454..399c1c8 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -459,14 +459,6 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>>  	if (! scsi_command_normalize_sense(scmd, &sshdr))
>>  		return FAILED;	/* no valid sense data */
>>
>> -	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
>> -		/*
>> -		 * nasty: for mid-layer issued TURs, we need to return the
>> -		 * actual sense data without any recovery attempt.  For eh
>> -		 * issued ones, we need to try to recover and interpret
>> -		 */
>> -		return SUCCESS;
>> -
>>  	scsi_report_sense(sdev, &sshdr);
>>
>>  	if (scsi_sense_is_deferred(&sshdr))
>> @@ -482,6 +474,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>>  		/* handler does not care. Drop down to default handling */
>>  	}
>>
>> +	if (scmd->cmnd[0] == TEST_UNIT_READY && scmd->scsi_done != scsi_eh_done)
>> +		/*
>> +		 * nasty: for mid-layer issued TURs, we need to return the
>> +		 * actual sense data without any recovery attempt.  For eh
>> +		 * issued ones, we need to try to recover and interpret
>> +		 */
>> +		return SUCCESS;
>> +
>>  	/*
>>  	 * Previous logic looked for FILEMARK, EOM or ILI which are
>>  	 * mainly associated with tapes and returned SUCCESS.
>>
>
>
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/device_handler/scsi_dh_alua.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff -puN  
> drivers/scsi/device_handler/scsi_dh_alua.c~alua_allow_restart  
> drivers/scsi/device_handler/scsi_dh_alua.c
> ---  
> linux/drivers/scsi/device_handler/scsi_dh_alua.c~alua_allow_restart	2014-10-06 10:19:16.184798305  
> -0500
> +++  
> linux-bjking1/drivers/scsi/device_handler/scsi_dh_alua.c	2014-10-06  
> 10:20:35.743165951 -0500
> @@ -474,6 +474,13 @@ static int alua_check_sense(struct scsi_
>  			 * LUN Not Ready -- Offline
>  			 */
>  			return SUCCESS;
> +		if (sdev->allow_restart &&
> +		    (sense_hdr->asc == 0x04) && (sense_hdr->ascq == 0x02))
> +			/*
> +			 * if the device is not started, we need to wake
> +			 * the error handler to start the motor
> +			 */
> +			return FAILED;
>  		break;
>  	case UNIT_ATTENTION:
>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
> _
>
> --

Sorry it took some time since we need to re-config the systems for this test.

With Christoph's new patch only, still saw the failure.
With Christoph's new patch + Brian's patch, works fine, didn't see the  
failure.


Thanks,
Wendy


> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


