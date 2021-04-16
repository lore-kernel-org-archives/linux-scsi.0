Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647ABC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3759D610FB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbhDPCwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38858 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhDPCwH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2ngRR047240;
        Fri, 16 Apr 2021 02:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=z0CN3GfbA7dvz8vAV91BrJiGIbex9eRQiYV7PzdnBco=;
 b=PVpuPB1FpxJDPxNA7EIjit9d+IogrHpmr6jzPTCZ9WFPHJkW2XSl7gSUZov5jk9iwIbC
 v+yYQZlbyyVVXenXnGT5jN7R4OfxdKabIYeYmb4tFpvRxIW17YTJWNxG41hCrVbZYrwx
 q3e4VUgboSg+dYQuAUBtenGvFuvB/NEtBLk7dz1ClPGWISoDi9/BTipTXJdgFG0IAFIb
 eWaPK1iZnlqPBDJ3wKkxiNrKKYfKmpD3I/I4UV/16rfkA3umJbBBmRbvU/qatfIVWW4f
 2OpuKViMT9Cq4TCEWaE5FAghTiyVJnmIS6U1yWLZiM6GU1UiDe8EkbTkP2qDZUKLsdST 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oeFl162577;
        Fri, 16 Apr 2021 02:51:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 37unktgk4m-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHy57s2w4EZnKjUg8/jjXpYNzfwKGi+S3Z34ojRvQtqxtEk+wEhcm1Xa2BZtyThS1oaX1azEJnCap58Dbp0OO2Fr9IGJGwappBlytN/EomPhRfKHyyG+n+2vTNksjfrN/04pifhjmS/57RIVBMTLv1Rd5AeeMdKlPS5m+8Ytk0b+eTYn56McPbIzqxrHaBgYu2jDctkDrjccy3twIIfC3FdY/S8JhxL4mAIL9/FSyptyp/IDiXoqBUzP53eekKa8G0Tr/cu3P/ZoH5C6Zh2+kOfQH44c1kmX023kOr121dWAVZ5xymzWkV3Y66lMlxCXy3a3U1a82TYDk1VtA7ALeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z0CN3GfbA7dvz8vAV91BrJiGIbex9eRQiYV7PzdnBco=;
 b=mU4MqxSCPQkfJQ3MVdV+iFNvYbTEwZsPJOfLguwry8nUlcMv55jhbOmM5tHTzVv3CmI4z4Ez5of9RFOZPLrxpC9nhJ9AiZG1DQl//R/XmtCAI3CsFL8LqU7R73TwkUiV6sC2lLr0LSlJ02t9JLCS8VoBPCb9Z2oHD9cZbVnXtk1FpKrlmHQh1uZwG67q3eVdFUKY0XDVAdx1EkhxMthl5NhCAv/FdQw9UFcGfnb34Ov4DESM5xeXT5LRJMf9jr06fcc7Xz2oS9hDqLwp/DoPdF5OPN5KEQMJyjYZA6euCZn9E796OSC0+8RRhLKy0a8yNy/bPi9MpKGqEnzBUFjLfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z0CN3GfbA7dvz8vAV91BrJiGIbex9eRQiYV7PzdnBco=;
 b=f9Mkg1FFA3hQBbgAHUkd805/R93I5Crj6+95G4x/R7KBkJoQmNqGUV4/xmAPHJ2IrF2j+8hEEGGQvh5ClR1TtM/n6/u95Q/Sm8lxuHTb2S3CXrWOT/oA21KK0n8FxegK7L2jFPhkIz4V38ivQRI+CMp3XeO2HLPdCeqQjD/F7sw=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Enable devlink support
