Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E73C47257
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 21:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D776214D8
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 21:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgD3VeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:34:08 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:54945 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgD3VeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 17:34:08 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MBlgy-1jKPRO2P7c-00CAl1; Thu, 30 Apr 2020 23:33:46 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@SteelEye.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 13/15] scsi: sas: avoid gcc-10 zero-length-bounds warning
Date:   Thu, 30 Apr 2020 23:30:55 +0200
Message-Id: <20200430213101.135134-14-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Tij/Kp5SwKUhjG30C/bCLnQ40qQlaQDnfS4eB2TiFRLUOoReIgO
 Uve4poc8gqTByejdFMSMTbXXNX/NxzKv5T9zugR5eHiWbAjhJmGlx+2BBvuxR6JAVdV/1EQ
 1fdrcKt+4tTHyB7fAeB6oMluR6RJ2X6imecINN6izUjHLPCJaOZJo26erjiprH8p28GZ8VV
 cHewMZZqRY9In9Z8ideeA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4+zXPanuvnw=:PWwkvbgpjR2mhreEII4Fj0
 CqSLh1dXafv4dZ7n4lWhQ9Ast7nFtTbkCoCR22k+O52B49d8/N/dgtvv+wc4/uao7Pk6D6PoY
 4MAtED1dya9H0gMwXzi+/MYaRQWOEJQCejlZgIb8AIqM42rDsIyCZc2/vmgMz7E9AOKf3OCb3
 QfJBjbtC4KRLTbENxGbVa3yIzGnf7NGcxbQXHQdjm0gNcG5n2G11GdqN1xMIRkzlRLXNtH+z2
 m8fvwwwW5Vo94Nh2HMan9eA/JFckJ0v7T8GPhcv7PqbRQpHs5KMtd+nAB9cxcSdZFQvlkq+iu
 Z76R5wuy9yh9baDX+TTAjOmJfFJGm8kAAv66Y8TxNtnwiWEleK3DLohZ5aOY6taEYwWEHoyf8
 F9mQENzzykPewo8elzI+nU0uMoqX3Y87ec3ou2zLzv76k4ODZC2Ap6hZqVRu9+zAc1qms6nbe
 OZJz8qr6g3vLdA/BaKkznTf5APh+0ptV5i2wgj3cf+e+4epz8uYeaHV5XUE6iALbU8Hc84RjU
 T7v5jwXwHJfkM5PWbLrNyQkDOexhxmktY459IHbgNZu7NS0LXROlcqqoD6C1Lmf+PD2Wjnpfj
 tVE1GCOKdNCZBl1PllJdcO9FVmf1hAJDjNgpj7T3i/mQhV+fNf2s5cDXpvsjbWKiOg7bL7V8O
 e7ACjlfIDowg2+2JvNaf9xhRmn2pHSyjx7yjOsUUwJxb6HNq/YQDY6Sn0d9z/xFknyO0A6NyX
 xOGrySVHGtA8OgRFFUMbXF+GuTm41/I4fNG4ecm0QKRYaAVQnCOzYw7FkwYqfm98jDrL5Zwlv
 djjOEKTF6jRi9Ru+QHILl4EUf2x6uroVjS1LsIYYGWLsZjSTHg=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two files access the zero-length resp_data[] array, which now
causes a compiler warning:

drivers/scsi/aic94xx/aic94xx_tmf.c: In function 'asd_get_tmf_resp_tasklet':
drivers/scsi/aic94xx/aic94xx_tmf.c:291:22: warning: array subscript 3 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
  291 |   res = ru->resp_data[3];
      |         ~~~~~~~~~~~~~^~~
In file included from include/scsi/libsas.h:15,
                 from drivers/scsi/aic94xx/aic94xx.h:16,
                 from drivers/scsi/aic94xx/aic94xx_tmf.c:11:
include/scsi/sas.h:557:9: note: while referencing 'resp_data'
  557 |  u8     resp_data[0];
      |         ^~~~~~~~~
drivers/scsi/libsas/sas_task.c: In function 'sas_ssp_task_response':
drivers/scsi/libsas/sas_task.c:21:30: warning: array subscript 3 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
   21 |   tstat->stat = iu->resp_data[3];
      |                 ~~~~~~~~~~~~~^~~
In file included from include/scsi/scsi_transport_sas.h:8,
                 from drivers/scsi/libsas/sas_internal.h:14,
                 from drivers/scsi/libsas/sas_task.c:3:
include/scsi/sas.h:557:9: note: while referencing 'resp_data'
  557 |  u8     resp_data[0];
      |         ^~~~~~~~~

This should really be a flexible-array member, but the structure
already has such a member, swapping it out with sense_data[] would
cause many more warnings elsewhere.

As a workaround, add a temporary pointer that can be accessed without
a warning.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Fixes: 366ca51f30de ("[SCSI] libsas: abstract STP task status into a function")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aic94xx/aic94xx_tmf.c | 4 +++-
 drivers/scsi/libsas/sas_task.c     | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index f814026f26fa..a3139f9766c8 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -269,6 +269,7 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 	struct ssp_frame_hdr *fh;
 	struct ssp_response_iu   *ru;
 	int res = TMF_RESP_FUNC_FAILED;
+	u8 *resp;
 
 	ASD_DPRINTK("tmf resp tasklet\n");
 
@@ -287,8 +288,9 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 	fh = edb->vaddr + 16;
 	ru = edb->vaddr + 16 + sizeof(*fh);
 	res = ru->status;
+	resp = ru->resp_data;
 	if (ru->datapres == 1)	  /* Response data present */
-		res = ru->resp_data[3];
+		res = resp[3];
 #if 0
 	ascb->tag = fh->tag;
 #endif
diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index e2d42593ce52..4cd2f9611c4a 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -12,13 +12,14 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 			   struct ssp_response_iu *iu)
 {
 	struct task_status_struct *tstat = &task->task_status;
+	u8 *resp = iu->resp_data;
 
 	tstat->resp = SAS_TASK_COMPLETE;
 
 	if (iu->datapres == 0)
 		tstat->stat = iu->status;
 	else if (iu->datapres == 1)
-		tstat->stat = iu->resp_data[3];
+		tstat->stat = resp[3];
 	else if (iu->datapres == 2) {
 		tstat->stat = SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
-- 
2.26.0

