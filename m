From: Jeff Moyer <jmoyer@redhat.com>
Subject: scsi error handler thread seems to run continuously
Date: Fri, 28 May 2010 17:07:57 -0400
Message-ID: <x49wrunvioi.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab0E1VH7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 17:07:59 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4SL7w9X006646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 17:07:58 -0400
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.16.60.26])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o4SL7vJm018632
	for <linux-scsi@vger.kernel.org>; Fri, 28 May 2010 17:07:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

If I turn up the scsi logging level to 0xff, I see the following in my
logs:

May 28 17:04:12 solid kernel: scsi_block_when_processing_errors: rtn: 1
May 28 17:04:12 solid kernel: Waking error handler thread
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115674580
May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host to restart
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
May 28 17:04:12 solid kernel: Waking error handler thread
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115674580
May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host to restart
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
May 28 17:04:12 solid kernel: Waking error handler thread
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115674580
May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host to restart
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
May 28 17:04:12 solid kernel: Waking error handler thread
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115674580
May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host to restart
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
May 28 17:04:12 solid kernel: Waking error handler thread
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115674580
May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host to restart
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
May 28 17:04:12 solid kernel: Waking error handler thread
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 waking up
May 28 17:04:12 solid kernel: scsi_eh_1: flush finish cmd: ffff880115674580
May 28 17:04:12 solid kernel: scsi_restart_operations: waking up host to restart
May 28 17:04:12 solid kernel: Error handler scsi_eh_1 sleeping
May 28 17:04:12 solid kernel: scsi_block_when_processing_errors: rtn: 1

Is this expected?  Any ideas on what might be causing it?  It's worth
noting that Mike Snitzer tried this on a scsi_debug device and saw the
same thing.

Thanks,
Jeff
