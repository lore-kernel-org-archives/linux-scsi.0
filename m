From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx driver woes
Date: Sun, 01 Apr 2007 16:29:17 -0400
Message-ID: <4610161D.7060709@torque.net>
References: <460E90F3.9070601@torque.net> <460EA211.2060501@us.ibm.com>	 <460EB110.8060706@torque.net> <1175383041.3760.70.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35054 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbXDAUbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Apr 2007 16:31:37 -0400
In-Reply-To: <1175383041.3760.70.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sat, 2007-03-31 at 15:05 -0400, Douglas Gilbert wrote:
>> James, note the SAS address of the first expander.
> 
> Thanks, just checking ... what happens when you directly attach a disk?

Then I get what I term as "udev hell". That is when
FC6 gets to the point during boot-up of saying
"Starting udev: " and hangs for about 5 minutes and
then continues.

I don't think my log records what happens in that
elongated pause. Later attempts to talk to the
single SAS disk (one port only connected) during
boot-up are shown below starting from the first sign
of trouble. The SAS address of the disk port is
0x5000c50001b02139 .

> Or even try the other expander?

Same as yesterday's report:
  sas: RG to ex 500605b000000af0 failed:0xffffff06


If I fiddle with the cabling long enough (i.e. shorten
it) then it will work some of the time. But how come the
card POST, Luben's driver and Adaptec's for Windows have
no problem with exactly the same wiring all of the
time? I suspect that either the HBA's phys are not
being set up properly or, the first blemish (e.g. loss
of dword synchronization) on the link, knocks the
production driver off its perch, while the other
drivers recover and continue.

Doug Gilbert


...
sas: phy3 added to port0, phy_mask:0x8
sas: DOING DISCOVERY on port 0, pid:2110
aic94xx: scb:0x80 timed out
last message repeated 6 times
sas: command 0xf57d5edc, task 0xf527bea8, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf527bea8
sas: sas_scsi_find_task: aborting task 0xf527bea8
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task 0xf527bea8 aborted, res: 0x5
sas: sas_scsi_find_task: querying task 0xf527bea8
aic94xx: tmf timed out
sas: sas_scsi_find_task: task 0xf527bea8 failed to abort
sas: task 0xf527bea8 is not at LU: I_T recover
sas: I_T nexus reset for dev 5000c50001b02139
sas: clearing nexus for port:0
aic94xx: asd_clear_nexus_port: PRE
aic94xx: asd_clear_nexus_port: POST
aic94xx: asd_clear_nexus_port: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: clear nexus ha
aic94xx: asd_clear_nexus_ha: PRE
aic94xx: asd_clear_nexus_ha: POST
aic94xx: asd_clear_nexus_ha: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: error from  device 5000c50001b02139, LUN 0 couldn't be recovered in any way
sas: --- Exit sas_eh_handle_sas_errors -- clear_q
sas: --- Exit sas_scsi_recover_host
sas: command 0xf57d5edc, task 0xf527bea8, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf527bea8
sas: sas_scsi_find_task: aborting task 0xf527bea8
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task 0xf527bea8 aborted, res: 0x5
sas: sas_scsi_find_task: querying task 0xf527bea8
aic94xx: tmf timed out
sas: sas_scsi_find_task: task 0xf527bea8 failed to abort
sas: task 0xf527bea8 is not at LU: I_T recover
sas: I_T nexus reset for dev 5000c50001b02139
sas: clearing nexus for port:0
aic94xx: asd_clear_nexus_port: PRE
aic94xx: asd_clear_nexus_port: POST
aic94xx: asd_clear_nexus_port: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: clear nexus ha
aic94xx: asd_clear_nexus_ha: PRE
aic94xx: asd_clear_nexus_ha: POST
aic94xx: asd_clear_nexus_ha: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: error from  device 5000c50001b02139, LUN 0 couldn't be recovered in any way
sas: --- Exit sas_eh_handle_sas_errors -- clear_q
sas: --- Exit sas_scsi_recover_host
sas: command 0xf57d5edc, task 0xf527bea8, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf527bea8
sas: sas_scsi_find_task: aborting task 0xf527bea8
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task 0xf527bea8 aborted, res: 0x5
sas: sas_scsi_find_task: querying task 0xf527bea8
aic94xx: tmf timed out
sas: sas_scsi_find_task: task 0xf527bea8 failed to abort
sas: task 0xf527bea8 is not at LU: I_T recover
sas: I_T nexus reset for dev 5000c50001b02139
sas: clearing nexus for port:0
aic94xx: asd_clear_nexus_port: PRE
aic94xx: asd_clear_nexus_port: POST
aic94xx: asd_clear_nexus_port: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: clear nexus ha
aic94xx: asd_clear_nexus_ha: PRE
aic94xx: asd_clear_nexus_ha: POST
aic94xx: asd_clear_nexus_ha: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: error from  device 5000c50001b02139, LUN 0 couldn't be recovered in any way
sas: --- Exit sas_eh_handle_sas_errors -- clear_q
sas: --- Exit sas_scsi_recover_host
sas: command 0xf57d5edc, task 0xf527bea8, timed out: EH_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xf527bea8
sas: sas_scsi_find_task: aborting task 0xf527bea8
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task 0xf527bea8 aborted, res: 0x5
sas: sas_scsi_find_task: querying task 0xf527bea8
aic94xx: tmf timed out
sas: sas_scsi_find_task: task 0xf527bea8 failed to abort
sas: task 0xf527bea8 is not at LU: I_T recover
sas: I_T nexus reset for dev 5000c50001b02139
sas: clearing nexus for port:0
aic94xx: asd_clear_nexus_port: PRE
aic94xx: asd_clear_nexus_port: POST
aic94xx: asd_clear_nexus_port: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: clear nexus ha
aic94xx: asd_clear_nexus_ha: PRE
aic94xx: asd_clear_nexus_ha: POST
aic94xx: asd_clear_nexus_ha: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
sas: error from  device 5000c50001b02139, LUN 0 couldn't be recovered in any way
sas: --- Exit sas_eh_handle_sas_errors -- clear_q
sas: --- Exit sas_scsi_recover_host
sas: DONE DISCOVERY on port 0, pid:2110, result:0





