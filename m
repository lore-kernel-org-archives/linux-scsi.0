From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: 2.4.26 panic: scsi_unjam_host: Miscount of number of failed commands
Date: Wed, 12 May 2004 14:51:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04May12.145146edt.332177@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:12302 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S265173AbUELSvt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2004 14:51:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com

I am getting a panic "scsi_unjam_host: Miscount of number of failed
commands."  This is the setup:

Linux kernel 2.4.26
qla2200.o version 6.06.10 from QLogic's web site
QLogic QLA2200 Fibre Channel card
Pathlight SAN Router
SpectraLogic Treefrog medium changer

This panic happens only under very specific circumstances:
1) A command fails with check condition
2) The sense length is greater than 32 bytes
3) The sense key is not ready and ASC/ASCQ indicate the unit is becoming
ready
4) A retry of the command fails in the same way

The qla2200 driver auto-retrieves sense data only if the sense length is
less than 32 bytes (a hardware or driver limitation).  If the sense
length is less than or equal to 32 bytes, then the panic doesn't happen,
the command is auto-retried several times, and eventually the error is
reported back to the upper level.  The sense length of the Treefrog
medium changer is 52 bytes, so this triggers the problem for me.

I have been able to determine the code path that is followed prior to
the panic:

-----------

scsi_unjam_host()
  loop on commands
    !scsi_sense_valid(SCpnt)
    scsi_request_sense(SCpnt)
    sense data indicates not ready, becoming ready
    scsi_decide_disposition(SCpnt) return NEEDS_RETRY
    rtn = scsi_eh_retry_command(SCpnt)
      scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command)
        scsi_eh_completed_normally(SCpnt)
          status_byte(SCpnt->result) == CHECK_CONDITION
          scsi_check_sense(SCpnt)
            !scsi_sense_valid(SCpnt)
            return FAILED
          return FAILED
        SCpnt->eh_state = FAILED
      return FAILED
    rtn != SUCCESS
      continue (at this point SCpnt->state == NEEDS_RETRY)

  count number of failed commands
    check for SCpnt->state == SCSI_STATE_FAILED
    check for SCpnt->state == SCSI_STATE_TIMEOUT

  numfailed == 0 && timed_out == 0 && host->host_failed == 1
  panic("scsi_unjam_host: Miscount of number of failed commands.\n");

-----------

So the problem seems to be that SCpnt->state == NEEDS_RETRY outside of
the code that handles it.  I am not sure how to fix it.

Anthony J. Battersby
Cybernetics


