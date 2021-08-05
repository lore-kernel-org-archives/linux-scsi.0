Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356BCC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2041761151
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhHEPm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:42:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14534 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242232AbhHEPmc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:42:32 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175Ffq7D011994;
        Thu, 5 Aug 2021 15:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=i+ZtSODU53c1M1+E6hlvlgmFuhlRxjk5jETx7jHg8hc=;
 b=ssLk+PAxI3DdzX+mF5b85gW3rwT9rkiXVOFNisxiAtLvBk9S/lyK5kSTUow4T3X+5aCt
 pFzVm78Ad2sGLXC8FOL6Fu7nKdq9S62TOZ47GbGve+10e86ote/eCklZECKQqZ82yV33
 pyDA/PAbpNM35zw5aG5BAxiRE9Tq5TL7BCI1pVIR6M5YwmMCDtGvNeJn1tHC3qNA0OKQ
 wOhnrJbn0JZ11KL0yy9sRuxZqGCoUfLQeIAB8paXWLvi27YtgDJo4L5onKIL8Cpvr/ru
 rtErs9PfAmeR/KTXQHtzyQ56h3tO1DPmIldz+lq6vnbdgTAYvuCsuotDLRuSUVe7k06w Xw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=i+ZtSODU53c1M1+E6hlvlgmFuhlRxjk5jETx7jHg8hc=;
 b=Yc87g7dUXlKtVz7oTjaHYfh/VZYk/Qj3imIQtRi++CYDcaIRJA5tp9JsxyJ79Hk0n2Nk
 OfN3bmLR3EZg47EdskguoK7enbYd/oYiRbAukvnMMPj9a0W8GQEidj3YhTL+R8vug6kQ
 OV7kpc8pI40E4nj97S/lPCSwGTk3yCH1JTYSlVhuQCIYofDk6cB5IHAbSZhS/lFD19KV
 sNriswuogSeENGPNehMrqRf9dozyYGRFsHnBLRsKVJPZMgc8FHkf/YvT29EHA60HiMyr
 tN/V5jkWddigi7VYZUY2J4/26BVtV6WmpYcUsYYA3qvIRkehiZ1OoMoYaw9KtPgOY+H5 KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0d3cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:42:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175Fe8EG073281;
        Thu, 5 Aug 2021 15:42:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by aserp3020.oracle.com with ESMTP id 3a7r49xvqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:42:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMebnXzxHuF0jDqZzc7GrNSVHhGPEJOvIrvk0eAB/HSTSUY49y4xkRa5MweIy1x1Oje/kXBH09yB43GGy8jdXTvJk1VkF2vMpFWoEpnl6r109zxEEkQHznz9g7sw+Sz9IH235ZFUJtZu1S0/cmh7vto0cloYYaB+KipCgZx8PdHtrXoqIC8v9MBIDKiYeleXbFqtgXRx2dyeu20YkB9kRPMD/IOJfNrMeyv+u2ztJtC0e8h/L62loRCxgj6HpQYk7B48FnKkxun4VyMrmMrHbVzqPxve9y4onVA42UnZiHA9AfZQDrG4TDQPw3FBL1/tIjP6xgLVmyWgSb4JIAyvgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+ZtSODU53c1M1+E6hlvlgmFuhlRxjk5jETx7jHg8hc=;
 b=Q24qafy4KPDXrUO+UHDTPVQqJPKskAJdUo8Kq2AIVMlbV4BFB6hvpvNcpTbf1DlYjdbw0N/7V8smfbe6Nzljmr4Buj8zur5TxNOkunGQET1Ud4BndpNbx1PR1MZLEtyK3vyy/90crbIG/BybkxtrUZ0Epp4rngpZ32Cd2UPakLBkcm4v6X59qZypN4hWdPUZQkEON1FexDTgwRMkonxRwQyM2HljeF/w9Y6Si1+OSJtCzAmq121BMuXdAMk0vERGYGQf6/SWPFkbXskydKlkWqIKJRopItyajmR9ZrVRllCcxvRk7yg/9RdhO1ecXVxNV410mZ3/fSbzQnppYglk9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+ZtSODU53c1M1+E6hlvlgmFuhlRxjk5jETx7jHg8hc=;
 b=XeMB03FvKjHLJ7n97q+PeWcUqIR70sATWdBAh14Dp6xwokWwYwQ2h9938ms+GuxDPf0OWM1EzFmeZdBqhOpBkD29izn5vdg2kaXkvSMi2xuPbtIHSMwohp4HQrPoYEdFCsZ0hBocQpFp+hWJTngS1fj3K69azXISOKYTP9McrtY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 5 Aug
 2021 15:42:14 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:42:14 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 09/14] qla2xxx: fix npiv create erroneous error
