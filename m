From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH / RFC] osst, st, sg sysfs removes
Date: Sat, 11 Jan 2003 14:25:25 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0301111416510.2294-100000@kai.makisara.local>
References: <20030109222107.GA5041@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030109222107.GA5041@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Matt_Domsch@Dell.com, wrlk@riede.org, Douglas Gilbert <dougg@torque.net>, mochel@osdl.org

On Thu, 9 Jan 2003, Mike Anderson wrote:

> This patch is against 2.5.55
>
> This patch is in response to the mail I sent the other day on the use of
> to_scsi_device with our sysfs bus/scsi/devices directory containing more
> than struct scsi_device objects. A link to the thread is below.
>
> http://marc.theaimsgroup.com/?l=linux-scsi&m=104198504307087&w=2
>
> This patch is just a removal of osst, st, and sg's sysfs nodes in the
> devices directory. Current I do not have a place to replicate this
> capability. It was unclear if osst and st entries where being used. The
> correct place for osst and st is to have a char tree like the block tree
> and have a pointer from the scsi device to the char entry. I do not know

Looks OK to me (at least the st part). I have been planning to export some
settings in the directories this patch removes but it has to wait until
corresponding entries can be created into the (currently non-existent)
char tree.

While looking at the sysfs/bus/scsi tree after this patch, I noticed that
all devices currently get linked to the sd driver:

14:20:59> ll /devices/bus/scsi/drivers/sd
total 0
lrwxrwxrwx    1 root     root           40 2003-01-11 00:14 0:0:0:0 ->
../../../../devices/pci0/00:0e.1/0:0:0:0/
lrwxrwxrwx    1 root     root           40 2003-01-11 00:14 1:0:5:0 ->
../../../../devices/pci0/00:0e.0/1:0:5:0/
lrwxrwxrwx    1 root     root           40 2003-01-11 00:14 1:0:5:1 ->
../../../../devices/pci0/00:0e.0/1:0:5:1/
lrwxrwxrwx    1 root     root           36 2003-01-11 00:14 2:0:0:0 ->
../../../../devices/ide-scsi/2:0:0:0/

(0:0:0:0 is a disk, 1:0:5:0 a tape, 1:0:5:1 a changer (not attached to any
high-level driver!), 2:0:0:0 a cdrom)

The entries for sr and st do exist but are empty. sg is populated.

-- 
Kai
