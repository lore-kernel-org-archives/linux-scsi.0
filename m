Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B3BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B13C64E08
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhA2S3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 13:29:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbhA2S2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 13:28:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TI8qjS152662;
        Fri, 29 Jan 2021 18:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+93MwuyKS26aKB8Pr2dP5+I11BX0rcUtlO6wEG7ISJs=;
 b=DDEE9IwOIHxJPojj3syBDSDQrZ2NoR3yId7QKm+BUt5NkgGdkOtXiDBbnANBvnCpWlQy
 D8E3SCIXIkitjWdzQqKtBgDD/AE+LCoyiueMkgGZYy1Ak09nDJASYO1jmtVJwoLiDyMS
 iBRdamZoWI1mtSRmcHHfsxBSAmqDrQw903INCKzm3mXz3Hs61Wy+sXP00ahUY6tOI/jq
 9gryw9pdoakaRfbe2wKub1LE2Y4E8rh62vcsI73JieoEKMY3BENoBQZnRRTU/ouIcMHJ
 5nmTI9728sBNdoi7FaSTIwAI72jr1EYIgb+4mv+1Xqa8j8/LvtWj4hk3fMTH1FKC816z BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36cmf890kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:28:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIAJM2037602;
        Fri, 29 Jan 2021 18:27:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3030.oracle.com with ESMTP id 368wr29r22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:27:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTSKrwREees3GpqafcNcFfXzCS1P4plcGLP2NiOxBbhYKMvQqJwPuffmig0T5xhPldwL8p5i9CWZm4BSbgCUjPdCrgbMaiS1159LCotK8M/69CroG4kolPAztoaoUrHBCQytYWtwq8JtXLdulRa7PyHrfX2+j9Slmegs8g6X949/L2hhqfE+NsNqZrTwtNckf4IJtgZEjyMExDbVcw1FH39eMHfEyB50UfMEFRQkKizcZYVst0+7xXmRo4CuDVLZ+H2jhxdh9JbS8DjytbQWMHvqJJMrLGz1QozzmGBkgvshDZ3iHa6ikgnn6j76OqTKJJ85KkLkEjK+Me2kjOKoHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+93MwuyKS26aKB8Pr2dP5+I11BX0rcUtlO6wEG7ISJs=;
 b=TwqyPZ3gn7t0dfFhgD0EVJ/p3dZ3ldrDcCeJ2bETsjikIm16bQonRd4y+CvZhhyfOVftduDAQRtsdeSjARWQ+iMpcqvgeJsH11oyiueP/bAYLorQJwoXGTfjrghNXI1tXLzqGAS/0D3XVZr6p/THjhANIrtlHBRYE1kH6e7HF/3GnlY8vEyl3i7pw1dIeddTDlsY8cKTM+0TQVDyz/yi8yLQhkY8Cdhxs83NVaZ/9f4PsOHo0BndIZtYePSsYD0QcabcfV2OePvOfrP7oe2w48zGsWDWk7/Oca7aInxxhjiDTFDd5DYLDUyBnylO9yvx6KiYtrUZLI4KtU3Lqz/OrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+93MwuyKS26aKB8Pr2dP5+I11BX0rcUtlO6wEG7ISJs=;
 b=cf6cHoPPSzlE1dNQnsVG5O9ZUO7PB1Tj8d985uOLgaRQFEwuqKS6jlp1ElhheKlvQWzUsW2OB+wv/wH2k4Y5e0ZSkNXYiEuTeKXk+afurQqtJQPDbO5NoTZdVr97hasqxqfLjCnGlH24EAV0OjBiUhqtE0WNfBf/4h9oyciZHbc=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4757.namprd10.prod.outlook.com (2603:10b6:510:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 29 Jan
 2021 18:27:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 18:27:57 +0000
To:     Nitin Rawat <nitirawa@codeaurora.org>
Cc:     cang@codeaurora.org, asutoshd@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: Add UFS3.0 in ufs HCI version check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11re31twy.fsf@ca-mkp.ca.oracle.com>
References: <1611058021-18611-1-git-send-email-nitirawa@codeaurora.org>
Date:   Fri, 29 Jan 2021 13:27:54 -0500
In-Reply-To: <1611058021-18611-1-git-send-email-nitirawa@codeaurora.org>
        (Nitin Rawat's message of "Tue, 19 Jan 2021 17:37:01 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: MW4PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:303:b9::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by MW4PR03CA0233.namprd03.prod.outlook.com (2603:10b6:303:b9::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 18:27:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8958f06c-8d27-4785-5d02-08d8c48399de
X-MS-TrafficTypeDiagnostic: PH0PR10MB4757:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB475753A09E7FD2A834CC06CE8EB99@PH0PR10MB4757.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vr3PUO9OOWCjPBqTBCq6OFPG0gcFKI1ScnmJPtGu93/X51Sq/JCRPopCCTGiSmPZJ7mKPEllof83uMlHPq/nxegkzZAbMvLuiHsohL+QQT/41e2GcY+Vd6uqDrweSlOXxfw/zeGrXT2GwfGw64TKiHSO9OrgfIH7Sot9LrQdFjI8fV7YHBWw7AqGvQdxstz9cRtso2IJ1bwzDQgXGCubqtrebkSxOTkxrUBDz9zlI836ONSjX4NGqpbjMQo2+jQNVD7y/TgIMvhk1EvKbO+QvErK8mdKreNmIjCWhpjOsFLbzLFcvkby0CGXwQuYHY9f6yU/4izVtqjb4sU248tIjbGdZAxWP1RZh8fowfVL3rIJxPADo0s+T94J0ALudUqdVh67jX5inM1bZ1JDJ2yDLC+7PbjaoXaf8rmUMiDpZzXZWVF11wYG4jUO1bEo8crvMnfbwwfrSFyxFm76OkCLfMEvjUUNbyPmW3ezH4IFUgAdQfEFw8UEWFxaTHC63A0PdlCnV68C+04QX6Db/nEYvIyWXHhY6nPxLcn1G5aQ0EPx0pU83/W77bD61j3IcESwmfqmpAp0O2vMyIvQIKkFPwzkNnQuda83JrEpqiWI5SE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(55016002)(2906002)(6666004)(4326008)(66476007)(66556008)(966005)(478600001)(316002)(83380400001)(186003)(16526019)(26005)(7416002)(36916002)(5660300002)(8936002)(66946007)(6916009)(956004)(86362001)(7696005)(558084003)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9IAiopSCIbNDj9mf+tCiGUqJFfGwLKx2bpotOxTsaGmC7z7qKAvTstUOjo1Y?=
 =?us-ascii?Q?EFjhIorq7wEjnJoUaTNxUt1jEe+Aa3rpt74jOPcr+KmUI2AKl/WfqIm3Vgrj?=
 =?us-ascii?Q?VdFkM9d/LAg7el3Vz+320T5r9np0LQfz17jRqUg1BxIHeBvaBB0iAEy1NK9Y?=
 =?us-ascii?Q?lU1QE6MnOa3fA0MeykZ+f3q5KReoFTlmd+BqEntUiE/jzoAAtZOpMAQNSO82?=
 =?us-ascii?Q?vFeusuLFpTiW/fMref9i77kyfJrLSxWQmMskyFYLmgY9TRdd0v6ucCO2jA2H?=
 =?us-ascii?Q?u4rqe32RYtGQ9PLyRm2WtPJ4AfjplaNgaTaHjQxTTId6jVy3ea9OaKx9/Z0l?=
 =?us-ascii?Q?4cpk18XpLouU7B3ebdrikjrVYMa1F1FzJofNXpJ7Wd/xq1RbJPQkT7u1q0sU?=
 =?us-ascii?Q?EAp6t52G0bJ7hZ0uu+O6rSfXlp3BJl+fu2AURv3A2FQSMWTBBBixCc+YDQXv?=
 =?us-ascii?Q?1CnNyMnerp4lDv+9zPbqvYNE15hbv4r83cCvIZIEtgdoVazawm0AHSEZ3AW3?=
 =?us-ascii?Q?XfhIEXluVdo23xpI2D9B05y9yfW8TkT05iaP8auWmpDnicNpQlgq9Q5Gyk6g?=
 =?us-ascii?Q?fv+kS9V8P+AfjkC1RRx8Zre8GFS/w4KUweZIn1AHk3T96nFHDNldBHL4gltP?=
 =?us-ascii?Q?CvJ+TYJZSJj899hsY5M3Y8h86eCjIPV2Q6TJZDi9t4gmKddnNKXaecmnGPHN?=
 =?us-ascii?Q?NjYEBa3wLf4Xwkqx4UQ0UectV/9TdODRX/o1K+y4bfzkDAIjTtqKiT6Vg1Z6?=
 =?us-ascii?Q?MgMGWCQAbi9OY57eL/VwUoi9m86X/AgDhymk/9UCbDyazDN9D00bifJJydOO?=
 =?us-ascii?Q?47SYp/LKyAivJlF94EA/hYlss/Ie2/0mzwYoR/x5b/xn+B79bb9LxekqQFIm?=
 =?us-ascii?Q?hwdTSQddp5dGyUdTfVQZupQlxD1uvbOGuryGvJgfL7sp91PrRPOB0OC0K+KL?=
 =?us-ascii?Q?fHBjP3KlrTDG3F4bRu/ztZfnOe0oHroCXrYQi9UaNIZP5V/POvShCrjLAhCs?=
 =?us-ascii?Q?DAQcOVyX4dcqrdGnKraSyfpo7BtERd6xAeB6yhQwDC4U4n+WAhKUgNW1lD4e?=
 =?us-ascii?Q?ej5DeyXG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8958f06c-8d27-4785-5d02-08d8c48399de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 18:27:57.6451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8KXh0C2FN15LSBnTX5+QyWYDsGP+PJgM9GbVlneAO4iDLOSF1gG2bVQh9gUyvrjH2TJSyoKd92Z898iuK61TuHtZBhah6BrEaCTV9q8lew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4757
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290090
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290090
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello Nitin!

> As per JESD223D UFS HCI v3.0 spec, HCI version 3.0
> is also supported. Hence Adding UFS3.0 in UFS HCI
> version check to avoid logging of the error message.

https://lkml.org/lkml/2020/4/27/192

-- 
Martin K. Petersen	Oracle Linux Engineering
