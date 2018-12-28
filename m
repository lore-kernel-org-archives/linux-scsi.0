From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/10] SCSI: fcoe: convert to use BUS_ATTR_WO
Date: Fri, 28 Dec 2018 13:50:53 +0100
Message-ID: <5691ac07-ec5d-893f-09e4-ff1acd889abd@suse.de>
References: <20181221075442.17109-1-gregkh@linuxfoundation.org>
 <20181221075442.17109-4-gregkh@linuxfoundation.org>
 <1545406185.2765.8.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545406185.2765.8.camel@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/21/18 4:29 PM, James Bottomley wrote:
> [scsi list cc added]
> On Fri, 2018-12-21 at 08:54 +0100, Greg Kroah-Hartman wrote:
>> We are trying to get rid of BUS_ATTR() and the usage of that in the
>> fcoe driver can be trivially converted to use BUS_ATTR_WO(), so use
>> that instead.
>>
>> At the same time remove a unneeded EXPORT_SYMBOL() marking for the
>> sysfs callback function we are renaming, no idea of how that got into
>> the tree...
> 
> The EXPORT_SYMBOL removal is fine, but
> 
> [...]
>> --- a/include/scsi/libfcoe.h
>> +++ b/include/scsi/libfcoe.h
>> @@ -405,10 +405,8 @@ int fcoe_transport_attach(struct fcoe_transport
>> *ft);
>>   int fcoe_transport_detach(struct fcoe_transport *ft);
>>
>>   /* sysfs store handler for ctrl_control interface */
>> -ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
>> -			       const char *buf, size_t count);
>> -ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
>> -				const char *buf, size_t count);
>> +ssize_t ctlr_create_store(struct bus_type *bus, const char *buf,
>> size_t count);
>> +ssize_t ctlr_destroy_store(struct bus_type *bus, const char *buf,
>> size_t count);
> 
> You're really damaging our prefix namespace here.  It looks like the
> ctlr_ name is a farly recent addition for sysfs (only myra/b) use it in
> SCSI but it's inviting symbol clashes.
> 
Hmm. I was under the impression that all sysfs functions from myrb/myrs 
are local, hence I would not need to prefix them.
If this isn't the case I definitely will be fixing them.

But in any case, if possible any sysfs function should be local to the 
driver; no-one else should ever attempt to use them.
And we should be making it so if that's not the case.

Cheers,

Hannes
