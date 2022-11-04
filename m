Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706D5C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiKDXYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDXYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B290B7E8
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KjBBt013373;
        Fri, 4 Nov 2022 23:21:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=WFNJYZ4rzm4LJmtg8d6DkoVME22Y/KxGyeGBY1wMnKOvfE66keXxrJonOoZTUlABnDV2
 MUjnQorvM0KiQ76SwZjv8vqcx6hCBV/67slcdYV5ACuMK9WSRQlMDRKY3fVdaP6honeU
 YBw00qwbAgsww5x3frjMjSZhpi9WJJ67qIj3MUaffuKHGBTj5ujo+tG6LIpLql0kKZru
 tDy7or9N2cVo89BFEFozUDSExDBIkzKTzxBB7x/RNeeJlsDHuqJzlpyq4udoE8wNwcb2
 54GuUoemeQqDn5ZWE/r68UqUZSqID1LObDnoBKkmO1eIqBCC6Rn5kWq30z3Szf2oNKKl /w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N8CA8014069;
        Fri, 4 Nov 2022 23:21:45 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr4t9rr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBnhYFuTeVSKKxUBe+Lk8Jkmt7b9CD//JZHVtSX+kcFo/OSLNEirUywCYaccZLeLcQEXLFNzUIPQu80wkB7N66bOm5tuVknchb5EmAzgh28uQqh31qmXaMFOvkb+Li4vtq8wxcHblczNSizIZ4l2ApZ/To3kbgsOGYb6C5ZWUEpMMwAeQKy5mFEGFNshIP/WFXd89U0oMFPJMlrSdbPYdFh3jVPwHz4q0Ntt6sh6YZGUYTJ9F7jkpnfM6ln1qL0DV0Zocy84avj9FapMOdhOENaQtxIaDAShL3uJjMgIvMwBadQUqEzSGN3QJt+7otT9lD1N5NsTV0uiGzPV/0yCDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=Z6DgrndqIjiAtWOsb65oB6jX93kXUXxqXLJmMuKgAW0mOLzTFMcD9pR2RNTjdzFG7QQxh50PUv4t/x1Qr/gOh33YcrylDqzulfRdIus4iyKaDhsxaM7g+ILdeg7g6/6KeTFcR6SeC84deAvnR8qjw80T3NZMFj6sUvo92BjkE6bCWAuyvK6jm/RKqZSRt5tUH9nqP466ugdNZzfvsu0WZkCKehtgjVhiwspPpHcdVYjWAIYyqOJmEAppyAMCsdVLNpaKDCxO2b77Z3g6YTjextnI4+OMuD4f3Cj2bTyplzqkdr2BfyE6gvZSXF3xqDWrYsynCPgrw4/Qw3ZtGwYtFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=kkuEI5Pdc79GOnyNm9u0timl4BAIygQWcpxGCRTAxFOVmQ83nYUO6rvyd/ePCJQa1GZXYJtufd+qPoPucnKBXxAAxY3tq66HUIwLHxoSl2Qulbf2lv9s7UqrxnRnY0sI2vb47zkg79GPsTpTmjUSQaDAIk1Y/QKrjZj1OYbtc6I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 12/35] scsi: zbc: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:04 -0500
