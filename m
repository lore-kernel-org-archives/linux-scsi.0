From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: error recovery and command completion
Date: Mon, 28 Jun 2004 14:16:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FF1D5DB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:35041 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265024AbUF1SQm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 14:16:42 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Mark Haverkamp <markh@osdl.org>

2.4 (and in 2.6) we have the following concept fragment in scsi_done:

void scsi_done(Scsi_Cmnd * SCpnt)
{
        unsigned long flags;
        int tstatus;

        /*
         * We don't have to worry about this one timing out any more.
         */
        tstatus = scsi_delete_timer(SCpnt);

        /*
         * If we are unable to remove the timer, it means that the
command
         * has already timed out.  In this case, we have no choice but
to
         * let the timeout function run, as we have no idea where in
fact
         * that function could really be.  It might be on another
processor,
         * etc, etc.
         */
        if (!tstatus) {
                SCpnt->done_late = 1;
                return;
        }
. . .

This means that if the driver's intent is to not perform any error
recovery, simply administrative health checks and/or minor corrective
action when the timeout actions are requested, that the command
completion gets lost. Commands can not be aborted to the RAID adapter,
The Adapter can not be reset.

However, if I call scsi_add_timer anew to permit the appropriate command
completion during this race condition ala:

//DEBUG
static void aacraid_timeout_dummy_fn(struct scsi_cmnd * scsicmd)
{
      return;
}

static void aac_io_done(struct scsi_cmnd * scsicmd)
{
        unsigned long cpu_flags;
        struct Scsi_Host *host = scsicmd->device->host;

        aac_spin_lock_irqsave(host->host_lock, cpu_flags);
        /*
         * Tell system to perform scsi_done functionality even despite
         * being in the error recovery code. Leave a `timer' to delete
         * so that completion can progress.
         */
//DEBUG
        scsi_add_timer(scsicmd, 60*HZ, aacraid_timeout_dummy_fn);
        scsicmd->scsi_done(scsicmd);
. . .

This resolves the problem in most cases (eg 2.4.9-e.40), but in some
kernels (2.4.21-timesys-4.1.193) I get address violations in eh_hand1,
and in others (2.4.21-15.EL) I will get out of memory complaints from
user applications (!). The failure is not repeatable and extremely rare;
but without this call, we have command loss even more repeatably.

What is the appropriate action to take. A suggestion has been to remove
the timer when the command has been issued, and add it again as above
(effectively turning off timeout activity) but the administrative health
checks are necessary as a diagnostic aid to catastrophic failure.

I have not tried, but if I remove the scsi_add_timer, and instead do:

-	scsi_add_timer(scsicmd, 60*HZ, aacraid_timeout_dummy_fn);
	scsicmd->scsi_done(scsicmd);
+	if (scsicmd->done_late) {
+		scsicmd->done_late = 0;
+		scsi_add_timer(scsicmd, 60*HZ,
aacraid_timeout_dummy_fn);
+		scsicmd->scsi->done(scsicmd);
+	}

Am I making anything better (probably not, but it does remove the risk
of exposure of running scsi_add_timer at each command completion at a
time that may just be considered inappropriate). Is my problem forcing
the command completion, or the scsi_add_timer ...

Sincerely - Mark Salyzyn
