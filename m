From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 2/4] scsi_debug: fix group_number mask 0x1f->0x3f
Date: Mon, 11 Dec 2017 20:10:06 -0500
Message-ID: <20171212011008.27689-3-dgilbert@interlog.com>
References: <20171212011008.27689-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59798 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751234AbdLLBKL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Dec 2017 20:10:11 -0500
In-Reply-To: <20171212011008.27689-1-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, bart.vanassche@sandisk.com, hare@suse.de

Various cdb masks incorrectly assumed the GROUP NUMBER field was
5 bits long. It is actually 6 bits long. Correct.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 68f4ab8ffbaf..05661387ccaf 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -422,7 +422,7 @@ static const struct opcode_info_t mselect_iarr[1] = {
 
 static const struct opcode_info_t read_iarr[3] = {
 	{0, 0x28, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL,/* READ(10) */
-	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
 	{0, 0x8, 0, F_D_IN | FF_DIRECT_IO, resp_read_dt0, NULL, /* READ(6) */
 	    {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -433,7 +433,7 @@ static const struct opcode_info_t read_iarr[3] = {
 
 static const struct opcode_info_t write_iarr[3] = {
 	{0, 0x2a, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,   /* 10 */
-	    {10,  0xfb, 0xff, 0xff, 0xff, 0xff, 0x1f, 0xff, 0xff, 0xc7, 0, 0,
+	    {10,  0xfb, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },
 	{0, 0xa, 0, F_D_OUT | FF_DIRECT_IO, resp_write_dt0, NULL,    /* 6 */
 	    {6,  0xff, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -466,7 +466,7 @@ static const struct opcode_info_t maint_in_iarr[2] = {
 static const struct opcode_info_t write_same_iarr[1] = {
 	{0, 0x93, 0, F_D_OUT_MAYBE | FF_DIRECT_IO, resp_write_same_16, NULL,
 	    {16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
-	     0xff, 0xff, 0xff, 0x1f, 0xc7} },
+	     0xff, 0xff, 0xff, 0x3f, 0xc7} },
 };
 
 static const struct opcode_info_t reserve_iarr[1] = {
@@ -548,22 +548,22 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
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
