From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/9] qla2xxx: Validate mid-layer 'underflow' during	check-condition
 handling.
Date: Sun, 22 Jul 2007 17:28:55 +0300
Message-ID: <46A369A7.2000401@panasas.com>
References: <20070719220456.GK4015@plap.qlogic.org>	 <11848827641168-git-send-email-andrew.vasquez@qlogic.com>	 <46A3366D.9070807@panasas.com> <1185111751.3431.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26995 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753330AbXGVO3J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 10:29:09 -0400
In-Reply-To: <1185111751.3431.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

James Bottomley wrote:
> On Sun, 2007-07-22 at 13:50 +0300, Boaz Harrosh wrote:
>> NACK. Breaks data buffers accessors patch. (385d70b4e2659ae525a00e46a9f97146949cfc14)
>> should be:
> 
> This isn't bad enough to eject the entire qla enhancement from the tree
> on the day the merge window closes to force a rewrite.
> 
Sorry I did not realize this was for the 2.6.23 merge window
I assumed it is already for the next kernel. You are absolutely
right I'm just nit picking here.

> 
> Could you respin an update against scsi-misc for -rc1?
> 
> Thanks,
> 
> James
> 
> 

You bet:

From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 22 Jul 2007 17:24:18 +0300
Subject: [PATCH] qla2xxx: Data accessors Cleanup of last merge

    - Left overs from last code merges of qla2xxx

Sign-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b8f226a..50539da 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1068,7 +1068,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			 * values.
 			 */
 			if (resid &&
-			    ((unsigned)(cp->request_bufflen - resid) <
+			    ((unsigned)(scsi_bufflen(cp) - resid) <
 			     cp->underflow)) {
 				DEBUG2(qla_printk(KERN_INFO, ha,
 				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
@@ -1076,7 +1076,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 				    "error status.\n", ha->host_no,
 				    cp->device->channel, cp->device->id,
 				    cp->device->lun, resid,
-				    cp->request_bufflen));
+				    scsi_bufflen(cp)));
 
 				cp->result = DID_ERROR << 16 | lscsi_status;
 			}
-- 
1.5.2.2.249.g45fd

