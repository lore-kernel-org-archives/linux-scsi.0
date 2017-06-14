From: Hannes Reinecke <hare@suse.com>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Wed, 14 Jun 2017 13:40:14 +0200
Message-ID: <9c8db0c0-01cf-9b52-d229-7706549c8a8a@suse.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
 <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
 <20170305173528.00006b41@gmx.de>
 <CAL1RGDVBvgzaQTRfWS14=S1M1DuzKGPYzAPWWeQyAASDQ=05Rw@mail.gmail.com>
 <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:50899 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdFNLkc (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 14 Jun 2017 07:40:32 -0400
In-Reply-To: <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Roland Dreier <roland@purestorage.com>, Sebastian Herbszt <herbszt@gmx.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On 06/13/2017 01:08 AM, James Smart wrote:
> On 5/16/2017 12:59 PM, Roland Dreier wrote:
>> On Sun, Mar 5, 2017 at 8:35 AM, Sebastian Herbszt <herbszt@gmx.de> wrote:
>>> Just like Hannes I do favour integration. I guess it could be
>>> comparable to qla2xxx + tcm_qla2xxx, lpfc + lpfc_scst and
>>> lpfc + tcm_lpfc. That approach might even help Bart with his
>>> target driver unification if he didn't give up on that topic.
>> Resurrecting this old topic - sorry for not seeing this go by initially.
>>
>> For context, I have a lot of experience debugging the qla2xxx target
>> code - we did a lot of work to get error/exception paths correct.
>> Basic FC target support is pretty straightforward but handling SAN log
>> in / log out events and other strange things that initiators do took a
>> lot of effort.
>>
>> Anyway, my feeling is that the integration of tcm_qla2xxx and qla2xxx
>> was overall a net negative.  Having the target driver grafted onto the
>> side of an already-complex driver that has a bunch of code not
>> relevant to the target (SCSI error handling, logging into and timing
>> out remote target ports, etc) made the code harder to debug and harder
>> to get right.
>>
>> Of course I'm in favor of making common code really common.  So
>> certainly we should have a common library of SLI-4 code that both the
>> initiator and target driver share.  And if there is more commonality,
>> that's great.  But any code similar to "if (initiator) ... else ..."
>> is really suspect to me - grepping for "qla_ini_mode_enabled" shows
>> great examples like
>>
>> ...
>>
>> Handling "dual mode" (both initiator and target on the same port at
>> the same time) is a design challenge, but I don't think the current
>> qla2xxx driver is an example of a maintainable way to do that.
>>
>> (I'm agnostic about what to do about SLI-3 - perhaps the cleanest
>> thing to do is split the driver between SLI-4 and SLI-3, and handle
>> the initiator and target drivers for those two cases as appropriate)
>>
>> I'd love to discuss this further and come up with a design that meets
>> the concerns about integration but also learns the lessons from
>> tcm_qla2xxx.
>>
>>   - R.
> 
> 
> Thanks for the feedback.  I believe you echo many of our concerns as we
> look at "merging them into one".  I agree with your statements on the
> number of if-else roles and know that we made this even more complicated
> by the driver doing fc-nvme initiator and fc-nvme target as well.  Your
> small list of "mode_enabled" hits pales in comparison to a hit list in
> the current driver if looking for SCSI initiator support
> (LPFC_ENABLE_FCP), NVME initiator support (LPFC_ENABLE_NVME), or NVME
> target support (phba->nvmet_support). And that's before adding SCSI
> target support.   We're also concerned about the discovery engines as
> not only are there lots of different paths for the different roles as
> well as support for fcoe, but there are a lot of carefully managed
> accommodations for various oem and switch environments. It's very
> difficult to replicate and retest all these different configurations and
> scenarios.
> 
> Here's what I'd like to propose for a direction:
> 1) Create an initiator driver and a target driver.  For now, initiator
> would support both SCSI and NVME initiator. Target would support SCSI
> and NVME target.
Well, _actually_ you only would need to move the NVMe target
functionality into a new driver...

> 2) SLI3 support would be contained only within the initiator driver and
> limited to SCSI (as it is today in lpfc).
> 3) SLI4 support would be library-ized,so that the code can be shared
> between the two drivers.  Library-izing SLI-4 means SLI-3 will also be
> library-ized.
> 4) Discovery support would be librarized so it can be shared. As part of
> this effort we will minimally move generic functions from the library to
> drivers/scsi/libfc (example: setting RPA payloads, etc).  At this time,
> the drivers will not attempt to use libfc for discovery. There is too
> much sensitive code tied to interlocks with adapter api design that are
> visible in the discovery state machine. Use of libfc can be a future,
> but for the short term, the goal is a single library for the broadcom
> initiator/target drivers.
> 5) lpfc will be refactored, addressing concerns that have been desired
> for a while.
> 
That all sound reasonable.

> 
> To start this effort, I'd like a bcmlpfc directory to be made within the
> drivers staging tree. The directory would be populated with the efct
> driver and a copy of the existing lpfc driver.   Work can then commence
> on refactoring lpfc and creating the libraries and integrating the
> libraries into both drivers.  As lpfc is updated in the main tree,
> patches would be posted to the staging version of lpfc to keep them on par.
> 
Ok.

> 
> Questions:
> a) How best to deal with overlapping pci id's ?  E.g. if we do (1) and
> we have an initiator and target driver, there is a lot of adapters that
> are fully functional for target operation, but were sold as primarily an
> initiator adapter. How could we manage target mode enablement without
> code mod or hard pci id partitioning ?   I know individual pci
> unbind/bind could work, but its been frowned upon as a long term option.
> Same thing goes for module parameters to select which ports do what role.
> 
That indeed is a problem.

Ideally we should be able to set the required mode on a per-port base;
having it per PCI device might be too coarse. Unless you represent each
port as a PCI function; not sure if that's the case, though.
If we were to allow to set the mode on a per-port base we could easily
implement kernel parameters like fctarget=WWPN and/or fcinitiator=WWPN;
NVMe could be treated similarly.
And have a config option specifying if the default FC mode should be
initiator or target.
With that we could configure the ports during boot-up and would avoid
the rebinding.

> b) Assuming we have the lpfc copy in the bcmlpfc directory in the
> staging tree: are there any issues with having a version of lpfc in the
> main tree and another in the staging tree ?     For many reasons, I'd
> like to keep the name lpfc on the initiator driver in the staging tree.
> But is that possible ? I assume we would need to develop in the staging
> tree as a new name and pci id space separate from the base driver, and
> we can rename the staging driver to the lpfc name when it merges into
> the main kernel and replaces the existing driver.
> 
Why not splitting the _existing_ lpfc driver along the above lines, and
keep the new target mode driver in staging?
That would be 'just' be a refactoring of the current lpfc driver, which
would be fully in keeping with the existing rules.
Hence I don't think that it would require to have the initiator driver
in staging, too.
And I do think that staging drivers can use library function from
'mainline' drivers.

Unless you want to go for a full split, and remove SLI-4 functionality
from the existing lpfc driver.
But then you'll be having a issue with driver renaming etc.
Not sure if I would want to go that route.

Cheers,

Hannes
