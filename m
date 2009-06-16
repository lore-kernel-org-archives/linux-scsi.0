From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] scsi: fix duplicate host number
Date: Tue, 16 Jun 2009 14:02:28 -0700
Message-ID: <4A380864.9020604@cisco.com>
References: <20090616062214.15969.55575.stgit@savbu-fcoe15.qa.nuovasystems.com> <4A37CFEA.3070106@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:44136 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbZFPVJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 17:09:56 -0400
In-Reply-To: <4A37CFEA.3070106@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Joe Eykholt wrote:
>> Subtract 1, so that scsi_host still starts with 0.
> ...
>> -static int scsi_host_next_hn;        /* host_no for next new host */
>> +static atomic_t scsi_host_next_hn;    /* host_no for next new host */
>>  
>>  
>>  static void scsi_host_cls_release(struct device *dev)
>> @@ -333,7 +333,7 @@ struct Scsi_Host *scsi_host_alloc(struct 
>> scsi_host_template *sht, int privsize)
>>  
>>      mutex_init(&shost->scan_mutex);
>>  
>> -    shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
>> +    shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
> 
> Can also be written
> 
> static atomic_t scsi_host_next_hn = ATOMIC_INIT(-1);
> ...
>     shost->host_no = atomic_inc_return(&scsi_host_next_hn);

Yes, I considered that, but then the variable name and comment wouldn't be correct.

Also, the initializer adds 4 bytes to the initialized data section, and
the code for -1 should increase text size by less than that, so I think it's a wash.
An atomic_fetch_and_add() would be handy.

	Cheers,
	Joe


