Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BFCC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5616965107
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhCPQ3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:29:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbhCPQ3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:29:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGJoi4134120;
        Tue, 16 Mar 2021 16:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1NEiuIcXijmuMDl1TAENNbkCErvvQvTKQhASMXpREp0=;
 b=K5vDCAhJFcnzLr6TaKxGdPM5/I2oFfOdKvbWUp1cAhV9UeupNlEGMp1FyFbvzKnTtVFQ
 6EGmZl9TZhRfkCRGTep57mMokEFG1cY9yvzjA/NSSpBopLmWzi0GVkPtTCHHFiX/QKQ6
 rDIKXNFwuKkvNMUbCLS/C98pu51V0jqf2+K1yRw/+oTFonr6cULhjM2dqKNNcV9lL52y
 qBLM0NyLM4gYuEaLsyoZjf7HlIMvMVwifVU1Y/bIVDnyBi+g+uKdJZ3rlVtcicvBNXLv
 UGF69676infxLLrAqXu6moomFMGXJEVcIDgKzFwD8HGeuZVbEJmPATJGQ5WIif3kr9Hc xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 378p1nruxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:29:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGL0K4184294;
        Tue, 16 Mar 2021 16:29:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by aserp3030.oracle.com with ESMTP id 3796ytp3r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SG5dyqjtGsWz1r2aDYka323Hm4aBrwGFAZcQoKGL7CJSqTpPRCfqsLKbRjkzsluRChNOAZVuIWTFzEVRYzI9J88Lnbyq5aYDykYhP2Z5E6YTgVLYE0EawwSR8D1S/xB7slXCg8pqqpJHaf0Jz2Yu0yleJFDoiS7/eJhwvZ3fPeSW5kVGY+m+GTWCHZexaLKuZ4VNyXyWn80NWwNflAD0dZ5BL2wUqAkI6uKfagCJ7kjRjIBdN0d2PE838Ub4qIKh8mwn3nCjITtbCVzuzFsu3KZubLSQ2wuAWqsNkrZ3twgkqESX24zqFr9YoEn7f1b1NM1a5gi70MH3vspzXIJKGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NEiuIcXijmuMDl1TAENNbkCErvvQvTKQhASMXpREp0=;
 b=SxPWNREWNhpUXuDXLi8yjX2XyliYixQDjiwkFGcDFJL76m9tkbzjLQBOdhVL3/JEq4bCl1QLem8my1EDU/igb3ZerLm6WCrjW/nwzjjIsm+VamxTgHZPa8CNRaLDJcOLKfE45D9xGwSYnC5k/RMEiMwEpWujDLLL/5BxLE9lXcGRCR2NIFWilpfD8+dJ+E6rvhO900dfudtN/Mi5CXhncVxQRZ2atSG48qHOpJrzcvOn3BC/MOYY1wBd2lhLldEw4k6sZaFJ2Yls7lRulA6ZQFAy5hSK9zFJDengQFmePlvwv6ID5KXmbo+txkOdS++VLGMlTvsS1as6gcJvedAnWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NEiuIcXijmuMDl1TAENNbkCErvvQvTKQhASMXpREp0=;
 b=bB/BpA4hyhQPC9sXGb1J17jH5Bp8xDn05UBLmVRkNqhYdV0Fb8kr+bvbIldYqLRb/jRBEQ5x7YAPUUi5O2Gl/CeGn9T3fYJhI6QD3m1qQ0sTpUFZlQ2PVMGrbElrRIzCaNW7rvfhE4Jri0DZSkFWrH7aKhQqQ3dMJuaeIU7gLGU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4665.namprd10.prod.outlook.com (2603:10b6:806:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 16 Mar
 2021 16:29:04 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:29:04 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 6/7] qla2xxx: Simplify qla8044_minidump_process_control()
