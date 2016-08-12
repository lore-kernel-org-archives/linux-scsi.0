From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] SAS: use sas_rphy instead of sas_end_device to obtain
 address.
Date: Fri, 12 Aug 2016 16:39:51 +0200
Message-ID: <75620aea-33df-9cf3-7eb2-ec209384eb4e@suse.de>
References: <1470902352-96734-1-git-send-email-jthumshirn@suse.de>
 <1470928175.2334.9.camel@linux.vnet.ibm.com>
 <20160811164350.vakulxlr4xlsyrxn@c203.arch.suse.de>
 <1470938407.2334.36.camel@linux.vnet.ibm.com>
 <20160812100854.4cks5qxsommfwsjk@c203.arch.suse.de>
 <20160812131125.n7p47dcf7sinwg54@c203.arch.suse.de>
 <1471012475.2407.6.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1471012475.2407.6.camel@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

On 08/12/2016 04:34 PM, James Bottomley wrote:
> On Fri, 2016-08-12 at 15:11 +0200, Johannes Thumshirn wrote:
>> On Fri, Aug 12, 2016 at 12:08:54PM +0200, Johannes Thumshirn wrote:
>>> Ok, we can't use the rphy because of wide-ports. We can't fix it to 
>>> an end device either, as this makes some peoples systems 
>>> unbootable. Now let's find a third option satisfying the needs of 
>>> SAS wide-ports and my customers (and others running 4.5+ with a SAS
>>> enclosure).
>>>
>>> I'm digging...
>>
>>
>> To answer myself, Hannes suggested doing it like this:
>>
>> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
>> index 53ef1cb6..1d82053 100644
>> --- a/drivers/scsi/ses.c
>> +++ b/drivers/scsi/ses.c
>> @@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct
>> enclosure_device *edev,
>>
>>         ses_enclosure_data_process(edev, to_scsi_device(edev
>> ->edev.parent), 0);
>>
>> -       if (is_sas_attached(sdev))
>> +       if (scsi_is_sas_rphy(&sdev->sdev_gendev))
>>                 efd.addr = sas_get_address(sdev);
>>
>> 		if (efd.addr) {
>>
>>
>> The reasoning behind this is, we only read the address if we have an
>> actual sas_rphy.
>>
>> Would this be OK for you?
> 
> Could you please debug the why? first before we start throwing patches
> around.  is_sas_attached(sdev) returns true if the sdev is the child of
> a SAS controller.  What is this thing you've found that has a sdev
> attached to a SAS controller but isn't and end device?
> 
> if is_sas_attached() passes but scsi_is_sas_rphy() doesn't you've got a
> device that is the child of a SAS host which has an rphy but which
> isn't an expander or end device.  That's pretty much the end of the
> list of things which can lie at the end of rphys since we lump the SATA
> possibilities in with end devices.
> 
hpsa magic.

The hpsa driver has some sdevs handled by the SAS transport class (for
the pass-through devices) and some sdevs (eg logical volumes) which are not.
As 'is_sas_attached' only checks if the _host_ has the SAS transport
class attached (which it will have), it will not work as expected for
devices which are not handled by the SAS transport class (like the
'normal' hpsa logical volumes).
And the logical volumes don't even has a SAS address assigned to them,
so in either case the original check will draw a blank here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
