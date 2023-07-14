Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD39C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjGNVfC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjGNVe7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:34:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ADB3593
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:34:56 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL49xQ004095;
        Fri, 14 Jul 2023 21:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=KmI8Y38YF//rU01w5PKjCUWggEfA6OIWeI9DBs8nPaw=;
 b=pr+s6NMKdKkFeq70hjd/MPz2/YkEF1mu/QfPhXTLB+Ni031Bw+0PA0IRbZ9Iz8ormW+i
 gbLWByp8LvIc9Gwqx0CPMIfUrJjl9TFB3oCdM/eAqUHpRj2lVL+B6voVPjuImxn8VYRo
 8ePeJNj4qryGEIWvUW4Iy7voVpfx9ApFiLzefAbNKvhs+7brFPaYiw2Rb2NIc7MMjK+V
 2VWgYf51DRhMLccYb5nX6aEmTcW7aOhu2k6CIMOcMvwJG/2EMTKHcmifUAIvC/DPccFf
 9aiUiqB8uCSDDnelpP8KR/nW3p+l3hnvGHJ/g/xHGyIs4eTApgqnSArozzzJ9HBMfsfo cA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpth2dw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK45HM013796;
        Fri, 14 Jul 2023 21:34:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91q4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awoju5mD6xvN/Zf4vOTc+wPDE4jtApjZ6yjYYZQnbZS2n5v49NMBwBCAqtllpno6pABxyhuozQMbEsj89miujKGnt41y06S2f1eEh7MdSyZb75bSfbRkxQexRVufZv7cZ2uKzbNu6SSHYfKjcO4tPFnOHgeowcyIDGDzD5F7d3g3oxCHrcfWNjlTlhRnpKOYOjL7OxVnNvx05i8gfEvEKycILCu3MXwHu5WYrXW0EW7uhehd3ZJs/zPcCvIIEsFcTXaGMhPTiBsclB9Q05OZO4EC6ZoNyDtlJAY+X0YTpSTNvuEiQPmRbPw4CPcNKEIWzR9Cw7JuGEgR6/Zkyg6lSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmI8Y38YF//rU01w5PKjCUWggEfA6OIWeI9DBs8nPaw=;
 b=LPFxRJvQQYy0t1sgceJtQoebQXKaTE+lRGbU/oI11fDWXw9NYoMRem04EDXfOUrsDuwb185ACC0hoo10vMwnNDABfq3Z0rw32HEnQB0U96OuGaW+PvdM9lwVbdxnX3wxq9So2oYZdNFgkl4AICBfPGNYIQDt5IPFHAFRWzn5Fgv1zG5oACJYkitFBA9IU69c6TFS4EhZ2JEz6oWc/SV83+zCmmxbwUigcFm1HWvrwkFBJ+YzCAjC6fK5HVHlqs4dUTqA5LNLUDV2aFPtkxW1Gnsf9dopNPXfW4uZYGmc4OPOEo0EhhZIFGV7WLDEkU78foq5NCi+KDZC8SyplTU0qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmI8Y38YF//rU01w5PKjCUWggEfA6OIWeI9DBs8nPaw=;
 b=DxWAz4nDa3ZS7a5CLtpxz4UbSV5YbJ7U+g22awMTCrM3VzfVeQcRu0XkibYv19UIkLmYBxw0+tNz1qxHkrnRgSZXVH++KI7z4jBdY4MEvZjskRZZCgQoXYVPALdr94X03X1VdBwUM+k1BOdLiHg+BNVBJB0TGJyaEuUqQjGR11k=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:43 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 12/33] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Fri, 14 Jul 2023 16:33:58 -0500
