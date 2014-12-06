From: Song Liu <songliubraving@fb.com>
Subject: [PATCH RESEND 0/5] Feature enhancements for ses module
Date: Sat, 6 Dec 2014 00:27:02 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBCC5BF6@PRN-MBX02-4.TheFacebook.com>
References: <1417824557-13470-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18416 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbaLFA1b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 19:27:31 -0500
In-Reply-To: <1417824557-13470-1-git-send-email-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>

These patches include a few enhancements to ses module:

1: close potential race condition by at enclosure race condition

2,3,4: add enclosure id and device slot, so we can create symlink
       in /dev/disk/by-slot:
  # ls -d /dev/disk/by-slot/*
    /dev/disk/by-slot/enclosure-0x5000ae41fc1310ff-slot0

5: add ability to power on/off device with power_status file in
   sysfs.

Due to the complexity of SES standard, the module is not to replace implement all features (which is the goal of sg_ses from sg3_utils). Patch 5 and existing features for device element and array device elements control of HDDs. It is helpful to handle some HDD related fields in the kernel, as the kernel can generate mapping between a device to the SES device element (or array device element): 

/sys/block/sdc/device/enclosure_deviceXXX/

With patch 5, we can easily power off a running HDD by 

echo off > /sys/block/sdc/device/enclosure_deviceXXX/power_status

This is very useful for systems like Cold Storage, where HDDs are being powered \ on/off frequently

Dan Williams (4):
  SES: close potential registration race
  SES: generate KOBJ_CHANGE on enclosure attach
  SES: add enclosure logical id
  SES: add reliable slot attribute

Song Liu (1):
  SES: Add power_status to SES enclosure component

 drivers/misc/enclosure.c  | 107 +++++++++++++++++++++++++++++----
 drivers/scsi/ses.c        | 148 +++++++++++++++++++++++++++++++++++++++-------
 include/linux/enclosure.h |  13 +++-
 3 files changed, 232 insertions(+), 36 deletions(-)

--
1.8.1

