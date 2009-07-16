From: James Smart <James.Smart@Emulex.Com>
Subject: Re: deterministic scsi order with async scan
Date: Thu, 16 Jul 2009 14:32:27 -0400
Message-ID: <4A5F723B.7070408@emulex.com>
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33595 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976AbZGPScm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 14:32:42 -0400
In-Reply-To: <alpine.DEB.1.10.0907161017180.9159@asgard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "david@lang.hm" <david@lang.hm>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



david@lang.hm wrote:
> On Thu, 16 Jul 2009, Boaz Harrosh wrote:
>
>   
>> It is highly discouraged to setup any kind of system that depends
>> on device-names for block-devices. mounts have the mount by-label
>> or mount by-uuid. Any other subsystem should go by /dev/disk/by-id/*
>> slinks to find a persistent raw block-device. the id is generated
>> from characteristics inside the disk itself so it will be the same
>> no matter what host connection or bus it is connected too (almost).
>>
>> This is because even if the boot order is consistent, the device-name
>> is so volatile in the life-span of a system. Did I boot with a removable
>> USB inserted. that camera or printer was on or off, disk was connected
>> to the other port. Any such change will break things and give you a very
>> poor user experience.
>>     
>
> for a laptop you areprobably correct, but for a server or embedded system 
> that doesn't have it's hardware changing all the time you are not correct.
>
> especially on a system with lots of drives, why should I have to create an 
> initrd that goes and searches dozens or hundreds of drives to find out 
> which one to boot from?
>   
Boaz is correct. Many enterprise SCSI subsystems (FC, SAS) do not have 
hard transport addresses for each device like Parallel SCSI used to.  
Thus, any difference in order of appearance of the devices (power-up 
ordering, FC ALPA assignment based on who's loop master, order that 
switch reports them, is an array in a failover mode with 1 controller 
non-existent), or if LUN configuration on an array changes, or as a 
drive may fail (especially with hundreds), there's no guarantee you will 
see the same thing in the same order w/o name binding. Same thing is 
true if one of those adapters fails or is swapped out.

> I am building a system that will have two drives in a hardware mirror on 
> one SCSI card, and 160 drives on a FC (SCSI) card. why should my boot have 
> to go and examine all 162 drives to look for an ID on every partition just 
>   
Because its the only safe way to ensure proper device identification.

-- james s
