Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366F8C77B7C
	for <linux-scsi@archiver.kernel.org>; Fri, 12 May 2023 16:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjELQaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 May 2023 12:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjELQaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2023 12:30:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0349ED
        for <linux-scsi@vger.kernel.org>; Fri, 12 May 2023 09:30:05 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CF4SY1028691;
        Fri, 12 May 2023 16:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=KFvwzmVB5EH/+E9ZY1bbOMxWdEuTWtgHPqynPlLJX10=;
 b=iOJ1eteP6TfB4MUSCZwsXrBfkjgS1dQO284064Y150WWgZF/ftAlWS2A8/VlVj6EJP5/
 sefR5t+IYQnAEB/MdUUoPHFFJ5TYqpv/Z7A35SPhia2N4HRTx1mioWxHgj+brI2TMQ5v
 6yAQdt+rEuutR3DBmzUrjOoj6n+enA7czBr//sgz0O8gu7ziN9n2GltY/YXQpixjGNkH
 eGMr8EaRUMmYYhcolsAhx+iNtTW188hmBts2ZPut7JudP6n26xVw18sD6ACPgAm5QeCn
 8SUiaL3ffuLbKXUfyvyu+r0chzqGr6SzFEqluKm1ZfwMq0gnFv+AY5Olf8QPybzhTPbM 2Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf77dk63j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 16:30:01 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34CG0S3u014547;
        Fri, 12 May 2023 16:30:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qf8312atf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 16:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdPi74gVsrtRyNmDGd8vL8J2pVfuiaFLGEsXhNajzfyd98dRkA2IJPNjK2AqBjllgi5xiDQLVn9SlnaMHO8gUMPx0m4RPKlpRTeEePJMj2mrUJhava74Gs2ujMRYL+1sVcgoWbeVI9pTHxrPteL2pSu1JY0tbcqGyvKmdVzf945P2ZD4V2j48p6Ic3ZwLteoRwZokF3gsYfE8mkGb/Fp7ilnonUy9OaM/jYzZDuFYfeMh4zYAcnN+LW5H5VJ1+ZrjnlihArDm57SDiFAFedvQar20kZgs/nWd2L4oDYMQmuRxY1bgkuJ00/u/uTxF+1Zcmr74iXs/1YXZdqmHFG6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFvwzmVB5EH/+E9ZY1bbOMxWdEuTWtgHPqynPlLJX10=;
 b=ir+7V9zc447yO8PzhyBCvK3A/FTiXT5jlShjQtemfvdS7bUjpaRgdObIMgSi1dYgt2rc+T45rcUWsD/0QRBRxZ4ahBfTmY1RiwD2u6sYkl1l/8E0PMxwtAQ1yHZ3Kjrkwu/xmdHsQV8vFRZyDi14vPbDrF3Z4K+yNRneZv+oHpo9kBqO4k9pNPMAwHpNe8Ve6tHpdecYW4NSuj30JwgS1Ti8kfYyg0kfWTKbrjcqFApvEAl0zZ083mgtQuo/BL2cMdfkXLod618vgBxdiqVN1tSYOHEQGi+7jP/KzSH5HJRpf0k3d/abDbm5tAdoYAD2KlHcfo3klscFg/gO9JijVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFvwzmVB5EH/+E9ZY1bbOMxWdEuTWtgHPqynPlLJX10=;
 b=WznAp2tnazzLOx6ELzTI5GIgeiDGms9QrJmCTlptqv1Ewnoh6d0jhBS2vBuJNFaHov2dyUBEpieN/rXx8Dph5yIlsvbarYKDo4Yj8/aJu945yqNWtBzj8HLt1ZXOXN6OAeEZukAkRnhuGkNaEchZ9lYn4Bkcyqu2JHPxRyA33Ek=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB7783.namprd10.prod.outlook.com (2603:10b6:510:2ff::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 16:29:58 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ba5a:9305:3a1f:824a]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ba5a:9305:3a1f:824a%6]) with mapi id 15.20.6363.032; Fri, 12 May 2023
 16:29:58 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Gleb Chesnokov <gleb.chesnokov@scst.dev>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer dereference in target mode
