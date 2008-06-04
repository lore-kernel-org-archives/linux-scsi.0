From: Tomas Ebenlendr <ebik@jyxo.com>
Subject: Re: Problems with aic94xx (AIC9410W onboard)
Date: Wed, 04 Jun 2008 14:01:55 +0200
Message-ID: <48468433.2000705@jyxo.com>
References: <48466101.70509@jyxo.com> <48466898.50809@jyxo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xmlcz.jyxo.com ([195.122.208.206]:44617 "EHLO mail1.jyxo.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188AbYFDJzv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2008 05:55:51 -0400
Received: from [192.168.0.29] (235-105-207-85.bluetone.cz [85.207.105.235])
	by mail1.jyxo.com (Postfix) with ESMTP id 28F77180F051
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2008 11:55:49 +0200 (CEST)
In-Reply-To: <48466898.50809@jyxo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello again.
I digged more into the log and also previous logs.
The fail differs from normal noise in following:

First, normal noise begins with:
aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
sas: command 0xd8c229c0, task 0xda2505c0, timed out: EH_NOT_HANDLED

Whereas there is no REQ TASK ABORT line when the problem occurs.
Then it continues with following. The last three lines
(task not in LU) are very suspicious.

sas: Enter sas_scsi_recover_host
sas: trying to find task 0xd7aae5c0
sas: sas_scsi_find_task: aborting task 0xd7aae5c0
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: task 0xd7aae5c0 aborted, res: 0x5
sas: sas_scsi_find_task: querying task 0xd7aae5c0
aic94xx: tmf tasklet complete
sas: sas_scsi_find_task: task 0xd7aae5c0 not at LU
sas: task 0xd7aae5c0 is not at LU: I_T recover
sas: I_T nexus reset for dev 5000c5000704c79d

Few other lines, and then reseting continues:

asd_clear_nexus_tasklet_complete: here
asd_clear_nexus_tasklet_complete: opcode: 0x0
sending hard reset to phy-3:5
control_phy_tasklet_complete: phy5: sub_func:0x81
aic94xx: asd_clear_nexus_I_T: PRE
aic94xx: asd_clear_nexus_I_T: POST
aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: asd_clear_nexus_I_T: PRE
aic94xx: asd_clear_nexus_I_T: POST
aic94xx: asd_clear_nexus_I_T: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x13
sas: I_T 5000c5000704c79d recovered
sas: --- Exit sas_scsi_recover_host

Log says recovered, but device is inaccessible, and whole controller
is frozen for a while then. Maybe until all other commands/tasks
are aborted.

Any help appreciated.
Thanks. Tomas Ebenlendr, Jyxo s.r.o., Czech Republic.
