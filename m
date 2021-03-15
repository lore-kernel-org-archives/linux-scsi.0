Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A631C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 19:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DC6764E83
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 19:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhCOTqe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:46:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhCOTqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 15:46:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12FJiwl2010140;
        Mon, 15 Mar 2021 19:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bYzuGHZnpC2C37dJjVx6UfTsNpgclMnQEHsaix/+JPc=;
 b=gLlwsY1eHGFABgyCSvd6Yr307y80WeuTS5JC7o+C28MeqgeSIHV7wtmcez2ZmuJ8Ww9Z
 yfpUdk4VB/d329js1xVcl+3wDjU4IxvedGipCK1MW9y0OxzEmZbkm/fFiFBfiPYOq8Sx
 vx8ZQ4sAfH9qCz5tGIINtT4YQdcbDM04bSEMMO5xDS053MeRVTIasCtfzAfJhw9EPhUI
 QsgUwFeYag6mjmN01qZjVUp46Cwwl3jSbymnWgOYgtY7pNNKb8Xg8KLBO7zZFGqr+/NY
 sM7KytORYqw2rvH6ft++A0e/hvHxM06sLWbRdFMwQcmQu7AOW9q8fvMXpG54K2pcVtaN Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 378nbm599f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 19:46:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12FJflQf016913;
        Mon, 15 Mar 2021 19:46:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3030.oracle.com with ESMTP id 3797ay4bsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 19:46:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Im1OmdCcpWfRZq86V0HC7/ncAR9zW8IQ72QjCC04gGvg+dlFuL+OXSp/YZsABy2NcgYx6LZ9Sy+3WOcr3QFRxBaLBxeudsY1hJG57n9QL2v7Pf0o5/ZlMXZO2nlGp7BCpI0LeOzexNnIkLa3uKf985353ALwp2g1bYCDFqvXVhGdGlm1s2xf/gHcYjZu1UGpKNVyOmQcvuwVW4jpRhYRlqVfJsbsFa9/5Aw77/VRIjSTL/+1SnPuMG4Ga7+RRgpRkUC8pkGiVHk7CSCW3ny0gVt3e/fdg43SivfahyKzHk5/hAKr6UplURb6/rpCzAlIQJvC5p60e8vYo9PH0c6KdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYzuGHZnpC2C37dJjVx6UfTsNpgclMnQEHsaix/+JPc=;
 b=YWEfHoGHIk6KxMjf9nwPYCwn0awN5chs9iAb/t9wZxWyWH5YTz0KZWnlRUjYXtd6EvzvNOMvgtLUbbK0JKtwSP+Egsir+VnfUMfFsHohn4muyuhbcb+gk4t/0d+UiuSRJHjlLpnxg7NEB/IrKwXVBH/vf/hPzukLYZ/huhIA9PROtffldK0RiSrKk+YUb0BRUyL3/uU0rWPiSGuchX//GPr1X7U7RRP7inYRshtU0S+oHpFm8ENm5Qjhf/tuqcC46BAnyyqN99iiPRmQ6u1n3+bdP7OOwHgfogNU8idtPfgD3kVsf7WAQNL6F269Gy8k1Ol5mu5XS8hAjo8IKdvNIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYzuGHZnpC2C37dJjVx6UfTsNpgclMnQEHsaix/+JPc=;
 b=kuqnUMyGoXZZEvx84OdQCiS3mogXVDS7fKa6EaGgBU/ImQaUTY3+uZxynyKCTrctMjIL4GIhnC2MDaPgK6jgj7DrudisONsoVdbMFeDM+8n7lb7gQpcXHA6BVAPGPOpdWEO8r9ChB+60AvXl/FJ9dBecLlUOjdfbcs9PkmOVmic=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 19:46:18 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 19:46:18 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Wang Qing <wangqing@vivo.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: use dma_pool_zalloc instead
