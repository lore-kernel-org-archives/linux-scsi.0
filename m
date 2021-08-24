Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1374CC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3C660F45
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhHXEAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 00:00:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22568 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhHXEA1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 00:00:27 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0x9uR013542;
        Tue, 24 Aug 2021 03:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=lWNu6poTKuZ/VMI/FnnR9mhOsMzdLdRCFoaK0LxGqEI=;
 b=WWrVoSmpakrxGyFF8JkYLbXR4GoTOk5o//K9LRA1t02Kiqw9HfgwjwCxmNgnevVVG1hG
 VsS+QJV4l4VWjXjK2lDJ0szX2lgCADiYJ5Jpy6KuR7Wr0z7nVWqzRqxNIu4ZbfUGCRBV
 gwjphD3R1gtA2qrB960uet6PHj4sJJ7aRob2IImgNf5+PjTLs0O+6LgWgmkn7raC4/2Y
 w0wnCAvvty7gWp7nyhFw8reuZLQob/hC7Rlj7dPP9Up1RC/FKj9PJadHoHci+fU7z1qR
 4L72gkjAkMEwpTgL1QbBTgT42SvRWjvE5K9/xz+e2X3ThXnUjmctgn8ESNoU0k9uTr89 mw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lWNu6poTKuZ/VMI/FnnR9mhOsMzdLdRCFoaK0LxGqEI=;
 b=dQfUFQzQAKBwc+kxWcIQDjal/UIH2HZdBI8reRtoZ0pNoj/QGH9EYvK6mWbmGLMHTTPD
 kxUKwZ9STtsnPMTvJjUtntdzuZTSKE8O1FW6nSrQ5RfEaXN0b6WbL0T8a5rsAdytTl/S
 H90IONFv1mqnXwPYqsBCi0xjSliiOjSY96FrUltq3rS6gm8QHdy76qq1qvL8m4QRf+eA
 4Xo6Dn9fN8wDAF54/6g/Eji9zmoUGCahzXwidQvvYRdXAJk8cFagjFwRDuwvzJktY0mk
 bGbaCli2XgYjq/pzmzdpNSuki670iOTqVUyG/lGNlqt/u3p0+0X3MhRsf4ZfGOok2ote Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akxreb2vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:59:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O3tOI7068298;
        Tue, 24 Aug 2021 03:59:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3akb8ty4d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:59:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIkegJWOqcYXDGplC8Ym//h9UgKj3/utQt0nIJKYkwE0GXe+JS3r2d+iE+JmbyyvgS1rsvGU8iERZBlU2qVX1Egh0RzRF7RfTBoqAU906akTcUG8w3zqHYXn3FDNYghht3NwPzugFG2wcIETU+sors37VJnhovko/p7ZfyRDOI9WEtoFxEMVk41PDBsJYQmEVFobIkdvo2/ykREvQgW3RoX9iENJ8n5aNCRltywYLVcTLiJb8O8Hvnagjnz5ZXSyQ6jMDhtciudQxEKuZR8E2MrGrU21n+mz0Mv45g6sMsz5D/ynzdB8sCMDBExcj5gVNIEeWNxkwoOU5PCgupr9fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWNu6poTKuZ/VMI/FnnR9mhOsMzdLdRCFoaK0LxGqEI=;
 b=n8jQFkkhC6Ur699rhKnHSCCuk+KSz1DPBGyDZLjp4guXlDkcKdSXutTcKL9SXkbC7ZsfaroNSDWQ9kxAYM+tM3z6B25msxsD9Eo37Z2P7AfBgsdRTPi7dUU5vph0+xei9pu0LFc/fLrVXqaDGx4OgtZqSeo2X4qKr063RwLpK9L2uCA9Q7Bk6Fj8xCoF2StsoLq8rYsznzV835Q2mZRajVGP8+HR/EnYAWNOCPPozMF+UKlOEJU0ntweoTjpBrmoSrCQY515P53VivOBqMaVjTTyjIG+/3styqfohz9BT/pSANPlC9JCvuYid05i9nXjcZOZmVXfSq+oBf1lAo/YUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWNu6poTKuZ/VMI/FnnR9mhOsMzdLdRCFoaK0LxGqEI=;
 b=cUBrocOhor3xJ4iNCSn5rjAvcUDni9v+qF3giNziwf+0aWCjdvzTyoFDmyWKCfg5PUL4JouNrMmvlVNPnYKsRVfyFBZYfNSq2dSUlrH0ce/YRIMZo1DyKgfqFla6Iw17LN698r2dlRlvzX2QM6rm6zXiajCE+pJ12r7Zrq7vXWM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5595.namprd10.prod.outlook.com (2603:10b6:510:f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 03:59:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:59:37 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/16] lpfc: Update lpfc to revision 14.0.0.1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgt7cx3z.fsf@ca-mkp.ca.oracle.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
