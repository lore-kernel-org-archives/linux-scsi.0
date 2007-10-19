From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 3/4] aic7xxx: Fix firmware build
Date: Fri, 19 Oct 2007 10:32:34 +0200
Message-ID: <20071019083235.596E318C61E@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966335AbXJSIcP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 04:32:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


If a prefix is selected for flex, we should be using it everywhere.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
index f06e703..c0457b8 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
@@ -66,6 +66,7 @@ static char string_buf[MAX_STR_CONST];
 static char *string_buf_ptr;
 static int  parren_count;
 static char buf[255];
+int  mmlineno;
 %}
 
 WORD		[A-Za-z_][-A-Za-z_0-9]*
@@ -76,7 +77,7 @@ MCARG		[^(), \t]+
 
 %%
 \n			{
-				++yylineno;
+				++mmlineno;
 			}
 \r			;
 <ARGLIST>{SPACE}	;
-- 
1.5.2.4

