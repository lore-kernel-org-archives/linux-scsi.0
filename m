From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi sysfs update (scsi_debug 3/3)
Date: Fri, 08 Nov 2002 10:35:06 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCAF8AA.4050701@torque.net>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107074222.GC1390@beaverton.ibm.com> <20021107183042.C15350@sgi.com> <20021107163348.GC1292@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@sgi.com>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Christoph Hellwig [hch@sgi.com] wrote:
> 
>>On Wed, Nov 06, 2002 at 11:42:22PM -0800, Mike Anderson wrote:
>>
>>>-#define DRIVERFS_SUPPORT 1	/* comment out whole line to disable */
>>>+#define SYSFS_SUPPORT 1 /* comment out whole line to disable */
>>>+#define SYSFS_PROBE 1  /* comment out whole line to disable */
>>
>>Do we really want ifdefs for this?  And if yes why aren't they config
>>options?
> 
> 
> I was trying to follow Douglas's previous form in his driver. It could
> be changed to a config option if Douglas is ok with that.

Mike,
I think it is fine to drop those conditional compiles now.
The 2.4 and 2.5 scsi_debug drivers are now significantly
different beasts.



Further to Christoph's "registering individual hosts" patch
for LLDDs, I would like to change scsi_debug thus:

   if scsi_debug_num_devs == 0
     then don't make any hosts   // await later "add_host"
   else
      make one host and build devices until
         either num_devs is exhausted or mid level stops

Add a writeable (via sysfs) "add_host" parameter. Examples:
    cd /sysfs/bus/scsi/drivers/scsi_debug/
    echo 1 > add_host // add 1 host
    echo 2 > add_host // add 2 hosts
    echo -1 > add_host // remove 1 host (last one)
then build (or remove) devices until either num_devs is
exhausted or mid level stops. This should allow folks
to simulate scsi (pseudo) host hotplugging.
Simulating large banks of scsi devices could then be
done like this:
   modprobe scsi_debug scsi_debug_num_devs=300 \
                       scsi_debug_max_luns=4 \
                       scsi_debug_add_hosts=10
With the current scsi_scan this would result in 10 hosts
each with 7 target ids (0..6) each with 4 luns (0..3)
for a total of 280 devices. [The scsi_debug drivers would
be left with 20 unused slots for further devices.]

BTW Is the 256 minors limit history yet in 2.5?


Whither sg?? Well it has been my intention to put
a functionally stripped down version of the sg_io_hdr
interface in a mid level ioctl. It could overlay the
current SCSI_IOCTL_SEND_COMMAND or be a new ioctl
number. For anyone who has used the existing
SCSI_IOCTL_SEND_COMMAND interface they will be aware
that it is dreadful (making sg_header look good :-) ).
However from an application point of view you are
still going to have sd, sr or st in the way of what
you are really trying to do. Then there are the odd
ball devices: this week I came across a SCSI printer
type device for the first time. It's a modern device
build to hide its true purpose from OSes!

Rather than a free standing upper level device, sg
could be seen as an adjunct to the mid level. There is
no need to probe sg to find out whether it is interested
in a newly attach scsi device - by definition it is
(unless it has run out of resources).

Doug Gilbert