Date:   Mon, 23 Aug 2021 23:59:33 -0400
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com> (James Smart's
        message of "Mon, 16 Aug 2021 09:28:45 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0010.prod.exchangelabs.com (2603:10b6:804:2::20)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0010.prod.exchangelabs.com (2603:10b6:804:2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:59:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fde25e06-d2bd-45ac-408d-08d966b39778
X-MS-TrafficTypeDiagnostic: PH0PR10MB5595:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55957A78EAB9A0178D81BC4A8EC59@PH0PR10MB5595.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDDHeJDrc68JE292K2rm4yfO6BuBNTAECo2mL3ZKoHeGLP0lVSNRwkOL1VjASWO3hcJNpq6v1ZOp4P5j2KbNbGOnGqZkHRBcMuO/G8XMciEBF/awY6bB4PwOx4qGPSmKHcrJ4crvUCNE1IbJIRkj10Tya/aDVLbx3/QctJOS9d0J4ERRQtKeOLTkKUwkKlzHBb4PQ7tJAQ+3JGg+b4LmEgVjaGveo7QLpgki8WABXOl7LVAMkEQvJQi3n61/525h7LF5+gOl5qJS047se0ZhL3reDaSbCf6YV7VZ6aeTnhXOoijCxPXfFdkTGy06TukKGmJaBA29XKQQ6BvHywvXC6/xR6VP2KP7fl9w2hWwDLdCQTM7hpOJk/71BCOcmIwyfGc4m5O/+xkPVHdWLJPuI58GfwnXZhPQNsNhBaF8KZ5S1pFc7IjTctsqYdkYzSKCfOzOtS8/Zy/QsugaCSTNjBDaHMDzd8x3SNUm2WsAXGv93pwjkGsqrPv2nqZySWp0da6tS901fWsWiyY0AjnkOa4zhNK/R77Jwj+GBF8wUV5bkdZJmFaNmZA9zdsqmZd908Y97PD8830KRQ4e0/w33bYTQavIIuK1rEhZq+JKt+hI1BvI8DvFLIpGgNG7rcR93kr2JGeSKjLf5YKqgrKJsCp1SmqUN1luoe7gVmtWMgRleCcdXGfePE8IR6yEjAnjh7uimRjw7oDvZfnk641zWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(66556008)(5660300002)(186003)(6916009)(26005)(4326008)(83380400001)(15650500001)(8676002)(86362001)(36916002)(558084003)(52116002)(7696005)(8936002)(478600001)(2906002)(316002)(55016002)(66946007)(38350700002)(66476007)(6666004)(38100700002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?voNzpykcnLYXv+M2A93vZOelloHpGzRewVr1+kqw7nBeSGRKdfMYtv05ISUA?=
 =?us-ascii?Q?Mcf03ieqX5ifmoyXxUurC7W25bc6XzA8Amc1z4YGY4l8yfR/vjp1veI0mX26?=
 =?us-ascii?Q?5/OvcKlDDLLoGag9+gZ8Gh6lImLyUhdKJdWStv+mol3xSdFhdSBLmIXgYuvF?=
 =?us-ascii?Q?cpvT4POnh+RxIgLJZlwBtxCSzjUp+fuHNrKHc5fGjgOXk39a3ya75f/JPjRM?=
 =?us-ascii?Q?JJ1cft98g756GS6C5EXNKKpjPHp65o9ez1gVGn5n5gViHqv3McO8d3Bp23uq?=
 =?us-ascii?Q?i0fi7+uBLwH6lwrx3pY1dkzIGYj+aSZYlCGROFfmHzCgXcT50ObYh1daE8H8?=
 =?us-ascii?Q?jRTI7mOmAUC1iW0dN4Q7TTnn/Ud017+8GpyjW0m8PelFNvmPi7twa6+nfW41?=
 =?us-ascii?Q?FmdfbT1CQm+LwZfSie+C4K9khHpcqbaDYoIyhj12tQF+CvKMz202lv1lx4wd?=
 =?us-ascii?Q?Pea3d8QlCAuK/z3922UGrMMfUQfNcP30eQhIXUGJff1ENNk0pBkNt7H50YUw?=
 =?us-ascii?Q?c5zoJ8qkSuQP7ajNDK0vcrgwD5CZNAGpVAYKJt5C7tjwy/Tcyela1fYnVk/H?=
 =?us-ascii?Q?wS1FXC9OcG2VlTHde0D0mRZeJJN2HuAvtl5VMJ+VQt7NO4/hLfHBzTZYI5jb?=
 =?us-ascii?Q?3XDPBvxZUFVD86nRLlMCSjtYR8gNusAWuqQ7jbOvCigR6Q5tqweUw5FaHFw5?=
 =?us-ascii?Q?WmdsACOC8KGHAxRTDfCo2hCkFw4RIhQMmgqXtUJO0VDD3CmvrcnN0XUe4YRl?=
 =?us-ascii?Q?dUwYzZQeWDE614TzxM28B3GEJAaHkzHaEwZ8iYyrQX7UyF9eUbVgypUlnMIM?=
 =?us-ascii?Q?aN1GH09CV6D11xkpamtRxaFmAEesNbpNW+6WuDNCwYX8ZD8MMoWdEhuOYrGW?=
 =?us-ascii?Q?d3rWlPVU95J9NM/CQ5ajArSkAwhlxb/w27hBv1/xO1FDm3gmi24bSRXD9m6t?=
 =?us-ascii?Q?TjAwArQr9k5Ia1g4MnNtPQSI8pTORYTyZETH24fR0ATM4ZJJRnnC3MucuGpy?=
 =?us-ascii?Q?nvptnlfJImK0/ILD2yo/kzVzjuu04DyN/GEq6cHbPfz2fsPZZDyNt6lbM7SE?=
 =?us-ascii?Q?8WU+gWT8mGanbUDjciMvg/VRIkWKWNGUeVyvWUDgfWkuN+TOZ9her9PVzYEX?=
 =?us-ascii?Q?c/B1bLWTTpkgF21I4z6W9NrBWeEnDVN4ONQSTULOKrUF9/M3hqFOnNIle4uF?=
 =?us-ascii?Q?vuFLexi4y5M32jvcNU4Pm0S9MFOWS322CfMpefOt9cD6UETTc1e9RL7rdUam?=
 =?us-ascii?Q?VYXTrZBjFV+iZd9cKAeqAUKLTXwnthjiyFI6k+mimv3TsDqwbrxC/tUWIpuQ?=
 =?us-ascii?Q?O1aGLJ1FNKfcHzs06cG2yENM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde25e06-d2bd-45ac-408d-08d966b39778
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:59:37.6981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RffKKYqKfUhE82Rxdqeb/40/WVVW040MVMBLDEJCuw5LuDovipzXhMesi/fxT1R0wWcQB9El3tEekNv6+pl3HmnYv6z1ty4pkFadyODypDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5595
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=925 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240023
X-Proofpoint-ORIG-GUID: NfjKkBXZS9TK5PfUUuIJ-hIMcBvc5ctb
X-Proofpoint-GUID: NfjKkBXZS9TK5PfUUuIJ-hIMcBvc5ctb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.0.0.1

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
