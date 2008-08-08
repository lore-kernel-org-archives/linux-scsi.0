From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: avoid DMA bounce buffers for ORBs
Date: Fri, 8 Aug 2008 14:00:42 +0200 (CEST)
Message-ID: <tkrat.6abbce7c47a1f236@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
	<1217877676.3318.32.camel@localhost.localdomain>
	<48975F5F.90906@s5r6.in-berlin.de> <489845FC.4080104@panasas.com>
	<48986B55.80403@s5r6.in-berlin.de> <489871B7.5050904@panasas.com>
	<tkrat.4aaf6794a4dd49c1@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.4aaf6794a4dd49c1@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

The command ORB pool is used frequently during the whole lifetime of an
SBP-2 logical unit.  It doesn't make sense to let it live outside the
32bit DMA zone.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.27-rc2/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.27-rc2.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.27-rc2/drivers/ieee1394/sbp2.c
@@ -531,7 +531,7 @@ static int sbp2util_create_command_orb_p
 	int i, orbs = sbp2_serialize_io ? 2 : SBP2_MAX_CMDS;
 
 	for (i = 0; i < orbs; i++) {
-		cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+		cmd = kzalloc(sizeof(*cmd), GFP_KERNEL | GFP_DMA32);
 		if (!cmd)
 			return -ENOMEM;
 		cmd->command_orb_dma = dma_map_single(hi->host->device.parent,

-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
