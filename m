From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/3] block: Add badblock management for gendisks
Date: Tue, 24 Nov 2015 14:14:26 -0500
Message-ID: <x498u5n1a7h.fsf@segfault.boston.devel.redhat.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
	<1448066960-20119-3-git-send-email-vishal.l.verma@intel.com>
	<x49a8q32yxy.fsf@segfault.boston.devel.redhat.com>
	<1448391837.27481.16.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448391837.27481.16.camel@intel.com> (Vishal L. Verma's message
	of "Tue, 24 Nov 2015 19:03:57 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>
List-Id: linux-scsi@vger.kernel.org

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Tue, 2015-11-24 at 10:34 -0500, Jeff Moyer wrote:
>> Vishal Verma <vishal.l.verma@intel.com> writes:
>> 
>> > NVDIMM devices, which can behave more like DRAM rather than block
>> > devices, may develop bad cache lines, or 'poison'. A block device
>> > exposed by the pmem driver can then consume poison via a read (or
>> > write), and cause a machine check. On platforms without machine
>> > check recovery features, this would mean a crash.
>> > 
>> > The block device maintaining a runtime list of all known sectors
>> > that
>> > have poison can directly avoid this, and also provide a path forward
>> > to enable proper handling/recovery for DAX faults on such a device.
>> > 
>> > Use the new badblock management interfaces to add a badblocks list
>> > to
>> > gendisks.
>> 
>> Because disk_alloc_badblocks can fail, you need to check for a NULL
>> disk->bb in all of the utility functions you've defined.
>> 
>
> Thanks, Jeff - I'll fix this. I have a handful of other fixes queued up
> too, will send out a v2 soon.

I'm not sure whether it makes sense to continue without badblock
management for the RAID code.  I was hoping Neil would comment on that.

-Jeff
