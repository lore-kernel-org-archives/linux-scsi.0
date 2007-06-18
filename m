From: Hiroki Takada <takada@cmsinc.co.jp>
Subject: Calling scsi_done() after the SCSI timer is fired
Date: Mon, 18 Jun 2007 19:13:32 +0900
Message-ID: <20070618101332.GB10405%takada@cmsinc.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fbvrgw.firstserver.ne.jp ([164.46.1.51]:46217 "EHLO
	fbvrgw.firstserver.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832AbXFRKTa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2007 06:19:30 -0400
Received: from vrgw5.firstserver.ne.jp (vrgw5.firstserver.ne.jp [164.46.1.48])
	by fbvrgw.firstserver.ne.jp (8.13.8/8.13.8/FirstServer) with ESMTP id l5IAEdG6026293
	for <linux-scsi@vger.kernel.org>; Mon, 18 Jun 2007 19:14:39 +0900 (JST)
	(envelope-from takada@cmsinc.co.jp)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiroki Takada <takada@cmsinc.co.jp>

Hi

I wonder if somebody could advice me. I am a SCSI LLDD developer. 
I have a question about an implementation of eh_abort_handler()
for SCSI hosts when SCSI command timer is fired. I may check out
the queue and look for a command given as an argument to abort. 
But, what I should do when the command is being processed. I can
not abort it halfway.

As I saw a statement to check if scmd->serial_number has been
cleared in scsi_try_to_abort_cmd, I got to think it makes sense
that let LLDD to keep processing the command and be going to call
scsi_done().

static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
{
        unsigned long flags;
        int rtn = FAILED;

        if (!scmd->device->host->hostt->eh_abort_handler)
                return rtn;

        /*
         * scsi_done was called just after the command timed out and
         * before
         * we had a chance to process it. (db)
         */
>>      if (scmd->serial_number == 0)
                return SUCCESS;

        scmd->owner = SCSI_OWNER_LOWLEVEL;

        spin_lock_irqsave(scmd->device->host->host_lock, flags);
        rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
        spin_unlock_irqrestore(scmd->device->host->host_lock, flags);

        return rtn;
}

I soon realized this idea is wrong. Any calling scsi_done() isn't
significant after the timer is fired.


void scsi_done(struct scsi_cmnd *cmd)
{
        /*
         * We don't have to worry about this one timing out any more.
         * If we are unable to remove the timer, then the command
         * has already timed out.  In which case, we have no choice but
         * to
         * let the timeout function run, as we have no idea where in
         * fact
         * that function could really be.  It might be on another
         * processor,
         * etc, etc.
         */
        if (!scsi_delete_timer(cmd))
                return;
        __scsi_done(cmd);
}

int scsi_delete_timer(struct scsi_cmnd *scmd)
{
        int rtn;

        rtn = del_timer(&scmd->eh_timeout);

        SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p,"
                                         " rtn: %d\n", __FUNCTION__,
                                         scmd, rtn));

        scmd->eh_timeout.data = (unsigned long)NULL;
        scmd->eh_timeout.function = NULL;

        return rtn;
}

LLDD calls scsi_done() and forget about the command. Therefore, I think
it could make sense to set cmd->serial_number = 0 in scsi_done() even
after the timer is fired.

void scsi_done(struct scsi_cmnd *cmd)
{

    ---- snip ----

        if (!scsi_delete_timer(cmd)) {
                cmd->serial_number = 0;
                return;
        }

        __scsi_done(cmd);
}


Or I should properly implement an error recovery function using
scsi_transport interface? I mean I return EH_HANDLED in
scmd->device->host->transportt->eh_timed_out(scmd)

Thanks and regrds,


Hiroki Takada

-- 
----------------------------------------------------------
Hiroki Takada <takada@cmsinc.co.jp>
Engineering Development Group, Super Storage Div. 
Core Micro Systems Inc.
2-22-2, Koishikawa, Bunkyo-Ku, Tokyo 112-0002
TEL : +81-50-5558-5410  (IP Phone)
TEL : +81-3-5802-6872  / FAX : +81-3-5802-5113
