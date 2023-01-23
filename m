Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53986C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjAWWOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbjAWWOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:14:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107643A591
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:13:42 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLiDnX025136;
        Mon, 23 Jan 2023 22:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lZ5SYPXfZY3lLNsmnfLK7nwS7WHlq3O0bKCzK2LHI3M=;
 b=e48zq3jIvg/v8En+HzCKDEZsxJusboDNH7c4hg4Ndi3TX0ERQG9ctXBYaMbo820qOawW
 Bf/tCmKq3P90x2iDWoGwYZCT0pF3nTU7vmm0vmmHU5goHmboSLi2krk1aBk575gulJes
 h4WTkwbDZUpze1OZi+N71w7aDPAArifv+k1cmFseROx4ogryPRH5GTxTepGSDMc7igiA
 py4kfsrsF/moraXeESGQgWpPfLjzIZRc+s4mCzaL6O9djFxR1SnrzgsSah6/klwpjUb/
 ZEs3gw4TW5tbWLGvvs6suOnz5boy56JB3DuZUj246dtkIKUMen3F12DSaZ162F70SMO1 Vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybc2ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NKeOFM023165;
        Mon, 23 Jan 2023 22:11:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4e4cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3xivOfA2EqDxaLJLolNB46E/McXB6aSlI3YyEIc00IyLJ/NZgrVWulvjoqudDgUjVq0YPDd7DOnmRvC8PvklbyOhoKJs0fIG9j966yrcemc7es8vPUS3r02B8BxWEO1zfzJgln7drxHYGI2gcf2Mu60+tFHo4inMGiI3mtkdtw7jE92IGDAldls6erNElMW26UHcdi3HgeNW5d3b8eOAyHaNe3xlIcpsDfjiWH2/lrnXkj9gQtR1aihoKOqYy3sY+mhOYaOIF36xfTShQESrgrarAYKOmw0TSKwz9pxgaw2txJ4uOu12wRYBmTEXM6Qc0ttfEuKQKsXBQldRGfhFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZ5SYPXfZY3lLNsmnfLK7nwS7WHlq3O0bKCzK2LHI3M=;
 b=R9GMcR3w3e//ajoXgo7OBsgqkz7x4tgiNupPe7MGxgZxa0KAzgL6cQ71PNBim7HWw97wkEsDW0yz8doJ3CAaetg9JMKgHeuSI6FygnM+kgIActJkQRqJxXP4SqQzlZn6qoSxHMMqibmU/TTmCviu0Odx+1Cir8HtsxrYqzgHUzgCs9OiAShAjZkuVxgy1hzgtb2fMLya2HAlnjhp+re207li5TZ4HzY42H2Sw+3ivNgO4or/NHL3WgvVA4NQEI2xd+dnLIBeVlXJfwotNgqL4G7/g6wXc1i1fx4D0PpyORpDLUMxRIe0iEZGhFLZdrBi+A/UvSNrdB2s3+32/tWc9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZ5SYPXfZY3lLNsmnfLK7nwS7WHlq3O0bKCzK2LHI3M=;
 b=J/QTXJg3QYXW7kUzgaEFOoPT9jw1EeLyQtDdrsYCO7cH7dzKPxBzVhZ8ziL6pDdKqqzmlNbclW/3lfqpawk+SRyzITc5b9BvAnvbZtkYQEF3pY0cV7lJB4bKT+afBDvGtSgR/6+z9wbbPemYKla/JNHVcgkXslSyo1JTdLGxhbw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 13/22] scsi: ch: Remove unit_attention
