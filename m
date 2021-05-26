Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3777CC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1989C61439
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhEZEKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:10:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53612 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhEZEJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q42LOV116471;
        Wed, 26 May 2021 04:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SGUIb6drz/i2Sr/QO6+t8+K7Z6S+t6aWO47rMNK1/sc=;
 b=h/nfYuV5m9onPgmIPtaMXpyThXimU6L7Vsul35R8V4A1OmT+PXfulE+aMnU6/mPbKcFa
 dcqE5Nehx4MXEglawlE//lmglomTUbvkgM/1lG6E2Gn0htbYFrosI6KzVisIS3LugfJs
 rZM7Z7qW5hpeW36t07BWj8Vwp+329WugM7PalArBI2jwTPHjE0kl83R//tb2U+XjoiYE
 /2/mXhGnbfRumiYglse+VrHAFnKDsqFJi2cNhg4IyiHuNdF23IQXefDtpplX5B4ytFEV
 3eFD5W5zfIX2X244d83L8vVNRWagXFTQII/WRncpF0qXn0mA7DGOjGCl8C+fg4wH5VV7 OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38rne43bda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q45I3r142537;
        Wed, 26 May 2021 04:07:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 38pq2uvw7d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsSMmqeL+j8yc7O4CCYhN2rX0UrIUe34YhmlqTlW6HqaQspb6KOvsUAIDR0PxXehD9cQ5N7+yHLGGKp2DDvrU27fLjXtzqIt+Y0w5JShEAqg636u0YKCL8V79mVVkd6Zo8k38ubSfy0cuXcPyPzUYODEhsA5QOT3+pMjPpOlnEuDjcDY4PEq/Yy2AmWYuxpHzz4K/uP5Ya9fFq/2Q/OASkA6BEhbnzfxrsgkyiOL63Dt21znkeRprrUO4PzxN4fJ/GQoJiu0ny/JAJkxHFniBP1ATDOxC++VP7DBDoJz0o3hnJyXgLSuvZ2XCOkhBhu9VG4Uj5fOWM+BXBL2r4LygQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGUIb6drz/i2Sr/QO6+t8+K7Z6S+t6aWO47rMNK1/sc=;
 b=UkyZnEx+VJnVoVfMzLEXbWlGz4xuDt/jMtk84qKqZh+afNtP8vT5rF7E+1l4tunBplVP4aDc7pVCc75OGx1I5DZkq+6YVJ+U0pNYy/KQ5xV/IAKPQx2WTF9WEGdpdgU/GMPFZHpW678jD6JDj90mC17icFBkLYYfimSsopf7BC3EyAZSMdT/l1q1NIt9vfbAF/lEM3p+cNCv63qZnzucxUqfTBs3XoVUCMW9hOUOh3onZ3ZFE3ziNnHWSa1Trm90g5oXjlm5yOiQ+jSqZqiD06IEQMHSXqiX6dbZmMJFteTaJfrYopk2R+zJW1PgTRVGMLJOzk3MCwcrGdayMAKgAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGUIb6drz/i2Sr/QO6+t8+K7Z6S+t6aWO47rMNK1/sc=;
 b=XuFq6PnnWeti4snVxiSCwBGNRHMBGFGO8SF76uZCSU+tyEx1hlPaG9uzcgVx7AC+hF0v1uIHvsqDX23alnPoZToGHsU//PLFjZkTntvrO7D+rs1DlPfB0HvxccdlTamqQMO0e7WzQzNCi82+lC8OSmjnqVh+ZOOMGcoZLHfgRUQ=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, beanhuo@micron.com,
        adrian.hunter@intel.com, jejb@linux.ibm.com, avri.altman@wdc.com,
        satyat@google.com, Keoseong Park <keosung.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-kernel@vger.kernel.org, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Clean up white space
