Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE1BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJCRzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJCRyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A713ECF1
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GONAx006557;
        Mon, 3 Oct 2022 17:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5YWPcUAeBPztCvPxkAw1ZA7DMaUL9J5GtrDVheS7bds=;
 b=OfET1eiTj4QsdWaqh9K+HG4Tdnex75qQxbsY7nuUlWaMZpmGOXw7beeTAot9TiaDxRRp
 35r/SHe3A8zEHdSnHpElhD044t0Mn+WgIOrM96WLJ+uIypj0weK77KNndXWPPG5DdQrU
 sY/QyPz4DMLvwoSRKhr11z857MYcWPayNTeo78Jw6Rh/E+6nKQlxaWeDxU4OB5WmNLWD
 4zvhZcA5q+gkTpEmnj5khgdQY3K+Jdgt0gCAWEFEOugtU5rkl7tZYpSfyTDWeN7xHUmK
 gBme/rRwPfqb1gPaokitPkID+5BLMEQPaTVQsR/ZPdM48txnTT56WjEwybpAjr+BL+es fg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xo015519;
        Mon, 3 Oct 2022 17:53:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jec1aPia+VKNYkMhb+9B+jwj1TiCwMKXwkhJKwGOn6RFbSBRSi4+nbH7W8ar+Jr4NR2AuhJ3NgKqS//zPcGAC9x/OHAce49mca1p1UpFahYNUoh5AB/l38Jv5/Ry/zB8UyLuDdHu9h0uaZsafWaGVrPbXVn0Cfd2+65+5xTFrl0Qtj2o9F/dHgbFFUPFSrh6wws9XB5hQAGU1in5fUnrmbCoh4a04OcQJ6n0l1FA5bWik/z4jQNxtVVETvudfmuxmnXDnPJD9LIM0HZ0DyapaT7H9oDRHkfnQQ/TYEFn2fT6GYuWzguQWQX1KFpSb258bg7gGHL2vyeMeX9fLMWE/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YWPcUAeBPztCvPxkAw1ZA7DMaUL9J5GtrDVheS7bds=;
 b=QOcYAo5C34TXOHc6CwdbolZi6DVdjcOWHfam3ugc3yDczv5pIUpq8dbySnIoS1SkoD331u9RZJwgoFcfa73FMfJuzBDkriMYia+Be73xJBC9+onfPmJF/SbTc9GUkH/5ek1gJrtnHqgwJC+ZsVqzuzORdBHF3LpUVEI9RnLMeWmyYDR1f/o7XK/7UWuZdTtvxpKuo1A5zvLUYi1GbT8I6gAbn01zCO/yNgAympFTvefrFKJZiCDXNIIOevIg3RBUmsruHLU8HwNEO3eDhkY+erihN7nCF8xTOdKnHXUCWiUJnVVvRZPcHfnN33TAU6cPjDxMre1EDuILBBuPbpvTPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YWPcUAeBPztCvPxkAw1ZA7DMaUL9J5GtrDVheS7bds=;
 b=iM9pBRfsaQ8w6oMv4SfLvLUHreAWDVIAawQSgLsoPc1bnJsf/PacY6Gn3NJgSaQjEsfJbk7/txJWLKgjF3NhWwIvwfHnMei8ysXALkkpmLJ5jjxNgk82C5tNYkI7maN9ziNKE3nUPbG2kHoiYDKJDpsPubAYOD4/d27SII0s7t8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:41 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 12/35] scsi: zbc: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:58 -0500
