From: Daniel Drake <dsd@gentoo.org>
Subject: ioctl_internal_command() too verbose?
Date: Fri, 02 Sep 2005 13:44:09 +0100
Message-ID: <43184919.5060107@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:9559 "EHLO
	mta07-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1751250AbVIBMlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Sep 2005 08:41:04 -0400
Received: from aamta10-winn.ispmail.ntl.com ([81.103.221.35])
          by mta07-winn.ispmail.ntl.com with ESMTP
          id <20050902124100.DGKG21883.mta07-winn.ispmail.ntl.com@aamta10-winn.ispmail.ntl.com>
          for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2005 13:41:00 +0100
Received: from zog.reactivated.net ([81.99.81.161])
          by aamta10-winn.ispmail.ntl.com with ESMTP
          id <20050902124100.OJBC3432.aamta10-winn.ispmail.ntl.com@zog.reactivated.net>
          for <linux-scsi@vger.kernel.org>; Fri, 2 Sep 2005 13:41:00 +0100
Received: from [192.168.0.2] (dsd [192.168.0.2])
	by zog.reactivated.net (Postfix) with ESMTP id 625157BDD57
	for <linux-scsi@vger.kernel.org>; Fri,  2 Sep 2005 14:13:49 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

In a Gentoo bug report, a user reported this message appearing repeatedly in 
the kernel logs:

	Device not ready. Make sure there is a disc in the drive.

This comes from ioctl_internal_command() (scsi_ioctl.c).

This message can be reproduced once by a simple "touch /dev/scd0" on a drive 
with no CD inserted. The userspace tools which monitor for CD change by 
repeatedly polling the device are resulting in this message being printed lots 
of times when no CD is in the drive.

Any objections to reducing this to a debug message only?

Daniel