Message-Id: <20230714213419.95492-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:5:80::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: d668b71b-91ad-46ae-e952-08db84b222d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9UPBimO4O02Wl1Mf+f/71DSD1EVCUIJNI9QUrgEnuhoXoHgedU0QHALiIkiBbC/Y5/y96JlIvwfMe5uL5CTHuLcJdcHHVOVJX24KXrVWPp/a4ELlIboEUtgdzlgm7LKtHeM9aa8EaWe0heHN3eqOgle8g+tUKLXwYnys8n558sgyhf+M/37WS1JoOHcnzXk8YJbVCBIdZE3bqFbMA8kVJ8jWfgtJC+lIY1I4RFBEt2LZOo++H8I15TE96glFgbRZHcJxu3P3nR79J9W0WFSreQy0KmKawyzs5F1AXybML608Tjw9tWhffYEd9doN7DSJU/R2AzY9bK5WNQx2hL4Dv/5fyz3gpzCHl33KodrVRCzO/Otlok9gQ73kX5yFt+2HmCUbThUhDX2y327dnqBU2o/LwyJf9arZykIQ9zF+uPUMpxvn+s7DvaSiZpk44XuFddoHFlDxVzJ3yM9Rk1+OTa7EXHhUL94AbgrhlC8QVbc7I7ICF8MnpqoYrYteMLrG3wyW71+TqBN/bwyjYgl9up7cyfQOwe5rFseoIRcZSjfALJHCF9qO95tapWMX2H9h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(2906002)(478600001)(6666004)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WDOeGZHV4D2vGABn2UwugGgcxJonjsxQYKaIK2rSFdjf9TC6OPEZyJbspUIS?=
 =?us-ascii?Q?Qt79EKKjtDO4x3/qpJpzpvBodOuPrnnBuCIRSzyBtNQokbrLf5esnCRD/78O?=
 =?us-ascii?Q?q1LlVlpBhg2UaM6DcrcjnQPruzJYt2i3cDFq6UqYQ68SM6PouvbagPoj0l32?=
 =?us-ascii?Q?B89H2cdhI00J5SaQ8i896tV5sAiHZcO6uNZlQWf1cARAsHceInj9zaqvf+HU?=
 =?us-ascii?Q?g3w5uUqvCOyP/p3CIyi1CMmkbL5UOZ4tNBmtSuoaJjyXXrOEbu2evtoX2Poj?=
 =?us-ascii?Q?78iHknSnaI5HDOKHadsLWVvQsaDkUwJNhP0ZkmIM2x7Hqcn6/IVZ3xZbh/Sf?=
 =?us-ascii?Q?aVTIdujnBJX4EepGyoYJfNP28lbACn8xQi7lhWnUJUxQeQps8+Lzk18byp+t?=
 =?us-ascii?Q?j66RZhyGBxcYDycJJt/KCsAkN/pmDdBqy4tPato0HJgT1J/IWtKja75jyOhi?=
 =?us-ascii?Q?KnRv0sFJUr/TQNWmXaIBB4ail3WWVSW+dGpL7qdzzxYlBjVlT/jiZU/M8GcA?=
 =?us-ascii?Q?SYiQIpWvMa5iNUhloeckjGVsWaXi+vhj51cj5G9gYQsoEx6KY/c4dTflbJ9B?=
 =?us-ascii?Q?gZkpX4qjGZWYE3f8DL/6IEke91kkdGXP2DJblr7ivZyr14ULIrV2Sbkhnhmd?=
 =?us-ascii?Q?3XaofKMi7qOpQv7rE1xdXshlTgpCEYk+yUbi2+ywtdye4Y8KGQ2sr0s8tG6+?=
 =?us-ascii?Q?VvcY+dxeJwqG7n2Jq5IagdzGK5rM9Hfr3XXVS/g+ojTwjhuic05B/XyyVe/W?=
 =?us-ascii?Q?olyjyI6/nFRmc2srztWSeVOTyL5w2SWblgdaRRDs6+/5vlcoXK/OuKZxy1xC?=
 =?us-ascii?Q?fyMCxitH4z+t20rXLoakmavAkxShXOIKdlP5HsRn5FnmmUHeVpYZpaRMoekV?=
 =?us-ascii?Q?YrPR5GBI4f2kTpHj7Mzj3FYiYDqlcOIkKQ5tek3Gcwu5+wZbtO9MvmorTgZu?=
 =?us-ascii?Q?HOjENLzlOUQ3iMLVcBhyUCe3cQixxcLU5cy2KZB9IxWt1RSzNrRPm75fjSq6?=
 =?us-ascii?Q?1Rofzqd88KDO6QLFeglDNviauYyu/ueDQUFJICeo7Gq2773XcE3LyLRlBtgG?=
 =?us-ascii?Q?HCCUYSXudyF3LCaXBIxhs9myeMs8bpWSWKKYk+f26cNq3zXoTQ/hWSv0zLBj?=
 =?us-ascii?Q?Yk93B4WKyJqGgNM4oLR5dYm2CgpdlTesS5KDHXSgRkxsEKDm5PWyKNef8O1y?=
 =?us-ascii?Q?lW7RJoCWNITNUEkyHCkf20WWUEr3oPIc6y9xObcvJ47H65oSb7AoPRKnUgk/?=
 =?us-ascii?Q?MmdCnbBec3NygoCa+4Gxqy10zyPdWNCB/hXJSTa9JGtNDzE+MvfhQlMpLaa3?=
 =?us-ascii?Q?OFiU5wBpCt2pTZgVCeKASVHJFK4122i/z6ZcGZKauconxNnrnsgzcbBnWTSu?=
 =?us-ascii?Q?c8ZFSME9xIP5N80o2Dg3oYB4qkYrCdV0vKDzAnQ25QsG0m4fykj2DoSKzMQX?=
 =?us-ascii?Q?kfcln6RtqCskNthdMPlaZUOhel6jHT0N/Tb3ze5UhUwWG8kvgOI1by6LMAnm?=
 =?us-ascii?Q?ZFYPT7rIBzMSdUUUYwvxBKay9SPYilfr8007oopOs/ApaRPxPpieQ1ZmwIdB?=
 =?us-ascii?Q?0/Z8nMIqnxPFOtQXK3xKBo6Jz5P9+uWjyGqWe2fdvi1MSjbVd6T3qkP0sqxa?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HnxNyK+4Q3CJQ5HWYmWIV7hIPGxaxq7ksGISJXWvEDPBLMEOoz+PGn2a/YJ7Mj6TFlEbxJGdvnTVYiete9phbm2NHAlAkjSz6TQRuFy/zIdMkD6RO6rgjojc+rF+0eSGgDvilxDLoHIA75Mmo2qCPSAp5mvKAJhtTBMsTIeQsUXkowCna8FHuYJT5kROSr41aUG1sHHJA5qQYtsQcWBmWiRjfUzfBv3QcwSpQKAlSlKF5nxH56fRqcFFysQg69KUMqd/loitG6Ac9+ZCAhM1V+LBiTjXS1e75PG2eJH+a/nBjelL3V4Fb05Vbctc6YOWKZrnx5pHnY1uK415Q7CIMl3r0DbjQfNo22C5PfJPoQzModQ2fT+HiDeZWJMEBOGypE+pcMJBi/9p07nLoUD3l5LCIcnCnKGdn+GPf4m6BWNHGBGgyIIOHKS7kLiHS62n+EL/11puXJE6xN+PYpv/PRPw7ttUHzUR//QPov8gJYXq5IRxoUvgurz5ja7nXmakTnyYZ0XLH4s9WoSRioCIavQ1TBGHUYuXLDLTdWxAdtqMzMyDGHUTQoVphq4OmHmKsnpE9xRILZfmJ0fmewAGIkQWqA+ePOOv3oXChzcEMeVlelIm3bo9ZFQxcMukHjx33jKlaGoTbKPVlc+3J++7NJMbj3qLz2nceVSLtfCyybR5MkZQaJ7nCWBR1dvPt0lV40P/SOCBy5ovHI/xyjxNJLdnmHGxnBtulKBvXqFHAunLQijkZ7e1SjxUueGlaN5m3KaZXLIWvqk6rgMEYZvoqNFAKqyJN/OkyVu1fKxg8fxmGI+QWjcqLiRi2PEiz6ZmQ+1YYWPojEGLaTXvkyBcrO0Uu3bg+Qnk6mtE5svsmN5Q13XTjY+tMkcHY4QQGU80
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d668b71b-91ad-46ae-e952-08db84b222d2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:42.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3YJHI92pzoYZe25uUj0sk+TeVQbTTb1I7b1QeiSofmvJN7MWVk+ELPfE8C2VsK/RN4+KWVVp6cZ/mTtg2phKGt2pBs1mUNoT3RE1xLJTAIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: IgH9UkLCu4hd5IoraWaHsKfcUBwu7StM
X-Proofpoint-ORIG-GUID: IgH9UkLCu4hd5IoraWaHsKfcUBwu7StM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 42 +++++++++++++--------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 785ab2c5391f..e25161aa7b77 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,11 +82,21 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
@@ -105,8 +112,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
@@ -123,14 +128,28 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
@@ -143,13 +162,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.34.1

