From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg driver and Fedora Core 2
Date: Sun, 30 May 2004 20:37:14 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B9B95A.40304@torque.net>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave> <40B8C81E.3050106@pobox.com> <20040529172916.GD18613@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:28172 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261405AbUE3KiE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 06:38:04 -0400
In-Reply-To: <20040529172916.GD18613@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@redhat.com>, Arjan van de Ven <arjanv@redhat.com>

Jens Axboe wrote:
> On Sat, May 29 2004, Jeff Garzik wrote:
> 
>>Really what needs to happen is a generic userland tap attaches to a 
>>chrdev, issues an ioctl(2) to attach to a request_queue, and then does 
>>read(2)/write(2)/mmap(2) to communicate with the request_queue.
>>
>>:)
>>
>>Call it /dev/bsg, or somesuch.
>>
>>The SG_IO ioctl won't work for all cases, since some block devices may 
>>rightly wish to limit (or block) multiple openers on the blkdev itself. 
>>  OTOH, the SG_IO ioctl does eliminate the userland app needing to 
>>worry about _any_ target/addressing information, since that is implicit 
>>in the dentry pointing to the blkdev's inode.
> 
> 
> Hear, hear!

Jeff + Jens,
Yes, that is what I was getting at with my "bind"
idea. Could a "misc" char device minor number for
/dev/bsg be made available? It isn't clear to me how sysfs
can be used to do what Jeff proposes.


I have no expertise in Fibre Channel but Serial Attached SCSI
(SAS) throws up more addressing problems. There can be up to
16,000 devices in a single SAS domain the bulk of which would
be targets **, expanders which are the interesting ones, and
other initiators (potentially on other machines) will
also be visible. Those expanders are critical to
configuring the SAS domain. Expanders are SAS devices but
not SCSI devices (i.e. they are neither initiators nor
targets ***). It seems obvious that the management of a SAS
domain should be done from the user space. Only those
expanders and devices directly attached to a SAS Host Bus
Adapter should automatically be visible.

Enumerating all the disks, and/or all the scsi devices
(as either devices or sysfs entries) makes less and
less sense. In the case of SAS, devices can be discovered
by recursive descent of the expanders (via a bind through
/dev/bsg for example). In a large system one possible policy
could be: only if the user is interested in a
particular device should it be presented as a device
node (in /dev, /udev or /sys).


My recent patch to scsi_debug (adding up to 4 partitions per
pseudo device) "allows" (6 * 32768) device nodes to be
created! To play this game, turn off udev, hotplug and set
delay=0 in scsi_debug:-) I didn't get far with 512 MB of ram,
Patrick Mansfield got further with a multi gigabyte machine.
Seems like sysfs eats up most of the ram. To isolate out the
impact of the block subsystem the pseudo devices can be set to
be enclosure peripheral type (for example) via a scsi_debug
driver argument.


** targets include both SATA and SAS disks

*** show should SAS expanders go in /sys/class/scsi_device ?

Doug Gilbert