Thread-Topic: [PATCH 09/14] qla2xxx: fix npiv create erroneous error
Thread-Index: AQHXieQLnmE/LdUSw0q3xP3azT7alKtlDSOA
Date:   Thu, 5 Aug 2021 15:42:14 +0000
Message-ID: <21F98316-8A93-4466-ABA7-B75D9A0DC498@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-10-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8cdeff7-089b-48ca-4766-08d9582798f1
x-ms-traffictypediagnostic: SA2PR10MB4796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4796A8B20E2D13CD5F4EF1A6E6F29@SA2PR10MB4796.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTlLtbuL35LE/yIthrsiTzgMdpSY6d7r2L3lXCLaJRLrQ8LjHSyPXjA168sSImWw/72TekFYNHgDp9AMQS9hdsXuXN5dG1xxDqEg8ZqlfR3NvWOYPSuJeDtvoW4W55aSarSZkMruhqgabt/YbWJDNSl8BuVZZDFcB1YQ8y70zLKTR50X+GH50QxWLlb3BnHQESCXk76YOJbtUVmOaKgYpNvrSLHcMtiSfFsDtUrWPDVx+Ompbu9n3n0NTY3ATKROb3Hp/NNyTw9WaTrgC/fV3M4sKQydK5g84ig3ZMxigKELjOCoZP3wBGYYTaxuCwfgM6rCaQ/Q1p1SvsmnXTJqk5tUj2M0vAffQfkdKmlGW7EQMnQvheAIfly+NytWyTXODz2aslWUXHvK8u2Dd0kb6PGAx2qUoJXvul+l+wd3WP9FyGu1E5fbBoj4gxoITDsWFR3BXEmKFZQMW5ws8CJTl806nOmwr8qtgjHmQadbXNzwC5aCygd0Yf0L8Wsjfm8StRArcz/JKw/6jg3r98ZOdD5uf/Qt1oeUyPI0rzD0uf7ON0AYdxIym0FUhGkDnI6u3cVWp5ZsQPFVM8WnK8jDk6CeH2QowT0BLxyZsUqR3eOPlLnXF89Bt229tgiHarcPKH/awdBvXBAtniW48mfqssaWSh8FZpeVuVoduq+T2FtYysGqUhF22SdTvgDYOap4RbwHbCVexdp+WF1OZeNS+MNfj0l7iwytS+GaKrgoTCUb0Z70oYfPxawaQJj5XBCO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(478600001)(6512007)(316002)(2906002)(33656002)(86362001)(44832011)(2616005)(186003)(4326008)(71200400001)(36756003)(26005)(53546011)(6506007)(6916009)(83380400001)(5660300002)(38070700005)(66556008)(8676002)(66946007)(54906003)(76116006)(38100700002)(66476007)(122000001)(64756008)(66446008)(8936002)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CNPsBpkymvHVrTCz2Q7EcENIqmDGUfDsBYIj11IS7RJfshzSgqvgacvk2QO5?=
 =?us-ascii?Q?WEq461imJ7NZ2thZ3ha0ql/QSm4AIH3ALUSJQr49iNURsHH5ji917DyMOYXU?=
 =?us-ascii?Q?q9KXtatz5UO7LN9SNna9P7u2mjvVzWFbTlkuXKWShFyuTofVRVdaQ6sR4GHq?=
 =?us-ascii?Q?b1h9/TuzH/EfX/HwmCa1s2NBGZlHB51sitywKdqgwtjBL4zf4IRAWktiDlUb?=
 =?us-ascii?Q?FEAYhYkfEE6h5EoBq4HrXJcEm3HX2zq61PWBnsvqnXPyTtMO6uuFNlilBvYk?=
 =?us-ascii?Q?mAdLytVrjbTRVMKnWUEqK9/mjFdv0coxVcGLhgmLfBE/XAMqqbsIpSinSLqE?=
 =?us-ascii?Q?MRQ5a31JYf/TiJYSTH1RUzPu+Q4o0RRR4iR82ue8p5ax6pJljpRV+L+sKrum?=
 =?us-ascii?Q?IvaOedrBj6p6vUGqKqzxw7YevdljV5g6j6PMk3tcIk6eC1xiVKwDy2SFRwgK?=
 =?us-ascii?Q?A8VUW+tFleSL8vfRMZxWuFMVUeqMD8es7TK1yG/zC1XzXNgPehh2Lyq+uJns?=
 =?us-ascii?Q?zmjYOG7mIY9VAPS4MgxrpFxRIg/BTRwKgEoIrWywXGnLCoBZJhvj0eKHi/rh?=
 =?us-ascii?Q?Lk1AcfktH7gLDDKYHchabLjOvlq/QUfJFak2EJm4lTGoHs9e5LmS6XUx7RzU?=
 =?us-ascii?Q?nnxJhUuEJH/mEmT0XHoMn3bgSLsFWWkdV6TfNxNaRtNVH8BHgYNFbZw5EtGy?=
 =?us-ascii?Q?jUgysu08xINQ/fBATudD21rVFX1NpGJAgVSAZEiylkWn+oYZIkG5lfGkdGYu?=
 =?us-ascii?Q?hswiHaD9oZYHgiCwtmV0ADOc0GlckSRoy9rN7xmTangkqlALVp5dQO7fvdrq?=
 =?us-ascii?Q?kirB7z8QMzjwPHo+2mvYFcGrQ3isxjlzB12anrP+aYuNb/q2v4pUv9zRu5VC?=
 =?us-ascii?Q?dS0Jb4t5pigzVEr80AOTA6e6RXVCmn/v1cTWUUo1A8w9KutLHSgqXE7YUOai?=
 =?us-ascii?Q?fLCd7GNbMLk2Ebb27OdYPw0MbhiNPNQHyNS+aTcI5Un13URAWDS6R5x+e95k?=
 =?us-ascii?Q?ZBJrM5pojr/2gnuCQYg0v5RgEktM0WbjhqM9SdK9WT16/m0AShPCw6kSWZx8?=
 =?us-ascii?Q?YxboQIxuc8nvT44i8a8PYK6urzQg0tWYOleEGfHc0uTqJfSaw7nhFtOU+IaO?=
 =?us-ascii?Q?5NfPqaxTRqJFKIEF4vEK+jWCTWCQls1+qaowL08dknzV7zIdXR4TDs4oiZYI?=
 =?us-ascii?Q?c5OzJ4mZ1CIzsVpbyJhECxttFa5QNym1mJIEunl6cnJHS2P0p3W5ONS3Aum0?=
 =?us-ascii?Q?Zxy57Mj/e5WuBFfjEJJAZ4KwxWQjlQBPG1TKLLemNZlMb/oWZdGNzqRO+x7p?=
 =?us-ascii?Q?NsUyNumx6/k9pNxwNvQZzg3IAJp8dVZ9V3kt5ycdMM04Ow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68E46A617824374395642B455850B07A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8cdeff7-089b-48ca-4766-08d9582798f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:42:14.1574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hg710BnG/mTZtPyXqT7S++BAsVA3Xqklsg6wiGQNPy1L8+TyOW5RfWHmIujNOSzOwjZF0QsMPOEyHKvITZih6aZYSjWClCg3maGqE9clGPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050095
