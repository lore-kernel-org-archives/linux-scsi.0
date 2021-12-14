Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87770C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 07:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhLNHTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 02:19:01 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55214 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231391AbhLNHTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Dec 2021 02:19:00 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE2g1V8004133;
        Tue, 14 Dec 2021 07:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/xbahMk6RxBEkhWBm19wT1gbWVvJgjwOl0NXJ1o4AyA=;
 b=T+zX3bVad6vWZqB+veyibPrPDqZLONiurLYgfIWFvkaLbMvwJ/po23dow6S3hJqv8IhR
 x9nU2S53u5rbsfwgNfBpd5dsgKD4aMoYfBIPa4Zt6pJOLs1DKmxYMUIgn4m8l6+7OHAK
 E65o2K4FesHN09YGH6AQtzYj/6zzlA/ZCZH4fzQF/yQslGEmlPhfF6ZB8EL7Ggt7rOzf
 KjIjh9zFlX1L+5xBDTTEZ5v4dbe1t22GfvTUt40fcJ66GPqdCPsfeP1pHNxJ9isbfnDj
 7eFUdLSkiBWxnXZe4TsgepbehXLJU5OtofBW4iBb3X2EsPOZ6kkYpu35pLuQ3gyUsNRY zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py2wjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 07:18:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7H3F6046526;
        Tue, 14 Dec 2021 07:18:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3020.oracle.com with ESMTP id 3cvnepg40h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 07:18:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwYrGBVZOLlseu7O8+GNK8Z+s4uS3lYWQrzatyXyV7CwiSIJvPdPTN2S4fLxPTdBFYkGLbLAv0C92b7DBINm/wE0UwQ1e2go8N13+fiSC6FCOVsswjX9STcsYQaADqvHNx3Ox4LLCcd0sVEd7U20U9XXxGMNmv/RspvXg2qIVx1jasDOpemMw82StgfyaIgWzUrK8RRWrNCUag+IejsSSxzjLcg7p80qa5vviCsL4E29xg/0n3Pq7bCPqf9cpKeEkZacwu0GZf8I2Gy9S9GMTL3CPTH3cHcKSoVtUGX/BR4yWETTQpjBZ8A3WAMWr7LsDGq8Q8JfsA6rsXjFc5jU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xbahMk6RxBEkhWBm19wT1gbWVvJgjwOl0NXJ1o4AyA=;
 b=IgGreVJMf7jSSpmb+JNr+nb0E5/XMRSstSeW39AjMZ/GcbaWqmOwV599VIaztJuBgi1veWUaHnAHKb6M7gRLvfGk2b3MGWhLKvaqXcUNkmb68Sla7VE3gI6t8/OcBh14UjaIZLhSBJHYLVamMez7QrhhVNYOSWtR6vcT1tkA5cTacZy1bWWGXC8H8BAHicA5lilVra58V/OR/I4vfC8dfESjTb6WL+VS6YgiCSx1woGUwCAmEDqfxdNL8XLoMF/j76x69Z5BPsyq9auwnMbT7BQzAfDTJ5VyuuEZmulL/cx4ADLGFpc1lMqlPQBM1N37UGXi6nVE/VdP+mqe9S7tzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xbahMk6RxBEkhWBm19wT1gbWVvJgjwOl0NXJ1o4AyA=;
 b=WLmtG2AXgQ+SyqsYl1TD5wrdrbX8TCT0q8oZmjm3UxHfuZqkk+fOIkeYt2O3iJXbq699ZQHzRqiRadCMLFsKQ6AgFfjXjQ119jKFi4TpT/j6c+HFIJ8Q6K9zcb5ahMVYl7XLHYTUTME/kJrkJlYFmAGMBYK1M2tfHdP3XNgzdSs=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5721.namprd10.prod.outlook.com (2603:10b6:510:125::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 14 Dec
 2021 07:18:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 07:18:47 +0000
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v4 00/17] UFS patches for kernel v5.17
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsqvodso.fsf@ca-mkp.ca.oracle.com>
References: <20211203231950.193369-1-bvanassche@acm.org>
        <163945683293.11687.10954614360616312364.b4-ty@oracle.com>
        <DM6PR04MB65752EB0E198BDA3F723DEE8FC759@DM6PR04MB6575.namprd04.prod.outlook.com>
