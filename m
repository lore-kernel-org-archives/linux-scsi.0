Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6DAC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DEDA610FC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbhDPCwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbhDPCwM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oSD9047681;
        Fri, 16 Apr 2021 02:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=49CwQMIQBEbvVUfBQo6YVlBoVIdRMtS1SqFQUppY7dI=;
 b=CGKjtL9K+/+jzYJuXD9/dpYobPwEZAD0WMDzW/sxh4Z+eDEqLCPqnLTjIj8E+lekQuDQ
 1Hd8BquyYykJs7OjuRPPX+6YQbmedQtX24K7HMj2BXLNWZQVi5C+baM1QGTs4FDB2J7W
 8revH8ibMs7lDCF6jrkQ+2AI+lrVcE1mAovz+rqHDHNvENxhsMkX8iZJ3/UeHjKNssKy
 UT1k9iRO3KxXooEHFfVp8jMAfShnJQ7dvqDLPQhAT2txEGWxZc2O/AOSkg714e+p3L4d
 UDr8JGpkCXjuE/blNuZoA56K9OC8DL7JUEFJHVsgmqAdvZprc7VCdAejDP1uTvIHy0oh YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oWJS160451;
        Fri, 16 Apr 2021 02:51:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 37uny1xe80-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6lqhG2CY5lPX/uBwjDL+ud3I+n4TuKIVjl9vm3opcbHee/Apa34xTaJkKgf2bZaQMtwdzVue4NyHSOMmht444GRuBgS4/bocLIpCjyByUKwMc/t1+ka1rJVl7e68S7KrlDfmn+XR7stZ2n5pD8QqRY/pbxv6w2v9e1mpsEdKGb1c73GY8POfr6ICZzeU8o349TEpzc0LkgaMhMUqJIf8ZM0htHDtx1R2Oha8ExauIW715zkkQ38aOX0qwwJlTYBol7bXkc+28LUWDzBmCWwnC/eBrAftWYRiAYYn3T2XM/l11PjWCPc3xwq/Ss4eOLzmu/C+7pk3/dP8e/5kvXVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49CwQMIQBEbvVUfBQo6YVlBoVIdRMtS1SqFQUppY7dI=;
 b=Q729a1YI/GvAqQ3wz+Kidpd2yPgE1TeDYtRxlPUvquiZVb9muqIgUFq6QVQZxXBfNEsh8s/K7KjW6g35cybesghGUdqRBEjfoTyTAzoko/XPZBkULgz5cRT/4x/JwAT8eoxD4pZydpYBW+lRKV93g4WObLDCLc2fghEoyctEq8UtoELk+wIlgIaUx3sPfoI2wFVjd9hkedolcGPIrg3ggePUg1jpcisIwO8xY1X2ijeS6dIVcfbfVw3UqcuZSEZoF+LUFYmygq0WpX39DFTmCDBHIHBX5v1IT4Lq/m7Xdt+zWpZXZ8jxO/DudVi36ttjjaLAJIeaXURmjHlqiMlp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49CwQMIQBEbvVUfBQo6YVlBoVIdRMtS1SqFQUppY7dI=;
 b=ZZVSAsuSQ6jxQ53RjqjyuNOTdz+caHoIAb1TLZTyxTxwPMFM9DcYZUjatrvevogcRiKbYl9x7wUiuzR5Vr8HIrETe5OJjH10kIe89ymJGUW+FW3eaTeKAm2IBOPArEp9obBeGdC7z5ISnk9hAZeYG88zvR0Hr6lvUSr3JKkIUiU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "MPT-FusionLinux . pdl" <MPT-FusionLinux.pdl@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] scsi: mptfusion: Clear the warnings indicating that the variable is not used
