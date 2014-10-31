From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 0/2] hpsa: a worqueue fix
Date: Fri, 31 Oct 2014 15:17:31 +0100
Message-ID: <1414765053-23792-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759419AbaJaORl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2014 10:17:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, Elliott@hp.com, brace77070@gmail.com

When a thread uses shared workqueue for a long time it my block 
other tasks and in log you may see mesages like this :
INFO: task sshd:6425 blocked for more than 120 seconds.
      Not tainted 2.6.32-431.11.2.el6.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D 000000000000000e     0  6425   6418 0x00000080
...

In this case the time resources consuming work in hpsa
was found guilty and the first patch in series handles it.
Special thanks for the analysis to Herton R. Krzesinski

Tomas