Date:   Mon, 23 Jan 2023 16:10:37 -0600
Message-Id: <20230123221046.125483-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:610:b1::9) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f8da7d-21ff-4001-222e-08dafd8ebbae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ye6J5q8/PEzWIqS1viPbIHlhOsCBVwxunTPX4EFJeWhhjbWIYiRRqJen1f4y07i5xhStgrw62tTFEVx2SIdGK6uaeWCf76dVUCI5NEdtnMW6CZB4dNrM9rRGlYnAAiUT7RaGkfLAw9G3Shqno9kEMkYZCLTROuxzmu0BS0DxI49ATkB9+wc9RyI3XrERjCsAbc13iV/mPmud924iFt1m2La0VaWfQGyUdhcTvdkwE/Mthrisf7hTN81WPSWXUPl8e6PxsVcWFhHanRroVpMRq+myj4rTtu61plGQEoqC3kklWejXylHQDHiita8Bh0t/mY0+5V7nz5BlIp8m3x6ub37OTCfUy3vS9XdC11RWsp4VLps8z7Ntco/5Q3s8FXJuI68tmaGYR66OfEaLx1X/Y3edrhrp4Q2XObubQuIy+chL6UZFxAaHvrEuxwbh26DZuFVQYYSr+fZYJ5WdQywcVLLT/KV/H27dLi/JxNw+B3Rx8jOQmdhtDtFfrRKKKmqyXzrTkjSP1hJjV6flwYRYJBPailSGmES+fzzEHjkZmTwLK4r2xMKtxO1I2elrWLV6BW1JH+GA5/RIJWP82c2zugd6kM7dNLJO2KpyWUignAed/6M7ydeXMkwQbGZrnLVmkLGVU3z2GBMKn/kp2qm0Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(4744005)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d3AYDfefv6IeU4DfB6LGfvGUV22Qhqm6ulphQqilpejqNi6MJCGD7atCRk0P?=
 =?us-ascii?Q?BAcP62UDxUcX0WabsZxZHMZfMkAF3DXaRmNCGnqzw+eiK0ZrBxRlaZCGRQME?=
 =?us-ascii?Q?UEfxHUT9UIsrs3/+xzekBBE7/pn97ePFF4TZMiIwm1H76Itrj88qwQ5gbt4/?=
 =?us-ascii?Q?7/GepdZDgyV+AMqNmByvUzoGExubg0b7XTUCBMHdontLO3fWjf/QAcqF+//a?=
 =?us-ascii?Q?HjQS0DGAEhp5QGjvM+QIFRHf5XV4dN8NNyGFNAEq0cZmkhG5JxsHr+mEYH4p?=
 =?us-ascii?Q?LvdHgkCoP8Oq/JVDkAEmAoiStKLh1oWnUw7qV8Ff5flYA8qRlCms1fagD/Gi?=
 =?us-ascii?Q?ayx1aO5j3pHJbe23XV+K9K3yCGU+5uoW1iuwi0QtGr0uNShBMOr0GrV7YVPb?=
 =?us-ascii?Q?dZv2grr131ubHQXyW61xZ2mZ3iQdp6E9KG15A/uMwITp0ZKsemXbTGhjgDWc?=
 =?us-ascii?Q?jSY5Lf8scyv1yPpbal7u3y5TVCd/TVMYTaIANGHHeYeQ9STiJkq9mIiKUwpt?=
 =?us-ascii?Q?5F4Rj3IitiqjXppTfqXPwt4dgE//UgGq6FJwOYJn1iTgdbHe/V1UkbDk8Akc?=
 =?us-ascii?Q?JOMgSORx6UVHLwZJiAHoVXQ2CO+eyZ8y8mQfOtRuCRHBH/ewM/c6XdnIlwVD?=
 =?us-ascii?Q?EkWCT3g0f1gN5sGy1pfJCoFpgfj+cU0gHXVJ2KtaLrG39rASBEthnB4pFNcr?=
 =?us-ascii?Q?YW68z+mJrIa8aco1GHV6cOvq425bAJujsIA2cbCfBK0+Ss4lRCEqEPvmJd7I?=
 =?us-ascii?Q?rDqy5/DjeS1LNEAa/07aEec7i251h4RgkLIq9RgvYImBEsBahxbXwQ0Hw+O0?=
 =?us-ascii?Q?lZ/znm+9axUnQBaxkxXMFuTQaeXx2NphA+jTcbs3CGz64ifw4741kBDLBZH4?=
 =?us-ascii?Q?tdvh3zNvkJJEo6ECyczKnr2c439pr41eI0Ow/Re0hptszKbbz0z4hvfITJG+?=
 =?us-ascii?Q?2h0r7EYAGikK9mvddrNQpM/rkePAEySOCtPzU3MJMTibWjok2K0qvCURVxIY?=
 =?us-ascii?Q?xzGN03aS76MWEAsUB4gVsi/AVxLBgc2I7uDYFXTdqc0ya+OUPe2ntowV1CKV?=
 =?us-ascii?Q?yfBLhc/CYObZ0g3iPkDPk5uqRois1yH2wupDl6ddehP7xSnLHwWpzCtht1e4?=
 =?us-ascii?Q?6V3oOUkqVKZTmZoM3bRN7v9sXzo1ZhQxnljwJvnrxFoyQknAGPjo6Zgy8Y8x?=
 =?us-ascii?Q?YNIPyUSscXXiDJgzjHk0FpTY23xNeM/DdfLSBVwPKU1IpJLT+YNWw8IMOVOb?=
 =?us-ascii?Q?9d77xOjKw/gTFjA5EamEltHhqKcbJkcsO4Wt2y5jGmJKyyXlkxt5fGpTwDv7?=
 =?us-ascii?Q?sEt5r0J0bcVbkSB5KjSyYXY2uxaHxBGYRLdSLq/eNKCXXolHepZ6B886Nvja?=
 =?us-ascii?Q?E+Zx9aKJbhfqkjZJ+9PbnKyYbnwfLyj2BFM7qO30NAEurWS37Prsidqv03xh?=
 =?us-ascii?Q?EZHfXv9BT1+rvqn++Qev5E+t5PzfyyC0cS+/WjOTdIovqibD/u3vX9uemhoG?=
 =?us-ascii?Q?CJH4BRmoXaPk5HUAE8LMfuwplwqER82T7ymRf5B5jaJPV3LUgjEZPc5tCUwh?=
 =?us-ascii?Q?TA69vPjCfMnBv7Fh45dbTq3MF5ugozlVNhwad2EAYmtmKI8cv8mxHAodN8Ec?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0qxrRUDlJWGkfrxkuGQw3+GV3EruZig+7p/2jJqCexKkiQU7GZu3pMsJIe7eAyqHSWUtxPtv7luG9Ib5JINf1O1RQ3dxjK49nh3vlxZM0jYPVlTOq4Tjp9hoTl8DIN23yMeZDpGI9FcYTHCkQoUzjOgXIiNvMiQhlUgXp0bCeG+A70/2yR6fYkHa9Y9EqF9u+69b9loh/32QcyMHDKTaWANQyIuzhGWrAtw1PTdjKhfD28UMjmxc8f9OV/gIu+Z33Bh+L8NbpdKcdyrjpkTTXfwFIXhlJxmIRVzjkqmTNf186ESJ3nP2ZNIctXoMj7yEj+rKftUpiwi+BFNIayyZQL/kKMNJ/CXQ6EQR1Ugw6u72j95mES1hxILiZ9QaYkfVnSk0CUTaDUtS+Y9riVNgyey1vBi45zSZBA7UyU5pb849c4CdBT0bdwn7Xe4akLu+2z19hPK5WbvvBcUCk/4Ov1uwGMiBlulJHT6PJfyWwL5AbF6m6wywkTlFalcTeTr6avApEDpbNv7/cjWGbiqAfjvc14JIJdi3dEdoDXXTBcoH+h6gd2MFG3ylD5Mkf+bH6+zSEq0R8vFdGPV2E0SMHITpiFtbMl78IS1dGXtZnSBdESXZfdinjV7lBioZPPzv6/rupe2Y8RTtH62teAIFBiMeV4XSHkkAzWJrd23Z7KIiRheWfoPUiYA2Z3U0oqIjwxG3yA+9flahBlJMnBDrM9RNUg33w7YYAS2XRrDXog8gcR0FWbhlusjPLr3W10fCEgu2rk9C5lNqIhoM1iYT5mLPloTP6m3ZgMPeI0ERKEIGsAEzGN/QcITPdkF0ZqpDZuc3p1g9bJxumqQy1kga1JEMGc9mGb5AUO0635eIjdYE1NRuHJWk/XyXqvVSAS1t
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f8da7d-21ff-4001-222e-08dafd8ebbae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:10.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uw843P3rFPh03vU8CArXHA+nMN5AYZAkqpSigYlR0vLu4ISvkYnyTRtxvZLOA5n5hH63mg5nAf7I1i4qgcXO/O9B9NNBrJelT4M6IoX95TE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230210
X-Proofpoint-GUID: -3yILpUZx-3Kuj_Gf7T7e7eIhtD0t8J0
X-Proofpoint-ORIG-GUID: -3yILpUZx-3Kuj_Gf7T7e7eIhtD0t8J0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

unit_attention is not used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 72fe6df78bc5..87eb3ca0d362 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -208,7 +207,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
 		switch(sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
 			if (retries++ < 3)
 				goto retry;
 			break;
-- 
2.25.1

