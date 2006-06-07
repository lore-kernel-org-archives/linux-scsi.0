From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 0/6] libata: Support SATA attached via SAS
Date: Wed, 07 Jun 2006 12:56:47 -0500
Message-ID: <4487135F.3050908@us.ibm.com>
References: <4486FDBD.9030200@us.ibm.com> <4487084E.7090307@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42124 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750993AbWFGR4x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2006 13:56:53 -0400
In-Reply-To: <4487084E.7090307@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: jgarzik@pobox.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Douglas Gilbert wrote:
> Brian King wrote:
>> Jeff,
>>
>> Here is a refresh of my patchset to allow SAS HBAs to use libata to
>> control attached SATA devices. It should apply cleanly to #upstream.
>>
>> James,
>>
>> After our discussion at the storage summit I think I have
>> a better idea what you are looking for with a SATA transport class.
>> Unfortunately, the problem I am facing is that I am dealing with a
>> firmware stack (ipr) which does not expose the physical transport
>> to the host. The ipr firmware does all the device discovery and reports
>> a configuration table describing the attached devices, but does not
>> export any physical topology information. At some point in the future
>> I hope to be able to extract this information from the ipr firmware
>> stack and convert ipr to be able to utilize the sas/sata transport class,
>> but, unfortunately, the firmware interfaces to accomplish this
>> aren't available at this time.
> 
> Brian,
> Does that mean that it doesn't have an SMP pass through?
> SMP and the SAS addresses attached to the phys on the HBA
> is enough to do discovery in the user space.

Doug,

That is correct. There is no SMP passthru interface. The interface I
am working with basically gives me some very basic information
regarding all attached end devices (which does not include SMP devices).
The information I get for each device includes: 

1. The LUN's SAS address
2. The type of device to aid in HLDD attachment. This could be either
   a SAS device, a SATA device, or a RAID logical device.
3. A bus/target/lun tuple which can be used to map into SPI if the
   host dd wants to. 

If you look in drivers/scsi/ipr.h at struct ipr_config_table_entry,
that might give you a better idea as to what I get back for each
device.

In a future firmware release I should have the firmware interfaces
I need to be able to extract both adapter SAS/SATA phy information
and SAS expander information such that I can move ipr to fit
into the sas transport model. Unfortunately, I don't have this
today.


Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
