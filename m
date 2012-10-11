From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/2] tcm_qla2xxx: Format VPD page 83h SCSI name string according to SPC
Date: Thu, 11 Oct 2012 13:41:31 -0700
Message-ID: <1349988092-27640-2-git-send-email-roland@kernel.org>
References: <1349988092-27640-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:51576 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759277Ab2JKUlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2012 16:41:39 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so940815dak.19
        for <linux-scsi@vger.kernel.org>; Thu, 11 Oct 2012 13:41:38 -0700 (PDT)
In-Reply-To: <1349988092-27640-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

My draft of SPC-4 says the following about the SCSI name string in
inquiry VPD page 83h:

    The SCSI NAME STRING field starts with either:

    a) the four UTF-8 characters 'eui.' concatenated with 16, 24, or
       32 hexadecimal digits (i.e., the UTF-8 characters 0 through 9
       and A through F) for an EUI-64 based identifier (see
       7.8.6.5). The first hexadecimal digit shall be the most
       significant four bits of the first byte (i.e., most significant
       byte) of the EUI-64 based identifier;
    b) the four UTF-8 characters 'naa.' concatenated with 16 or 32
       hexadecimal digits for an NAA identifier (see 7.8.6.6). The
       first hexadecimal digit shall be the most significant four bits
       of the first byte (i.e., most significant byte) of the NAA
       identifier; or
    c) the four UTF-8 characters 'iqn.' concatenated with an iSCSI
       Name for an iSCSI-name based identifier (see iSCSI).

However, the .tpg_get_wwn method for tcm_qla2xxx formats the WWN so
the SCSI name string looks like "52:4a:93:7d:24:5f:b2:12,t,0x0001".
This patch corrects the code so that VPD 83h gives a SPC-compliant
SCSI name string like "naa.524a937d245fb212,t,0x0001" while leavig
other uses alone (so configfs will still work with ':' separated WWNs).

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 +++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2358c16..d8211cc 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -237,7 +237,7 @@ static char *tcm_qla2xxx_get_fabric_wwn(struct se_portal_group *se_tpg)
 				struct tcm_qla2xxx_tpg, se_tpg);
 	struct tcm_qla2xxx_lport *lport = tpg->lport;
 
-	return &lport->lport_name[0];
+	return lport->lport_naa_name;
 }
 
 static char *tcm_qla2xxx_npiv_get_fabric_wwn(struct se_portal_group *se_tpg)
@@ -1534,6 +1534,7 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 	lport->lport_wwpn = wwpn;
 	tcm_qla2xxx_format_wwn(&lport->lport_name[0], TCM_QLA2XXX_NAMELEN,
 				wwpn);
+	sprintf(lport->lport_naa_name, "naa.%016llx", (unsigned long long) wwpn);
 
 	ret = tcm_qla2xxx_init_lport(lport);
 	if (ret != 0)
@@ -1601,6 +1602,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 	lport->lport_npiv_wwnn = npiv_wwnn;
 	tcm_qla2xxx_npiv_format_wwn(&lport->lport_npiv_name[0],
 			TCM_QLA2XXX_NAMELEN, npiv_wwpn, npiv_wwnn);
+	sprintf(lport->lport_naa_name, "naa.%016llx", (unsigned long long) npiv_wwpn);
 
 /* FIXME: tcm_qla2xxx_npiv_make_lport */
 	ret = -ENOSYS;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 8254981..9ba075f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -61,6 +61,8 @@ struct tcm_qla2xxx_lport {
 	u64 lport_npiv_wwnn;
 	/* ASCII formatted WWPN for FC Target Lport */
 	char lport_name[TCM_QLA2XXX_NAMELEN];
+	/* ASCII formatted naa WWPN for VPD page 83 etc */
+	char lport_naa_name[TCM_QLA2XXX_NAMELEN];
 	/* ASCII formatted WWPN+WWNN for NPIV FC Target Lport */
 	char lport_npiv_name[TCM_QLA2XXX_NPIV_NAMELEN];
 	/* map for fc_port pointers in 24-bit FC Port ID space */
-- 
1.7.10.4

