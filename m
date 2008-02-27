From: peter <pbog@us.ibm.com>
Subject: Re: Bug in aic94xx driver in 2.6.25-rc3
Date: Wed, 27 Feb 2008 14:39:06 -0800
Message-ID: <1204151946.7281.23.camel@gnattop>
References: <1203987834.6909.17.camel@gnattop>
	 <1203992592.26232.79.camel@alexis>
Reply-To: pbog@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:33576 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYB0WjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 17:39:09 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1RMd6E0005853
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 17:39:06 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1RMd6Y1190330
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 15:39:06 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1RMd5HN005783
	for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 15:39:06 -0700
In-Reply-To: <1203992592.26232.79.camel@alexis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, Alexis Bruemmer <alexisb@us.ibm.com>, tom_white@adaptec.com


My original post was user error and not acutally a bug.  I didn't
realize that there was another patch I need to apply to rc3 to get the
latest scsi drivers and error handler code.  Alexis clued me in.  Now
the error handler appears to be working properly.  I included a sample
at the bottom of this email.  

I am still seeing the disk go offline if I run i/o performance tests on
sas disks connected to the aic94xx (sequencer version 32).  It doesn't
happen right away.  The i/o tests will run for several hours before it
fails.  Eventually you see the filesystem abort and then be remounted as
read only.

Peter Bogdanovic
IBM




sas: command 0xffff810142569200, task 0xffff81022ad27980, timed out:
EH_NOT_HANDLED^M
sas: Enter sas_scsi_recover_host^M
sas: trying to find task 0xffff81022ad27980^M
sas: sas_scsi_find_task: aborting task 0xffff81022ad27980^M
aic94xx: tmf tasklet complete^M
aic94xx: tmf resp tasklet^M
aic94xx: tmf came back^M
aic94xx: task not done, clearing nexus^M
aic94xx: asd_clear_nexus_tag: PRE^M
aic94xx: asd_clear_nexus_tag: POST^M
aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...^M
aic94xx: task 0xffff81022ad27980 done with opcode 0x23 resp 0x0 stat
0x8d but aborted by upper layer!^M
aic94xx: asd_clear_nexus_tasklet_complete: here^M
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0^M
aic94xx: came back from clear nexus^M
aic94xx: task 0xffff81022ad27980 aborted, res: 0x0^M
sas: sas_scsi_find_task: task 0xffff81022ad27980 is done^M
sas: sas_eh_handle_sas_errors: task 0xffff81022ad27980 is done^M
sd 0:0:3:0: [sdd] Result: hostbyte=DID_ABORT
driverbyte=DRIVER_OK,SUGGEST_OK^M
end_request: I/O error, dev sdd, sector 27106623^M
sas: --- Exit sas_scsi_recover_host^M


