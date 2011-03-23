From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: sr driver fails to update inode size after media change
Date: Wed, 23 Mar 2011 10:49:11 +0000
Message-ID: <20110323104911.GA18422@stefanha-thinkpad.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:46120 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab1CWKti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 06:49:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Amit Shah <amit.shah@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.orglinu

Hi,
Both 2.6.38 and older kernels do not update the CD-ROM block device
inode's size after media change.  If one process holds a file descriptor
to the device across media change, then all other processes on the
system will read the outdated size when they use lseek(2) even if they
opened the device after media change.

The reason for this is that although the sysfs size attribute is
up-to-date, the inode size is never updated by the sr driver or the
universal cdrom driver.

Here is an example.  There is a medium inserted:
$ cat /sys/block/sr0/size
7656192

Now let's start a process that keeps the file descriptor open:
$ python
1>>> import os
1>>> fd = os.open('/dev/sr0', os.O_RDONLY | os.O_NONBLOCK)
1>>> os.lseek(fd, 0, 2) / 512
7656192

Now change the medium and check what sysfs says after hald/udisks has
polled:
$ cat /sys/block/sr0/size
15120512

Okay, the size has been updated in sysfs.  The python process still has
a file descriptor to the device open.  Let's start a new process and see
what lseek(2) says:
$ python
2>>> import os
2>>> fd = os.open('/dev/sr0', os.O_RDONLY | os.O_NONBLOCK)
2>>> os.lseek(fd, 0, 2) / 512
7656192
2>>> os.close(fd)

Still the old value because the inode size has not been updated.

Close the file descriptor in the original process so there are no more
references and then reopen it:
1>>> os.close(fd)
1>>> fd = os.open('/dev/sr0', os.O_RDONLY | os.O_NONBLOCK)
1>>> os.lseek(fd, 0, 2) / 512
15120512

Now we get the new value.

I would like to add a check_disk_size_change() call to sr.c.  Is there a
reason to keep the existing behavior?

Stefan
