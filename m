Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75F5C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C25E06510C
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbhCPQYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:24:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43848 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238650AbhCPQXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:23:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGK3Pe041922;
        Tue, 16 Mar 2021 16:23:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aGf5nPKCRThFNVDTlftIc4adhX9mFI5EKrAYMabX8OI=;
 b=i+yG8wifNjV1hkiiRCinentwda9X1c82oR9WgsNBJznpum++Mu9mivf3V1qlqwPKMxbi
 o7dnTx5k+LPYfPv+EzHkn04ws0cwCvLqv2PUiE0j7zJ8smJ+vRv93PNM557uJz9M4dD/
 r34MhM3cGumMFKkSk9KfnmvAONKJ6gSjLwmB5RMvph666LVqb+GtHG9OsaFbcavA514U
 psfLAJ8+fdAnXT5sjFISNRM/vqwvwWSfdtWp0L5b5Hog2jVL3LOAEFvutspaoxYITe3Z
 sbBF+kofwmnG+t8DD2WkJ69hMFYjjZKFlEOAuniTDlRlp2a5FbWBcf3hav61yM5qIYuK 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 378jwbgxm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:23:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGLchu125895;
        Tue, 16 Mar 2021 16:23:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 37a4et5cyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:23:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cclRr2tclxCJ7pyt580zMFpxSTV3ytpHl+3QGRYs0EAm/DsM1qzkmPg5uatp+xWjlpsUBAuDUOAt3LCf4Pw6ikZaWl56LIV8tu6L+Pw3MMtjlKwj26FLvGWzYq2eaUkUYTO0sNCg0UKBg20sesOLKAKbVjXgq3MTl8Ic5G6T0AKmneRBnSq/XpT4gBEfy4Ij3cL3dcXdig5HG57mqOle3SUJvX+4xVQJ90usAIgCfr1PQoPJ6QcaNVU6CeEX/c+kjGPtbrOAbKFiTIxe0Nx7FE+oidAsyEaVganxnlNj+/YJBEjtnsl4RTlZlSI/XNgR+FG0He3qc8PkkxMz62EI5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGf5nPKCRThFNVDTlftIc4adhX9mFI5EKrAYMabX8OI=;
 b=E/TPOxswyDGoFaFqV6IH64R0zaYza7lQt3rKlKpCCYsy7icbZ5swRq4TxCGr2/Zac76fuBDjGoGfM1jXwYAH1KwnGPcd8qAfHpm+UKXgYCkJCFTPsWC3TX+GLnxvp30yYm9fxj9uMsmmz1Uy2MdEi7rQUOyVBs7ylOLwYUtgmNIyPCv62Em7x2J47MsHePZ2s4+m09GJvtHVQSWKznA2IYLHsxSpKoAc0EZnojuizAczla/ufExGYHyXVXK9lMRQEkAY10zTrFmrSrqlJsMArirYErTv3Ekv7kuv1V90gwOHZfWRw3LeaqDY6MFsdsxHsVdhaqKLMR5l2+aHRveB1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGf5nPKCRThFNVDTlftIc4adhX9mFI5EKrAYMabX8OI=;
 b=Y2aov2Iz0sMhADoTX/LCDeopMTRgUOcCLM/ZkySvniuLy5rGUPAF/2AZ+U1i2VhqPYbV+w+Rsx4v7yVyd/RJcl8WbZeZdkY0zj4U1FTjqT1N01TL9RMK8tuO0Psb81rAm0gy1NbwU5lqYMcX/4v/88zD6p/8V6AYFBX/s18SxT8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:23:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:23:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 2/7] qla2xxx: Constify struct qla_tgt_func_tmpl
