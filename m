Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07EFC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F5E23B08
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730129AbhAOEJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbhAOEJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F44g7x055648;
        Fri, 15 Jan 2021 04:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6PvGB2xi698DbGT6DFqJfvF3cxHhPTCVJupwu9KoW50=;
 b=reOWOhQk/+kJDKbnkQ51oYzbWk6crNo8peAPcTCdFu8yuri/jwfBEymlq+3hPot+tbB+
 cd04anWgKHewOeZ3vSxLFnIrI/sbSJHOxvV1RzoePmFtFM3Ba25rmgiboEkWjkmber1q
 2DGjzmsWSxsIUEEHIqXI/B1j+kHmxdUhx5ImHxSQEimS8pflH0GIP50c2NduSEv/mtfS
 MYc7AJcdf/eUdtAO78S1rnmW5kj0kcd84DQHPXMEp0o1r3jcWnr2wPPQPsWp0vaD5CQN
 0JQ1J6IC12xmySAzcFF8bYo8fsPZIDQAS53HOYR7YWGmhv6XorVWS67u0kz9bRuRsPqu YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 360kd037we-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46eX4094901;
        Fri, 15 Jan 2021 04:08:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 360kfagp6r-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5JazkEI0aPajIg8VCmoCeXtSm98CcHpbxBZfwPOiIhEtxjLFWjzHdblkVEFn0etOjLeOfPojsaun0INAVI6KfLUR/dumDu6x/7hzZqT9h1eVniykdhwjRb4LXoYGYEgKF0Lkfm8qZ1SZBU14mmVaZytCtX/V151vdepYj5nuqqrjAe3H5A3/DhqPsFs/yvgo4iXyoHp+vVOBehsd6JlzD7ljYuYcTpfRvL5vsJiJiyYjRkix5UNl87F/58+olQsTT0P7F8xjNwg/v7Z2TLLdZAGgEkionxAGKtd8KB37OQb1j34nUnXvnwdetN7DS4JFbpOkqLRcLA3+t0ATvQ9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PvGB2xi698DbGT6DFqJfvF3cxHhPTCVJupwu9KoW50=;
 b=O3RZ2T+gQ1+vMnFiNvoJcO1ZtqC+FuGqY/ZGvgPNKwdUCE+ZWmrbO5IiSjSxDghqWTMAmzwcN9nkJ0wNIomDB1V0mFeVRPisabzxfmuQXP30AGkpWYg5v2APKgknu4QZCBQbQSxS2SMyNaZbupqpM0mfJ4z3xMPr2XFk36jGvlRU6mJo9qzhSM1JDSPWdOa1oelPYwUgfXKrU+P8c4s1IPidjPA+5H/7X1Ds2lC+GUpTOm7IFystol4ySEouK4/vPFHLUe3Vz3f68pKcigZxkmcP7Sm9OxR3kjKqLYZertKUj6sWJzntWjJEhHAvCOvp4GcDFhNOGQuCOslNrFJ0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PvGB2xi698DbGT6DFqJfvF3cxHhPTCVJupwu9KoW50=;
 b=hVbSJfOiKnwGBkh4f61Rukt+wQ7SyrrWgj2ZeVeIrpx+z8SfFgINlrh783Zc6gYSgY15fM5LxRyKJ+oGa6ntSGHRZuOTfcytrx3xXYvOAGhx6W/r3L5aYZVHvcZbUOUsJI1f8v+LpPN8Fatrh7+qDyYPODT2LwWafw0YavWK+bA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        linux-kernel@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH V4] scsi: ufs-debugfs: Add error counters
