Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F4CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiKVDm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiKVDmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:42:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F6728720
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:42:51 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM38jX9014952;
        Tue, 22 Nov 2022 03:40:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0oTSuGBL9ZxzufwokOoOZu1xoYKWn43fHHshoZcS4+k=;
 b=nt2EakGthyXo8cT/WQN5tSy7qvopU2zwUHXLC5zudVBFjiELX/9JIkKnqZIBwpF3yyQ2
 DtCMbKb/u/tBZZBQ3Y1ukdSpjxHf7RdN7PzxiFOimpcNqsv3N9+o+gAE3FqdnwOju6nA
 QaIgzMBQ0SAmOs9XgZwsxEaAPWhRh15HHIjkIdQtipLwyQd4Ykm9GSqGACBSYzbX1dBu
 vaOrFtle1SNo25yQPtHrtBwOuyQdsRIDZnT2xEMNDcrdAGjYw9ZA8oiT2Q12ASdW3Feu
 SZZGsv/jYuYB5zr5vISFLVzbRNuqgqUzy7qy6//tYAmtVTr7t+hYUIHSPmkqN2UcOf8U Zg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0afr2c50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM1Krpg007462;
        Tue, 22 Nov 2022 03:40:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk4y8hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeLWMdDUVdaFNJQpV3tq+6/TDAIvmwQ0DPV3bIkN5yk8n3AeRpCDkMoxjsgfURMBI+NIcH0MLg7SWOBavvvl3Qi4snLVcgwq+tx34b5vlxFDwbx1kBoyAKR/7UBkuDAFjoIrSlZZeb+ubySqAwBBecWNI3fuBmkS2M6BzEt21joeBafZ9EgtIZSklHXzWVkb32+xmZPpXFpIXZKc3Qi30+u+xcviR/LvSJKVCiSmCxEKuxF3Gl1IuqZqHCX9PbChRp7KBWBjw5pGWOGlyzZEEiP7zn/vYODaK6TcuYw9HRgWAYC3cKH0xq/AIpug35pP7RPRHly/hTEuf9QWNlghxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oTSuGBL9ZxzufwokOoOZu1xoYKWn43fHHshoZcS4+k=;
 b=BZcJPx1B15IpbcRtAXVOeMOPyy/UdWogL5neuRUJHEWOY0GKE10adKaivxhf04a/xxo8X2P2X1498Abn7juReB1m8gdL9L5d2G6OwulJlGTddaOTKVWGZKL+pMCqiP5F2EbyhpZdGDvbi35NkunNvbFCfwYXsTJcODTav18ZAZjYstvIy3eJijhUkPZJQ+iXrf3wuKiM8yhyt1SeFP4Ku3I/an2u90EWqz7O7or3eQXqPj8gH3Wh3cpnoKKZgnY86+90LoKQQ965btAwfiNb7ExG3476R20YVxr1djz8Pbuai7Gq0I8/HBmQThQ2+7/z37WXMtZHHry+sIcoeb1DOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oTSuGBL9ZxzufwokOoOZu1xoYKWn43fHHshoZcS4+k=;
 b=evvOJGUVJXftVloCFabsEk76+OLeRt5uF/RXAMMnxkmbBXxLgZHw+CfqDLOLM1/ykzTRaPR8Dhl2qgjQWOWYUUukeSVGS9XvEWiSgiZScfUYEFi6ETOKIKHwVKQf13t/Vl71EgHisIK2+h9s2pV5uXzPsNeaVoFZwshabmWZqOI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/15] scsi: ses: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:29 -0600
