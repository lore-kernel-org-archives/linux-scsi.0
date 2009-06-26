From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules automatically
 inserted
Date: Fri, 26 Jun 2009 09:56:10 -0400
Message-ID: <4A44D37A.10903@redhat.com>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>	 <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site> <4A3BDFE8.3090003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58202 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZFZN4R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jun 2009 09:56:17 -0400
In-Reply-To: <4A3BDFE8.3090003@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

James, I think Chandra and I have responded to most if not all of your points, 
and would appreciate your thoughts on what we've said.

Peter Jones wrote:
> On 06/18/2009 06:48 PM, James Bottomley wrote:
>> On Mon, 2009-06-15 at 14:29 -0400, Peter Jones wrote:
>>> On 04/27/2009 02:06 PM, Chandra Seetharaman wrote:
>>>> Hello,
>>>>
>>>> Currently, SCSI targets doesn't have modalias support. It wasn't an issue
>>>> until SCSI device handler came along.
>>>>
>>>> We want the SCSI device handler modules to be insmodded automatically
>>>> when the specific SCSI targets are probed and found.
>>>>
>>>> This set of patches adds the modalias support for SCSI targets and
>>>> also makes the relevant changes to SCSI device handler modules to 
>>>> make use of it.
>>>>
>>>> Applies cleanly on 2.6.30-rc3 and is tested on the same.
>>>>
>>>> Please review and consider this for inclusion.
>>>>
>>>> Originally sent on March 17 2009 (http://marc.info/?l=linux-scsi&m=123734001009654&w=2).
>>>>
>>>> Resending after testing on 2.6.30-rc3 and with an ack from Hannes.
>>> Was there ever any followup to this?
>> OK, since I've forgotten where we are, let me summarise what I think the
>> situation is (correct me if I misstate any of the facts):
>>
>> This code adds no functional value to the kernel because dm already
>> autoloads the correct handlers based on the inquiry strings
> 
> I don't agree here.  It adds functional value to the entire system by making the
> loading of device drivers use the same method no matter which kernel subsystem
> the driver is part of.  This is a very tangible benefit in terms of maintainability.
> 
>> The only value it adds is that by overloading the module table with the
>> inquiry strings, mkinitrd pulls in the correct dm handlers for the state
>> the system was in.
> 
> You keep on saying this, and to me it seems very strange.  The patch does no
> "overloading" of vendor strings -- it uses them just like the PCI vendor/device ID or
> USB idVendor/idDevice.  Fundamentally they are the same thing: an identifier to
> tell us what device we're looking at.  There's no overloading here, it's just
> hooking them up to the kernel's generalized mechanism for loading modules based on
> this kind of data.
> 
>> the unaddressed problems are:
>>
>> The kernel now tries to load the dm handler for the device dynamically
>> whether or not the user is actually deploying multi-path (previously dm
>> does this and if it's not loaded, that doesn't happen).  It's entirely
>> unclear whether this would interfere with proprietary multipath handlers
>> or even cause problems in single path systems which were designed that
>> way.
> 
> I just don't see how this is a real concern -- the whole point of the drivers
> which we're autoloading here is to work with specific hardware that's designed to
> work in this fashion.  What's more, if that hardware is being used for single-path,
> and the driver is loaded and it decides to reconfigure to prefer a path that's not
> plugged in, surely that's a bug in the device handler driver, and should be fixed
> there, rather than blocking the auto-loading of such drivers?
> 


-- 
   Peter
