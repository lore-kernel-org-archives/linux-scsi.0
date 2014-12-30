From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/5] Feature enhancements for ses module
Date: Tue, 30 Dec 2014 14:46:13 -0800
Message-ID: <1419979578-3793574-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48058 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbaL3Wq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2014 17:46:59 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBUMkw5u015753
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:46:58 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1rkxvpgv7h-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:46:58 -0800
Received: from facebook.com (2401:db00:20:701c:face:0:3f:0)	by
 mx-out.facebook.com (10.212.232.59) with ESMTP	id
 b5193920907511e49d390002c991e86a-113d9390 for <linux-scsi@vger.kernel.org>;
	Tue, 30 Dec 2014 14:46:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, hare@suse.de, dgilbert@interlog.com, Song Liu <songliubraving@fb.com>

1: close potential race condition by at enclosure race condition

2,3,4: add enclosure id and device slot, so we can create symlink
       in /dev/disk/by-slot:
  # ls -d /dev/disk/by-slot/*
    /dev/disk/by-slot/enclosure-0x5000ae41fc1310ff-slot0

5: add ability to power on/off device with power_status file in
   sysfs.

Due to the complexity of SES standard, the module is not to replace implement \
all features of sg_ses (sg3_utils).

Patch 5 and existing features for device element and array device elements control \
of HDDs. It is helpful to handle some HDD related fields in the kernel, as the \
kernel can generate mapping between a device to the SES device element (or array \
device element):

/sys/block/sdc/device/enclosure_deviceXXX/

With patch 5, we can easily power off a running HDD by

echo off > /sys/block/sdc/device/enclosure_deviceXXX/power_status

This is very useful for systems like Cold Storage, where HDDs are being powered \
on/off frequently


Dan Williams (4):
  ses: close potential registration race
  ses: generate KOBJ_CHANGE on enclosure attach
  ses: add enclosure logical id
  ses: add reliable slot attribute

Song Liu (1):
  ses: Add power_status to SES device slot

 drivers/misc/enclosure.c  | 106 +++++++++++++++++++++++++++++----
 drivers/scsi/ses.c        | 148 +++++++++++++++++++++++++++++++++++++++-------
 include/linux/enclosure.h |  13 +++-
 3 files changed, 232 insertions(+), 35 deletions(-)

-- 
1.8.1

