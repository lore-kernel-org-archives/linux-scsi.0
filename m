Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7431CC05027
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 23:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjBHX4C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 18:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBHX4A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 18:56:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEEE16ADA
        for <linux-scsi@vger.kernel.org>; Wed,  8 Feb 2023 15:56:00 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318KxODg003997;
        Wed, 8 Feb 2023 23:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=8h3axM5F/6y4l+5AdQJ/xLoMSnTfFQ2c0yti8MbLx4E=;
 b=Tf+/k4fzJl2W8tfYvsuxGptMcfmDf73/htKP4f6YLKTvt2W4zPVcjvP9Vefr1F0G0AAt
 RLqUKKCPFKIQ6lffEHNE35J09A2DV2fmMePEkYoG+lAHHuhsdJGffzTLASsGdUYNnUuK
 90Ov+4GNU4PLJwjdUTuVoU1pCdQlcbwkl4DeF3p1eJO3ev2cHifWp30HmJhGFX6khibH
 8SCbOrricOyPg+0k5x5jli/XiG10A+K9Hou11BQqnN6rnDjpPMGf4Ib/21waphENYpSS
 8yCbbuTt2ziw52MuLyzMxOHzQyddvNb8D6k5TWPb3HkfAyYUlBYi/k4riers7Yju1zN3 NA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy19nwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:55:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318NHwe4021313;
        Wed, 8 Feb 2023 23:55:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt7y17g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:55:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R475B9AphjYCEKLAfBxp/wz++t7EzaAo2aFv+EvYuZ4nhnZz+PL1livCvbZkrFBY/vqSQlKAg918/PP3pB1sk5gJdq/AxVZPH+kNmtA1OMmisQQBYbuJ6wVLbOAfsVFZWObZ0em70lR+WRciAFFJbME6xt1edm75YWOpSQCOSFN0hlAsiRCzfgDNYToVTC1HqV2bU1C19lwPmqFVBLD/qsIeS89xbd7yuiWIG5PxB9hw851CQa34khl+2vYQOe1g/SUHutkKDj4ZZhPwPRiCooh3GJJGl3NTPqF6S34JUOVvAYQ3FcK5quV7u30wJGcQPVmaHZ+UY1AygM5mAYWfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8h3axM5F/6y4l+5AdQJ/xLoMSnTfFQ2c0yti8MbLx4E=;
 b=eh4ZslDmwU5+KsyuWp2zIv4lDNML1qWEZ4JX5X9ARnjhjoTaDohgpM8p1iFVaRKJIS3QFWgIjmdwgYLxVSVanUdER4IhoOModyq4b7EJAYfg0bD382/wDC54BzfBZ4s55cd4yFxL4eJE/fvApYPi023QvdDW8NpRcBYawfYNJ/RgtuASSXdxOWAOhJkN8Ud9t0x5lY6i1p98X6okrgbP6wBrykUruFrfyrgPbh6yi6DGwpAG6lYqa7+cm9EP2oX/npFh4lLVNImjZtZyM32uHoO6yL0o6fBudKs1PfRzOfn6/tAQjjDBXTdDx1DZUXXArt0dS4ri3jeOgYE/FmNYJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8h3axM5F/6y4l+5AdQJ/xLoMSnTfFQ2c0yti8MbLx4E=;
 b=XUnLT+YC5NcIjY1eyBFG2cFGm/MhyoR/2tie5Ka27dqWPIBKub5MAsE4kG7/WwKEhVw70JPKDVRkSCF1BYHnzG4r7B/pt/Xf1NXDqmxBnsyLN9r1bw/6tDgNQkFZMBxejhdoKN0u6gsJ2iF9wo5jAmEWGxj/tp3m/O8L/s/+Lok=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.15; Wed, 8 Feb
 2023 23:55:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6086.018; Wed, 8 Feb 2023
 23:55:48 +0000
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS
 devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttzvyas3.fsf@ca-mkp.ca.oracle.com>
References: <20230202220041.560919-1-bvanassche@acm.org>
        <Y9yp+H1qkuAxrB8j@infradead.org>
        <235d32fe-1d78-2eff-2e13-5ac82b337793@acm.org>
        <Y+NCDzvuLJYGwyhC@infradead.org>
