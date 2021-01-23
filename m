Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61859C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FA9323A60
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbhAWEXv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 23:23:51 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54614 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbhAWEXX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 23:23:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4FtE0165096;
        Sat, 23 Jan 2021 04:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XNG4jGZCnGe8XtxgkzvvhVnYo8Nm491YN71fK9bH/cE=;
 b=TSMTARVca+Ke4qRyHFzTDoZrrYIYF7F+5JUDzddinqhyWJURdCaeZRibfMXx0DDwodKB
 Zh3hPh4bMI0QU0CRAgTH+d/++y3CPHNTC6nKw9POjRzjBQ5RfzHlE2ow75uCvwtoRIbV
 VugRNl4I+EPxKOuYFC6GDLKQ3a7emhsPSmuluU1agPhIQZ9NcelD0DBbEkiD8udSRMCF
 1vpj7jRhuTS2S52NChWG8BxPxIfpqqxJ8LW+rWxPHsa49YaFP818WvNfkJw5s5sH1pe0
 F3wLfOJSqLsMTSv/CoQ1tSLNrfPB/mQ4sCXiI76cQMdDYihydNtjPr9fqE/xgVAmCAfi dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aa8a56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4K720174110;
        Sat, 23 Jan 2021 04:22:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 368bm0s8rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvL0tKdxK1a9YTOBrxeIZedkihcG0aSbiWIGUnpyJrMuPgo/4tlwWPuue272W0+SAKK2+uifAIqG4LLuYqhe5y21fs+nDOjULsqKF8m2W5I6bL6cO7FlHDK8TGtqO+zVlcRvGa9Lu9w4AfvcvnpDJtZFWkaEvtJ6Brz/RABdu60lf8uxAkgW/GKEkYdsBrRbWANsH1ffnKu4Mtn7IxUAR/JloryMk01zYCqXVHJsSX/64vcTEvqgyTPGFK1c8bLY47ZLLMWUNSWxE8dNyPcRiVa1QY4ZuUruSu5Hyg0vfD///9HclyM6wzD2QQtXPp88HLkUu8xdAS10Ow26Ew1KEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNG4jGZCnGe8XtxgkzvvhVnYo8Nm491YN71fK9bH/cE=;
 b=TN6e+G8XfCNqfRy0ni12v2FjEtQozW8RWpfioK6RZvGE3SqGobyL82PgqP9dUaNPNsFQmtJ1DcMm/Hq20mFzbXsqMQuLvidJE5kKL8PULUr9eMlroHrDsIZH+NWlWnwIhcUKJddsueCJx93mUJ2gsDCgzd1J1PLZXsE3y0AjutkRVjFXNdEcJTK/p2YO51Skztp2MJ8lQG/z1jJk5+lDRT2hedTSx6BmLc/0B2VKabPlJrmDL+AVRddsyg96znPwS4XIPp7bCYW4lWTnf5XMR8SkOPVFL7n7/+hpqGLM/d8LoleA0EOFsEEqmeskYN7Y/KXCvtqoanFnmUQqaq4sQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNG4jGZCnGe8XtxgkzvvhVnYo8Nm491YN71fK9bH/cE=;
 b=S1m1jaAeYznStdoxBp6zT7jLIUr1MGvKcEfwd+Nuhi87se5nh/I1A8pzh1OuTVqeNUVKuJ9rxF6uk8Iqc39kbK8+rFUCLEU28NlDwigJpEDCNDR35zBJfC6vZnN+Jj4FfEeMC4WUYlwoJC6F8W7nG9QYzvHyjN7hNnyNVKSbtkw=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 04:22:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 04:22:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        beanhuo@micron.com, jejb@linux.ibm.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 0/6] Several changes for UFS WriteBooster
