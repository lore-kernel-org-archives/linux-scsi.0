From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: With kernel 2.6.19 no sg devices for devices that return PQ=1,
	PDT=0x1f
Date: Tue, 05 Aug 2008 09:51:30 -0700
Message-ID: <1217955090.9923.22.camel@localhost.localdomain>
References: <48984A20.2050002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35089 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758729AbYHEQvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 12:51:41 -0400
In-Reply-To: <48984A20.2050002@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Petermann <martin@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-08-05 at 14:40 +0200, Martin Petermann wrote:
> With kernel 2.6.19 a change was introduced that no sg device was 
> generated if PQ=1, PDT=0x1f was returned from the particular device:
> 
> commit 84961f28e9d13a4b193d0c8545f3c060c1890ff3
> Author: dave wysochanski <davidw@netapp.com>
> Date:   Wed Aug 9 14:56:32 2006 -0400
> 
>      [SCSI] Don't add scsi_device for devices that return PQ=1, PDT=0x1f
> 
> Before it was possible on Linux 390 in user space to a e.g. LUN 0 to a 
> port and to receive a generic device:
> 
> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
> total 0
> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
> --w------- 1 root root 4096 Aug  4 12:07 uevent
> --w------- 1 root root    0 Aug  4 13:46 unit_add
> --w------- 1 root root    0 Aug  5 14:24 unit_remove
> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # echo 0 > 
> unit_add
> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
> total 0
> drwxr-xr-x 2 root root    0 Aug  5 14:25 0x0000000000000000
> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
> --w------- 1 root root 4096 Aug  4 12:07 uevent
> --w------- 1 root root    0 Aug  5 14:25 unit_add
> --w------- 1 root root    0 Aug  5 14:24 unit_remove
> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # lsscsi -g
> [0:0:0:0]    no dev  IBM      2107900          2.27  -         /dev/sg0
> 
> After this fix there is no /dev/sg0 device generated.
> 
> We are utilizing the possibility to create such a device for the 
> sg_utils commands in the case no other LUN has been attached to a port.
> 
> I do not want to put this fix into question. I would like to know if 
> someone has an idea how to workaround this problem and to generate a 
> generic device in user space using kernel 2.6.19 or a later version.

First of all, why is the device returning PQ=1 PTD=0x1f? this should
mean its not connected and probably doesn't exist... ie inaccessible
without some unspecified action being taken.  If you can use it, it's
clearly not behaving like a PQ=1 LUN.  Perhaps the simplest thing would
be for something in s390 to fix up the inquiry data ... or we could
allow you could have a script to force it to appear (as in if you send a
specific scan for this one LUN we could override the catch in the code
that throws it out again).

James


