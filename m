Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA72C38A2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiJZXZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiJZXY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED32CE21;
        Wed, 26 Oct 2022 16:23:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMITxd014921;
        Wed, 26 Oct 2022 23:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TZk6ghsPowBpUzDbo1ylVpomuPUCb5oWOrKm7/jKlyw=;
 b=p/471CG6mJzdISPAc+Hbot16ihwLbLEK96btuhUoE5yk0ckEeWQ39PzzJSFSmaxfLGPs
 SgF+Ngln15l26z21Ha6/YZThKvJcOSP6s/5dk4ZXWA8nnQGBFR9OUFW/3/7X9MOo69TH
 27mxlhhConnF+sYw0mCgN/SFVLx/O9z85INaNM79+JMrbJyaoIpXLFeMkAva77b00KCa
 TMj+dlwW0oaSl94qq2eVwJuY2jyrgEL3r4uMBSxX2XH8/a7CE5xOA70wp6svUOvljuNC
 Omgxk/G8FR61mc9QJwWhkE/rmzFdOhfnqocRwko6YtwQUFll7mMJW8s+xcgQrb3qOSSK Mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0aghy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM16LE009431;
        Wed, 26 Oct 2022 23:20:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagedtke-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEatAiVnY1+BKiFRy49obXHx/Ql+qb1ZiAC4tS/WmXUjGu4YsVjQhUaxv0ANXdledUD8aSPFKc0ZO0noVvlePGp0pl1hc+O46pE1E8Tv0D4osTGLwMcnPel29CAqMqSw+CrnAz011tPhSz4slAJtww6/Z2qHcCIN77SW+0tTvEYJgOvPcJMBCktrB3V+8tSoBWlNRYqXGLwplLayrhZry/hyoY+wFQbj5JClnsGAovHYWHggCZs+FtupTft3GgGEPU9isTheLoJmYi0D6OAKQJ0q4B1xCHCF3geycCLiiclNzps/XBiNdcYfULfov1je3hV8RFI2aRmM3sDci87pAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZk6ghsPowBpUzDbo1ylVpomuPUCb5oWOrKm7/jKlyw=;
 b=ME1zKUMnOoPMlZTXUmE4UUM1M3yh4T0BhUqhkHRkmS4mKck3SCGoNYzjeb8eV/fC6fHQCyVNZLlE9nv7/p0RRL062vhPa+CjORkZvCGs6DXg3vtn1b6QvGV92hGN9i6VJdqLeDqcFu25VhA6LCZ6BzJkHxHq4fI1yrekgMF3dJTSDvInZ+IwTIyJtpsAf9xyUHLuB+B8Rw34y608sxM1MiwNwRkymcMMKdL+5ZWGQOO+IFLhq91vvZfWb3OZdtOAwBiNJxVCMMk7xtdp+8d5GyjFiH56b+y9LuApHCA28MTR19ee1XxehkY8mVVvQXmWa6nk1w348SqMHynb4oIFJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZk6ghsPowBpUzDbo1ylVpomuPUCb5oWOrKm7/jKlyw=;
 b=F3mnNXlmz+UATLXHVOb5NA1wn7VER9kQVdw01UIVHgaIoRzyiqPGt4Z02aCrAZs0SUtxGTV95CEl+ewr4CNCcOAvoqq+Hv8hz3/abG5VotUc/QIUrZWxoMIm6pguRSkDuQ4alP+XPBBQqwxFfkRC+1Tl9gONoC7XIlALl5JTUbk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 17/19] scsi: target: Allow backends to hook into PR handling
