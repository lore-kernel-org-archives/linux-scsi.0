From: Douglas Gilbert <dougg@torque.net>
Subject: Re: BSG question
Date: Thu, 16 Sep 2004 17:14:36 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41493D5C.9000700@torque.net>
References: <4148FC12.1010205@torque.net> <20040916060508.GF2300@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:51360 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267818AbUIPHPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 03:15:30 -0400
In-Reply-To: <20040916060508.GF2300@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, pjones@redhat.com

Jens Axboe wrote:
> On Thu, Sep 16 2004, Douglas Gilbert wrote:
> 
>>In the "[PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2"
>>thread Jeff Garzik wrote:
>>
>>
>>>* if the userland interface is 100% sending cdbs or taskfiles, then I
>>>would prefer that Jens Axboe's "bsg" be used.  Its a chardev interface
>>>for sending/receiving commands to a request queue.
>>
>>I played around with bsg
>>http://marc.theaimsgroup.com/?l=linux-scsi&m=109160967927030&w=2
>>about a month ago and it
>>looked good (and I would like sg to evolve in that
>>direction as well). My plan was to make a version of sg_dd
>>from sg3_utils use it. However since it was a patch it is hard
>>to keep in sync as kernel versions roll-out.
>>
>>Any chance of getting it into the main line kernel,
>>on the quiet? Failing that, a web site with up to date
>>patches.
> 
> 
> (you should cc the author when you ask questions about the patch :-)

I have cc-ed Peter Jones now.

> I'll try and set up a tree that gets regularly updated, if people are
> interested in it. Last time I basically came to the conclusion that bsg
> wasn't 'interesting enough'. SG_IO might not be a pretty interface (I
> mean the ioctl, not the sg_io_hdr structure), but as long as you don't
> require queueing or async io it works well enough. And that covers just
> about 99.5% of the use of sg.

It has another advantage. It allows device policy
(including error processing) to be decoupled from
the primary device interface. For example cdrecord
does not want to see EROFS (when it opens O_RDWR)
and does want to see all sense data back from the device **.

On the other hand there does seem to be a security issue
with bsg. Perhaps there could be a "non_root" sysfs attribute
(default 0, root only writable) on devices that bsg can
bind to. Then a bsg bind to a specific device needs
a user with CAP_SYS_RAWIO (or CAP_SYS_ADMIN) or the
device with non_root=1.

> Current tree is at 2.6.8-rc3-bk'ish, I'll post an update later today.

Good.

>>Various comments were made at the time
>>of its release that a more 64/32 bit friendly version
>>of struct sg_io_hdr was needed (this is for folks running
>>32 bits apps on a 64 bit architectures). As I pointed
>>out struct sg_io_hdr was written with alternate interfaces
>>in mind (i.e. its first field: 'int interface_id').
> 
> 
> Yes, we could add a sg v4 header that would work fine on 32-bit apps on
> 64-bit hosts.
> 
> 
>>bsg has one device node (i.e. "/dev/bsg") which users can
>>open and then bind/attach to an existing block device
>>node (e.g. /dev/sda). Extending this to bind to sysfs
>>device paths might be handy as well for
>>   - (SCSI) devices that have an unsupported peripheral device
>>      type (e.g. SES)
>>   - other devices (e.g. SMP port of an SAS expander)
> 
> 
> Yep. I suppose you would need a 'unknown' SCSI driver to attach
> unsupported peripherals to for that to work transparently.


** for example I noticed that sg gets to see Unit Attentions
but users of the block SG_IO don't (as the command is silently
retried clearing the Unit attention condition).

Doug Gilbert

