From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH 1/2] brd: Fix the partitions BUG
Date: Wed, 30 Jul 2014 21:37:33 +0300
Message-ID: <53D93B6D.7080609@gmail.com>
References: <53D7CDDD.1000302@gmail.com>	 <1406654379.2767.1.camel@rzwisler-mobl1.amr.corp.intel.com>	 <53D8D2C4.1030101@gmail.com> <53D8FE1F.1060009@plexistor.com> <1406739017.2767.9.camel@rzwisler-mobl1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44147 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbaG3Shj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2014 14:37:39 -0400
In-Reply-To: <1406739017.2767.9.camel@rzwisler-mobl1.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Nick Piggin <npiggin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>

On 07/30/2014 07:50 PM, Ross Zwisler wrote:
<>
>> +	 */
>> +	printk(KERN_EROR "brd: brd_find unexpected device %d\n", i);
> 
> s/KERN_EROR/KERN_ERR/
> 

Yes thanks, sigh, code should compile

driver error. I used pr_err but last inspection I saw that printk is used
everywhere and, crapped ...

>> +	return NULL;
>>  }
>>  
>>  static void brd_del_one(struct brd_device *brd)
>> @@ -554,11 +552,10 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
>>  	struct kobject *kobj;
>>  
>>  	mutex_lock(&brd_devices_mutex);
>> -	brd = brd_init_one(MINOR(dev) >> part_shift);
>> +	brd = brd_find(MINOR(dev) >> part_shift);
>>  	kobj = brd ? get_disk(brd->brd_disk) : NULL;
>>  	mutex_unlock(&brd_devices_mutex);
>>  
>> -	*part = 0;
>>  	return kobj;
>>  }
> 
> It is possible to create new block devices with BRD at runtime:
> 
> 	# mknod /dev/new_brd b 1 4 
> 	# fdisk -l /dev/new_brd
> 
> This causes a new BRD disk to be created, and hits your error case:
> 
> 	Jul 30 10:40:57 alara kernel: brd: brd_find unexpected device 4
> 	

Ha OK, So this is the mystery key. I never knew that trick, OK
I guess I need to leave this in

> I guess in general I'm not saying that BRD needs to have partitions - indeed
> it may not give you much in the way of added functionality.  As the code
> currently stands partitions aren't surfaced anyway
> (GENHD_FL_SUPPRESS_PARTITION_INFO is set).  For PRD, however, I *do* want to
> enable partitions correctly because eventually I'd like to enhance PRD so that
> it *does* actually handle NVDIMMs correctly, and for that partitions do make
> sense.  

So lets talk about that for a bit. Why would you want legacy partitions for
NVDIMMs. For one fdisk will waste 1M of memory on this. And with NVDIMMs you
actually need a different manager all together, more like lvm stuff.

I have patches here that changes prd a lot.
- Global memory parameters are gone each device remaps and operates on it's own memory range.
- the prd_params are gone instead you have one memmap= parameter of the form
  memmap=nnn$ooo,[nnn$ooo]...
  where:
	nnn - is size in bytes of the form number[K/M/G]
	ooo - is offset in bytes of the form number[K/M/G]

  Very much the same as the memmap= Kernel parameters. So just copy/paste what
  you did there and it will work.

  Now each memory range has one prd_device created for it. Note that if
  specified ranges are just contiguous then it is like your prd_count thing where
  you took a contiguous range and sliced it up, only here they can be of
  different size.
  Off course it has an added fixture of dis-contiguous ranges like we have
  in our multy-nodes NUMA system in the lab that host DDR3 NvDIMMs in two
  banks.

- A sysfs interface is added to add/remove memory range on the fly like
  osdblk

- If no parameters are specified at all, the Kernel command-line is parsed
  and all memmap= sections are attempted and used if are not already claimed.

An interface like mknod above is not supported since it is actually pointless.

My current code still supports partitions but I still think it is silly.

[
 This is all speculative for DDR3-NVDIMMs, we have seen that the memory controller
 actually tags these DIMMs with type 12 but it looks like this is all vendor
 specific right now and I understand that DDR4 standardize all that. So I was
 hoping you guys are working on all that with the NvDIMM stuff.

 Now lets say that I have established auto-detection for each DIMM and have
 extracted its SN (Our DDR3 DIMMs each have an SN that can be displayed by the
 vendor supplied tool)

 An NvDIMM manager will need to establish an NvDIMM table and set order.
 The motivation of a partition table is that a disk moved to another machine
 and/or booted into another OS will have persistent and STD way to not
 clobber over established DATA. But here we have like a disk cluster/raid,
 an ordered set of drives.

 Unique to NvDIMMs is the interleaving. If pairs are then inserted in wrong
 order or are re-mixed. This should be detected and refused to be mounted
 (unless a re-initialize is forced) So data is not silently lost on operator
 errors.
 
 All this is then persisted on some DIMM, first or last. If code is able to
 re-arrange order, like when physical address have changed it will, but in the
 wrong interleaving case it will refuse to mount.
]

> And if I have to implement and debug partitions for PRD, it's easy to
> stick them in BRD in case anyone wants to use them.
> 

I was finally playing with BRD, and it is missing your getgeo patch, so
it is currently completely alien to fdisk and partitions.

So why, why keep a fixture that never existed, I still hope to convince you
that this is crap. Specially with brd that can have devices added on the fly
like you showed above. Who needs them at all? Why waist 1M of memory
on each device for no extra gain?

Specially in light of my new prd that does away of any needs of a partitioning
since it supports arbitrary slicing in another way.

> - Ross

I will send a new set of patches for brd tomorrow. If we want, really want,
NEW SUPPORT for partitions, we need 2 more patch.
  But PLEASE consider just removing this dead never used crap. If you agree
  I will send a cleaning patch ASAP.

Also I will send as RFC my prd patches if you want to see, it has some
nice surprises in them that I hope you will like ;-)

Cheers
Boaz

