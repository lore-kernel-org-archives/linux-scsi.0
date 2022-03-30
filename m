Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDFEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 03:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242242AbiC3DWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 23:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241298AbiC3DWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 23:22:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941079BBB6
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 20:20:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22TKn3lP013073;
        Wed, 30 Mar 2022 03:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=RHGvzORo3dRw29GVG9mUWWcdLCjCGJAP9czNgLhu6LI=;
 b=SiYusi6cpRUggult49eh0uvfWv7ePa3WiY4C8GMP8YuoYRrAnwrXxkT6DwjcGOtTY7gS
 3j+urQjuNgfmpH4bkuZiEiwfPytCXQD2QCmAmjXLX6kGM6yGD7IL6TXCVks/ZWXBam0N
 mHNEiwmm4FrZ+b9xfL28ok6ndDP9up6TgdNI3At2wZAJyZayThiQaB7/YSJydivgWnUK
 g/k1sLaPTfd1nJWR+lvodUWUnmHx9U3WCCxKVQ5TlEuo4MK+8BbQ58TiUTamJPIRXfpK
 DW9mrqVgivNDeltajM4Af0I3p3IpTxKnn1SDWgEo4xsRhkZsl1i1TbL++0bhyn4xEFZ1 oA== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb8539-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:20:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22U3InDW125795;
        Wed, 30 Mar 2022 03:20:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3f1rv8e7gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:20:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/duHTCh+thU8vVoBFXllulKsh739kod0ZYDvuHECrWrS1m/uQlqq7+49GPxwrNyKDGjgs2aF8g4DJam1mtU58fKoJ/K2DFX7E+t0p+ifF8PIIa258rUP0PgEqujdNjYBuvBh36CRf+UG1ViJ6CQWihBAu2SRl8n4aPM+poRXYB29wmHM2XY8YOZDORD5TKTtmBQI4ADgfFyBPwYmvGlaZBcoHNXNhZapWd1Z3YfGx1ktZeFXGYGfYpFI9S+qv7irsrJxayF+ZDbL3kjoYiAFmWMlfSjysPLCdE0+9qU7cWgHC5t3i1vC+TJ9oUmKU0/SBh722TCGgAaMQUuhriYkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHGvzORo3dRw29GVG9mUWWcdLCjCGJAP9czNgLhu6LI=;
 b=Ob+EfDee38rbCqYTVR+uil6z4DAuM1IDopJ17i8Tf/m74xER1pSYj2Igth+M9gLA8BZg/G7Re7ef80jA/rJoFunrNW/XzIn+ol90JxBUenTRpDAd9jUAZ4wD/BHrpDO3/bRM6HGi5bAIm5ch6j6+de6zNY2G7PXx9gs5FN8lQKDQM39WBY1cRhh3yb4az7zMhgqmaxB64eW9SyKmLr21psSCyAZypJHBCUd4EVR/KLatqV0bwBfXq5BPmIaggZjAwHBWQ5tpQsZeS35+WKzLJhxzXUXH+q6kra9DZcJzrYcjCu3PIiuiu45HZEik7jGeAaWhVc/nhNlQyTHjouhY+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHGvzORo3dRw29GVG9mUWWcdLCjCGJAP9czNgLhu6LI=;
 b=ShKg7xBVz8rW4FLxITCD47kX9uCRr7GR324TEpqA9S8lSuGH5L+/U3T1rCT1a1RHZp0abVU85HWjCCYQKSze0chXzX5IHHckINw1bjIOCmfj4pizF49eCsQD9UGuKjJ67VpOQ+Aj8guYTAuHNwWzWL5SGpCC7iVyjhF3yf58EP4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR1001MB2362.namprd10.prod.outlook.com (2603:10b6:4:32::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Wed, 30 Mar
 2022 03:20:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 03:20:21 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] lpfc: Update lpfc to revision 14.2.0.1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o81ow2hg.fsf@ca-mkp.ca.oracle.com>