Date:   Thu, 15 Apr 2021 22:51:20 -0400
Message-Id: <161853823946.16006.13919455938365537623.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210408061851.3089-1-thunder.leizhen@huawei.com>
References: <20210408061851.3089-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ba18cb7-6a39-4c8d-d3ef-08d900829076
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54662C0B6BDF834C63F450278E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0IVEQaxm2Dz138eRjfh6/NzrD7nPlsmXt3u/lzWO8UqeLQ3WkKp4uKjeUhi3nQhS/8nYFYCSQUxQuMV7M7PaUdZBOsW8+nbHP1gECPCEr1/6n8MutTva4sHYuVOQWxKH42BwS3xKPgVi8S0TZxoe46s1RQc/Zo0dD426MN0HMCQ65OWWtv9kBECUPq8VbZylSXZjDOBnmcDQbeyENbJb4pUOrcp+dMDBP05QDTnuARmwBrewxtKRUAdPXnIGWIV7c1PXi8cl1Y62w1D1YO1VwawUq9u0vvDmN2DbKbg5hbk/T7wj9871vVgwzraLrbOMoyABSbfWSSDquqrrvec31kwFBqlWXCDNkwB8ZYh2Dt1/xgd3lhj6OGDSR1k+kXbcUbkVTFRflomreNZX8mBfmbe8BZTAH28RucF0KXlyN3mYdEM9tStcdQBt5s2xO2EGptlr3B6v0gKQ9KrIrTPZi1Bw2yozangB7djeiiaSRyOeulzGG+kKd2RlW7KUTBIdBke+9XdOM/kQyA4PZFvKGAAU2MYN1Eq7+7g0+tgNs5Zvcv9/+Lx6jlLMxQMfvOQw+7jb9S209pv/2P5G1j6daEsQzQx+dYsN2/41W6W9GHcMivNx2UnfKFN1QUSJBQx+P2+a5zOD1eokvRJir1MsWYvQLqQUmWCbjEPrWjIa96Q6BAcUQBWNU3CAyWCVg1mUhTMDDjE3cZZ5uKXuJCuogHg3amjzXJ4lAWL/0Xk4680=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(107886003)(316002)(83380400001)(66476007)(186003)(110136005)(16526019)(66946007)(66556008)(8936002)(38100700002)(8676002)(86362001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d204V1dvNFd2ZmRudW93d2FJNUU3aEU1a1puR1d6bWsvNDMrMWl1dkZuRXll?=
 =?utf-8?B?Y2NyNmU4dVhVZWxVcW1udTM5ckRWQXFUanVDTzc2RUtRYmxBcXVLRExPaTdV?=
 =?utf-8?B?R2xncXlVallzc0RzblJjMEk5UGtkeHYvbEJVeS9iY2E1M0gwRFpKVlZra25m?=
 =?utf-8?B?NEJnNTVBSVMxY0xzaXh0K1hFanhMck1iSFJySS9ZRWpGVEFuenpHcy9zbkdV?=
 =?utf-8?B?ZGI5aVh0c1ROTjNoRitZV3UxbUVacnZDeE9EbVduN2NIRFJBRjg3Y09YczBD?=
 =?utf-8?B?blRkVVJVL04vK2l6YzgyUi9nSU5xS2Q0S2tlTWFtSlpXZjZMM0FjZ3piVzZV?=
 =?utf-8?B?WFQzTk13cTZ0NXhRUWVtc3hRWlNCOUNNTzFNOFRCVnlGR3RMRnVpSGdLMmlQ?=
 =?utf-8?B?KzgvT3MxSi9Hdmo4aEVuZVE3WkxjdUJ0WE8zQWI5SmxReWhSNHdkaE9xYklK?=
 =?utf-8?B?c1dhMll1WmI3c2s4bGUzbDRwOHF2d3ZsaTRvSmVVelFMMTh0QWhja2dnWEI2?=
 =?utf-8?B?WFdGd240dU80UnVScVF1MjZqOUFES3A0eVZpb0hSa0ZjckhkcWdqNUNuemJp?=
 =?utf-8?B?dlRtUzIzTUVKMjkwVlV1MkYzdzd5UldrYlhRUGZBZmVqd2QxSDBmNlRvZWp6?=
 =?utf-8?B?RWtyYWtGUUxCTjhrM0dvRWtkdUNqa3NKQ3RMVm9TaUpkYUpWT3FBUTdGeE1G?=
 =?utf-8?B?V0tHOTloMXZ5NVFOZCs4d25IYlRhNkJ2bzBtSWVJeFJiVUgzWHdmVEdneFNk?=
 =?utf-8?B?TWZteURFMzZxYVRVdDdNb2NpUDFhKzNMV1orZGRVRk5OS2VBUDJobWdpSFdr?=
 =?utf-8?B?a041cUZiYi9BcDNXRWtweTZNemZHaFZWTGMvRStnRDFHdFdFR09Hc0pLc3hJ?=
 =?utf-8?B?U1IzYWpTcXA4ak5lUFJSN0V4b2g5VnpYT3JBcUMrNmZnYTU1bFJuVEpYUjhD?=
 =?utf-8?B?UkFGVENXKzF2VFEyNXc2Mk85UE9NTXM4M09JbjZpT3hJNlA0Qm9FY1hkeXIw?=
 =?utf-8?B?TE5MSkd1aWsxS3AyZU1QdUdHMnkyTWVyOVljZGJyRkhqMlZZaGFYYklCWnd5?=
 =?utf-8?B?VFNmS2Z5dHhlQmg3UGZXVkF2cS9pVU1GbnAvd1dERXFaSUJMbExCODZPQi9S?=
 =?utf-8?B?TzJ4eWZUZ1AzMEFkcHR4TXo5YkZRWnhweDJQQzNEcUJpeklrTlNSQ25XdCs5?=
 =?utf-8?B?WmRHKzZWMytUVlpCRlYvQitZM09kTWZvVllqZ21MRFNKaEF2MnhQTU9HV0lN?=
 =?utf-8?B?ZVNFdzFYWTU2bGFsUk9qU2VxTnRMYkFha3lnUEhXSDhZMU4yMzZUV0h2VXhT?=
 =?utf-8?B?N1Q5RExhN0hoMmV6b2hBY2xHdmMxSXVHdjBDRkJrZUtVaFFyL2xZeTB0SWVh?=
 =?utf-8?B?NHl2dm5GL3NmQjV1Z0N2R1Y3ZFN5Ry9Hazh2b1ZTL3Y2WGNnbTAwOGJWNGRj?=
 =?utf-8?B?dnRpek42V1QzMUVhRXZ2YytyZ05iV3g1S0hjT1UvUWFLdDhkQW9SOVM4cVR6?=
 =?utf-8?B?L1lRMytCUGw0bnlvNkEwNXZmY3pWWVJkU2NkakUvbTZtZmFObXlZYzdKdmFu?=
 =?utf-8?B?b2pzNlhrRStVMlJCcS9IS1p5MmJTWEJBUU1KaUVjcXhjOHJTaUlWZnY1Yzhy?=
 =?utf-8?B?SDExd0NvZ0swaFVwMXNnMG1HVzgvMks3aVBpMmFVSUpMRXlNRmlxb3lTc3ZJ?=
 =?utf-8?B?b0NVTklBVDlyRXlEMGhQOUxOR2RZNE0zdkhtUGJXcXFHY0JGQWNDRkZ4bFV0?=
 =?utf-8?Q?C6sWEzNxEV6Umldg8I8wH6Trbsbd3eulQMi/qE7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba18cb7-6a39-4c8d-d3ef-08d900829076
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:42.0733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIKT9Uljv43yi/AQ36ihLcTnAY7n8YJdSw75ObPDcwNXVfH0Y8ofvi0P+RVYqJpCov7tdnBmHRqcpXz7QOnLDbrap2pyHX8Y4i6k77g6CKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
X-Proofpoint-GUID: OBlrae7d6Wd0eHG8SyGAmZsgJWQ9dzqC
X-Proofpoint-ORIG-GUID: OBlrae7d6Wd0eHG8SyGAmZsgJWQ9dzqC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 8 Apr 2021 14:18:48 +0800, Zhen Lei wrote:

> Fix below warnings:
> drivers/message/fusion/mptctl.c: In function ‘mptctl_do_taskmgmt’:
> drivers/message/fusion/mptctl.c:324:17: warning: variable ‘time_count’ set but not used [-Wunused-but-set-variable]
>   324 |  unsigned long  time_count;
>       |                 ^~~~~~~~~~
> drivers/message/fusion/mptctl.c: In function ‘mptctl_gettargetinfo’:
> drivers/message/fusion/mptctl.c:1372:7: warning: variable ‘port’ set but not used [-Wunused-but-set-variable]
>  1372 |  u8   port;
>       |       ^~~~
> drivers/message/fusion/mptctl.c: In function ‘mptctl_hp_hostinfo’:
> drivers/message/fusion/mptctl.c:2337:8: warning: variable ‘retval’ set but not used [-Wunused-but-set-variable]
>  2337 |  int   retval;
>       |        ^~~~~~
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/3] scsi: mptfusion: Remove unused local variable 'time_count'
      https://git.kernel.org/mkp/scsi/c/039cf3816648
[2/3] scsi: mptfusion: Remove unused local variable 'port'
      https://git.kernel.org/mkp/scsi/c/30264737bd95

-- 
Martin K. Petersen	Oracle Linux Engineering