Date:   Wed, 26 Oct 2022 18:19:43 -0500
Message-Id: <20221026231945.6609-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0056.namprd18.prod.outlook.com
 (2603:10b6:610:55::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: f8e73db1-0960-4c91-aee7-08dab7a8a26f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ogIpKGBPYN/E5Dwp0fiQ4C0FPkLtBBqL4Mz4WmBk9v6oDN6crSQKB9xJD9q8INpmG2EL8BFoaOjqFGLYtbF62Bnz+j3MvIndnmqxOizR3KQDw2hSJhOH4Dj7Saffk/W6S9TkfXOH/9BkIuC3xPI9M6Nn6ZrC7HrM5P2cwwQyoXlxJm06t8+zlyCCow4aRb8wot2cUXTt1trKedTnFXZfpW3x+uQbdUVplyOX95Tx+xPrERPUzLfrKAuNsOqLlob/uNr8BAWY1MHBY9UmIaDyiiq7TiTpfnsxqXfLSniSzcaLKiCcca7ugRS7q58+p41nqbXr5+rQ9T2Cl4Ja3snaKuK1ABTB+nP7KZ1solMA7D3OzSQ/KBvFPQkvsoK+m/iLZFIxtAgEJFlrHQpWrMojGUqjk6UyC14J8EcGt2aNb54PrausZAeBKFtlI6lUi9RvlwaIH9jwoOzj6KhGcz+M9019hijdkPR+uJKhIDJV6FN/c9Q5TrabOTrPAR7QJCac0vH/8F2a6g1YAdSbgV8MDQM1712fC/krXQO9zT7IzgLuH2VI161xK5BSxOdgOjP60pyuFsY30UrxHt+xw/+2o4QxC4R5RLxN9uZimEmKku6Wqb/2n4MrrI9Eh0RDpZhFFrJR35fKHq5+MZ2J1CbqM6UmzsHpQ2dWQKL8zVhBQxRpfLYp6YX/bl73f0FSeXnoPu9Gl1prY+PNAC3RZ+U+rgNOmVjFHuce69qH4e5+ObYe1M+O3MlDbcDwRTcA+Qf5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P81LKLKe762S9GHcoZNqOsoGuL1Vw/UCy8Wu+5p6gFK4eKyjEIlmb3pVtHIZ?=
 =?us-ascii?Q?3+KfI53a1KvHdncYRqP9IfeT4RaOpI8k2hDNStXIOFOQE1ysG/8jzeLnTE9g?=
 =?us-ascii?Q?YcP1tTeE7KMudLKtSb9X5p8CQ8XYBh/bibdIqpujENh/VmzuCXYKRh1VaSOc?=
 =?us-ascii?Q?z4tON+L2vhwgsBbeaKDoEPar+URG8WD1O83ahZTg59bgfdYOl6nOoNQR9pQk?=
 =?us-ascii?Q?xsrmwcyz/cRgWeOnW4xl8y+leV/1tTSDvWUuUTxdX71NqDahCgd6nc8fz8Qd?=
 =?us-ascii?Q?M+JS2tmbQO6uyUPM49wghBmXGqau+2fhwz0thEuKQc1WARPOXhqdIzXeoi1G?=
 =?us-ascii?Q?WhUK089+RANyuIdlPYJs3oyFKZ647/WNlOYsFU9K+x4gkrQewEDl4fz/Ubc6?=
 =?us-ascii?Q?LPQEX70iTWLVrmtqzV050wOZED7+L3ALOLbKFBNK/o78nUYJs5Y17XYKta+/?=
 =?us-ascii?Q?uhblp5RSz8wojZ5FjRVKNjW/qiST9QQQ7Nk8vdcsWb9mmF6JS5sgcny+oLdL?=
 =?us-ascii?Q?LS4khaq1MUxzPTQ4hZ9MJlDI8iblVaF6voXO/nRoQ9fHc8KdQ4VY8x/Tau4Y?=
 =?us-ascii?Q?VDJ+nlYjiHjU0whDN/nF4GqXxNkSsyHBssq+reuzZ89I2qeuH/2abvMEJTOI?=
 =?us-ascii?Q?K9ay0rcQNA/Fks9VP+LfVCp9FzsWcXfQdoHsAMMq5gyXGmRHgxPQcg/Kb2VW?=
 =?us-ascii?Q?kzqNczBBohs8xfQ72pSpNVW0sOcFv5nFtQ6b8CUHT76FYyxqxcgSSbjsewpT?=
 =?us-ascii?Q?x7xNUEK4bIjuO0PNJPsmHfP8TaBqA3tL1xh06eCURswO5bQdHsuvm70cRnRc?=
 =?us-ascii?Q?HP6j8qsOXJS6sUEA9cMYK11gAh6kgcZX5IkB5wcHVhm1kgw+PbTW3tNYigPD?=
 =?us-ascii?Q?BPm54b5iajTZe6NbI/gzQ46DmF7gt6P+DU0UT08NusSuvsqL77BfkTrmeqvL?=
 =?us-ascii?Q?uij3TurEvR46nSjS+gZfBZzKcrBj3ozq7JXa4Td+pfXqtChrF8rTWcMt6X/m?=
 =?us-ascii?Q?NRn1Rdmi78pIUZm4a/+abLN00ood2RmqLLUKmrDd0Tg0WoqIUSxfiUY+WfPc?=
 =?us-ascii?Q?2SUQ08gA33B0kFbZa7R/pqvqpaJy15o8TyiLIIj5lF/+KSpKUVnoGl52ocWq?=
 =?us-ascii?Q?Nu8JtsoMFCCk765MRX726TuthdIZU+it34OcDNGyJ9nuU+W/50ykj2wtuRaQ?=
 =?us-ascii?Q?R8bjx7PcRUcqV+I5jd0wroqNGB1Dm4ThzMbZsQZQjA1uq7OK8664Iy8Sj1HL?=
 =?us-ascii?Q?vPFCpF190jYZKKd1A2o0dcvOiGOEBLPaVPgXGDTiK62AnLfAbkRgoyg3nmd5?=
 =?us-ascii?Q?ePXf0PWkXmXZnVPfgmw1Qo/5Xy0IztRI3AVgOB6FmBtqXehtKJF0woeGfCY9?=
 =?us-ascii?Q?4J4c50+8L71txR5IWOSPTFoYwALYwoMZDMb62o1ZaxMNmAhUivXSiIaJHod4?=
 =?us-ascii?Q?Eet3qNHKhJ/YQ5NEnu5ow0kFSvsYmGGqbHTluBr31n9juH1m+wCx9qHJgWh6?=
 =?us-ascii?Q?/t6LkdTbuchsXxQVm+amuOwGLTUkRTHC+rFhjEIQMOy9/+Nck++ixMA25liN?=
 =?us-ascii?Q?0NWTTNiiIQCxnvbKKazfSEqBdlIepGaGR58lzDZ1SOag1bDJj9Wzqiz+ksPt?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e73db1-0960-4c91-aee7-08dab7a8a26f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:13.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cOYrmjDHEUU2/pQdYYfsTj1UogUrncCSJvRiMU9Hh3o25USYH6pEF1Rc0xAsqeWJ/PJoOExdZxOemvjQcNrMTwReZVXSHt7070oCFc510cM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: R1JEE5MDYzceQnTmmx1GYK9HGhP5uhZn
X-Proofpoint-ORIG-GUID: R1JEE5MDYzceQnTmmx1GYK9HGhP5uhZn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For the cases where you want to export a device to a VM via a single
I_T nexus and want to passthrough the PR handling to the physical/real
device you have to use pscsi or tcmu. Both are good for specific uses
however for the case where you want good performance, and are not using
SCSI devices directly (using DM/MD RAID or multipath devices) then we are
out of luck.

The following patches allow iblock to mimimally hook into the LIO PR code
and then pass the PR handling to the physical device. Note that like with
the tcmu an pscsi cases it's only supported when you export the device via
one I_T nexus.

This patch adds the initial LIO callouts. The next patch will modify
iblock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_pr.c      | 60 ++++++++++++++++++++++++++++
 include/target/target_core_backend.h |  5 +++
 2 files changed, 65 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a1d67554709f..ac85f2b87c4d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3519,6 +3519,26 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	return ret;
 }
 
