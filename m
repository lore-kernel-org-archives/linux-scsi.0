From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: deterministic scsi order with async scan
Date: Thu, 16 Jul 2009 22:53:46 +0300
Message-ID: <4A5F854A.7030101@panasas.com>
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933174AbZGPTxu@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0907161017180.9159@asgard>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/16/2009 08:22 PM, david@lang.hm wrote:
> On Thu, 16 Jul 2009, Boaz Harrosh wrote:
> 
>> On 07/16/2009 04:09 AM, david@lang.hm wrote:
>>> is there any way to get deterministic device ordering with scsi async
>>> scanning?
>>>
>>> currently (2.6.30) it seems that the various scsi busses are loaded in the
>>> order that they are detected, which can vary from boot to boot depending
>>> on how long it takes for the card to initialize.
>>>
>>> would it be possible to detect the cards/drives, but not register them
>>> until all the detection is complete so that they can be registered in a
>>> deterministic order?
>>>
>>> having two drives on two different controllers swap positions from boot to
>>> boot makes it very painful. yes I can make an initrd that fixes this up in
>>> user space by examining each drive and creating links to re-order them,
>>> but this is a lot of work to fix randomization that can be prevented in
>>> the first place.
>>>
>>> David Lang
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
> 
> for a laptop you areprobably correct, but for a server or embedded system 
> that doesn't have it's hardware changing all the time you are not correct.
> 
> especially on a system with lots of drives, why should I have to create an 
> initrd that goes and searches dozens or hundreds of drives to find out 
> which one to boot from?
> 

there is *no* searching with /dev/disk/by-id/ or /dev/disk/by-uuid/
Udev comes reads a small piece of information and puts up a link.

now: not(initrd+Udev) == Kernel_with_no_legs

> I am building a system that will have two drives in a hardware mirror on 
> one SCSI card, and 160 drives on a FC (SCSI) card. why should my boot have 
> to go and examine all 162 drives to look for an ID on every partition just 
> to find the boot drive?
> 

Again no searching is done here, just read of a sector for uuid and some
query command for by-id

>> I would say that "scsi async" is a grate blessing
> 
> it's great for startup time, but doing the async detection doesn't 
> _require_ doing async registration.
> 
> David Lang

Boaz