Message-Id: <20221104231927.9613-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0063.namprd04.prod.outlook.com
 (2603:10b6:610:74::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: eeb8e6c4-e960-484d-5428-08dabebb54f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAwhbRil6HIR8tUufS7IdQ4aRRGyeXGbSIn75vCeMuKwdSZMpReLoa1ODdtAB/aXhW1rwEFbE5rks8Oc5WYLW6M4FjbdzpRxkUzWX7oM72ZrVq1pNIKW50jie2cQfxr2VBhjDzhwsyYSb89BAi11wHOvDg4hpIUfE/xyX0pUHZXXTzQvX+5+SCq+k579hmDNqAC5lRXktu0swfXMwR+Jckqe79czXWmjMh1sQxLx2e/pi7VdxP6xVrsJi7nBgHRfynEk2uit/wDZSggQKLSWLEFPzgLuV7wPR6d+n3d1b7hzFG4MDxR/7V0sZ4YTnYgH6hdX28bof7yLeDVlMGd1sg5im9+jjME4Q7ZObLNx1pnG/20t6Br2/5m3OswfWatJLlT53tE9uwzX9rKnIs/CzxHZtMcWU7kL5B+JjpBxXRTl7iTCRwE8+rD7tvY0zB6MwBz5NsrRg3N0DVI3VIx975g97BfcBk7+/n0wnFrdetBwuzrLFFR83TuV9cWd89w9u0vBhp9pqAzmZouu8px22u4KXmCYxwodrobj5jxrxqmKNmvjhbYfUpFAtlfsHOGhPfdL6i2aOWbDHrpKIDvtnCRCSfMpsS5FfRJNfTe6xZASMpFJ9SrWMJG/hk6Bx8f6uWfuks6J6VflQKfcGrfRwd9OWThnKCjgQmLXqMTfpMLo0vJYPh/pPOb6QTJ1Bsp4W3UkqoVBYF84ByBNSLsJIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BzFmKgoiB5p4AmD6UhlbNhfUGtvBhNmgAD/cPhBk14p55ICKOfo9wQoDg08v?=
 =?us-ascii?Q?Cv74yMpB5UkLFREpGhpiKdgNFXBNGeQrg1AYUnoVqcw6Tz4SSnHE1hKz3gkk?=
 =?us-ascii?Q?HXzW2BKdyTH39gWHLgH1LRQ9lVPDveCyEPAVIJNf/HGro4Hhjj7NAHna9tRt?=
 =?us-ascii?Q?cAbD2L7yFAsLZhNE9FxA6w5/ckSOBZEhRCIHzPfIEdnALM0EF47+Sw8rxBMI?=
 =?us-ascii?Q?LnUJOY+23Wv31uI8A5Lzbwkp96vuh0r+F4+dEV9JLDO0vLWIota9zX3xR4KQ?=
 =?us-ascii?Q?4JErKEORSkDjoHBgUbvsa703gR4OTbhHRCJ2rd3HOxmLpM0iZBBLZ3N6Qel8?=
 =?us-ascii?Q?+uHYdSv+ce5Y7SCZ3e+vVwzIlEsKAV+Ez1oxZf28O+l/mnGYANLv3wSYfj3C?=
 =?us-ascii?Q?AwNCX4lciOFVKxDOqvxnXP5axThXCd2vbPTrbwpGUgjTlPAGpMQJCjj+nRL8?=
 =?us-ascii?Q?GE51GjtBpB/s0aLJMu1hMKGrI0Gafk/jpzYBOoRh+cpj3hlbqQLR6P8YSWHz?=
 =?us-ascii?Q?C9oJhqTBx+KP7NHx9TVffwIzHUkLvaXDCxqBkHdRVikQbmSA/39rChctJMjy?=
 =?us-ascii?Q?Le/Kw72TUpgDkg9k+Ic64xVFz/HTJYu2F70b5/SOAO3xJJEhxJP4ursct2OC?=
 =?us-ascii?Q?Cz2/IxZflpT4jcrUqmx8v8pSRrPVLe0B+Agg8H6L0AxRA9F12U8aHRrSfWYT?=
 =?us-ascii?Q?cLhNsFMncRMg0nBoqDYrVaTL5KIIskc+sS3/YCcCiicHrEmwuVwjgo1AsBLI?=
 =?us-ascii?Q?ZWB6gk/8hvDLP2ToeDAunw1oibrLaOpCEJ+wm1e4xJvrSe7JgxVuh8Da+GM8?=
 =?us-ascii?Q?51AplDGgff8soNQECnLvgj2s6Z9c31OBBfE0Z1sFFfSfngmDWPxC+RAzWoHn?=
 =?us-ascii?Q?hzyr9xAKWRCVGdSMx+q6jHrM4diaZwLGUHqbh1fNs/AwORbrV4jNU+x08MUu?=
 =?us-ascii?Q?+3+j1wKgpoTg6ZrmjtSclbc2sXfN/tkZ/uB7ggim2jCHe54VQRvZbiYWHKD8?=
 =?us-ascii?Q?baREVTYwNvsLJc0pTP/dfSJNYAZ2aRLNg5B/Pcezf2bEu28WC03jo8EY+0TY?=
 =?us-ascii?Q?9tcG8DjaACnZATYeVKbUuSvkybGLGVpkVSmncz0tLqAKPrx5zQ98NiLZ/QVd?=
 =?us-ascii?Q?F2Ijr73AP5ajZBOSpvl/xWVFqljoggAhpG+1lzt6V8Ngh1IiPmh6Jqw/oKqo?=
 =?us-ascii?Q?13tO4xWAcUEcYnP4dIsvbIdixPIPSIwbaIWdDRph5lwXe5Gk7TbtTN4FCQeL?=
 =?us-ascii?Q?8yAXU2psMCdu0JMVoK1ElHD0JrUGpTLwKb8PrUbSwAlUce/GcryyyBNUEwI1?=
 =?us-ascii?Q?aUGv7jyrBEEHjqD5jrUmi1kCNR+cJG61o0k+rVmleMNIVn5HuIiKOiD9/b9b?=
 =?us-ascii?Q?nkjoM7mPAaEzZam4yJiMzKj28JFRfFllIXZtgBo9aIZ/WFAm9rR9lDhLcDOH?=
 =?us-ascii?Q?iYQ8a4qzpeF3jaFZ+/LZJKOHQaCWExmUpiZ8fCx8qr63gc0QzhiTkTSaAhAS?=
 =?us-ascii?Q?+42CJSegcnkrHPyhFD0r1fsaN/objZMJo9uT62OO877Lmhn64LiPQpihfs0x?=
 =?us-ascii?Q?avlbf99NAgVdunvu7oenvq3vLqeJuPBSPsm/nzUWL+iS/1/CKT6jsR1iupDf?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb8e6c4-e960-484d-5428-08dabebb54f6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:42.1031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlI9Zd8+MnvF4JoTBkG86dpdm6uIMPP2tFSlWcOZ8Sv7hUsKjucQ3dpKIJwrhSBr2L3Xosj2F+gyxv/2be50aABC6gsPLzcRZAIRkDqkWNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: nOKJrNPBbpO_p40m74jgTHnSjR5Jz8Pv
X-Proofpoint-GUID: nOKJrNPBbpO_p40m74jgTHnSjR5Jz8Pv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..d87884a19a51 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -157,9 +157,15 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = buflen,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = SD_MAX_RETRIES }));
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

