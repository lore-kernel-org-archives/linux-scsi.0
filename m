Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F19CC32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 23:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjARXax (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjARXav (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 18:30:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B287D4CE51
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 15:30:50 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmt2J021543;
        Wed, 18 Jan 2023 23:30:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=SdciPmneNs7xJL6LQeGhFIzzPHvVq0lJd9JVMrMFe9s=;
 b=foysX6tzqukxTfX015l4zG+JkI/4i6N7rxZed57WLeJrs2Oo+1ADXA7n9NbCuL9Uv2aE
 yYFM8oa+jC5E7mAuvyFSDLAhC3esK47G7XeRTzr/40ey6KZOHZb7kngqx+1L7kHSbrcz
 iTMr0pQfphtFU8h3neQrI9IGJfZFo7JXn65CrdZL3qolKW9HKKWzqNUDUYdzZYQQHouJ
 QLM+3QlTzmPrqVNE0+MT2SqdkcYDiQcbytbwpOfbHwptMzvoTyPLMk+Ot7s0v3USnVIx
 ToY0KrZLGlJEisOOfL+B+pcitHgaYoDYBV+nzpoB0NMRKt48qrJrQdrzzx/px+U8C8Hh nw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3m0trwc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 23:30:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30IMKLEN028875;
        Wed, 18 Jan 2023 23:30:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n6qufwrn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 23:30:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRQhlAxLM6Bik6EtSdQPuvNtR6poAKrcr3frqwbvxk7GvcNpckNuEQQspejUf4XzyCAg1x4OiX/YDNNGLT/8hl6GF7DR68mE8Es9v5R3BAUFu0PLm5zaG+D7hv2lvRuBGJAhHXFLp5tNwPj/FOVsj41T1LPkL9hN5V/Laay96fYmv0AfofxVN3R6RmdN5Kj3l/3p+wQ6z3FXXWhD8VUBuR57as540vDYOCVlaOF9paenyPJKiJMf3gpF3TQpRFLdS34CP2nnSaKKVZKqsVixp/Fkd5Me8NkdO7NGqFaOuyFqRQHXEMb5DmrwLNI+WJqJzMUZCGpF8aZgz7n+hYjhQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdciPmneNs7xJL6LQeGhFIzzPHvVq0lJd9JVMrMFe9s=;
 b=bHYu+ZQrCUv/evql03qHHYWglGCWfa0B/OGc4CnluIClr5GvjhJaJxYJNA3tnN4+d8cm/mkO403cwMsqySgLn1SH/NQAuahlOOo461UCUQgMGZRir9/b5qufyTjHWDA7GvvYgEO5hHCCNeQTkEFXHAHe89B1qOMLgwlNxDa/QLTig9VOHkdJsHvft16QVxCTQW7gaZt/AH4lfYlRRPwtO/ZFh3AQ/YcBJVjfM+CA3yvNXoMEuuYGtcznz4VspcZLNmlneeo6V9/CRB3zf3Atp/Kmo2fkEmNnVAJ4FcoB4T+U4tDlq9cRMhfd91MHyYMretuDehOv3WF8vVN3yUiidg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdciPmneNs7xJL6LQeGhFIzzPHvVq0lJd9JVMrMFe9s=;
 b=NEm9N4c4SVVi6tCB6OH9Daex1Ace2tLkGFGdmpuoEGn43+RcmV8z6i6DX8WD9E9FSxMvXe//sADKiiAMQJwGOzPqYk4UrJpW5BvgepNp87UWyOubnjgtmgEJ4kHoqGTd9ftZtPtFIXQhCmdsdLJV7DrxznDVKNNAXTcV0T2r+/0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB5809.namprd10.prod.outlook.com (2603:10b6:303:185::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Wed, 18 Jan
 2023 23:30:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 23:30:35 +0000
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Exynos: Fix the maximum segment size
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmbbpgpo.fsf@ca-mkp.ca.oracle.com>
References: <20230112234215.2630817-1-bvanassche@acm.org>
        <20230112234215.2630817-3-bvanassche@acm.org>
Date:   Wed, 18 Jan 2023 18:30:27 -0500
In-Reply-To: <20230112234215.2630817-3-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 12 Jan 2023 15:42:14 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0080.namprd04.prod.outlook.com
 (2603:10b6:805:f2::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ccb3381-79ae-419c-9399-08daf9abffec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8FyRHwkVR4o2yLCO7zTnlsJ9AMUMXfeRIoT+NjkhYWbfX5KTeKz6z7zaQqYdUWKRpDdXR+MkqPii1iQK4E0Bh3VeXQJeWTwRdmEdV+7kmLtFw0uf6+rjCBRh6SxgD+Z2ESaPqhOstcZzQNrulm/5b7uB6k7/ZORnnYuKKez+ybyj92ERHCVQrKv633kGhVNwslZaIZnEgGpMifEMupip4TTRFoduIlVsWMRbQJ5jYqFzXr3XBaBM/HtPA7LBQ142RBa6l5up09IkmtJouRRf8cCHkJvqwl+FWktZWOlAk7lg617xNSwBYZYT4JZV7ki7LVl99fsKZrTfc0427nNEpZmoLu2tL+BWudkLav33Xq0hzvHQdBzaTDpuqX3039hOkerVnLg+nRK70hhDx7xtmq17lc+HvFPl6966rNdqyNENyUvYk9pzeuXAdLzHeiyH93sYxHgyeZ3y0vJQqg5k+FTPEMy0o6K2NzXTfP+8Mlwu0wLz5m/wP9PVEG8qGeziP3expGms1NyWomQkxBFNKy5k0UY1Bc8NvJ4QOjXCPAYU9QBoV413Wj4oXoFxA0UysEeohWr/3h8EZ0/hfHJiBte6WlhdPfy6k44PV2yyE2lmHnSmDJdnjNiHyqXOJ64Pr3fyaLZS9FNqKIgkk8IlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199015)(86362001)(316002)(66946007)(4326008)(66556008)(36916002)(8676002)(6916009)(66476007)(54906003)(6486002)(41300700001)(8936002)(5660300002)(7416002)(2906002)(4744005)(478600001)(38100700002)(186003)(26005)(6512007)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VReYNkwJSOV9S7zNbZgiTNzJaS7ITyB3Nxwq65J0EwPG9XmlC9qZ+RO31Q7c?=
 =?us-ascii?Q?uZoJhstoicEQ3A6NnBYTj1LJQy5oHkuFUf3FPwXVul4CDR3F5F5T4axxkBdE?=
 =?us-ascii?Q?46cmA97a9+Uru/GL5QSDKIZjCSzaZ9TxoSixaHPTd2G7XATVD6XuFaMgMtbA?=
 =?us-ascii?Q?pm1pk1XZrX5xT4cLH9faBAOWbQjPZHq/as98IZjIvZ597pWqu/WTLafm8vTO?=
 =?us-ascii?Q?9YyzRjdSAogTRb5DROLjBgfjLfclY0kB/j4gW5aPJXZNg41xXjjaDXl9m9iZ?=
 =?us-ascii?Q?1krWA4Gw+716uS7afVYZx/JqQq7L+pnXoIXy0snQN70Ijz870wVT/8K7Fx6s?=
 =?us-ascii?Q?TgqNTaDsKwQOYOKQzv/XUHt+6CdUNQzTa1K8wAYRfeZEveh6MNnNTsetmVdt?=
 =?us-ascii?Q?j3ShPXUThvqeWJBPmxV6T0IXi4Qhb5n3KMZVzhPyQru7ZgqWtbSgTTPUlin0?=
 =?us-ascii?Q?ENKhhmJGAySsRQefTN+uWy+77048oCImsLKqZCFzZc/MPxO8DbbO8XgYI6Sv?=
 =?us-ascii?Q?RlZngdSh4x8IBTv7AMQ8Eqwcp4XDa4fl6T0mhVLV42oUbx/1JEFgOYy+0XaX?=
 =?us-ascii?Q?SMBNftIDsVktyBZvQEGplJ0Gz7QHt8QuILVtIRxu8pZ5RNGE73kjmbxk1uqu?=
 =?us-ascii?Q?phsnRH9TNPk6qwrA4CBhsj6cXJN9KGeSEVd5gnavnsq7GGz8JWf9/QUSg68g?=
 =?us-ascii?Q?8yXAtoCp6RiZAlXJSOZRQnsCjFLvqfsGOku/+/4q2EvV3BEXDETU4ufbroJg?=
 =?us-ascii?Q?YIMdIowkwW+UDz+OoBomO7rKvfhwk+3s4BaYn5sBIpPnOnX3tItfqrSHmFXK?=
 =?us-ascii?Q?67YsG1IuEGzRshpgNXqQsxfpLU1EPDOC+vALRGxxtBZs+qkdyeyV8wJOWvOw?=
 =?us-ascii?Q?OM8W/ruwGuySAXv1UPGw3OSCxCKot0FDLPt4YH5GGgw3LHBQEqh13o2ECbLg?=
 =?us-ascii?Q?LXtY5yzweBa6oLZZ0czygKJnIx1xVYywLrneniFZLD1Rw9reHq1CITK5wrqj?=
 =?us-ascii?Q?as9zsryRe7bMTL1MHECzbA7+MN1m5PioeSoexi0cKm3tGUmeQNmRBo8uBSnT?=
 =?us-ascii?Q?fX7v12H6rYBRUSVmwIkxYWA0QYQdCBRkUhBD/OMYLaSYPD+N34jk1cgXXzvP?=
 =?us-ascii?Q?C3cRY9pzw4t54X4hvN2GF+Ie3Qk3GLgUMJZOGy5K6wurvGKbuQo6N4evTh82?=
 =?us-ascii?Q?EV83XGi8FpnROmlYl5nHf8ni6lgDXrda9paNpe0seFkkw4EgdUrTnNmyQCLH?=
 =?us-ascii?Q?8Lro6MVBy3e8gajleI2DlMsj4f6eFp5LuFR7ZhkPIKzYww1Af0C1+v2sNZ60?=
 =?us-ascii?Q?CQtrqTQJS4BPRzzV+ELf2QBNRwHsaGN8gNd8eHE253EtYWrR0fYQGuLF0Eo5?=
 =?us-ascii?Q?nUxBMyGYga+zAIMH7zb+bCVc1CPX7EG0TBJFvxVGdvdnjC0hyDBPE/v6+Rcp?=
 =?us-ascii?Q?+XWHW2npC1AYl+CA+BT0P5qkUJy8bEDHygdQbPSBMEF0V7ePMMngHBfgfrOl?=
 =?us-ascii?Q?8fcYXiYgNBkTHk0YX6i7vwKmTXiC5lh2elFBFSjKqRvwdlCkcGii+kw7Q1oq?=
 =?us-ascii?Q?o/OKIXtG85OyHVJeN6giImlgcZgLrboNZd6itgVL9Cpj4rtNKke7cwiy74AP?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?KeytEeeHdTnBc09y/MndHCPF7x9OH1moQbEHfhGllQwwfxp58J2ASu0TSdOU?=
 =?us-ascii?Q?OUuSi955Vg8GDMR7Az/EfuRVmu/zSYXPQhWmOeXcb62/t2Ldy5xalSdiawmn?=
 =?us-ascii?Q?dKovfCaeKhHUrNePfAkM6hP+iIRxAGa77wmzd1H8xezg2C45DIffE9Chj0cA?=
 =?us-ascii?Q?HqpzG65wxYzk2BG8aJrhDLltk5lc6SQoy3zMmBtfvgPixy90xDPCBKyIGkkx?=
 =?us-ascii?Q?J4seSbLjbec7Ypm2jQ2eq59A3Hp79yxwNQE36phirYyyC3thPuXjn4buq4vj?=
 =?us-ascii?Q?akzPPjsOByrWI5cg0yQ0Chc/JbBS1y0RC63vT5GEihbgJP9XkboWH1SScIYC?=
 =?us-ascii?Q?HIrNQKKZM9ijht0F4Scm8y9wMqOrjJokTuHbXw9mLQQapKgFwmsQx8sM7A1n?=
 =?us-ascii?Q?bBV6iBekI5TzLOkA4lf0Mp8MfTeRaBgGjdGHFM9X5iH1fB37XM1XO9EcqDKD?=
 =?us-ascii?Q?Q0687m9GHqtiDme/6wWGFQ0zm2ha8dMy4sRXhb71mb0fX2+1APT4esoj1wJd?=
 =?us-ascii?Q?BMkT4E9qjeNfSMWSoApcCP+f+b8j5YT3fx+DPZ4pgsWUX3mGGlNZ8+fNcHHX?=
 =?us-ascii?Q?dmCRqAMlGnWeQNOSeK5aaYGdPLDod0FJzlxOtOv3MO5n+Kl3wZRzyzLR8y3s?=
 =?us-ascii?Q?luTpLX4WiOzSGXurk6A9JZbI79jXZtm26g016qpZ3KLD23hb+RGE42pGuFZW?=
 =?us-ascii?Q?KqlEPJc9FFIyONRQQbLG91cqQDAiqJfqkVQvgRmkgEAlsBgl2DT9/R4LmzaZ?=
 =?us-ascii?Q?4ctvpb4A0FHWbJqlrgYQVDpwbYvajdQsZOux+9cNLMm03Oa+4ZeoX5MaCgrB?=
 =?us-ascii?Q?Qp2dF3Ju03lMKauxHIRjnzoBnHn1N2WxGDrcfIxJhe2zZeH5Sx7RHBE/RPra?=
 =?us-ascii?Q?rJgur6F8RLiGEek7kMp+e2gyYPqPOpN52eF7nz+mVJtMhUsud0ozJZolGmMW?=
 =?us-ascii?Q?GQSkvpYwJ3ogoYfUL6dTrA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccb3381-79ae-419c-9399-08daf9abffec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 23:30:35.6964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjABSfmWGnjS5A4XMq2OmyldtstgHauSC55oSH8DCHrcHvJSCDsnkJV8uVIBknVBmKfAC8Dg09qzAArchW2FHuUbWRjUeEDi3tl4woT49HU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=798 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180195
X-Proofpoint-GUID: VM5IPdDqqm2WtW6GkO_MP8zMWUMTY2aq
X-Proofpoint-ORIG-GUID: VM5IPdDqqm2WtW6GkO_MP8zMWUMTY2aq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alim,

> Prepare for enabling DMA clustering and also for supporting
> PAGE_SIZE != 4096 by declaring explicitly that the maximum segment
> size is 4096 bytes for Exynos UFS host controllers. Add this code
> in exynos_ufs_hce_enable_notify() such that it happens after
> scsi_host_alloc() and before __scsi_init_queue() is called by the
> LUN scanning code.

Now that you're Exynos maintainer it falls upon you to review Bart's
patch.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
