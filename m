Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82EDCCA479
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 02:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiGSCHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 22:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236794AbiGSCHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 22:07:10 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A273CBED;
        Mon, 18 Jul 2022 19:07:03 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IMdcaV011679;
        Mon, 18 Jul 2022 19:07:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=date : message-id :
 in-reply-to : references : from : subject : to : cc; s=pfptdkimsnps;
 bh=SNxVebTkJtrdJ3jPqQRlMFu+48h4yZEszNJ0G8H3mvI=;
 b=pNqwmCjJtKSUiwJS1UODYPs+NbyPA2F3nFj+F7IOfR4kQaPDDxR6lJnKLWCgYXSSHf2s
 V8SFM1glTQ5unHGNzwfGL5iEw1/HZsoPaUBJoow6GfFWhSebz8e21iVr0lOQclwP2VWZ
 h5tcKlF89UZuanhmf7phv3sdyZsszDYbHpo5T7hbcIqMQGOcbYdsgTOeHZnVJfxMIW5P
 ysd31Ns13y19DUx+MjoodJb6ioM1zYXk/GIwL5bPoUcvMHI70oPh3NA9b8SyXcwVBNWz
 p4aO7tVNEzVwLol1cpi/MvKUm2seDIVXR6DcrwoaY9t6RF7d0tCRfX8ueJYgNhFn0xto 1w== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3hbvk5wnv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 19:07:01 -0700
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 82DF040097;
        Tue, 19 Jul 2022 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1658196421; bh=stlln6nZ9iLk2UzcbhO1hBFrRMvJ8sq1R2eq5f9T1nc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=TqTlAcYKEZJO+gN3fr7knjYGL+FY7LBxECmn8cvzJtSH+BvZHd7sGrvpwIvSVJdIE
         u4WvrM2V5BIGIz9AFWrvx4huJmUprMlElQjv8YeUTW/G8mpI4VJXDncbJAiu58ASDX
         EHLRFqti3F1ezw1U49sp09jrOSudILZRx9b/bljUENqlwl2/tpyK/VBPdSgLqx99UY
         XhZ8Qtl15CASDVP1DiDpFsQbJmRhvoyJFKlix9ax2tSarDBEH2kDxSRfujT9bzpVNi
         wGLVSTQl6E8DCQXM6GDB+sOF2ZyGrXsAmRzvByHtTRDnc6AIDFJKHi9J2pL0VLGjq9
         CdWaC91n6j6Gw==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 6477CA0062;
        Tue, 19 Jul 2022 02:07:00 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Mon, 18 Jul 2022 19:07:00 -0700
Date:   Mon, 18 Jul 2022 19:07:00 -0700
Message-Id: <41806206e78812afe97101a11881f5a33092a93b.1658195608.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1658195608.git.Thinh.Nguyen@synopsys.com>
References: <cover.1658195608.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH v2 1/4] target: Handle MI_REPORT_SUPPORTED_OPERATION_CODES
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
X-Proofpoint-GUID: ipO6XqndCbxzJR7rx7-FAIMM4N6Oc3iW
X-Proofpoint-ORIG-GUID: ipO6XqndCbxzJR7rx7-FAIMM4N6Oc3iW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 bulkscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207190006
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Microsoft Windows checks for MI_REPORT_SUPPORTED_OPERATION_CODES. Let's
handle this MAINTENANCE_IN command and report supported commands.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 Changes in v2:
 - Fix spec section number
 - Fix potential invalid "buf" access on error

 drivers/target/target_core_alua.c | 70 +++++++++++++++++++++++++++++++
 drivers/target/target_core_alua.h |  2 +
 drivers/target/target_core_spc.c  | 14 ++++++-
 3 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index b56ef8af66e7..881e04ce8544 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -259,6 +259,76 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	return 0;
 }
 
+/*
+ * REPORT_SUPPORTED_OPERATION_CODES
+ *
+ * See spc4r37 section 6.35
+ */
+sense_reason_t
+target_emulate_report_supported_opcodes(struct se_cmd *cmd)
+{
+	unsigned char *cdb = cmd->t_task_cdb;
+	unsigned char *buf;
+
+	/*
+	 * Only supports reporting option 1.
+	 * i.e. one command parameter with no service action.
+	 */
+	if ((cdb[2] & 0x7) != 1) {
+		pr_warn("Unsupported reporting op code %d\n", cdb[2]);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	switch (cdb[3]) {
+	case INQUIRY:
+	case MODE_SENSE:
+	case MODE_SENSE_10:
+	case READ_CAPACITY:
+	case SERVICE_ACTION_IN_16:
+	case REPORT_LUNS:
+	case REQUEST_SENSE:
+	case SYNCHRONIZE_CACHE:
+	case REZERO_UNIT:
+	case SEEK_6:
+	case SEEK_10:
+	case TEST_UNIT_READY:
+	case SEND_DIAGNOSTIC:
+	case MAINTENANCE_IN:
+	case READ_6:
+	case READ_10:
+	case READ_16:
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_16:
+	case VERIFY_16:
+	case MODE_SELECT:
+	case MODE_SELECT_10:
+	case START_STOP:
+	case SECURITY_PROTOCOL_IN:
+	case SECURITY_PROTOCOL_OUT:
+		/* Supported */
+		buf[1] = 3;
+		break;
+	case ATA_12:
+	case ATA_16:
+	case VERIFY:
+	case ZBC_IN:
+	case ZBC_OUT:
+	default:
+		/* Not supported */
+		buf[1] = 1;
+		break;
+	}
+
+	transport_kunmap_data_sg(cmd);
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
+	return 0;
+}
+
 /*
  * SET_TARGET_PORT_GROUPS for explicit ALUA operation.
  *
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index fc9637cce825..7941e4dd4f97 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -82,6 +82,8 @@ extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
 extern struct kmem_cache *t10_alua_lba_map_cache;
 extern struct kmem_cache *t10_alua_lba_map_mem_cache;
 
+extern sense_reason_t
+target_emulate_report_supported_opcodes(struct se_cmd *cmd);
 extern sense_reason_t target_emulate_report_target_port_groups(struct se_cmd *);
 extern sense_reason_t target_emulate_set_target_port_groups(struct se_cmd *);
 extern sense_reason_t target_emulate_report_referrals(struct se_cmd *);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c14441c89bed..dd799158609d 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1425,15 +1425,25 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		break;
 	case MAINTENANCE_IN:
 		if (dev->transport->get_device_type(dev) != TYPE_ROM) {
+			u8 action = cdb[1] & 0x1f;
+
 			/*
 			 * MAINTENANCE_IN from SCC-2
 			 * Check for emulated MI_REPORT_TARGET_PGS
 			 */
-			if ((cdb[1] & 0x1f) == MI_REPORT_TARGET_PGS) {
+			if (action == MI_REPORT_TARGET_PGS) {
 				cmd->execute_cmd =
 					target_emulate_report_target_port_groups;
+
+				*size = get_unaligned_be32(&cdb[6]);
+			}
+
+			if (action == MI_REPORT_SUPPORTED_OPERATION_CODES) {
+				cmd->execute_cmd =
+					target_emulate_report_supported_opcodes;
+
+				*size = get_unaligned_be16(&cdb[2]);
 			}
-			*size = get_unaligned_be32(&cdb[6]);
 		} else {
 			/*
 			 * GPCMD_SEND_KEY from multi media commands
-- 
2.28.0

