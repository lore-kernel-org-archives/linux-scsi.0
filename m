From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi:sd: provisioning_mode not being set to unmap
Date: Mon, 29 Oct 2012 23:53:50 -0400
Message-ID: <yq1r4og8vjl.fsf@sermon.lab.mkp.net>
References: <CADHvswAnKx7COQrtnXp7LTmRP2euC0xortkcd2+HgwAxUc3-Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:22570 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab2J3Dx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2012 23:53:56 -0400
In-Reply-To: <CADHvswAnKx7COQrtnXp7LTmRP2euC0xortkcd2+HgwAxUc3-Rw@mail.gmail.com>
	(John Washer's message of "Sat, 27 Oct 2012 12:52:46 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Washer <johnkwasher@gmail.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com

>>>>> "John" == John Washer <johnkwasher@gmail.com> writes:

John> Provisioning mode is not being set to "unmap" even though it seems
John> that device firmware provides all the required information to SD.

I instrumented scsi_debug to provide the same values as your device
(LBPME=1, identical Block Limits VPD, no LBP VPD) and we end up choosing
unmap. So I'm not sure what's going on in your case. Which kernel are
you using?


John> 3. The device does not support VPD 0xb2.
John> $ sudo sg_vpd  -p 0xb2 /dev/sg1
John> VPD page=0xb2
John> fetching VPD page failed

FWIW, the Logical Block Provisioning VPD page is now mandatory.


John> But when I check the "/sys.../provisioning_mode" it is set to
John> Write Same 16.

What happens if you override it by writing "unmap" to that file?

-- 
Martin K. Petersen	Oracle Linux Engineering