Date:   Fri, 22 Jan 2021 23:22:08 -0500
Message-Id: <161136635066.28733.585752456327626682.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com>
References: <20210119163847.20165-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 04:22:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 940cd850-3203-4673-e6b2-08d8bf567e1c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439E8204E6DE06B6420F4928EBF9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ATLNneX6H+e3zWSnIkKwoTUKkySRXoqaI/lFYm8DOwp8e5S7KqardWeUZ2x+4HAyq+b6qjqPiFz4f+W+I9k/HZtnCHGGbqwrP7Bk3qKpr5QBkAY3RyG/4ZR+sN2l3tlDgXg5yVk1OLqIKNWVb08ONiUQMXgiTX4xJvnK8I9eJBfoBcqHUnA6TDaQHBPD1JZ8wfHZO3SG46PXF50lN6w/Cgqx79MwNZWysdZ7awhZaw2FmgfkX4BiGv6EZav0SxypHP2ZKjZoV+OLX6jNr7vFJVFfcQk8Sr34IHWN2FOzSEJ2jUxsfG++rt+j8V8qmLCUsY8Mbtr08Yit4ug92XDaJqpmShd4exBKLkZZjmJbRTvavUrO09qXYmvoP6L7dmKOfd0T4F1MvtORNWG3tk2bsN/fg1dKo9Y14HvF1V3YRch2Xs9DUAg2vHU5+Eg5ghoR0vRmTgnYxO4W9YtzIeJR8dC2HpCtpKFa6u7pOTr5PTUdeM82xi9HJgfUCvm/aZYgnOkamHipxvOReLWrwuS+ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(6486002)(7696005)(2616005)(186003)(316002)(4326008)(5660300002)(8676002)(478600001)(956004)(16526019)(86362001)(103116003)(966005)(83380400001)(66946007)(921005)(2906002)(66556008)(26005)(8936002)(7416002)(66476007)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dWhnVUV0eHc3d2VpUGRHbXUzWWZFM0Y3aU85WEFuRW5BU2Z0NllVaUN4ZSty?=
 =?utf-8?B?UDlLWHBhK3BvejJRcFRYVE5MT2FSNXNlRUFSYXd1UlVvZm44eG1TRklvdHFN?=
 =?utf-8?B?ajg3dDNGeHVkaVZVTzdQTFNsbnFuNnRzS3ZPR3NLeE5yYWRFZDZHdDJKQ0pj?=
 =?utf-8?B?Q21weE5pSVJXSjNiU1pVM2xmVGNDMU1RYnlPQWo0MUdmY1lPUlEwUXZ1Rk1l?=
 =?utf-8?B?TFBMaEJ6RUNmcWlVNGlQTzZTV1J2cndBSmRlSkZTaEpBbjBheWtSSUs2TitG?=
 =?utf-8?B?R1Yzdlp4SlgraWxuMzNzeStoUWRVN0RRWEJScDNUUm5CL0cxbkhHajVsMk05?=
 =?utf-8?B?cGt3VnBUdlZMdVhub1crblJ0UndyUUMrWktUR0NSa0F2Sm11a2xjMk54ajNX?=
 =?utf-8?B?dmI3emhnQTZiWkYvTHEyMEwwMG5ZNTdXL2hQc3Q0WkJOTm9SZDBBR1hGdk9v?=
 =?utf-8?B?VUp6cC85VW1LNTNKWGpFd0VRSWFQNDNTQnZTaGY3TWJFWFRiMWlwUDc4RS9G?=
 =?utf-8?B?dzZlN1dRRkN4M1Vtb1BXd1lvNVN1UUptZHFnNW9vd2plQjY3bVRGZGRiZ1Q1?=
 =?utf-8?B?azNYWlNraUdFMUpaTmI0T05jeVU1TTVrK2dtZUREUVU2QUVnTDVsYTVVSEw3?=
 =?utf-8?B?cHBlRGd1d05XZjRZazFnaHBEeWtsY0VuQ25wdUVHVjFLbWd3RHlHT2F1MjdN?=
 =?utf-8?B?Tm1hTnp5NlJSNDFJc04xZktxdmI4K3Z5a0s0ZUNaaUgxSStIOUFKK25Rdm5u?=
 =?utf-8?B?OUtEUEFoQzFYYzhxMzQ3RmZyUml3bTJjSEd4dFpIRVlaV29XMldwWlBYUTR4?=
 =?utf-8?B?NlVEYjBva2tTcU4vaHZoc201cXFMUEt6a21pbUNJakEvdUEyYWVIUnhwSUJZ?=
 =?utf-8?B?MEtiLzdHYlZXejJrMk9hNitpdDhTVm0vQWF1b2RWbmsyM0ZKZUtvRE02QXB6?=
 =?utf-8?B?T09MbkppdXlwZ2lTQVA2WVdjUUltRWFQZkRQZnk2dngySmtPdzl5Rm9EYzg2?=
 =?utf-8?B?VkpjQWU1QWlyNDJrMWVpNmlJMjU5OElTT0FEc09BMlBEcmdVZlJ2YWFwY0Ni?=
 =?utf-8?B?TmwrYUo1UUpZQm9YZHRYaHYrdjNvK2tyRGJsVndnWUlIQXJyUEs5UlFaZ2Er?=
 =?utf-8?B?UDh0Qk91SXdWeUU5bHBwd2VVVFczVjFpSDFVRGZTd3dtNDNPMS9vL3UxMFN5?=
 =?utf-8?B?LzlLbnp4V1ZCV0ZKV1JucWNUSVllZm1xVWJVdHBPdGlEdkUrSkN2U0ZsbXlu?=
 =?utf-8?B?ZTEyTjhLcGlCQ0ZmMVJ1d0ZIOHRxR3J4ajJxN0g5a3BYMy9hemttM0lHTUVM?=
 =?utf-8?B?dERETlVGSU1lWUZlOXo0KysvK2VJdXlrVldTQSszb2crVEJkdERJYnBRcjYy?=
 =?utf-8?B?eGtmM0JBMEYva0dzTDVrLzROdHlSSWVadTMrWitBMjlXTFAwN09qcnZTN0Fm?=
 =?utf-8?Q?iFpqMBGY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 940cd850-3203-4673-e6b2-08d8bf567e1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 04:22:27.9529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0erDuSjnm5taiBx970xZp+vXbqPUx2tTHjWvuX/QNhgiNTHx2gEG0Anr9SOYZNDR2WSy2HlyQ2zHDhEJelYxRbDLKoi9Aohg6800CvZ7n8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Jan 2021 17:38:41 +0100, Bean Huo wrote:

> Changelog:
> 
> v6--v7:
>  1. Change wb_on sysfs documentation and add information that WriteBooster
>  is already enabled after power-on/reset(Incorporate Adrian Hunter's suggestion)
> 
> v5--v6:
>  1. Remove original patch 7/7:
>  "scsi: ufs: Keep device active mode only fWriteBoosterBufferFlushDuringHibernate == 1"
>  2. Rebased patch onto 5.12/scsi-staging
>  3. Add protection of PM ops and err_handler for the wb_on entry access
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/6] scsi: ufs: Add "wb_on" sysfs node to control WB on/off
      https://git.kernel.org/mkp/scsi/c/8e834ca551ad
[2/6] docs: ABI: Add wb_on documentation for new entry wb_on
      https://git.kernel.org/mkp/scsi/c/06aea26676a5
[3/6] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
      https://git.kernel.org/mkp/scsi/c/ae1ce1fc61d4
[4/6] scsi: ufs: Remove two WB related fields from struct ufs_dev_info
      https://git.kernel.org/mkp/scsi/c/e8d038139420
[5/6] scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
      https://git.kernel.org/mkp/scsi/c/4cd48995645b

-- 
Martin K. Petersen	Oracle Linux Engineering
