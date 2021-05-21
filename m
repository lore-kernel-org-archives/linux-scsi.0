Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F21DC4707D
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B85E6101B
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhEUUJU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 16:09:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47532 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhEUUJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 16:09:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LJxiek105637;
        Fri, 21 May 2021 20:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ny9anGUnkZ8qF5mZMhkodRx8EtbAnDtXQTV+LjzQwRc=;
 b=B1mfqAN4sZnED0qnAMrJWu8TGhOEOpQFUKfrrrZpxN/nXrtgufS6FXWDFAZoXdm/IkfC
 KbRw6cwc7Xs+j09Ka7AmH4D4qqogKXhsYAjuJPYFNNRBXotR8L0Cdfe0FOMRjhpEAJN3
 ZT63mvFJALexJRAaC+27D4pl/CNeKmVsdtDgqID3crGBb9DSGqmPAOh2r5THAiOwjphF
 xOlm5q7U4BcwBPKtpqh05Lkmi/2XQl/88DGUD3xgeaK4ha3n8uojzJ2G6Pj1RVnWUbk5
 v1XiGbrmDEaB4acDKUUhsV6oDrO9xUHWW+Mnvfxiye+EPRfg4+9c3nX025RytNsWaM4l ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38j3tbrr50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:07:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LK1YjT015669;
        Fri, 21 May 2021 20:07:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 38meej1jjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:07:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eb7lofHbpev9113+QWWTCTdREu4zIXZ8uDdVBli07u9ZdYEcnf2sGxUTcpCRJ1xe5dn2ZRc6FCqm6aDWzKeuXEOawGleK80xPzta43Sg8cUXFjp9AahMkDIci/m0cSOqMkfaHqMe0Yi1escI8hzrVSXbGmNz4Z3Vjdb9smctprwtj3bfVaetR98NmoCjNgW4bcQW6a0xRJbsymmRJGcBWQrZhrZFsWffoqe5Mlp37LDX/UmIEqeJ5bUIgCVCS4+gaOVr5O65a05MbCRZO+I9e9mx81bT2Y43kbdYZbJmaDJTxOYc6fqkzKX+r76K6fLXV1L4FDI+6KG6UJKOkpRfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny9anGUnkZ8qF5mZMhkodRx8EtbAnDtXQTV+LjzQwRc=;
 b=CzUAIS0CIG7Fecm+vuR9PLrgAD0NnRFvTA8qwXNXUGl+ey6xT8St3UNpMRn/BOCh1iS5eMXXUxbGmVOItttebhjF6rRjEQjBzt3RW0g1qFiVinmsOb0Zn2nNtvvs1idtPhAPQy4Toq2TZE1yU4bhoudih/SUwfJQlj4OKVGGXSIJGPwM6x24/ynVoV0o3Trc88xHDdqd3kQwz/59Q2TRzlET8oUm2XD8oA5RXfPrgJkh1YpDuMCSdXKYnEf7fEgfPaP58jXMPgzE8TIPjvsyGPhn35e+sJpkhevq+JOEC3cSc9oum7a2uotgPuJnYSeXsJ7yfMZ71WJTv4zLi22yRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny9anGUnkZ8qF5mZMhkodRx8EtbAnDtXQTV+LjzQwRc=;
 b=bscs3zD9tv2g3fUROX0cgtGv7Qu3KfLxCxGUYVqSkYdTfT3jAeEBkW9kGgtkOr1en6IpD13M83fk28n47djn4Lc8W5Sofo6SmoGct8YEXWHEyfiT/ymukPe7nGhRxvFMDBDhAsqEhqlahkKXpM/9hhOkyY0fyqCQQCereCMpHBU=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Fri, 21 May
 2021 20:07:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:07:39 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH] ufs-exynos: Move definitions from .h to .c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0nr4zr5.fsf@ca-mkp.ca.oracle.com>
