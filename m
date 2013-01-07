From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v11 9/9] libata: do not suspend port if normal ODD is
 attached
Date: Mon, 07 Jan 2013 09:09:41 +0800
Message-ID: <50EA2055.1030600@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com> <1357440509-28108-10-git-send-email-aaron.lu@intel.com> <50E98B7C.7030908@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <50E98B7C.7030908@mvista.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Sergei,

Thanks for reviewing, will update in next revision.

-Aaron

On 01/06/2013 10:34 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 06-01-2013 6:48, Aaron Lu wrote:
> 
>> For ODDs, the upper layer will poll for media change every a few
>> seconds, which will make it enter and leave suspend state very
>> oftern. And as each suspend will also cause a hard/soft reset,
> 
>     s/oftern/often/
> 
>> the gain of runtime suspend is very little while the ODD may
>> mis-function after constantly being reset. So the idle callback
>> here will not proceed to suspend if a non-ZPODD capable ODD is
>> attached to the port.
> 
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> ---
>>   drivers/ata/libata-core.c | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
> 
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 65a362e..f664a90 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -5408,8 +5408,27 @@ static int ata_port_resume(struct device *dev)
>>   	return rc;
>>   }
>>
>> +/*
>> + * For ODDs, the upper layer will poll for media change every a few seconds,
>> + * which will make it enter and leave suspend state every a few seconds. And
> 
>     Article is not needed before "few". (Same comment to the changelog.)
> 
>> + * as each suspend will cause a hard/soft reset, the gain of runtime suspend
>> + * is very little and the ODD may mis-function after constantly being reset.
> 
>     s/mis-function/malfunction/ perhaps? (Same in the changelog.)
> 
> MBR, Sergei
> 

