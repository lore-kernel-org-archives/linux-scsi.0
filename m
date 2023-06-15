Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E20DEB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 00:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbjFOAh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 20:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjFOAhZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 20:37:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B5310A
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 17:37:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJko8f011566;
        Thu, 15 Jun 2023 00:37:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pANOCySSWgVZBTJ2VVwxW0eqnolXE2qNhjiVW0ILAMc=;
 b=N6p6dMKFH36VASvCnTIxEmaYGSy7I4oRxTXLBwbzvpwj/du9g4RnxIW1LEFFewHJs0MF
 MxXFbDxAcAZ2ZRAnq0T1oZfuAhbGz8ZoJRiayze0BL+iP1vXLAHwWeJmEIL4HQ4ZzOev
 vZ5R2BuWdSgAopflHMe+Xji+444uJXuH0gqJVvigu9Zj7+aI/IptQ0p10PuUvQLwruXa
 yStZJpxRhvTVQF4gFpjFHfUfr3V4RSXqSIwx1ZcjcgEPgRUc1Vux2j6Vv4QDf85RQlEi
 JX+MqM4NFlc3pZXCcvGtfgIysaopcNkGZLIgknvMU6fQsF1rw3PWWwrJnkOR8e6mNKyU xA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqurv28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:37:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENdBdA016265;
        Thu, 15 Jun 2023 00:37:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm69qhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 00:37:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmHwlBO3W/3Y63/Sw8pJcaOhJpTW7tCOwQLzBhJijzoFqlC3n8JuNjdmaS04/35SpQfqofxA4mqzNAwPnhuLcaxiaT4cUqP8jHsfzenNxHUSamav4gqcSympm8GEyoF7WAdoI3NHNg1x36kebFtuNQVKWh55YFSTQeq0uOSVk1P8A+/4lBCQwlcdpjWqSMcX3rGoPER902I71pyShhLwi6im8VaVP2e2yZkeacP61rA8I3rOaZu4YmxRkTN+f9i0hc8iRNbsjpypDfKQZtxsJUgkwX6w0Ev+/UNDvkMQs8oiOsBj3etr9OMxNgp6d3r/2SVcWroZ4ZAYucAR+Us0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pANOCySSWgVZBTJ2VVwxW0eqnolXE2qNhjiVW0ILAMc=;
 b=mCD/CB9z3oMcO4UYtVjfucV/k45Ab016gOb64GUs6p1NC7BAeE8nPwXK/4FISy1x6aSCG/GgCHC+ARNj5zj0kGE3PomX4UtldSlMirGDXM42j7jxytwoZrJWtlGted1tduOpvm5Fxatvo+0BR7jFRQWmxVEwNG4///Y03QGnu2PtohD+jNvPoax6CeV2Bj+ZZ/6LDaaIXUAHtE0lvKNV6vqO7fWvJeRlX0HNHAgmtoi1tamS1klv/1vnTSGuk4wmGSkZzrkIMwKyW/48enFxXYXIKBY9ZtlYVxyv2Mouqer/Gc221Nxj1jjv9Wk3zDR0tuXaIunzSiLs1VHFcGOE3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pANOCySSWgVZBTJ2VVwxW0eqnolXE2qNhjiVW0ILAMc=;
 b=msPyaU64SH71FoHRRud6mVTsof4/0fhcYNrMjJXILn4LeKCS5y2St7Ldg2KbUY/EAjVH2hf9Mz5bbuvF5n3a8QrKSuui5NAoVvpy1osMuA5saX56KiFFxxzzwXl/08JjMdUfbWUFf/Mf+7nfEUj3SIhXeFzk44Am/Cb6uJzA83c=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 00:37:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::d634:f050:9501:46dd%3]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 00:37:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 5/8] qla2xxx: klocwork - Fix buffer overrun