References: <20210509213817.4348-1-bvanassche@acm.org>
Date:   Fri, 21 May 2021 16:07:35 -0400
In-Reply-To: <20210509213817.4348-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 9 May 2021 14:38:17 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0053.namprd05.prod.outlook.com
 (2603:10b6:803:41::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0053.namprd05.prod.outlook.com (2603:10b6:803:41::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Fri, 21 May 2021 20:07:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90d20d59-2275-4bbe-7600-08d91c941559
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB451863A9E3C1C0691529B5438E299@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TYyPc2B1a7hVmJcTfo4oCM3cLOjoYr+Uqqoh0xWeeadcDs2laITHmpgmHQ5C1tF2CXJUeUZZpc96ubgYcCxXJnspeTAxhymTPmjfCf+Nv6xX6P9g01cdtPdIVXXqQyB+hdXw5RwjJOtwjjy4mbaSVOvBQFeqHSy7Iefcl0RwlqLQqDK6m/0VtDhVUppG2rUyb8jK/cLedC3F2oACZHs4p+udJ0yZ4W3q71LjqqK/D2KPujwwxfyHbcLYukJacTPji9Udux/ZQJrPmkWZmWdCZ3Flg2VkU/A08uTLbfwAabZXsnqGOEgSkB0xfivy5SewMBL8OYxlAnNL/b9SQI9aVP/pbS04SX2BSWXWvQEZl60hoFeSjMKVNQwks6enyDhFkfm4gH/yCJvCIlbSLUa/OemudUhR5sXGeswZaCdn7dg0QIt1yJfWdTMl3vr0AARwBm/Yxucewh5n3DsqmIKIcl3D1/w7gDicUETgCZt5BQGTaxTWMj9HetYMsbX231WCuXwd9iSmgREF8pFKhJDDal4cc2K5SWoqoyFl3IJRJ99+SOv2bdwOkOzzWGoA5IYhoyp+p3tvMeya9XOKaG/Mhe3zxsZ5u9njs2+sTemLiGxJzllkS7UsWMoCU85qFQfW4K6/Ogt7QRbWh+a+MPYSCCdlpizxZ4TCzlGGi4jQZ8LQybq7xBC/oPA+ugyThVI1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(39860400002)(136003)(376002)(2906002)(66946007)(66476007)(66556008)(16526019)(186003)(38350700002)(4326008)(956004)(86362001)(83380400001)(6666004)(5660300002)(26005)(38100700002)(8936002)(6916009)(55016002)(316002)(54906003)(4744005)(36916002)(52116002)(7696005)(8676002)(478600001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I89Pg8fmIab3GasNZ4ePr8h4SpG/KNXTYIiI8NSkrlAf/U4LSb6OPmH6+4R+?=
 =?us-ascii?Q?TtTVORK70lsWGM3qBnGw4SQL4DKPsT8BYqS1QMnGf3Owz1DcDK9GJRxV42U4?=
 =?us-ascii?Q?gJ3l3iktUXGKT3FCoVw1GIoOPvQc4d8kNe2tPfbIkFrGL1qzIq98J2aksYe0?=
 =?us-ascii?Q?+U4LkvGFlO2MGNsGgLy4tDvVgBbgkkc8lhkUmGn2vevCjbh98bUy4Xyju0Pf?=
 =?us-ascii?Q?EZqGzKuzfmdgBe2RrrFwPNv4BDCSZpRcH1J3Jj+Y3Sm2igjQd5WwSRWzHCw6?=
 =?us-ascii?Q?znY1DKCLwSHHwU/mR2rV8JH1ceKWC3hG4WDNrLlhCUOebFU+8BzR3XfeoXLt?=
 =?us-ascii?Q?TSrXNAV3QVSBeZWQ2eDsTeo9vXvk1KNnbSKsZXpwSJiKn/UdrxlO6xDbjoib?=
 =?us-ascii?Q?bgLbFExV5BcBKcpC52tDcYm04huqCelVEULLwnlhPqIF2K1TvnBJYj7YD/Yl?=
 =?us-ascii?Q?ydzpvh0bAKPdkIomqP8Rku6wz/KQra26zJxXVDo4uMjY3udCWKz+QR5M8HO+?=
 =?us-ascii?Q?pl3IHMC689VYhu4dIRwDigObXeN03a6/MqGErgaNEAHvKXF3vJJ8h9Om6A48?=
 =?us-ascii?Q?e7pjIy+8PBusuz/UfvsmVKYxi1uYF8WgY08vIYVCnEhzUs2ckRhR3EwZr3j3?=
 =?us-ascii?Q?B34dqHtRQjmhHb4WTkJ4x1ixTBjYGsSwtt3bepyRt7NNtv4dZHGlfC1C4E83?=
 =?us-ascii?Q?wKrNyU0RJPElIcdlxTdFlm9UDdL4v8ukj5IOuYf3Cb1VtUjT54gLp4Civb9U?=
 =?us-ascii?Q?GRNEpyiBxyzITET9Nfrf4/V14hF+uqqoq8YW3h8V1XcJfQjKU123hW0gOsS4?=
 =?us-ascii?Q?TFhiS67npZ4HFDY4Kjk3kR6/mN0+o9aanC8n8ebweKH3LN9HM6NlK0+DIMZz?=
 =?us-ascii?Q?RW/L/KORpdEyopy7janSeMTsImrgJO0RkIdKgONwhSvuzDB0sFTEXSTJRFSG?=
 =?us-ascii?Q?0E6E2k/pntG76tUJI3Vw8eMSqMV/WosI6s9KaZ9qlKHA9BqDBpo7HgucohE1?=
 =?us-ascii?Q?kK0ETgsGb5XN7wd9PNE9BdidQb4dsaMnc0UcNpVgaPmiqYNQbxxcUZqx+oZu?=
 =?us-ascii?Q?BABjnLz2BV4UgE2YCOLiAP5cJ2G/zEx9w8ZUQT4iQngSpQ3tSNUaC1q95QT7?=
 =?us-ascii?Q?13r6DknfJohYpI5e8woi5YsvXqMAhZw/C8G7lS818FyUGXBade/+h7nkZl9m?=
 =?us-ascii?Q?5AH6bigexhPM4tQhJ6GlT3Bo9qzS5vMmKbV50b1fgy3Ub2hYpio4rn5akOON?=
 =?us-ascii?Q?tX9J1FezfBRSTb6bKia/kPBGtxL35wpzxkKH/BnRPwrsa33xjEz/EwvfkSU+?=
 =?us-ascii?Q?GZjMElrNZhKRuN23PFJ/F5Cb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d20d59-2275-4bbe-7600-08d91c941559
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:07:39.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2pPQFbQhaaBJaEa83n2Yhut7yNC7cf/UffwGe2ag+nzw56dNVhd3t5Tnfm9TM00dHUSdvbeq0a2Zd8NcYcTiOIaeH5iectMagybqt1A7Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210107
X-Proofpoint-ORIG-GUID: qj3DrZ0NnEy2TbvuZQnHsIe70F3uWpj6
X-Proofpoint-GUID: qj3DrZ0NnEy2TbvuZQnHsIe70F3uWpj6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> In the Linux kernel definitions of data structures should occur in .c
> files. Hence move the exynos7_uic_attr definition from a .h into a .c
> file. Additionally, declare exynos_ufs_drvs static. This patch fixes
> the following two sparse warnings:

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
