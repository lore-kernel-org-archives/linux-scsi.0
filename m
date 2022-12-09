Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD224C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiLIGQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiLIGQG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:16:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6311A19B7
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:16:05 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B94VD9g020087;
        Fri, 9 Dec 2022 06:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BuGVhowifuGV6RuPEoeUKppwXcicwWbbWqztmVohcoU=;
 b=ca7yWpe3ng0/I0g2BKu8z3IR9xnZV+umIypyCUHMWOjg9U6P9icjR55MU/QuMZYUTQlN
 8xAS0P7iuhk44bnsND9f15C9Ky8Gws6r16htw8ffCPDtT4w5MFxKrBBlXL624u3Noh95
 2ZCvytQjnsRnP83uAivG2dyC1QiEELcBTNDxgtaiR/KfNdFtOcLLGqhmhyNvmX+V8AzA
 6ijc1Uvt9xWAhSYJEVDjztctuB1qlyWMoQOP/h29ZLqeiCZf7TX+GljYKx4W4VPbP4Mh
 AmUfNTD4cN/ByCco0NZvG9RiortaRhGJ3BXnky+RUhEZH3HX5xUQtrIfTR/+yy1berJh NA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8mcq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9413CT008380;
        Fri, 9 Dec 2022 06:13:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa61ymwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/qX3J54c56U31GKBaMFSJOpAAlhFxZED0/xZK06YDPzonCsOdXrtIFOY7gP/ZsNdfj/FJtd2Pfnr+p9at+DIGKQJgQllmmQaM0TLgZwpxresb6OJHkqSnOTevqZI5vl0E4i7OLqA6/KlFI6xiV1mK/X1pAYaX3BaXfqfDKlULm/QEfyRABJZk7wlxyBhwFz3+o5Ps9gZdKQv/ZQIRJ4BGRr3WNOZac3ZVQRxi5t/CGP7P5BSgeFpM00F2adUIyYHTR39aMa5IN4FfBp8Ed24YqO8aSrGqFfPfb8AhU0j/o3QIatI3XF/8ndRHI8L9hqMmkOx2trFX3qt6iiI7roXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BuGVhowifuGV6RuPEoeUKppwXcicwWbbWqztmVohcoU=;
 b=jOWkX6/IkYUqIHTK80i7Pzc7fRsZkY8iMAN8M0XcMZ06bsiVD+0OcNFl+1jSmHaquJWrvAOfNXVUAruZJRnhNmBhf0bSFJGG/bPxKG3hrgUgt2ZtVrOqtOGJ97VwP8LTulDp5BFNKUDwbbXapwkHai6zVECkIz7MtYhC83/7Mc4Imkk8AuVmdV+6p0tePm2GgMuGmh1lzvPFoBiwzhjvcg4usNV2vhHMKkMWJN2LlauNcccIOSm7KFMQ9N0JMGlHJwh2lhevAi5F0cjEpVfCx4S8Uij/tPyTiHPEyNd6iMZQb8oz6fTj8r0g7PkLYoyc5yzjrL5Qy6+tTK3UZuuIBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuGVhowifuGV6RuPEoeUKppwXcicwWbbWqztmVohcoU=;
 b=m+7Jcz+d/ZWI7BpOcwtG/lb65oQHE3WD8nlTcPUO+PNtA/IK19SQEB7LYB9i/JxU6fG5D3oy1XCXpt0IcyOy/EJgG8tfcPFwynuF71/zUAzuY54sJw9XxQKe1oBoEhzvKsX4SuxB+plzk6KduJm8S5PPkMESinGwGcWQIHU8XdY=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:56 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 13/15] scsi: target_core_pscsi: Convert to scsi_execute_cmd
