Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93464C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiACAwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:52:11 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41556 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:52:10 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029CSHt008576;
        Mon, 3 Jan 2022 00:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FjUsMm2cgu4+PJhfDYEvbViOQIhJvr5kR97fhBu7sOg=;
 b=FeDNlDGoyUWIzq0Xb5HPzhql7jYrRVtgL6li2rHwwFZFQc3apLiENRfI9xhwXGmHo0lF
 lNuCnyVO/ppWikHINmYowmnHhxc/ajvIUnGm1KiIG++qZL+mLnWXDCF9/Pz/jHAPyskv
 HZARutS1FFt8FqcvwLmD0b/S4km39mD024QZ3aqEepe+u58wZCix0bRJfOV/hqsHLs2r
 uw9uZCBHjOwEW3zjlptzhZKfmd0I88coMxJMGveikRuG1rFFVChoF/dslSS8IledBFKl
 BEYMLAFcYVI3rKoky4gWzVVW7g4lSMEbfASoyb1X0dl6DGKzuhG3No5VfmyVLr3SwdEc 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daeuahpgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:52:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030p8gf194641;
        Mon, 3 Jan 2022 00:52:08 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by userp3020.oracle.com with ESMTP id 3dagdjv0vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:52:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PX9Ixnjt8ZWPILKFtuoRTCiM2lusfkWScqG+O7bpJ1OHzgTfbYdE0+dDNsf6ZXIQy5VT8dK1QG7yf44LKj863fNaZI82XXOkCC98ZIChJumnCyRjG4z3XoZunypM9h9tP6dzr2yW6wgo0SRwP4EVDkrcYXzJCrdTfGPlL7jnmFtN2XC+MMWu5gl2zp4dCheTctxFn1kQlcjlaRcT4erlrrYyQImZ1IjiCq2fJ6pi/mY+nGhiHP/ju9+oEF1GZB7sS7IcbriPbTnETcokIvjPubIOjU3IXwE3tGF0rYSOCJWjnXKiKnawt8X2Cv9nhWRQ6KU67etyAFFPZb+plcBkcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjUsMm2cgu4+PJhfDYEvbViOQIhJvr5kR97fhBu7sOg=;
 b=LoG1tjtCTj88+w6Kk7Skt1pEKj66GGUPPmfSN7/DG7n4XQd/xS06YO6toPtJQAMhwW1h+W03x0OGKnMiyaEKZxj5fTgi3qigoFC5SqpmPw/affB3KLkkUbR7IkxW5qwV7LU8Y7XXFWifojZjIG6JTkF95yos6uqlV4nZQd3vmDOFyNcvVlMK1/xLwfnWQPEix0ArgfhuJy/P9ROtoysw2uWfvT5Wy5sFAkz0kqlw867iNV9RBtdz1YE0d6pvk4AXKsRlPxK/rj19KGgHgjA4QVpvR77gg3ezbb94v5N4jho+NzodzgDzKh+Z5c9h4h9GkjpRdQkYcMnTYzpXfEO9Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjUsMm2cgu4+PJhfDYEvbViOQIhJvr5kR97fhBu7sOg=;
 b=n9pTw6Vxgvh6GwqujbgYQclK0zAWFsYEgym6GQIWkFaww1mCmwHvLey7bwRjzVNRl7F7RUpvJ1RuRF3idhTXk8y0dVo56HpGe8bvjfRtXwPx4kXtplDI+nENTl8VabZPv2K3Y6YBy9mYS5oefO5+jgtEjLrFJLnNQD467NAZNp4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB5710.namprd10.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:52:06 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:52:06 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 14/16] qla2xxx: Add devid's and conditionals for 28xx
