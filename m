Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37282C41535
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjKNBid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjKNBiV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D851D57
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:18 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsNM2009055;
        Tue, 14 Nov 2023 01:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=6XVjzyMVKuJ7EPCNXg0h4JiOQCS6wjLoyflDyLvdw38=;
 b=b9AEWlROSz1XXVImzFXLiOlyleJBuZEdt82W2oD4EJTN+qRahnjOL3UClmmHQo4REN4K
 hc3X/2/icVvPRTTZJAbnKP0lXqYs6XofJdjdUC3neg5vJ+dVMLKby0pde0J4JFgrB5Mq
 klJejeVqIAxnSzIvIizyoXeACTeu5DSwFXCUvzXKFZNSpRcWxqrsnu7SD2eDFo6at+lz
 MT9OvoD9T/u1Fx22AzJrb1CtuHo2vcsT7hoanW4FV1sVC8/o/MIQVeGSZ8xvtSOTO7SP
 ynZyLTmcapu8B2BQBncG+/XY1BuHeqFjUhL7AQ53GYJs4OpmfPzGcXlaD/f33ZvFRZQm 1g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qjm56e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0SxC0013517;
        Tue, 14 Nov 2023 01:38:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj193s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYmCUwg1D2Jnp7xgOvUQ95uIu6VlPHqkHWaBp7PrNcUlh1kRK0qoGgI57Vd8C7oUhS5TbKsl4x/iBtwA1IRvDVOUh+Yt4sh2MjUEMF/g+tqDaWxafiakVxIRqAYZoGvMrbaRhzYngKnrrMOg1o28o7l+EYxwGE1WSnBthsk/A77wttc6rmRLbEPHCnagpzLzTbkVNa5p/6x9SMH22l7SPFzEeW7GX2t8MzB+N3aljoGZM1oaplFrFl4TRGNEZeQeWyOUuWrVNbMcQ7MzZGD+/NjxFkmeeyKmp7smcrQn2cpML2UUtTkvZ9nuXVD1NxWB6i5MHHoewSU7saxtYFo9wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XVjzyMVKuJ7EPCNXg0h4JiOQCS6wjLoyflDyLvdw38=;
 b=g5+lscU7cWJjpCkvzrqNqFkWZ5FJctO/dwwUUVqBFUgnoCGmm7E7TDTRB/wGHCMBKCf/TMLunOFwlOgtUFAN50EqwWN9tukor2mE9E83+UtRJbk3WM1qm0qIn2o3iQALO0KB8HqNBush7NrIQciHP0hUJf6IE8THrj+2t0FHGTYCiHdzUUexe7TZ7arVH/oKryevps0ybp8HAx9D2rxHCPx88lY7yLCFGbSpjR8tNSTpW5l2gPuvdekFs9zgikfTYIlLcp9tE59yQkEoRDRNl1z6//8AKa5AX+PkbISx8jWtj+GoWHKwe9bKw4Arub8iMODnNpvo3bdYUUWCeF3mXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XVjzyMVKuJ7EPCNXg0h4JiOQCS6wjLoyflDyLvdw38=;
 b=cKrOxUrMd60w+wiLu0YFCzu71mAsWTzrVLEJxCe96S9fr5IEEgmPxsQOwFU/8B+QtmmO76OfpGO3hcSfALDX1n4kNXDm3sW7jyeQrYIWGRgmj5uewa4LGeTsvRobdCUFmQ+XiaQHzEdjVqix/AW6yIJlWZGck8HTI/Hd4TgGTZY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:09 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 13/20] scsi: Have scsi-ml retry scsi_mode_sense UAs
