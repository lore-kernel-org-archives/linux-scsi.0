Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B85C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9402070E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbhA0Fip (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238759AbhA0E5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:57:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4s8jE115648;
        Wed, 27 Jan 2021 04:56:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+eXXIIcYzYe+EKE7PRnlouJ9SPFvesmBiuhdN1nlp6w=;
 b=k3yWtMyvVsPCvGuAbbkmcUJG7HSZ9mKNQozrtanK2Prlqui4pK2Nkb4HeQNUNUuaYLnm
 f7lNXo3TLaF98BosHCG/ilIXfrXyPnuNSvbeLKEOEDgQu1djlimb+jGYWFn3xeAEtt1W
 TlTUc7ZomQA/kceoI0yn5Od2BudOcWLBpxClwKJ7Yb/kT+3oT0EkT53uXuMR/BxcPUcf
 5RrN9wb1mOQNQdH4bI60sHp727alWKLGXA0ngPiDPN5AudOq3gB16Rp3dbtKE8y6VHG8
 v9zDSJvXkGETWl9hEiXUD+yiDyT6bsSkoxC/2PiUAii8cbXz7rMdzGKe80J9bwb5VTau ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7qw6qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:56:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4oXu7100831;
        Wed, 27 Jan 2021 04:54:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 368wpysn6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktxybyBNuxSaLAX1pX/d6wtoFy9wZydWV6vIItbEemCD+Yodl5GB93pNFXhS+38vvrb42ZNkgNI8iFnEcJvJ1PXGLezDybSg4vbz+xJPTPKQXzw59VB1wblwhM3IorDNUhUkcp0WA7KdlfgkdCCd+HxKjOx/hZxfF5IiMitZQz06pESh7Omm4qTkUvySP3M3R7cICYUGV/N1anKyvNDVDT2wfexENBqWfp//YYgPCtDNzNwVFttyTERGwy/t7hdqU06+0ZQjNg+SxHEY20933kyr5MxTeZX7BFryK9bek1kZPgvu0rvut9Xz1nwDO++cf46yTt1xYyGrTRBlIxiiLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eXXIIcYzYe+EKE7PRnlouJ9SPFvesmBiuhdN1nlp6w=;
 b=mdjqh+9YgmYDurnZnY1qyAvA1DKRs+6iLyLzf6qnxlKOD2dnlge4xmaJQnrsihiibNxhVbuV+v3WVRQMjbA6djrpfH+p7M1ljt6hHaAFUMWMRMDX5Fx1d5VBujQdU/qONB8Sqf4Ez6JSgb7jKDSjpUnsCwrMuxqb/2qmbSTyYKfMug4HQTTYvbd02p8no2vJtYGWBexHtGCYCbmaArjw+j+a5dyjBlauUlsU/ZcHBBQuna/PKvam3nhK/0faYrIJ/9pib9YYqUn9hPNA53wcqqLeu4ir/XORKRH5E3ZdPxfbtO0L558JmD1J4lnd0JZ1mMzXYCJOa8ntNQagCNJJWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eXXIIcYzYe+EKE7PRnlouJ9SPFvesmBiuhdN1nlp6w=;
 b=ps/1liSDvwJc9ImTbtaxKTlE4EdQG3972ZjhZzL7O51JZeBfIr4FFmuTV/VYfY6b2cjotz6348CCYMJSbP7zc2V3y3v4UNne1wzoIRNmOlYo6OZGXT6Ps5xVm/nFzy7Ym7uKMAyfmgrkozLLgNzuehl0kziWjZqJbwkNdDhXuyg=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, beanhuo@micron.com, cang@codeaurora.org,
        stanley.chu@mediatek.com, tomas.winkler@intel.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org,
        Bean Huo <huobean@gmail.com>, bvanassche@acm.org,
        alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Cleanup WB buffer flush toggle implementation
Date:   Tue, 26 Jan 2021 23:54:25 -0500
Message-Id: <161172309263.28139.9697983184598233953.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121185736.12471-1-huobean@gmail.com>
References: <20210121185736.12471-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9de0d7f-0901-4933-1149-08d8c27fab3f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45845DBBDFBAC98C45AEFDD68EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FouO9v+ZlbyILl1TBq2aKyTZyKkouhwYDhTGPWQxBu8O9n6d/DFiqXLMsEwW8LqBB2DlpOYy28QCRBYx1N668IRaPCdG+BxP3IA8iN2V2TUBsseW6qgEQ9OYBQx8TfJO0rPYoZ+a+o/DTZtyrVYE2X37Ck4+cFpODoDjY2c9pl6OC/hQFTgPw+aDGhFZ6KrIzNiHvQdQ3JV5LFRICCkX3JgOSH8zr8tFR0hZZR8BaFQgEB57EO4Sg+OzKoCSwzkmTz5cNxShmEieBTpdxLwAVo8TPVVGki00FA5L61od9H3Xy2rS/vEnghA7ZiCGZTrLnkJkFUt5gbgUnTUDEspxMJ3fV4RfjJ9L0ABld88KCY3d05Z7DXZMbCogPFz9i6ila/kkI4UlsCjr7lX5TeI2i3gNvuhFabr5gGui3ZgXMe4kZqJZSdAbIG5bDKF7nx+arBFLLWbKSGtJNKnTxXbRxTvbHfwKsPLWAP/UbI9iewE6NS220DVZ7Pg63X3NMZvw9bt46DdqUoXQ7viVCvHXjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(921005)(103116003)(6666004)(16526019)(7416002)(4744005)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(4326008)(66556008)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2tpV2wrRlJWd1dCZjhkNlBkSHBjTUhVbHNIaWFmc09Vazh0MUZ0N2ZFency?=
 =?utf-8?B?N3RPbHlXeU1qMzZHU2g5dDF4QzRaYTlPYVNPWStYK1dYT1F0dTFYdmluVEtF?=
 =?utf-8?B?eXQzVkd4QThUS2libTRwc1FmcmI3K0RQclFYZnE1SXdMV1VsMXNlb01QMUtP?=
 =?utf-8?B?UUhqSTJzRkNOeENBT2VzdTJpNUE1N1dWS2hrOC9aYWhiZEZVMklZNXFrWUxW?=
 =?utf-8?B?MTlVZWVvaGliT3FpYkR1ZDc1cFhOS1JiRlRFRmg0VWNOZkhxbmQvQXRTSnVp?=
 =?utf-8?B?cGpnbERiUHRpMjBzdlFMR3hzTzBTT0NjUmJMMmljVDMvRU8vMit6NlZLT2Zq?=
 =?utf-8?B?VnNhRHRBajNUVmxiYmo0QzVBWGZzc29uRjZCWFNPMlQwU2VJMkM5SEZHc2dH?=
 =?utf-8?B?VXpUTmd2Q0h6NDJqaUdINVVEWGFEeTlwS2Q4TnBicDNqMGtHcnJTSFpGNkU4?=
 =?utf-8?B?Qys2ZDlSSGhOYnl3dURsTW0rRWFhWnByU0JlQVhwVnlIcVVMZWZiR0VRbTFu?=
 =?utf-8?B?OWk0c01mYUtFU3h2YXc1UXQ5SUdPSDNSRXBoNVBwb1NKdmdXZzAxZ2JWZ3hl?=
 =?utf-8?B?bURJR1BkQU5rRjRMY3F4bjRXMVlDKzFZSkFzWlpUaDhXV2l3NlpkUGE5WTVY?=
 =?utf-8?B?SnROSXBhNC9BZFNKUVl3RTdkUVhZNjdwd3R4R2FiYnNFOEswNnlraXR2eldW?=
 =?utf-8?B?YUlUeVRUUGQ5VFp6OGlQMHVVT3daTm5JbFp1cjYrMVVpbTNwaWtUaENHWmNm?=
 =?utf-8?B?bFpQeUh1M2tobXB3b0J1VnlUSHQvWmZ0bWlUcFhoZTk1TlRmVitXT0hQTFJj?=
 =?utf-8?B?bStkWHhQL01QYndTeTFuYUlmWG56QWNsZGtlZXVJSFZJR3ZaR29oK2kzMlk3?=
 =?utf-8?B?ZFlUVXd6bHZiSFVndks1SlNrSi9Tai9hZCtpZXNqWGNNazZCTmMxQjRJUWE1?=
 =?utf-8?B?djU0NmhPL2t0UVBYL20xT25SR2VvVkJLU0FVSXBHNkFiS0IyTWM2c2U5ODNW?=
 =?utf-8?B?T1JZaG1hekpkK0pwWU1JV2pTTE5BM04zQ1dpMDcrTUJJN2UzZ1kyVE5LZlNy?=
 =?utf-8?B?Um90OWRFUEwxNTJuQlc3U3JHenZ1d1FwS3FzY0tpbGhaWTJEYk1CcWlCVUJy?=
 =?utf-8?B?WG10V1pQMzBOT2lPbjRLbm43VFBNODA3cW1JYkZmMVRXWHFvMWVCTGVlNXk3?=
 =?utf-8?B?WjBxelg1amQyRGJOVkxTclNKLzdBSlRwaWw0dFp4U2YwRDBRRncwbjFHNXBi?=
 =?utf-8?B?dnlaRWdzNno0Y3p2UCtHbjhEMXd5RC9ITWJtT1dzWlM1akh0R05obis4cFZs?=
 =?utf-8?B?SVdkWWxybzlHT2djbmQ0cUFISnN4UWlFbXVmdmJxdW90N3Rmb1pPUDE3cmov?=
 =?utf-8?B?Z0NoTUJsYWp5MWNNZHZrWUNFTXhpWTFKM25RcFlsaS92bldLRUp0Nm42NDdE?=
 =?utf-8?Q?B9DV7Enx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9de0d7f-0901-4933-1149-08d8c27fab3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:46.5205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mavtU5QlKp9v68gpIRbOYVk4RKAW9y2BeUDSa+kxOG4Fg0+opJq5waxTlwKJ0hHFP+0+HZ1I3sx+SIInFDjJEO1ucbbItrua+WsW2ppZ+js=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=978 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Jan 2021 19:57:36 +0100, Bean Huo wrote:

> Delete ufshcd_wb_buf_flush_enable() and ufshcd_wb_buf_flush_disable(),
> move the implementation into ufshcd_wb_toggle_flush().

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs: Cleanup WB buffer flush toggle implementation
      https://git.kernel.org/mkp/scsi/c/d3ba622db82b

-- 
Martin K. Petersen	Oracle Linux Engineering
