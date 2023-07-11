Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A598FEB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjGKVtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjGKVtB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:49:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF38173B
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:48:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDBtv010943;
        Tue, 11 Jul 2023 21:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=F2r98ak+WJfCtcwHYGYZNcTTPE5SmYoJyLL5rjtPLso=;
 b=TL6HBbvqgUQy3RSGglhr2sP5eiGA+g7058VS0EEpWAk0gex+/OE8Okl16LjK6k+WVZv8
 LCoMYzso0Jo/RtHDmvY76y+9ttQMNxtmImlh0BmuE09Tp5pZjANv+/ZfWB/hd/pPEKdG
 NC40+L7jkdD/rkS/NA3fMGQTFqFGzfJG+Jlg/J6B2kQOyOu8v5v5aYpFa0ASOlY61L/K
 /9pW/P2+/iCrwIdOWNTSOrehTy607z0X2dsM4HR8WoLEnCc4wDV03n8zJapF57RKeefk
 uW9cYtHmVTmOeS2vzrtXeNpWGDchMnhjtp+NoUQ0RhoopWtPHCVQ+QH8K3G2bYXKHF3R 2Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrfj63wth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BK14uH007175;
        Tue, 11 Jul 2023 21:46:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h13t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+4jmgpWEWkLmHYs53Ue67skXAvQ2bqv5MPjuIap5ieRjwE8J5WNW+YqTJob8PzGRBLkxSN6PBUF0QfSnflgdMEBFZZdHAYmJRCxfLFSM9AFixYpPalBC2bj+ARYPS2mIC7esSTSDSq2GgyFU9Lz6l019QmhBc4vT7+6Ep2o3LC53ennzo4gmWlkndDkkeFi84XqGdafgx05Z9pHcd6/n+Uzyc0/eRjlcYnrbqrNPD4kj7bHSyS8+0Y//8+hsN7KQAlrDnZhWdPIazp8VzowXm+fp2CLx3CRIeP1+ahmi8CyMN0W6Z28XfF/fxIDj86wmgjKZ9KjLZy3P0aoouxtbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2r98ak+WJfCtcwHYGYZNcTTPE5SmYoJyLL5rjtPLso=;
 b=Im04FKQZq5/24FZkzCrDf/B7KhoSZnIfPsEJpwrFgkCSxi24OTdjAYY1mA1m2VHw7WiamRPrwxhIT5aoNfyNET99NLziB/XVGqTeTcze0pqbmdJ2Ip6xBsOkxrWMhWzUnISuQGWhN+t3kzzz0hUtlTS9x/+vB+P8gXugEnCZzKv7pUOUP8KPf4VP++ZAQj/qtHlIp3SUq19eTxLfk2L2+To5N5GMoyy45YGifUjfhq6Z7+6AY7y++7uLh0z2EArZIw7AG7ii1U2NHL6gGYI7fUzj1XYWD5TBwnmYQgizAiU5ltQQ+O39OBwSFDPSeCdVO87yNoJyfi9vsT2WL1q2BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2r98ak+WJfCtcwHYGYZNcTTPE5SmYoJyLL5rjtPLso=;
 b=zXGwkFVZfTpcXRaaJwTr4Q3k5l0LDM50/9lOXpccPRJk7zR4AdSbIrzlDGEVK+2sUwOkaWMZFhHx3fNqnHol3v4VO/ubfuhSnYds7c1pvml/psW+Nk90DosFNxmWcef0NfZ8VTmp/8C1HmU0NKr525//k/23ayV3Plwm3chpBY0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:44 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 09/33] scsi: sd: Fix sshdr use in sd_spinup_disk
