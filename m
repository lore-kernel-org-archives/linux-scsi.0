From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH] ses: Handle non-unique element descriptors
Date: Mon, 11 Jul 2011 15:54:14 +0530
Message-ID: <4E1ACF4E.2010307@suse.de>
References: <4E11D946.4050307@suse.de> <1309793724.2606.19.camel@mulgrave>	 <4E1245DF.5000403@suse.de> <1309820435.2606.43.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab1GKKWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2011 06:22:21 -0400
In-Reply-To: <1309820435.2606.43.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 07/05/2011 04:30 AM, James Bottomley wrote:
> On Tue, 2011-07-05 at 04:29 +0530, Ankit Jain wrote:
>> On 07/04/2011 09:05 PM, James Bottomley wrote:
>>> On Mon, 2011-07-04 at 20:46 +0530, Ankit Jain wrote:
>>>> Some SES devices give non-unique Element Descriptors as part of the
>>>> Element Descriptor diag page. Since we use these for creating sysfs
>>>> entries, they need to be unique.
>>>>
>>>> Eg:
>>>> $ sg_ses -p 7 /dev/sg0
>>>>   FTS CORP  TXS6_SAS20BPX12   0500
>>>>     enclosure services device
>>>> Element descriptor In diagnostic page:
>>>>   generation code: 0x0
>>>>   element descriptor by type list
>>>>     Element type: Array device, subenclosure id: 0
>>>>       Overall descriptor: ArrayDevicesInSubEnclsr0
>>>>       Element 1 descriptor: ArrayDevice00
>>>>       Element 2 descriptor: ArrayDevice01
>>>>       Element 3 descriptor: ArrayDevice02
>>>>       Element 4 descriptor: ArrayDevice03
>>>>       Element 5 descriptor: ArrayDevice03
>>>>       Element 6 descriptor: ArrayDevice03
>>>>       Element 7 descriptor: ArrayDevice03
>>>>       Element 8 descriptor: ArrayDevice03
>>>>       Element 9 descriptor: ArrayDevice03
>>>>       Element 10 descriptor: ArrayDevice03
>>>>       Element 11 descriptor: ArrayDevice03
>>>>       Element 12 descriptor: ArrayDevice03
>>>
>>> What is the external visible labelling of this topology?  It's
>>> completely weird that the enclosure would burn in non-unique names
>>> unless there's some reason for it.
>>
>> I'm not sure what you mean by "external visible labelling". The system has a
>> SAS expanded backplane. I don't have access to the hardware now, but p7 looked
>> like this:
> 
> The element descriptors usually correspond with labelling on the case of
> whatever it is the enclosure is embedded in. Their job is to describe
> the location of the device, so they usually get burned in with whatever
> the default labelling scheme for the physical device is.  So what I want
> to know is what is the labelling scheme in this case?

I don't have direct access to the box, so I asked the person who does,
and he says: "the labelling is just 1-12 unless I'm mistaken.".

The duplicate descriptors is a firmware bug, but since the specification
doesn't say that these have to be unique, we should handle these, IMHO.

-- 
Ankit Jain
SUSE Labs
