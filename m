From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Flexible timout intfrastructure take II
Date: Thu, 17 Jun 2004 14:52:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617215229.GA2204@us.ibm.com>
References: <1087421869.2796.80.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:60110 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263828AbUFQVwg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 17:52:36 -0400
Content-Disposition: inline
In-Reply-To: <1087421869.2796.80.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


Just an FYI. I applied the patch to scsi-misc-2.6. I patched scsi_debug
to add the new eh_timed_out interface and added support for the
scsi_debug opts modules param to control the return values so I could
test the three cases. 

I provide output below from this artificial test running a single dd and
selecting each return value. I also attached the messages output with
scsi_error logging selected.

-andmike
--
Michael Anderson
andmike@us.ibm.com

1.) Output of test running.
# ./test_eh_timed_out /dev/sdc
andmike: Starting eh_timed_out tests
andmike: Starting eh_timed_out EH_HANDLED test
dev.scsi.logging_level = 0x7
1+0 records in
1+0 records out
512 bytes transferred in 30.017646 seconds (17 bytes/sec)
dev.scsi.logging_level = 0

andmike: Starting eh_timed_out EH_NOT_HANDLED test
dev.scsi.logging_level = 0x7
1+0 records in
1+0 records out
512 bytes transferred in 30.241254 seconds (17 bytes/sec)
dev.scsi.logging_level = 0

andmike: Starting eh_timed_out EH_RESET_TIMER test
dev.scsi.logging_level = 0x7
1+0 records in
1+0 records out
512 bytes transferred in 60.017334 seconds (9 bytes/sec)
dev.scsi.logging_level = 0
andmike: Ending eh_timed_out tests


2.) /var/log/messages output
Jun 17 19:22:05 elm andmike: Starting eh_timed_out tests

#
# EH_HANDLED
#
Jun 17 19:22:05 elm andmike: Starting eh_timed_out EH_HANDLED test
Jun 17 19:22:05 elm kernel: scsi_block_when_processing_errors: rtn: 1
Jun 17 19:22:05 elm kernel: scsi_add_timer: scmd: c9ccce98, time: 30000, (c028cd50)
Jun 17 19:22:05 elm kernel: scsi_debug: scmd: c9ccce98 28 00 00 00 00 00 00 00 80 00 
Jun 17 19:22:35 elm kernel: scsi_debug_timed_out: scmd: c9ccce98


#
# EH_NOT_HANDLED
#
Jun 17 19:22:35 elm andmike: Starting eh_timed_out EH_NOT_HANDLED test
Jun 17 19:22:35 elm kernel: scsi_block_when_processing_errors: rtn: 1
Jun 17 19:22:35 elm kernel: scsi_add_timer: scmd: c9ccce98, time: 30000, (c028cd50)
Jun 17 19:22:35 elm kernel: scsi_debug: scmd: c9ccce98 28 00 00 00 00 00 00 00 80 00
Jun 17 19:23:05 elm kernel: scsi_debug_timed_out: scmd: c9ccce98
Jun 17 19:23:05 elm kernel: scsi_debug_timed_out: scmd: c9ccce98 NOT_HNDLD
Jun 17 19:23:05 elm kernel: Waking error handler thread
Jun 17 19:23:05 elm kernel: Error handler scsi_eh_2 waking up
Jun 17 19:23:05 elm kernel: scsi_eh_prt_fail_stats: 2:0:0:0 cmds failed: 0, cancel: 1
Jun 17 19:23:05 elm kernel: Total of 1 commands on 1 devices require eh work
Jun 17 19:23:05 elm kernel: scsi_eh_2: aborting cmd:0xc9ccce98
Jun 17 19:23:05 elm kernel: scsi_debug: abort
Jun 17 19:23:05 elm kernel: scsi_add_timer: scmd: c9ccce98, time: 10000, (c028cfe0)
Jun 17 19:23:05 elm kernel: scsi_debug: scmd: c9ccce98 00 00 00 00 00 00 
Jun 17 19:23:05 elm kernel: scsi_add_timer: scmd: cc59ee98, time: 30000, (c028cd50)
Jun 17 19:23:05 elm kernel: scsi_eh_done scmd: c9ccce98 result: 0
Jun 17 19:23:05 elm kernel: scsi_send_eh_cmnd: scmd: c9ccce98, rtn:2002
Jun 17 19:23:05 elm kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 17 19:23:05 elm kernel: scsi_eh_tur: scmd c9ccce98 rtn 2002
Jun 17 19:23:05 elm kernel: scsi_eh_2: flush retry cmd: c9ccce98
Jun 17 19:23:05 elm kernel: scsi_delete_timer: scmd: c9ccce98, rtn: 0
Jun 17 19:23:05 elm kernel: scsi_add_timer: scmd: c9ccce98, time: 30000, (c028cd50)
Jun 17 19:23:05 elm kernel: scsi_debug: scmd: c9ccce98 28 00 00 00 00 00 00 00 80 00 
Jun 17 19:23:05 elm kernel: Error handler scsi_eh_2 sleeping
Jun 17 19:23:05 elm kernel: scsi_delete_timer: scmd: c9ccce98, rtn: 1


#
# EH_RESET_TIMER
#
Jun 17 19:23:05 elm andmike: Starting eh_timed_out EH_RESET_TIMER test
Jun 17 19:23:05 elm kernel: scsi_block_when_processing_errors: rtn: 1
Jun 17 19:23:05 elm kernel: scsi_add_timer: scmd: c9ccce98, time: 30000, (c028cd50)
Jun 17 19:23:05 elm kernel: scsi_debug: scmd: c9ccce98 28 00 00 00 00 00 00 00 80 00 
Jun 17 19:23:35 elm kernel: scsi_debug_timed_out: scmd: c9ccce98
Jun 17 19:23:35 elm kernel: scsi_debug_timed_out: scmd: c9ccce98 RST_TIME
Jun 17 19:23:35 elm kernel: scsi_add_timer: scmd: c9ccce98, time: 30000, (c028cd50)
Jun 17 19:24:05 elm kernel: scsi_delete_timer: scmd: c9ccce98, rtn: 1
Jun 17 19:24:05 elm andmike: Ending eh_timed_out tests

