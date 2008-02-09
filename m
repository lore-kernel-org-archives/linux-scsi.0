From: Elias Oltmanns <eo@nebensachen.de>
Subject: Investigating potential flaw in scsi error handling
Date: Sat, 09 Feb 2008 22:59:28 +0100
Message-ID: <87bq6pkczj.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:42275 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbYBIWvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Feb 2008 17:51:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>

Hi there,

I'm experiencing system lockups with 2.6.24 which I believe to be
related to scsi error handling. Actually, I have patched the mainline
kernel with a disk shock protection patch [1] and in my case it is indeed
the shock protection mechanism that triggers the lockups. However, some
rather lengthy investigations have lead me to the conclusion that this
additional patch is just the means to reproduce the error condition
fairly reliably rather than the origin of the problem.

The problem has only become apparent since Tejun's commit
31cc23b34913bc173680bdc87af79e551bf8cc0d. More precisely, libata now
sets max_host_blocked and max_device_blocked to 1 for all ATA devices.
Various tests I've conducted so far have lead me to the conclusion that
a non zero return code from scsi_dispatch_command is sufficient to
trigger the problem I'm seeing provided that max_host_blocked and
max_device_blocked are set to 1.

Unfortunately, I'm a bit at a loss as to how I should proceed to find
the culprit. I can reliably reproduce the problem using the disk shock
protection patch in order to cause non zero return values from
scsi_dispatch_command. How can I find out where in the error handling of
this condition things might go wrong?

Most likely you will need further information to help me solving this
issue but perhaps you can already come up with some suggestions and tell
me what else you'd like to know.

Thanks in advance,

Elias

[1] http://article.gmane.org/gmane.linux.drivers.hdaps.devel/1094


PS: Since the disk shock protection patch is mainly concerned with an
ATA specific feature, I'm currently working on it to implement it in
libata rather than in the scsi midlayer. This doesn't change anything
with regard to the problem I've described above but has confirmed my
suspicion that it must be the return code from scsi_dispatch_command
that triggers system freeze.
