Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6DCC38A2D
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJVDUj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJVDUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:20:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A412F181DB8
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 20:20:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1uoeI030082;
        Sat, 22 Oct 2022 03:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=MuYymIIU8TBcJhHBd1RkTdj9hbchPDoPHc2fr+Xb6N0=;
 b=JhHlqdDBSpHQryRwYgFaYEeYi/xUzc15Gk04WFnJYp0i1GICEc35z6BV1UYNvgvsygxz
 iehsFdNVTqpOVba3bJcTDRn4G66frmQKHp3Ly/pLsNoyG9ye/FyPaR3ejlj+ympFAlH3
 sNKbzvSHXgzY5I5a4WntEk1Ev3m+IVa+FF2zmIad7Oq3kMID30PELyPa+0vJpaWaRPo1
 SxheWQzJnUNp2gxuoRreiPDqXp6lUODXvxtLHez1pAuZA4QRINpKb8Zc+dsaDikfeAs3
 Ya/jWQze25ch97JtSmuBIXnbMEBIC79nen9zEd6JgBZfxlBESYcP3P16g6S3/MHx3eN9 bg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2r1sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:20:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1XBHQ030662;
        Sat, 22 Oct 2022 03:20:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y296cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:20:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ps22Hi9Wb7YMPtQe8DN6oO4omHRfFUI3mdFmHZUbrrm8JUGIINmpEMVA3jn4R3oR69sb5GDskxqcurBFJxAsJK56R+t2uYd88DBI+OAHSjY4kQVAu8mdCJeXfNiTJzndvKs4g0T/0c0GD6sGDd2X93vKxt1ptpxG3cerPCwTrKAYbnvT2Md9VqRJLLPre4PkntvEh9IpuNt4LKu1ATr0T6U22oa7LsT1tpG93Vo5WvJZS9d9j46FTpTIGXefnIsimXQ+NRBo1c60mW4V41WowUf5knvH8nJhRCISSTTRYROtmCkjaMjnNiY+2vli08IuEibrWWvuuYBMfMA2cKWbVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuYymIIU8TBcJhHBd1RkTdj9hbchPDoPHc2fr+Xb6N0=;
 b=P50K5zM6t/So6oCV/u3thc4ZU3WbDk/T6PDM28rubtZ4DtFYgxigd9Vt5HSvq0xfwa6qf2hU+cHXRmeXmwdll0JyxTKJ+IZAySmvPE1rk7gUna+slB6fnT4HGw+2SQ+AyVLZqHTmz1P2jJSD02VtsI+ITSwdO3jVn2uKlfpdtbDGa5BTxFdbfjSBClc8aB/MaheoHnLcIgYYBHOYPFasws+UQDUtiGjiVqVfqo6MhoDvyY9KkPertSa2ZRJZ1RSHvETcDPxDYtPQfB+XFjcXg5kb7Y3oMfsGE/81wzjBKwEBSIf/IekK26zDlRVsB4FRIVXX2hYCE+KgAnGo7UyhFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuYymIIU8TBcJhHBd1RkTdj9hbchPDoPHc2fr+Xb6N0=;
 b=HVqcE3c1cjAsNMF1nt9QVm+3NS07fiVOpNatsYaYH07iRW7mmHPMd+jriMgDKQ5YBEUDilPGvxcOeu2zXQ6X7oMGicxRTTefxZKJgyJetGMJ6AmOEBtlOSNsT4FDnZiFP+pkNhNwVNrJ09keeqCxWtdcVvkiSMoumad/r7xrve8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6492.namprd10.prod.outlook.com (2603:10b6:930:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sat, 22 Oct
 2022 03:20:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8714:e5ca:3c31:7bf]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8714:e5ca:3c31:7bf%7]) with mapi id 15.20.5723.035; Sat, 22 Oct 2022
 03:20:25 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH 1/5] lpfc: Set sli4_param's cmf option to zero when CMF
 is turned off
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkq4wnm8.fsf@ca-mkp.ca.oracle.com>
References: <20221017164323.14536-1-justintee8345@gmail.com>
Date:   Fri, 21 Oct 2022 23:20:22 -0400
In-Reply-To: <20221017164323.14536-1-justintee8345@gmail.com> (Justin Tee's
        message of "Mon, 17 Oct 2022 09:43:19 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:806:f2::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6492:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7af97d-ac72-4cbd-0912-08dab3dc5c45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T4rjNQ/r+b7+iBFbeta9FVpZUVoRNtIIMlO/oZu+0OqhCARe6mVevv4HhKyKtCLrJmriBoIhde/D+olNT7IR5CzV+m2caXZgaIohLoaygruO9N7fZxsLOyx3iwoYUaNmj2kQUUJw0YkoiVsSTyyRIVibHypCNs6YHuhRK1LLWZr9yC30uSPqyR6UwruLyvY3c/XTVGfRgLQ56K4/fLpBiznA8xbfLBt2rqY/O9q5zNpxSaTEi0kVDI2kKiSmLBxIJSVQh97W6f81XuWp0TrVMvuvWpppriVudwJLkByrjvWe532vPiqp23TonK2sRtlE80ahm2nzKuZu7BuSDOIm+ENDzDkhivMZwVUb4X2Vn1YG9PyjEQ1W7zWPG5mNFYvusKblvDn0ofM44J9pzf4WE+QmjNmqBP6stlzWD0A4MB3Afhawjq15a8WwSQdCjxzYalnYYhpprx6gTKpfwY8uQpeudarLPIuUymME/3PH4qdTzZlUrSSY2BHq2+471egXeG7Y8xFhlITV/2w22B3t26ZWQUztamct8r2IMDv2chv6axzqc/NlL5lXyOLRjeOvCiZiAEsBsL7JoWjx4FkudCxn6O3IK5f6H5+mEukL+S6/5CzvQHw4bzSZNiMTIKurkmsBBuI7Am3329PpHy4T/LihgEjO2qlJiZ/SNQ4Xvzf7on0NZ3vre7kMZ3Xh83YLZCjbtlQxj52/wQKqiYM4Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199015)(66556008)(6916009)(6506007)(316002)(36916002)(66946007)(6666004)(8676002)(86362001)(6512007)(8936002)(41300700001)(4326008)(5660300002)(26005)(2906002)(478600001)(558084003)(186003)(38100700002)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CNQc732bh7DDN4jzVoKap5vVjVP9p1YsUBQaYM5xVRrD3Uxo2Wx6HtRgHk9Q?=
 =?us-ascii?Q?XFeD5xuii+SUqj9cAqvW6VSlXufj3765tzWmBfHHYGQSJHshH8C///7RWXbW?=
 =?us-ascii?Q?jci5wI78CrHJYOgPKsgk9WQU6N+p7pOZfksIPS6ZCNpUTwBOjjbPMgB6mWHd?=
 =?us-ascii?Q?vCoiRXY00/50ZWOS6FGxJwidzMzc9WfFXb/9LYfMqyDI4f5DQ/m0YWG2ercr?=
 =?us-ascii?Q?E6HmWdbCDXkXrvGe2JyFUOfQagJ5u+aETrn3b79hwOgezV3UsuWD9WkIG4hk?=
 =?us-ascii?Q?hxYTNUMDqR7gWfQMVYyxyFt6zUaU2ntA4dC1taJcdCmT2m8e1zF6W+jQKBtW?=
 =?us-ascii?Q?fihX++3xeFgS+FYPs0BpJwAnWqEDkTYPtQoRd32ABilBO4scGL0o1KVmzRsK?=
 =?us-ascii?Q?ok3og+h9RQ2AvEN/yJjtCeIWC5vfPCJ3XqT4nwoc7IkjcNDNbEEhOxq8Vnel?=
 =?us-ascii?Q?NjAKb85t93YJAzxO/72TwOclSgnOWbJFWeS4yTENA0mNTr6KBhxlAlj6s2BT?=
 =?us-ascii?Q?FQ6ABYQPgiI1zD8YGQYjrijp+RD2EXYC9nkLCYf+XpcYYNGMN1Zl9YeW2ORV?=
 =?us-ascii?Q?hhbh3qjPK5i/THIbVr9zY7p1nfgFZeJi8qYuTR3N+kTqzyjzhdqSRP5V1ETV?=
 =?us-ascii?Q?fk18YGY5dUqoFi4rUyyh3Iv7zyMJIUZ0894uMzvjXsCySc7iIZerhNV5Z0rm?=
 =?us-ascii?Q?2hTK+ZyUawH+MhmTvp6IWUVQuFf4n7nLkkwWinOV+1M5R/IHmfyU1M/7GmVw?=
 =?us-ascii?Q?RPJUTQgKDUZvQxuj9HaB3PVLGpd6SDzPXSWU9LMfb/UhMm2KYhOO+nZAIN1t?=
 =?us-ascii?Q?2JWLTJMhcCmsX495xRp/AeAY5wUE6mV4lxcEWhbjK//YLg5QVFWlSfgHkzcp?=
 =?us-ascii?Q?FctUbqem7KVeiFOpXBQ67AHVKvt915AJpFzwtEeW2gLfGogF6A+x45zvTtlG?=
 =?us-ascii?Q?4KTn2oEiBvZuJKPqN8NmwxycOtlbmOUNschcV1FyTUWXjSC+5zdOnVE2Jpj1?=
 =?us-ascii?Q?xtyG/5RH5X5YoPneEzyR5QU/Nj872lcmLOmd8EAV12qGtH8fHKl3moI2Aog9?=
 =?us-ascii?Q?bGQGQPFwC6loBRC5VxfG7Tc4vTCCis0PqZ9Kgt3fQf1WVAyHDv9Kgl2EUqdZ?=
 =?us-ascii?Q?165D0mCUzsLOnYyHqH2UKGkn/CCEG5jL6PqnKNxxl9VNaW/tidCfOZvgxcFy?=
 =?us-ascii?Q?+lbdwNI0g9HhDV1ntEbdLr4BwYKOnmo4BUQ8gQnxzbAx/zQO+NTZZm+rOLmK?=
 =?us-ascii?Q?m5HaX1xoggH3MfrSWq2KWcgQ0t9eUB0fdsQwUJkCGQzKGKkDKIJ9yH3JJJmQ?=
 =?us-ascii?Q?kesB6SI6ck4/bxcX/9CY9oB4JtP8QkOuozRDLyZ4jlccg6LY9bM54stnPRI6?=
 =?us-ascii?Q?SjjYIPHk0nw3FrNJ5mf7E3eddXCKl3GRaa7oYOGWnxVEGqbQzZeC7UrWHVI+?=
 =?us-ascii?Q?ky3G9WzmBFfttZikhYiFZuteVZv29csPqPcIHgX0j9dow/wB2JYXv2wgbxdU?=
 =?us-ascii?Q?+omC924szNFTXeO3WV8ieuerjjozyd/KgjwgloF6rszWCRKMZq5HqQcWnPhd?=
 =?us-ascii?Q?laxH6E4hNhicHqvf5GXNB2wmMFWDekctFzChWPx5HzH1VnBp8DLG9AVv+JaP?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7af97d-ac72-4cbd-0912-08dab3dc5c45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2022 03:20:25.0113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9/7nBTSWDaDvQw45zXHvDyjc/8/GzfF8gEn7iLXUbIn6z5mCAMn9fqZ7zgfVECFsGJyAOvr5PwifIEySKvJXHbOwUGA8YbSC5/ARU7uk0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=761 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210220018
X-Proofpoint-GUID: w91pRxQWECg8yV4koWc8SCUjOrWS56_O
X-Proofpoint-ORIG-GUID: w91pRxQWECg8yV4koWc8SCUjOrWS56_O
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Add missed clearing of phba->sli4_hba.pc_sli4_params.cmf when CMF is turned
> off.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
