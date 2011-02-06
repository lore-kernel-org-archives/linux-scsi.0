From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [LSF/MM TOPIC] [ATTEND] A new layout based, unified mirrors/stripping/raid[456],
 raid groups, and more, block device.
Date: Sun, 06 Feb 2011 18:21:30 +0200
Message-ID: <4D4ECA8A.3050601@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: lsf-pc@lists.linuxfoundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>, Brent Welch <bwelch@pana>
List-Id: linux-scsi@vger.kernel.org

I'm just in the process of finishing up a new mirror/striping/raid/groups engine for the object
based file system and pnfs-objects projects.

The code library is a small 1700 lines of code (2 files) that implements a general raid engine
given a layout. It supports all the raid and mirroring modes in all the current drivers
combined, and currently up to 3 levels of stacking. (See fixture list below).

The Upper and lower level APIs are all bio based and it is all based on copy-less IO.
The striping and mirroring info are not copied, just the pages are rearranged to split
to the different devices.

It is now implemented over the objects API, but if needed, a very small (50 lines of code)
shim could turn that into a block based raid engine over regular fs type block requests.
It will need a new block device for instance the osdblk driver could be used for that
purpose.

(I'm just now in the process of finishing up the first RFC patches, but since the LSF
 deadline is today I'm sending this RFD before hand)

I would like to say that the current layout design is based on the pnfs-objects layout
standard. But a more general recursive layout could be implemented just as well. (It was
talked about in the early stages of the pnfs STD of a recursive multi-layer STD but it
was dropped for simplicity's sake)

The current layout is built as follows:

[layout]
stripe_unit - Number of bytes per logical raid unit.
              (Bytes belong to the same device before moving to the next one)
mirror_count - the number of mirror devices. Mirroring is the inner most layer and can
               be stacked upon by all the raid modes.
raid_type    - Currently defined: Raid0, Raid4, Raid5, Raid_pq_norotate, Raid_pq_rotate
               (Note that raid 1 10 50 & 60 are just a combination of this plus the
                mirror_count)
group_width - total number of devices to stripe/raid over.
parity_count- number of devices of parity, out of the group. Currently only 0,1,2 are
              supported but this is only do to the limitations of the async_tx library.
              Any number of "parity_count < group_width/2" should be possible.
group_depth - Number of stripes that belong to the same group before advancing to the next
              group of devices.
group_count - Number of different groups until the pattern repeats.
              "Groups" is a grate concept when few devices are enough to saturate your link
              like 3 in a 1Gg Ethernet or 30 in a 10Gg. But when you want to scale to 100ds
              or even thousands of devices. Also when you have switch-able fabrics then
              you can reach higher then link speed by having many more pairs of devices talking
              in parallel.
              Grouping can be looked at as big-chunk striping over, what ever is on the lower
              layer.
device_array - List of devices to use.
               The number of devices in the system is mirror_count * group_width * group_count.

We can see that all the possible combinations are supported, for example 1, 4, 5, 6, 10, 50, 60
and much more are possible with same small code.

The low Level API for writes is as below: (Imagine that the "osd" is considered more abstract)

1]	osd_start_request(struct osd_dev *dev, gfp_t gfp);

osd_dev is just an abstract handle that has meaning at the implementor. It's only member is
a block request_queue. Because all bios per device will be associated to this queue.

2]	osd_req_write(struct osd_request *or,const struct osd_obj_id *obj, u64 offset,struct bio *bio, u64 len)

@or is what was returned from osd_start_request.
@obj Will not be used by the block device
@offset, to write to
@bio - the pages to write
@len is passed because we support chain of bios.

3] 	osd_execute_request_async(or, callback, ...)
4]	osd_end_request(or)

So we'll need to write a small plugin that will abstract the above API over the regular fs_pc
block requests.

We can even do much more. a device above or even the object_id could be used for abstracting
different regions of the flat array. and in concert with the filesystem Different regions
could be used with different layouts. For example directories/small-files are best deployed
as mirrors, big files as raid5/6. So regions with different layout could be devised. Since
all you need is pass a different layout to the raid engine this could be done easily at
run time, with no extra code. (Just a sound policy in mind). All the filesystem needs is
to specify these files to the different regions.

The read API is a bit more complex because it has the notion of on disk extent-list, because
osd supports it and the raid5/6 likes to jump over the parity units, it sends a single long
extent based list to read, though in raid5/6 reaching an effective striping of group_width
instead of just group_width-parity in writes. But the list comes ordered and should be easy
to just split it up, or read in the stripe_unit and discard it depending on size and link
speed.
(The osd API is much richer then just read/write but the raid engine only uses these
two.)

The only missing part is multi-path which should be just the same as today using the
device handler abstracted as a single device for the raid engine.

Conclusion
The raid engine as described above, subject to review and fixes, should be accepted
into some future Kernel. The inquiry here is: Will it also be interesting as a block
device for local filesystems to use. Given all the new possibilities and small code
size compared to all those other devices it obsoletes.
Also will it be interesting as a library for other projects, like btrfs, scsi-target,
drbd, network filesystems ...?

Thanks
Boaz
