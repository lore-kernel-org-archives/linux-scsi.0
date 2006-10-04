From: Andy Warner <andyw@pobox.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Wed, 4 Oct 2006 13:29:29 -0500
Message-ID: <20061004132929.A29689@florence.linkmargin.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02.rdc-kc.rr.com ([24.94.166.122]:35761 "EHLO
	ms-smtp-02.rdc-kc.rr.com") by vger.kernel.org with ESMTP
	id S1750884AbWJDT32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 15:29:28 -0400
Content-Disposition: inline
In-Reply-To: <20061004164438.GC5091@rhun.haifa.ibm.com>; from muli@il.ibm.com on Wed, Oct 04, 2006 at 06:44:38PM +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Muli Ben-Yehuda wrote:
> [resending as it probably hit the 100K limit the first time]
> 
> I'm seeing these aic94xx IO errors on an IBM x366, usually after I
> copy ~20GB but occasionally as soon as heavy IO starts. Happens with
> and without Calgary enabled (iommu=off). I'm seeing this on two
> different disks which badblocks claims are ok. The machine usually
> stays up and keeps chugging along after this happens.

Since you're working in this area, the processing for REQ_TASK_ABORT,
REQ_DEVICE_RESET, SIGNAL_NCQ_ERROR and CLEAR_NCQ_ERROR needs fixing as
all 4 events collapse to REQ_TASK_ABORT, because sb_opcode is masked
with ~DL_PHY_MASK before the switch() in escb_tasklet_complete(). In
unpatched code, check the phy number reported in the REQ_TASK_ABORT message:

  0 => REQ_TASK_ABORT
  1 => REQ_DEVICE_RESET
  2 => SIGNAL_NCQ_ERROR
  3 => CLEAR_NCQ_ERROR

So you are seeing legitimate REQ_TASK_ABORT values, but need to look
at the remaining data to see what the chip is trying to tell you.
For REQ_TASK_ABORT, status_block[1..2] is the transaction context,
and status_block[3] is the reason (TC_NO_ERROR etc from aic94xx_sas.h)

Here's a patch (quick, suboptimal & compile tested only) that improves
the decode and logs the reason, but doesn't actually process the
events any more usefully. Hope it applies to your tree. Report
back with the reason(s) and then track back to the port/device
using the transaction context in status_block[1..2].

Signed-off-by: Andy Warner <andyw@pobox.com>

--- a/drivers/scsi/aic94xx/aic94xx_scb.c	2006-10-04 13:22:35.821333918 -0500
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c	2006-10-04 14:17:07.505966527 -0500
@@ -389,39 +389,41 @@ static void escb_tasklet_complete(struct
 		sas_phy_disconnected(sas_phy);
 		sas_ha->notify_port_event(sas_phy, PORTE_TIMER_EVENT);
 		break;
-	case REQ_TASK_ABORT:
-		ASD_DPRINTK("%s: phy%d: REQ_TASK_ABORT\n", __FUNCTION__,
-			    phy_id);
-		break;
-	case REQ_DEVICE_RESET:
-		ASD_DPRINTK("%s: phy%d: REQ_DEVICE_RESET\n", __FUNCTION__,
-			    phy_id);
-		break;
-	case SIGNAL_NCQ_ERROR:
-		ASD_DPRINTK("%s: phy%d: SIGNAL_NCQ_ERROR\n", __FUNCTION__,
-			    phy_id);
-		break;
-	case CLEAR_NCQ_ERROR:
-		ASD_DPRINTK("%s: phy%d: CLEAR_NCQ_ERROR\n", __FUNCTION__,
-			    phy_id);
-		break;
 	default:
-		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __FUNCTION__,
-			    phy_id, sb_opcode);
-		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n",
-			    edb, dl->opcode);
-		ASD_DPRINTK("sb_opcode : 0x%x, phy_id: 0x%x\n",
-			    sb_opcode, phy_id);
-		ASD_DPRINTK("escb: vaddr: 0x%p, "
-			    "dma_handle: 0x%llx, next: 0x%llx, "
-			    "index:%d, opcode:0x%02x\n",
-			    ascb->dma_scb.vaddr,
-			    (unsigned long long)ascb->dma_scb.dma_handle,
-			    (unsigned long long)
-			    le64_to_cpu(ascb->scb->header.next_scb),
-			    le16_to_cpu(ascb->scb->header.index),
-			    ascb->scb->header.opcode);
+		switch(sb_opcode) {
+		case REQ_TASK_ABORT:
+			ASD_DPRINTK("%s: REQ_TASK_ABORT, reason 0x%02x\n",
+					__FUNCTION__, dl->status_block[3]);
+			break;
+		case REQ_DEVICE_RESET:
+			ASD_DPRINTK("%s: REQ_DEVICE_RESET, reason 0x%02x\n",
+					__FUNCTION__, dl->status_block[3]);
+			break;
+		case SIGNAL_NCQ_ERROR:
+			ASD_DPRINTK("%s: SIGNAL_NCQ_ERROR\n", __FUNCTION__);
+			break;
+		case CLEAR_NCQ_ERROR:
+			ASD_DPRINTK("%s: CLEAR_NCQ_ERROR\n", __FUNCTION__);
+			break;
+		default:
+			ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __FUNCTION__,
+				    phy_id, sb_opcode);
+			ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n",
+				    edb, dl->opcode);
+			ASD_DPRINTK("sb_opcode : 0x%x, phy_id: 0x%x\n",
+				    sb_opcode, phy_id);
+			ASD_DPRINTK("escb: vaddr: 0x%p, "
+				    "dma_handle: 0x%llx, next: 0x%llx, "
+				    "index:%d, opcode:0x%02x\n",
+				    ascb->dma_scb.vaddr,
+				    (unsigned long long)ascb->dma_scb.dma_handle,
+				    (unsigned long long)
+				    le64_to_cpu(ascb->scb->header.next_scb),
+				    le16_to_cpu(ascb->scb->header.index),
+				    ascb->scb->header.opcode);
 
+			break;
+		}
 		break;
 	}
 
-- 
andyw@pobox.com

Andy Warner		Voice: (612) 801-8549	Fax: (208) 575-5634
