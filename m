From: Sachin Sant <sachinp@in.ibm.com>
Subject: Status_byte() in drivers/scsi/scsi.h
Date: Thu, 19 Jun 2003 14:17:40 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF178AC.CEC2C720@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:5285 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265526AbTFSIbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2003 04:31:03 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h5J8j1u8271816
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2003 04:45:01 -0400
Received: from in.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay02.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h5J8iwNO098484
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2003 02:45:00 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There seems to be some problem with the status_byte( ) in scsi.h

A SAM status code SAM_STAT_TASK_ABORTED is ignored by status_byte() - it
returns a status GOOD. If SAM status code SAM_STAT_TASK_ABORTED is set
status_byte() must return 0x20.

In kernel file include/scsi/scsi.h new SCSI Architecture Model (SAM)
Status Codes were presented as following:
#define SAM_STAT_GOOD            0x00
#define SAM_STAT_CHECK_CONDITION 0x02
#define SAM_STAT_CONDITION_MET   0x04
#define SAM_STAT_BUSY            0x08
#define SAM_STAT_INTERMEDIATE    0x10
#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
#define SAM_STAT_RESERVATION_CONFLICT 0x18
#define SAM_STAT_COMMAND_TERMINATED 0x22        /* obsolete in SAM-3 */
#define SAM_STAT_TASK_SET_FULL   0x28
#define SAM_STAT_ACA_ACTIVE      0x30
#define SAM_STAT_TASK_ABORTED    0x40

This means that an implementation of a status_byte() function in
drivers/scsi/scsi.h has to be changed from:

  #define status_byte(result) (((result) >> 1) & 0x1f)
to:
  #define status_byte(result) (((result) >> 1) & 0x3f)

Otherwise it would ignore a status code SAM_STAT_TASK_ABORTED and return
GOOD.

Please let me know your thoughts.

Thanks
-Sachin
