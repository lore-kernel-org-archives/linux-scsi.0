From: Martin Peschke <mp3@de.ibm.com>
Subject: Re: [patch 08/11] zfcp: Add traces for state changes.
Date: Thu, 27 Mar 2008 15:31:55 +0100
Message-ID: <47EBAFDB.8040101@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com> <20080327133028.840759000@de.ibm.com> <20080327142001.GA4122@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:5922 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbYC0OcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 10:32:00 -0400
In-Reply-To: <20080327142001.GA4122@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

Heiko Carstens schrieb:
>> -	zfcp_erp_modify_adapter_status(adapter,
>> +	zfcp_erp_modify_adapter_status(adapter, 24, 0,
>>  				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
>>  }
>>
>> @@ -216,7 +216,7 @@ zfcp_erp_adapter_reopen_internal(struct 
>>  			       zfcp_get_busid_by_adapter(adapter));
>>  		debug_text_event(adapter->erp_dbf, 5, "a_ro_f");
>>  		/* ensure propagation of failed status to new devices */
>> -		zfcp_erp_adapter_failed(adapter);
>> +		zfcp_erp_adapter_failed(adapter, 13, 0);
> 
> 24, 13? I bet you made sure that these numbers fit the huge list.. and
> hopefully nobody will ever add anything in between.
> Why not just pass a string? This looks way too complicated and error-prone.

Well, do you remember the scheme introduced by our (s390) kernel message 
catalog? Same approach.

I think numbers are superior. I won't store strings because I want to 
keep trace entries as small as possible - 1 or 2 bytes for a number vs. 
lots of bytes for a string ... for each event.

Yes, I did this carefully. The strings array helps to keep track of used 
IDs.

Regards,
Martin

