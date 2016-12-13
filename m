From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: version 3.18.44 to 3.18.45 introduced a bug in
 "drivers/scsi/megaraid/megaraid_sas_base.c"
Date: Tue, 13 Dec 2016 08:33:19 -0800
Message-ID: <f08db306-7e67-ff4d-979d-8baa82c40671@infradead.org>
References: <23B7B563BA4E9446B962B142C86EF24ADB6F24@CNMAILEX03.lenovo.com>
 <a9788b9c-6361-f79e-f851-e8c4871571cb@infradead.org>
 <20161213163013.GB20693@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161213163013.GB20693@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dashi DS1 Cao <caods1@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>
List-Id: linux-scsi@vger.kernel.org

On 12/13/16 08:30, Greg Kroah-Hartman wrote:
> On Tue, Dec 13, 2016 at 08:08:27AM -0800, Randy Dunlap wrote:
>> [adding other lists + gregkh]
>>
>>
>> On 12/13/16 02:56, Dashi DS1 Cao wrote:
>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> @@ -1614,16 +1614,13 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>>>                 goto out_done;
>>>         }
>>>
>>> -       switch (scmd->cmnd[0]) {
>>> -       case SYNCHRONIZE_CACHE:
>>> -               /*
>>> -                * FW takes care of flush cache on its own
>>> -                * No need to send it down
>>> -                */
>>> +       /*
>>> +        * FW takes care of flush cache on its own for Virtual Disk.
>>> +        * No need to send it down for VD. For JBOD send SYNCHRONIZE_CACHE to FW.
>>> +        */
>>> +       if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd)) {
>>>                 scmd->result = DID_OK << 16;
>>>                 goto out_done;
>>> -       default:
>>> -               break;
>>>         }
>>>
>>>         if (instance->instancet->build_and_issue_cmd(instance, scmd)) {
>>>
>>> MEGASAS_IS_LOGICAL is defined to be a macro with '?' operator, which has a lower precedence than '&&'.
>>> The macro should have been defined as:
>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>> @@ -1823,7 +1823,7 @@ struct megasas_instance_template {
>>>  };
>>>
>>>  #define MEGASAS_IS_LOGICAL(scp)                                                \
>>> -       (scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
>>> +       ((scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
>>>
>>>  #define MEGASAS_DEV_INDEX(inst, scp)                                   \
>>>         ((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +    \
>>>
>>> Dashi Cao
>>>
> 
> I don't maintain 3.18-stable :)
> 
> thanks,
> 
> greg k-h
> 

Thanks. My bad.

adding Sasha.


-- 
~Randy