X-Proofpoint-ORIG-GUID: GRd1-6fxB0If7IOY2cGTD8L-mvw8yEtm
X-Proofpoint-GUID: GRd1-6fxB0If7IOY2cGTD8L-mvw8yEtm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> When user create multiple NPIVs, the switch capabilities field
> is checked before a vport is allowed to create. This field is being
> toggled if a switch scan is in progress. This creates erroneous
> reject of vport create.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index c427ef7e7c72..266e9e06a6f2 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4623,11 +4623,11 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
> 	/* initialize */
> 	ha->min_external_loopid =3D SNS_FIRST_LOOP_ID;
> 	ha->operating_mode =3D LOOP;
> -	ha->switch_cap =3D 0;
>=20
> 	switch (topo) {
> 	case 0:
> 		ql_dbg(ql_dbg_disc, vha, 0x200b, "HBA in NL topology.\n");
> +		ha->switch_cap =3D 0;
> 		ha->current_topology =3D ISP_CFG_NL;
> 		strcpy(connect_type, "(Loop)");
> 		break;
> @@ -4641,6 +4641,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
>=20
> 	case 2:
> 		ql_dbg(ql_dbg_disc, vha, 0x200d, "HBA in N P2P topology.\n");
> +		ha->switch_cap =3D 0;
> 		ha->operating_mode =3D P2P;
> 		ha->current_topology =3D ISP_CFG_N;
> 		strcpy(connect_type, "(N_Port-to-N_Port)");
> @@ -4657,6 +4658,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
> 	default:
> 		ql_dbg(ql_dbg_disc, vha, 0x200f,
> 		    "HBA in unknown topology %x, using NL.\n", topo);
> +		ha->switch_cap =3D 0;
> 		ha->current_topology =3D ISP_CFG_NL;
> 		strcpy(connect_type, "(Loop)");
> 		break;
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

