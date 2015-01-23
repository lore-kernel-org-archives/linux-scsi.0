From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 07/17] sbp2: Fix bidi command test
Date: Fri, 23 Jan 2015 15:05:13 +0100
Message-ID: <20150123150513.13fb8682@kant>
References: <54C2390A.3000700@sandisk.com>
	<54C23A02.9010807@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <54C23A02.9010807@sandisk.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Jan 23 Bart Van Assche wrote:
> The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/sbp2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index 64ac8f8..ab1b114 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1467,7 +1467,7 @@ static int sbp2_scsi_queuecommand(struct Scsi_Host *shost,
>  	 * Bidirectional commands are not yet implemented, and unknown
>  	 * transfer direction not handled.
>  	 */
> -	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
> +	if (scsi_bidi_cmnd(cmd)) {
>  		dev_err(lu_dev(lu), "cannot handle bidirectional command\n");
>  		cmd->result = DID_ERROR << 16;
>  		cmd->scsi_done(cmd);

---- 8< ----

Subject: [PATCH] firewire: sbp2: remove redundant check for bidi command

[Bart van Asche:]  SCSI core never sets cmd->sc_data_direction to
DMA_BIDIRECTIONAL, scsi_bidi_cmnd(cmd) should be used instead.

[Christoph Hellwig:]  Bidirectional commands won't ever be queued
anyway, unless a LLD or transport driver sets QUEUE_FLAG_BIDI.

So, simply remove the respective queuecommand check in the SBP-2
transport driver.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1463,17 +1463,6 @@ static int sbp2_scsi_queuecommand(struct
 	struct sbp2_command_orb *orb;
 	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 
-	/*
-	 * Bidirectional commands are not yet implemented, and unknown
-	 * transfer direction not handled.
-	 */
-	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
-		dev_err(lu_dev(lu), "cannot handle bidirectional command\n");
-		cmd->result = DID_ERROR << 16;
-		cmd->scsi_done(cmd);
-		return 0;
-	}
-
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL)
 		return SCSI_MLQUEUE_HOST_BUSY;


-- 
Stefan Richter
-=====-===== ---= =-===
http://arcgraph.de/sr/

------------------------------------------------------------------------------
New Year. New Location. New Benefits. New Data Center in Ashburn, VA.
GigeNET is offering a free month of service with a new server in Ashburn.
Choose from 2 high performing configs, both with 100TB of bandwidth.
Higher redundancy.Lower latency.Increased capacity.Completely compliant.
http://p.sf.net/sfu/gigenet
