Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E269FA3746
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiJZXZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiJZXYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9ED27934;
        Wed, 26 Oct 2022 16:22:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMW9lD000954;
        Wed, 26 Oct 2022 23:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=nCTYX8irgEBcxjkGaeVbK/DFoeKIEcEGtO+2BRQT0OM=;
 b=LkRGnd2Gus/gg2eF8goxtSiT/QXZBmhU7NVeRumlCP4rAmkpFDIymybtqcr7fWkGpK9f
 ApHO+W8sfTmpyHk5VY+7+RzVplmdpNobSJxuX6DBDuWA1lIBnb921MMkAqRgzbleq0eY
 1b52FHJ2kS66lC23C+ckTuSPtobxol22n7EfKfx0NAOkShwfXpEQf1FpsluhL5g8SBhZ
 0ZRN23bEtcGDTnhx6CvE4wDokyqUDQrcWc9X5vSV6wbwRy7f0kUL6rtq/gXzMkUZxPCK
 X79efQjJyGYWrQ/G+4KiklRhBjFyuClBzVEVW/cutTEJGSi5hVweDWWzKe7O/r3Tm69w dA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7rgsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLcp5x026565;
        Wed, 26 Oct 2022 23:20:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagpdxe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kg984A7SvAoab9aR+o7hlEUmNgoVmneVgTB5YN+TePcyBMTvtw05xLr1WeRJRtuEpW8/Z8cMU7j2esmup3Wy32yv7v7uSSdkeDfjlXKtaBCyqAQ84lhPObRrp9ORXrxd/E6apEs1pqbzhovAvdmn2qbM6/wSAt/21yNeBqtvFaiqYZib73xYLfXcAmSg56UZYOgUCzojwHCUHl/Jnms0qARHWQzc17Vhf5xvqAK5dN9Xi20ui93OO48ufHVbvL7hl4Uu3r0IXHTpBS6gKLMZLYEJXMao4GgZIYdJBJfFF0Q6VWU/wEsHh7EkSawv1+1AxWwJIjW0UuXb59YwUf08KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCTYX8irgEBcxjkGaeVbK/DFoeKIEcEGtO+2BRQT0OM=;
 b=gwXHiO/bUAKd9Bkx3LROfmFgMfdft7EvCRlvqfp7SN3lSeQPhOQGaw/uKa0RLaEOIRDbYQ991WHSvfptruInAKUljqUUBVGkDbwp9+sElDJcwf5FpbeMUmyeURu8DgDsjrEz+g+7ggXAALrVKdTCbF7aSUZN13Mwx1iuaeRq+8e1UGYPC9897HvFezhq/fmmJVRlMXRanahygeYEcBeJKpq+yC8HVzftEx4hSy6IZFiCM7jB5JZDFqFaVwO0f7SoFgJ7hHQvHwxxkWfUZ6pf3OdmWcFNRJDoOYiVEfIC0XWlGkHJspqCPB0GYP1Vxxh/zmiw42nW8NCblFQNTXc2Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCTYX8irgEBcxjkGaeVbK/DFoeKIEcEGtO+2BRQT0OM=;
 b=fqJTIqFXIizwVx61MjP6y6FLQnKWnDwFNdAQFn4KU5F3wplAiaVgBxmAg4swmYGCdCliN71qorDUUH+MW9xynM/9d8djMkJDxAnPGBcaefpEf9FnYKT1ZBlETLyei6eXoWlixVDRhTatI1qhGgVLryxwUDqfE6WoxrzCXUcEPVM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 18/19] scsi: target: Don't support SCSI-2 RESERVE/RELEASE
