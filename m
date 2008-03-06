From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libsas: Check that the firmware loader is present in
	sas_request_addr
Date: Thu, 6 Mar 2008 13:02:13 -0800
Message-ID: <20080306210212.GC7430@tree.beaverton.ibm.com>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com> <20080306181645.GA6046@kroah.com> <47D03666.9080000@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35053 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935161AbYCFVCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 16:02:15 -0500
Content-Disposition: inline
In-Reply-To: <47D03666.9080000@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>

Return an error code in sas_request_addr if the fw loader isn't
configured.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 601ec5b..e44be7a 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1085,6 +1085,7 @@ static void sas_parse_addr(u8 *sas_addr, const char *p)
 
 int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
 {
+#ifdef CONFIG_FW_LOADER
 	int res;
 	const struct firmware *fw;
 
@@ -1102,6 +1103,9 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
 out:
 	release_firmware(fw);
 	return res;
+#else
+	return -ENOENT;
+#endif
 }
 EXPORT_SYMBOL_GPL(sas_request_addr);
 
