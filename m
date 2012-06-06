From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 0/3] scsi: fix internal write cache issue on usb hdd.
Date: Wed,  6 Jun 2012 08:19:59 -0400
Message-ID: <1338985199-9648-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The numbers of USB HDDs(All USB HDD I checked) does not respond correctly to scsi mode sense command for retrieving the write cache page status. Even though write cache is enabled by default, due to scsi driver assume that cache is not enabled which in turn might lead to loss of data since data still will be in cache.
This result that all filesystems is not stable on USB HDD when the device is unplugged abruptly, even though these are having journaling feature.
Our first trying is that scsi driver send ATA command(ATA Pass through, #58) to USB HDD after failure from normal routine to know write cache enable.
We have known it is dangerous after testing several USB HDD. some of HDD is stalled by this command(A-DATA HDD). So we tried to make the patch James's suggestion(usb quirk) on version 2 that add product ID and verdor ID of USB HDD to USB quirk list after checking write cache.
All filesystem will be stable on USB HDD registered in quirk list. And it will be updated continuously.

	scsi: set to WCE if usb cache quirk is present.
	usb: storage: add support write cache quirk on usb hdd.
	usb: core: update usb devices for write cache quirk in quirk.

 drivers/scsi/sd.c          |    9 +++++++--
 include/scsi/scsi_device.h |    1 +
 drivers/usb/storage/scsiglue.c |    6 ++++++
 drivers/usb/storage/usb.c      |    5 ++++-
 include/linux/usb/quirks.h     |    3 +++
 include/linux/usb_usual.h      |    4 +++-
 drivers/usb/core/quirks.c |    6 ++++++
-- 
1.7.9.5