Message-Id: <20221003175321.8040-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:610:38::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 463dbe3f-6550-4791-e6da-08daa5683530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7jf5y4xl6SlYZ9HiwOTXL3yXVZle9uhtRdxSXTmEjmfUpuskKBTmQue0SYlw/ySOZMxMCGUqCKnuBSJ9/BjZui1dNE2mq71QhOUsBy98Pc1Hf6iXWrZor6w/4MR69zRLM+ejlCs4CC4ITiiQwvXIb7+cle+TtHLBEBFiJokPeCLtB4BfXhH21KMZ6ZTQ9ey1kfovqE703WVKP/xMk4FG7aoxvqxfgMkQ/v3zmR/Tw7ezHcpEwS6rOnz4GKDRzC0y5HqtX/d0/PKcoZxCQvT44yqDmqHjZEhdBqFEgMAFqERX5GubIJlCxO2qqBahcO0vpDuRgR4KPRo/lV9ckBY/R5adh65PuGemnSOYJpL6aEXmJ9LGVyLGxMMxlQyRjf6rbiSA1hfsCYyD5nBLWJwVViWvGZCV6Hfs7eIQ6hbEYHEYdrAer1vNcAMVQ9MdkafyFtem8llj/ctLVsJ7MjeWa21hUDOyrpDz40ajIiD/j9h1bm7o6MG38iDGph7gWnchs9WiX89L5ah/uT8q39n6HrxN+yC/ehW2TMiAOC9PpKROcswnkfFZn3XoGYCW9wu0RenpDZXnaiX6TXdmja2cNfvmBhf9ZxmO4mx95Fq19QoDgtqhuxPty6ZlKqX4eUtPyEVsXdXCyvprSN53G6cKmjD76MAuNgjlQz7cPO9qrQ/v3zYqin3d0PW1a40h88VLFfeeZr4ADml/XKX9hvkRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gUE+re2LUxOb/9TsRfvROc4GhRG6U4mMIseV6EKRkvSvZfDt/B0EbU5lrKII?=
 =?us-ascii?Q?AviYcEHg35Z1NWCxKR05v+N8jl7yYeArXeLr5lfRC6mma+jNnD06tAU80i00?=
 =?us-ascii?Q?aLZPEVk5PUPcVvpdMg4yxpvf0Sxaf5n5XWaSO1eWmNFEPxQhTAVGT3fMV6vL?=
 =?us-ascii?Q?Odundf3+qmp7YdqHn2R+YkC+knTqnYolJz+xtsAPd3WTtgDwq7gdfzHtKx9C?=
 =?us-ascii?Q?wFbRuhr5g4dpF7zBVIoc0aUQd1K8hfvz3X5o3pg80acKygzNk40EOG+PCOCS?=
 =?us-ascii?Q?cfMcrz9WD62bvGmh+DyY/npHUPpaHBtDfsaDN0PcdBQfrUNFictX47HSYUSv?=
 =?us-ascii?Q?Dc3rxPjVzs6q5o/KOneO5SjCXRIjDgNviMQiUW71K9rhFl1esuyT/oQ9b2vP?=
 =?us-ascii?Q?oEz8p+WhuslfzPQLXQwP8zvXYJHraqMiejcFhZCGBEPmHlxkR4SId2ewHZyv?=
 =?us-ascii?Q?7eR/GhO2S+4yeLxA1Pq12MViUIMtKHa1vW372/Is5MT5o2cDtNxvIIzm0YPg?=
 =?us-ascii?Q?cV09FKlF6lKou1dQzE2/DtodRVdoWGyt1C0Zs3yY5wuwfhCCwMO846NBWYCT?=
 =?us-ascii?Q?w5tBsFVZXPy+mq3sGPVZhWdxVXEv2UKrCQ61O37qONrnouRqkhfPVTz/6AG5?=
 =?us-ascii?Q?UZmoiid8jVju1nhICdT2B5dFZsf9MdsHs1bXFEm9n97pTvsPCFguZmf7+DA2?=
 =?us-ascii?Q?IWXAVEP3+IKPAyJCxxPOvh2YMX/94nhoRwtCWqY1X3Loy1EKJibmr7S8CccK?=
 =?us-ascii?Q?ZEMPJR/esRL01mY5KiYpbVJOmh7xnV1lmga79lpGQIVgQQuTVBQLbj44TV4U?=
 =?us-ascii?Q?oydUJ6GY2EEkgcJhGHlFlOAxs/wwQU76YH6pTF8FBLbqNqTufpVTBd2Fq9Kp?=
 =?us-ascii?Q?RnzO0NqH/+M+23fuUzN7QP1HJj4ujGxx8cZ9a4YD0pNbBQTL1oP22GCKm/zr?=
 =?us-ascii?Q?YT32VaL2rhhskHHuG21AuoG9CTYOIyk/W1maO5Bqlt+pAMDrNc4X2P26RRM7?=
 =?us-ascii?Q?wUGqWT73u7FQMujGldpcA6yWF5wB+bAwS0VNdDht3Js1GDorqKWOVySdGz/v?=
 =?us-ascii?Q?3qB5KXKTwaJJHG/SWtjZgnBCNUJLujxNESh/9RE54u3u1HBBz3lsF4aEOJNm?=
 =?us-ascii?Q?zXOyKCrYLu8aVFTonlHFCX3KxRtK+ZfPRZrU5g7y4KobAJB86Np/2FlweJHR?=
 =?us-ascii?Q?tjOMYyMthY/G+w6Gg/e1VNvyYIz+iMW1etKP5+5VxRp3lfNAQCXYAK1Efcz6?=
 =?us-ascii?Q?TXgXCoIiaf8NmByC0s1fAwcKXhz6UNicz1V/QCk6vZWeHPpZYhExY4GFnlIg?=
 =?us-ascii?Q?tHyrxdE4bMhMwgFIi79G6i6g0FTZUrOhDNAnWzUMk0SzoOWjZAy/9Fapf0wj?=
 =?us-ascii?Q?V0aNlmH3NJQho64EZr5pfJQYK3HZQhOUcFqzULuY6Tp6hnnWlnLVZNAQHyRe?=
 =?us-ascii?Q?nQIuIyYJAKg/UTi4Ex2GCsnxcpSASHRkd2COfMgdP+qF2Ixj+lUcOlnbT4qT?=
 =?us-ascii?Q?E7McGvl/VaVL+2Pa/28HEgDeQWFQZobZDtEGoT2yFRDSQ7s6mAGHHRDp96y6?=
 =?us-ascii?Q?EGFM24Rrp3Bo/+BGafWfZpnvmPBN/6cLGFnzymALGC6LzUPfsux7LHC8YdV9?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 463dbe3f-6550-4791-e6da-08daa5683530
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:41.4863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJ9fNyzRDFGaJDlGVEtf825e77marsIR0ZjHL5Uau2q3KMLd5bDicHTvv5gr/8QPB2fhcDSMUIT4dF1TqETLjEv5f6xKrjy3hWRsGlLF0WE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: fqGynOLlQ5UIHoCYuaqH8_mPt_r0vCu4
X-Proofpoint-ORIG-GUID: fqGynOLlQ5UIHoCYuaqH8_mPt_r0vCu4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

