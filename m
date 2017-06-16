From: Hannes Reinecke <hare@suse.com>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Fri, 16 Jun 2017 08:38:55 +0200
Message-ID: <157527d8-c133-f2bc-4aab-34182f7e9374@suse.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
 <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
 <20170305173528.00006b41@gmx.de>
 <CAL1RGDVBvgzaQTRfWS14=S1M1DuzKGPYzAPWWeQyAASDQ=05Rw@mail.gmail.com>
 <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
 <9c8db0c0-01cf-9b52-d229-7706549c8a8a@suse.com>
 <20170614220256.00004dd7@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170614220256.00004dd7@gmx.de>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: James Smart <james.smart@broadcom.com>, Roland Dreier <roland@purestorage.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/14/2017 10:02 PM, Sebastian Herbszt wrote:
> Hannes Reinecke wrote:
>> On 06/13/2017 01:08 AM, James Smart wrote:
> 
> [snip]
> 
>>> Questions:
>>> a) How best to deal with overlapping pci id's ?  E.g. if we do (1)
>>> and we have an initiator and target driver, there is a lot of
>>> adapters that are fully functional for target operation, but were
>>> sold as primarily an initiator adapter. How could we manage target
>>> mode enablement without code mod or hard pci id partitioning ?   I
>>> know individual pci unbind/bind could work, but its been frowned
>>> upon as a long term option. Same thing goes for module parameters
>>> to select which ports do what role. 
>> That indeed is a problem.
>>
>> Ideally we should be able to set the required mode on a per-port base;
>> having it per PCI device might be too coarse. Unless you represent
>> each port as a PCI function; not sure if that's the case, though.
> 
> It seems to be the case.
> At least a dual port FC HBA (SLI-3) has two PCI functions.
> 
>> If we were to allow to set the mode on a per-port base we could easily
>> implement kernel parameters like fctarget=WWPN and/or
>> fcinitiator=WWPN; NVMe could be treated similarly.
>> And have a config option specifying if the default FC mode should be
>> initiator or target.
> 
> The old lpfc+lpfc_scst combination and also qla2xxx+tcm_qla2xxx allow
> simultaneous initiator and target mode on the same port. I guess this
> won't be possible with a split driver.
> 
Which was kinda the point of this entire conversation ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
