From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] smartpqi: initial commit of Microsemi smartpqi driver
Date: Fri, 14 Oct 2016 16:59:53 +0300
Message-ID: <20161014135953.GA5081@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20629 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753350AbcJNOAL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 10:00:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kevin.barnett@microsemi.com
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org

Hello Kevin Barnett,

The patch 6c223761eb54: "smartpqi: initial commit of Microsemi
smartpqi driver" from Jun 27, 2016, leads to the following static
checker warning:

	drivers/scsi/smartpqi/smartpqi_init.c:3513 pqi_submit_raid_request_synchronous()
	warn: inconsistent returns 'sem:&ctrl_info->sync_request_sem'.

drivers/scsi/smartpqi/smartpqi_init.c
  3437  static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
  3438          struct pqi_iu_header *request, unsigned int flags,
  3439          struct pqi_raid_error_info *error_info, unsigned long timeout_msecs)
  3440  {
  3441          int rc;
  3442          struct pqi_io_request *io_request;
  3443          unsigned long start_jiffies;
  3444          unsigned long msecs_blocked;
  3445          size_t iu_length;
  3446  
  3447          /*
  3448           * Note that specifying PQI_SYNC_FLAGS_INTERRUPTABLE and a timeout value
  3449           * are mutually exclusive.
  3450           */
  3451  
  3452          if (flags & PQI_SYNC_FLAGS_INTERRUPTABLE) {
  3453                  if (down_interruptible(&ctrl_info->sync_request_sem))
  3454                          return -ERESTARTSYS;
  3455          } else {
  3456                  if (timeout_msecs == NO_TIMEOUT) {
  3457                          down(&ctrl_info->sync_request_sem);
  3458                  } else {
  3459                          start_jiffies = jiffies;
  3460                          if (down_timeout(&ctrl_info->sync_request_sem,
  3461                                  msecs_to_jiffies(timeout_msecs)))
  3462                                  return -ETIMEDOUT;
  3463                          msecs_blocked =
  3464                                  jiffies_to_msecs(jiffies - start_jiffies);
  3465                          if (msecs_blocked >= timeout_msecs)
  3466                                  return -ETIMEDOUT;

You probably just want to delete this if statement because it is racy.
Or unlock before returning at any rate.

  3467                          timeout_msecs -= msecs_blocked;
  3468                  }
  3469          }

regards,
dan carpenter
