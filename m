From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] sym53c8xx: Read buffer overflow
Date: Sun, 09 Aug 2009 16:16:47 +0200
Message-ID: <4A7EDA4F.6080402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:44679 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZHIONE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2009 10:13:04 -0400
Received: by ewy10 with SMTP id 10so2501567ewy.37
        for <linux-scsi@vger.kernel.org>; Sun, 09 Aug 2009 07:13:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Prevent read from div_10M[-1] when no clock divisor was greater.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Can this happen?

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 297deb8..230add3 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -542,6 +542,9 @@ sym_getsync(struct sym_hcb *np, u_char dt, u_char sfac, u_char *divp, u_char *fa
 	while (div-- > 0)
 		if (kpc >= (div_10M[div] << 2)) break;
 
+	if (div < 0)
+		return -1;
+
 	/*
 	 *  Calculate the lowest clock factor that allows an output 
 	 *  speed not faster than the period, and the max output speed.