Thread-Topic: [PATCH v2 5/8] qla2xxx: klocwork - Fix buffer overrun
Thread-Index: AQHZmTStYOtEGk3kuUKaNQpWefZmLa+LEKMA
Date:   Thu, 15 Jun 2023 00:37:19 +0000
Message-ID: <D0E3950D-798A-47A2-93C1-8D273050776E@oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-6-njavali@marvell.com>
In-Reply-To: <20230607113843.37185-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|MN0PR10MB5912:EE_
x-ms-office365-filtering-correlation-id: 38256180-78b5-44c0-87dc-08db6d38ad83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SFSfFM/C00eiwGbRmJsLugI3pWkDISMgo7zJ2UwptPvRKVLA/EmaqVUGKIbmyr5XPIDfRpYgpQD9ENGAwABngdbxURmTCYpdBVTDyOu73/AWCZjhrTP/ldQnCOVd628raM4oqMWGoBrUL8Kow8xvmbxhCvXuP332+ZAto3zg67H8s09Fi3fRO7d49b5lOgnrjxTCcRu3qPFDIRSiXqoiDWawD7ojM+bPl3RDIaSRQZeJ1MDbRF6fUaPLkeiIg64e/gyyADF9tvOFBiZUzlzTaoOqRO1lUtu9MsUmf27Acd8zMtqA4waq43Wrd9OnLe52ETjNq7Kj512hOpVfcPUfE7Kq3jwu2WRlSGNxQYkRRn3n7yxBxmd9yfFmwTX325A3yAG6Vp9XYWZ3QVmma5S7bCNWM/XP1gIC6Np2Y6JchG9sBPvpwMc8GGsjTmMyjEnpm/vOtq4iwotNPR1y9Khj2LS+rv3vPwQoJa5jef5GXIw0KMSf3dTzEVo0Zw6we2zo4HPUHgAk7fdPhpIrzQjeA/E4jabzbPYDNgWA+vwlwphxR89UtonZGVuNmM5SOz6VQ8mYPC/mZANOa+aytUwM6jtW2AWBfHYVc3mS1onbJmiFAtMPvXmdt4sc8vPm1iFkn2pJIc3s12/EBLQHolEPjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199021)(54906003)(6916009)(4326008)(66946007)(66446008)(36756003)(66476007)(76116006)(64756008)(66556008)(186003)(478600001)(2616005)(2906002)(316002)(8676002)(38070700005)(41300700001)(86362001)(6486002)(6506007)(53546011)(33656002)(44832011)(8936002)(71200400001)(122000001)(5660300002)(26005)(83380400001)(38100700002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ad6VmVJ4eG679WKviF+l8tACPyz9oZw512kSKN4zXj1Yp7g1aw9xSbj7ViRa?=
 =?us-ascii?Q?OU2ZcJkTcYPpS2p4eYL6PYF07q2lEO9FoRnHjpCr6OaLztu3qcQwpgUjCjoO?=
 =?us-ascii?Q?5Q+6xHxPYlWCoBABUABwr82H5Qqr1Jo8/o4NKyivDc+kquBgaXovnFgPf3gE?=
 =?us-ascii?Q?cn/SuyxjKyuft/MPXRe3ngb4OgvofGjMZnCnSLybh05x5X5G81ck8x8XoOl6?=
 =?us-ascii?Q?m9MkTx1nLGa0efsOfBVinOcr9ekAXaCJ832OMx6mj08RA7z6wXLTTWkhJzaD?=
 =?us-ascii?Q?EWxYUOtgRnOhuIRoF1SfIKan9rKTHTb7+jQUMT8vwkcZO4TLyspOzQuT542K?=
 =?us-ascii?Q?lEc2Tu0xnmbiQjgVB6nTlavcHHv69YqK1s9dNLGs26wuBNVUwgctrmiZCU1h?=
 =?us-ascii?Q?cvFJKg3A6GkktGolrLgBd5gGowdG63jpKt6GWiOCNXJgc7xlAtqE9QzttVOu?=
 =?us-ascii?Q?/zbXNc8hoFdvoKpDvTxjjK8WoQLoNufXxB56eWM1EBljaGiyBUxWHkb3uxdl?=
 =?us-ascii?Q?8tgprBUf1kVBJIn9nlwRk4mRRYoDsf8H2cUqXUxxYpIbjopTQG832MOT/1oA?=
 =?us-ascii?Q?ZanxHpCpyLk3lZ65TXvnI3XtVja+Efj+a/P9xgEdM+nJQVuqSdG5JG6kJE5q?=
 =?us-ascii?Q?tS03WypUAoNNixoYUS86KuHHsfFn40q2oNhBGVDLjxnCUZvOZYMVF7pVO2Ce?=
 =?us-ascii?Q?29uIhqcTYpriKrM+Mu7ZH7pIPqS9rCVgtD9+qknUsNyBg+dDcPBWRWHFEgC+?=
 =?us-ascii?Q?BgZxMOJYeyVoAEfkZWn9+B6q2vQQgbLVQ+Jehyp5oK96bHxBevwxltt90U7H?=
 =?us-ascii?Q?iCMbjKVAjvbxVBtRAlA5GowhaLGPL4dFPPGKIM+ZCWzzAQtXMq9e3KcoqXN4?=
 =?us-ascii?Q?e/8nGSRUQjQ1WN2oGsujVDCHVoD1AvVDO9UcBp66JuZB+cXEKdpBsi8ZobLE?=
 =?us-ascii?Q?AyLUdULGPelbwIqWt/TOkdGGKX9+UavspTnWUAg4gJ5h2hQk3AoN0R3Ej6i1?=
 =?us-ascii?Q?ttEkNgAjgDD7yr7l98JMAyqUPFNhphZMgFNUEODSEC2SJwevtj7fqzOnGno+?=
 =?us-ascii?Q?oE4NU5wELqaaCAK9szdm6nNprUwLqylCo59rcn44jtXxwLKMVSskX0mVOD1v?=
 =?us-ascii?Q?/XK7E4wFj4gxTVVN9vbNU2zgmQP7dwANf7BpbxO3u5w9tJ/R/LPJUWwEtUsy?=
 =?us-ascii?Q?nKx9etXtd72jeZnoJg9UwbrfdUpsxL3iMyEx5BgGZ7AIds2RKPvODOer3nRW?=
 =?us-ascii?Q?PTuIsx2GX/s0BqxWxEyrwirJy39L93sWWHo+7JKQoTc9gHMfXgQ4BG0xYGzW?=
 =?us-ascii?Q?XQRD20cq36woWenWFrRBykjxpgMtA/crbE9eLJPGqIw/HW5AU96zRnRMEwVy?=
 =?us-ascii?Q?GlUOVbTf3sVFpkNvmVrq4Oi6n2NTXxF6QqoDCjcsrV8yGYM4IiExvmZRnD0q?=
 =?us-ascii?Q?KlrRgxO98x74UtJ3Ed/A95JmJWskoHf5UG+E93dX16cBg2TeLlmnZbzGUQV2?=
 =?us-ascii?Q?tJZnL8IFKao8sHxj770MoBNAEgRerpor/Vtu3x4EjDCr2Gz+asuNy/jsznhv?=
 =?us-ascii?Q?IvNPFrwNL1XzjxgP2Akl2JaKDjmu8v18p/aUvjZbeyTRvwgwcFr2angGKLff?=
 =?us-ascii?Q?5Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B496F9133AC4D04D98E4C6FF209117DD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NtBiuj1gphITcVCOn2YVLpCEbs00lZt3+/9NveSAth+3mRDIwRpzPAhK8yXP8hvt3Qtt/FTTAv7wfUonSeeOzboyTy/BYOoSbh7Yf3Gcm8yuM+8YHfTwb3+ykUeblth0LfRodasMdm3WZkNuaCM+PR6pSeVfJmNvrGWmAhDqjDMQseRsDggCBWRBVgRc6auyGF1GodbA1/AbFP/dcgMTe0ESFR/A4EnHiQxP68s5gTCiocNqiRz49m7aoZXWSbgC3YE7nPR9Vj5GK5GXndrQljVZN5PhUJT39ROO4KMO19f9RolgjuPJ0hX2MI9kKh1ykUdDjsRC7U/Yq5CY8PowOcsxBo1eQKU5DyJQ/sFaOkLxYiLjjswFgyzIefmH7ugYirZythzHfrB3yM65A5EtPuVKmTgsvYypQ+s3EayzV7ksojek/ql062hUzr4Mrs4kx5lTie4dNAEAevCC1alm1iVN4M+MqCkP2MMLUQJM7iGPg3IjYjmNk2XWkWhRGyIoVWwNFdW3WEUg9VaKQFBwRc6bCeF3oHr9r7gR8SBokQO442f+WqEt3Nf8ETIRH+eYXgaPLZS3zHp3KIfLLivSjN2aX/3H5q12uIIQVqmsEm00HQtrsRWms6EWForTefTmWxp5+GD2wNCzLwVeiCVrfn3jsA/3QmTmenczB7Plmgd0yAs8FbXmP+rwbVkMearvWAtZmb+hhWdcqeafoOq1v1BRR3Sq/6T8icLJPd2V2Wgf7A6CvHSlpVBXiTHRJUjFdfcmXWSILyQqd2lbyjNFGMhJSWlm7k4CRtMzLfWaCLg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38256180-78b5-44c0-87dc-08db6d38ad83
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 00:37:19.9465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6jb49wQM254m6cSFNsRDbaRlaOdsLdFwaNgiCfEk4zdQAfGNyxDA9sqDO+J+OPB87T5Vn5yjoUdMC1rhg7B9mx+XcS8BmW50oq7NdlPfpO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150002
X-Proofpoint-ORIG-GUID: n6V1vjTOoHnqu3q7ZslV-rvTsPiHBTlH
X-Proofpoint-GUID: n6V1vjTOoHnqu3q7ZslV-rvTsPiHBTlH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 7, 2023, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Klocwork warning: Buffer Overflow - Array Index Out of Bounds
>=20
> Driver uses fc_els_flogi to calculate size of buffer.
> The actual buffer is nested inside of fc_els_flogi
> which is smaller.
>=20
> Replace structure name to allow proper size calculation.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 0df6eae7324e..b0225f6f3221 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5549,7 +5549,7 @@ static void qla_get_login_template(scsi_qla_host_t =
*vha)
> __be32 *q;
>=20
> memset(ha->init_cb, 0, ha->init_cb_size);
> - sz =3D min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
> + sz =3D min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
> rval =3D qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
>    ha->init_cb, sz);
> if (rval !=3D QLA_SUCCESS) {
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