Thread-Topic: [PATCH 6/7] qla2xxx: Simplify qla8044_minidump_process_control()
Thread-Index: AQHXGhhzg2cnDH3dfk+qDdQclrRNeaqGzr6A
Date:   Tue, 16 Mar 2021 16:29:04 +0000
Message-ID: <13759E4D-55ED-48F8-9F48-71DD5E0C805D@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-7-bvanassche@acm.org>
In-Reply-To: <20210316035655.2835-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7dd29224-0c25-4642-193e-08d8e8989d97
x-ms-traffictypediagnostic: SA2PR10MB4665:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB46651E736E9EC474E1A0D760E66B9@SA2PR10MB4665.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G/9Bk3d2cta2O4MJsuOO2YktvMUEN6BAPF6tOBhD5JdHwSYnEquhST5tVCFj3llG86Pz5Oo2e1d9CoyFcV1vPxudhdUU5euAq6OXjz6x0vxV6aSkDT0xCDUUuB5icts1L9a2lVtyOLO3RSabGU1iuQIS5Uphx5S+CbtqftlbPmaRIhgDrba3lrOxX4VbC+BFHHdHJ5dO/hn7+7kPpTNw93EJfkrdX3M79Qn6EatCxz+knKdL/Tdw+mQB0o1qRRopkTpopp4fuMU508mYFM1ItMujWI2LAqO7urbh0l0S0PgTs3IfE31fI8BZQ3GGtgEALGn0EUuupLxkSvK3o5cBnugOHUTiesz9JyoIzfR9trqwFmZchkH6ICNSJWxZujAxCgzULxM0k5YKDtQjdPrekSnX34OY2eRSxasff4Pq4bYHAhXNheAF+MsmPhMIdutx9waj9MC1KFvHxCXzhw8PzVZ8vM3XP/IxGboPv26LQ+c34iOTBwOHQCH8WUv3az38zesiPHB5F/eZ4r4+nkXZ3pgyARYKXD1uyKm2jUh1EjNkfGZCQJkjzobZOzXsQKcnPhvtn5aorXkmoyEi9Xlig7LWIZ25mK5Wcjv44E8js+SHn7Tq0XFRmGJBZcmq8NRn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39860400002)(346002)(64756008)(6506007)(53546011)(478600001)(66446008)(66556008)(66946007)(66476007)(186003)(6486002)(5660300002)(2906002)(6512007)(76116006)(316002)(26005)(4326008)(8676002)(71200400001)(86362001)(54906003)(44832011)(8936002)(2616005)(36756003)(83380400001)(33656002)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?T0Ui8z3TOZ0ZBNqvI4gCLZ+JyWQQkW8h+ZjBn868dBxGjbYgr55QiNElBs5w?=
 =?us-ascii?Q?I9dGPUcD+TG/XZqPNaPJ8TrHPlGKLI37S640DI0iz+J0lYUbYiHKrDsFgFEG?=
 =?us-ascii?Q?unrZFt2FbsEqQoWa1MmNMBIEt3fh7vypeen0QpgGmktuRO3YPEW0a8/7OoJz?=
 =?us-ascii?Q?pelrXpaRalIbC9n8asMY9y8NQ5bwP0lxcSSf1GIZg/TfTHZK/0YZZchJpNJT?=
 =?us-ascii?Q?hXU5zGeXhgBfoY4aiPxdLy+hEEqlu7wiPKmfMdQyPnkoyKG5DqOm9T4Bdiqv?=
 =?us-ascii?Q?7RU2687SXyeZ8q8k6wlLpTL/DJ73WJ6ACgsE/6EKBRvywfe7Cs6WAHp1dxpC?=
 =?us-ascii?Q?xB7npBEebd2r8EYFYP1jDW5kqskwCMGZTx7z9SWuy5NMbPht11a6BUbHOZrO?=
 =?us-ascii?Q?bMFEIiGg2adXzkngw2SNbquUcpAeXq3YkUQVekXu8WHJo+OJkQo8BlZglLHJ?=
 =?us-ascii?Q?KWVqL5fM4H6ByC80YgpUQNZmj1fJmO0pEoWhZJS+GJ37vEHU5WFeBDQB7DNh?=
 =?us-ascii?Q?IBnN0ug5ZjX9b1KQrDN1+fvRWlbKIztec3XArBhdf1so9GWb2Tr1GrVEfisi?=
 =?us-ascii?Q?5BPmIHd76EiCqSz0c7cH1X6u8X9ob29KZRa/zh/DZUOhaebejon3TLGW59W2?=
 =?us-ascii?Q?amQ6MQVP1ShQbIfTvKOSqe6ALY0+0fdRCi27/dgbc0cDjyYz7zHm4V1HFtJD?=
 =?us-ascii?Q?tZPNOmFfdW2sApBSnJSrWf70cawneCUQnJ7dnJ9NXJnxcmlpjWdR0qGhhU5t?=
 =?us-ascii?Q?V0OMrPOYtcy2l+Ua6sa+xjdTCEfxCVIp3XPfNtIIofWyOuHRPiiCaPYP1tdw?=
 =?us-ascii?Q?q36gSSOlYfgs3YQthEoYkEn9lae8jCY1xv86z+XRCTu2nqgdCXHiPbTtXyRG?=
 =?us-ascii?Q?bu/B03XxYwcrZaa5uC3HnZbYK+EJinsNohqLl8rxLJeBql6Av9ExD9cd0zFI?=
 =?us-ascii?Q?745PXuSEXKQhbrGjk9H4WxqIw7nFFptJRhPhZPhVMiEfFpGDAQjYiFaeUaFV?=
 =?us-ascii?Q?l783d5ZXG7dGmqg/K0faqIbE2QKlAHgxxpCFVVc1fqbh5O7KPu2YGFLWlXVC?=
 =?us-ascii?Q?wJVw1zRiR4iRtwF2M4mhh6OWhTCUUYvJ2ohmKTph9fDWQNOg/bpsM/OeD1FT?=
 =?us-ascii?Q?5C5XYQzZPcrimqIz+pDr27uiUmzMVGzbBBnI9n4vC+JJVrkoZ4V/Zc5RDmAj?=
 =?us-ascii?Q?1/cPmCvZtp5Igo9XR6NAGr8R6rF7LxTCEIgyikczQLi4TgFo6YC+oL//BE6k?=
 =?us-ascii?Q?EtGmi0Nj9VNeNEVcYqnT20igsQi6oMfyiN2raaw/W1fYLbXQGn/xEgLKmen0?=
 =?us-ascii?Q?AqQyN9ZzB+d5TLCiJ4Dk8M768ZRAJCv7p1Fbs+fEesmj4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5DB0D254BD0EB04BBE0D394ECF18DE9F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd29224-0c25-4642-193e-08d8e8989d97
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:29:04.7874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rmjn6BE47xe9zsxVNvynDcJHY0dB9mYVzk5c6eJiJRVIdA8yu3/BnqmkeKegooIcF1cXrkcxqV6jcSkRzjsOtnDDShxFgp2yeVM3qjXSDUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4665
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 15, 2021, at 10:56 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This patch fixes the following Coverity complaint:
>=20
>    CID 177490 (#1 of 1): Unused value (UNUSED_VALUE)
>    assigned_value: Assigning value from opcode & 0xffffff7fU to opcode
>    here, but that stored value is overwritten before it can be used.
>=20
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_nx2.c | 8 --------
> 1 file changed, 8 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx=
2.c
> index 68a16c95dcb7..792c55fcec8c 100644
> --- a/drivers/scsi/qla2xxx/qla_nx2.c
> +++ b/drivers/scsi/qla2xxx/qla_nx2.c
> @@ -2226,19 +2226,16 @@ qla8044_minidump_process_control(struct scsi_qla_=
host *vha,
> 		if (opcode & QLA82XX_DBG_OPCODE_WR) {
> 			qla8044_wr_reg_indirect(vha, crb_addr,
> 			    crb_entry->value_1);
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_WR;
> 		}
>=20
> 		if (opcode & QLA82XX_DBG_OPCODE_RW) {
> 			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
> 			qla8044_wr_reg_indirect(vha, crb_addr, read_value);
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_RW;
> 		}
>=20
> 		if (opcode & QLA82XX_DBG_OPCODE_AND) {
> 			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
> 			read_value &=3D crb_entry->value_2;
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_AND;
> 			if (opcode & QLA82XX_DBG_OPCODE_OR) {
> 				read_value |=3D crb_entry->value_3;
> 				opcode &=3D ~QLA82XX_DBG_OPCODE_OR;
> @@ -2249,7 +2246,6 @@ qla8044_minidump_process_control(struct scsi_qla_ho=
st *vha,
> 			qla8044_rd_reg_indirect(vha, crb_addr, &read_value);
> 			read_value |=3D crb_entry->value_3;
> 			qla8044_wr_reg_indirect(vha, crb_addr, read_value);
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_OR;
> 		}
> 		if (opcode & QLA82XX_DBG_OPCODE_POLL) {
> 			poll_time =3D crb_entry->crb_strd.poll_timeout;
> @@ -2269,7 +2265,6 @@ qla8044_minidump_process_control(struct scsi_qla_ho=
st *vha,
> 					    crb_addr, &read_value);
> 				}
> 			} while (1);
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_POLL;
> 		}
>=20
> 		if (opcode & QLA82XX_DBG_OPCODE_RDSTATE) {
> @@ -2283,7 +2278,6 @@ qla8044_minidump_process_control(struct scsi_qla_ho=
st *vha,
> 			qla8044_rd_reg_indirect(vha, addr, &read_value);
> 			index =3D crb_entry->crb_ctrl.state_index_v;
> 			tmplt_hdr->saved_state_array[index] =3D read_value;
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_RDSTATE;
> 		}
>=20
> 		if (opcode & QLA82XX_DBG_OPCODE_WRSTATE) {
> @@ -2303,7 +2297,6 @@ qla8044_minidump_process_control(struct scsi_qla_ho=
st *vha,
> 			}
>=20
> 			qla8044_wr_reg_indirect(vha, addr, read_value);
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_WRSTATE;
> 		}
>=20
> 		if (opcode & QLA82XX_DBG_OPCODE_MDSTATE) {
> @@ -2316,7 +2309,6 @@ qla8044_minidump_process_control(struct scsi_qla_ho=
st *vha,
> 			read_value |=3D crb_entry->value_3;
> 			read_value +=3D crb_entry->value_1;
> 			tmplt_hdr->saved_state_array[index] =3D read_value;
> -			opcode &=3D ~QLA82XX_DBG_OPCODE_MDSTATE;
> 		}
> 		crb_addr +=3D crb_entry->crb_strd.addr_stride;
> 	}

Looks Okay.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

