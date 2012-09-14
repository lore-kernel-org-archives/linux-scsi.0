From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Fri, 14 Sep 2012 16:48:31 +0800
Message-ID: <5052EF5F.3000103@intel.com>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>  <1347522049-1836-2-git-send-email-aaron.lu@intel.com>  <1347524092.2720.1.camel@dabdike.int.hansenpartnership.com>  <50519801.6080502@intel.com>  <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>  <50519E08.10800@intel.com>  <1347526590.2720.15.camel@dabdike.int.hansenpartnership.com>  <5051A25F.7040704@intel.com>  <1347528404.2720.28.camel@dabdike.int.hansenpartnership.com>  <20120914052041.GA5177@mint-spring.sh.intel.com> <1347610640.2794.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab2INIsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 04:48:46 -0400
In-Reply-To: <1347610640.2794.11.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org

On 09/14/2012 04:17 PM, James Bottomley wrote:
>> Just read the SPC-4 spec, in section 5.12.3, it has words like this:
>>
>> Logical units that contain cache memory shall write all cached data to
>> the medium for the logical unit(e.g., as a logical unit would do in
>> response to a SYNCHRONIZE CACHE command as described SBC-3) prior to
>> entering into any power condition that prevents accessing the
>> media(e.g., before a hard drive stops its spindle motor during a change
>> to the standby power condition).
>>
>> So this looks like cache needs to be synced before the device enter
>> standby/stopped power condition. Or do I miss somthing?
> 
> Um, no it says the device shall do the sync on its own (as though it
> received a sync cache).  That section says the device shall be
> responsible for cache management in the power states.

Oh, I thought it was the host software's responsibility, thanks for the
explanation.

So if we program the device to let it enter standby/stopped power
condition with the start_stop_unit command, do we need to sync the
cache?

Thanks,
Aaron