Date:   Thu, 15 Apr 2021 22:51:10 -0400
Message-Id: <161853823945.16006.15335759945407578270.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331164917.24662-1-jhasan@marvell.com>
References: <20210331164917.24662-1-jhasan@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89eb4542-1833-4d4a-cbc2-08d900828acf
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568CC92AE4DB70601F1AA548E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3EkBBiM7PjqM6UoiNm4ZN5NWkca9lsLn/9HrnmmbEWuQ+zYq8EMNW1aoEVanht1Ma2vIizx5h9ghYUkuBWXFIgMgAacVV2K2UAvpa1ExpmaiP/r99KTYO4eempnG1m9nAvctyXvx2eSUriR7nptujkViYIbspKiPcCopqtp3h48n7ORYXaV8Lm6cUYtJ01aI7uz4pSImKTjmsJeM4S/ogIm4rEJuZOoflabgbx7cRknAgplwPypJfExvEm2y/tE/c1HTsi+pVzYewTY1wYMqrZSMbp4ciQBfzkyu8H20mNdWFU4XFInmt9ct7vSSbDhlWwkFov87rG6xhlLGsiBvivuqqLp/TUJzecIYASMc//UWlmD1EswS86CVVLmiKtTgEONbTR0F4+5EqT1QPJPuzt7OzBTHnnUWuzCnwmRUrMDKuN6aHoe9FvxaCwAWOsoazeptOsP1CXME8ZmGhVWd2Bcx8aLYQstO2UPYheeIXp4D9xs+fIbaAAyQ3XmvGpQ5oJ0FityzkxKkhbI2VvU/uU+8Ycy57iOTYT5joS8uY2PkDpblVu1osTCv2D4t434YiyrlI8Qhy0Y3Wm9BqWD2EILcOL9zQvcsi89acEn1LKIC1RVEuz/NBMW86T2qiW2iSjX5OEpyu+Yciof686Zy6SUvbXUj2n4OoFdMxV7Cs1EZIYhuAsQfNAjpVSnoE49114RoM2qUoO+otVXlqBahi+BQUV2qIaIQLuXkWfBfqw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(2616005)(956004)(8936002)(16526019)(66946007)(66556008)(66476007)(86362001)(6916009)(4326008)(8676002)(186003)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MjM2a2xxaTFSbXBjdTUrUHFJQjhNN1Z1a09OMnBvUlc2elovTEw0U01tNnJ5?=
 =?utf-8?B?STFmMVBCa0ZFTCtlQ2dURTRtRU9UcFNhVm1TdnhLSWNLdUVaNnBJV3lYdjQ5?=
 =?utf-8?B?RVNaaG9JdTJhNTZFd09PLzdxczRiMkxwTXhMVzZnaFJxbnpSSjJ2TGNxQzZI?=
 =?utf-8?B?dy9VZWhXTU9kV2xQNE0rQmNSVnhyYW05Y3BiTExvTkgzTTFES0FNRjQyUUNr?=
 =?utf-8?B?UnY3MHJIOURhNFZmeUJCS09lM29Jc0FwWU9HQlk2ZlNVSzBMeThJWFVzM2dB?=
 =?utf-8?B?SjIwOW01MXpmbFVTOUhucFRpbU93SjIrRWp6U2RuWWx5aFBKTzE4UnQzaDBz?=
 =?utf-8?B?ZWpZNVBqSXhHdmdGZFJMVm90b1VLbmpFUWsyQ3Z2ZzJxVmlIOTR5ZytENU12?=
 =?utf-8?B?NGh4Z2JXOFN6bW5YQ3JvNktHQ3pnZFVkeXlENDEvYlZsSXpubVk5UEpXOXJH?=
 =?utf-8?B?T1E3SElJSEtVcXh3NU9RSmNpZkFyYUtBcFE5NG1qZEtXNzlHWjRzeXZvakJ2?=
 =?utf-8?B?WGV6aWRRUG8rWU1HalVGM2dsUmdPQ0d1b252YmxKd3VzdVg1d2c3N1pwQUR6?=
 =?utf-8?B?SnJtNEZ1WDZPbklMK1BYcnhGckYzc0luUnNsdHdWckh1T05WbVk1bkRXY2NO?=
 =?utf-8?B?Ym5JcFFINnlrMks2VEtQdmtWQ2V2Y3Q0dGVRUTNWSEpsTEhwV2NxbW5qZE5O?=
 =?utf-8?B?R1FKbC9kZU5GcXZkMEIycHl0d2pTallrZFJUa01HWFZVRVRKQVhUNGNtTTVk?=
 =?utf-8?B?ZUg5Qjlrc1hMeFVLbVlPWlJHcWFlY2xwN0JiK0dRN2RkZ3BrQ280bEZmZXRG?=
 =?utf-8?B?ZUFiektDQW5rWXZiWDJoQkEyYU1GMzdjbm9NNEdydXlrYW9uUGh6UUhUT1Ny?=
 =?utf-8?B?VmhCRnVubEVOb3RIYU5yTVBsTlUzS01TUkg1WHRFU1FPbzlqN3ZPUFhTc3kz?=
 =?utf-8?B?K0QvcFJjTy9Qa3pBL2s0QW14cGF5Ukg1Sy8yT0QyT0M5b0c2T2JFM0o5enFo?=
 =?utf-8?B?TDdzSXFRSmdwSTVXVXFzQkNXeEsralRTaDNGcTNSZXR0V21EK3hyWXpqclgr?=
 =?utf-8?B?UWJCcWFQeWJOSmpRVFloMVZLQ0xyaWlROURmZm91QW5TWXJCbk04anNGTENi?=
 =?utf-8?B?MitNRXh6MnViZUJZZHV4WitLZllEdFVTSzZsMnBsMGFBaUZVUTdndGYrbHdE?=
 =?utf-8?B?OElKRm9mdEw4d0wyandtRWk2YmhMaEthQ1pYdDdmaHExSmVELzlmMjlLeU5y?=
 =?utf-8?B?TUhENVJyS3Z6aU9VMmlsTGZtSkNzZEIzNHR3c1NiandFRjdBb1JmbE9SQVh4?=
 =?utf-8?B?cmYvUE41b3JCdWFLUEpjRk9INUtFU3l4Nno0Z1loeFMyOXdqMkZLRHBXUHo1?=
 =?utf-8?B?cHNWSnJtcVFvc2dvMkk4cGt1UTErUVM4Y0E5RU03ZisxU1N4UGVnTzVrRDZp?=
 =?utf-8?B?c0R4ZVNTeTBGL1lmS3hIN0owMXo3Qit3Z05QQktHVU5oaHBPTTJLWEZlS2xN?=
 =?utf-8?B?eWJDWmlMaTdBZG13bWRGWGVhQlVlVVM3S0RQVG1FelNTbmJUYTlNZUQxdWlS?=
 =?utf-8?B?MlFCSWU2dUcvZUthaHRVRjFiblhzVStLV3hPQjdzZ3o3TjJUWkZ3dk1TS3lj?=
 =?utf-8?B?a1pqK3ZSMzYxNnV4a2ViUDBuU0ZzVk5xV21IS2FXR2JSRWhzRWVGaHN5VzNt?=
 =?utf-8?B?L2owRnB0VVdOTUdnNHRMV3QrK1RIMGNQWFE1eEk3L0hSQkdBd2g0ZUp0a2xq?=
 =?utf-8?Q?ey20yQD8EInrfG7LRwzf54ofYSzD1q+ctqkok7n?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89eb4542-1833-4d4a-cbc2-08d900828acf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:32.6259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYdxGUNCm8sajlS7WBeYp9T3+Yw6lhgDavPb9IglmHtPaJcJk0Gjm0fija1//bLO+sKc6rULnPrknW2EhZm/9CwnxXPkyQI77wJDaoFRICI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: vtW59I1MXrYC8TLLdqU8seyLzLdU4PbD
X-Proofpoint-ORIG-GUID: vtW59I1MXrYC8TLLdqU8seyLzLdU4PbD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 Mar 2021 09:49:15 -0700, Javed Hasan wrote:

> Devlink instance lifecycle was linked to qed_dev object,
> that caused devlink to be recreated on each recovery.
> Use devlink_health_report to push error indications.
> 
> Kindly apply this series to scsi-queue at your earliest convenience.
> 
> Javed Hasan (2):
>   qedf: Enable devlink support
>   qedf: use devlink to report errors and recovery
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/2] qedf: Enable devlink support
      https://git.kernel.org/mkp/scsi/c/4aab946f789e
[2/2] qedf: use devlink to report errors and recovery
      https://git.kernel.org/mkp/scsi/c/9d6f87c25ad5

-- 
Martin K. Petersen	Oracle Linux Engineering
