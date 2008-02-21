From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [2.6 patch] scsi/qla4xxx/ql4_isr.c: remove dead code
Date: Thu, 21 Feb 2008 03:43:00 -0800
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC0701277989@AVEXCH1.qlogic.org>
References: <20080220025525.GG23759@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:36368 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYBULnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2008 06:43:03 -0500
Content-class: urn:content-classes:message
In-reply-to: <20080220025525.GG23759@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

 
Andrew Vasquez wrote:
<snip>
> > > Hmm, guess it's the earlier 'if (scsi_status == 0)' check 
> a few lines
> > > up...  Dave S., can you take a look at this...  Thanks, av
> > 
> > Ah, so the !scsi_status is wrong it was supposed to be 
> scsi_status !=
> > 0 ... and even then it can just be dropped.
> 
> My guess is that the check should have been written as:
> 
> 	...
> 	if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER)
> 		scsi_set_resid(cmd, residual);
> 		if ((scsi_bufflen(cmd) - residual) < cmd->underflow) {
> 			...
> 
> It looks to be a logic-error while porting from qla2xxx, where
> scsi_status during CS_COMPLETE is the full 16-bit status (high-byte is
> transport, low-byte SCSI status) from from the FCP_RSP frame (not so
> in iSCSI, where it's just the SCSI-status) and the residual check
> in qla_isr.c::qla2x00_status_entry() looks like:
> 
> 	if (!lscsi_status &&
> 	    ((unsigned)(scsi_bufflen(cp) - resid) <
> 	     cp->underflow)) {
> 		...
> 
> I'll defer to Dave S. for verification.
> 
The correct patch needs to be 

Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>

---

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c
b/drivers/scsi/qla4xxx/ql4_isr.c
index 0f029d0..fc84db4 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -100,8 +100,7 @@ static void qla4xxx_status_entry(struct
 
 		if (sts_entry->iscsiFlags &ISCSI_FLAG_RESIDUAL_UNDER) {
 			scsi_set_resid(cmd, residual);
-			if (!scsi_status && ((scsi_bufflen(cmd) -
residual) <
-				cmd->underflow)) {
+			if ((scsi_bufflen(cmd) - residual) <
cmd->underflow) {
 
 				cmd->result = DID_ERROR << 16;
 