Date:   Thu, 14 Jan 2021 23:08:21 -0500
Message-Id: <161068333182.18181.7961931758594272733.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107072538.21782-1-adrian.hunter@intel.com>
References: <20210107072538.21782-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00b6f281-ca01-49a1-c5b5-08d8b90b3d16
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568D8C792D17D0898F236048EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95Thyw3AYrU0gkfP3Gn+bsxBR+Mb+0UHZ3QiewLhaGQ1gRqgPYYJXnMOhedQF8AGMid9mmX2NTtedIQIZ89LnkI1bIWs7fEDTMUMMCHZXtjzMLtFL4gbi/s+7f2uTj02ftSy39BUBYNR/w7PTebhQ2gEVnfkvj3kOH10PdHo8+uzbnfK8MH7ixgH309awx/Y19oVJu2gl88N73v9d5ntTPyeZjsnWxHphDx/5writ9wx91phboQ6+Zi+hoJbhKo2GoN40HTmDXNT3A05PEH9RxSAS12J6g7hBxI7iiAXQMqg8VPCjvJEig3ENJEUEro+4myCph2wjFGXuiZyzzdADOaw0P53M5XCbqyV7nZOrhp6hMtjMWyf6w+j+Uln8X1UvJBA4P6OLXj/ki09CpLXBuuAhWEny3OVuiKDCONNcCJjAVxb8yQztrV1GOx8EFXEc54wVXJZQZpWOCKW1YwgiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(54906003)(36756003)(6666004)(316002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(110136005)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eFlnSXB1NjdEN2MwWVQ4c1dRSldKQldOaDROUFpRYlV0SlBxdWNLWExtL2Jq?=
 =?utf-8?B?WHpKMEJWekU4eVF6UEg0TkcrdVlyZnVGYmxNVU1IMlpYN09URFgvYU4rZktr?=
 =?utf-8?B?VVNMZ0s2eHhJVHY0UW5RQnhrYnNSa1JYalpHL3Vkdkh2WDE5U1FtTyt2eTNv?=
 =?utf-8?B?cGJtdkR2ZDdHM1BMOG1Sa0p0ZURjbVFnMGI4RlJpNkJFbmRpVjJ1NVdjVFp6?=
 =?utf-8?B?YXdsdWxTY3N4OGlvazJQM3ZEVVQ5MWROSUdpQlhJZGIxN053MlFjaFZyK0Y1?=
 =?utf-8?B?WGxHbG9Ra1ZxMkt6MDhWRzVsRjAyZEZLTHZObTByZWtTd29sRUhrdWhFTEE4?=
 =?utf-8?B?NmV4R1N5QzZTREpmSDJ4QmdmcWpVcVBsTnkwNm5tYWVwcE1ianRiblFOcUZK?=
 =?utf-8?B?SXRmN3RiUFd0bmduWEk0VWY3SVRaMnpScjJSQXdhcGNpK0wzQkpzRVFEQ2pz?=
 =?utf-8?B?Y1hMU0JhOHFVUUZTcGNRNGwvbHhrRkQ4TStpRHpjUHpRV3RKOUhGbTl0VUEr?=
 =?utf-8?B?MHdBY0VNR3dnNGlZd0MwWFVNTkVIdzhYdUJpRWt4UmdMaXF4NEU5RmhvN3BK?=
 =?utf-8?B?bmhhcjJLZXdNdENUOXA4SXErUnJZOFNndzIyeW5iTWs5YTRiS2xTU1VBS0lw?=
 =?utf-8?B?SnowRmYyY0JpeHp0cW1xSEg5S3Z4ZE0vSnprcE9tcE42b3RzMjlDbGsvVTRG?=
 =?utf-8?B?Tldqd09yNlQyV3BWU1ZBREsrczNwYUpoTnEwNC93Q3M3bTlBaFlhaTAzb2xx?=
 =?utf-8?B?Z24xcmFUUDlWc1puN2VjaWpkRCtmODJCQmEyZzVTMGRBR25MQ0ZxUjBETTcv?=
 =?utf-8?B?c2luZ09oM0R5Z1B2Ylo4R21FeU9YZFZyWDJDNmw2K0dnNHY5OU1sTTNHRFVz?=
 =?utf-8?B?Z2kwVmI4MGlVUk5JMkVSUGtmcm9UbkVrN1loeUEwKzlwK3dENWFpS0xIMkxC?=
 =?utf-8?B?a2VCUy9XT0dBK1czUlVxdVZqRStYM29mR1dCeEx1bU53ZlpnSjRVS1FwNWt3?=
 =?utf-8?B?SDhNRTl1QXJnYi83SXpMVmQ5L2dzdVlTK011TStHdkozWmZJR2U3SDVaSVVP?=
 =?utf-8?B?ODlvWUowWi9Wcmx6M2ZIS0tGZlZ4Y2xjLzR4ZnpwaVNGUWF0T1Y1RGVvQXlo?=
 =?utf-8?B?T3YrWmgraUtMTGpwSjBTb2xlaDgwMXZYWEZGcDl0S1VoWHlwaWtDL1diS3B0?=
 =?utf-8?B?czcrUElYODNwSXdGZDl3NE9ya2ZZL3RqaVR4bzdDanhZdTltczRIYmcxcmpN?=
 =?utf-8?B?cjhsRmNtK0JBUHJaWHNjU0dNbGsrOHZMQkVZTy9CWCtDcFRhWE85UXE5bXBB?=
 =?utf-8?Q?yvXRkXR++7Mxo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00b6f281-ca01-49a1-c5b5-08d8b90b3d16
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:39.6693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pP2QWJt4u1bacB8fZwq/grtgzszgryM5gBsT3kwKNPSTYV5dPEpCFhdESMY0Bjc4Gcy5+18GzoCSRyCvI16vp80Plx1xx6FZMV95cvAVNqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 Jan 2021 09:25:38 +0200, Adrian Hunter wrote:

> People testing have a need to know how many errors might be occurring
> over time. Add error counters and expose them via debugfs.
> 
> A module initcall is used to create a debugfs root directory for
> ufshcd-related items. In the case that modules are built-in, then
> initialization is done in link order, so move ufshcd-core to the top of
> the Makefile.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs-debugfs: Add error counters
      https://git.kernel.org/mkp/scsi/c/b6cacaf2044f

-- 
Martin K. Petersen	Oracle Linux Engineering
