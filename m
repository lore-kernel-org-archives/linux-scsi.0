From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] SCSI: Scale up REPORT_LUNS timeout on failure
Date: Fri, 4 Sep 2015 10:47:13 -0500
Message-ID: <55E9BD01.3020002@linux.vnet.ibm.com>
References: <55D65082.6020504@linux.vnet.ibm.com> <55DDB8F3.3020308@suse.de>
 <55E70852.9050506@linux.vnet.ibm.com>
 <1441381013.2204.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60017 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbbIDPrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2015 11:47:22 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 4 Sep 2015 09:47:22 -0600
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id B0AABC90041
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2015 11:38:23 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t84FlJhq62390312
	for <linux-scsi@vger.kernel.org>; Fri, 4 Sep 2015 15:47:19 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t84FlIsX029259
	for <linux-scsi@vger.kernel.org>; Fri, 4 Sep 2015 11:47:19 -0400
In-Reply-To: <1441381013.2204.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On 09/04/2015 10:36 AM, James Bottomley wrote:
> On Wed, 2015-09-02 at 09:31 -0500, Brian King wrote:
>> This patch fixes an issue seen with an IBM 2145 (SVC) where, following an error
>> injection test which results in paths going offline, when they came
>> back online, the path would timeout the REPORT_LUNS issued during the
>> scan. This timeout situation continued until retries were expired, resulting in
>> falling back to a sequential LUN scan. Then, since the target responds
>> with PQ=1, PDT=0 for all possible LUNs, due to the way the sequential
>> LUN scan code works, we end up adding 512 LUNs for each target, when there
>> is really only a small handful of LUNs that are actually present.
>>
>> This patch doubles the timeout used on the REPORT_LUNS for each retry
>> after a timeout is seen on a REPORT_LUNS. This patch solves the issue
>> of 512 non existent LUNs showing up after this event. Running the test
>> with this patch still showed that we were regularly hitting two timeouts,
>> but the third, and final, REPORT_LUNS was always successful.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/scsi/scsi_scan.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff -puN drivers/scsi/scsi_scan.c~scsi_report_luns_timeout_escalate drivers/scsi/scsi_scan.c
>> --- linux/drivers/scsi/scsi_scan.c~scsi_report_luns_timeout_escalate	2015-09-02 08:49:07.268243497 -0500
>> +++ linux-bjking1/drivers/scsi/scsi_scan.c	2015-09-02 08:49:07.272243461 -0500
>> @@ -1304,6 +1304,7 @@ static int scsi_report_lun_scan(struct s
>>  	struct scsi_device *sdev;
>>  	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
>>  	int ret = 0;
>> +	int timeout = SCSI_TIMEOUT + 4 * HZ;
>>  
>>  	/*
>>  	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
>> @@ -1383,7 +1384,7 @@ retry:
>>  
>>  		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
>>  					  lun_data, length, &sshdr,
>> -					  SCSI_TIMEOUT + 4 * HZ, 3, NULL);
>> +					  timeout, 3, NULL);
>>  
>>  		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
>>  				"scsi scan: REPORT LUNS"
>> @@ -1392,6 +1393,8 @@ retry:
>>  				retries, result));
>>  		if (result == 0)
>>  			break;
>> +		else if (host_byte(result) == DID_TIME_OUT)
>> +			timeout = timeout * 2;
>>  		else if (scsi_sense_valid(&sshdr)) {
>>  			if (sshdr.sense_key != UNIT_ATTENTION)
> 
> Actually, this is a bit pointless, isn't it; why retry, why not just set
> the initial timeout? ... I could understand if retrying and printing a
> message gave important or useful information, but it doesn't.  How long
> do you actually need? ... we can just up the initial timeout to that.
> Currently we have a hacked 6s which looks arbitrary.  Would 15s be
> better?  Nothing really times out anyway, so everything else will still
> reply within the original 6s giving zero impact in the everyday case.

12 seconds definitely isn't long enough, but 24 seconds seems to work, at least
after we go through both a 6 and 12 second timeout. Anyone opposed to using 30 seconds?
15 seconds is likely to be right on the edge in this scenario.


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

