From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Wed, 14 May 2008 10:39:44 -0400
Message-ID: <482AF9B0.7090307@emulex.com>
References: <1210700704.16304.1.camel@localhost.localdomain> <482A87EF.4010002@suse.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39248 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYENOjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2008 10:39:48 -0400
In-Reply-To: <482A87EF.4010002@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org



Hannes Reinecke wrote:
>> This patch was cut against scsi-misc-2.6, and depends on Mike 
>> Christies patches
>> contained in the original thread.
>>
> Hmph.
> 
> I don't quite agree with this one.
> For once, /proc/scsi/scsi has been marked as 'obsolete' for quite some 
> time now,
> so adding other usages to this is of questionable value.

Um... I didn't think I added a new use for it.  The existing data had to
be extended by an additional argument.

> 
> And we've actually have a similar issue when developing the SCSI 
> device_handler
> stuff where we also have a device list to maintain.
> 
> Seeing there is quite some overlap between those two cases I think we 
> should
> come up with a way of handling these things properly, ie tied into sysfs.

Ok - but I see it as a two part process. I am not signing up for replacing
the device list infrastructure.  But, now that there is target queue depth
management in the midlayer, I believe we should be taking advantage of it.
I'd rather see the additional field go in, then see a separate effort to
replace/collapse the device lists...

> So, what we should do here is
> a) add a 'can_queue' sysfs attribute to the starget (which we can 
> nowadays, as
>   the starget is a proper sysfs object)

Um, it exists under the /sys/devices tree (the base object) but there is no
class representation. Are you requesting this goes on the base object ?
I thought we avoided this. I guess it can, but as it's scsi-ish, I would
think it more appropriate to formally create a scsi_target class and put
scsi attributes there.  (but I was avoiding that too)

> b) define a 'modalias' style definition for matching SCSI vendor/model/rev
>   and create a scsi_devinfo module from which all these special cases
>   can be invoked from.
> 
> That would also allow us to get rid of the device tables in the 
> device_handler
> modules which I never really liked.
> 
> What do you think?

see above.

-- james s

> 
> Cheers,
> 
> Hannes
