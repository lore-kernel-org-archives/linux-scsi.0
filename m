From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Mid-layer handling of NOT_READY conditions...
Date: Fri, 28 Jan 2005 15:24:10 -0800
Message-ID: <1106954650.9862.61.camel@plap>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:22184 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262820AbVA1XXw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2005 18:23:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com

[PREFACE: Please forgive the rather long absence on linux-scsi, I've
been occupied by several non-related projects]


All,

While stripping out the remnants of internal queuing from the qla2xxx
driver and adding-in support for various fc_host/fc_remote constructs,
I've ran into a rather peculiar problem with respect to the way the SCSI
mid-layer handles NOT_READY conditions (notably ASC 0x04 and ASCQ 0x01).

I was doing simple short-duration cable-pulls when I noticed I/O errors
would occur at unexpected times as the storage returned to the topology.
The simplest case goes like this:

      * Issue I/O to device A
      * Device A falls off the topology 
      * Driver (qla2xxx) blocks additional requests to device A via
        fc_remote_port_block() 
      * Short time later (couple of seconds) device A returns to
        topology
      * Driver logs-into device and unblocks requests via
        fc_remote_port_unblock().
      * I/O resumes

The storage still unable to process the commands returns
check-conditions (please excuse the crude printk()s):

        *** check 1148/1/5 [1:0] sdev_st=2 status=2 [6/29/0].
        *** check 1149/1/5 [1:0] sdev_st=2 status=2 [2/4/1].
        scsi_decide_disposition: sc 0 RETRY incremented 2/5
        *** check 1150/2/5 [1:0] sdev_st=2 status=2 [2/4/1].
        scsi_decide_disposition: sc 0 RETRY incremented 3/5
        *** check 1151/3/5 [1:0] sdev_st=2 status=2 [2/4/1].
        scsi_decide_disposition: sc 0 RETRY incremented 4/5
        *** check 1152/4/5 [1:0] sdev_st=2 status=2 [2/4/1].
        
while scsi_decide_disposition() agrees to retry the commands since
cmd->retries < cmd->allowed.  But when NOT_READYs persists beyond
cmd->allowed, scsi_decide_disposition() returns SUCCESS:

        scsi_decide_disposition: sc 0 2 SUCCESS 6/5 [2/4/1]

and the command then begins additional processing via:

        scsi_finish_command()
          sd_rw_itr()
            scsi_io_completion()
        
at which point, the following check is made:

        ...
        /*
         * If the device is in the process of becoming ready,
         * retry.
         */
        if (sshdr.asc == 0x04 && sshdr.ascq == 0x01) {
                scsi_requeue_command(q, cmd);
                return;
        }
        
and the command is requeued to the request-q via blk_insert_request()
and started again with:

        q->request_fn()
          scsi_request_fn()
            scsi_dispatch_cmd()
        
There seems to be two problem with this approach:

     1. As the storage continues to return NOT_READY,
        scsi_decide_disposition() blindly increments cmd->retries and
        checks against cmd->allowed, returning SUCCESS (since at this
        point cmd->retries is always greater than cmd->allowed) -- I've
        seen this condition loop several hundred times while the
        NOT_READY condition clears.
     2. as a result of the (cmd->retries > cmd->allowed) state of the
        command, if a LLDD returns any status (other than DID_OK) which
        could initiate a retry, the command is immediately failed.  As
        an example, the qla2xxx driver returns DID_BUS_BUSY in case of
        any 'transport' related problems during the exchange (dropped
        frames, FCP protocal failures, etc.).

When the qla2xxx driver managed command queuing internally, a NOT_READY
status would cause the lun-queue to be frozen for some period time while
the storage settled-down.

Would this be an approach to consider?  Or should we tackle the problem
by addressing the quirky (cmd->retries > cmd->allowed) state?

Thanks,
Andrew Vasquez