Date:   Wed, 26 Oct 2022 18:19:44 -0500
Message-Id: <20221026231945.6609-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0012.namprd15.prod.outlook.com
 (2603:10b6:610:51::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a24a1f-1df7-4096-9e62-08dab7a8a367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3p1fNjONomXbw2SPE/0OpzLm2T3pTUTC05bHTEJfaPmT5lS/d5TE7X3F12c7x0td1ceY5VlGMjsWlNOXeNeUKLTjdmbY4kS91x4Qr1CnWrfqedy3rlp9Mt8NlZyG/WycIc5kyUFbNaa72XscRK3BNoaxg5tm3LrEeW7vA6cx4J+YuQ1PKOd6TzOiaGsCOQiF4V+e0BMlv1aOQMqp9hAjaxFKAnYIq5RjeCMPCrOPnjOvwOHgXAQxKIBLfkXM/uIiPJv4bmc0bvOAruhuL0QmD7kI2wBLb4GTfgshcp40lnXVuCWSpXdyEUwscDZ0tYaeVoUzAVrleLtc16SDXHg2lp5YpDTQIHps1/fIoJ+pbEUqUNQGakz59ecKFAUcTyzEQnrPkTN8oDOrF4kPzgYTQjxNfCc2xUO+7+w6Wo2Tue4XTJR+T79Pjj3QzyfvkTiR3PTQdkcc3n3ZykcxhM6aebA22tmXdFu2hkr0uh7cDMOvl5/6w7FS77W/7bJxN5EG9gWhO+0UtCkyHH1oi1IhHoQ9TKBnlvP3xVYpratTqxsiBqIzP4EpRjjVTP4rJi8NXUwJzpuc+GKf5J+dDhY9OcqGRf+8OTCStewj/F6b/aOmAF7c4st1zd8lhd1JEJUe1ZUkblkgqMs3WtPl4YJAMELqZ8oHFcUEmic2XpLKj/SUy5PQyRdm5LTAhSuME0jPXZWdG2UO1Fzg6YSLg3V4vJO4XwiHLKwosrNI2/oGrPlA1TYhT8NPdOWgrTDp70c3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ejuF9z8BDnOyqfFjYMCyLgnyaMeAzMsWQs244CG7wJGUMIGZT9E4U55OQPwm?=
 =?us-ascii?Q?hrxp8rxryLXaIBFyi190gNPOSyEF1Us2OHGNBL7ILD7ZmVU3obCAfjSaRzTM?=
 =?us-ascii?Q?y3uRtRhvVk6sBPheh+vTTNY+uqO8ovAYlrb9XsdnlX6hjAoBqcR9zoKiLvCb?=
 =?us-ascii?Q?6UtDdbVhbTxqYHLaPdHqieM0CKAZftw0WuatdyfvLnuTxBNXdDUUFTbg9Tlo?=
 =?us-ascii?Q?L2QNcaEiUtOsPiHfyQUDF9DTFdX3C4gMl3cshawwoQ9N2Iru5bfvILRdm80O?=
 =?us-ascii?Q?Wshci4X6peeEW7thgaGkP4g0jgwAcYFCAbBoEJj1/jg446if3fNGUlPA4lQX?=
 =?us-ascii?Q?AB+uDBGfZedmmszvttPB4r9IdaCLYo8j2gG4Isn3CY7NQKNSRNrQ5svoVNry?=
 =?us-ascii?Q?jTaqljxy2MjI3lFQb9pzTvtjZb3ZLNLBtkwUkNYR7huf2gzeGH6tQPD6An08?=
 =?us-ascii?Q?awJFT8AICf9kHqX0QcXuLVjbkel8uriWrZBNYwhwFecCIh/LGvLdCjNrMoEB?=
 =?us-ascii?Q?KkJ+XlHN896zZVSKVIWtvbv3Y4TSCB2PeSB18zlAn9nAOf3qhckZDyc5IVnz?=
 =?us-ascii?Q?q1VFNf4pLkcfhB3pKqnOmWxEfbBjFjRIDRNWc6HPcn8iVJI25huyE65VqulA?=
 =?us-ascii?Q?0d4IsmMDs5P6pDiqK+mD5iw5EaB8YfdYbUK4zZkgzAQoIvhe+Nvy6+1ZtjLW?=
 =?us-ascii?Q?LQmV1A/zp5g9fpVOMMn/I/E3VXk5riiCHWaA+if7NOt04khdPVAFGwBREEFg?=
 =?us-ascii?Q?xSP/uItbhbRKD5mwNxH2mVAE3pqnPREzRx96yKCsH3URvZBrZYXI3K9gOtMq?=
 =?us-ascii?Q?Vqolxv8cMjG6QkSZ9EFv3Z06hE7jfDho642M8Dh6xexcWIGYL5p8Mmqz7COZ?=
 =?us-ascii?Q?MW1cfu9g6XFNEtYtBu9+QzuIVmdmC+IkC96GWdIPY9TK/GsZ+YbpaBuxIRdp?=
 =?us-ascii?Q?CMJINkWzwoEbL4YLusiKVhkTXVwbJHmH2FhcHMVqkNapGfwJ+ESMqZg8BfGM?=
 =?us-ascii?Q?I9lehxDtswGEQ9RqZUWs0dMaoXowzRHOfEn4k2nocSM6IXJX5roG7mcaCps4?=
 =?us-ascii?Q?5I6MU4OyorvrTgVq4dI+qrLzrW3Ji16+EG5lCq6yxr5014HuGHhzxtyH2cRL?=
 =?us-ascii?Q?jXpRsCPDn3BqFyue/G8weIPN897TPeadD9xQbyBUmF/v5Ozg8SVBl8IsqIyh?=
 =?us-ascii?Q?gEKi1t4bIW6q+YZ1g22p+/6iHhE1UcuJdSzLGB7n5Gl26V6cxH1Ctbl15g25?=
 =?us-ascii?Q?KqNS10gs/LBdAeeZoJp4p012Ss6P2aw1iZAcT86Yb+wWtROoQ6ZyghtPAC9n?=
 =?us-ascii?Q?r4KaRTgOyIpiDv8ThGaZgN7UKVtkArgijWY6jGqkNKSQzSrh2Kb0/U3Jm8DS?=
 =?us-ascii?Q?8hJVd3+l8HghtEyLRyIhi+jRz59+a889I637ynVyC8dzinL1FPwLIwk1FJHw?=
 =?us-ascii?Q?YKy2NbJncVF6kX/wm+vwkxsG0CWUVp9k2uMqDnexWoirTiSspJ01kf5LNJ0l?=
 =?us-ascii?Q?Xco5ZVaxzfyRAep600Iar4MyWFwwJIMlBFM1Xr0XHBwG9zHmb6rOw0j7VO/w?=
 =?us-ascii?Q?79oV2d6iCy/1/vaiatF/1vzuCqoqUmObK/5+rJ3b2aoJwr7Zfx8tRypDaj57?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a24a1f-1df7-4096-9e62-08dab7a8a367
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:15.1774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQh4ndvXNnb3OOrsiCJaJRblVO8OQ2P2E2mGhiae5DHT4e2aEgekrX9ZuHJ6imqpS4ioPd3GXUPJk8R7SsFjZTQEi5d+MUvaJG5c5kN4/4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210260128
X-Proofpoint-GUID: 3LszkXjdZ7d5daBhnFDLUShdnNcJHv5v
X-Proofpoint-ORIG-GUID: 3LszkXjdZ7d5daBhnFDLUShdnNcJHv5v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pr_ops don't support SCSI-2 RESERVE/RELEASE so fail them during
parsing.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 7cca3b15472b..fb5febc437a0 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1320,12 +1320,25 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
 
-	if (!dev->dev_attrib.emulate_pr &&
-	    ((cdb[0] == PERSISTENT_RESERVE_IN) ||
-	     (cdb[0] == PERSISTENT_RESERVE_OUT) ||
-	     (cdb[0] == RELEASE || cdb[0] == RELEASE_10) ||
-	     (cdb[0] == RESERVE || cdb[0] == RESERVE_10))) {
-		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	switch (cdb[0]) {
+	case RESERVE:
+	case RESERVE_10:
+	case RELEASE:
+	case RELEASE_10:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		/*
+		 * The block layer pr_ops don't support the old RESERVE/RELEASE
+		 * commands.
+		 */
+		if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
+	case PERSISTENT_RESERVE_IN:
+	case PERSISTENT_RESERVE_OUT:
+		if (!dev->dev_attrib.emulate_pr)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		break;
 	}
 
 	switch (cdb[0]) {
-- 
2.25.1

