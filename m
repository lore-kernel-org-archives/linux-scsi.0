From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 16:51:12 +0100
Message-ID: <440865F0.1000500@s5r6.in-berlin.de>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com> <20060302231323.GA12869@us.ibm.com> <A421A6E6-A405-4DEC-847D-C5F33AA0718F@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:43021 "EHLO
	statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1751482AbWCCPve (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 10:51:34 -0500
In-Reply-To: <A421A6E6-A405-4DEC-847D-C5F33AA0718F@mac.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@mac.com>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

Mark Rustad wrote:
> On Mar 2, 2006, at 5:13 PM, Mike Anderson wrote:
>> James Bottomley <James.Bottomley@SteelEye.com> wrote:
>>> 1. Discovery order is non-deterministic (it starts one thread per  
>>> port, so the threads race for discovery)
>>
>> The issue also results in the device discovery not completing by  
>> the time the module load completes resulting in the initrd not
>> finding the boot disk
>> http://bugzilla.kernel.org/show_bug.cgi?id=6045
>>
>> I agree that we need a solution for this. Should the solution be in  
>> the LLDDs. I thought previous comments was that we wanted this fixed  
>> outside the kernel in user space. Though I have not seen any enabled  
>> support in initrds or support in the initrd bins.
>>
>> This appears to not only be an issue with aic94xx as it appears  
>> this could happen with some of the fc transport LLDDs.
> 
> It also is a problem for usb-storage devices. I have to use a kernel  
> parameter of "boot_delay=7" for my USB root device to be available.  
> Fine for my system, but ugly in general.

Same for SBP-2. This is old and has been solved before.

Neither attempts to enforce a specific order of device registering, nor
a delay of an module init routine in order to wait for completion of
device discovery is a proper solution. Let alone an empirically chosen
delay.

Create an initrd. Put the necessary hotplug infrastructure into the
initrd. This includes
 - reacting on device hotplugs,
 - mapping persistent unique device identifiers or unique partition
   identifiers to mount points,
i.e. basically everything which has to be done for hotpluggable devices.

(Put policy into userspace. Let the kernel provide mechanism only.)
-- 
Stefan Richter
-=====-=-==- --== ---==
http://arcgraph.de/sr/
