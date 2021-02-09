Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB66C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59D8F64EAC
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBIDQp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 22:16:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBIDOB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 22:14:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191JLTx014854;
        Tue, 9 Feb 2021 03:12:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GRqjp1e0uDqcUY0YCQdcFSIaAjKs6Jkio1nIH0X5tMc=;
 b=ffEu9IxxZSFq0mnEk26F26Brz1YYuEjp7dnW3GnGvTGNBGtC+jlRkU4F+wgiEBQ/zSZQ
 8mCz9pRPCzdQSv7JzXNakIHsowMj3QbHnAMqdyH8+4QdvSzAWBobZ9icfjG63/+6RZ1M
 T7VwKkDUPQSdHCY5e0L1MjDMTtBLLQHU7qQSVelah40grLi6Mo37I3JkWWcOrRPJAZAL
 fMTbhpNPES17kE5vPDmEprwPW/lsqSDoWA7EK8xO0wEtxj2VhD2s3nZZ/YDyNQhAsCGb
 FCguMd17PdydynBgbO3CgVzNEyaW61bHDoxaz+ZHYGqRSbndjXrQ7YveKW1diVLZK5zN Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36hjhqp3bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:12:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191LB9i196304;
        Tue, 9 Feb 2021 03:12:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 36j51vfenf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:12:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvKYCFwSZGHylx7lDvgKjk4I6s33UYkoeraD0ZefrZ49C77FbmND0RNzxz0lvzZ0JZ8h8XdL+ye++zA3xYKmGlAXODKzFJSqplG9efFJQOw4vMSf+S/JFldkiS/m+0YQZCKaXdLYh4Mtb4+jb9FVPYuxOEoXfEQKAfhrHL5q1dIdSR1yYkWgAgZYg9JgbFZSc+NCJ5KKtW8Ru+6uqKW94tgDQaePSGkTsYGftLRVyAd8kAIpbcsu2dyHolEvOwWG3pRREIFo5tdpRcOrWigsOV6nK8HtKtltW76dcmjb25C+IU8u46PLHIzjmVcXewia1LizPOvai0MqPfwolMBbYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRqjp1e0uDqcUY0YCQdcFSIaAjKs6Jkio1nIH0X5tMc=;
 b=WkEiFegc1HMrE3wnPwbY4dFIy2D5FdJmq+nwhoZ6Q78bRXafkOc1vYpDVxSNUMbxZ9/AwSKbKaOB5wT9Gkg/WIqbPJ2EhGKYaT7QButCrc/PVeKKAFF1K0o51uFJCiXR2B9tJW5rL9pp60gkvazghqLEMIdsUqbjxjhrpL/YffeafkKw5RmU93r/VH6wC/lIivD4oXdsFb5s89tCQ1cluhHGL2SK2G8FVXWdZ9XV92S3jhp0Xak4P/YAbRCeTzg7qwOJi0tHNGVPuhczq1DwasX/BZPXGCpeW+0JtaFJ0dXLwHh0M4aM3POHs1RvTSrH2r+JBE/gCnTzlKwhqdvb9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRqjp1e0uDqcUY0YCQdcFSIaAjKs6Jkio1nIH0X5tMc=;
 b=NKpNYk+emPnM9I+kFYthuuLPq7ZapwHaYYkJeV6WZJyWXn9AS5hbWfH8T3030VBgyxib9EKbkYaSsRV/G7/2ecy6Edyuzuv5fBYvxuGlqvjMvKlWwlIKLfqoZvh3weUwLirr0mXcgJ5UGBg/Sbs8d7WMyPQFTYwC0cSrqPxyu1Y=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4630.namprd10.prod.outlook.com (2603:10b6:510:33::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Tue, 9 Feb
 2021 03:12:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 03:12:19 +0000
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: convert sysfs sprintf/snprintf family to
 sysfs_emit
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kimrl3i.fsf@ca-mkp.ca.oracle.com>
References: <1612337990-88873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Date:   Mon, 08 Feb 2021 22:12:17 -0500
In-Reply-To: <1612337990-88873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
        (Jiapeng Chong's message of "Wed, 3 Feb 2021 15:39:50 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:217::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR04CA0011.namprd04.prod.outlook.com (2603:10b6:a03:217::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 03:12:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 269b13ee-7e98-405c-dfca-08d8cca882f0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46303A540974826FBCE7DCDC8E8E9@PH0PR10MB4630.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ibs1ylfpezZxh0mF+nTA02xL5qbBu09rctD7ikIm7A5peTQXamWG/qO2OITAvP/z+G6Vq0MoRtVV9qhYke3QaPZZHgL7X4ggUlJORVE8551VB23uueMfrYPNtq8YZ5A0S4+IIH8KqcFy0VWGdOcqckyinZ6nMWpGO7OJl+iBFAsTokVRSBX+KVorKUDFqMZzw99vd8dGkLVGgVIysAdzw0RCu05SQpO1FCDXE/jQbsAqS5TG3uNy/sVXZAfiakUS2SWZCnnX/jFqvsxybDIG0An1dgUDpZ7Q0rvdawo3yCHR7t01cfYMWuYq8Pqc6j4O7qVvfGu/QRtfqVvvsdDZ5EVue7mCZw4h/nUIkxelOH83mzBTzfaaTOxWgcZgtvWUuzr0KgZeu0IOlaDPkR5pA1uuH4aYtrc3vTKTJPYVaa0el8aCezg8VF7itvQ/A6JX2szYF3gxi+xD2sv8XOrs3pafjuPIOvIIIFlGI2qnsQj0FYqnU3zGzV9bXe2fX/aZItKbaXE8iXLvhKltGw9m3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(346002)(376002)(136003)(8936002)(26005)(186003)(4326008)(6916009)(16526019)(4744005)(86362001)(956004)(66946007)(5660300002)(36916002)(7696005)(478600001)(52116002)(8676002)(2906002)(55016002)(316002)(66476007)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?C8sD/bHE7HqangZ0uRE8U235r2EOW8OxS+DZwVAImBmQQa1jZ1MTEt+tctqP?=
 =?us-ascii?Q?OmimtJjVeyruMx8SmGZz7Lk1dXBoVVVpyYKQMwEWN8LobZyfkEVlc1KRZy7W?=
 =?us-ascii?Q?2/xIxVY5oYQY1mU7uJBwZMP/1KzEo9x0ErnMxMVTZ/G6nCyIwY94XBPGx+wO?=
 =?us-ascii?Q?qNuN6NKRQihY7MeL7Zmdv1zvh0t/IYrLiuVq4uB9JrZn7GjzolLxwOGH9lc8?=
 =?us-ascii?Q?yBjuwv37rEs590OdNbR/FoU9Qj2zF2wIRUuYeOkTnWAeL1uCsd8IdgJq9SD1?=
 =?us-ascii?Q?W6gE+I286+WCys8RAfR+31MTwFdy/CgwNXZZJedBbHCma+vbVedaE61SpuCb?=
 =?us-ascii?Q?K2hevAvubOEM9p3KfhB+1zl11a/WFon0xIKneuPoP1neu56lZWYNBlDTJCrv?=
 =?us-ascii?Q?q9fCMU8SdE4YgAh1cYIUL7bB2/KbAcL+0JC6OS+21mc89vjZju3y8OUN/z4U?=
 =?us-ascii?Q?s4QG7+4XsI+uM9L4kZKixVpa7vTIcbntVO+7zQ2Njk8YagpqbtZPTRAO3L03?=
 =?us-ascii?Q?rc7bE6Qgj7gSBIZLjlP/FHDuiFK80bvxo+p94nzh/b801iU1fuvyxna4evxY?=
 =?us-ascii?Q?mXSlp7hDTziIgO1eLsysWGC2eZADwdVLOK47PnQ7MbiwOLBlWQf5ZfF0BVzV?=
 =?us-ascii?Q?AxHkB1wzoAjbnoPLStvOGivqMjjWfCXvdCJQ3ag4HBTiIcnyb0qd6U8Gb6um?=
 =?us-ascii?Q?oF08dYaziIXqItCRZHPLC4vmSvH40kOnM3vnim4o/EQ7Q/mItIK9NbSXwQ4L?=
 =?us-ascii?Q?7ydbS7gZOyR6CgtuWoUC5DWJSeaaKbDsi2uwGY69OZf2f+4mSPR3Rl9lqr/z?=
 =?us-ascii?Q?JndvEXDazjqyJBhRl9KwP1LG4Mp2OIdProVmZnSf5tMFKzXXLjOutIg/1tlY?=
 =?us-ascii?Q?8rCRR0R9yzzTc+0AYJcmaheik05BsX1d+pa21rWJBkfNiLtyKwdXhsBCGuaB?=
 =?us-ascii?Q?R2pADbi86n8QGSXMI5jJBkBPr7iAZ1gaxYDUsA9lnVgNQsRh9eUMKPjKleb/?=
 =?us-ascii?Q?95mP/6zzGpgBvrb/ZdjNfGTntaOuRZ3CEF0T1ySwWVnwTAfOsFLQL09Z04ps?=
 =?us-ascii?Q?kijLuIYDiubu5jtHZt3WWyEqoPGX/GAxdBuwijSULtKVOyBhUC5JToKlLEVm?=
 =?us-ascii?Q?QFkwKlgrWoVy4GlShG3CuCZGdIbFbURmYA8Rm4THdG4JY8KCTld1zqcBKZ3Z?=
 =?us-ascii?Q?IrbWoUNNnX+IrMWt4aDKbFH9fM8ngEfGjT7eCuhzIwUFCrrAadmS7JM7iz9i?=
 =?us-ascii?Q?+/2n8yq0KEWiy4X/TbRGijGfG+KjELrzOx/D9KQR2xJyfMm6Q/pB8MzylHZP?=
 =?us-ascii?Q?zYaShkgotCak3rUrP2jD/IAO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 269b13ee-7e98-405c-dfca-08d8cca882f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 03:12:19.7884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRjWPKsYAa0tV2Zce6XWKNryTxXqYNNsbn5CRzGC5kF58gFEoZE0CDYuJ5fX1GYf6VZnXvLfspILer9h4Hlog0BExDh8i1JuYjL+d6G6FOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4630
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> Fix the following coccicheck warning:
>
> ./drivers/scsi/ufs/ufshcd.c:1838:8-16: WARNING: use scnprintf or
> sprintf.
>
> ./drivers/scsi/ufs/ufshcd.c:1815:8-16: WARNING: use scnprintf or
> sprintf.
>
> ./drivers/scsi/ufs/ufshcd.c:1525:8-16: WARNING: use scnprintf or
> sprintf.

Does not apply to 5.12/scsi-staging. Please rebase.

-- 
Martin K. Petersen	Oracle Linux Engineering
