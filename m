From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH][RFC] iSCSI transport class
Date: Mon, 05 Apr 2004 14:10:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4071CB37.7070401@us.ibm.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAA9J1WRvNm9EOzhZvg3SDlSwEAAAAA@cisco.com> <4071BFFF.5090405@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:11712 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263271AbUDEVjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2004 17:39:06 -0400
In-Reply-To: <4071BFFF.5090405@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Surekha.PC" <surekhap@cisco.com>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net

Mike Christie wrote:

> Hey,
> 
> Surekha.PC wrote:
> 
>>  Hi Mike,
>>
>>   Sorry for the delay.
>>   The structure which I represented was meant to have iSCSI transport
>> attributes
>>   under their respective category. Right now, in our iSCSI driver all
>> attributes are defined
>>   in `iscsi-attr.c` and `iscsi-debug-attr.c` which need to be either 
>> per lun
>> or per target.
>>
>>>> I have reviewed your changes for iSCSI transport class. 
>>>
>>>
>>> The changes
>>>
>>>> look fine.  I have few suggestions on further improvements. The 
>>>> attributes can be organised
>>>> under iSCSI transport class in the following structure.
>>>>
>>>> # ls /sys/class/iscsi_transport/*
>>>>
>>>>  /* iSCSI host specific attributes */
>>>>  |-- shutdown
>>>>  |-- host_id
>>>>  |-- ....
>>>
>>>
>>> The examples you placed here are not tranport specific. They are just 
>>> HBA values, and should stay under the host attributes.
>>
>>
>>
>> AFAIU Transport class is basically to hold all private attributes of the
>> iSCSI driver.
> 
> 
> That is wrong. Look at the qla2xxx or 53c700 driver. The transport
> classes represent transport specifics. They are not there for a
> driver that is a particular transport to place all its attributes, and
> each driver that is a particular transport does not implement its
> own class.

Let me clarify what I wrote. I am just saying becuase Cisco's software 
iscsi driver has some attribute which a fc or spi or whatever driver 
lacks does not necessarily mean it is transport related. Some of your 
attributes are HBA or device related, and some are a result of your 
implmentation, and some are iscsi related.

>> Since iSCSI driver has attributes which are hba/target/lun specific it 
>> would
>> be good to have them in a place away from the generic scsi attributes.
>> For eg, the "shutdown" attribute is a iSCSI attribute to shutdown the 
>> iSCSI
>> hba.
> 
> 
> shutdown is a hba thing, and has nothing to do with iscsi itself.
> 
>> Similarly host_id is iSCSI transport specific and gives the host number.
> 
> 
> How is the struct scsi_host's host_no related to the transport?
> It is assigned from the SCSI layer.
> 
>>> Also, the host layout here does not look right. What happens when I 
>>> have multiple HBAs?
>>
>>
>> Right now iSCSI driver supports single HBA, hence this representation 
>> is OK.
>> However in multiple HBA case, it can be represented as below.
> 
> 
> Again, only specific to your driver.
> 
>>  /sys/class/iscsi_transport/
>>    |--host1/
>>        |-- shutdown_hba
>>        |-- show_hba_id
>>    |--host2/
>>        |-- ---"----
>>        |-- ---"----
>>
>>  
>>
>>>>  /* iSCSI target specific attributes */
>>>>  |-- 1:0:1/
>>>>           |-- target_addr
>>>>           |-- target_name
>>>>           |-- target_port
>>>>           |-- ....
>>>
>>>
>>> I agree these would be nice under a target attribute. Did
>>> you have something to post since the last time we talked,
>>> or did you write the example by hand?
>>
>>
>>
>> I have written the example by hand, I am working towards implementing it.
>>
>>>>  /* lun specific attributes */
>>>>  |-- 1:0:1:0/
>>>>             |-- device -> ../../../devices/platform/iscsi/1:0:0:0
>>>>             |-- driver -> ../../../bus/scsi/drivers/sd
>>>>             |-- lun_status
>>>>             |-- ....
>>>
>>>
>>> I don't think anything in lun_status is iscsi specific.
>>
>>
>>
>> We have lun specific attributes defined in iSCSI driver some of which 
>> can be
>> used in debug mode for testing purposes e.g initiate command timeout on a
>> lun, set lun queue as busy, query the lun status etc.
>> I think since they are private to iSCSI, this is the right place holder.
> 
> 
> Again, specific to your particular iscsi driver vs transport.

Just another clarification. I am not saying everying you are doing at 
the lun level is not iscsi specific.
