Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F01C4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 17:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiLORlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLORlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 12:41:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA32012D15
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 09:41:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn3BK029712;
        Thu, 15 Dec 2022 17:41:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=b3xWCuxW3ySdOP0scB4XcesGhGuzczcre+untoBGmFM=;
 b=onA4xJiegF42rN3LssUsR5MsJDx872OGTNqaeuyvClO9QHUWv8lyFfgzRZ2Bk4ZM3Xoa
 f1+SLq9IvmfdDfH4J/3qVvSsSXpSP2+A3iu85BZPazDEHVcnlY80hLxbRdIcprhySfYy
 xJeVdJiTOKQruASqogKNRs+rlPhqZcZjHpD1BnbqFBPEnwRw5bAIjVTXHvqiJ6FwcMNo
 9IsLtVLO+nS6YX6uQcWjgpcPGdw2R07gxNX8NdTRNuZGCLmuWwJJcMF8muuTRVsKIjxQ
 PimlgLAA7Osjs/UM04u2jh0XLldHLplneKlp+NC2068mrUjK+AL46FhNBQToSNBqgOMn 0g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewwrjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:41:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFHNlUo011349;
        Thu, 15 Dec 2022 17:41:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyew4g45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:41:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgEpcQNdA+kxkwD3rykxW7I3uLIggFrC5dsY0jhdYgviql1d8D7TIsbI9aqcRxNb8Ennu5v5TOv72lDstFcdP3sEEnWGJhzNlDuuLEWdaCMMJkjb3H56KjZuX8Z9t6uIP9VOy9Phba0knt9dWJ85D9srs230JBeJrvNcXQHdmUn+/ytsMEN29zLjBMRtdrB6qakF488Idw0YNj80pWsKVzj9+ZF7fa1fpshtUsEVwMJtQTWvVp7Gqc7HgPWU5x3C7pVflf1mRp4evn2CvBswNcomVe65ByUfk5tAkpsYWC4pKtBeNRQalFjYWQQjWHjjIOK8vbzN3azuWhMKBGJyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3xWCuxW3ySdOP0scB4XcesGhGuzczcre+untoBGmFM=;
 b=dNzfIcYJh+OTun9JPFP8DAvzcG7pDt6gwTPMKEkSYCcnjGCIk9JUJDikHZbw2qjzp15BfOeI976g9A1rai09UaS5CJBd5lhxd60OGBK6DtjpriN9ShGwsSnXe7vAoC60nclM/ANgWyJ+BiORiMQZv7z5GMB68K6TxXl6URw0pRofxme/Jv3W8hPo6onnIkGhLbowdnkntXeokbUZyrgQHPMCFW4y/vpPDa6IObJzXaRbSZigFDQcuc0a0AmLpibC8ax3kXpB5DvQn5L4teEFsEODjkAfjOTaWxoaeVBZkGwGWnu33ov0RGWisoEWpk9NfSb4VH4UZerC4qmuS4dKiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3xWCuxW3ySdOP0scB4XcesGhGuzczcre+untoBGmFM=;
 b=XJ7ruBL+dyAqulsPeHO/LIN0i33sPqrZCeWjJ6QtgI1J4f6Qwwnu5h6iyN1MEDHBGe+xwzGT3/d9prWLxZK/aVfaqhUQrm0AhNjj6gIB0kMGPAA614ebo/qsE9/dGa1SQv/SINoVwd/cyFCfIpyvZXtH9OZdCvV/xN2vuZW+JqU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH0PR10MB5257.namprd10.prod.outlook.com (2603:10b6:610:df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 17:41:12 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:41:12 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 09/10] qla2xxx: Remove increment of interface err cnt