Date:   Fri,  9 Dec 2022 00:13:23 -0600
Message-Id: <20221209061325.705999-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0030.namprd18.prod.outlook.com
 (2603:10b6:610:4f::40) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d3481e-5507-4164-a79f-08dad9ac8c97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgFO5h/5Wi4+5UOC+JS8IugOiUxPTkPxTBulvqEtsSKyNwVrl8pWCDyy4+YI1l8b9GDo8vIfTubsreH0KNkY8XRzpX9ZEn7zDhTCMH/k+kgxrK8lKk7fhaa4OYcbVGq6QsP9UTbDVCN4NxU2kp3P6TTKICiMPpW4/pW5dWxsfaIukN1m6bdEljpES2xBq/IO/AS2ZmX/qIT18MpE8U9EjyOFmz1wZevm32qLA9T8jGU2JkLQ5Xbe7QwPiS7M9R/a4lm3xYy70JzNcOtrJhshQOWlElgPN4ozBlMWA1DCKxB5iT0iJ2uDSjWW2l2WbpoxUErMHGPTm1lVCaS4JLOrpp+XbLhmEzxRHD6FlNeXHMhw4HxVacdhi3O17hSG2QhqOnkuZ+DryC6eSbPaKASQel5hmP5SgYX0iI5US6rP1iDAeXoUO46sLWQWjS0FoiTivKZFZGZRtagwzXgSHu/Rd2NFESlEsbp0CqUTlei34P6ZpPRdvdm6LH87TD50oPd1k36VQRNhd/gkI3eyBbMW+7+ci5rW4+ncOoheaR51eXmOUWVy4eW51LGh0iSv68ySNt8YXrLB8TAGOZh+JeXkVvtPryuKOT4uX17perSwvnY3uh/ci3lbicKsvEiCUnepd8fVg5CCADQZaFKynl7SOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pjeKyysMhJU9bdBjlVaK/AUDi+UYnJydqr+RrFHlr9aoNkxFIIVkK8RUJNh2?=
 =?us-ascii?Q?wmxoyYADCNBmz1dL9tHXrbHDgAYjIvTHvb3N/CjYLmmokpJX0HBdOkCg/mCk?=
 =?us-ascii?Q?dLkqBTYgLGS6DNY6Zx7bkhuRe6RZU8CFhLYDQDn2mFXGi52wDq702u0MBjsx?=
 =?us-ascii?Q?SD1RgKvV1tUhOb908HbwUAjRJlY88IB97deRq4vlNYm7b438EVAJvnEzdUZ2?=
 =?us-ascii?Q?X/XQvwavf5BT3Bze56H0T80xnWiqVBDSbkvep/7kFp/UKhzj0OO4qNU1JhY5?=
 =?us-ascii?Q?YdCF5ODDBuc//5dpufeDE6MIrfhgHgJVPHqLFQC+wamlcVOlMfYkk6RSKfeO?=
 =?us-ascii?Q?4BDqTGdSkcNqCCZ/m4CqdYxItcYM3d0fn+znAvGTJ8MRmvNbyuyMMBlzJrFU?=
 =?us-ascii?Q?HpFMIr8qpSfO0tQ397yhzF9RGcHZefx892+WjsCQ2Ee44EvhcOL6vOFHUG11?=
 =?us-ascii?Q?NO5lqJym+aTMBFkLe3bVGOCVgVhAJKcSSv+KOrCfr2r7w+zTI7iqihga5wBr?=
 =?us-ascii?Q?90nMKpULbUUm7hlkg6iBcex1vVBgA69C6Axp6WZMw3UCEWyzzDxfgiCyUZwr?=
 =?us-ascii?Q?8hOs0QAUkCUCJY47r3uaWFyvR9b3abpnZY74e3qNIHq/086JjrDar63JNa/F?=
 =?us-ascii?Q?mkuFmv9TK9SkqYENjmISBUQF6zdQ/dD2AKoHcS2kUdXH9oNDcmJygGZy4Oem?=
 =?us-ascii?Q?Wd/k/eAU323LgNfAAzwVHRivHzxboW5wdXiA+5wPW61ybcWqw6Uab6w6x7nw?=
 =?us-ascii?Q?MM7hHYtHVV++pe+vleD8oNm6YCCA7yv8AvfCfQGaPqJALMjUd18PZVCwEK27?=
 =?us-ascii?Q?OEBeoA6mKPuBEZvnkboJXGNf6TYYojfi5JWbOVlXP0tz8kRwWEO0moeyvhpR?=
 =?us-ascii?Q?HYO5+DbsQ/BsCXivPBI3fYkA7GMFnQQNK/KiTilEUgX5VW59v38nWIIETBoR?=
 =?us-ascii?Q?xD3S97VA6R7rwdJq3IaykYK+2mSHsiG7L9GgKuVgjYEEsxWHWzBs2s8wxKcJ?=
 =?us-ascii?Q?oei/w6hKd2fxJNXpGOP5IQNVUDftQMABYAGMp6pLH2LmJHS2LxO8wHXGrUw0?=
 =?us-ascii?Q?yx7OxB6CN5qL6LCN7w8p9EQ/4mEwP8cQjp1niZTH0v9xpNMCEmVS4xzbyT70?=
 =?us-ascii?Q?8nl5C4ZVBuwV5asnH1eYJLF8Uw1ssB/TkuNMSht0h9XeuU/TsuwZ6QfV97dg?=
 =?us-ascii?Q?ihTkBJY+LJDKEIdQy6Nd98sgknoJKtvCNO6rECjhw5fZwpOI0g/S5xFPsDZ/?=
 =?us-ascii?Q?e7var6DQeCsbOYqMuq7dtKSNG3lxurf2FVnzNdq0c2L9FzbkSQhJ/QSOtJwM?=
 =?us-ascii?Q?HIiOHuFAyH8FhUJMSEgvcUC11rE0ZQMwzq4QwLlTXgs4kGs2i/4m1pvuOKkc?=
 =?us-ascii?Q?lcUAGQ+wTznluOgsiSYWopj/wK7iHrlTVCnI47H7vRsAR8GCfxpHnD/iaI7I?=
 =?us-ascii?Q?HOLM5ZRmHA2y5e99L+ooZGZc9x0u7QK/78BXuSgsGWOZy48QrRgSL6hxQTv2?=
 =?us-ascii?Q?AnZcD+SB5T4J/kNiyCHkKiZqAnbwL5w7PwIP0ZzvTFsUxEWxuf6L2TO7MtXE?=
 =?us-ascii?Q?PP2P4ELV49kfPtESvdDTK2ixo/ZKsE2imEECIAn5rSDw+fOgteeBt8oS2r+9?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d3481e-5507-4164-a79f-08dad9ac8c97
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:54.4572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxaENQhfP+X2xk2FeTSKeq+Eif/AQA/m9Tnc77W/hVSrqFMter1/Z1KfbogbVnwQ1AUotZvaiZ8C9CrafJfKQAyiRT793O7BfLEiD4Vt/uA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-ORIG-GUID: jOtz7wsUZii1jsWdPqT9VzcHRnp5zp3L
X-Proofpoint-GUID: jOtz7wsUZii1jsWdPqT9VzcHRnp5zp3L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert pscsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pscsi.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 69a4c9581e80..c9dd5a98800f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -144,8 +144,7 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[0] = MODE_SENSE;
 	cdb[4] = 0x0c; /* 12 bytes */
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf, 12, HZ, 1);
 	if (ret)
 		goto out_free;
 
@@ -195,8 +194,8 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	cdb[2] = 0x80; /* Unit Serial Number */
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+			       INQUIRY_VPD_SERIAL_LEN, HZ, 1);
 	if (ret)
 		goto out_free;
 
@@ -230,9 +229,8 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 	cdb[2] = 0x83; /* Device Identifier */
 	put_unaligned_be16(INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+			       INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, HZ, 1);
 	if (ret)
 		goto out;
 
-- 
2.25.1

