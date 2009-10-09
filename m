From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: [PATCH] drivers/ata/ahci build break.
Date: Fri, 09 Oct 2009 13:48:12 +0530
Message-ID: <4ACEF1C4.4050204@in.ibm.com>
References: <4ACED7E2.2010108@in.ibm.com> <20091009064638.GA27673@parisc-linux.org> <4ACEDFA9.9080102@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36667 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbZJIITG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2009 04:19:06 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id n998GrTS015713
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2009 19:16:53 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n998IGNM1155108
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2009 19:18:16 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n998IFxr004742
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2009 19:18:16 +1100
In-Reply-To: <4ACEDFA9.9080102@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Tejun Heo wrote:
> Matthew Wilcox wrote:
>   
>> The usual way to do this is to make sure there's a dummy
>> ahci_gtf_filter_workaround so there doesn't have to be that ifdef in
>> the caller.  This is probably easier to do like this:
>>
>> @@ -2884,6 +2884,7 @@ static bool ahci_broken_online(struct pc
>>  	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
>>  }
>>  
>>  static void ahci_gtf_filter_workaround(struct ata_host *host)
>>  {
>> +#ifdef CONFIG_ATA_ACPI
>>  	static const struct dmi_system_id sysids[] = {
>> @@ -2927,6 +2928,7 @@ static void ahci_gtf_filter_workaround(s
>>  				dev->gtf_filter |= filter;
>>  	}
>> +#endif
>>  }
>>     
>
> Fix is already included in Jeff's tree.
>
> Thanks.
>
>   
Ah Thanks.

Regards
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