References: <20220317032737.45308-1-jsmart2021@gmail.com>
Date:   Tue, 29 Mar 2022 23:20:18 -0400
In-Reply-To: <20220317032737.45308-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 16 Mar 2022 20:27:33 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0701CA0035.namprd07.prod.outlook.com
 (2603:10b6:803:2d::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 172d71fd-ebf2-45a9-b42a-08da11fc38dc
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2362:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2362ACBBC8480C8F951EAE318E1F9@DM5PR1001MB2362.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5vVexRg+9xj/OdZsHZZC9SLwGXm/WE+cH3vJPo0tur5NQPu2FgbytmrBEuLykgoDYichnagWnx75VB/LW7dU5xEBHwip7kq5a3sXe9jj2Zjl7V5C9dgU5beYbIZ8PbhfJ0PNLhEVDzZf1alTyRu/pF+wMwy1E1HVbhxuQsbT3IHF1/Ynkik78HGFPggqmc+jiPE1+8ib3dxQh1f7Dg0O2B4KxFPoFBpS2E3DSywzz7O/ggE2Ty5Ppd/TpEUBS5HJ8U91rQQirrIRfx+Z4rHm/To9JVp5D7vvy6WDWvDkiGKJobaM0iSeBeJe8q+67eqgzR96RH1GCWjOgMXLyUecYTlUW+skfAtBzC+eNjB6eaYUWIC0envXgkdFSVpgoLn+VegvbXe95ENG6tsaazgX1SLO4zGOjY/coEZxmz1glIktUucWis3eWMiQSHFyRgvP24fMp3sT7DIB3M70AMIBUmDwfECReuCfgy/QLt0NQUv7gC1vClbXQ67HyHUJzAonp8/jFAtW0NEJo3N/6yXUQRRO9QZDjuZlwFVh/8hs7aA62eBD8tnEsth2R97LMQ5NuDl9oJX8SE4VaYTSvGefSi7SgXUnE/E4Px/46e/DOs+GsYfnhE2yoW951KR9NnkTmDq7B2INPXlliwIxyIGaXERYd1+PKRHJDqiBzvlSvcA1v/49eK10yM4cduUKeIvW9UTV5TYmIEeUB20zElcog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(186003)(38100700002)(4326008)(66946007)(26005)(86362001)(8676002)(6916009)(6666004)(6486002)(508600001)(316002)(38350700002)(83380400001)(6506007)(52116002)(66556008)(2906002)(8936002)(36916002)(15650500001)(558084003)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bj6v+pDJQMxyFPWw0+MUsdWTtYsqo0X24vWM+u5K8Mla3Dj9K/4Da6e5cRVW?=
 =?us-ascii?Q?aQuxot62Rwi1eaOqTgROxLZXPkdBsW9ceVciYj7rKWvy9N6y1uyY326WZNsN?=
 =?us-ascii?Q?mFNZIBi9Rid3mU9oONiuv/uLTR8XGpoTaA4AX5DjpsY9lTn5+8Q5GpibIj9x?=
 =?us-ascii?Q?xvEjuf+SnQ1vdNdaWfmQ83dsziaGPVaXeNGulWw8WMf2vshQ7eQokHBfGD9r?=
 =?us-ascii?Q?Sa9VUGdjTFIIn7z2N8Hk+znHeFN8TKLNyELa++JWb+ylrDws5qeebPrYK603?=
 =?us-ascii?Q?rj2D/P3wEgoJNVkqOrPh08uQSFdjpenxd7Pv/UYqdfGxiIxAhl64VrDFvCKh?=
 =?us-ascii?Q?+LXnICW6dR8gJGqFOPA2bPCWJnp8Q4MNoI/PTG3G4l/a+cxwnZBiVmP1A0Co?=
 =?us-ascii?Q?CF3QFb/qEkYOYI21fJzBrD+EBDWmx3D5CW6oHVrZliNvGVFwt1EbZJty+Z2N?=
 =?us-ascii?Q?NAGn5XQa5w3953CdK63UlgbAQYkpWH5Z1cHrdR425dCvqg2BGIOsbdFlHuA8?=
 =?us-ascii?Q?jI1wbnaiQmngahactAi+I+KA2VI1TOClOvi8zCo425f1djfGiRkRocBIXj0E?=
 =?us-ascii?Q?efn9gErwGWRNrHfxzfju53pffvbemhYNB3sEHS8hPay6E3Qn0vbWDAj6oUgX?=
 =?us-ascii?Q?vpOLj9l7ZtOs8rfj2VknnNkMDNpJTIurGYuDe9HfB2bOch9nND57oaTs/G8n?=
 =?us-ascii?Q?AbMB5NQiQZiHs++jPznklh09rAE7skb2LRsWvFO+K6RJEXrpYJcwE+E/Zyy7?=
 =?us-ascii?Q?JA4vVE71aIagvsTcr5jF95hgr9KXCEMLdRhQ0j+FkZ5zWk4Oan+7TWjVjbHt?=
 =?us-ascii?Q?/h9SvUoFvRn+U12KuOsqP24xP1nKPLjPKAU8UeWLsKcic2nP9HTF2Up5UWQa?=
 =?us-ascii?Q?ul8y0tT/VR16OsdA0G0yq6v5hL8tmxA+TmpZ/PyQ8YL3m4qum5lEC91RN+No?=
 =?us-ascii?Q?MCTWG6s939wedFNYXr0pWm5ruzjE/+P778HeFhTS5UhFiOyZewP/TPyK+RgH?=
 =?us-ascii?Q?jtkQ/2i2iiWdLiYHZ5rcrxOwtrY5+5VL0KVFngfFyrwi685fcg7eRuudEkpd?=
 =?us-ascii?Q?5bg60lh3yHUkXp46vkjk0pFSeFyrGaH4RibhK0EVBC/NbAyiCi/jJ9+I8N9P?=
 =?us-ascii?Q?J6PhP4jcLbBVTvQyNRK8VNAte5/pDMFnovHtIdYbigkp3EOB7OkB68gTTqbx?=
 =?us-ascii?Q?jztSp8tqBUkviDvxjk2USwNNRXkDPCCS80dORziwexyCbvpbrvkReURLql5m?=
 =?us-ascii?Q?8fNWI/AQrlGO7WzVw3AHKK/ol0Em9yGyP8nVIHGbmnlWi1ftLJHvyWfWZi6+?=
 =?us-ascii?Q?GQBagmrkeI7zJuJaCHxWLtAq6+MYpFVfgf5Z+A8NnKpw+RvyqUMcmD4Upybk?=
 =?us-ascii?Q?dnp+CBdumjDszD4gYcGjZxwdlYBsmhrIxThSw9olGerBIu0GsWSiq1YrpNTv?=
 =?us-ascii?Q?96cXt6EhjEoR3vZQqYeTwjL7OwOQpeHGLOXGqBXVLy75HtvDQOyBxdXdX6hR?=
 =?us-ascii?Q?MMgKAK7gq3Pp7eOQIFB/7yINT87ImAxyP+YjmgzL/NSZf9fzZ/6SxB3cZ+n2?=
 =?us-ascii?Q?06Mdl5aA3sA34Nhvsi+sGBPvDIDVI1FZTMU06Pbx9qdQ/aO7hshVPMWANZGS?=
 =?us-ascii?Q?j87XCqVakQZ9xlDEzJE1+g2m7hfZrP4Ot0zisI2zRxMtaQHP5+dL0UF0r+Vd?=
 =?us-ascii?Q?srbjXCjVse/AfQCLqWxd8uCyT3yyddkmGbQeriXw47qOI4Sa5L6c7cpHG9Vk?=
 =?us-ascii?Q?Zv2VzoIUiBjxp6Z8kbrlmjc1d9CTRBs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 172d71fd-ebf2-45a9-b42a-08da11fc38dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 03:20:21.1015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dl+kjAYUi2j+/QGAooO2G4OR2dBXTohniNe86h3Ql5cv8elrkBpv10ABPpKgKbOajfz8DgbOdG5UV+awKwg6piKHFSWv4q0pnCZKxOKiYfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2362
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=688 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300014
X-Proofpoint-GUID: CR79NYLDt6O2En9VE5cPJH66pNiOU3nE
X-Proofpoint-ORIG-GUID: CR79NYLDt6O2En9VE5cPJH66pNiOU3nE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.2.0.1

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