Thread-Topic: [PATCH] scsi: qla2xxx: use dma_pool_zalloc instead
Thread-Index: AQHXF7J0CTLvBa0mCk2OoB3Gtpj/WqqFeFQA
Date:   Mon, 15 Mar 2021 19:46:18 +0000
Message-ID: <5A7ADAED-6A7C-4855-A6AB-6786896BDE03@oracle.com>
References: <1615603275-14303-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1615603275-14303-1-git-send-email-wangqing@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: vivo.com; dkim=none (message not signed)
 header.d=none;vivo.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e9121c5-e891-4294-d642-08d8e7eb0065
x-ms-traffictypediagnostic: SA2PR10MB4537:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB45377EAF45B67BF141717734E66C9@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:47;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GI4vTKe0sj3TguxGtrm/dwtSNkFRBQZ+gOr4Us4ufucUPHCc9xDTfl4hvGnHtoJAywjCbhca8S5YBUxcakPujEGH/Zw1bPOz8teZtT8pMnKvp3UkQGbhDjPaH6Jz72GtKwXhfSZnbaeiGXh03Tn+llu7azOiGYwa9OnXmbcw9lmehZIOx/gR+rRZ/eiFi7PhHtqzdX75McE6v5OnWBo/IUa5I5Vsdl7QxVivZ+05MZgjBLbMfGgvm2FieL286YEQMaQQoiRATU1oTE7GkIQ2EhxAIgw8C5aSQtB6SHgDK5jsCRMWehaINlK7IMx7HtLrsVNgXlsQYLkffx4UpPdv50JDgttjqYhoiQXddjSQTyvv9Ou3Lok5yJVa+cJ2jgu7eKTuTKprOVWuBTaUxW1tZjzw53b7I3yPodCFoWN+dFqD1c8OISyPAKWJuYXKOVYv0bypKDESFbg9KR+X85O08+ACO0GkremAYxF313JW2SPM/wf6WhoMXcxecRgnH48OLiSx0Mb0B3ytvb6aQpM5dOWCCoqFNwqqodgq7VbnXmIY5ktGzUD3sTyjjCQRFTs04oPfC4NXFlKSxYDRbUCb5fLHS6hRlzcTUOyaVCf8w3Rw4DBypRE3eky8w1yZxV01
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(346002)(136003)(6916009)(66476007)(5660300002)(316002)(2906002)(76116006)(6512007)(6506007)(36756003)(83380400001)(66446008)(66556008)(66946007)(64756008)(6486002)(53546011)(8676002)(54906003)(33656002)(8936002)(4326008)(71200400001)(186003)(44832011)(26005)(478600001)(2616005)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?70aGBzIQEy4rknV50RRpVi31vNKR9VZ5rOl5qZONx4mea9KcQUVB5aGYp2x9?=
 =?us-ascii?Q?P9pnS8oFhAurFSY1AT1GG39aiP1mbxraJSZAyCKiJc/ZZRDnVQLLhWQeCPTd?=
 =?us-ascii?Q?XdajR/VHE05vVmlz6z6SmBu6S2Zh0iyf3+UwnnPtVuDSGGigrEFqsvmU5lOM?=
 =?us-ascii?Q?rb4qBzjjY3pQ4unoL19wL6D35HDZ3We3fOnnXSpcPFYJ9WdiH0jnpDqWnX9l?=
 =?us-ascii?Q?AYvs4AFftGBxvqoEkHXc7oqjJ+jaqDG40Q03UOiGLN5CKzgLYkkDqSDhT6Bv?=
 =?us-ascii?Q?qTsRMO4uw581Fu5/5Ye0jG9zDIesnWVNzFgVrFNTG3GeQWp5ava/Ax4/8lir?=
 =?us-ascii?Q?GZrFhRZFtSCXzli2BT30oDwJwEnyq/tOQN6DusVqFqW/BbG+idur5G51T7lw?=
 =?us-ascii?Q?kNsV9Cx/C+eKfVvqA/E726YCmjmLPpwFmd9OFiku0jlXpAs2mEEfxCWoA8uQ?=
 =?us-ascii?Q?G7XxufAYvGw01SorhixFKmYP/AxXJJPUF6zPBJvI6jEzFXIrzvxlY65Jui15?=
 =?us-ascii?Q?V0hooKyFUb2bXlhak8LwydwWHmtrRpBRzum3l8hlNBf5ES1Ac/Bbys5kEYbg?=
 =?us-ascii?Q?vLGvinm8d7fGISIXIASJmrUDeEhAs75tZQhyM9HH9+voWaABqi2hG7NeWO/K?=
 =?us-ascii?Q?6Fj0Sqxe56U5Du+xZWLaktskPVvQZTl+d/0+4cD1DJ+QTNiBK+ei795L5ljU?=
 =?us-ascii?Q?OnNWnmVxWl6pDp2OaseXO1ad4Y1/g4WMP2nqclD44SCy36GCEggMegLKvXwm?=
 =?us-ascii?Q?R1idU3Yc+IuItksg25EP/AOhrQd7rXaO0jDZqnXkYX7Nke70iOFXb+B47ayh?=
 =?us-ascii?Q?/h/o4XJne7wjjE4e0Vp4HRnJvUv6fwzOnW9VPE9721sReEgfXzyPCkI9WCrN?=
 =?us-ascii?Q?Xjd2ACFAA0z6uZzfL8ic361mKMgq78VvHx9G7c8jsjoOqv7+jwyCTAZaRmbr?=
 =?us-ascii?Q?m1JwbrTuYeji7zyiZj5V9hXKUo7JNVVjRw2f4A+hpO5gN3rv+6XPwHw1fu8E?=
 =?us-ascii?Q?lP4H3iVNrZOch11l12LTxbtmCevuTd0zaKcOJPcetweVRayoJkqysYSmhtA4?=
 =?us-ascii?Q?vH0BIBq9sGeXfvn7G4EDwmJRUu5WPf89eZFpt2ZXmD8XzPTmN41TgprWNPnw?=
 =?us-ascii?Q?tx0Xj6iI2AEDB/3dwvjurOdK/ZkvSNzUqxW0ykvHf2NIszDQMMYkD1IJSEE6?=
 =?us-ascii?Q?PR3DjF15KqlKoGt48obgURj2f1ha3nsVGc8I8lKBTkIZ/OeMcBVk35hfotOd?=
 =?us-ascii?Q?t8rEHSc7EmEPLPlehy8G2EkrjAtpeD8lVNxW6D1Jh3SiRk2JiNMJuz7vxsJ9?=
 =?us-ascii?Q?jAFRnInmrReOwDE1rxjWQd9/XpidRTLUGQWuzgxV7B6Tug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <114A3A8218709749978BC343658B4E62@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9121c5-e891-4294-d642-08d8e7eb0065
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 19:46:18.2190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PKQWvZLJrGpUUJQ86PjncO8RKWb9G3pKfYuOmcsjAprJRZFVc9LuK8ecCKOGpgRw+e+aKq0utt2BxMddrgNQ75LQcABPm7QjNjO0hk+du58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103150132
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103150132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 12, 2021, at 8:41 PM, Wang Qing <wangqing@vivo.com> wrote:
>=20
> use dma_pool_zalloc instead of dma_pool_alloc and memset
>=20
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 0743925..ac5e954
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4238,11 +4238,10 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_=
t req_len, uint16_t rsp_len,
>=20
> 	/* Get consistent memory allocated for Special Features-CB. */
> 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> -		ha->sf_init_cb =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
> +		ha->sf_init_cb =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL,
> 						&ha->sf_init_cb_dma);
> 		if (!ha->sf_init_cb)
> 			goto fail_sf_init_cb;
> -		memset(ha->sf_init_cb, 0, sizeof(struct init_sf_cb));
> 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0199,
> 			   "sf_init_cb=3D%p.\n", ha->sf_init_cb);
> 	}
> --=20
> 2.7.4
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