Thread-Topic: [PATCH 2/7] qla2xxx: Constify struct qla_tgt_func_tmpl
Thread-Index: AQHXGhhw3P9Qu05mrkS3ivH/epdu26qGzTKA
Date:   Tue, 16 Mar 2021 16:23:27 +0000
Message-ID: <DFC47F23-0BF8-440C-A4F2-79C5FCC37459@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-3-bvanassche@acm.org>
In-Reply-To: <20210316035655.2835-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b13544bf-b542-4807-c349-08d8e897d4ba
x-ms-traffictypediagnostic: SN6PR10MB2464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB246441CF4F158229843F6625E66B9@SN6PR10MB2464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ty4nICAQli4BzEzUxAXo6MNSkoFwFwsak4xT/BdxMit2k46xGfEFnAJQfjFE7PGuGbzilkb0DevZeaWpLHXLOqtwOgbZoDmE8WwdWx41JhwZo8PmHiU7+9vf+Z96BmLw0snQ86/pgk/bhnAzufC3mrnv+e227jk6+KsOovC22pPIOZhsdcIsIM1jtTuJCKhGspeEc18dPuTdAd4+p1NIw8GWLmOTkL+ypxTOEq2LtCPYX0TSA4bFoiWeH8lMSVeSVo7ce0sBcQFzT29Yebusm9AYPs6e/GTnY2rN7TqPQccMPMJZ8dUBoNMcXpKRP2hzes2uNoHo8iRmGW7rsgSEVWmI3cwM4HmRjn26M6usXY61PoxuDkYJN8NCyUnLXq0BB39iO2UMGKfuRbQmCFL16IIUuK/avEzSfOHSoCpGnD8yFIhRmARQ4TDX0rU4b2tGttasrR8ItjOgTunZURMBzLkPKFP3qrd+GaPagB3NV88AEmJR7WfKhSPLR9mQkCCmEg5ONlIjF1XLQYr3WpXqLz+XVEPJUXlZ1UCuLBDeTQxeGMMoGEWd6IxnQJcoJmWE2BzPZzfRAx91ZcbMT5iklYw93p8DEcfuNHjMdXmmZKR//83BEwy4XrZrXspyUjgh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(66446008)(66476007)(36756003)(6486002)(66946007)(8676002)(6916009)(316002)(64756008)(66556008)(2906002)(53546011)(33656002)(71200400001)(6506007)(54906003)(5660300002)(478600001)(4326008)(2616005)(8936002)(26005)(44832011)(76116006)(186003)(86362001)(83380400001)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JY/A8w22/7uExaPUmT1HUkPiYV46isgmMpmuyrKt5/xYp5rRvjGofrdgJug4?=
 =?us-ascii?Q?QJ6bnNfZm9dhf0G2yQLbW6udGTiG7gW3RPm9FVdS8XKduHTpBNsSQcozFzA9?=
 =?us-ascii?Q?1OyslQi7UkRwlwB6ziKRTC5RJLdicmdjExXQmTZffyAX1FFonrfMmITDNK+Q?=
 =?us-ascii?Q?MDBGsvckNPYszv6ithJmxJQHGPQqOVPgikwFzafIxMIXY7RhLTY+xYUVU9bW?=
 =?us-ascii?Q?twh1P7FRLO5cAfNbeXDLtZGzQxNgY3dhdkCmBnPzPBQWeZVuQodoMO4ZwpUq?=
 =?us-ascii?Q?+hf/e/SuxA+7z9E8vAaXrRxZroI+DizL+/S4J7N+eLgktCrCGJo8KyFL6A+k?=
 =?us-ascii?Q?eOeoRnF9snvaOPtOrUMFC/bK110NjTh2EgZ7FgGP4vMAQAgfPnMcj0iNauYp?=
 =?us-ascii?Q?W2dpqcOOsv+nN3yT3cAmErWw/SqzZEunjGsPVR4iPyA6JiYHvVEDUW/X8mDz?=
 =?us-ascii?Q?QsXg7Q2JN81MyV/GIkVGNnGnPG9o7sUfmTVL6eI+WPDKYYby2PcDjZIrAQlC?=
 =?us-ascii?Q?FxV4JP3BWAJPdHBsz6+GZeR4Tc+d3qSXBLfJLFx/YfpHfkLOzy3WqX8j2kjL?=
 =?us-ascii?Q?MaqajSM4XWw4mCWUX0YvFC6grypCDBRtPoqiPEtFXD1kYW4FcQXR4nzHxmP6?=
 =?us-ascii?Q?E4EtIx4nwM7zr+jseNtXI5BDrCTciGFRw48GrehCSnNRca95V1cHQG2U2qi1?=
 =?us-ascii?Q?kDfufBwmHX6vEOTHNYx0EJgVk8canxM1AZBk/BZRWEHZCefqR5nYDqpXO+eO?=
 =?us-ascii?Q?6xRlpMqecXA5fyOMHd+w0TgdrbyQSEHFW/1Gv1QHwerL0c1XCzhPjj+Q+bgN?=
 =?us-ascii?Q?WFWsMaTN2lAp0yQplZOhSLTUKnTX3u1/t9exdI+5iUynRe6dgZ5nUXgKaZBf?=
 =?us-ascii?Q?QZ9cqxCQs/Z3St70oxjH9feaY85Y90VWk00yJBiUj5Jco2whHZmo1azZHtUa?=
 =?us-ascii?Q?Eyy++d7hbABgUSssiH+zoz+l8L4Bkv13IKGt5d/KnvrxF3cEf5VqfEj8Uq1X?=
 =?us-ascii?Q?d7nD3KVrPt029Yr59INn+6oiHXdUIPjV//w/ZIQdmwTkPKyJ/5guLWlLBdBi?=
 =?us-ascii?Q?Zfdw2XUQDbFtCfCK5kY6fEsPw7UzA8Kp6+6bDrhnu/DLLxIHRmj5lgW8Vy1g?=
 =?us-ascii?Q?oxtkPYdbOiQafV65aUkpoDHa98EBBi4GefX21kIjfI5gs+NPeI7wP6BBnM0y?=
 =?us-ascii?Q?frYSKbG6dYREIphKy0RxqcZlQnKcJeCqcsrM/fWZnwL3fdw8cR2H1/CmkLBo?=
 =?us-ascii?Q?NV12o51qX9nGxVrDZ1HyCfIhvp/hpYBqCvRHASOOzrvwpuymI8LI99aAutj0?=
 =?us-ascii?Q?udwvD4L11ieskh/NNeminPUsWDFfBGrQHcD37hzRLhlSig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <37C1AB2B7361CC458F6B409E140F9C4C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b13544bf-b542-4807-c349-08d8e897d4ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:23:27.8610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MTx6QJ3OATTIlkATB+aUto2jARs83lwKcMYJEFHipWDyAjE1urxbwTjD4maN0WSpApffDjFzp4Zb3GCZ1QRR2YFqjeYcaPVKbW0GE4I6UV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 15, 2021, at 10:56 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Since the target function pointers are not modified at runtime, declare
