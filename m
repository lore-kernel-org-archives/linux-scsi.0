From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [Patch] scsi_dh_rdac: retry IO for 06/3f/03 in
	rdac_check_sense fn
Date: Mon, 2 Aug 2010 13:07:25 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB24902991CCA21@inbmail02.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch adds retry for the IO returned with 06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in rdac_check_sense(). IO returned with 06/3f/03 from controller are currently failed by scsi mid layer, as a reason momentarily path failure is noticed by DM multipath. 

Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>
Reviewed-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
---

diff -uprN linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c
--- linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-22 15:13:38.000000000 -0400
+++ linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-27 12:13:58.000000000 -0400
@@ -738,6 +738,11 @@ static int rdac_check_sense(struct scsi_
 			 * Quiescence in progress , just retry.
 			 */
 			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
+			/*
+			 * INQUIRY DATA has changed, retry again.
+			 */
+			return ADD_TO_MLQUEUE;
 		break;
 	}
 	/* success just means we do not care what scsi-ml does */

--
