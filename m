From: david@lang.hm
Subject: Re: deterministic scsi order with async scan
Date: Thu, 16 Jul 2009 11:43:55 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0907161143010.9159@asgard>
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard> <4A5F723B.7070408@emulex.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:37131 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920AbZGPSoH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 14:44:07 -0400
In-Reply-To: <4A5F723B.7070408@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 16 Jul 2009, James Smart wrote:

> david@lang.hm wrote:
>> On Thu, 16 Jul 2009, Boaz Harrosh wrote:
>>
>> 
>>> It is highly discouraged to setup any kind of system that depends
>>> on device-names for block-devices. mounts have the mount by-label
>>> or mount by-uuid. Any other subsystem should go by /dev/disk/by-id/*
>>> slinks to find a persistent raw block-device. the id is generated
>>> from characteristics inside the disk itself so it will be the same
>>> no matter what host connection or bus it is connected too (almost).
>>> 
>>> This is because even if the boot order is consistent, the device-name
>>> is so volatile in the life-span of a system. Did I boot with a removable
>>> USB inserted. that camera or printer was on or off, disk was connected
>>> to the other port. Any such change will break things and give you a very
>>> poor user experience.
>>> 
>> 
>> for a laptop you areprobably correct, but for a server or embedded system 
>> that doesn't have it's hardware changing all the time you are not correct.
>> 
>> especially on a system with lots of drives, why should I have to create an 
>> initrd that goes and searches dozens or hundreds of drives to find out 
>> which one to boot from?
>> 
> Boaz is correct. Many enterprise SCSI subsystems (FC, SAS) do not have hard 
> transport addresses for each device like Parallel SCSI used to.  Thus, any 
> difference in order of appearance of the devices (power-up ordering, FC ALPA 
> assignment based on who's loop master, order that switch reports them, is an 
> array in a failover mode with 1 controller non-existent), or if LUN 
> configuration on an array changes, or as a drive may fail (especially with 
> hundreds), there's no guarantee you will see the same thing in the same order 
> w/o name binding. Same thing is true if one of those adapters fails or is 
> swapped out.

yes, but does your system change the order of your internal direct 
attached drives with your FC/SAN drives?

David Lang

>> I am building a system that will have two drives in a hardware mirror on 
>> one SCSI card, and 160 drives on a FC (SCSI) card. why should my boot have 
>> to go and examine all 162 drives to look for an ID on every partition just 
> Because its the only safe way to ensure proper device identification.
>
> -- james s
>
