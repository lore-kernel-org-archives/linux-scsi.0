From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: prepare for s/g chaining
Date: Tue, 15 Jan 2008 21:11:28 +0100 (CET)
Message-ID: <tkrat.070bfc631ede4143@s5r6.in-berlin.de>
References: <1200419579.9273.39.camel@localhost.localdomain>
	<tkrat.dd08f05252acff9a@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.dd08f05252acff9a@s5r6.in-berlin.de>
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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Replacement of patch "ieee1394: sbp2: enable s/g chaining".

It's the same, minus '+ .use_sg_chaining = ENABLE_SG_CHAINING,' hunk
to prevent conflicts when James is going to remove .use_sg_chaining.


 drivers/ieee1394/sbp2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -1489,7 +1490,7 @@ static void sbp2_prep_command_orb_sg(str
 
 		/* loop through and fill out our SBP-2 page tables
 		 * (and split up anything too large) */
-		for (i = 0, sg_count = 0 ; i < count; i++, sgpnt++) {
+		for (i = 0, sg_count = 0; i < count; i++, sgpnt = sg_next(sgpnt)) {
 			sg_len = sg_dma_len(sgpnt);
 			sg_addr = sg_dma_address(sgpnt);
 			while (sg_len) {

-- 
Stefan Richter
-=====-==--- ---= -====
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
