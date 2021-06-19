Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67D7C48BE8
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A339A61222
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhFSC4Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:56:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33642 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234263AbhFSC4P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:56:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2qB2t028224;
        Sat, 19 Jun 2021 02:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=jkVGBsEWr/Z1sImjJfpA4RpFSKxto5upIw2hQ4RLZE0=;
 b=vLvmAqJBrhQQ1s8hp7eOpVGVIocB5tWOJmA39TNBLE4yp96/aMfLc3HXaQGtNxQprkin
 1Tu2N/bDcBaDuYPAA0ypAYmhHSoSPXsm4XqmNvQDvM85vjvgQdK6wwtG8G7dKWiiyiE1
 Slc247T4YcNI8dLFna1VQALg0q5f/OZ4PSvki8oOwzM+csmcostUac3DvL0Eh5Iw/aIq
 oNdGxQXupejP+ZBZjnfgXTBQeBFZQOgwmQ+6eWEn8JDAfVJDZjbgn60AGJOc1+DSwVzG
 1NNXQbfrjwRjC2VR7tNfxaAVhu9bIFFxSIvQEYbQoDm85XPGcPoGNfNuQzs5ce3UWSTr 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997c1811b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:53:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2pEjv032895;
        Sat, 19 Jun 2021 02:53:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 396wb03eb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:53:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox7VGpdhErTtStzlKuQFVEgqw7h3UJi8UOqx7zooXqrUaVTUpM63HwoEKgNVIbAcYAjR/ZQmpZEVL+trKzplWtO1kApZ0S0mMtg2PCrQW84kPqQbwMBuKvSkQb8LycVBcIBEKl7MfyVbLTkJfcgPCtT7iVa5bl/SEnForwas57oKtinJiM7iUVFLna483cl6/sohCUgw/Gmbn3D+9qLdP3TLoWdMVqy+tqQWZ4gaHPJA5gIY3umDpf7wWO9owZd6jrCZ+rcKT5hIvXAwWkd39Gz0QA76NpsT+7+2aBDWtHDi1rNwb66oFYTqSPQzfaDV12YDYuHCxkfwNU8S/qII1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkVGBsEWr/Z1sImjJfpA4RpFSKxto5upIw2hQ4RLZE0=;
 b=RPyZqavuzXRmQkcka/nEFvWHY/fCThw6QEifh7yKQaWopx34DQTumapDOcJKGNipgqWf1PMmNzqGTbkk9k0RUs9X5ZRKDY0FHFTAeHro9Q0CRPlqSMmz1QRAYk1shUzP5XHQKNrmr2x/cqTPqst1dTB26iJYPYWKMmi96R+/pEIAjA6hhvrUyV8koBM0sRzk7/U0TWmJpTdUfkK5bEe91oCiGIsNCFgkdDr9hMZTgXgLvUn198sNu5xx/1D4PJrjEGXxx7uYG7AXLrN/JHRbElVnnZAwS7uvStoMAtw0J+0GE1elDjzMZB0WDSnIWlHAdwcVsWYfXVzaBz7F887YlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkVGBsEWr/Z1sImjJfpA4RpFSKxto5upIw2hQ4RLZE0=;
 b=BTo4l8ookpwFfPr7KMNY+9A1PPvFJlcJMvjKqlZK9ZXjhjq77n5ed4sO4qBZ2dJsKTqU0ZKleS844tqvU6gmjWJ4KbxyjINdA9RfaruAH8fWVWIDdiQupoIK704CJifQKqLNF1u+7XJPsPYLGdHnFFw5GezIUpctl+11h0iVGbw=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5465.namprd10.prod.outlook.com (2603:10b6:510:e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 02:53:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 02:53:52 +0000
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        MPT-FusionLinux <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: mpt3sas: Fix error return value in
 _scsih_expander_add()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl82wonh.fsf@ca-mkp.ca.oracle.com>
References: <20210514081300.6650-1-thunder.leizhen@huawei.com>
Date:   Fri, 18 Jun 2021 22:53:47 -0400
In-Reply-To: <20210514081300.6650-1-thunder.leizhen@huawei.com> (Zhen Lei's
        message of "Fri, 14 May 2021 16:13:00 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0801CA0010.namprd08.prod.outlook.com
 (2603:10b6:803:29::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0801CA0010.namprd08.prod.outlook.com (2603:10b6:803:29::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Sat, 19 Jun 2021 02:53:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 801e32f5-30e8-41c7-f828-08d932cd78e8
X-MS-TrafficTypeDiagnostic: PH0PR10MB5465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5465A955100EC4FB9BB913768E0C9@PH0PR10MB5465.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gTscLHXvaI/FbSza6dL+uTHGJrDnWhCVdrWojksreu+JufA9YP5XD+U3l32UG8yt0Et4Q9mWNfo0O5XQPraL9o/ngOHJYA5yME1QKfkyAFNJIz5XobziDG3OFhlRE+B6b48uuoSMUe2SOZ63R4abSvZ8lUNAEkyi7fviH6MN1PCgeccWv2FXbB99RKZk+cr27Xw0fjaiauYq+elwcgJoex3yOnOQV2eRYW+Iq9L+3POhJesQihgEuc3gLm7BTDOAPg4Hia2sTP9FuhlINbsm8zZNzkpc/9F20bPYPXR1hsbbjgehCxT1lq6ZksXj7LgploYD0Uu2wmTVD6HDHo9KMARuwnKo5ZuQPPiEQkCAuwoFEivYM3XZQDXBXP0XhwGAEGOPvxRJGiyuM2QXiBbv5LYKx/Z8Qr0Er39o8GL8c7rhpDARH+ds/G0BHKC/KGHsfvkx2ZALydIxFwZ6jI3t7IBwDFwrafhuT5p5KXE9RRtZFXxoSqEpW3bLtGKsUGVhzkjOjSRoBvm8DkPwc+JLOqXjoWKTNjg6AV/8nRwYlzJNZrcYwQsWDAKY+935H3o7gUUiPJJRFj5Sschg+wSVCj4Y/upNJ3zsp997VRQj7SnJ4gvWbodkversOYNs/XP2Byjiv2baQHFb73bz1pKJJQgu5F6/4cSpcDKCMO+6NPWioU/7VgRkBXl/kfKaPVEu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(366004)(396003)(136003)(478600001)(8676002)(54906003)(66946007)(4326008)(7696005)(8936002)(6666004)(38100700002)(2906002)(38350700002)(956004)(86362001)(66476007)(186003)(16526019)(316002)(5660300002)(6916009)(55016002)(36916002)(4744005)(26005)(52116002)(66556008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DzsRFRxT8xVlMFvHoNdbGVUcKVfGOfVV4bH8kv7aqe/kBDtRPyiIHIjJG9vn?=
 =?us-ascii?Q?MyYldNSwafqu1uNI0KKBKqYDl2DUyizM9FtBq2qzxLnw0bcCoN1XupKNt6RT?=
 =?us-ascii?Q?KjgVLxkMx88T74HF1BBfmy4s/H5NCvcZB2lllxWk+gXdZO+t+KV2zxrw+VhO?=
 =?us-ascii?Q?KlTn8nlZLZ0jfbhb3N63Ky84Egl4m9m3vC3AEMuVoknGZt7IyeyUe7HpftyA?=
 =?us-ascii?Q?Y9L2fCQY4PI2ABSckPhZbCIfzDgrjm3BWVhpiZ9fsBrKQWq2lIz4jSJ319FA?=
 =?us-ascii?Q?O14dhfT4yuHyK/SEsdbX1ihWXZmdYAJQutuhEXGpFUONKn1OAnmn7K2x6mik?=
 =?us-ascii?Q?7Gd6hk9tHD/7H6f8n58bNbu84CbXgY8IveqxBgvZvcmbRThBQydotytNYcCV?=
 =?us-ascii?Q?byu/LiXkii5NYxwV5kGet2UlpgoKGWDn4fgSN4bKGfuwm5rVrXMw7o8HiRKS?=
 =?us-ascii?Q?IWcSetHuHgjvHh7RB9D5xTD3GHU11rAtQVAml+D98IPnWAM/UOr8mYrd7fkH?=
 =?us-ascii?Q?Ca46jZtzFWNK/fFYvvviMWpmBNpEUg9s0mtIawhPSjtdp0ygX9S49vfp4Ig7?=
 =?us-ascii?Q?7BpIp7Erlsfmk+mM0y6gFFtKV7+wfuW+JAcWSXSDDhV/va4BcBP7a+WKTR2a?=
 =?us-ascii?Q?SoH89fr+8Ml5336mzZk2jvOjRe6u9hjgrbGPd3Z6YJY8fFsOVCFKWF2q2H+K?=
 =?us-ascii?Q?Fmzsw2mANOzULddyGnQndgD5ZjkJXiI55Grz2X72Wvd886QlDqQSswWaQp6B?=
 =?us-ascii?Q?JQuUbEtZfVKGNZx+KC+yuYo/k3h2lsE4TZi5jDadlyvwadejb0bREGH0z3hk?=
 =?us-ascii?Q?Ke1GJEu4x1/92zueJliktFtGjoyPUr4Lz9zSm6zH5bUXS6TpNjVGeHl1Ndja?=
 =?us-ascii?Q?DoaIMv+6QHy9snsJlktquY/VLZJ8l8/ERYLcYsJ/t6vtHKkAj5TnDiVfqgvW?=
 =?us-ascii?Q?8KonPpcr6aLbQDpvqG7gq/urDofHhi8QAmjTvMqZXhLqTJubOC8HXBMZ4bSd?=
 =?us-ascii?Q?ozQi3U4daxc42YWo68v/g/GLgUjaVSMZutDyLP7C4XbVMSSoEl1QgErSBkTN?=
 =?us-ascii?Q?N1FJIjzhzi30RD+JMdbfW8zLhpFQVCpQCmVqWd1U8Vu/7oC2Rlefx2qtWM5g?=
 =?us-ascii?Q?yJBO2ldtF+FEi74cn3IGDttyjcbo01cdGTVX0atY5HDowjNLaPSd8pb1agGe?=
 =?us-ascii?Q?DyhrPyeZbwwQS0bbBLsdLWdif3Kp+cVLhAtP2U4HNfPrivKqrud2gYNLVoVr?=
 =?us-ascii?Q?2Li5WU2wi8yzPTMi7qMaR9PKRQr2AdG/EE7Fj5nsEhCz8tAw2vCW37grkEp6?=
 =?us-ascii?Q?qnQk/b6EdhDPRpvdh+Szl5D9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 801e32f5-30e8-41c7-f828-08d932cd78e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:53:52.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgTXual5pWKg3Jcbt2Id1ypK0H6+XwfsZUI+U/OHrRZRybISfyJf5SM+pSPMiqSRVsQiRbLVdOybrrNUg8gVn2MCSvPGNH3V+6GxbbGo890=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5465
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190013
X-Proofpoint-ORIG-GUID: uW4ZCkFQrtelGBnc7BBCYXHj5C8sAaKU
X-Proofpoint-GUID: uW4ZCkFQrtelGBnc7BBCYXHj5C8sAaKU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zhen,

> When an expander does not contain any 'phys', an appropriate error
> code -1 should be returned, as done elsewhere in this
> function. However, we currently do not explicitly assign this error
> code to 'rc'. As a result, 0 was incorrectly returned.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