> the data structure with the target function pointers const.
>=20
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_def.h     | 2 +-
> drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 49b42b430df4..3bdf55bb0833 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3815,7 +3815,7 @@ struct qlt_hw_data {
> 	__le32 __iomem *atio_q_in;
> 	__le32 __iomem *atio_q_out;
>=20
> -	struct qla_tgt_func_tmpl *tgt_ops;
> +	const struct qla_tgt_func_tmpl *tgt_ops;
> 	struct qla_tgt_vp_map *tgt_vp_map;
>=20
> 	int saved_set;
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tc=
m_qla2xxx.c
> index 15650a0bde09..46111f031be9 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1578,7 +1578,7 @@ static void tcm_qla2xxx_update_sess(struct fc_port =
*sess, port_id_t s_id,
> /*
>  * Calls into tcm_qla2xxx used by qla2xxx LLD I/O path.
>  */
> -static struct qla_tgt_func_tmpl tcm_qla2xxx_template =3D {
> +static const struct qla_tgt_func_tmpl tcm_qla2xxx_template =3D {
> 	.find_cmd_by_tag	=3D tcm_qla2xxx_find_cmd_by_tag,
> 	.handle_cmd		=3D tcm_qla2xxx_handle_cmd,
> 	.handle_data		=3D tcm_qla2xxx_handle_data,

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

