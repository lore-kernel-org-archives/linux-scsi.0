Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE760C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJCRyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJCRyJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9663DBE8
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GO9WG029401;
        Mon, 3 Oct 2022 17:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0uwQRZH1MRoqoy4nw9Eu8xYJvyrGSqKaXBn86AHK1y4=;
 b=wg2N9txUYHGwPF35xX+qn3oqPmhN+gHNeVBSnKdpNfp/e9w5ZedRuoUdUaHpB+hynTu5
 OCN3A0AbZuMFdNj8MwcJ4Pa2v5fwN6Xq7Zet97vfUa/Re0wjuglQTS4Yodm8p10ig/tw
 VDwnDlDN+Ko+hhlvYZn1Z6ljGrHeA2tKNKD9V1AZDec/7yb3+ss/sfcYGYyW8WOCZQGb
 yl6YiKIbXSAZel9BO/YAj1y0rhBzRHOfYtPOXufao8/uJxpElQBeJD2uvUvQeP0Ic3Cj
 bKfc4aVlWLjh/iQtIo9HetxkozHiGnONPSpRhKiBCv+6E23n0BAE2w7g8yuiyCTFelMC oA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tc91r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xj015519;
        Mon, 3 Oct 2022 17:53:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O59wcvD7FF2g8vxx1aveqdhlKDjTzRPhDgu3VPVwUODHIq8ydXohuW1pM/Ug25rAdxMlDnDgjrbH9bREHCxDVq3ncDJPqwQrFIHovTAUWU4k5sTmFIzOxU8c6hSq6iMxFaoWoE4vfEEmMGAXT46Kh7BI4Fz75xnKAiS/ph6hildVuVuHJB+cPHbVpG8na0e5oNjyJTLxs/1Yu7Aw9TccSwznKuPvZkknyDdTIiT9oUn2fyzE0o8/CUXcmeWUxgi65EX3UbcITP/CznRziVGvkiX6BItHqKHk+JtGDodMkAPeyb2gcOSYx7jwXdXPf0n28nkJXqHybkp+gxoF3Hzjxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uwQRZH1MRoqoy4nw9Eu8xYJvyrGSqKaXBn86AHK1y4=;
 b=RTYhhZShAh1KElgweSUhB5MuXl7JLqfTSCS3BXyNu+dW9udf+1P7r9edEE7eCwGgoK8tzZpB/OXV7G5Lo7otsDPqe57xxsqbCFxX9QjdchfONFqcZZDUJFci58zQ8weiFCskjhRuNFiM7P8qUgHTJksubHhBhOxwI2sJpDLmQXdzFOvC60BGOwU+kH6K+gnS/n46Vbo094eMAG6lim6pjwSZrRjq/hItNOOpmmhEc2ZxswIDyp/oVjzeQMHyw8yEHBZ2hhJP4NocqwIsgJEtbUb6exqHC4aeVhq/ip/QTkHqrpIl9sgTie2iXUL+gQJzKU4JVfGfWHXeGuRUx6A0lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uwQRZH1MRoqoy4nw9Eu8xYJvyrGSqKaXBn86AHK1y4=;
 b=fWnYFuqR3pzAde6vKMw5NIgMERpnb6cVTT0RH+LZwJ7u+s3RbPxkpv6wu9d49Uk6vNglIB/tQjUS0MV0TTjkna+VCeJ2qBkqIlbHY7EIVNJJxHKWfHX2G4snNPHnPqa6ZIrzEdawQ5dzGRfTeFv2ikNtXdi2py0BJp8NvXXwGgA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 07/35] scsi: ch: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:53 -0500
