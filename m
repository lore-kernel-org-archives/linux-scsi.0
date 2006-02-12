From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] sym2: Mask off opcode from RBC
Date: Sun, 12 Feb 2006 09:28:19 -0700
Message-ID: <20060212162819.GF12822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:62862 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750814AbWBLQ2V
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 11:28:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


pm->sg.size is set from the Residual Byte Count register.  However,
the upper byte of the RBC is the opcode of the instruction that was
executing, so we need to mask it off.  This fixes some spurious rejects
of IGNORE WIDE RESIDUE messages.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

[James, please apply to scsi-rc-fixes]

Index: ./drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/lib/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.79
retrieving revision 1.80
diff -u -p -r1.79 -r1.80
--- ./drivers/scsi/sym53c8xx_2/sym_hipd.c	12 Feb 2006 16:10:34 -0000	1.79
+++ ./drivers/scsi/sym53c8xx_2/sym_hipd.c	12 Feb 2006 16:17:03 -0000	1.80
@@ -3596,7 +3596,7 @@ static int sym_evaluate_dp(struct sym_hc
 
 	if (pm) {
 		dp_scr  = scr_to_cpu(pm->ret);
-		dp_ofs -= scr_to_cpu(pm->sg.size);
+		dp_ofs -= scr_to_cpu(pm->sg.size) & 0x00ffffff;
 	}
 
 	/*
