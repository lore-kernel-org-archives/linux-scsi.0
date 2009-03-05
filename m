From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v3 09/15] NULL noise: drivers/scsi/FlashPoint.c
Date: Thu, 05 Mar 2009 22:55:04 +0100
Message-ID: <20090305215455.23866.57598.stgit@f10box.hanneseder.net>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
	     <20090305191602.30062.71301.stgit@f10box.hanneseder.net>
	      <1236283546.5626.45.camel@localhost.localdomain>
	       <154e089b0903051215q1216aa53icd41556e2af8b234@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:59816 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZCEV4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 16:56:13 -0500
In-Reply-To: <154e089b0903051215q1216aa53icd41556e2af8b234@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: trivial@kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

Fix this sparse warnings:
  drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
  drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
  drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
v2: fix checkpatch.pl issue.
v2.1: other subject, as suggested by Al Viro
v3: no need to explicitly initialize the variables, as they are in the
    .bss section anyway (pointed out by James Bottomley)

 drivers/scsi/FlashPoint.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index b898d38..ac67307 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -902,13 +902,12 @@ static unsigned char FPT_scmachid(unsigned char p_card,
 static void FPT_autoCmdCmplt(unsigned long p_port, unsigned char p_card);
 static void FPT_autoLoadDefaultMap(unsigned long p_port);
 
-static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
-    { {{0}} };
-static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {0} };
-static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { {{0}} };
-static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { {0} };
+static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR];
+static struct sccb_card FPT_BL_Card[MAX_CARDS];
+static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR];
+static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS];
 
-static unsigned char FPT_mbCards = 0;
+static unsigned char FPT_mbCards;
 static unsigned char FPT_scamHAString[] =
     { 0x63, 0x07, 'B', 'U', 'S', 'L', 'O', 'G', 'I', 'C',
 	' ', 'B', 'T', '-', '9', '3', '0',
@@ -916,10 +915,9 @@ static unsigned char FPT_scamHAString[] =
 	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
 };
 
-static unsigned short FPT_default_intena = 0;
+static unsigned short FPT_default_intena;
 
-static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {
-0};
+static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char);
 
 /*---------------------------------------------------------------------
  *

