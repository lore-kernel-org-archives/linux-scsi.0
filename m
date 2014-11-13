From: Charles Chiou <ch1102chiou@gmail.com>
Subject: Re: [V2 PATCH 3/4] scsi:stex.c Add reboot support
Date: Thu, 13 Nov 2014 18:07:56 +0800
Message-ID: <546482FC.2090207@gmail.com>
References: <5462D62C.50602@gmail.com> <20141112172750.GB18862@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141112172750.GB18862@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@parallels.com, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 11/13/2014 01:27 AM, Christoph Hellwig wrote:
>> +static int stex_reboot_callback(struct notifier_block *self,
>> +							  unsigned long val,
>> +							  void *data)
>> +{
>> +	if (val == SYS_RESTART)
>> +		isRestart = 1;
>> +	return NOTIFY_OK;
>> +}
>>
>> @@ -1832,7 +1859,14 @@ static void stex_shutdown(struct pci_dev *pdev)
>>   {
>>   	struct st_hba *hba = pci_get_drvdata(pdev);
>>
>> -	stex_hba_stop(hba);
>> +	if (hba->yellowstone == 1)
>> +		stex_hba_stop(hba, ST_IGNORED);
>> +	else {
>> +		if (isRestart)
>> +			stex_hba_stop(hba, ST_S6);
>> +		else
>> +			stex_hba_stop(hba, ST_S5);
>> +	}
>
> This sort of check for reboot vs restart isn't really something
> we want in drivers.  I don't really know how we could find this
> out assuming we even want drivers to behave differently.
>
> Maybe Greg or someone on lkml has an idea how to best handle this case.
>


I have no idea to distinguish OS is going to reboot or shut down without 
this approach. I'll try to find it out.
Charles
