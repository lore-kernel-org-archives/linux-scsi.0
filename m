From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 2/5] scsi_debug: fix group_number mask
Date: Wed, 13 Dec 2017 20:40:13 -0500
Message-ID: <20171214014016.13142-3-dgilbert@interlog.com>
References: <20171214014016.13142-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40138 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbdLNBkW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Dec 2017 20:40:22 -0500
In-Reply-To: <20171214014016.13142-1-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, bart.vanassche@sandisk.com, hare@suse.de

Various cdb masks incorrectly assumed the GROUP NUMBER field
was 5 bits long. It is actually 6 bits long. Correct.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 80a775b6e648..428165dbd486 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -421,23 +421,23 @@ static const struct opcode_info_t mselect_iarr[1] = {
 
 static const struct opcode_info_t read_iarr[3] = {
 	{0, 0x28, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL,/* READ(10) */
-	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
 	{0, 0x8, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL, /* READ(6) */
 	    {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0xa8, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL,/* READ(12) */
-	    {12,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x9f,
+	    {12,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf,
 	     0xc7, 0, 0, 0, 0} },
 };
 
 static const struct opcode_info_t write_iarr[3] = {
 	{0, 0x2a, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,   /* 10 */
-	    {10,  0xfb, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	    {10,  0xfb, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
 	{0, 0xa, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,    /* 6 */
 	    {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0xaa, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,   /* 12 */
-	    {12,  0xfb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x9f,
+	    {12,  0xfb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf,
 	     0xc7, 0, 0, 0, 0} },
 };
 
@@ -449,7 +449,7 @@ static const struct opcode_info_t sa_in_iarr[1] = {
 
 static const struct opcode_info_t vl_iarr[1] = {	/* VARIABLE LENGTH */
 	{0, 0x7f, 0xb, F_SA_HIGH | F_D_OUT | FF_DIRECT_IO, resp_write_dt0,
-	    NULL, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0xb, 0xfa,
+	    NULL, {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0xb, 0xfa,
 		   0, 0xff, 0xff, 0xff, 0xff} },	/* WRITE(32) */
 };
 
@@ -465,7 +465,7 @@ static const struct opcode_info_t maint_in_iarr[2] = {
 static const struct opcode_info_t write_same_iarr[1] = {
 	{0, 0x93, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, resp_write_same_16, NULL,
 	    {16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-	     0xff, 0xff, 0xff, 0x1f, 0xc7} },
+	     0xff, 0xff, 0xff, 0x3f, 0xc7} },
 };
 
 static const struct opcode_info_t reserve_iarr[1] = {
@@ -508,11 +508,11 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	     0, 0} },
 	{3, 0x88, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, read_iarr,
 	    {16,  0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-	     0xff, 0xff, 0xff, 0x9f, 0xc7} },		/* READ(16) */
+	     0xff, 0xff, 0xff, 0xff, 0xc7} },		/* READ(16) */
 /* 10 */
 	{3, 0x8a, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, write_iarr,
 	    {16,  0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-	     0xff, 0xff, 0xff, 0x9f, 0xc7} },		/* WRITE(16) */
+	     0xff, 0xff, 0xff, 0xff, 0xc7} },		/* WRITE(16) */
 	{0, 0x1b, 0, 0, resp_start_stop, NULL,		/* START STOP UNIT */
 	    {6,  0x1, 0, 0xf, 0xf7, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{1, 0x9e, 0x10, F_SA_LOW | F_D_IN, resp_readcap16, sa_in_iarr,
@@ -529,7 +529,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7,
 	     0, 0, 0, 0, 0, 0} },
 	{1, 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_DIRECT_IO, resp_read_dt0,
-	    vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x1f, 0x18, 0x0, 0x9, 0xfe, 0,
+	    vl_iarr, {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0x9, 0xfe, 0,
 		      0xff, 0xff, 0xff, 0xff} },/* VARIABLE LENGTH, READ(32) */
 	{1, 0x56, 0, F_D_OUT, NULL, reserve_iarr, /* RESERVE(10) */
 	    {10,  0xff, 0xff, 0xff, 0, 0, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0,
@@ -547,22 +547,22 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{0, 0x1d, F_D_OUT, 0, NULL, NULL,	/* SEND DIAGNOSTIC */
 	    {6,  0xf7, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{0, 0x42, 0, F_D_OUT | FF_DIRECT_IO, resp_unmap, NULL, /* UNMAP */
-	    {10,  0x1, 0, 0, 0, 0, 0x1f, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
+	    {10,  0x1, 0, 0, 0, 0, 0x3f, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
 	{0, 0x53, 0, F_D_IN | F_D_OUT | FF_DIRECT_IO, resp_xdwriteread_10,
-	    NULL, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7,
+	    NULL, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7,
 		   0, 0, 0, 0, 0, 0} },
 	{0, 0x3b, 0, F_D_OUT_MAYBE, resp_write_buffer, NULL,
 	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },			/* WRITE_BUFFER */
 	{1, 0x41, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, resp_write_same_10,
-	    write_same_iarr, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff,
+	    write_same_iarr, {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff,
 			      0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
 	{0, 0x35, 0, F_DELAY_OVERR | FF_DIRECT_IO, NULL, NULL, /* SYNC_CACHE */
-	    {10,  0x7, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	    {10,  0x7, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
 	{0, 0x89, 0, F_D_OUT | FF_DIRECT_IO, resp_comp_write, NULL,
 	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
-	     0, 0xff, 0x1f, 0xc7} },		/* COMPARE AND WRITE */
+	     0, 0xff, 0x3f, 0xc7} },		/* COMPARE AND WRITE */
 
 /* 30 */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
-- 
2.14.1
