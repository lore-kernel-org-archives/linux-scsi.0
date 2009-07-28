From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] u14-34f: Buffer overflow
Date: Tue, 28 Jul 2009 15:45:48 +0200
Message-ID: <4A6F010C.2080605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57782 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZG1NnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2009 09:43:02 -0400
Received: by ewy26 with SMTP id 26so24331ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2009 06:43:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ballabio_dario@emc.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

This allows i == MAX_INT_PARAM, which is out of range for ints[]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with Parfait, http://research.sun.com/projects/parfait/

diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 54023d4..26e8e0e 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1070,7 +1070,7 @@ static int option_setup(char *str) {
    char *cur = str;
    int i = 1;
 
-   while (cur && isdigit(*cur) && i <= MAX_INT_PARAM) {
+   while (cur && isdigit(*cur) && i < MAX_INT_PARAM) {
       ints[i++] = simple_strtoul(cur, NULL, 0);
 
       if ((cur = strchr(cur, ',')) != NULL) cur++;
