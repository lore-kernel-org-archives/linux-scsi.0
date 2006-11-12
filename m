From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Aic94xx and Linux kernel 2.6.19
Date: Sun, 12 Nov 2006 11:05:31 -0800
Message-ID: <4557707B.8040701@us.ibm.com>
References: <834553.41356.qm@web31804.mail.mud.yahoo.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:6890 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1752764AbWKLTFe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Nov 2006 14:05:34 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kACJ5r3c019018
	for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2006 14:05:53 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kACJ5XZg138574
	for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2006 14:05:33 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kACJ5W3Z027170
	for <linux-scsi@vger.kernel.org>; Sun, 12 Nov 2006 14:05:33 -0500
In-Reply-To: <834553.41356.qm@web31804.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: ltuikov@yahoo.com, mike.redan@bell.ca, James.Bottomley@SteelEye.com, alexisb@us.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:

> 3. I never see a crash.  After the transport driver couldn't allocate
>    memory and returned 0xFFFFFFF4 (-ENOMEM), the SATL task is put
>    back on the list of tasks to be executed, task order, NCQ, etc perfectly
>    preserved. (SATL supports NCQ and Full Task Management, btw.)  The second time
>    around* allocation succeeds and the task(s) are executed.  The application
>    client (I/O tester application/whatever, in user space) never detects this,
>    since the task does complete and status is returned to the application client.

Indeed, I had hoped that libata would do a similar thing.  A curious
thing happens, however, when ata_qc_new_init fails to get an ata_queued_cmd:

First, ata_qc_new_init handles the failure like this:
    cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
    done(cmd);

Then, we return to ata_scsi_translate and do this:
    err_mem:
        cmd->result = (DID_ERROR << 16);
        done(cmd);

It appears to me (jgarzik, please correct me if I'm wrong) that first we
set a status code indicating that we're ok but the device queue is full
and finish the command,  but then we blow away that status code and
replace it with an error flag and finish the command a second time!
That does not seem to be desirable behavior since we merely want the I/O
to wait until a command slot frees up, not send errors up the block layer.

Perhaps in the err_mem case we should simply exit out of
ata_scsi_translate instead?  I've a quick-and-dirty patch, though I've
not tested it thoroughly yet.

--

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7af2a4b..5c1fc46 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1612,9 +1612,9 @@ early_finish:

 err_did:
 	ata_qc_free(qc);
-err_mem:
 	cmd->result = (DID_ERROR << 16);
 	done(cmd);
+err_mem:
 	DPRINTK("EXIT - internal\n");
 	return 0;

