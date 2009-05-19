From: saeed bishara <saeed.bishara@gmail.com>
Subject: how to block in_atomic scsi requests for long time
Date: Tue, 19 May 2009 15:04:07 +0300
Message-ID: <c70ff3ad0905190504o77d966dbxcb07eb39d1225f08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65298 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZESMEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2009 08:04:07 -0400
Received: by fxm2 with SMTP id 2so3821583fxm.37
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2009 05:04:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
    I have a system with 4 disks that configured to enter standby
mode, the power supplier of this system can't drive concurrent
spin-ups of more than one disk, and it needs the spin-ups to be few
seconds far from each other.
    I've implemented this feature by adding a semaphore, and in the
scsi_dispatch_command, the process will wait for that semaphore if the
disk in standby mode and other disk in a middle of doing spinup. but
the problem is that sometimes that function is called while in atomic
context, and waiting to the semaphore is prohibeted.
    how do you guys suggest to block a request which comes in atomic mode?


saeed