Date:   Wed, 08 Feb 2023 18:55:45 -0500
In-Reply-To: <Y+NCDzvuLJYGwyhC@infradead.org> (Christoph Hellwig's message of
        "Tue, 7 Feb 2023 22:32:47 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0118.namprd05.prod.outlook.com
 (2603:10b6:a03:334::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 025e2f9e-1f2c-478b-cd3c-08db0a300065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WW8VpQqkfavcLoiine58IBWTOSLxEQqvZOPpmOazU2Gmu/igoSJZFXllPUV6HgFpeDeFESREZoApbjrGjhZ4dLkvQKcu17yHjvAGWpOn9/Uva61gqlKMMnJa7Qybq58HLN17xQ35KrvghzYs7zNGJJoK87TzUGBUFs06zRgv0WKl7PoJI5y8L0D91hcX9gSDdX6in6punga367znKsa2LNNpEH/S9wNHmL9nLWo03XESRoOrV8SQXM/WFA7boomJ3B+rhd5EWv0KB2t7hl/lm6YMawRetb4YNsuA/X9r0IzLdBqewTxbZ0frKkLsgVS0xhRtrX3oz8de3kxzEQRN83rceEiSknCzNa7ATcFRsgTIe+UNa3SHjAK2NhWGR7yWa4S7bSSCLSbkctqG94h+GXSvDxdyWBbdcx1sHjy6HOJ59KIwpOzjDFYN+UbYkGY4w6Z0qllbd8LgXzFJ63MiMIE4/uCxQWRlj4Re/pT9azSKYojrjaVaQfoE2CswatFPD4sPc7lLejc5CFyMljIFbfZW2TapvekFODnWV3n0WNqRwxRh55kWPpsiwGxFtBYt4XP2t65Y4mhdv5XxlZwWSL1zMHbCC4yR00ZeSg+BXvwijSsaKZZkAmuywSndc+bBxM0J0TWMhvGuQ2fLnaH5Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199018)(54906003)(8676002)(38100700002)(5660300002)(8936002)(2906002)(86362001)(4744005)(83380400001)(316002)(41300700001)(6916009)(4326008)(66476007)(66946007)(66556008)(6512007)(186003)(6506007)(6486002)(36916002)(6666004)(26005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C0sJERgvPd8b0BWhWAsjxB//cXinuseMdoC5B5W8WKMFGnCuZVYVLdAC/0eq?=
 =?us-ascii?Q?Aqa8XE9gi6yXvmDm2KZHc8Y0gemHQKA7tywCGGrmXWz3cp3Te3MaUR/FcaM3?=
 =?us-ascii?Q?P/v5zVQSBbtazZd3j2c8R+rtF26BHJGl5DWGJkFbwZ4LLYPN+PuGOzYnoK8p?=
 =?us-ascii?Q?/MIbFM2WOaxVhWrTK1XRcWxA86Ey7PfQAKHgLJaA2w69/BxExectQeeRwBwd?=
 =?us-ascii?Q?o7Y3rCTwFI28afpcdRTvjFBBI0sfnn81Y2+0R/1SMpu25Uj/xFrZrOnuei5c?=
 =?us-ascii?Q?jerht3j/hLuukEuEM/+1nKCK95PIJCbT1FrzwJ5fmeSljdmhL/z+mMb5iCNQ?=
 =?us-ascii?Q?ivkFGJ25oaqbwh8CYccFCJURe9ICyW8GwWFHw3z+B3HcXInUkqerZs69ncwe?=
 =?us-ascii?Q?70jfgQrSoGoijbTPeK2u4dxrGRSuvw6mYWUiPwmOyX8VMbJ6y5GELoLd5Pvq?=
 =?us-ascii?Q?blGfQeOeV+jOP2+cvlL04d4XZZtHRE/mgpvXNhtY7KjOrhT9JJkkTHyurgmA?=
 =?us-ascii?Q?JScWPQlgKs9Ke3PksDbxrjMSp+82X8QyrV//+f9GgltTYlGm9jiyP6k9kAlL?=
 =?us-ascii?Q?2fAILwMy3smkLkhpx5z8P6y3Opmdg50TZovVEYI9b8J1mhJDRvEEiUQzvAlP?=
 =?us-ascii?Q?rJX8mhGkuLV7B508qcNcTOoSj3VWVUL4KAXBs3Bfp5IJkedXDAPVhVWaLx8E?=
 =?us-ascii?Q?0/l8tJq0VYOAWMZv2f592jIN2ZYQYZgb2AMrl9fUzOy8TMyR23nlmBZaCRXg?=
 =?us-ascii?Q?XyTCa5tLF4O1UHUMIt6OFuMQWQLj+BSjKBO3gDQJc6mguMDW2D2ytJTsDxOA?=
 =?us-ascii?Q?VAZZqSSBKit8jgAutr8vFco3ILe76f9RRKKYoXxxPK5Olydc1s9/Rjxb3xuM?=
 =?us-ascii?Q?Cl4PQ/zXs7wmgn2iIGcD0NGy/Aep5UbMazomZGZ3aruhFO5OvnuHJxoZTay3?=
 =?us-ascii?Q?JONd/VBp73nu9Dj5fvaw3XUNIjS7gSjnS1HQbuPMdXzf5bWuUNMgKvj571Ac?=
 =?us-ascii?Q?Qkr86cwE6N5Ru4SXq3IND2arWPRfCBWrPEgxMxZgblEhQlnV08rmIdd0EotT?=
 =?us-ascii?Q?9/HPs6THnv59jTaMEXVgK/uWnipb+7YCEJbHrEoY8iT2JdbVLN6wqcT0coxo?=
 =?us-ascii?Q?fz5lUl3b8xsoNHJpcYrFD7YaNLgOFOxgtLIJE5tUD/bUm4DALvMYgXpCBiG3?=
 =?us-ascii?Q?6k9AUHHE/vKX2T3n4MxL+oJqZrSk76DCC7vghhzjmG507z0yywM6XhNmgilC?=
 =?us-ascii?Q?ak9TrfrexxDNB7cwzstuUKITgJpSgI3ZFeqkL0q0V1gUndr2ySVfuJdcsQph?=
 =?us-ascii?Q?RIcdoQaWJhz/wQ5HT0Ts8BQUs88KUM9GVe+WQmIecgCZgfxxcBOeoff/iTwh?=
 =?us-ascii?Q?VOQHTJ1aiL/AxWsl8pj95u9L0vSu5hDCt2pTK9CYKXvEpgkLagHMJ1Mv/9gd?=
 =?us-ascii?Q?NoI1IZWNFQPc8sJzwF3gSNfM4YA3L3Sb+/LhXz7OipcW9efD8ySf6KICwnFT?=
 =?us-ascii?Q?HooDzOC0KwRnSa1s2iv7T9IdioRqex02GjaA+fUVxfhNGMmGoL2ELxHNtztY?=
 =?us-ascii?Q?GuHk+0isbEdrBSoBlPBZTHItnbv2qdFE8AbrawL831xG8DoCYQV2UfhyakIf?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0Jymo5l6v7sJAJnQ7mCnkTdtPLdvOzDH84egmKZJR3OZoSBANp18KabH86y/y3/AUQxiT2bvtR2WJRe/sxa4fisqKYAmuCd08ebIwDzEyjSXOh87j1scC5xQm0xqIn+vjM3j4qSYEMZwHRF9d74Z7uiHGxhPWtQkdM46FmObov+eY9WM2GaHeUfDvFrq8Oot+RwUIuMCT//lYAheBpNqa0nKQ9KUAzlACYM2Y5woKB21Z7zA+40qCIwox0WM3E9T4XkBvQeeu3rBBN8iBWEdwhSLuQK910YWVO1K+u5vXbTn6drvhV8PeuuMoPkDWCk4L3oLduy0Q/HGmVNRVchzLIHZq8XaMbRxQhWzAZlWhYo3JwNqqH7Xb81xkNIBAbpvThLHFFOIiQ8fg+6IxHJIe1FPlp+LWftRmTtJNrK1e1q4VpV7pqi3gGdi+zjO1Mexp5pmUNnXlQb3Tk/ihP1k+PftnVXW5KSZI94QODrZX3SLA/0HhQ6zAmQi/OagDG9uhxyW0cb2pT4+MOd4bY7tsohm6XO361rTBNoM/khNlEckwvzY+GyIWgFx/wWcekfDuaqce8ceYkVaD/pr0k6HTePs+ERTJor1pzxOfunoVT+dKke+tLNZ6amCQpWbjGAQ6vyrN3+L88fcZNna4Dhg2dNebBBrr+Ste6BZ6cRl4GKiMDntHc5PRJUxH9vpPCDI8O1IvN9o4p+ox86IUcMktUTzg79wGN3k8kBLjJVDmylutERGA2vnXXUaGa9XppvxsDMWHNf1vYGYbqfcrquCdotMOA2n+HRb8ZWgfjadOv6DxV3ikvjclR8X8MGZIk9S9rt/eTOYn/6jh4NucuHsloptHe/JY7kRO5VhXszkan0tPBTrTnSJ/jldmpcPJH4yGO5k5KeybDMzsJKtwWvpOA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025e2f9e-1f2c-478b-cd3c-08db0a300065
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:55:48.6780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0n3sMb8kC+qqZt7E43adfnUeMDFFgNLd74BmZxrkh3wT9d8v+wceZx4WnX1NkFuGSc2gp1365MHtNSkFz1LtjGaHskT+oJ2LuBIQkHKgRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_10,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=463 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080202
X-Proofpoint-GUID: 7EnLOJsrUoVkjRqd5OM41V03vtfeE4eU
X-Proofpoint-ORIG-GUID: 7EnLOJsrUoVkjRqd5OM41V03vtfeE4eU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

>> We can ask our suppliers politely to not claim FUA support in future
>> devices. However we still need patch 1/2 for existing UFS devices.
>
> Please add quirks for the actually affected devices, and do not
> block fua for an entire transport.

Yeah, I agree. Let's not make assumptions about implementation
deficiencies based on transport. If there are specific devices that
perform better with SYNCHRONIZE CACHE, then we should quirk them.

-- 
Martin K. Petersen	Oracle Linux Engineering
