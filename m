From: Matthew Wilcox <matthew@wil.cx>
Subject: [2.6.16 PATCH] Fix uninitialised width and speed in sym2
Date: Tue, 28 Feb 2006 06:28:15 -0700
Message-ID: <20060228132815.GI27759@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:20439 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750774AbWB1N2S
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 08:28:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sym2 boards without NVRAM currently negotiate narrow due to this missed
initialisation

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.82.2.1
retrieving revision 1.82
diff -u -p -r1.82.2.1 -r1.82
--- ./drivers/scsi/sym53c8xx_2/sym_hipd.c	28 Feb 2006 05:25:44 -0000	1.82.2.1
+++ ./drivers/scsi/sym53c8xx_2/sym_hipd.c	27 Feb 2006 14:11:31 -0000	1.82
@@ -919,6 +922,8 @@ static int sym_prepare_setting(struct Sc
 
 		tp->usrflags |= (SYM_DISC_ENABLED | SYM_TAGS_ENABLED);
 		tp->usrtags = SYM_SETUP_MAX_TAG;
+		tp->usr_width = np->maxwide;
+		tp->usr_period = 9;
 
 		sym_nvram_setup_target(tp, i, nvram);
 