Message-Id: <20221122033934.33797-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0003.namprd15.prod.outlook.com
 (2603:10b6:610:51::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: cd924b1b-80ce-4e38-c95f-08dacc3b5345
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TZSea4+uSUSLLz+HZemGlC7izYuIu0+2X7fjqeCYP/PP5oJl2QlVnLEQD8hQZATr6eY0HMfefl9Fyr+itBTvIypSwuaxHHNzykAgiPv0Gs34ALdMviksGt4NsViD/VYQMhFsng5MN+bpmlKd1AYHz9yxcmhELWMa1k8g2VV9/ZhEIsvPiUk1LXB5NAq5KAO8RRezy5xxuxPxZs6yqwqRPQyd+b1/WsGjQFbbofP04ZyhpkHg2CVT/Fsvxf84BI+890DlQvAeLo9/ZEvbWKvchxG2V4afIELF5jOZXzVkg2zvg7oh0MQfIswrxC8UfUt2zKS8M6wGP8GBoiBZEY/po/gO1ZOAwwW1Ttlqo83k26sgWTweazJxCmZkq3/GJ04KrLgGVPOMCx667yMcn6Bf/qWKGQ/Xw0pvfhIWC9PcDCzSTQDdgNNwdZcne8rI+0O/z5P4xB0Ol3e+N+cKhcnUlINI/z96haBKlvpvzzxXx+rvzM4cOELT9L6r5ZU3Kuquns8nXPy9aJ/vhWe6lUnvxQ1ZFiBvjGKSfkQWY7uQ4ZeDr43MsL8vX3aiay+Tq7N/NzufmuCMvMyhBnBiAbi1GjZJANwEP7uOpe1J11M2cByhNsjLj2IzWDczjl7oqgN/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TC+ywx83qa+kPXlaRuvCTk+5HXyXfKUV+fFVIkCh+y+6d+6OjfvgKFlKqPx4?=
 =?us-ascii?Q?7EoznfRxB0ZsUkjCibWwT11XzDBVDzFLtDSqgI1vm/unCi8C2hWtxR6SfbNU?=
 =?us-ascii?Q?GryyM5QK10ax4heS9RtHjlYfrWU48rY4m6uh4SYCLVhMXEr4qAn8uSXtDCT7?=
 =?us-ascii?Q?hGGU3qL86inrywBactfvVMOZCNhruEtdypVSKSJZ27cKAv+4itiWEnl6JmmI?=
 =?us-ascii?Q?1URiPlyO/2ZqKFkdoR+jajqgV9CpllkUz/yI6PEHEZ5SgHy7XUsfnC4jXVcf?=
 =?us-ascii?Q?1U85sZ3AxMdjwMCWk7vtuAltqh/q3TlNPcmzqbg2fIlykBqoj9XXicQ6O5AL?=
 =?us-ascii?Q?SsvXE1gWl5pQz/2ZypIakrHLoLiSZ/Ryetjk8PhC+1jTudqB43A9YmmSlP/M?=
 =?us-ascii?Q?M4QcVQmkgqeE00A0MBhhOOIKHI5klIqKFNtqlJMWBIrXt5EghZCIra5jY8px?=
 =?us-ascii?Q?eJTQyc/09UPNwcZm/YAi7UexjKeLehOy1ZZSZHlr5C251P8gbXwU8Z3mAf/V?=
 =?us-ascii?Q?j1rKDKnnk/AlP47duzcGfxS6s3KUQ5FObjJ8HGzMCcEwlNqoDZBMgSPyt2oC?=
 =?us-ascii?Q?DN/KgeRzjkr+y939tSCz7kUyfUvKyu+VSovLrd+gh7J+EgO4pSDhfpE75/SP?=
 =?us-ascii?Q?09MdO/2pnG4wm8B/+SPeBYKxojkeIdX+hel601cmJQzSZxBa295ZTRJx4+Bz?=
 =?us-ascii?Q?oEEtXWG1B5iK+9gGJAlO8hmWKGvMsvyCRK5+mNNCWw1ZJdhqC+sdh685XeKa?=
 =?us-ascii?Q?31/Wkhxc1yN3ADG7gTsTb7wH+tcAgkniye7Qhgu/YwrI2+NYn0L6e92iH0q1?=
 =?us-ascii?Q?wQbeNEXuqot9/bFVKvyFknk+oDGbS8Sy7x7Q6oRcr5hWCrSYd2MsFR/xp1vX?=
 =?us-ascii?Q?eKwbJqL9jbjjBdeK6BxMfs+i+yWU8ytwwJVfYaqv1M/IxYW/1LpnxWOcJOQJ?=
 =?us-ascii?Q?lic2DlTx29wHaus27tRF43UUNMKbepnPjwpZJ8DyePkyhjk4fveIT4i1A0P5?=
 =?us-ascii?Q?lBadYq023vM9brLcKXEUpD5SNYmYXGUD5aeCJODbe2nvxp+fB6cpdEgaklRX?=
 =?us-ascii?Q?G14jUneeIWNU2hARCSmwdczV/e3vn0owlIWF6dbahOlJJQyZq9Ud0t6WAUgp?=
 =?us-ascii?Q?KSOjdclxZw9MGWtaIPdZ5SCt39nvmj6lI+2l22niZLbdPv2EIynISxI9pSI2?=
 =?us-ascii?Q?a24tqv6Z9GeUOGjrnXpLiBd8G3h6ThO0uUJR0l0Iwmxut6fJEfUchd/7A62w?=
 =?us-ascii?Q?OtLGGZadXvJgmb/ZEl2FtGPH6F2NoFXRUce2n7Oyf1O3nmXXSdbXjaKxJLzd?=
 =?us-ascii?Q?HAx0dioF+XkPgzRauSwR9ob8G1FzGJ7Wmk9kJ4LEuyW2LVYEHrvsGyLMHYoj?=
 =?us-ascii?Q?yUfDmB/yq8JD9HjgdDFUneECanyzbixPB92ossK3dUojHW90wHdex/fvnrly?=
 =?us-ascii?Q?0nlMPhJ52T9t31c4ks2IPydTr91lqPUgye7RAgOQh0DjFnzZTcChRpSNu5Vn?=
 =?us-ascii?Q?gWyUtGMU36BEoVy/pMDx1iZzzdXHYBU41muFlqbnwOnbhKo9smwgUqV6lEMd?=
 =?us-ascii?Q?RA4Vw5ailrDcRhulSiKFdR49SjLO9E8mcsG6oYTfTSSYpW1aJvddm16TgnuM?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: v21xmnOSvdpbKWPPEPrpMuMIjfHq4js3oBt1sfPhtlgn8UKkFJZAp4sLRMYCWrOTOtLHyWhkElYgGqgxZUp/qjYcG3X5FNEUQS0uJf4Knx63SkgPJBOJp54xgGSjZQ1urSrhyYDN9zR4om7X6HMLc1VnRfk1gSGvx77F81g5/JrVToBV48tBWYYfqVoFu51PLyyzRGZH+fPOM3pPX+Kiac6sz9V6ZFQNDvhcFogV4geZXj0tFOAwMhJWDdzB5Q3y7AR3kjF9sy7I0SAo874UX8AOK58wozEgfIn8hDTw0fZS7gi01ErqvpEOjpNTh1OeRgE8bo7Y6pEmYY8dwiq5cjYXGNwzxqLi6Exu5mgPwfI0tvmqJ7TDi1/5NARDofwTKdecIW3sP3RkssT0+X358jykJgSNiyhA4tjJkV2jalOqgzB1E1PWp+eajqJHwbvK8OeiJp346ReudJDdDlIR1TUU/ZGb2h+FcJI1xjXsZjgbwYMUY+UELqU91QpPbodAxRo2AWrPSYIqRFKSkDbVdnBMNH/lzZwbABc6ATWEWPlpB+1E8iLvm7Ltf14E8G1uJP/Kxsrww0gCwOKZ+UdpfP65+5Q3u5FJEyVmFwXZRFtxdr0HyoXpBKAzYoqapgx08PbO1uPeQWSN01ZYYkOJ5gDZ1cRp4RGL90zEht+x3/5MOloHPRacu5nP+ZnQ1MaGimhdyNDS37sv9YwwLree1eH7SySsyWOzGBnKQMhk+MKNqsaWKVpeaUdC04yIrtbsup/ontKAe7fwuLBLkz1QbuZReljXviSJl+D7VTIfS2o3rs0K+IXJYf6it5hEzFsCdvd6OSmxfvaiqn0fYwjrHZuQPzxOHe8Jmu+Ea/be4dWprFTzQjFWTms6hArGHV66
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd924b1b-80ce-4e38-c95f-08dacc3b5345
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:40.0284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3T+MJdPUCWp+a4CdnplGUvQAjft7tkoWtJ6E9swgH0X/npJ67W6qAq5tI+MydrHXlwy4mzY8DUUaFyU+eZ2jmD3jRes/Uy/fJWCfsTQraY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-GUID: rHgmJtWe-L17T9go6BMwlhbg_ginrN-G
X-Proofpoint-ORIG-GUID: rHgmJtWe-L17T9go6BMwlhbg_ginrN-G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ses to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..fa9966331670 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -91,8 +91,11 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	struct scsi_sense_hdr sshdr;
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+				       SES_TIMEOUT, 1,
+				       ((struct scsi_exec_args) {
+						.sshdr = &sshdr
+				       }));
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -132,8 +135,11 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	unsigned int retries = SES_RETRIES;
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
+					  bufflen, SES_TIMEOUT, 1,
+					  ((struct scsi_exec_args) {
+							.sshdr = &sshdr
+					  }));
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

