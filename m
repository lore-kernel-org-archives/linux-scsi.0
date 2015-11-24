From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] block: Add badblock management for gendisks
Date: Tue, 24 Nov 2015 13:31:58 -0800
Message-ID: <CAPcyv4g13_6mS5uApb+3QUaGEf8630Znv3sq-2WrGiK5fKBs8Q@mail.gmail.com>
References: <1448066960-20119-1-git-send-email-vishal.l.verma@intel.com>
	<1448066960-20119-3-git-send-email-vishal.l.verma@intel.com>
	<x49a8q32yxy.fsf@segfault.boston.devel.redhat.com>
	<1448391837.27481.16.camel@intel.com>
	<x498u5n1a7h.fsf@segfault.boston.devel.redhat.com>
	<1448395840.14996.8.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448395840.14996.8.camel@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "neilb@suse.com" <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 24, 2015 at 12:10 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Tue, 2015-11-24 at 14:14 -0500, Jeff Moyer wrote:
>>
>> I'm not sure whether it makes sense to continue without badblock
>> management for the RAID code.  I was hoping Neil would comment on
>> that.
>>
>> -Jeff
>
> Not sure I follow? I believe I've kept all the badblocks functionality
> RAID already had..
>
>
> On a related note, something I observed when testing with md:
>
> md's badblock list is per-device, and can be seen at:
>         /sys/block/md0/md/dev-pmem0/bad_blocks
>
> Now if we have badblocks in the gendisks too, there is also:
>         /sys/block/pmem0/bad_blocks
>
> The two are separate 'accounts' maintained by separate drivers (md for
> the former, and pmem for the latter). This can potentially be
> confusing..
>
> Should we consolidate the two, i.e. make md (re)use the gendisk
> badblocks for its purposes too?

If we get agreement that tracking bad blocks at the gendisk is useful
for more than just nvdimms then yes, I think it makes sense to move md
bad_blocks to the gendisk layer.  That is provided we can add a
symlink to make the move transparent to existing md userspace tooling.

The use cases I can envision being useful for other disks is:

1/ Bypassing / avoiding known bad blocks on disks / drivers that
inject long completion latency for error handling.

2/ Simulating bad blocks for disks that can't store them locally.
Similar to the md use case, if one encounters errors restoring a disk
image from a backup it's useful to have the option to record the error
in a bad block list and keep going.
