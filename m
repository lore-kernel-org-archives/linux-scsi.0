From: Douglas Gilbert <dougg@torque.net>
Subject: noisy reservation conflicts
Date: Mon, 14 Jun 2004 16:01:40 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CD3F44.4080004@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:60177 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262003AbUFNGju
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 02:39:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

While testing persistent reservations it is quite common
to get a status of "reservation conflict". When using
the SG_IO ioctl this status is returned via the
sg_io_hdr::status field and is simple to process.

However this lk 2.6.7-rc3 code fragment in
scsi_decide_disposition() [scsi_error.c] makes it very
noisy (on the console and in the log):

         case RESERVATION_CONFLICT:
                 printk("scsi%d (%d,%d,%d) : reservation conflict\n",
                        scmd->device->host->host_no,
                        scmd->device->channel,
                        scmd->device->id, scmd->device->lun);
                 return SUCCESS; /* causes immediate i/o error */

The unadorned printk() looks like debugging code. Could this
be softened, or removed in the case of a RQ_SPECIAL?

Doug Gilbert

