From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Mon, 31 Jan 2005 23:21:45 -0800
Message-ID: <1107242505.6305.15.camel@plap>
References: <0B1E13B586976742A7599D71A6AC733C02F326@xbl3.ma.emulex.com>
	 <20050131173629.GA29928@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from avexch01.qlogic.com ([198.70.193.200]:33476 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261667AbVBAHV1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2005 02:21:27 -0500
In-Reply-To: <20050131173629.GA29928@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Smart@Emulex.Com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, 2005-01-31 at 09:36 -0800, Patrick Mansfield wrote:
> On Mon, Jan 31, 2005 at 11:56:02AM -0500, James.Smart@Emulex.Com wrote:
> > > On Sat, 2005-01-29 at 11:34 -0800, Patrick Mansfield wrote:
> 
> > > > 
> > > > Why not just set scmd->retries to zero in scsi_requeue_command()?
> > > > 
> > > 
> > > This is exactly what I was thinking would be a fairly straight-forward
> > > approach at solving the problem...
> > 
> > This is ultimately a hack, and raises the potential for the retries value
> > to perpetually be rezero'd.  The better solution is the use the block
> > primitives available to avoid the i/o being issued at all if the transport
> > can't handle it.
> 
> No, it does not change the potential to retry forever, someone still has
> to requeue the IO again outside of the NEEDS_RETRY/scsi_retry_command case
> for that to happen.
> 
> We only check retries in scsi_decide_disposition (well not counting error
> handling), and if we hit the limit, return SUCCESS. The change is that we
> reset retries to zero if the command is *not* retried via
> NEEDS_RETRY/scsi_retry_command.
> 
> It would be even clearer to zero retries in scsi_decide_disposition.
> 
> For NOT_READY, we would be better off always using the
> scsi_requeue_command path ever: get rid of the check in scsi_check_sense,
> as it will be requeued via scsi_io_completion code. This would have to
> happen even if delaying retries to NOT_READY devices.
> 

Here's a small patch against the latest scsi-rc-fixes tree I've been
running with which allows my basic cable-pull test to complete without
incident.

Please consider for inclusion.


As per Patrick M's suggestions:

      * reset a command's retries count in scsi_decide_disposition() in
        case of additional requiring by upper layer.
      * remove redundant check for NOT_READY (ASC: 0x04 ASCQ: 0x01) in
        scsi_check_sense().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 scsi_error.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

===== drivers/scsi/scsi_error.c 1.86 vs edited =====
--- 1.86/drivers/scsi/scsi_error.c	2005-01-17 22:54:45 -08:00
+++ edited/drivers/scsi/scsi_error.c	2005-01-31 23:01:54 -08:00
@@ -327,12 +327,6 @@ static int scsi_check_sense(struct scsi_
 			return NEEDS_RETRY;
 		}
 		/*
-		 * if the device is in the process of becoming ready, we 
-		 * should retry.
-		 */
-		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
-			return NEEDS_RETRY;
-		/*
 		 * if the device is not started, we need to wake
 		 * the error handler to start the motor
 		 */
@@ -1405,7 +1399,10 @@ int scsi_decide_disposition(struct scsi_
 	} else {
 		/*
 		 * no more retries - report this one back to upper level.
+		 * clear retries in case the command is requeued by
+		 * upper level.
 		 */
+		scmd->retries = 0;
 		return SUCCESS;
 	}
 }
