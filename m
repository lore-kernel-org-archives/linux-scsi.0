From: Douglas Gilbert <dougg@torque.net>
Subject: BSG question
Date: Thu, 16 Sep 2004 12:36:02 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4148FC12.1010205@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:53397 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S266790AbUIPCg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 22:36:58 -0400
Received: from [192.168.48.80] (dsl-175.131.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.131.175])
	by borg.st.net.au (Postfix) with ESMTP id A99603944F6
	for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2004 12:36:50 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

In the "[PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2"
thread Jeff Garzik wrote:

 > * if the userland interface is 100% sending cdbs or taskfiles, then I
 > would prefer that Jens Axboe's "bsg" be used.  Its a chardev interface
 > for sending/receiving commands to a request queue.

I played around with bsg
http://marc.theaimsgroup.com/?l=linux-scsi&m=109160967927030&w=2
about a month ago and it
looked good (and I would like sg to evolve in that
direction as well). My plan was to make a version of sg_dd
from sg3_utils use it. However since it was a patch it is hard
to keep in sync as kernel versions roll-out.

Any chance of getting it into the main line kernel,
on the quiet? Failing that, a web site with up to date
patches.

Various comments were made at the time
of its release that a more 64/32 bit friendly version
of struct sg_io_hdr was needed (this is for folks running
32 bits apps on a 64 bit architectures). As I pointed
out struct sg_io_hdr was written with alternate interfaces
in mind (i.e. its first field: 'int interface_id').

bsg has one device node (i.e. "/dev/bsg") which users can
open and then bind/attach to an existing block device
node (e.g. /dev/sda). Extending this to bind to sysfs
device paths might be handy as well for
    - (SCSI) devices that have an unsupported peripheral device
       type (e.g. SES)
    - other devices (e.g. SMP port of an SAS expander)


Doug Gilbert
