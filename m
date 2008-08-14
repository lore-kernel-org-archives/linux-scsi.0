From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] ieee1394: sbp2: enforce s/g segment size limit
Date: Thu, 14 Aug 2008 09:12:01 +0200 (CEST)
Message-ID: <tkrat.84add1a51a966d30@s5r6.in-berlin.de>
References: <da824cf30808121004w1ea59dc9rd805e2ae4d9f47a7@mail.gmail.com>
	<20080813084514K.fujita.tomonori@lab.ntt.co.jp>
	<tkrat.a77de871a8213efc@s5r6.in-berlin.de>
	<20080814095549S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080814095549S.fujita.tomonori@lab.ntt.co.jp>
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
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: grundler@google.com, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14 Aug, FUJITA Tomonori wrote:
> On Wed, 13 Aug 2008 12:19:59 +0200 (CEST)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> I keep the original scsi_sg_count to call dma_unmap_sg with it
>> later.
> 
> You need to keep it? You can access to it via scsi_sg_count when
> calling dma_unmap_sg? Seems that firewire code does.

Yes, I can easily do it this way; fixed below.

[...nents in dma_unmap_sg...]
> This is from Documentation/DMA-mapping.txt

Right.  How did I forget about that?



From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: sbp2: remove redundant struct members

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   14 +++++---------
 drivers/ieee1394/sbp2.h |    4 ----
 2 files changed, 5 insertions(+), 13 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -656,11 +656,11 @@ static struct sbp2_command_info *sbp2uti
 static void sbp2util_mark_command_completed(struct sbp2_lu *lu,
 					    struct sbp2_command_info *cmd)
 {
-	if (cmd->sg_buffer) {
-		dma_unmap_sg(lu->ud->ne->host->device.parent, cmd->sg_buffer,
-			     cmd->sg_count, cmd->sg_dir);
-		cmd->sg_buffer = NULL;
-	}
+	if (scsi_sg_count(cmd->Current_SCpnt) > 0)
+		dma_unmap_sg(lu->ud->ne->host->device.parent,
+			     scsi_sglist(cmd->Current_SCpnt),
+			     scsi_sg_count(cmd->Current_SCpnt),
+			     cmd->Current_SCpnt->sc_data_direction);
 	list_move_tail(&cmd->list, &lu->cmd_orb_completed);
 }
 
@@ -1505,10 +1505,6 @@ static int sbp2_prep_command_orb_sg(stru
 	if (n == 0)
 		return -ENOMEM;
 
-	cmd->sg_buffer = sg;
-	cmd->sg_count = sg_count;
-	cmd->sg_dir = dma_dir;
-
 	orb->data_descriptor_hi = ORB_SET_NODE_ID(hi->host->node_id);
 	orb->misc |= ORB_SET_DIRECTION(orb_direction);
 
Index: linux/drivers/ieee1394/sbp2.h
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.h
+++ linux/drivers/ieee1394/sbp2.h
@@ -252,10 +252,6 @@ struct sbp2_command_info {
 	struct sbp2_unrestricted_page_table
 		scatter_gather_element[SG_ALL] __attribute__((aligned(8)));
 	dma_addr_t sge_dma;
-
-	struct scatterlist *sg_buffer;
-	int sg_count;
-	enum dma_data_direction sg_dir;
 };
 
 /* Per FireWire host */


-- 
Stefan Richter
-=====-==--- =--- -===-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
