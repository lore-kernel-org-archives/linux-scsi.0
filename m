From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: iscsi (?): Unknown VPD Code: 0xc7
Date: Fri, 24 Mar 2017 21:16:14 +0100
Message-ID: <6eb8196f-7116-6cd5-8039-25b9a956c19a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35884 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936093AbdCXUQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 16:16:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id x124so149074wmf.3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 13:16:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Dunkel <harald.dunkel@aixigo.de>, Hannes Reinecke <hare@suse.de>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Harald Dunkel wrote:

> I am trying to use LIO on amd64 to provide block devices to some
> AIX 6.1 and 7.1 hosts. It works pretty well, except that I cannot
> create rootvg wpars on AIX 7.1. (rootvg wpars are containers
> running on their own volume group.)
> 
> The error message on AIX is
> 
> bash-4.3# mkwpar -O -D rootvg=yes devname=hdisk3 -n sample
> **********************************************************************
> ERROR
> mkwpar: 0960-587 hdisk3 has un-supported subclass type.
> 
> **********************************************************************


> Kernel is 4.9.13 (Debian backports). It shows several (maybe unrelated)
> lines in kernel.log
> 
> :
> Mar 23 08:46:05 nasl003b kernel: [ 1172.226643] Unknown VPD Code: 0xc7
> Mar 23 08:46:05 nasl003b kernel: [ 1172.279368] Unknown VPD Code: 0xc7
> Mar 23 08:46:06 nasl003b kernel: [ 1172.331243] Unknown VPD Code: 0xc7
> Mar 23 08:46:06 nasl003b kernel: [ 1172.380074] Unknown VPD Code: 0xc7
> Mar 23 08:47:02 nasl003b kernel: [ 1229.106384] Unknown VPD Code: 0xc7
> Mar 23 19:06:30 nasl003b kernel: [38396.514881] Unknown VPD Code: 0xc7
> Mar 23 19:06:30 nasl003b kernel: [38396.576499] Unknown VPD Code: 0xc7
> Mar 23 19:06:30 nasl003b kernel: [38396.624678] Unknown VPD Code: 0xc7
> :
> 
> What is it trying to tell me?

Maybe related to this SUSE patch(missing upstream):

>From 09040ffe64b67a66453c7cc7bf2d645a0b27aeaf Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 27 Oct 2016 09:20:23 +0200
Subject: [PATCH] scsi: Add 'AIX VDASD' to blacklist
References: bsc#1006469
Patch-Mainline: submitted to linux-scsi 2016/10/27

The AIX VDASD devices do support VPD pages, but implement
only SPC. So set BLIST_TRY_VPD_PAGS to correctly display
the VPD information in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index cab178f..8d66051 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -136,6 +136,7 @@ static struct {
 	{"3PARdata", "VV", NULL, BLIST_REPORTLUN2},
 	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
+	{"AIX", "VDASD", NULL, BLIST_TRY_VPD_PAGES},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN},
-- 
1.8.5.6


Try to add "scsi_dev_flags=AIX:VDASD:0x10000000" to the kernel command
line in grub.
