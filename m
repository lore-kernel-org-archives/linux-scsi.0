From: Douglas Gilbert <dougg@torque.net>
Subject: Re: NAA identifiers with scsi_id
Date: Wed, 16 Jun 2004 14:59:12 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CFD3A0.60708@torque.net>
References: <40CF0A29.2010308@suse.de> <20040615145421.A23070@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:5907 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S266168AbUFPFAo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 01:00:44 -0400
In-Reply-To: <20040615145421.A23070@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, hotplug <linux-hotplug-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Hannes -
> 
> On Tue, Jun 15, 2004 at 04:39:37PM +0200, Hannes Reinecke wrote:
> 
>>Hi all,
>>
>>having checked scsi_id, I found out that it will always prefer NAA ids 
>>in favour of any other types (EUI-64 et.al.).
>>
>>This is not very helpful if scsi_id is used to generate meaningful 
>>persistent driver ids, as the user might want to check the links created 
>>by udev against the device list presented by the system (e.g. via 
>>'dmesg' or 'cat /proc/scsi/scsi' or even by scanning sysfs).
>>
>>Can't we just ignore NAA ids and fall back to page 0x80 + inquiry if 
>>these are all we will get via page 0x83? Just having an arbitrary number 
>>is not very helpful and totally intransparent to the user.
> 
> 
> No.
> 
> Some reasons we should not do this:
> 
> 1) No matter what page or method we use there is a rather arbitrary number,
> it is just that for page 0x80 or a page 0x83 vendor specific id, scsi_id
> prepends the vendor and model before the id, this is done to ensure the
> value is unique across all vendors and models, not so users can more
> easily match an id to an actual device.
> 
> Some (well not your standard desktop pc) systems will be connected to
> multiple LUNs that all have the same vendor and model, and having the
> vendor model pre-pended does not make finding them any easier.
> 
> 
> 2) a device might support only page 0x83 NAA, so falling back to page
> 0x80 could give nothing.

Recent SPC-3 drafts have marked support for the Device
Identification VPD page (i.e. 0x83) in INQUIRY as mandatory
while support for the serial number VPD page (0x80) is still
optional.

The allocation length (of the response) of an INQUIRY has
been expanded from 1 to 2 bytes. This, no doubt, is to
cope with large responses associated with VPD page 0x83.

I am in the process of adding 0x83 VPD page
support to sg_inq (in sg3_utils) to decode its
multiple descriptors.

<snip/>

Doug Gilbert
