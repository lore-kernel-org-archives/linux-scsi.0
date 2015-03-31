From: Daniel Kreling <kreling@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6] ipr: Fix possible error path oops during initialization
Date: Tue, 31 Mar 2015 10:49:29 -0300
Message-ID: <551AA5E9.1030905@linux.vnet.ibm.com>
References: <201503261623.t2QGNtSX003713@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:55008 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbbCaNti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2015 09:49:38 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <kreling@linux.vnet.ibm.com>;
	Tue, 31 Mar 2015 07:49:36 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 382EE19D8026
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 07:40:40 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2VDlkLJ28704992
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 06:47:46 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2VDnWDE017006
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 07:49:32 -0600
In-Reply-To: <201503261623.t2QGNtSX003713@d03av03.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, dan.carpenter@oracle.com

** Adding 'Reviewed-by' tag **

=46ixes a possible oops during adapter initialization in some
memory allocation failure error paths scenarios.

Reported-by: Dan Carpenter

Signed-off-by: Brian King
Reviewed-by: Daniel Kreling
---

  drivers/scsi/ipr.c |   14 ++++++++------
  1 file changed, 8 insertions(+), 6 deletions(-)


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

diff -puN drivers/scsi/ipr.c~ipr_free_cmd_blks_oops drivers/scsi/ipr.c

--- linux/drivers/scsi/ipr.c~ipr_free_cmd_blks_oops    2015-03-26=20
11:14:41.465782868 -0500

+++ linux-bjking1/drivers/scsi/ipr.c    2015-03-26 11:14:41.471782829 -=
0500

@@ -9061,1 +9061,1 @@

static=B7void=B7ipr_free_cmd_blks(struct=B7ipr

  {
      int i;
-    for (i =3D 0; i < IPR_NUM_CMD_BLKS; i++) {
-        if (ioa_cfg->ipr_cmnd_list[i])
-            dma_pool_free(ioa_cfg->ipr_cmd_pool,
-                      ioa_cfg->ipr_cmnd_list[i],
-                      ioa_cfg->ipr_cmnd_list_dma[i]);
+    if (ioa_cfg->ipr_cmnd_list) {
+        for (i =3D 0; i < IPR_NUM_CMD_BLKS; i++) {
+            if (ioa_cfg->ipr_cmnd_list[i])
+                dma_pool_free(ioa_cfg->ipr_cmd_pool,
+                          ioa_cfg->ipr_cmnd_list[i],
+                          ioa_cfg->ipr_cmnd_list_dma[i]);

-        ioa_cfg->ipr_cmnd_list[i] =3D NULL;
+            ioa_cfg->ipr_cmnd_list[i] =3D NULL;
+        }
      }

      if (ioa_cfg->ipr_cmd_pool)
_

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
