From: "Jeffrey W. Baker" <jwbaker@acm.org>
Subject: arcmsr aborted command, machine hang, and useless SMART behavior
Date: Thu, 12 Jun 2008 08:59:40 -0700
Message-ID: <1213286380.21613.3.camel@squeak.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:57411 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYFLP7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 11:59:43 -0400
Received: by py-out-1112.google.com with SMTP id p76so1672709pyb.10
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 08:59:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm having trouble with arcmsr.  I have an ARC-1280 as follows:

CLI> sys info
The System Information
===========================================
Main Processor     : 800MHz
CPU ICache Size    : 32KB
CPU DCache Size    : 32KB
System Memory      : 256MB/533MHz
Firmware Version   : V1.43 2007-4-17 
BOOT ROM Version   : V1.43 2007-4-17 
Serial Number      : Y650CAAWAR800029
Controller Name    : ARC-1280
Current IP Address : 192.168.1.100
===========================================
GuiErrMsg<0x00>: Success.

CLI> disk info
 #   ModelName        Serial#          FirmRev     Capacity  State
===============================================================================
 1   WDC WD5000ABYS-  WD-WCAPW2369251  12.01C01     500.1GB  RaidSet Member(1)
 2   WDC WD5000ABYS-  WD-WCAPW2620902  12.01C01     500.1GB  RaidSet Member(1)
 3   WDC WD5000ABYS-  WD-WCAPW2369851  12.01C01     500.1GB  RaidSet Member(2)
 4   WDC WD5000ABYS-  WD-WCAPW2562218  12.01C01     500.1GB  RaidSet Member(2)
 5   WDC WD5000ABYS-  WD-WCAPW2368419  12.01C01     500.1GB  RaidSet Member(2)
 6   WDC WD5000ABYS-  WD-WCAPW2370161  12.01C01     500.1GB  RaidSet Member(2)
 7   WDC WD5000ABYS-  WD-WCAPW2369852  12.01C01     500.1GB  RaidSet Member(2)
 8   WDC WD5000ABYS-  WD-WCAPW2608483  12.01C01     500.1GB  RaidSet Member(2)
===============================================================================
GuiErrMsg<0x00>: Success.

I'm running:

Linux think 2.6.18-5-amd64 #1 SMP Thu Aug 30 01:14:54 UTC 2007 x86_64 GNU/Linux.

The version of arcmsr is 1.20.00.13.  The problem is that the machine
intermittently hangs after emitting this message:

Jun 11 20:04:22 think kernel: arcmsr2: abort device command of scsi id=0 lun=1 
Jun 11 20:08:07 think kernel: arcmsr2: abort device command of scsi id=0 lun=1 
Jun 11 20:09:26 think kernel: arcmsr2: abort device command of scsi id=0 lun=1 
Jun 11 20:09:26 think last message repeated 2 times
Jun 11 20:15:25 think kernel: arcmsr2: abort device command of scsi id=0 lun=1 
Jun 11 20:15:27 think kernel: arcmsr2: ccb='0xffff810037f222c0' isr got aborted command 
Jun 11 20:15:31 think kernel: arcmsr2: abort device command of scsi id=0 lun=1 
Jun 11 20:15:37 think last message repeated 8 times
Jun 11 20:15:46 think kernel: arcmsr2: ccb='0xffff810037f25f80' isr got aborted command 

That is the last console message.  Afterwards, the machine is
non-responsive, i.e. hung and needs a hard reset.

Is there anything in the latest driver that would fix this?

Further complicating my problem is the fact that the ARC-1280 has this
completely useless SMART output:

CLI> disk smart drv=1~8
Message: Drive #01 == >Off-Line Data Collection Is In The Progress...
Message: Drive #02 == >Off-Line Data Collection Is In The Progress...
Message: Drive #03 == >Off-Line Data Collection Is In The Progress...
Message: Drive #04 == >Off-Line Data Collection Is In The Progress...
Message: Drive #05 == >Off-Line Data Collection Is In The Progress...
Message: Drive #06 == >Off-Line Data Collection Is In The Progress...
Message: Drive #07 == >Off-Line Data Collection Is In The Progress...
Message: Drive #08 == >Off-Line Data Collection Is In The Progress...
GuiErrMsg<0x00>: Success.

It _always_ says that.  I can never get SMART status on any of my
drives, and therefore I don't know if they've failed or what.  I also
can't run self-tests when they are in this state:

CLI> disk sttest drv=8 
ErrMsg: Drive 8 Is Not Available

Please help.

-jwb

