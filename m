From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Problem handling task management functions in qla2xxx
Date: Tue, 22 Aug 2006 18:25:28 +0400
Message-ID: <44EB13D8.6010607@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([85.249.135.211]:56205 "EHLO
	out-relay-02.mailcluster.net") by vger.kernel.org with ESMTP
	id S1751392AbWHVO0S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Aug 2006 10:26:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-driver@qlogic.com

Hello,

If a task management function is issued, eg using sg_reset utility (the 
easiest way), during active IO to qla2xxx device (ISP2422), it often 
fails with messages like:

------------------------------------------------------------------

qla2xxx 0000:04:02.0: scsi(13:0:1): DEVICE RESET ISSUED.
qla2xxx 0000:04:02.0: qla2xxx_eh_device_reset: failed while waiting for
commands

------------------------------------------------------------------

This could lead to broken SCSI mid-level's error recovery and 
erroneously making the device(es) offline, when they are actually healthy.

I did some investigations and figured out that the driver waits some 
time for the firmware to finish aborting the outstanding commands with 
CS_ABORTED status and if at least one command isn't finished until 
timeout, FAILED is returned.

The problem is how the wait is implemented. Here is the code:

------------------------------------------------------------------

static int
qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
{
#define ABORT_POLLING_PERIOD    1000
#define ABORT_WAIT_ITER         ((10 * 1000) / (ABORT_POLLING_PERIOD))
         unsigned long wait_iter = ABORT_WAIT_ITER;
         int ret = QLA_SUCCESS;

         while (CMD_SP(cmd)) {
                 msleep(ABORT_POLLING_PERIOD);

                 if (--wait_iter)
                         break;
         }
         if (CMD_SP(cmd))
                 ret = QLA_FUNCTION_FAILED;

         return ret;
}

------------------------------------------------------------------

Where CMD_SP() is defined as
#define CMD_SP(Cmnd)            ((Cmnd)->SCp.ptr)

It's set to NULL just before cmd->scsi_done() is called.

You can see that this way of waiting has a race with the SCSI mid-level, 
where it can free and reuse the command while 
qla2x00_eh_wait_on_command() is sleeping in msleep(), so SCp.ptr can 
become non-NULL again, which could lead to the above false errors.

Regards,
Vlad

