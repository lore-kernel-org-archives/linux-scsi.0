Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4210C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E9D42389A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbhAUD4X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:56:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49392 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbhAUDfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:35:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3WFG3195855;
        Thu, 21 Jan 2021 03:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hsy0g1JoiS7k7hDl+NfyeUwbOZvbfMlTfKuGvfZpK/k=;
 b=P+Z57JK3hFKdloX2gTm442F+05Ya0jxVKikSzO8yfu5uZW/LVc54ofceXJ1m1zjgatE2
 1mC+bRkPwTsSst8Q0rx20HV9qLsurJc9fB+dihaV0TJMcR9s1wvqWGMVkym2dm/0bccn
 J3Hhomq1QWzy/UCgj+FFXKJML0cuCCXLm8dVbOJwCVji4onWReTGO/1ISTBn/rd5Z5dt
 cejZUhoAbrRa5zwfdYA8jDDC9oSHXyIPE6vTPFF+zKU7vhBHjfrbYPiV3ayCLIXk8o3O
 hDLwVrUbOvPkQVREhBWEyogPUXJYPGIZBpV4PqwnGEBU1PgAukm7Zv6SKuXpKiXWfvo6 qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qmwcmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:34:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3UgA3161448;
        Thu, 21 Jan 2021 03:34:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3668qwag1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4y/iQhhq4nsX+X3kdZ0Cv78P8LWCEz+4T8Hd6tKyXbxbnQQpLL/aJYhJiuusZHp9KtF6RlY0z9+zD+zNrKFtyFL+5cl9qh6ft2Kzl+vn79I+ebeSuVlVzeffW3c61oRobiopzZGHjUVzJo8Xtq185SMQ+2vlQCOIVmxSFnUQPazpEDoTe/I7Uvf7spciXdFtKZHePv/c0IZxHx+6UAuZaSJ2ZcyvZd0pYYYaRNlBegRARKEYlUwQTx/7G1wxQsYXs/yvvpNf+hyLipsONDmFEOVpFgUI4LO6bPK33Zr0Bpyi3JgF3YIZwmm03KNjffOXfQXdL3aO2MfIb1bA6QJDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsy0g1JoiS7k7hDl+NfyeUwbOZvbfMlTfKuGvfZpK/k=;
 b=Ie9j5wxiUxtjV0OIVhRF32WdWJ601PNUM1N6tUF/MBPM9bgMkbvkPHD1Hr9PxpfwFw5Q+pM227BhveQE3wmiOVI7w/z1jvVN1Y77CMf69kPi8SBkrAx59VbueZMDA91GzCehbjmEnCtNWR3icbSamPV77jtqTzrWDq/Y69KIJoyX3av+V/WPmt2HQsslXZX4IbAURcn9B4rbQiHyLlXuhOXRiJl3wjlYE+/oSvtdSFh1dP7hf5kjDYI7eevoUeLercWW3MMnWGtdly9xPxNzQ63pT0JXJK18opOITW8BfG03audaECzwCH4yeVewoT0gOPNgSmNsoutxu8FheVLhhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsy0g1JoiS7k7hDl+NfyeUwbOZvbfMlTfKuGvfZpK/k=;
 b=RRnLC4O9bO/ng3yoj0bA/Wj8YiQnt+qhH4RIYVsSfYot97By0x2dv3oWzk8V9+SlmAF1KH7pSPj2ns/16VutCXJ6Js+N2yCMIC1CxGVHmEMRPc5i68Zw16JDMlnhvfRaIBm/cdaLOxt0MsgigfMG+AVPdxd5Xx7klHynB89t/lI=
Authentication-Results: android.com; dkim=none (message not signed)
 header.d=none;android.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4679.namprd10.prod.outlook.com (2603:10b6:510:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 03:34:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 03:34:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kernel-team@android.com, linux-scsi@vger.kernel.org,
        rnayak@codeaurora.org, hongwus@codeaurora.org, salyzyn@google.com,
        Can Guo <cang@codeaurora.org>, saravanak@google.com,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 0/2] Synchronize user layer access with system PM ops and error handling
