From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: qla2xxx: qla_mr.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 23:54:56 +0200
Message-ID: <1410731696-18247-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/qla2xxx/qla_mr.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 4775baa..23bc7e2 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1868,21 +1868,21 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			phost_info = &preg_hsi->hsi;
 			memset(preg_hsi, 0, sizeof(struct register_host_info));
 			phost_info->os_type = OS_TYPE_LINUX;
-			strncpy(phost_info->sysname,
+			strlcpy(phost_info->sysname,
 			    p_sysid->sysname, SYSNAME_LENGTH);
-			strncpy(phost_info->nodename,
+			strlcpy(phost_info->nodename,
 			    p_sysid->nodename, NODENAME_LENGTH);
 			if (!strcmp(phost_info->nodename, "(none)"))
 				ha->mr.host_info_resend = true;
-			strncpy(phost_info->release,
+			strlcpy(phost_info->release,
 			    p_sysid->release, RELEASE_LENGTH);
-			strncpy(phost_info->version,
+			strlcpy(phost_info->version,
 			    p_sysid->version, VERSION_LENGTH);
-			strncpy(phost_info->machine,
+			strlcpy(phost_info->machine,
 			    p_sysid->machine, MACHINE_LENGTH);
-			strncpy(phost_info->domainname,
+			strlcpy(phost_info->domainname,
 			    p_sysid->domainname, DOMNAME_LENGTH);
-			strncpy(phost_info->hostdriver,
+			strlcpy(phost_info->hostdriver,
 			    QLA2XXX_VERSION, VERSION_LENGTH);
 			do_gettimeofday(&tv);
 			preg_hsi->utc = (uint64_t)tv.tv_sec;
-- 
1.7.10.4