+static sense_reason_t
+target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
+		     u8 type, bool aptpl, bool all_tg_pt, bool spec_i_pt)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	if (!ops->execute_pr_out) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type,
+				   aptpl, all_tg_pt, spec_i_pt);
+}
+
 /*
  * See spc4r17 section 6.14 Table 170
  */
@@ -3622,6 +3642,12 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_out_pt(cmd, sa, res_key, sa_res_key, type,
+					   aptpl, all_tg_pt, spec_i_pt);
+		goto done;
+	}
+
 	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
@@ -3663,6 +3689,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
@@ -4020,6 +4047,33 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+	unsigned char *buf;
+	sense_reason_t ret;
+
+	if (cmd->data_length < 8) {
+		pr_err("PRIN SA SCSI Data Length: %u too small\n",
+		       cmd->data_length);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (!ops->execute_pr_in) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->execute_pr_in(cmd, cmd->t_task_cdb[1] & 0x1f, buf);
+
+	transport_kunmap_data_sg(cmd);
+	return ret;
+}
+
 sense_reason_t
 target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 {
@@ -4041,6 +4095,11 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 	}
 
+	if (cmd->se_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_in_pt(cmd);
+		goto done;
+	}
+
 	switch (cmd->t_task_cdb[1] & 0x1f) {
 	case PRI_READ_KEYS:
 		ret = core_scsi3_pri_read_keys(cmd);
@@ -4060,6 +4119,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index c5df78959532..84bfdfb14997 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -69,6 +69,11 @@ struct exec_cmd_ops {
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
+	sense_reason_t (*execute_pr_out)(struct se_cmd *cmd, u8 sa, u64 key,
+					 u64 sa_key, u8 type, bool aptpl,
+					 bool all_tg_pt, bool spec_i_pt);
+	sense_reason_t (*execute_pr_in)(struct se_cmd *cmd, u8 sa,
+					unsigned char *param_data);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
2.25.1