Date:   Wed, 26 May 2021 00:07:27 -0400
Message-Id: <162200196243.11962.15325131473743608868.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <2038148563.21621340102306.JavaMail.epsvc@epcpadp3>
References: <CGME20210518121217epcms2p6b35173a078be7eb2cea2d80e2bbc1b00@epcms2p6> <2038148563.21621340102306.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a65c8fc-ecc7-45ef-7bfa-08d91ffbd394
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44690537675C5FD591FC4CDD8E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nPODzgVVEiWjU6uaO6StlDGf25Y8Zq5gPGMLDamc/xM4G2XUyiN0B6HR7TsO19m+CUlDNPzKsgI9Y0znBT3fg4KbOsYxx+nYpvgLLiU/yHAl+PUMVB18xIKM1fA/a+6dp8wk0bh/D1byKLyfYI97RPUUliBvVWyo8lY6fbKW/qMh9ynixGS8Rhbjd0ywJxnnPS4kryCxcJV9mf2zCKPZPccuqC37szbZ9Sea7+8nrloXMnITl0R91jAL7mFdts14VHA9AHhJ61gYq5RAKps5wVIQi+UMBHY7zizJLj1Ye/aOpWzsqFHwOhJ81L2p9j+sF+wj05RpNxz6W3B5YM9YLXxZFefPUWQ88BPLqvw6GQVRgyY6+uMhrCYSq1P5fQu/CWdvAiOJB7bdRBVLdfhY1flykxNdal4eRB5kCTYm1huRtPkLFdkPfV4A/QmABkbPjOtQ2gMf1l8nnIHmUPPpLF/Ra9A2sA+5JYgYQ/dNSYSQcC68e6OuufOONacdX972qzNxu3MC8S4LM3bco6ergmaAIW4GcMpcckAE/t7KpeETZ9Qh2g2G1QSK4sxXloHMpKpAq38130k0e0URyRXEd0PoTvBRQiszF/uenfMdpZ9XNY3ZOS19FJDrW/mZhwH0LhU72GvL3v0QXayjFA7nlHtUCVJ8piX5h8+goGv/LYEK9t2EW6forWtbuVBN3XJSgskY8jC5g/dMTUCWuft8xC9z19VGNXxQbkrrfnjGe3SXXvQjhcFiRJk+FSWL19uR11z5nQunMYYtSwWRwpYT4vbJtNFo7uwpD7WA2E/y7Cs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(110136005)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(7416002)(6486002)(86362001)(6666004)(478600001)(966005)(36756003)(107886003)(921005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SnN0bmdVanJIY2dLUERsQWxqNUJaZVZZb2Nkb2p2NTZFWXgxZlR5SU5LZmJZ?=
 =?utf-8?B?WW8rVnNOMzloTlgzd2xIVmw2WXZPTlMrTlMyTGd2U1NVTlhPWlo5OTlBZEVx?=
 =?utf-8?B?c1pFZ3oxK1A0RVJkN1VYaCt3YjVjN1ZjZmd5NHlrbjRvVkNCNDh0WFRxc3Fn?=
 =?utf-8?B?R1ZmVnN0b1hsaWN5aUljaTBCNW1BTFpwNEpMMjhIQUxIeWFJMTdtbHY1TS9J?=
 =?utf-8?B?d2hKbE5rMVpKKzZyUHZGTnZPY2JGZlFZUnRyeXREay9wa0hVR295WEhNOWcz?=
 =?utf-8?B?REh2bzlwS0s5SmtraUhudDM5L2ZmblBrYXBYUHlhSENLS29admM3L2YzSFoy?=
 =?utf-8?B?OFR4WFBpaUJOQ2hYYU5yQWZqRjdlek9uaU9aZkFpWFFCMFhtRHl6Mk5FLy9k?=
 =?utf-8?B?L2YyTTVjS0Q3aGZkM2pkWmRGVTd5cnAxNFpCUjZnZkF2UVZDN01JaTYydFg4?=
 =?utf-8?B?NS80TVJ0T2QycU1ENi9wd0RKRXRQSC9MMEFVVmdpUFJmblNEc2tySExwTXRW?=
 =?utf-8?B?SjNVS2tVbDhyV3JEcHI0UGpKM00vTkxlVHB6UVlNdXp4aysrSksxdWtmZlBV?=
 =?utf-8?B?WWpCZ0pic3RMNDJMcTFsRjVBa0d5QkNKMWQvd3pSMFBkMVdRSE1LM2N4K0ow?=
 =?utf-8?B?QTRBOVQreWtCOXBlY1lzTE5QS01pbWhHZW9lYlNlc1lkc0hGRlgxYTJiWlVM?=
 =?utf-8?B?d1ZxckRuQ0xZVmNweTJUeldadDB1bTdYbjJrWHppRzRmbDV6dGpuVkxXTzUy?=
 =?utf-8?B?VjhpdTJKaEhFbW1NNWp6WS9FQ0VPOGVCdVpESkpvZFM1M2pZVzgvbWE5dWFs?=
 =?utf-8?B?bHhNMDdlZ0tIbklZdk9ad0hXNUtkaGRTZXlSNndIa0lTU0FBOTYxRkk1c2JB?=
 =?utf-8?B?bjA4dEVjRTdPaWlqUUFRZlpZMU5oUm05S3FrY09tT2tJTUgxR2JsVkNUVGpH?=
 =?utf-8?B?VXNEUVFUd3RZOWluMmcvSTJSbXpLQ2VESytCdTgyeStvbVhQS1d3L3dkV1h4?=
 =?utf-8?B?MkRIdjJkdnJxTURjeksyd2ZzdmRPdFJzelRobm9EZEgrSDUvK3dRbll4WEFN?=
 =?utf-8?B?RTVpK0dhSEJ5S1IrVmlYYlRtODVJUWo5V1BLREhKMlhQQVp2WWpvbGU0THNO?=
 =?utf-8?B?cGRXbEprR0hGaGpEUnN6cFJZSyt1Um5NeUErSVJrcGJFbVN3WUxjUG9BYWxz?=
 =?utf-8?B?NFdKUlc4ZFZsbmRYc0p1Yng3bVBNK0VCT1BoZTJzS1JVbFh3dTJVQ2g4SEZV?=
 =?utf-8?B?L3ljS3F6QU84Y1p5a0dGTUtiOUc2NHZvN2d5TnJSSGNHdHAyckY3VVlzc1p1?=
 =?utf-8?B?RXJYWUZUYUdvTnpDQ1cvM2xOaER0dGdGNzlyT0RnL240QVVSdTE5WTEvUncw?=
 =?utf-8?B?SEZ5TnpoeUx1WmU0SWtHTHp3VFpHYkZxZ2dSbnhGd21wWEZPb25TeVc4eHVP?=
 =?utf-8?B?elE3UWdQNjlDTFVMT1h2UHJxOFU0NDNNM3FjcTkyVlN4UFdnS0xOajQva1pS?=
 =?utf-8?B?UlJteWFMNzRsOExObjgrMGZOKzVSMHRwWlJ0TC9kazlOK1l1aU1BMW1sV3JM?=
 =?utf-8?B?alpHWlhLV0hlSmpvOGZZak9USjBmUkJJZEN1blZmTWw1MUJNc2FIVm1CRXFp?=
 =?utf-8?B?eVd0a1lGOGZpWUJCWFNZOFVyNStBTEg4NzNPZEIxbXBvK0svMlE1dEFZcVlm?=
 =?utf-8?B?Y0c5VnQ1TllraVRva0sxRVlBWXJXZmRvM2pnVmVUZGJSZVFZV2VGc0wzZ0Mx?=
 =?utf-8?Q?bEGAPrbn63ZkUcb4Zk7/SQBtoI9KpWZjjT/M5jY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a65c8fc-ecc7-45ef-7bfa-08d91ffbd394
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:49.8891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EeaeBV0tyVsWFFUxbu3zRIoz3u2WpsF9uO/NT5gNk0yA+3NUkFe1nSejSRfNFjwmXlxc4X4TKgZ0qZfqcW0hKfDwIKr/FQ8H60g7vqhhowA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: OxkNgOi-XycFWt5sb4fvihBJZpJR1iSw
X-Proofpoint-GUID: OxkNgOi-XycFWt5sb4fvihBJZpJR1iSw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 May 2021 21:12:17 +0900, Keoseong Park wrote:

> checkpatch reports the followings:
> 
> 	ERROR: space prohibited before that ',' (ctx:WxW)
> 	#945: FILE: drivers/scsi/ufs/ufshcd.h:945:
> 	+int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
> 	                                  ^
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: Clean up white space
      https://git.kernel.org/mkp/scsi/c/ecd7beb37871

-- 
Martin K. Petersen	Oracle Linux Engineering