Date:   Wed, 20 Jan 2021 22:34:38 -0500
Message-Id: <161119996964.1307.5956597823766582436.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1610594010-7254-1-git-send-email-cang@codeaurora.org>
References: <1610594010-7254-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:610:58::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR20CA0030.namprd20.prod.outlook.com (2603:10b6:610:58::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 03:34:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaaaffe1-910f-4fd4-ac58-08d8bdbd8051
X-MS-TrafficTypeDiagnostic: PH0PR10MB4679:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4679B1C19DD359DB32E0837F8EA19@PH0PR10MB4679.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCkyufY6nCO0rbYy6qMVTL+ggy3pJ3DNj8cbSQdJ89gUlOYSLGmLPoqlr0y1vlPZVeaqHDBuvEFdGZK48GcqvyPw75Nw0PA/QYQqcR9UkY6zAO8ClAblh46Zr/CPtHWkD6q2XGvDHaS/HobwulrWqf/Voh7lGgoAv/cAfcIfGVN5rqbTpFEMlAjpHICoDduJdQHWMgrztMpBXhBb0clH5T+bJiMh9ZCPy28R3+l5t2/T1sCGOGW1MZ/3ND7k++oQGFsASDXf1+swhw57cF36bokn/ZBdaW6V9/zt855utm1aRF9V9Hg3FQBqDFyVJBDZILT+PRJjvC0IOZozQXaW+C3iRsXRn8TJNE2Krm7rpgAlytkYSL/hMDoNfDVIpNZWuXi6Qi7qQIUnHks8gmCiyM5WmiwvC+UIxhAmlM5rCGgADcrttmfgjK5AE2oIjcqFXfOZnQfKU3yN7tvku64I0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(966005)(2616005)(186003)(83380400001)(4744005)(16526019)(956004)(36756003)(8936002)(2906002)(7696005)(52116002)(5660300002)(6486002)(6666004)(66476007)(66556008)(107886003)(316002)(66946007)(103116003)(26005)(4326008)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QjJ0b2hudHlkbko2eFcrVWM0cUIvOTBkMWRPaTVzOU12RWFWL1dnOGhEaVVj?=
 =?utf-8?B?K05SZUduOEJEWjlHc2txS3N2ZkIrTExwTjFLYjlsYlVaVC9IN0hzT1k5WTJ4?=
 =?utf-8?B?WTg3dllhWGNFb3lTOGkvejE4QXQ0NWhKeDN2QVIyWnlYVEo0SVVGQm5NalVu?=
 =?utf-8?B?Z3N6aCtjdkx0VTh1KzlvNDB4N2c1Y1NUWEp3OHh5WnMxZ3N2WDUxYURickJu?=
 =?utf-8?B?bEl5aTcwNGkxNUNpcjhtZnZITE1JQ214a05xcjN0Qis5dkFmdXh4a1RieHM2?=
 =?utf-8?B?dkl0UDYvOHQzNHRqYUY3Y3ZkalIxZEpyVDBDblNMN2hVYTFORUdtSDl0UUZM?=
 =?utf-8?B?bHpKSDh5RnE2NzliTTl0Nk95Y3dFTGFKb3BHWG41bGJvK1VMWjd1ZWFHRHR0?=
 =?utf-8?B?dWRyL1RnT29taE9zcUhIaTlycHNtSU5RZ2lwTjkvd3lDNEpDeXZ1V3V1cW1B?=
 =?utf-8?B?c05iYW1FeDlKNGJNZTFPVlh0ZEI0YitFcVV1SXk1K0plSlBJRXUvNUo2bWlD?=
 =?utf-8?B?c1FKRE5la2FPR0Jmd0Q3OEQrbFUwTWJURXg3SGpWeE9iSFl1WWNEb0F5eGla?=
 =?utf-8?B?a3NkSEd0bDYrSjBZNXp3T0M0azN0Tkp1V2gvcDhQZkRrYkR2aHVWYWxGZ1Jh?=
 =?utf-8?B?M2NWVjhBVjYwdEVGVGpVTXBzR1U4QU8rSDlCMm9rUUQzRU5JMjdTWkRCMTEy?=
 =?utf-8?B?eWVLZlNYb3VpWXhnb0FtdjNZL1l3cng5VmdGcVR0dDBuMUI2akhvWXpSYTJU?=
 =?utf-8?B?b0kxM3htVFBXWCt1alhnbjNJL0tUNFEzTFVpdjhXQ2x6cjB4NVBxNXh1VVNW?=
 =?utf-8?B?YlN3YVZIdmlQRktjRDJscmhtYW9Ea1dMaEVKblVmMU85bUhGQ0xJV3hsZGVK?=
 =?utf-8?B?S0lSNG00d2t1bFI5dGhSYVAxdldOQlIrMWJVa1ppQlZrbE5wQjdYS29aaXlv?=
 =?utf-8?B?VHFwNm1OanMwQTNURkxYMENtcTlUYWVyYktiTkx4S3pJSTVCVEhoR0swNCtJ?=
 =?utf-8?B?enFhMU1rdnUwWFZ3UWJUa1p0MFBsUHllOWpadXlsV1hmTmsrOVBJdTd1dWlX?=
 =?utf-8?B?dWxFN1dQQ21EUk5UTUkxdkpmZ0V1NGV4NFlleVpKZlY1MkptcFlPcWRySVFz?=
 =?utf-8?B?SWd2dzJSNGh2RkY1TXVncFlEdXMxMkxPcG90WnFIVStMQWZyVzJWQjRvamRI?=
 =?utf-8?B?MVloMVh3ejYrOWhXZDhhUUxnbmVUendrYllCS3ZGc2NVV0FUaEtrb21mZEFH?=
 =?utf-8?B?STYzSjJYc1IycG5Ha3cwTk9zMTJma2dyNmlsUlpwNGNlV3VBQnlHbXBnS1dK?=
 =?utf-8?Q?y3iWckIRskce8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaaaffe1-910f-4fd4-ac58-08d8bdbd8051
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:34:47.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+8l8T+0yWQ+m2qJ2xG26Ur89jvm9d2IDfAjx2yp6kB+vgcVXoLfwcxjj0aJUEtBlcn4Dq6urJtoXMXaXdbuIbp1+t8Dgb8xH5EGbYn9Ot4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4679
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=898 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Jan 2021 19:13:26 -0800, Can Guo wrote:

> This series contains two changes and it is based on 5.11/scsi-queue
> The 1st change is just a minor fix.
> The 2nd change is to synchronize user layer access through UFS sysfs nodes, so that system PM ops (suspend, resume and shutdown), error handling and async probe won't be disturbed by user layer access. The protection is only added to some sysfs nodes, not all of them.
> 
> Change since v4:
> - Incoroporate Adrian's comment - renamed ufshcd_is_sysfs_allowed() as ufshcd_is_user_access_allowed()
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/2] scsi: ufs: Fix a possible NULL pointer issue
      https://git.kernel.org/mkp/scsi/c/fb7afe24ba1b
[2/2] scsi: ufs: Protect PM ops and err_handler from user access through sysfs
      https://git.kernel.org/mkp/scsi/c/9cd20d3f4736

-- 
Martin K. Petersen	Oracle Linux Engineering