Thread-Topic: [PATCH 09/10] qla2xxx: Remove increment of interface err cnt
Thread-Index: AQHZD3etMurxH6Bbu06d8wrqOyvJp65vOeeA
Date:   Thu, 15 Dec 2022 17:41:12 +0000
Message-ID: <914D3973-BE78-495E-8EFB-32117D6F3B3C@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-10-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|CH0PR10MB5257:EE_
x-ms-office365-filtering-correlation-id: dbe318a5-a453-45a6-b8c7-08dadec38f01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QcrY+DPTZ97HWIg5M6M+TIttCfoMXO3D+Z6EZhGA3h+fnH5iNo72fJJOADa1U/DbrDdROjNDdNWntUzGZ9WhBAIu6u9q1zjLdbfu3ohsxHokK0cqrIKPrIULtc65J3hgNdLfUb6lGz5kSaY8KKBmD9VSvQ96LV9aQdzyqW6X+IPhmNsGTV8Fw/UDs8/vmqtHev2oHw7tB1H7C8RzRSoJWa4+y0yKWrWzH8V9mD/Gnjr57U5BYsi500KpqYCjokw9y6wnzHgVptqlaIjeOCmiHTMXF6uOcYYlMRSLnAp+LW/d2gAtf5zP0Woc7snpYkXPHjp5RguxnAOLHa57nBXQiPG//vaqfdBqblHlo1QcBqCctaEC+xHTgXpt67Pa6ZiZogDK6Wc4ZSeUD8e6eG/T78I+F6TcKSDC2lAAxy+mS0iVPmv/p5yYNTHZjRV3Y+hrlllsjTL16qOrCFe2kT8wxeQOinGzWjUNGzoiQMjowNuajAZwzkrlJv2qV15nsDE720qCGfziV8I3lNJ0WuU599lvLl512Vla4jozoHnCD/0trhf4p45WLWWG+BslUTeC3bfAwluM9r+3jPWk4cSngAV02xUxf1PWJ6zAhlRsGUmhFC7jfjUaX33EGGqLBknxK5j6QbGCAYDrMeiQ+6L5FRHawKBvj1yiOCyzQfBE9MIrbEualXgnZwSERYe82NWvbETmvs+Eg25ej4OoiinhfmhSeO9G3/537vrjG6Qxmfo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(38070700005)(8936002)(54906003)(5660300002)(122000001)(6916009)(2906002)(33656002)(6486002)(44832011)(316002)(41300700001)(6506007)(478600001)(53546011)(66556008)(66476007)(66946007)(71200400001)(4326008)(64756008)(66446008)(8676002)(36756003)(2616005)(38100700002)(86362001)(83380400001)(186003)(6512007)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jKETMer1ipDAOfFgfdc3mE7q4ADtu7kWjhgepkP3Swy2L8L9eC7QdOm2pjCR?=
 =?us-ascii?Q?ueyILBCa8MEGvwXwX6dHNyXu4hezdY6BOW+GrbL5kV4CvsToNayaHIXzfvd1?=
 =?us-ascii?Q?JX8GF72/7kPfx7ol0CQW+9JLtzbRPmyIcc7E9jFnasU0vsar2zEDYBFBpnwG?=
 =?us-ascii?Q?1hU3+Sqfgl3FmoClXmYLigNgrSwPMpsFq92ODtdpQsz7jLlwC+RR1ricp9kc?=
 =?us-ascii?Q?PAmLQSC3muiq1Kjg96WDtebWF/MWIU26EbToALxisOpFQrM/tVvbKk71GcJj?=
 =?us-ascii?Q?+JXVkvxG5LzOmg25KYSfvad9p3EAP4Bw7s2Mms3hh+ff0ts8JYyRcSuyX/9S?=
 =?us-ascii?Q?/YWur1RKMzbkgO33nzVouhVNWTT4Bmw60iIEHj3ViIiysGEYt+GfQpNlG4us?=
 =?us-ascii?Q?y76qAMIAdxMoBM66VgLx4euAPSg/IOPhdWYljyujWljED3i6cHVSYeaeKFy6?=
 =?us-ascii?Q?+lgcNVCPThPmt/59DzwCzS9cdZ/ln1sGYSZfIfgVpF3FiuCx9kXOQI0RfZFl?=
 =?us-ascii?Q?Wqc4qRepVKZi/jS/1mkOem52XtZlyBKzqL2BTFwtPWuHYAraaXH8E24EO4rU?=
 =?us-ascii?Q?4RlyotNcptQKFEYfrzKsfqkw04RaIg9R2lTcpa224nw4ylYPPxUSbruAgBhK?=
 =?us-ascii?Q?l2iFGDs9PozP3EOM8bq6mN1OJUowktMCJOAZ3iKlm39kEN+19z9EgpOuxRte?=
 =?us-ascii?Q?5TVvNdefZoPpwtmDBm4BRUg4tLmc92LwXKK3n/F7IiGMBKtvvtDgjiT/gXdZ?=
 =?us-ascii?Q?EW/dqQWKV4eDed7Npyo6jni0goDuK1A5DzjRdhrKVeNxsfEKz2R0F+rLGb9n?=
 =?us-ascii?Q?vp9Cg7oXHNt22Zc9pZB+16T6co+baZAcRwiBBHjnk3lUboeKFnOUxs5IeN/R?=
 =?us-ascii?Q?FkGaAQO+GhxCJv/QJUoPXR6A5I8Yt62BGkeA2UmO6m2oL8eGfQKXO5K+LoR3?=
 =?us-ascii?Q?rKfT8FtGYtJnoRQQnTGoZiA9Me69+iqk+OuVyn2x2VwOMA3z9My0aPBPoRI+?=
 =?us-ascii?Q?vHAKvni/T9qQJtCgF35tmLWB844sgee+YCOxpReDrJUI6Sko+MtqN6WbB2JW?=
 =?us-ascii?Q?c9cn9Ko4DIY29UGvvcZ+eHW7VzmzOlm065XU7ui1rK8KSzcEisrAvZ4ZXg2l?=
 =?us-ascii?Q?4OpM+IYpk3Wk1KhOVsJ0YAvtBy3LaNCnBh7YIX2VJZpg9VgRj0DW//iCdoSe?=
 =?us-ascii?Q?auBXEOlfDYBwYmmCxEOF1iIkE3Xh4zFncO35FOHkst8pOnIyooboJW0UNzQd?=
 =?us-ascii?Q?aaCOM9FiENKhGuDWN7uyr9g+HxbWaFovPw+bMcRUn0vta8vrBomcPU0+qZ5G?=
 =?us-ascii?Q?YnHwWr/VgW3hRX+jxkkyu6o94J5lWCF/cKaX/Wbvbeq7sofJSuTlCn9iUudh?=
 =?us-ascii?Q?mxxCCJqEyIdeLqwu8EL7garEGHc6C35GuWpEDTTVMuMLRm/KPdXzdukV2iQ1?=
 =?us-ascii?Q?j2RHIR/gJdpPigV6Ihqq4f7zNyno3GSGHaYPvn2DSK1wn12HfCJrTomb/rYL?=
 =?us-ascii?Q?47zVkcf5OeVOA3PMcKAvU35+63SCZpVVLw7MDRZGKxppfX3JvHTXJvxeGj0G?=
 =?us-ascii?Q?blU1GvNHTdNlWVgiKzzMW/M50jAHYQltJTikBQHejNT/wXgbPLdHKgFCsCJ3?=
 =?us-ascii?Q?XPcVFEtNIIjF+HjHrF+bWY1Zit1FnLpIW2bZwrXyEA2R?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E32FBB6F185B9049B9C2E58164AABC3F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe318a5-a453-45a6-b8c7-08dadec38f01
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:41:12.5277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dgew39zxUc0RPawFtkTxT/Y33SbqmK+WyJi3mw3rTD6mD9Umw2J2lRTr4o6w6m3IGz4DOWpmfUybZ1BL6DKcVTK5bxOUvze8YXHeuSVbA70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150146
X-Proofpoint-GUID: wrSuuQBUyDYZBBzZDGUbFWPhpY7Tmae_
X-Proofpoint-ORIG-GUID: wrSuuQBUyDYZBBzZDGUbFWPhpY7Tmae_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> Residual under-run is not an interface error, hence no need to
> increment that count.
> Remove increment of the error count for under-run case.
>=20
> Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage hos=
t, target stats and initiator port")
> Cc: stable@vger.kernel.org
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 2 --
> 1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 759bea69de12..cbbd7014da93 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3363,8 +3363,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct r=
sp_que *rsp, void *pkt)
> 				       "Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
> 				       resid, scsi_bufflen(cp));
>=20
> -				vha->interface_err_cnt++;
> -
> 				res =3D DID_ERROR << 16 | lscsi_status;
> 				goto check_scsi_status;
> 			}
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

