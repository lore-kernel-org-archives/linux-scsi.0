From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Strange code in revalidate_scsidisk
Date: Tue, 14 Sep 2004 15:20:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914152022.5d47cae4@lembas.zaitcev.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56277 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S269580AbUINWUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 18:20:37 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.10) with ESMTP id i8EMKTpT030555
	for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2004 18:20:29 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id i8EMKTr16075
	for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2004 18:20:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: zaitcev@redhat.com, dledford@redhat.com

Hi, Guys:

Here's a short summary to provide the context for my question. Fujitsu report
a lockup (on RHEL3, but the code is the same as 2.6). They hook up a USB
connected MO drive with three partitions and do:

while : ; do fsck -t ext2 -p -y /dev/sdb1 & fsck -t ext2 -p -y \
  /dev/sdb2 & fsck -t ext2 -p -y /dev/sdb3 ; done

If the drive is unplugged, the system hangs. They were able to capture
netdump logs and cores and came up with a patch which replaced
rdisk->busy flag with a semaphore.

My theory is that the following loop is to blame:

static int sd_open(struct inode *inode, struct file *filp)
{
	/*
	 * Make sure that only one process can do a check_change_disk at one time.
	 * This is also used to lock out further access when the partition table
	 * is being re-read.
	 */

	while (rscsi_disks[target].device->busy) {
		barrier();
		cpu_relax();
	}
........

First process sets the busy flag and sleeps. Remaining processes take
a CPU each, lock the usb-storage thread out, and no progress can be
made thereafter.

Now, the question is: is there a specific reason to avoid waiting
in the following fragment:

#define DEVICE_BUSY rscsi_disks[target].device->busy
int revalidate_scsidisk(kdev_t dev, int maxusage)
{
	target = DEVICE_NR(dev);

	if (DEVICE_BUSY || (ALLOW_REVALIDATE == 0 && USAGE > maxusage)) {
		printk("Device busy for revalidation (usage=%d)\n", USAGE);
		return -EBUSY;
	}
	DEVICE_BUSY = 1;
	........ lotsa code ..........
	DEVICE_BUSY = 0;
}

What happens if we just take the necessary semaphore here?
In other words:

revalidate_scsidisk()
{
	if ((ALLOW_REVALIDATE == 0 && USAGE > maxusage)) {
		printk("Device busy for revalidation (usage=%d)\n", USAGE);
		return -EBUSY;
	}
	down(&rscsi_disks[target].device->busy_sem);
	........ lotsa code ..........
	up(&rscsi_disks[target].device->busy_sem);
}

Thanks,
-- Pete