Message-Id: <20221003175321.8040-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:610:59::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 35a139ae-36cc-48f0-b8b3-08daa56830fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1tIT+BDTqYgrCTkVpQDoktn1JKFzxajQkT5KO250V+YPbkPVmaWIml3UDZ3cQlZSXalyHl7OZD/trPiqOLMJt8njtLHzJRbAKAEEZ4/uPsjdtPGgyTGXln13iTTd1w4s4kjZBENiFZRdaOcf+KeTc4C3VYjwrroIrPFifhrTgoj90hGDwWyC9Xiylg+QmalWt6X1g9OSTKJ/MjkPyoU8PnjPPxEFoKceiWmFTB9ZKpYnBZerlnV92DKDgle0di2teTG4+7rocJmDScLIMtdwWWUoZweCfo3yB5qyZ0DDGYSoWBAZhjxHBxrmEurTAF8198R8ObjidqxJQQeqM54mMO5xRWfc7444Bj5oM5Mux4Yn6D/Z8HtUV5yeP/zvQfX4FQUwE9kDhOszM2QZM2gJuAFA6+SA8IFhtrUYbOgGjtYA3OiGRizL1S18fy61oPKS1/Brabzy7Q46WJTd7IUHafs+pOF3CXcNzJ4JGuzI2HK0MdK/5h2hI/bkr5N5aff4pFCz+nLOnV6eyWlUfTB1rLsxhQOLW9Jnh6WH70P3PWNpD45q6FJyuBynHdlphCKI+j8D7Vr7ohqz0d6L3z1hcIHHtrJZeG6JuSOh1w6UJWATDPLC9sbiZeSPkKUb+AP+xnrQHIAZClodUnwOou870Dmq5DRWwTG7/lRwUw3XWuo4Kyfs8BIPaQL+dMIGP6Kh2GaXRplkP+ntP2dhrlA7tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(4744005)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ThNzdEXEzU/aHtUZ0ngF5zDVahPXNALBUIQmW4MbLn4gJBEKO/uxKp/a4Dsn?=
 =?us-ascii?Q?jw1aloH+3GIjR8oyt2e+7z8vGCMpOATZMUzyOevsruu8tbWbJXOt4fAkL1US?=
 =?us-ascii?Q?piuoreIV9ZbdOMdoi5lZ/VSGWH+4qSJfiFK4QTO9PnSx0vN89umhmNXfnfSK?=
 =?us-ascii?Q?3kdnJ1NLM+Ebhh5H32cRnH/E3hPkkUbMDDjDr3eczqswfyoajypDYAXYlAAj?=
 =?us-ascii?Q?15EvS+goaQag7SoTvVOSrN7Fa2zcRfH4sux/pLpr5Ac4Pyyjuk97uFWXerIa?=
 =?us-ascii?Q?dxhiITFFzp3lvadbtOzkGtQyy/mFmZZ+FsEHbH1746z4QidMS3xm+op+vNSi?=
 =?us-ascii?Q?izwjnXka7HjduClUS9oywsvVXfnOYABv/EL4N7FMrYKJ7MqBirJm8x7Eed5O?=
 =?us-ascii?Q?uuuNBYFtx0GCuYXntrIfBsy2Wf252vNtsDuGDf5/pxsCHK+7YK7/OxhHQcRx?=
 =?us-ascii?Q?zjszucYscy4++EJN8j8LobwP3WQTGUD59+x+3rgIDc1mpOmLqBmBcfzeBG8L?=
 =?us-ascii?Q?izOFXottfIDks2c8I/U40CsKPea5+LIhhhT47e/n0Va1IfNTF4urSxTWKUJG?=
 =?us-ascii?Q?Q4e+P36MPinAqFKRPbz6Eb1be7gV70zHthBLr8XdpHuNJWY6rdhdwpdhGI7Z?=
 =?us-ascii?Q?sd7EHPi9xEcsvkRhIRB1m3f+T+7pM3Tce5gaaBdoGWM2sMF8sVkltTSZu46l?=
 =?us-ascii?Q?o6jzD6t6vORy+tAxlI4bsS1HqiTnmjGnxiHOfKU1Dh3h8I5xzDdhhnPuBaDW?=
 =?us-ascii?Q?k4oNaWZG9sRGNsBQi7ipM9x6pUkiJ4S+UR6NmQTcMxH130RhPUDBa+7qoPay?=
 =?us-ascii?Q?z4NQmn1LmAPmnvlEtm1cXX/5zHIjxY3diq9IpuOtHGQohF+HhoEdnVhDu+CI?=
 =?us-ascii?Q?VUjYLKFngmjyblRlpRMupywF7AA2w8s46WFqwASc3qkUiky98bKs+e7yK369?=
 =?us-ascii?Q?A7CXt9gjHYWlW/4w5RHUqlyUzTljgp1fGabm5fBHnbpGU4AbstFVdWel57yP?=
 =?us-ascii?Q?wZlqyUEHwsJ3QQY/tCLGJIzTtGPXEyKEYyxOJi79BqTVNaIY/VYuAZLVhWZg?=
 =?us-ascii?Q?mMoe8/3Mb3BCb/8TatNaO19mD8HOUws8EOr0cwZgyC963LZLJcuXQNQPVQsK?=
 =?us-ascii?Q?McpQInkj01hxCOH6M3mikD0np3PpyCSl/UiuDBTzpSOMtrOfVo1BSpJ6Tj+G?=
 =?us-ascii?Q?92jXf6FLikgzX19UDjzq8pFrK0mmIbwrTxK2fz8C3CPnfAynbCwfL0TDsV7h?=
 =?us-ascii?Q?ke556XxI5nKIUQA2ZCuQH/WBSHTxFk3zrs+ibwANpLdeJdjAn/0APUwdXR09?=
 =?us-ascii?Q?uWj0FPCqTl3kCbprqdmNY7iQlB5Ta9gV/vXO0vn0QDyGHtj9HYecyk4NPZcY?=
 =?us-ascii?Q?bnEnDk47AikG68jRwO2GQx/1njERcRsN5yYJH28aYIU1R08ZSCsxu/7i1i4G?=
 =?us-ascii?Q?s+D637Uyl0coEwBLdyM6TY2DoJiS14zldauJu/H2lUHTELo3PEX6hZkyaGr3?=
 =?us-ascii?Q?U363tU2GWSgA5Kc6McuRZdXlsJ4mjoYqLTHSC4cM9/p3XtnDEkgsp0mhhw9H?=
 =?us-ascii?Q?MBHyhQPit9ul82kEiA4zoOGfG3+bF1Fb5JJjdWZOMyRvZF+jDZeVse3DQgE5?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a139ae-36cc-48f0-b8b3-08daa56830fd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:34.4400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmLvJC8BuJiETnXtHCDsB2o4S4NAeTfgjnGIEQNqn2B0XcaYCES7JP0C7ufG7FwWar7qWXMFXKOLljBAf5e/vyqkug45SH0koyAgzSR8Sp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: VNGsNdyiSTsD6v3tBgfVPP70q2sPWkxb
X-Proofpoint-GUID: VNGsNdyiSTsD6v3tBgfVPP70q2sPWkxb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ch.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..511df7a64a74 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -195,9 +195,15 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
-				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = ch->device,
+					.cmd = cmd,
+					.data_dir = direction,
+					.buf = buffer,
+					.buf_len = buflength,
+					.sshdr = &sshdr,
+					.timeout = timeout * HZ,
+					.retries = MAX_RETRIES }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
-- 
2.25.1

