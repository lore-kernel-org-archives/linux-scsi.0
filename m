From: Dave Olien <dmo@osdl.org>
Subject: Question about Request Sense case in scsi_lib.c
Date: Mon, 11 Oct 2004 17:00:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041012000058.GA26569@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:26605 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S269358AbUJLAA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 20:00:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



I'm having some odd behavior with my multipath fibre channel system.
I'm running 2.6.9-rc3, and have a Qlogic 2300 dual ported controller,
routed through two brocade switches to two IBM FastT200 disk arrays.

The FastT200 are configured as JBOD. Each array has 10 disks.  Each FastT200
is dual ported, configured in "active-active" mode.  So, I have
four paths to each physical disk, 80 paths total.

Doing just simple IO (dd if=/dev/zero of=/dev/sdX bs=1M) on all 20 at once
drives gives me occasional messages of the form:

Incorrect number of segments after building list
counted 31, received 30
req nr_sec 1024, cur_nr_sec 8

this is from the code in scsi_init_io() function in scsi_lib.c

I traced this to scsi_io_completion(), to the scsi_requeue_command() at
the bottom of this code.

			if ((cmd->sense_buffer[2] & 0xf) == UNIT_ATTENTION) {
                                if (cmd->device->removable) {
                                        /* detected disc change.  set a bit
                                         * and quietly refuse further access.
                                         */
                                        cmd->device->changed = 1;
                                        cmd = scsi_end_request(cmd, 0,
                                                        this_count, 1);
                                        return;
                                } else {
                                        /*
                                        * Must have been a power glitch, or a
                                        * bus reset.  Could not have been a
                                        * media change, so we just retry the
                                        * request and see what happens.
                                        */
                                        scsi_requeue_command(q, cmd);
                                        return;
                                }
			}


My system hits this scsi_requeue_command() case a lot (maybe 1 in 1000 writes),
and of these I occasionally get the error messages in the requeue.

Can anyone explain why I might be getting the "bus reset" in my
request sense data?  I'll later look into the requeued commands that
fail, to understand what's going on there.

Thanks!
Dave Olien
