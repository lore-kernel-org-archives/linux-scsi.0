From: John Washer <johnkwasher@gmail.com>
Subject: scsi:sd: provisioning_mode not being set to unmap
Date: Sat, 27 Oct 2012 12:52:46 +0900
Message-ID: <CADHvswAnKx7COQrtnXp7LTmRP2euC0xortkcd2+HgwAxUc3-Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58400 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934466Ab2J0Dwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 23:52:47 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3199622obb.19
        for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2012 20:52:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com

Hi,

Provisioning mode is not being set to "unmap" even though it seems
that device firmware provides all the required information to SD.

1. The TPE bit is set in the Read Capacity 16 response,

$ sudo sg_readcap --16 -H /dev/sg1
 00     00 00 00 00 00 ff ff ff  00 00 10 00 00 01 80 00
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

so sdkp->lbpme will be set to 1 and sd_config_discard(sdkp,
SD_LBP_WS16); will be called which maps 'provisioning mode' to Write
Same 16.

2. Device supports SPC 3
First 3 bytes of Inquiry

$ sudo sg_inq -H /dev/sg1
standard INQUIRY:
 00     00 00 06

So extended inquiry on the firmware will be done.

3. The device does not support VPD 0xb2.
$ sudo sg_vpd  -p 0xb2 /dev/sg1
VPD page=0xb2
fetching VPD page failed

4. The device supports VPD - 0xb0

$ sudo sg_vpd  -p 0xb0 /dev/sg1
Block limits VPD page (SBC):

$ sudo sg_vpd  -p 0xb0 /dev/sg4

Block limits VPD page (SBC):
 00     00 b0 00 3c 00 00 02 00  ff ff 00 00 02 00 00 00    ...<............
 10     00 00 00 00 ff ff ff ff  ff 00 00 00 00 20 00 00    ............. ..
 20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
 30     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................

Block limits VPD page (SBC):
  Write same no zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 512 blocks
  Maximum transfer length: 4294901760 blocks
  Optimal transfer length: 33554432 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
  Maximum unmap LBA count: 4294967295
  Maximum unmap block descriptor count: 4278190080
  Optimal unmap granularity: 2097152
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks

So, sdkp->max_unmap_blocks = lba_count;

So the following piece of code should set provisioning_mode to UNMAP

              if (!sdkp->lbpvpd) { /* LBP VPD page not provided */

			if (sdkp->max_unmap_blocks)
				sd_config_discard(sdkp, SD_LBP_UNMAP);
			else
				sd_config_discard(sdkp, SD_LBP_WS16);

		}

But when I check the "/sys.../provisioning_mode" it is set to Write Same 16.

What am I missing here. What else SD is looking for.

-John
