Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F401C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 02:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbiDGCeV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiDGCeT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 22:34:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7331FCD25;
        Wed,  6 Apr 2022 19:32:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236Lmv0p000758;
        Thu, 7 Apr 2022 02:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BnLhyGu9C+oqJ81Esrty7oXaF0tamCIJcnxyk/UF5mU=;
 b=E7tv7ldVq8tx7sykLoLPzfBXOcUgrT3c0jTxZ8lYCYLLRMzPKBHrt7SkWzhw9jJI7zJo
 wtOgW0ykrcmv86NNyQcGhm+LMP0VrzhZSl75Ta20eLKy+/sU8fvtbaUMdiUcw4LUaZpx
 qa4rfU3bxTmlesW6tx5QGKrkZN+EgY+GfAmE16gvWSknrYFnpLbODYVxfsSbhIiY08p/
 z0dc/dz80ajqStBQS6FpXC+G8AvKsVv50v7VJwJQIbRNtK1PN05V7rNPk4JeCJMDmVVU
 ulicd4af3lY5Ipy5qcIiwrWm4uqJMx9NNhxJe2Jv3H4hd39hQCw2noyXkYS7empn9rje uA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3stgmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:32:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2372HLeo036059;
        Thu, 7 Apr 2022 02:32:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwa09w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 02:32:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlaeMJbuTMtuquBZukLz2SmRg1uu6OBZjA9ITEVcuPgjdbpfq1K5Ov8nYx0yLfU3HBIf+ewbr7XII96aUE6wGTuwMw6d4D12GOdUr+TRiwvahSUsES9QgVnFdMypZzBDwUvr4xm6zS490WDyb57gKW21SZ5CCk244k9coiEO6Nmg07L/rebjC20ZUekit7aPF/K8CEEYU6qyg3JxlvVAL5Njm63EnZD/wkW0H7xYBBO65PD25MHp/FFMlqPg/zvtH070kvD+4uor1gIBGzoUB6mpaIcSjJ+JCov0JPrYlmHOogcr4xgM+UCa1HTIykY5ZZLC6prq6uA5qKTsEKegPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnLhyGu9C+oqJ81Esrty7oXaF0tamCIJcnxyk/UF5mU=;
 b=XakD3tAJFNFKm2ZPr0t90TRJEXJQztEuycY0r/AxCMasGojyyKu/w5OYYnUuzWLFGuIIjSdGyEuqOXyvy1HZJKPR8sJ2+Uo5pLWgInF/pDdQ2gW5X/YLPFbdZ/cQP+PTKN0oqsE5YwZN1CYCgXAkI333VNiMKbA1DqJFhLE6bq512P5VjxDtYSjlm5Zkir0aR/Dzbp367PDv1XJWPwUt29YXEmowzauROwGoUBoTGYlkTkjMwjU1wqMYXjGRuxyzwY4JepCmk+gBz5mhMR1qf+RoAfjeXpryuR3TYkUnopVr3o7XgQLOh+z6LDhDbB7h8QDdV+VKyCCHUOG9cPKOoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnLhyGu9C+oqJ81Esrty7oXaF0tamCIJcnxyk/UF5mU=;
 b=T+bNt6HbqkY/kFaJxoCkvIsiEAChX3voYWyIn0syAZ35UiuS12zCjSat0BokBO1hK5+uyiSLZW+TIQVgWg2XnP6uvsGguy+IapQsQ3gGWP0E6GwaI7CYZIr5F9i1BLMtIPBevB3yr9Kyeqa7L7CgtHieYBugRjOnUKO/jHWsxaY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4266.namprd10.prod.outlook.com (2603:10b6:5:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 02:32:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 02:32:16 +0000
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Subject: Re: [PATCH V2] target: allow changing dbroot if there are no
 registered devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmltlj32.fsf@ca-mkp.ca.oracle.com>
References: <20220328103940.19977-1-mlombard@redhat.com>
Date:   Wed, 06 Apr 2022 22:32:13 -0400
In-Reply-To: <20220328103940.19977-1-mlombard@redhat.com> (Maurizio Lombardi's
        message of "Mon, 28 Mar 2022 12:39:40 +0200")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0077.namprd06.prod.outlook.com
 (2603:10b6:5:336::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49bfdec1-0492-41c4-0579-08da183ed4a7
X-MS-TrafficTypeDiagnostic: DM6PR10MB4266:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB42666622934DB155B6428B258EE69@DM6PR10MB4266.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E6dM9in7GfG8KJt345KDWvFLoRa+5jgZm52yymTnpMb63Ln3Y570r9hzss2WdaYjzO0gmk/9wqggP+HkS3RtwzBfv8R8EZD8yqVQNpzNYU8mSIuSA53DyGitc6DsTLAhD8tp+zCLCm3f5D6tJIR9kAGFrExmOt5PhbeZFJtqBHt8UASTljrIc4BJE2d3kw3sOU76O7lynRm6ZlfyU1zIJQ2lY70Cfhyga1n1IndhEd3afaW8FyXMd2ldIsQY/RzXSAFd/nfcPn1WgSl6dcHplThXmVEsOjWunWz3IMuNoiNKJkqITH8xVDx13BbJHQTGq7+d0Ult4ap1/qzr1BHA/QVWdV260mD54+TBrOEIUz6glUClmT2qcvg9EaO4BHfWFQpJpYXjGBoPUlQfJIO/f0tMOsLbVRtMyDkR8KnzO0vjRZJZjBGGi8j0gwSQCAeq/EahN9JAm4GKhSLCuHA08FHhhheGj/AHKSEe85S71ER9WQbj/4l3AOWTfsVSkxbJe4RnfNKSIQrzEyA2h1LhRU+B71WFvnF+erBLbqxEmCzDN5vOZPuPcmi8SWzmsJ3/N4locVjwepAhWc7IASlSXVuACBQD8kA0m5cG8+gCbRzcMcbcjAv7mG/thlZfl+8xrgUHSitOKEGkiL1Zmpg4hLcN4gNvnavcqQrc1V5qadVP03ig5ENy5mnIPYTAKMLmdlf64NPA0vDYuGg4vCW3SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(6486002)(4744005)(4326008)(38350700002)(66946007)(8676002)(66556008)(6512007)(66476007)(508600001)(86362001)(26005)(2906002)(186003)(5660300002)(6506007)(316002)(6666004)(52116002)(8936002)(107886003)(36916002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a0spBcYff1eoi5+gU8DhFyndVv59WZDDZoj8iAEzuKOwnDvNugxw01+f8nNd?=
 =?us-ascii?Q?enaI9r68R8hrKHXzmPLsy2HgUDwKyPo4F5Ro/HsaU3OMFvVvQ48SZ6AFKav9?=
 =?us-ascii?Q?5irW2f7XFBCO2ZcwvCMm4nQtTRmTeM4+RNHN6WtyPl6F/YZqWncyFL8YGtsj?=
 =?us-ascii?Q?rwQ1sh89lhsv/N6jfDkAHmIqvinxDXC9rkqVBjF3qfmE+oQ/loqwjvc5HllK?=
 =?us-ascii?Q?efqcAyxmAUWq3OqmylKaaLVXUIv7GJh6cI6ssk9ujj4Zy+14QKATmr/9te9X?=
 =?us-ascii?Q?6IlcqIw5HPNp9EFINYAS88PELAjDkkKWV35Mt+5Lt97K56Qadzn2Ndp2Je02?=
 =?us-ascii?Q?OWhc/J+6t5yTrHmfnWWeE59kcBn9Lf67xwlym2hwfFVkia4PxqcsfLUrFjiL?=
 =?us-ascii?Q?Zk2u18bNj8NMiAR9Jh0QqK4BBBpGBOFR8IJj+43PVH6PfBtT3jLY3uRexsNt?=
 =?us-ascii?Q?AXAjDwOFpS7ZPIRdd3h9pCGv3Cw06wgviLHEWYtGa12z5dsWgNj/mF69b7Cj?=
 =?us-ascii?Q?BHuAduoCm9V/A5zf4h6qdeIAbpSmS0Zaxjh61mGuhS3WCMOpirrxPwQh8quN?=
 =?us-ascii?Q?mE/GbUgfKutFtgRydUY/CGKaiQ6gVFlCrg0WVUuvZ80wpNcAlqFVYYNtAcKu?=
 =?us-ascii?Q?LGym94Fnw3hdgXPg1qyXUYD3h+qaGltFremWp/ef3Yk8RgfnQ14DKu10/51R?=
 =?us-ascii?Q?Teezmx4FrtOFOqVqNbivtDplBX3R9nTwSRm4IrcifMp4npk4ESQgCPZOYKbL?=
 =?us-ascii?Q?jx5LG85IQ3putvZy2KRu0pvzH4v+7//6jPGNQIm56e4oswSJ+Y49zCAmg8pg?=
 =?us-ascii?Q?vWTxb72O5BzV+l4WRrwToAWr5DFpriF+eGMZgscMZLbvt6kgey7OHgHVcvGb?=
 =?us-ascii?Q?TC5Z7pIABmW6LMrN5J3LmbOhIH9pGEobn4KAaV4HQoZRj0FZxSn2DkQQT3kU?=
 =?us-ascii?Q?IUSggoKw6fPBB3taeref6UzEhOp3ftA5uBj7sRRYoUsqlzlHpHhkqjhVAfTP?=
 =?us-ascii?Q?mEVdec6QFzYm8XYAtnqsWa6+UA1b1QxS2gMztlLLnSv1m9ppkCbElJdFIiZ2?=
 =?us-ascii?Q?DHVsuEmCH0obKlFjNg98/f6ahzjU47rf5spOB+lBrB5vChSz92s+AgL/sc5O?=
 =?us-ascii?Q?9NLQIW5xapwNymIxJRG6nSH1IbOshfGEWnSy/TkkhXRr7J6JeTdg5PNTDMV4?=
 =?us-ascii?Q?gdrioZDWItI91s4jzd0wOHt8xabtqLzHDsGc6TNDjQhzYHWX8DrBWEvG9x0G?=
 =?us-ascii?Q?7fEKP1BbS5xidKY923v8P9dRQC2Ky8VUXW/TrXS0TKXi41bCkMi1pPMlrvzK?=
 =?us-ascii?Q?ZMxQPeP+weOHNmDRgj4z6uarLRrO16iJWz3ZmcFBoGI4+0aA/uIf6lZYScpz?=
 =?us-ascii?Q?OY+HtTFwDWDBknVCLacvTo1bg7n2qi4LlCIOCVm6Br3He5J/4LWnv98P8g4Q?=
 =?us-ascii?Q?RRmvQBTDapAEkt2hb/189qI4bIMYEmU3t7eAK/ejkYhQRnywm0VuEiIFA9vd?=
 =?us-ascii?Q?FuVqcQ98Sdk/6XK1tXSWDplcHAb10Axs4szR8/xt2mSoedR8TbM69P11RsmQ?=
 =?us-ascii?Q?VnJCXOGtZ2aRPu4F+n872hWdpq+Zt0375ghl/jHAYGA7E+s69rFnCXcB5sgC?=
 =?us-ascii?Q?I4nOCIAG8zLM6VtDQOf/gZc4U+GgDalKFafDNmtyXUKegqvanddVe3MhYVNI?=
 =?us-ascii?Q?3ZtsVNomvZJ3B3OrdAj5SlfZGtJ0EAZFLuyB9AOVnzLdzR3+PwqI07rTCksm?=
 =?us-ascii?Q?O1nxSXLpVMHrJr8Y+LaphOxrwV6V3KY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49bfdec1-0492-41c4-0579-08da183ed4a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 02:32:16.2038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsLUwG6DHv53ABKjSR0rwg/Z/TAdrUNLDw5CDoETXnnJaopGUai85eX+03N4L9tm3BYSQKJ6We2mqoW2jOcVJ/yqQEsrYwzC6/CU63QFEDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4266
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=669 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070011
X-Proofpoint-ORIG-GUID: RoKneiBw9aCOjEa2jSwFHXJnqQkMHLrD
X-Proofpoint-GUID: RoKneiBw9aCOjEa2jSwFHXJnqQkMHLrD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Maurizio,

> The target driver prevents the users from changing the database root
> directory if a target module like ib_srpt has been registered, this
> makes it difficult for users to set their preferred database directory
> if the module gets loaded during the system boot.
>
> Let the users modify dbroot if there are no registered devices

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