Thread-Topic: [PATCH 14/16] qla2xxx: Add devid's and conditionals for 28xx
Thread-Index: AQHX+JULeFd3ykfAvUadCsfyPmaytaxQhxaA
Date:   Mon, 3 Jan 2022 00:52:06 +0000
Message-ID: <46AAF253-04F5-4B3D-AD45-FFAE1FD43D4F@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-15-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-15-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25e062c8-4cf2-45b8-97a3-08d9ce5343eb
x-ms-traffictypediagnostic: SA1PR10MB5710:EE_
x-microsoft-antispam-prvs: <SA1PR10MB5710A3D7DB96AFC2AAD3E4B4E6499@SA1PR10MB5710.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kIYTceZ7KG1NnyKNBYexOsH+kcgRFr6dBr/4iSxeRGhJhxQaZQ/4EWpHG/SYcf3T3WaapF4Z2reccTm8qIUMZuc1xD15gKUoprXPgcZQ9o+VuVg2MWykJowPaSK5THqlPsCzXiptUkixUI6PAA7hI5D8MlPTcJ3qzwRnUvHzJEeguqlXSthKrptrdf8PGcFCPzd7KAwIW+Q3pkDqr9xvUsAMYEYBAMPoJw12Msyk7DD8xU+SW0iYjvAM5ttjopzPRJR6Y7yz1+iVzfELK9fi1KJF4wMlIzVcSAd4x35ZPbKxDvxEpFB7gy79m8HLgsY/zJdQ+3327r3o0lSaJwGqfF07CnZpBl/avQrycgsbAiiiJqIgMBPYV+m1wA5ZVk/CjNe+Z+l/1la4HXY6XlkV+27i/yI7iFS/kQTlU/9YJz/NmcQaUKBEutjAdk/jpErsiNUBGbUC6hKsQcgVLyw22t6hlvLbuaXZmAa8Z8mRrNSmpHigSRHGapfwHQw0RCBRBLUCyrUhSHB9L8aAbvE4SlmE95T+QjAEBLTzS8XPyQrnE+sgkozFg89sDlFcE/4GnQo6s5noMItU8gHGiO7aeZ8Vz1mc4/B+dYZUzdI3pLqQ/aAMklKj9e8ZOfiSyWxiLwvamSqn9varhhImkRJJt1wtwU2I193Ng9vGF8lUFWPeuUmk2P3Zm3yPFNL/E2MXmBosZXR9AbeP9vzz3/Z+wQYjsw1uFC+jiYpErGnaYGc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(71200400001)(122000001)(64756008)(186003)(66476007)(86362001)(8676002)(26005)(2616005)(38070700005)(6512007)(83380400001)(316002)(53546011)(6916009)(6506007)(66946007)(66446008)(76116006)(36756003)(44832011)(8936002)(2906002)(4326008)(6486002)(508600001)(66556008)(5660300002)(91956017)(54906003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g6xgQqu3xAHIPg+R3TS8TLedxunMYadhjwqrbypDOKnTZ5fyHdns9i1dABAZ?=
 =?us-ascii?Q?mi8YaZ4fZE13r4Fc2qo7tCnD7CGNvdxuS6cIM1hAKYNxwuSTEeCdJVRIdF6z?=
 =?us-ascii?Q?55fXnvsKvVcnH5nJTpPxZVftqrYqUrhVVDNf2/oqFvAgZnZQVJDgeQ4CRZXD?=
 =?us-ascii?Q?dwhDWG+iziwJKAWm3CrPvlllUJF4LecRkwM+hW7ZCq79C1Dnk5YUIAkgkIZm?=
 =?us-ascii?Q?rejwJOYL5M2vo91LqR1uIyI+SoriCFkTC3GekyMWXOwOaR9OfAARYj30zt9E?=
 =?us-ascii?Q?nDJN+H7pa3qe7dMAZHR1QoEKn8WEzoM6ZvqHvX0wxXCPKCrx2B4JdVBQEi1t?=
 =?us-ascii?Q?tTmYwvpz0VgYiKm7D+vlOdDH8PV22BhstxAuV4+Zxnkrnh5ESLOkVncP5T+W?=
 =?us-ascii?Q?Hk/F8vXTaWbXDy316zyJ80hngV5KklwFhtQa+JKHyeLjlG3qOPCh+80tN8gm?=
 =?us-ascii?Q?ITfW6hz6OBsuEZEz6EGhWouxTYhfSXpgUwa9MFTDTy7Bw4AptnElABFDm5Nn?=
 =?us-ascii?Q?I04u5mV0+YbAhn7JMFJQuHhPJyTMtraxB/Zpd6M9IpKahhCEgfzAGyi7KT0d?=
 =?us-ascii?Q?8IdZzAUkOBJnQaAyBMVJRtCXb0G/IRProRxbCtC/WW+F2cvdso2GwHlsy2Mr?=
 =?us-ascii?Q?1V8DTJGfN+Nafb2g16IPtkf/486zpqIV8ObXRBvq7ghMtuC6+O23J4rxNhXO?=
 =?us-ascii?Q?cE8NE14JiqQ+LGCcFuoJbBhGxlN6sg7WHWkD4vkfnLKtgxY6rffbfT3QTB06?=
 =?us-ascii?Q?cAqb5QPd+o4dTxrmbnEc++IFKxwOnO6yQrJqPVVbRNXd7Cy6eEW1Y6uIqhUx?=
 =?us-ascii?Q?Y0uJPzmxzMG7RsGJkEcyl9RsauHo/5aRM2Q/e7V7XZIomgVlB4PHOfvgsTCP?=
 =?us-ascii?Q?Zx8oFHsnDFcGiLDqdiPdrS6RJ5y+UrXwV4ZDGvPAufXUpFrtIHjjjpHH+8KA?=
 =?us-ascii?Q?jPSgj9PeJ9MdZOysUay48WPrhk+i98uoO8p1pDFgr86xwIIvjIRYUXQqMiRm?=
 =?us-ascii?Q?pGTbTrpH4O3fvvKySUZxDhB2K4J64bQkC2VW41Du0+QZJLNAAFkuBfk6U6vi?=
 =?us-ascii?Q?33qfMK8MIdFo1dLRXNcR1xOkkvLY2WcswjiDKbXspEdmzsEpIVVIBre90kQF?=
 =?us-ascii?Q?YLXwahnaloC8+jYZNRY6nA5FjqnyyhRJL/iOTL5ySmq9NAy41Bla7fmgadkB?=
 =?us-ascii?Q?2Hojk9dIFTomyj1yNIQ3IrujSzxhtJAhQwVnJfhodTKFlnXbsofAuwynGYLW?=
 =?us-ascii?Q?nlpDWQLhEaMNLNnU328znc2aUUhR3Y72vpSlib+Bg7Vk2BaRFUrSpnGxAgLC?=
 =?us-ascii?Q?p7DXTyGuc5w3cay/oV8EbBvNgp0SCpBhhrmtXeKPvJevev5/OJTsWINYnbaV?=
 =?us-ascii?Q?cgruH0pEdn0xkrRo8Yejzg67BIpKmyUHRvjzI8qfmA+G66afpo38m/hy7/AJ?=
 =?us-ascii?Q?IxdtNrmXm5jrSVLL33uUOxsH6wrOD+ATySbFn8VFdGHUVDvprGn0wxP6Q6Is?=
 =?us-ascii?Q?IVVhPhZNIwv7B63rhvdbVXJ/D6Kw4qmJlbxRSRUtOgCy+dbWs6aJW//M222h?=
 =?us-ascii?Q?QvgiUhIEi62AfAvJEeIJ37Jh3cq4Qr2peLYB49Bx4xR5IkjpZxzagya5+82Q?=
 =?us-ascii?Q?UJqk3Olms7qfuJkW5QUoZ3MN1lQKYJYS0sXxViA/zNyX8CwVowz/N36ZkW2H?=
 =?us-ascii?Q?ECPG6LhWhwEARDltIlCcS/phUjQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D95DC07612A0734FA2DAD495F0835657@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e062c8-4cf2-45b8-97a3-08d9ce5343eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:52:06.6444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /TL2oRLZstzVLsh01X0nWFOxpFITFmNLCAJNDl2ciIBl99DMYPiY0OK7nr0Nj3zo6088BxnJSe0G/dvRbZ4Z9WBeDf3lWvk9XBzoH45xfgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030005
X-Proofpoint-GUID: l8BOtQ4bhtXK2gGnFPmO8EU35BAJ2Bhq
X-Proofpoint-ORIG-GUID: l8BOtQ4bhtXK2gGnFPmO8EU35BAJ2Bhq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> 28XX adapters are capable of detecting both T10 PI tag escape values
> as well as IP guard. This was missed due to the adapter type missed
> in the corresponding macros. Fix this by adding support for 28xx in
> those macros.
>=20

This patch seems to fix more than just IP guard macros.=20
Can you please seperate T10 PI fix with other fixes from this patch.

> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c   |  7 ++-----
> drivers/scsi/qla2xxx/qla_init.c   | 17 +++++++++++------
> drivers/scsi/qla2xxx/qla_mbx.c    | 17 ++++++++++++++---
> drivers/scsi/qla2xxx/qla_os.c     |  3 +--
> drivers/scsi/qla2xxx/qla_sup.c    |  4 ++--
> drivers/scsi/qla2xxx/qla_target.c |  3 +--
> 6 files changed, 31 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index db55737000ab..3b3e4234f37a 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -555,7 +555,7 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobj=
ect *kobj,
> 	if (!capable(CAP_SYS_ADMIN))
> 		return -EINVAL;
>=20
> -	if (IS_NOCACHE_VPD_TYPE(ha))
> +	if (!IS_NOCACHE_VPD_TYPE(ha))
> 		goto skip;
>=20
> 	faddr =3D ha->flt_region_vpd << 2;
> @@ -745,7 +745,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct k=
object *kobj,
> 		ql_log(ql_log_info, vha, 0x706f,
> 		    "Issuing MPI reset.\n");
>=20
> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA83XX(ha)) {
> 			uint32_t idc_control;
>=20
> 			qla83xx_idc_lock(vha, 0);
> @@ -1056,9 +1056,6 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *vha, bool =
stop_beacon)
> 			continue;
> 		if (iter->type =3D=3D 3 && !(IS_CNA_CAPABLE(ha)))
> 			continue;
> -		if (iter->type =3D=3D 0x27 &&
> -		    (!IS_QLA27XX(ha) || !IS_QLA28XX(ha)))
> -			continue;
>=20
> 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
> 		    iter->attr);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 24322eb01571..87382477ff85 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3482,6 +3482,14 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
> 	struct rsp_que *rsp =3D ha->rsp_q_map[0];
> 	struct qla2xxx_fw_dump *fw_dump;
>=20
> +	if (ha->fw_dump) {
> +		ql_dbg(ql_dbg_init, vha, 0x00bd,
> +		    "Firmware dump already allocated.\n");
> +		return;
> +	}
> +
> +	ha->fw_dumped =3D 0;
> +	ha->fw_dump_cap_flags =3D 0;
> 	dump_size =3D fixed_size =3D mem_size =3D eft_size =3D fce_size =3D mq_s=
ize =3D 0;
> 	req_q_size =3D rsp_q_size =3D 0;
>=20
> @@ -3492,7 +3500,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
> 		mem_size =3D (ha->fw_memory_size - 0x11000 + 1) *
> 		    sizeof(uint16_t);
> 	} else if (IS_FWI2_CAPABLE(ha)) {
> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
> +		if (IS_QLA83XX(ha))
> 			fixed_size =3D offsetof(struct qla83xx_fw_dump, ext_mem);
> 		else if (IS_QLA81XX(ha))
> 			fixed_size =3D offsetof(struct qla81xx_fw_dump, ext_mem);
> @@ -3504,8 +3512,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
> 		mem_size =3D (ha->fw_memory_size - 0x100000 + 1) *
> 		    sizeof(uint32_t);
> 		if (ha->mqenable) {
> -			if (!IS_QLA83XX(ha) && !IS_QLA27XX(ha) &&
> -			    !IS_QLA28XX(ha))
> +			if (!IS_QLA83XX(ha))
> 				mq_size =3D sizeof(struct qla2xxx_mq_chain);
> 			/*
> 			 * Allocate maximum buffer size for all queues - Q0.
> @@ -4065,9 +4072,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
> 			    "Unsupported FAC firmware (%d.%02d.%02d).\n",
> 			    ha->fw_major_version, ha->fw_minor_version,
> 			    ha->fw_subminor_version);
> -
> -			if (IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
> -			    IS_QLA28XX(ha)) {
> +			if (IS_QLA83XX(ha)) {
> 				ha->flags.fac_supported =3D 0;
> 				rval =3D QLA_SUCCESS;
> 			}
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index c4bd8a16d78c..826303f53f77 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -9,6 +9,12 @@
> #include <linux/delay.h>
> #include <linux/gfp.h>
>=20
> +#ifdef CONFIG_PPC
> +#define IS_PPCARCH      true
> +#else
> +#define IS_PPCARCH      false
> +#endif
> +
> static struct mb_cmd_name {
> 	uint16_t cmd;
> 	const char *str;
> @@ -728,6 +734,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t ri=
sc_addr)
> 				vha->min_supported_speed =3D
> 				    nv->min_supported_speed;
> 			}
> +
> +			if (IS_PPCARCH)
> +				mcp->mb[11] |=3D BIT_4;
> +
> +			if (ql2xnvmeenable)
> +				mcp->mb[4] |=3D NVME_ENABLE_FLAG;
> 		}
>=20
> 		if (ha->flags.exlogins_enabled)
> @@ -3035,8 +3047,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha)
> 		ha->orig_fw_iocb_count =3D mcp->mb[10];
> 		if (ha->flags.npiv_supported)
> 			ha->max_npiv_vports =3D mcp->mb[11];
> -		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
> -		    IS_QLA28XX(ha))
> +		if (IS_QLA81XX(ha) || IS_QLA83XX(ha))
> 			ha->fw_max_fcf_count =3D mcp->mb[12];
> 	}
>=20
> @@ -5627,7 +5638,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
> 	mcp->out_mb =3D MBX_1|MBX_0;
> 	mcp->in_mb =3D MBX_2|MBX_1|MBX_0;
> 	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
> -		mcp->in_mb |=3D MBX_3;
> +		mcp->in_mb |=3D MBX_4|MBX_3;
> 	mcp->tov =3D MBX_TOV_SECONDS;
> 	mcp->flags =3D 0;
> 	rval =3D qla2x00_mailbox_command(vha, mcp);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 88bff825aa5e..cff5e4a710d1 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3762,8 +3762,7 @@ qla2x00_unmap_iobases(struct qla_hw_data *ha)
> 		if (ha->mqiobase)
> 			iounmap(ha->mqiobase);
>=20
> -		if ((IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
> -		    ha->msixbase)
> +		if (ha->msixbase)
> 			iounmap(ha->msixbase);
> 	}
> }
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index a0aeba69513d..c092a6b1ced4 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -844,7 +844,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t f=
lt_addr)
> 				ha->flt_region_nvram =3D start;
> 			break;
> 		case FLT_REG_IMG_PRI_27XX:
> -			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
> 				ha->flt_region_img_status_pri =3D start;
> 			break;
> 		case FLT_REG_IMG_SEC_27XX:
> @@ -1356,7 +1356,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, __le=
32 *dwptr, uint32_t faddr,
> 		    flash_data_addr(ha, faddr), le32_to_cpu(*dwptr));
> 		if (ret) {
> 			ql_dbg(ql_dbg_user, vha, 0x7006,
> -			    "Failed slopw write %x (%x)\n", faddr, *dwptr);
> +			    "Failed slow write %x (%x)\n", faddr, *dwptr);
> 			break;
> 		}
> 	}
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index feb054c688a3..b109716d44fb 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -7220,8 +7220,7 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha=
, struct qla_hw_data *ha)
> 	if (!QLA_TGT_MODE_ENABLED())
> 		return;
>=20
> -	if  ((ql2xenablemsix =3D=3D 0) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
> -	    IS_QLA28XX(ha)) {
> +	if  (ha->mqenable || IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)=
) {
> 		ISP_ATIO_Q_IN(base_vha) =3D &ha->mqiobase->isp25mq.atio_q_in;
> 		ISP_ATIO_Q_OUT(base_vha) =3D &ha->mqiobase->isp25mq.atio_q_out;
> 	} else {
> --=20
> 2.23.1
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

