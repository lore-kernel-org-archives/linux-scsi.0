From: Tejun Heo <tj@kernel.org>
Subject: why does udev set timeout for all SCSI devices?
Date: Thu, 30 Oct 2008 11:55:04 +0900
Message-ID: <49092208.9060909@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:54503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYJ3CzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 22:55:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jens.axboe@oracle.com>

Hello, Kay.

As the $SUBJ says, why does udev set timeout for all SCSI devices?
It's the following two rules.

50-udev-default.rules:SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",
ACTION=="add", ATTR{type}=="0|7|14", ATTR{timeout}="60"
50-udev-default.rules:SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*",
ACTION=="add", ATTR{type}=="1", ATTR{timeout}="900"

The appropriate default timeout differs depending on the transport and
the type of the attached device, so the above two rules harm more than
help.  The affect of the above two rules weren't visible for some
reason but with recent block layer timeout update, they actually work
and cause problems.

Thanks.

-- 
tejun