Thread-Topic: [PATCH] qla2xxx: Fix NULL pointer dereference in target mode
Thread-Index: AQHZg/DMRBUHVmtcK0qSko9yoKjW/q9W1haA
Date:   Fri, 12 May 2023 16:29:58 +0000
Message-ID: <812BEDB2-5D43-4D08-B565-2431D420E736@oracle.com>
References: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev>
In-Reply-To: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|PH7PR10MB7783:EE_
x-ms-office365-filtering-correlation-id: e55a472f-bf14-44da-1596-08db53062081
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qMHy1ZYgtAp87fHPeiOe/jj+Iry2vBnXjYxqdllb/vxSDYyDZ25ep9AeivW5UBkHWlEX4+vZUFQjoK499i4SGRmEcWU/fdr0iOQ3pnnxJxMKVVwi3BsCOFOjyBP8eY9MPDo+ugf13QYW1krid5AI56cwWQW+7oozcMpr6145UjBkSP6ExKClFj6tfU0ekPWgltka7bQGfQbSnoNLqIaOUlAWFGhMc+8h09ph9Q9rECKLffRktxSPQnAb5nh7ZkkHuCTUqYfiaaO4DFcCYbz+zz2NrV8C28YfJ9PunfXeqF4Mdd3H/gc2ZxXN07cJETSZ+KKuOKfoYk2X9IY0l7mHK4BlJVJEiOGDAlpKVqlY/MkUJCox11CLRu14+SatTWhgTS6saz6305MF0cSJBsn+x6ejhOpBV7+gN1JeG2OrbjbwPyOSdx72Q70hFkfT07SokuH4Af+mTldnfSybO3JGZOdgbwAlqVj8/lPTSNxhu037p8kcmLVB0sYfUgUtHj6Zx8LXkYcABjREPQfAcKj6/v9JIbmuQWLmHM5kDuN7Hg8BSYKRRFGNZR2hRV5ZEAc8FIargWuaMC7QpQNdi5rPjd5U7m8D8ca+QjK9qiAbHmRO5v0H0y+zlpwSKGPeMYlMHq2TwbjzvC5yVU4BtyfMQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199021)(8676002)(8936002)(2616005)(38100700002)(5660300002)(2906002)(6486002)(71200400001)(26005)(38070700005)(53546011)(186003)(6506007)(6512007)(33656002)(86362001)(36756003)(478600001)(44832011)(83380400001)(6916009)(66946007)(66556008)(66446008)(76116006)(66476007)(64756008)(4326008)(316002)(41300700001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8x3RMo/roBdzMwcXKB5Dl3XBMf/z6NeqDj4RJuWvSyiy4vVk4D2WcjB829/5?=
 =?us-ascii?Q?Uk5kk9okK6wY6UYDYqt1U/3gp3VZzi4LIyyWrlC+YW5saYGOUOd+G7STwFSp?=
 =?us-ascii?Q?hxZi1XhwU+fZO44IH6ZfIxVidSGAo87GQc1Ogr2redVOFh05m9X+FxjJG24s?=
 =?us-ascii?Q?jo5oZf5AM2xWtY5oRMHrwWWFGu3yP/6BM5njsp/OVnarrzdOghrVE0mosfkp?=
 =?us-ascii?Q?S44933xzz4TjQHyc1VLJJFT17ImXPxklIhxwSTboqmU113xjlKZ05I5oARsG?=
 =?us-ascii?Q?lmANMf9vrL2YO2jrT0rpDkHNm3sQW82Qpi1N9ooELZRlWs2fKwGqdtIIGV33?=
 =?us-ascii?Q?Jzpi0wxll+6zdWi9byvs705Z3k5t9JRyUGhwBou010fS58fVfUpRioyFwTTc?=
 =?us-ascii?Q?xAS3kuPtTXeQjxjUtWaAZEbZabhEkVS3oMtZJZ9aezxkcPUjMJPoO+CU80AP?=
 =?us-ascii?Q?V0Lt2q5a9Maf0M36naSPEwJwc6h9SdcICr3iqrB9fQvLrZXJhEDmGps3On+l?=
 =?us-ascii?Q?4Z1WflOpMfZMk3DLNZugDOlIARNNvzUC9CP+A64eBrmTtSUZ2nYL2sokcq3O?=
 =?us-ascii?Q?nE4h7Sz0W9JNq/gU913vSdiUmfuG+OWr7ZRwsdhlqrwfBSDkvDpcGcfY/oks?=
 =?us-ascii?Q?lSzPVvRYyuAXM8CUHYaIgyoDztS2z9pOGyLizNdxQnKPcKQM7Hc4gMhCGj7n?=
 =?us-ascii?Q?CxsCFn5K0gPdJUrDHcx9cdrYr35+pJaodOZ9NDoJB+4e/tWuX6vpg2eOn4n+?=
 =?us-ascii?Q?JQfovCr+KHgObz+zWKt8vaFrTmxw3acVhN5t4myyZOLL5zD6x3m7jz9MEorz?=
 =?us-ascii?Q?G5hr6UI8XV13+PZaWfoSRP0ZUqOAK8sgHCbXvAFdsX7FnrO+ykaVVlKV90dj?=
 =?us-ascii?Q?B2OCiUMJrjNPj0CpxoT6ehJE26s2kiI43GzI2gnffVGC6FGkdvlSi3Zs0YcM?=
 =?us-ascii?Q?7AMe/mapF2u+8MT4bkmCopddKnwxI7AtD3I2rvKZlOc5/h+RIa2CUYCIN8gC?=
 =?us-ascii?Q?//U7FlSUtZABzqzX95RnNvyuZlMG1nc25oxWYM5laTXL2pgDMcZFKTe/MH/3?=
 =?us-ascii?Q?qo9GNCBNAjpWfwKC8YwuI0LirYlgcZ4Fe6UquNnQ3YPN17xVZjs5PGNnLwVe?=
 =?us-ascii?Q?MF8duKtZZj3Q5D/dWwJrmp0rX0GSXNDkcCMwpcN33W4CM5WXe7SEoZy93x2s?=
 =?us-ascii?Q?qapQUmKAB+xQP4a/Br5kcwpf32Hr/XM4+tGksP3eb+N7zuEKpuM/rv7zcqjX?=
 =?us-ascii?Q?7Vt/Pae6sPuqIZEIYCJoonrgh9xguB5DDyXIpgc8wur4CxId9FAj6SnTHjLw?=
 =?us-ascii?Q?GeCFIj+b0kRBlmNiqI03EgalEnBaYVrBDZA6d99yn5mS7yxXXhAhktcyqqtS?=
 =?us-ascii?Q?swXQhxES7hXI767xtuh3prN8IXXcgWIEoka4AUGSU/s33AY0LDRaHil6wQyd?=
 =?us-ascii?Q?DjIDO9MJbzfsLZ0LuCGA1QV/qNggsrXHpYJzvoer8TR9hlh4lI6sP5NplkDd?=
 =?us-ascii?Q?3i9vKUy2MBBnWOZvCqaggPkADrnchNbPv3bEdT4vE49cKKs2w6gmKba9YYcb?=
 =?us-ascii?Q?zJYcmvHKjHrM8GLHtnB72mVB8HK6tL3PF07wLo12Pvl8gfVJ931p1DbBRkxW?=
 =?us-ascii?Q?uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F43ADDBC37C7D141A7396747927E9316@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CmFvHxwF3exhT1rPXzMhbZ8whjUp+44lYEal5yKUjzUsgtiF3J4OXdYvOCiZleLfraoXz+3xyEvYTbECScDumoetzHdvjgi7l2GIZqHmdrjqzPOP9tIXSPCrpY081xdM9s7mTR0fJMUzWqpd6DE0UuZC7IGwdiNtjFAzh7KJSntkf8jY7Bm2CVgiZQ8PmiAAt/6IdHyLGWRoURzkinBzhFM7QLgaFfAfEOlCc7VQAdlWan76feIoxmYe0TrVu7xX+1WyWwN3qVb5IqHhsjx4obQhZy/fVt33ARByQl8LBVN1bdP8hlDAhqDQQmpe657t2RSvbLsm6lLn9H1FvC514L4+K/oC4Y9YzL/bQVpSS0O66SWGmpWGLTPK2brJ+aPl/BL0jF29J1i3kUePVyVurgAoAoXmKe7X+XrAm9QlnMgQlGsHc/APXngQANbmEMm1gKE65WINO+Bn31lIP7ECuFcaEWNJQpzyMfeZeBxRA0/miCnHWpb7Dbb0jdqqShp/9tKgBmfJswA4TYyxEjfMVXonOIcy1oipG/82JRKrRmjCMF122GbCFwloWEYPvkFz8rCBaPfP0F9ABjEPrSl5wPHfVQLewXw5Okgm9cvPSe7O+xleHBLVJ/sbVPkWQ3rlaWceEbY6sZqiATY2JNeWhFw5uqDoSpSz0AyFJsRNxQOVbH2HXg0sVgd3SBW7iA1Tdw+D140sWkO6ZJ4M0gzRYEoyNk7M2zqwpFREQGTu9/YKWzgE1vQLHG4n96W3IywbJRnFWtwPcID8YHb1OLS6jBD7dZGRmhatAYl6tIzw9BE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55a472f-bf14-44da-1596-08db53062081
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 16:29:58.2769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: myfT//c53+CqlnQ6ApVNpTIvmGYgU6ANx3q9EsDHICz1fNqCXz3VJf7MpbRZwMEH/xg8bsIaY74FYG54Kfx23UrtsIIZjSr9VeUJlA84dWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_10,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120137
X-Proofpoint-ORIG-GUID: -lKsSQF8plomgVnClCzVAWHY_67P2m_5
X-Proofpoint-GUID: -lKsSQF8plomgVnClCzVAWHY_67P2m_5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 11, 2023, at 3:02 AM, Gleb Chesnokov <gleb.chesnokov@scst.dev> wro=
te:
>=20
> When target mode is enabled, the pci_irq_get_affinity() function may retu=
rn
> a NULL value in qla_mapq_init_qp_cpu_map() due to the qla24xx_enable_msix=
()
> code that handles IRQ settings for target mode. This leads to a crash due
> to a NULL pointer dereference.
>=20
> This patch fixes the issue by adding a check for the NULL value returned
> by pci_irq_get_affinity() and introducing a 'cpu_mapped' boolean flag to
> the qla_qpair structure, ensuring that the qpair's CPU affinity is update=
d
> when it has not been mapped to a CPU.
>=20
> Fixes: 1d201c81d4cc ("scsi: qla2xxx: Select qpair depending on which CPU =
post_cmd() gets called")
>=20
> Signed-off-by: Gleb Chesnokov <gleb.chesnokov@scst.dev>
> ---
>  drivers/scsi/qla2xxx/qla_def.h    | 1 +
>  drivers/scsi/qla2xxx/qla_init.c   | 3 +++
>  drivers/scsi/qla2xxx/qla_inline.h | 6 ++++++
>  drivers/scsi/qla2xxx/qla_isr.c    | 3 +++
>  4 files changed, 13 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index df5e5b7fdcfe..84aa3571be6d 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3796,6 +3796,7 @@ struct qla_qpair {
>      uint64_t retry_term_jiff;
>      struct qla_tgt_counters tgt_counters;
>      uint16_t cpuid;
> +    bool cpu_mapped;
>      struct qla_fw_resources fwres ____cacheline_aligned;
>      struct  qla_buf_pool buf_pool;
>      u32    cmd_cnt;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index ec0423ec6681..1a955c3ff3d6 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -9426,6 +9426,9 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_=
qla_host *vha, int qos,
>          qpair->rsp->req =3D qpair->req;
>          qpair->rsp->qpair =3D qpair;
>=20
> +        if (!qpair->cpu_mapped)
> +            qla_cpu_update(qpair, raw_smp_processor_id());
> +
>          if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
>              if (ha->fw_attributes & BIT_4)
>                  qpair->difdix_supported =3D 1;
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla=
_inline.h
> index cce6e425c121..a6e2c7d4ff87 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -538,12 +538,18 @@ qla_mapq_init_qp_cpu_map(struct qla_hw_data *ha,
>=20
>      if (!ha->qp_cpu_map)
>          return;
> +
>      mask =3D pci_irq_get_affinity(ha->pdev, msix->vector_base0);
> +    if (!mask)
> +        return;
> +
>      qpair->cpuid =3D cpumask_first(mask);
>      for_each_cpu(cpu, mask) {
>          ha->qp_cpu_map[cpu] =3D qpair;
>      }
>      msix->cpuid =3D qpair->cpuid;
> +
> +    qpair->cpu_mapped =3D true;
>  }
>=20
>  static inline void
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 71feda2cdb63..245e3a5d81fd 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3770,6 +3770,9 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
>=20
>      if (rsp->qpair->cpuid !=3D smp_processor_id() || !rsp->qpair->rcv_in=
tr) {
>          rsp->qpair->rcv_intr =3D 1;
> +
> +        if (!rsp->qpair->cpu_mapped)
> +            qla_cpu_update(rsp->qpair, raw_smp_processor_id());
>      }
>=20
>  #define __update_rsp_in(_is_shadow_hba, _rsp, _rsp_in)            \
> --=20
> 2.40.1

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

