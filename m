Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0352FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4AAB23134
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAMFbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:31:35 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51016 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbhAMFbf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:31:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5NhTS122835;
        Wed, 13 Jan 2021 05:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/z9MzkHjy6CPuN8XOjE3BFouQcgX9VHmcBUnHUTK4FA=;
 b=lag08anJCUQsbY61NVtnSllAusWMrbZ6WkpFUXh273fa3uCtRzkYQNQG8fF3yqFIkOyL
 buIYTeRIo3DkRmoohAPFTZlHSjrbVwCzLutR6b5DuK0U1fAyFbQLY7weXelZVJR/kWVJ
 VhNk29+7wBOdNC5OpE6o0yxpE1UdApjyFt+JhDiV1sNSwH1WMeLWWXwWwqtPsrJwoXK4
 7w9dSBlYitEfvBejCatNYC3Ko5Gz8ol4qVXce2JrgOat3YhyUcqqOjmiWn6yBhkeMayl
 CCX71zJdX0MwITB/DUQenTjCqRjAs6X+5k8UAe129Caxe7jp/LGrtHghWzWKhkChIO8u bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 360kg1smdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:30:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5Pd7w127637;
        Wed, 13 Jan 2021 05:30:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 360ke7qs8p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nffbQe2ce9JkUDdGL506m7J8xxxEiCgX+H7sDOU+Ug9MxQpvvjYMqEF8XX5i86kIiV+KqWhnGKE+gL9Ez7aa7kl6Jb18ff/ZIyZQ2Z796KY2GXydhIUp83CiUWZ8pxRtWTB0v57QAkD01qNrWEshPA9fZKLQiiQuoSpbRS52vHHM6n0t0i6T4veehjOH5Bu2MZbTrO5eQYuW2P6IB6pggaud7TB//F07Qik5YWuciJbyJKPXNDn25v2QjLi1Xj73K7LktNc4s9pg1j2OLXiMbLm6vUe00g3j17v+TqJLbYcI8SgbfeRMmGnY0qriImk/FpdmJrmzGLo+T7WLEnVdEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z9MzkHjy6CPuN8XOjE3BFouQcgX9VHmcBUnHUTK4FA=;
 b=K34KwX877mvkU3gwpWBLmKPC87xZ/yEbS0P85VSvyXHb4+GKgAVi+B4SUtKLsz/y3g50+Ho9LxTZnqf4bdUPFO00M3fzrtH9lNGbEgYQM1IzXtEUZrSiQj5s9flj/V3hSLFYYC5LPlYFzGap0xVPclNIZ0V5jzUyZBbxN6+ZlFnMOs6fjSNdaRo8mktYq2jalnkfqyJ81xwBqd9bfDMNQqKwGpaCSeZFEnGUVtLm1Z+KshFeM46dQ8fnUdoNVex1V7315leNeb54D+ehkhFYBxd+5zwQUTKJG4n6St7TURSaXvD0j22USPcPNLTaw7HCSOA+E+kjV2D53atSoSAtjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z9MzkHjy6CPuN8XOjE3BFouQcgX9VHmcBUnHUTK4FA=;
 b=kKTNpb00uYq689TCq8SJu+GmWvPyUyDYLvixg9iyYM3gBpKoWkizIl7FJNm9vNZJvPbJHtThXUCDtDSRmwtkwry1iVTxZzOqt7B0ZPigHNnO9rPZ9aKyLA1eeJZ6X8qH6ji69fi1UR2RmPrkPnGPkGR4+AV4If/uLwVb8iMB7I4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4694.namprd10.prod.outlook.com (2603:10b6:510:3e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 05:30:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:30:29 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v3] scsi: ufs: Remove unnecessary devm_kfree
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1turl2ykz.fsf@ca-mkp.ca.oracle.com>
References: <20210112092128.19295-1-huobean@gmail.com>
Date:   Wed, 13 Jan 2021 00:30:27 -0500
In-Reply-To: <20210112092128.19295-1-huobean@gmail.com> (Bean Huo's message of
        "Tue, 12 Jan 2021 10:21:28 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0122.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0122.namprd05.prod.outlook.com (2603:10b6:a03:33d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Wed, 13 Jan 2021 05:30:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39f2d0cd-c58e-4c40-3049-08d8b784571c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB469474A7E49066DF1AFB079A8EA90@PH0PR10MB4694.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K12/WCjG/4bBzm1mtQXdr4BLfBLbBNfrP9d7/0TjVZj5KcJ+nPjN5MYMNTp1EsfTcsHLYHW5hCcDHwU7HEVxrdNcU+ikV1kQZrKhCUF+tSCcAovrW8bxBfRElYY0DZ1GDJPqhxTI1veJNw99pBbIEuai8KTGAs7+fyyBbVc+UrOShdyt+iIlMo4moYQTgoOPxxZ44pBh4R9s7MjiQ+M3xfZ2y2Df6sN+XIXuriaF9brNrFY1Nm+4o4yKiLYGUQcznAR34IJn19RwBwojdD8vmOvJMtYh/DCNKgsPKelCZ7lYMvkFx52n3zq1z1NgX1jEuqfBeY+OafMPCsqTSs854JwIokmFKuD48meTGwQz38hYbKWtuvDWFnwjElNd/Q3VrA9dZmExMwMX40CORPVKYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39850400004)(55016002)(66556008)(66476007)(316002)(66946007)(186003)(8676002)(16526019)(4326008)(86362001)(956004)(5660300002)(7696005)(6916009)(52116002)(83380400001)(8936002)(2906002)(36916002)(478600001)(7416002)(26005)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ycIWLDIitujIa2UGeo/5r/rBaVQ98j1NpLr2wTlOGjho27rm7kXry7lOAZbH?=
 =?us-ascii?Q?Xz7l45qnWnbVW72+IyUCu94WqYsbayTHBt5xqd4NnNS68TONTBT35/BlepHz?=
 =?us-ascii?Q?JAN95F1gM1LJGMNl6AwKPTpij8DDSuNyAxCbqhle0zp7aSuaDXlWUZYBMLLr?=
 =?us-ascii?Q?j6Ls9C7uAXIGJbNZ+o7kpc6x5cxUfyuM+hStvs6sU+jS13pVJxgc3cYoDGfs?=
 =?us-ascii?Q?S2dcheVtJnwbeVPwBC/6VwNffw4rUcswo2/dOtJ+mrlGqFbjxb4n8otV7epy?=
 =?us-ascii?Q?E3DOT9Ibk54iLNVekiBIPsXcUJ47lRXxdHRfLMu3+D60epJ0G5XTCkjj/7+y?=
 =?us-ascii?Q?UEJkOEvgd9h91qkPYJSn3oCj2TwEdb51FSOnLSszB7nf3U/Wcti5ZH+mo78A?=
 =?us-ascii?Q?pc0skCaowFLxKqWIrp6ooIzgBLv7c6bqJnHGRqpsLEaAC/qBZG2sDIutmPwa?=
 =?us-ascii?Q?SRCXgwgn3KJa8637VfvGlD/HgfTxwQeAzjTTgJ+WfxbuSSwDRoA6+BeGpz3k?=
 =?us-ascii?Q?WPIOAKBMETTrMwEQjDtooB+jhAm1ypVuLO+5mIsOn706bOJAOhHWURixXuL5?=
 =?us-ascii?Q?TUaPRjHFDfgYGL8rxIZL318+EF1/I43YmevuzDYdyQ2JBDyHK/HsBc05cq+v?=
 =?us-ascii?Q?Xj7xhQUxprMi+/bZzvr1LCmAb6ywYRkM5+Ke+wBTbfqsWwOS+dgPK1CDK4e8?=
 =?us-ascii?Q?GaiROuTRH4Io8oENFBvrYftVQLGz2YuC/WPK+aVhyY5tMkTCbWAbm8DLtudT?=
 =?us-ascii?Q?ZP/UpZlKOYMxrrIavkmHk5CZs7AJ7LDozDpov2NR+QSF7JBxus7cQF8rELOS?=
 =?us-ascii?Q?qWucay/VED3I2ehvVth14Dh7rFpMlvzoOdf7ycYy7tBw8dkQ0gT4oUIuY00o?=
 =?us-ascii?Q?+wjm2h7QWihazybHFx6/Qr1eOlgf8Hnfp3F0ntXDj5Ps5q2kwV02Yqg2Etgb?=
 =?us-ascii?Q?Dgs92HH687bPH1Y7MoY3YyYcxVQpLB8nU9ljBgen5PA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:30:29.6453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f2d0cd-c58e-4c40-3049-08d8b784571c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4oKbTR67nw8KSgSQJBZ4CYCS07Aie9uJM0v90wPwvhThhBM3+SXjwJ3Lk3iOvD7gcBpPxqn7L5jNwhyTCx9BIY+b6SQKcv1y7NRtt+tuxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4694
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1011 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> The memory allocated with devm_kzalloc() is freed automatically no
> need to explicitly call devm_kfree, so delete it and save some
> instruction cycles.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
