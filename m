Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A9EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 02:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378252AbhLCC5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 21:57:20 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38322 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243536AbhLCC5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 21:57:18 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B31Ffao032257;
        Fri, 3 Dec 2021 02:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bXKc7pbpChjBThXRuxhMZHAE0kC3l4Qnn47nbrRePvw=;
 b=ovx9wBOH+IEYBuX5QW8Fxm6YOf2L99yXfz0fFyHd9hZuEWXaet+lJdJkM77hjXC4+qGG
 CWRWLZaNi2jYxNwH1N9ZDg+OHqnYoCJjPdLgaKuNGXq7Sg7GRs/uE6VH/JDkHLSTUXuv
 2hHFdswlmbBcr3j0XafKvMVMBGpBENnEdojWmhyxhKA2xH+yzGrD8/UlUG14R/IeAKdm
 qJMuce/43OtmxzAXbnJCY3K/XyP/tn5dfT8tiEi7S9RVBcJN+rB4kzkimof+dxVQuQTg
 H7Ag3yHzpNIGS7p7mQX701qQ67k9e9+cN5jx3VwDbf71Pi8Tmb7HBiPWc6pBR0rgJqz9 ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cpb70d36v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 02:53:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B32otUM169433;
        Fri, 3 Dec 2021 02:53:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 3ck9t5dcdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 02:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUxnDPGBn0PuC+J/uIg+EPzCqvO/PCbqeqsqO5pITWAxZi1WxhcrE54sTcrGzvCa43I19fQO4iweN/z85K5u16hyJuHxBaZi8FTBBea4lJG3prbicM/HPEZA33D1kGQQ8GHAlVQMvTs8MjekaJS4QWPURWk0XcsHs39jt22DPgtpTYR296pVm8sPr2ez5wfh5GlJhWRd0yZm+77rn2Dws2VQ8Q+kULdaP0LqUvzal87scKELU9VoF1YVF6UjvWu4+5F3DS8cWKsGb+aBkyg5AkAUL2oG7qxbcgcunOlHLnIAefwgkAuNNbNewRp48w08VY6E8V1YxbHs748/R3PHDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXKc7pbpChjBThXRuxhMZHAE0kC3l4Qnn47nbrRePvw=;
 b=GQabFsuBNW3MYqS/5EIsCCxXeldyv8t/b+ovffXFHt3rBV3WY6dlS71rr8dE8pcw52fmTH8ulXPm62klbIdXKRTk/vYrHYcxt6WKJTOr8/XEc8X+rYbOV9xuM2BcD8qRiJpR7SB89rZ7fJhvlBR9zlV421uxUIajXB6Iopx1CZ1cNVrwzaF16pJj0VKW7CODuY1nCHNDAJyIjhXmog4/4LSOjMCfdKHtlPa00UaFy6W7mTCQcZ7GSu+OAa0wjUtsphaOMkvr9sB9m0z5Qz0A1CrvMnpidy4/CPPlv/aH4aimzS0/yxHuRT8L4PxpeMtXAuChGF0JIwEg/4h0eIYzVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXKc7pbpChjBThXRuxhMZHAE0kC3l4Qnn47nbrRePvw=;
 b=ZeaYOmkd3gRfxRInAeL5izOGW94mVem/W+OXilII02vXPj/XRYLAAhMg2776/KHm1/KOUtTvL054nYAx7JrW/BFzxLtTkvhwvkcFgZQcsmY5JinJXuvIHsK8Et/A/5jtWN68KTbg68gmIq7fTdsrEsCdL7QYXzUuBcS7X89uPZk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 02:53:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4734.024; Fri, 3 Dec 2021
 02:53:43 +0000
To:     Manish Rangankar <mrangankar@marvell.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee6uwgbx.fsf@ca-mkp.ca.oracle.com>
References: <20211126072853.7862-1-mrangankar@marvell.com>
        <CO6PR18MB4419DA9AF111D1A9DF136A4CD8689@CO6PR18MB4419.namprd18.prod.outlook.com>