Date:   Tue, 14 Dec 2021 02:18:45 -0500
In-Reply-To: <DM6PR04MB65752EB0E198BDA3F723DEE8FC759@DM6PR04MB6575.namprd04.prod.outlook.com>
        (Avri Altman's message of "Tue, 14 Dec 2021 07:14:55 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0058.prod.exchangelabs.com (2603:10b6:800::26) To
 PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a20a169-541a-46da-4c50-08d9bed1f861
X-MS-TrafficTypeDiagnostic: PH7PR10MB5721:
X-Microsoft-Antispam-PRVS: <PH7PR10MB5721E72A2EA57533907F223A8E759@PH7PR10MB5721.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPngt3xKaSuyP9BgZRz/hIF8R9XdA1u5q4Z3bR3kv6+q/dSIh3kh+LGxf5Gv7ax3JO+8G7OZ8yNWqEqxy+dZhI+4i7US/9kQXRbiu27FE3Ric8xG2dvR0WQceZfz8KRea1JTG5ns/ZFVIFwxoAQZQBG8SUKDgfhEG4IlUr6p/XktV0+KunCq3PlupmANpocgkwU+hMjC60EowUXuolLpY6gGg2D4z5isdXB3t9nu+AwGpbMSjasuEFnVE5HjvTrg7KXuWK6Kg4SFGORB7v9oEwcvs6FshvfyOz1kT62P4XEARm5QbZzO2fVBYbS5F+taS2GKJYUy8KpVfERU6M3/CJay2VE0aUdkjuRYkYrJ87LcG/zNMnDutggfUxYaCri/xgTVEMn9/L7MR4/u3bXSticfreJoNoJDMEYOVozhExsGqh4Hz8cEEU0K5dfor19lEfH/fhHZJBZg/OEcJIsR+EN8vnWzG/RY5WZmJCpv6QcKNeIY+SoROESt59Oo95CHQ4BgEkpNrhuWMd341Fw7/WRKd8JmGKOxR1iqi4v7CfDC+ybexMPMJ7Rns/VJSvDWWQ8n6r9b0A11tFp9XFdHHqAqUMfSiX68hrYKckodaEUsw0vzdHbK2QPdm0i2XZRA4Cm5r6BLc8M8Fsy+EA81Nn+PeV92ltKjGYxibADpbq7QUdeWAyDfgV/mg/VWCTI3GdkogpsCuZ3yoXf1YgsZ2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(186003)(508600001)(86362001)(2906002)(6506007)(83380400001)(5660300002)(66556008)(66476007)(8936002)(316002)(6512007)(38350700002)(8676002)(66946007)(54906003)(26005)(4326008)(52116002)(558084003)(38100700002)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hQJyWOw/evPzcb0U4klWg4kPlIoNKqr0OzgB7uNKoVcI6DJ7oLhI3FDZu0Uy?=
 =?us-ascii?Q?5jBeX6WOsq/zdT7qtbuGQpt6Dtrt9vjTiontPxYNtnCNPjT2FBDJoO67ZmEW?=
 =?us-ascii?Q?4rixafSc7jlWGBw0bIdegBIy5PYuxuGDVPOXOk3ApMYiIsaTS0wdii39Oels?=
 =?us-ascii?Q?rNd9n+iYGJ2XGB1YGK5vRM2PKOYxOItWlWIK1j+T1jsyi6x6SpA4R80GiGoU?=
 =?us-ascii?Q?+aWxF4PHJcDp7JsBlBt+LZWsVv3FtEYciY7gtqBgmkiQouUa4euDYCror5I3?=
 =?us-ascii?Q?MIhMXvRB+SV/eDmk9weHZTePuzpunABboMU2dEjoUfk882wjF0+TdWDmxxbj?=
 =?us-ascii?Q?FOhfdWbDblCHv9tfWxncc0n3n64DgYGvHSHDd9ZqRveRticQH5XJew0aW9ik?=
 =?us-ascii?Q?rNEMnEWRl6nh+gNaFB6xU0+8gm2xfVdJEbl/kFPi4NY5DsU+0Ah1YjLAfCoJ?=
 =?us-ascii?Q?WI+UdeTb3PcCLT6XmPUw0LEg2Kwg26mlGqHnbQB+pdY6Lrd8yVw0Yj1jlwBI?=
 =?us-ascii?Q?Ns+qHRhpoFccneloHXIZT0OQSb94tb5oqfkTVCU1mwuNanAILhWQZD232DZ3?=
 =?us-ascii?Q?V1jjvwKkGPv1TZ40+kU2PSnQWXgUbe/SgFJzcweg0ipvhLRIiWmREIujTVTH?=
 =?us-ascii?Q?glWu+Q5PGFzf7kIZAoSHLv1y98wgdoqfCIis13MOQOKJMAdlhEw2eKIu+Zux?=
 =?us-ascii?Q?gD0fuAnEHsYPY17NBuxztZGvt/w4t4yWHz3lrAs3KJdBducqUsQCYR+Z4C6p?=
 =?us-ascii?Q?q8oOtphd8wsTSEORR6c+abE389JJgkiXNZZy5Gg7H3T1WDtgDUd5UzKe3YaH?=
 =?us-ascii?Q?FQN39MU3dwkTqKB+2v3Ou7m4ERPUZuJtg6fviQmKS0U360+9v1sByPWJhDhR?=
 =?us-ascii?Q?KndpYx8ygsfBUNWNwzQ8p9IioM/Z1WWZHp3um0RRQ6qtEuD4BZ/uDvEc9BQ4?=
 =?us-ascii?Q?osIuabQBngDzIb/P2aTYcCTjRh0qpxha818T6XmUWlAAu8UEiykVrbISSgWc?=
 =?us-ascii?Q?S6BiP5KADlU2aYz0vvYGlaH0odpSe5sKMJc9B3Bf8U2HQHNQfZkiCL/ZDjU+?=
 =?us-ascii?Q?2L51diYFSzg1c0+YzJXIyjd6c0vOqq7bnJWNGSBkDHx00rGhDdH42G2RqLun?=
 =?us-ascii?Q?Gh8tumgkkLt7ZAYFfw4zQy9l4qf2zAt6uNUIDABzqcoZB5vVD0n4RmGQTlN4?=
 =?us-ascii?Q?/xyBIr9nIsGGRZALdr+KDULVwQDecVA5NJ3iOMBfmPPz5inYaMh/4Vtl6edg?=
 =?us-ascii?Q?3jP9lxwRqPiUVGy65g3YTVviPU8uDZBk4kZgd5cCWA1EFw6Q6c90V5lmNn/k?=
 =?us-ascii?Q?EfJsMcibfbI661kXm2Qftq939kJOlnYEuQe+gmqOstkCQQIp4sbgp2vPP4zG?=
 =?us-ascii?Q?+BbMEvw51/Bqnji7AcscucOCF/ZlpR1EJLMMqyHPDCft0yo93oC1OVXgIlKd?=
 =?us-ascii?Q?8J7vcb4SldNBnJzPFYxUMgHuCr84NC3wRs7dEdX730KnisEuiB8i/dGdCDVn?=
 =?us-ascii?Q?pASGYekzlY/2u0uw1f9ieLd7ikCBhP5lcub7syPrGDu6Ju0ep5PbMgkkWHGR?=
 =?us-ascii?Q?xxCIeTgZpnmQmk4EndnO/E8DV3FGVGY80+0iZLf07rQRMKwHxLJQ+kwIrg/L?=
 =?us-ascii?Q?XzqGP4uY9jSfMBFp4hX/SBwuUz5m7RBojk6At/UQkM01RkgJGB22K5fuEIWj?=
 =?us-ascii?Q?dKdhoQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a20a169-541a-46da-4c50-08d9bed1f861
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 07:18:47.5454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMKKy/nTh5sCA2dRk9D5ACZnYXFSnPTzWCata3XMPt9INzK0+uNV+1C9kxih7aLD26rhA1ICvn1PbJY6bIh3Y/BhwR9NEZw+uMk+z4IUk1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5721
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140041
X-Proofpoint-ORIG-GUID: rm3bMDfwsF7TbBXI4OGg3OR5ppPXTcMM
X-Proofpoint-GUID: rm3bMDfwsF7TbBXI4OGg3OR5ppPXTcMM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> 16/17 is causing a deadlock - maybe you can wait for v5 that will fix
> it?

I'll just amend it.

-- 
Martin K. Petersen	Oracle Linux Engineering