Date:   Tue, 11 Jul 2023 16:45:56 -0500
Message-Id: <20230711214620.87232-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: a43d33eb-3f0c-4ad5-62fb-08db8258519e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZGLCQxZ+ZpvYJH3rNm9/AUmtjTLbo4PmlfrzxPpYpq5oGsv4Xl8HIbHRbbGfvW4AKrDkLWlrBF/Twn/SRzIWf2meMUGaeBm10VVg/ujPfzbuzTJA1uYK/orta1YefymliIDZGDSodzMrAo0LtA+YXKv/o75oGPcxlOhSCPH1WzXMJ6Ake9h+ObpTI/Z6xIVnFcb+Jnd0rxYgSATjvOOkZzbMTy99VrORAZFbNcLo/GVHUgwkfzpM/+k/c+JgX0PfvKkzVxURnfkzi1WUPklCMdvhQWiqZPsRXkR8oMcWfv/w1dE3kuOyGOxEPb3rL732E6MlNx872gs8uIcENNYqlTe1BqR4KWqYMeyo4MUGTkg3QDCAr0so1RMM8OC6XGOuEgmHPtHVExKmijY9DHmCTNlPYlUA3VaI/lrulfJaiAbWqpHhqRViN2E8nVrJm8dhW2V7eTj7DEoMXG7PnTguA9ayXdaxDaWC1fA9CjLp4xpmdu8IRro5sqZPCDAmeK3x61ekDOwySEPNmV9uj0t/wp33QRkaHG4NvIHP8VtBEXpnRvxHwhdKLOMoMVVUVkJH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CIvnWfA6tzUGSsyhQehLqJgrkLKoanrxEQf0ssN9VHkuzFlqyyUDOSy4Rh6l?=
 =?us-ascii?Q?0i/RL3fpif8W7P4ONNVCCoIvDq0yd5WdyWHqLwcba0a2B8eZDLgGpwDJq+0/?=
 =?us-ascii?Q?E3qmU2sYqIX4uahXDHRzWVm9JIHWAdLrUW9e+7TNXS5MHGBEJ9562jqZHsLp?=
 =?us-ascii?Q?Ou66x9dPL29bENheiV/oU5WI0zH9eXwmjLtzhKaSoJQm4cNBk3pGvARXeeV+?=
 =?us-ascii?Q?6XsFkWO7w19qIpxSc+KRCtZJNOcZe8jdfKj+L7iLvlrmEwHRrsUtNliZAjG2?=
 =?us-ascii?Q?P+gFNjZFASP0L0vWj0/jEUPiuRAjzQF2pShVxGRynIBojSbAwMGAU9EVQJQs?=
 =?us-ascii?Q?ctgE6ZrIo9+uQuObIJCHi0SIG0qGs6y7XGEfzzDZcYIbySmeir7knKbuczZz?=
 =?us-ascii?Q?4P7JQH3bmiwpVsBDkZDRue+NvqP7YEEmPA5oDoXaQhlMebeLLSPjh+/LwxW0?=
 =?us-ascii?Q?tGYduPsoCqG6PfjbT26GlrmddoSpt5cpQA6d+qKzmkQKceSP3ndR2S0QRGXJ?=
 =?us-ascii?Q?kTKEE/UKQdezX40i7AK2Cl0+FXW2tWgcrEpBD5a/wIwirrry0Qkj6kI+7W4v?=
 =?us-ascii?Q?vHDPhqPRTqtcbBoPaV7NFACxM59V3nspjp1Re56PT8sny1ks8uvfBXm+eOiS?=
 =?us-ascii?Q?C0LAc7izghau1jRx5rum01XtGxgrIwHSnuXte6MptAJ6xtqXs+TE8iqsBdzc?=
 =?us-ascii?Q?ACurYCurPfFDmU9NqlFQUEkAruNsPFkktpqur4PK4ZHh1KhvdwkKugV5cIOS?=
 =?us-ascii?Q?38tbxNyIpMPP45ZtO4hrYq5SjHZmg3eio33begAMHoOyfadfeayF36UqHx8j?=
 =?us-ascii?Q?UPbNyZddpBuTsZtHLn+Vw3KCOvyIILSTWYEse8AbRF84jWKWvDevoUae71ay?=
 =?us-ascii?Q?3Gh19BnbbL2wvQCuxbxjtYpRiN7Ba9xU/L2rQjRYO9t5vS64QJMvj1+gHqxP?=
 =?us-ascii?Q?dWabkvjk92bcJBgA3DIY6r5tS5h32COk0yOpX3MHGHGb4biIV4Xr1GlVLJ0W?=
 =?us-ascii?Q?gyvksfhXS1Bnyylku/zgAbBmB5H6M7k9DQMxqxtp9ce80KOZkFHbt/kvHVz/?=
 =?us-ascii?Q?Y2DBSDhvAvCCJBKu3e4sxZ2jvRgAw7fy05qHBb1bnJgknY6StvbC4HDNSral?=
 =?us-ascii?Q?RXDPXZi73fxWJVp0vKE6doefQeRdD5vqpL1JpTMLWo7sQGC8yvxM7q8wToul?=
 =?us-ascii?Q?T6tQQrDqKU8HZQx0VUvzpVGUd2iCABlNF3BC8A33a6kdtwrEDF7Rkx1JW8Qe?=
 =?us-ascii?Q?YBHVLgJ6ytQ7ClOU5Apy6fVIRoj9IOal2dCWmu2DZiQ6hsZZQUKDr7cmcn2Z?=
 =?us-ascii?Q?8onw4pLAQ6Q+cFO0G/1APPH8wkN4ES1ARxv5HtLr5t7J3VuQd4AliTB8CQMS?=
 =?us-ascii?Q?VQkyHm7kUHsZG7IAzFu0L6y+CyiPCe8c2Fo39GU9cPuLf2GsnDCLrgJA2DuV?=
 =?us-ascii?Q?gJZ/VZDoXrjsEGNoczHpoN0YI5KzmckUIgvvkBKXUx678GmbA3ijlaFR8fwe?=
 =?us-ascii?Q?c+FudZIWbHAwLlfvDTEt+39lManGL7vKu/VzNrMSibCbvXcN6HNy51khAp3g?=
 =?us-ascii?Q?bd01I9EWPNb+vEygPdMRtc2XHY92l1q2SVFT2ikbmDaBtgQpzpdNoFxPXVDl?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7HnYrhMAv3QEXIgGn7g34vHk56bmT3MSw7TUqtaUjlrDyRDxrzSb13pEAcVdg1Hy/xlaED1UcsHHmhDzJPrQr0wq5LFVdK4YCJn4lubkb8oHcvuJKyejFfRk2Rno9xhhB6llakDRlEqsEst3spcuOA172bZy2AouhAvwaKIBVT91hkJQIFZt6pAAzx0Rc57KN2wuJ98GbJblTkf240d4Bgcu79T3xyIkVfpH+iP5tKnwbwNKr3F7Rz/D4rIexr5NqfcVpiMeT+cXR2+9/v7SmIvbrw/R7A3R/1InXToiGPjdPQXzoRRmjwrbiG4uyHjeL8ukNfcZoNarjsedl3nSoqqiHLGJ/BQY/IU16F7wJMySyO9aSTAsCMzuBCUY3QacuGS80ahpp3C55LWwyBbq4Fd+cqLAV+yju6Rh0Lz5ea0KwqOFDjlyXFg7EMj0SF4HIJ+hyGIGMun2XeIyrSz8+TUf9O2+oQsoGHeZJhyy7/5Em7McFMAjYCwVHOz1OJ6nlLdViyiIK1ekSBrEGLC+ugiVxkSjVbCxCzY8rEEplGJCTqz40mmqVy9sDt0L7rYHYdOUdL3pql7JpURT3uyRM27rahBJWkcjC9z1QlGSD7uRQtmfuL6zicstUNA6ZaxdOBUx/z+C73EnBhmdFc6sAihVH3cIPhOvFVY5o2/bXd6ItVA+J9EO6cRpmQ2AL1926aMKjoSYOaPxq729OkbFwueVYMxfWG3SN+ycBC8BwYkaRKQ1/nAucnOtUhQiFKosqSNjFKwl7hEtTrcqnsS1qlCHPMpkF9L2im3diynaPbP0sDX3cR90j2DyfLTtaU8gYsNAxyFuM+qtp4Um0hD2y8ekbGUF7VaPoXYoO+o9Z4Ipxc4J5tn6HGpxJDXDndHZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43d33eb-3f0c-4ad5-62fb-08db8258519e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:44.7919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLKz5CAhzWtRFcgossTvm8F/BZO4vmeFKTZwwkIjGv/toekwNhY5RdkMskewgPZg1ABR30yZCMpKI1h2nIw85s722jQcD8IPgcFtQwP+0So=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: vKRzhqC8ZV26WiRfJ10w24SqeeE4Cgdl
X-Proofpoint-ORIG-GUID: vKRzhqC8ZV26WiRfJ10w24SqeeE4Cgdl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1a1011a8ae53..e34cc9daddce 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2220,19 +2220,21 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 						      sdkp->max_retries,
 						      &exec_args);
 
-			/*
-			 * If the drive has indicated to us that it
-			 * doesn't have any media in it, don't bother
-			 * with any more polling.
-			 */
-			if (media_not_present(sdkp, &sshdr)) {
-				if (media_was_present)
-					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
-				return;
-			}
+			if (the_result > 0) {
+				/*
+				 * If the drive has indicated to us that it
+				 * doesn't have any media in it, don't bother
+				 * with any more polling.
+				 */
+				if (media_not_present(sdkp, &sshdr)) {
+					if (media_was_present)
+						sd_printk(KERN_NOTICE, sdkp,
+							  "Media removed, stopped polling\n");
+					return;
+				}
 
-			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
+			}
 			retries++;
 		} while (retries < 3 &&
 			 (!scsi_status_is_good(the_result) ||
-- 
2.34.1