Date:   Thu, 02 Dec 2021 21:53:40 -0500
In-Reply-To: <CO6PR18MB4419DA9AF111D1A9DF136A4CD8689@CO6PR18MB4419.namprd18.prod.outlook.com>
        (Manish Rangankar's message of "Wed, 1 Dec 2021 04:22:42 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:806:121::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SN7PR04CA0071.namprd04.prod.outlook.com (2603:10b6:806:121::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Fri, 3 Dec 2021 02:53:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20d64caa-9eba-4832-9062-08d9b6081e71
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-Microsoft-Antispam-PRVS: <PH0PR10MB46773FFD967058DBAD34E9D78E6A9@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /zMde/zry+LdCaoJ6R6VK3k+JUe58RnYsFxrafFsGmNtWBvVxaFiZU4sVUk71cYTbPwoxtlQfBgHpvQnbRZoHI4y/iXldzzpPlUqSiva1OV0gHZQCx+iYTHOoAE1F7ygUa5MLJybqd1Z3gBto8PFbA5faRrftJQvPjddYOw48a1WBK0kWkDc2A8K3sVpHI9xmAYz4nAvIk4kATjp9qocd/V2hyiXU4+VnjejUz1GYlQUjwT2AgbOseFwyygW+hxJi3AxkzhFcxVEQ7doXZ+meoZneGd3Gdev2rr1BRa3x3tJGuamomnfJhCVOMH9XV7XK65BhQ9K2Hd01CWgt145+lLDEjCjJfNeM4zXmzuG4O/rx7jFoKz97McukLWKFodZ0VKF9oUJTZInWR2+Or/FhCIAAHAoIu9pMVQ5/IzKWB1yS4fEso4GFXsmYz7Do7Ai1oPUZ0vWE0ynXryl7H6DfHAsAKPJTj8uKpVXNKInwFvNi5h72R+sMIm6r1sQKz4KRWljta7Q/tUeWz/ZG6vY82vhP8slpi82RKSteb1G921vYf9nOh+RHpws0RIVppTEMnec47fHpRy9V2YYgrTl1uT1u3Wvo8GeZ5rKdVQRW3dL2UOlxWhOBcPWMwEf7BIScHynoRtLXBAOgvoBTUbFyhmfV8bF2RTzjjaj6RXG4H2zpTAmmMAuq1i0MWgNqGNNP5M5obzP1d6kVkH7i+t+Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(558084003)(8676002)(8936002)(38350700002)(2906002)(5660300002)(26005)(508600001)(4326008)(36916002)(956004)(55016003)(6916009)(7696005)(38100700002)(66946007)(54906003)(66556008)(316002)(66476007)(86362001)(186003)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JItKpQOP/WDnRR7u5FMG0xMOyBAvDaUGoRpI2jbst5QpM98rJHVTi+IdMfjG?=
 =?us-ascii?Q?t4VVAGCll9ivBImjdFNiOuplAmKydwWv+l1xy/1fpDQDbh1IqkNeAwdNiyYp?=
 =?us-ascii?Q?RxQOclkSwa9Cc98omJDy7tfY/K7bHW5zUFttliiEx7i6fagJ76HXNfApfiA4?=
 =?us-ascii?Q?J7cuFsOPB2brbp+73UX4Fkncs2G4wB7KsImffwKo4hfMLaY/DGY9/7SjBOBD?=
 =?us-ascii?Q?3LvBz3zvyYOQp4lwdvGi42xrs746bdavN0X/FW9/sIDUACHaXzuGR3fDIfQX?=
 =?us-ascii?Q?zj7+oZNpC9l9B5b9RptzqFXZgHpwm3XvwM+HsfgJw6GS8kPOq8SXOYQVTbTu?=
 =?us-ascii?Q?IrUSV4uZOjAUD6iib5mmlLQmjFUsjh+5PE3QxLeYrG7V39nE7T/w0xvQzPfX?=
 =?us-ascii?Q?jLL7CkBrMdM2xaqDpHWLRImWWGvDUDz+ioudExDgwBz9cpX1/k1hY/iSAHWF?=
 =?us-ascii?Q?7mr6lOYgafVjc3htf5Xv9VOM2xTBR9B0menjfXbej9o919leA25ZlmYCOFVY?=
 =?us-ascii?Q?RHGtDrCCZSOshHSDJHpEo8kC2WWohK3yM/IGgd/RUyA2upkTgpKbtorDHMqn?=
 =?us-ascii?Q?F2IiEQJlH/eWDsDNGFzEdl5bbsio2MrFm5wvCJ5fB0qj/bx0yR2Iq4JD4/k3?=
 =?us-ascii?Q?g7KlYKOLsJJd20sLCKHA98SydELGgHTSs4iBmLv9KcykXtTZSDsklLJJXRAt?=
 =?us-ascii?Q?xN+vF1LklT2Z+Yi5YPkPIcvCapxe1JYoPRuHkX1isP/BPW8+9RQUxP3VOC7K?=
 =?us-ascii?Q?Zn8dzfubpWBXVtKvIWVgNyn7Or0iblNISLJFfAjjGnMaCxNIjsT9T1iGs/Vz?=
 =?us-ascii?Q?2mTR0QiZGxNXHDB1Q1eEGtH8L5pnleBAE/qRYUOrMTcjZDidTa+IHSm7xma4?=
 =?us-ascii?Q?/Ws7r9AubZ12XzhBjfjV4Tjd27RwLiBIXA/kjnxgDkv/clL5qY5GvY2GHuKI?=
 =?us-ascii?Q?3ZOZTWfO00krkbPIA/slQ3jPsFxMPC41Recc72cxClW4yzBfopYSaKtGBkhE?=
 =?us-ascii?Q?fh7jEVIOqrW98vhgjlzBxZXQM64chm2hrFRvtOlCNIrKQcEOnvDR+guLjA2Y?=
 =?us-ascii?Q?anenXrFnPTRchwLh8XODY9Irf8FhCrgT9O9Pu82aQsKYEkp9OmqmunIi3FLy?=
 =?us-ascii?Q?LdqgEsauRkWmKoDSm/0+7PUROj2fSb8ethqsxymoNHaS+QzIwO/ZEhnwN6SK?=
 =?us-ascii?Q?fue7vGXWrN3HGjKD0hj2WCtHrpWsL4efV5WxKqxW2TLuqBOVdk47EAx2HNBv?=
 =?us-ascii?Q?LSv2up4E5iHtp5YdmwYqGeRl89ow2qcbeW10tyxpRHSus0ulMEM89rD0krak?=
 =?us-ascii?Q?BT0Ir7hB2dzdobEYjojYFH9Y1mDkDjGNiDu7Sd4wRROEbzV6dFhOSSsRWrab?=
 =?us-ascii?Q?1U+dYbINsNlXp/EwewNTNpen6eDZRfwtmVWgX3/6OxIQNqr5mMVowV2zxhyG?=
 =?us-ascii?Q?lm24zZ0pHG/ohKma7K6NwJo2XXGKQLSXtMpyLOf/OiHRDREj/GY5i76vM0ZY?=
 =?us-ascii?Q?9AkbwapIdgpN5GnW/QOSyplQgF/gaQXFqFg1dCsLBrKmdkJrd+CLZatNZCuV?=
 =?us-ascii?Q?S/2QDz8kNIpjdjJMDStjWCtczG9rXrTGrxhe8xYpxYlKLNtQr77Oqt2zM9Hg?=
 =?us-ascii?Q?GF5CO6dx4AtN0+LJZGJZ8spDFp7X7rFzV6zzOSHGVJVs6itC0ffB7FcqBk9w?=
 =?us-ascii?Q?oRKcDw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d64caa-9eba-4832-9062-08d9b6081e71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 02:53:43.7613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HCSoDweJKb72PH9wpchV8ZUk6dnsPXWigRbLxwJqE4VnyYwPPqUSbDDpIQFsz6IUt9ZX6/np05wb8fSVZVYhVR/nTVW14GxaTfPYQKe+pA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=939 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112030016
X-Proofpoint-ORIG-GUID: wLXsCDm6u6KVVTc-9tz8A3pjfLK3ybT-
X-Proofpoint-GUID: wLXsCDm6u6KVVTc-9tz8A3pjfLK3ybT-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Manish,

> Can you pick this one ? It's a single patch fix.

You may want to copy Mike since he was the one requesting changes to
your original patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
