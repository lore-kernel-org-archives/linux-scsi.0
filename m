From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 5/9] zfcp: fix adapter (re)open recovery while link
 to SAN is down
Date: Fri, 26 Apr 2013 17:32:14 +0200
Message-ID: <517A9DFE.7060207@linux.vnet.ibm.com>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com> <1366985635-38270-6-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1366985635-38270-6-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>, stable@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

FCP device remains in status ERP_FAILED when device is switched online
or adapter recovery is triggered  while link to SAN is down.

When Exchange Configuration Data command returns the FSF status
FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE it aborts the exchange process.
The only retries are done during the common error recovery procedure
(i.e. max. 3 retries with 8sec sleep between) and remains in status
ERP_FAILED with QDIO down.

This commit reverts the commit 0df138476c8306478d6e726f044868b4bccf411c
(zfcp: Fix adapter activation on link down).
When FSF status FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE is received the
adapter recovery will be finished without any retries. QDIO will be
up now and status changes such as LINK UP will be received now.

Signed-off-by: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> #2.6.37+
---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -563,6 +563,10 @@ static void zfcp_fsf_exchange_config_dat
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;

+		/* avoids adapter shutdown to be able to recognize
+		 * events such as LINK UP */
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
