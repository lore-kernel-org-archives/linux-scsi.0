From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND 1/2] SCSI: use scsi_device->timeout consistently
Date: Mon, 20 Nov 2006 08:26:29 +0900
Message-ID: <4560E825.3080504@gmail.com>
References: <20061119125115.GJ2184@htj.dyndns.org> <Pine.LNX.4.64.0611192353590.4946@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:64459 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S933739AbWKSX0h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Nov 2006 18:26:37 -0500
Received: by nf-out-0910.google.com with SMTP id o25so2109483nfa
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2006 15:26:36 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.0611192353590.4946@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Sun, 19 Nov 2006, Tejun Heo wrote:
> 
>> Each high level driver uses scsi_device->timeout diffrently.
>>
> ...
>> Index: scsi-misc-2.6/drivers/scsi/st.c
>> ===================================================================
>> --- scsi-misc-2.6.orig/drivers/scsi/st.c
>> +++ scsi-misc-2.6/drivers/scsi/st.c
>> @@ -3986,7 +3986,8 @@ static int st_probe(struct device *dev)
>>  	tpnt->partition = 0;
>>  	tpnt->new_partition = 0;
>>  	tpnt->nbr_partitions = 0;
>> -	tpnt->device->timeout = ST_TIMEOUT;
>> +	if (!SDp->timeout)
>> +		SDp->timeout = ST_TIMEOUT;
> 
> I don't think this should be done. It probably makes the default timeout 
> way too short. The error recovery with tapes takes a long time. The user 
> can change the timeout if the default (900 seconds) seems too long (or 
> short).
> 
> I don't think there is anything in the midlevel or low-level code to set 
> the timeout based on the device characteristics. This is left to the ULD.

Low level driver should configure timeout or retries to a known value 
iff it knows what it's doing, when it knows both transport and 
device-type specific characteristic.  AFAICS, the only driver which 
modifies sdev->timeout is ipr and it does so only when it knows the 
device is of certain type.  So, I don't think it will cause any trouble, 
and using different initialization in different ULDs is too subtle.

Thanks.

-- 
tejun