Date:   Mon, 13 Nov 2023 19:37:43 -0600
Message-Id: <20231114013750.76609-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0025.prod.exchangelabs.com (2603:10b6:5:296::30)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 214c93b5-54b8-47e4-348d-08dbe4b25b56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IsSgJLDHy/K2q+/t5ZXgsZo+lcPt/CNzyAPrNAbI7/PaKYXCTNNp/eopaUDupwMA5pE5hf3axbK6XjdAlPUtmcbWrSycUeOLqlVZeTrIwab2ZkRB4RchpEkBMB2dXxEJCabJYbZNIM6Kwsm9MUVP4x3EeZJPPMVxk8Vdhoabbi42e/5ihOcs0zJq3S7tgOWssa1wTBIlIrZrfyHXYOHBuKTW3SkS1e/9fRao4IOVH62Si+VInruhN+Ec0dHINxH6Lhv2BQlOeYCmUMNZImlbycUMqLJ5QrGKKG1cU4+0uUg0ECre06xANBEv/Wve3jEVt63Pir6Q6myO/07e5vNQ02yU7X5vS3MtcZY2NNbvQV2DT+lwhyHXY7fpeKXU5P9mURM0CAVkFPcr0hIUSR5sPkgdFhr1VSA9/moYtJ+3eTyjzMAwdUGS6TIR1mym2Ei9tWGVtzoBawx/LK9X+5HH8VOCbeAkaJ6KaapyWCUlp5Ku4iCuMpLmriBwHdO2TR5RXoDngpWRd0zCytotb5FGWqSwDbc+7/QXBpC0fhrLx3XkkjsH75ceNhdQrCv4rULK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xK6n2wxKY4mBM4P5d6x0vpCH86At+0DEjEU47GKldmmRRvqZeyIESSdfulqr?=
 =?us-ascii?Q?/QEohSskO3RLozK0rcYLwD43rhtGE9qFoAy+znnxIf5U5vVkVyOs0ktlWLYW?=
 =?us-ascii?Q?kII51Dzbtc+31JT6Db2oyqd9d71j2u/DBL/eDw8gbk8bJOKwbTFTdcxopjW9?=
 =?us-ascii?Q?NIny10zjY6reTtHUx7GNF4o6oH4WkAXstfllw0tONUQUGLSjYrMApGuE37un?=
 =?us-ascii?Q?3iDwJoUkxWxaW5L72OfEj+y9lRKkDj4KBveqpvS55gV9rEJnsYjeiDui7H9a?=
 =?us-ascii?Q?+Xryn16vRc18YjwDI6w9JiwIGgrVsDK69Ec9pc7tplBvP13c2LEsjDvK2Rze?=
 =?us-ascii?Q?iQTBVUAIyCuJv+RSKAYjWQI8xO3/i5lwJvMFL0tJaJdsp4cc6BU/zYDtJ2BJ?=
 =?us-ascii?Q?aeJVnOzXNg2z6dJCojDL8b/zAlbq5hXwTkA4RlB3eqLzNf4w6S7PAR44qwww?=
 =?us-ascii?Q?XfESqATJ+IUPD7LvnxMxEA45h6aq/5ZXJcQ3ikXG81HkT5HSoPe1yITMESSy?=
 =?us-ascii?Q?zqDRNhhsb/BHgCaaw9WHmI6WqRKN9UkE0eBhINn/LId3fZUf8+e7uG+yZeaJ?=
 =?us-ascii?Q?hMZ/app6WE2U2x2mHdBD3zRdvC435p55OD59e9rmII9ObDtgM+z5vReZAIch?=
 =?us-ascii?Q?wAQrzIDea2jHIbEKZzZaHOdmFUBUqG/MYMS4C0PVjNNpQRxrL4MY+PrW/ILL?=
 =?us-ascii?Q?vZd+59GaIBkLivMl8jLRxcv1+/EgWKdrime7GkMfTfhUlgPBcLpB1NSRmlOd?=
 =?us-ascii?Q?mcdVO25HlmXQXGG58xcPT2H01DnDeJoCqYqFBPmvJG5NNPBgkeZ9jGLawXGI?=
 =?us-ascii?Q?MzBchNeBZZCU/laMO0jMo2k8H75wNRKJOOeBp0BxU09OnHiUVIyLTWlKMucu?=
 =?us-ascii?Q?jWotd6/wqrn230FczvLb5wfoEtQ/HFjh5NCIjh9l45RkL6dr0C8zq310oC+y?=
 =?us-ascii?Q?iWpoPWcz25QhTdUOq6MkS+tD79Bftg/weersH6HxeKih0DDKCMhd5Pbtil6X?=
 =?us-ascii?Q?vXQdG66lHPhfsAihe+IZqnkRkO8oca3FNc4HLRI2s970D5Ds97j2iU8SFoQI?=
 =?us-ascii?Q?f3KsWcGNQNaCKxAr3XAwvC79VqfNPEDLmbDNdxxzGjcgNtNSe9JGnABCxniL?=
 =?us-ascii?Q?Bw0hqNj5+38oETv8osd3R6FF5HlYxKkCzPmhrA8v2+FH/++S3EdBKGDlasQg?=
 =?us-ascii?Q?zfmU6Lyoc/RYu5pFIqHW5GK+IGCVKtGnvIXMZL+S/adNmqL/de7314RaiK1H?=
 =?us-ascii?Q?K50vJJ5Yl2Tkz+RQwOK3UoYC/ZNGYRFgRDv+6tvyOj+FTEstDCRg5qzmGC30?=
 =?us-ascii?Q?7aipQsLSJXaTjdsOhruvYN8XyWMVN4kxpe5TGoQphOEYydCKoxR1/YOwdX3p?=
 =?us-ascii?Q?cUubpK7UuF/2acZO/vU8nXbAbuT1e1DQRe7Q7rUus+KOjiMoWklwbspcfoU0?=
 =?us-ascii?Q?YaMiMsWGjEZamaJ2HSZulvIP7CATguF6qj3LDSU51wqjWOyGwioKml+SO41g?=
 =?us-ascii?Q?xZGSHG64WuGMSulJuh0/J/R9oEMcQpHxQib6i106vWow+ZRuFi/yqnaqb9gi?=
 =?us-ascii?Q?GmD70xq8HkULLOb9fD/6SCj5pr9bUgpgfyBhIsHJ0I+aNeJ3pyAFQBnAVqBX?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BJTl61dw15GiwlkTzEU9v2v8gcM0jYa0xK/wdXMChHGQMlDG3n8mvF8Emxygiybzkzpz4yTl1SvNxMWLsBaIYv6e7WngReChvXT46mX44XjjmWLZ1rCMFPDnKeJjJsrLgKlrK8YMVOs6YWw7ijilAOkerUsS81Ny/Jn6VaDZ0hwOBqYVJkmSHs7noZEoKZiSeu2dCRskkmrFyzh3RQNyQbj6SxtWlmFrfnp9jJXUoHUhSakTvmG/FoQT4+I2u0+Kjd9kD7B/Ob9pRWHnuecznZvFqgHq2A7hmRsNxLrznyuzpGneWFV2XM4e771UwQ2FnUdgm/CIjRYfaJ4v6IIG9N0InXIbu1KEjSw2yjdqfkieUytY9TtZpJfuaoL5vlggq3RtUSE27iXPJBqLn8jfAktCEKSgsnEbG1dIQ3NMhH8WroNz+IR+SnfWjV+A5PqiafoTW+kskovqHvsV3HZHgqOC2C/iAYi7tgpZrYfUMMnqVQtq9DBfm3CsZGi+fpDL8TtMxfwpzDmRjp147fbRWy89dJcE9OaC4NYvOzLbXs7DYwhUxB0K8/Uk6I4+PBqAakWs17OSDFeXWs/D9kBXbmWpy6+DFVdzCBigi2KvRS34753vETXGU8KEL+AQtBL6LnyM7NEWa6N5LVln9XJLaHxAx7ODpClw3A0oKtpoCSpkfpAfafu5M6GGLdVH73UCQuqHVrsCrxOZoWdCgVx/YoguYI9h1pV0i1SFiVc2/DJ09DBXzz94nS99Vsgs7VXRKTQ1u/3x4wN9tg4D1STkkUwsYgsjy6qEA0X5BcSmqutmh0CpE0JqdyCBt6tyrKTXEnmHKc8kcroNLC6ZVhQSfFdhfW653jfaxJ5ykdL4da7jUSvxuXAuWsOtE+mNSJS8
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214c93b5-54b8-47e4-348d-08dbe4b25b56
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:09.1518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BE9BgiygGF2dQ2UBd0+srf2FYWfzi5iy62tbOU8jrNNz/msBwUcx0jhK6GXXWjsJ0xYq1ANsx1AQgeU3xXxSVuX6JoePKZb+xV6cEziAQzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: q1TguyWYjosYQEVG6wD1RA7xnIy472pZ
X-Proofpoint-ORIG-GUID: q1TguyWYjosYQEVG6wD1RA7xnIy472pZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dee43c6f7ad0..69c79725a1cb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2262,11 +2262,25 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		/* caller might not be interested in sense, but we need it */
 		.sshdr = sshdr ? : &my_sshdr,
+		.failures = &failures,
 	};
 
 	memset(data, 0, sizeof(*data));
@@ -2328,12 +2342,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.34.1

