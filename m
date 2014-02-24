From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: [PATCH]: qla2xxx: Fix kernel panic on selective retransmission request.
Date: Mon, 24 Feb 2014 13:59:53 -0600
Message-ID: <201402241959.s1OJxrn2007544@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:52522 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaBXU3x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 15:29:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net

From: Dr. Greg Wettstein <greg@enjellic.com> 

qla2xxx: Fix kernel panic on selective retransmission request.
    
A selective retransmission request (SRR) is a fibre-channel
protocol control request which provides support for requesting
retransmission of a data sequence in response to an issue such as
frame loss or corruption.  These events are experienced
infrequently in fibre-channel based networks which makes
it difficult to test and assess codepaths which handle these
events.
    
We were fortunate enough, for some definition of fortunate, to
have a metro-area single-mode SAN link which, at 10 GBPS
sustained load levels, would consistently generate SRR's in
a SCST based target implementation using our SCST/in-kernel
Qlogic target interface driver.  In response to an SRR the
in-kernel Qlogic target driver immediately panics resulting
in a catastrophic storage failure for serviced initiators.
    
The culprit was a debug statement in the qla_target.c file which
does not verify that a pointer to the SCSI CDB is not null.
The unchecked pointer dereference results in the kernel panic
and resultant system failure.
    
The other two references to the SCSI CDB by the SRR handling code
use a ternary operator to verify a non-null pointer is being
acted on.  This patch simply adds a similar test to the implicated
debug statement.

This patch is a candidate for any stable kernel being maintained
since it addresses a potentially catastrophic event with
minimal downside.
    
Signed-off-by: Dr. Greg Wettstein <greg@enjellic.com>
---
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2eb97d7..8cb91b4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3185,7 +3185,8 @@ restart:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
 		    "SRR cmd %p (se_cmd %p, tag %d, op %x), "
 		    "sg_cnt=%d, offset=%d", cmd, &cmd->se_cmd, cmd->tag,
-		    se_cmd->t_task_cdb[0], cmd->sg_cnt, cmd->offset);
+		    se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
+		    cmd->sg_cnt, cmd->offset);
 
 		qlt_handle_srr(vha, sctio, imm);
 
---
As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"We came, we saw, we fought, we conquered the multi-headed beast which
 is storage for isochronous video delivery."

 Any questions on the project summary?
                                -- Dr. Greg Wettstein
                                   Resurrection
