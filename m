From: Luigi Tarenga <luigi.tarenga@gmail.com>
Subject: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 10:52:20 +0200
Message-ID: <542A6F44.3070802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:64205 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaI3IwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 04:52:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

hi everybody,
I write to you for a problem that sound as my simple mistake
but I can't really find a solution after googling and reading
official doc.

I'm trying to configure a iscsi target on a centos 6.5 box with
a custom kernel compiled from vanilla 3.16.3.

I have compile:
CONFIG_TARGET_CORE=m
CONFIG_ISCSI_TARGET=m
CONFIG_CONFIGFS_FS=m

I mount configfs:
# mount | grep config
configfs on /sys/kernel/config type configfs (rw)

manually load iscsi_target_mod (and this show nothing in dmesg)

and when I run targetcli ls command this is the output:
# targetcli ls
o- / 
..................................................................... [...]
   o- backstores 
.......................................................... [...]
   | o- block ................................................ [0 
Storage Object]
   | o- fileio ............................................... [0 
Storage Object]
   | o- pscsi ................................................ [0 
Storage Object]
   o- loopback ...................................................... [0 
Targets]

I can't see "o- iscsi" so I can't create the iscsi target i need...

# targetcli version
targetcli version 2.0rc1.fb16

$ ls /sys/kernel/config/target/
core  version

# lsmod | grep scsi
iscsi_target_mod      205464  0
target_core_mod       229493  1 iscsi_target_mod
configfs               22151  3 iscsi_target_mod,target_core_mod
scsi_mod               93246  6 
iscsi_target_mod,target_core_mod,sg,sd_mod,sr_mod,libata

any idea of what I can check?

many thanks in advance
Luigi
