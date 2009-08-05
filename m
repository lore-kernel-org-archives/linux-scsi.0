From: giridhar.malavali@qlogic.com
Subject: [RESEND - PATCH 06/12] qla2xxx: Correct display of vp_count in debug printk.
Date: Tue,  4 Aug 2009 23:38:21 -0700
Message-ID: <1249454301-2662-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:40619 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755595AbZHEGiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Aug 2009 02:38:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
>>On Fri, 2009-07-31 at 15:09 -0700, giridhar.malavali@qlogic.com wrote:
>>From: Andrew Vasquez <andrew.vasquez@qlogic.com>
>>
>>VP IDX need to be converted to proper endian for NPIV
>>to work on PPC platforms.
>>
>>This description doesn't seem quite right; it implies there's an NPIV
>>failure on PPC.  whereas the patch
>>
>>		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
>>			" number of VPs acquired %d\n", __func__, vha->host_no,
>>-			MSB(rptid_entry->vp_count), LSB(rptid_entry->vp_count)));
>>+			MSB(le16_to_cpu(rptid_entry->vp_count)),
>>+			LSB(le16_to_cpu(rptid_entry->vp_count))));
>>
>>Is altering the way a debug print works, which isn't fixing anything.  I
>>assume NPIV works fine on PPC but prints the wrong debug values?
>>
>>James

I have changed the description to reflect the patch contents. This patch was to correct
display of vp_count properly in debug printk. Can u please apply the patch.

- Giri
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index fe69f30..8fcd99e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2746,7 +2746,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	if (rptid_entry->format == 0) {
 		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
 			" number of VPs acquired %d\n", __func__, vha->host_no,
-			MSB(rptid_entry->vp_count), LSB(rptid_entry->vp_count)));
+			MSB(le16_to_cpu(rptid_entry->vp_count)),
+			LSB(le16_to_cpu(rptid_entry->vp_count))));
 		DEBUG15(printk("%s primary port id %02x%02x%02x\n", __func__,
 			rptid_entry->port_id[2], rptid_entry->port_id[1],
 			rptid_entry->port_id[0]));
-- 
1.6.2.rc1.30.gd43c

