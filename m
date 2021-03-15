Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E79C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 19:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CE8664F2F
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 19:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhCOTrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:47:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48460 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhCOTqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 15:46:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12FJkT1u046682;
        Mon, 15 Mar 2021 19:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LbjHobQ6RtHHRnNICspPL3mCzjpgfdpVjTrdvgfkt9w=;
 b=knT7pirQq8BvfVtoi80nTe3JlgN13kCSeyGnDKmSw+eqBMFXqXeyKoktrvJxJMValI8T
 J0tAWfOYwAAXH0EUySu/G/zzgN7b+a4eHfSdw1tnA3gbVxZyVyzEwiVOgXBSsV+XfxzY
 V54LB4s/oL57sEVnQ9MFxif9T1ki4fNp/a7/ODR0zwdMDp1KODxSYPqV42L4j332nA5C
 WVCSICZv7h7gAk08iiMUA2Bcfkr6jfA5nkQsUtp6pAt2fCM0f/nF+wC/EMVubiUwXWMF
 FhGsvmcs3a5i32pSP9Mf8jDGc5B9mrHNaXY9YSreQPoEsxe6MEmZfadiBMBIpNgbdhDH 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 378p1nn880-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 19:46:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12FJeXNW160853;
        Mon, 15 Mar 2021 19:46:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 3796yshyb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 19:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XD7H0pNJN1tRhzWR3ucyGKQ17jxIIzvRypDmz+KyrQ7As8kt9cWd5NTbgO1GmumIqB7iuNrsC2Qvj0F9yTxp578wYzZ/pwz6b1/34Nmjvs0YhiuLvOy468D6rxPmEbrpaNtSdDmRB4HEUTu53R/0uOxT/WS76sNibbYbE6pVWKVdyT7fj29MIO70htNcXhfDk7NSAL5tpG2Yl2Vqu8OLTPiPn6+AJeh5+D2wUc6I5s4T/1KcQ0J0YZIFU+Ny7esiBccMgSto6S2we6H2Fz6uu1UPMeOXVi0+f6VWkPY+8D7i9NbCFB4CKoKCeW7H6VLOQNdgOVd9g+8WkL6VS/3bTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbjHobQ6RtHHRnNICspPL3mCzjpgfdpVjTrdvgfkt9w=;
 b=aEYH6iGWUBkkhtt95hShwXmiikwbM6OolgbaVNGJp7SaPrSXEyLZ7/7lXE86lBvlSoWDlMt4Zho/dnxGBS42cTVSR6w9+mpoysJPSs+4j7tf4n8S5gEqPgspvdhwG2lt/lXasGgVF4wB9iFeDStLdnuuNOY+9efeycH56q8XIb+7huIoGtoiBOP+wuloj89o2ueUYFsURKX/iX9UW1paFbXLrkDLnNGMdM5na7QfSx4kTwqi4iP0gyup586qILdM/pOavzEkCo+LLwX1HZ59QV/XfEJfusaSi5BSgfbDhV7OlRYNnCx7AdyWGnac1lK13XfyAJx5ypXWuPZ+7v/D4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbjHobQ6RtHHRnNICspPL3mCzjpgfdpVjTrdvgfkt9w=;
 b=bSm6JFuTl8b04HiwBcU9kaKVKvCuV2wv49vsSktb3StSqKB5l2xNM+LwxmxMm6IbbbTZCXkOpRvUmVI4jjyY1Qv3WTDMJQMAMcT3EMrKwM+iXRf6Z4ugYsRnBnzjTY6XIdrJg1unP2K+ReL+TvzufHsNMhlQuHxolTI1nlfTkHc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 19:46:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 19:46:32 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "njavali@marvell.com" <njavali@marvell.com>
Subject: Re: [PATCH] qla2xxx: fix broken #endif placement
Thread-Topic: [PATCH] qla2xxx: fix broken #endif placement
Thread-Index: AQHXGOdkxuaVMSkd1UGk+ikaMVb2rKqFdfyA
Date:   Mon, 15 Mar 2021 19:46:32 +0000
Message-ID: <04F8D192-2569-45F5-8F6A-53EA135F0CE0@oracle.com>
References: <YE4snvoW1SuwcXAn@localhost.localdomain>
In-Reply-To: <YE4snvoW1SuwcXAn@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67d9104d-122d-4b54-75c3-08d8e7eb08b4
x-ms-traffictypediagnostic: SA2PR10MB4459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4459B03BF46DF3462CAB9840E66C9@SA2PR10MB4459.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m8VhGcI5ihjlir1ovlkvgX0fWb7KA1Du/U4nakfHMTXufbD+DNFMh02vP4mX4lZkmcB/ps1xmbqhJ56T1+sy0tM21D4y6YOsv07eYk+/As7pNr4TKhidyCEBj4SIn4HMW+sqYWyvgLCKUoq+Z1UDPQsA+xpqTuVWerHUCfCLzQdHS1tU9FhV9+AfanI4ohdB6ETfWAy39sGbMWCIjSMJdSqFkddpqXDn2Mvq0goqy7Ac9x1C8QURe13BFV7ZnJuBeusW21ydf/DmBIoNiGOgplN4Tl2I+ukySwceAeOtXmqsKJx7f4dpyjG/7SXLp/tVoSTY7P/0eFTDK77ZnZ9MW8ClBJtQvs9T3A2/g5tgmiszpHwTV/jc7dYF469MnTL6TiTICaYvd6kg28CmJuu3kOdGEpb0H00qbcNAejFeAGTgTrcvCeHB38WmI0wNNUoIK5T/69TR6uY8fVIJAWpCL1bG6eYr6mEqQzpJ7bLJUDx+Ofo9NlGx/8/6SFI7XNhEwE2Ba0zSRrjKKrq0kZjAobIxbLtMCGASCXlE7koAO2aM5NomJMtGKA7kTGTWoOw+uhmRyynIJXzBN+VbTJsyZQA+XJhaOXGeQINwv39QHqN3RLaZES2CG9RhQMkX2/GB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(2906002)(6486002)(186003)(6916009)(6512007)(8676002)(44832011)(26005)(316002)(54906003)(71200400001)(76116006)(53546011)(86362001)(83380400001)(66556008)(64756008)(66946007)(66446008)(66476007)(8936002)(5660300002)(4744005)(36756003)(478600001)(6506007)(33656002)(4326008)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VF2QrWC3cQFZ/GGWmDSUpeh7qOLDMEr+TCX2oDYKfE1hULCC6pxW3aqD09BQ?=
 =?us-ascii?Q?ka6YKJzWtYgCtgrivuNUexpC4i2588G3lInTgk9riaOmdb2e+37ya20bNWUc?=
 =?us-ascii?Q?XI4WHNz4xwLENMsGN/x9HcIBNAvDSiNZo3moIZuDCE9uOQtulTCeh1Ddj3yz?=
 =?us-ascii?Q?h75+QSIiKtwfGmnsy6CPqnaYdDddegIWuMiZH/NAb+5N8x1twPOsh8ROG0Vh?=
 =?us-ascii?Q?M01BPdCV6+N1ZYaYhw+cAg10irZwIo4WNJu2ZC1gluexE5CEeVtlccxg7Bsn?=
 =?us-ascii?Q?4E8mcgGeBzXzqOoyEBRSmrE5CWIC/I+qSwq0KIdt6duxXuFNe3Y1H7T3DvWU?=
 =?us-ascii?Q?ttG6kF2s2k2UsXRx0Ke/1gWZExjdjEl70k3ZHWyakaXhZHZPylK207f9DZMc?=
 =?us-ascii?Q?5onnd1kf0u1IV7Z+SfyavSMGHH3HZJ34IY+6kWRF5NPDtxpzqDRDWpFVNWJn?=
 =?us-ascii?Q?7yBAU4OxXOnD8x3DcjWQrT9az1wqbjkdS6LoWmV80jXciZq83pMtWDuJC+RC?=
 =?us-ascii?Q?OAd+UXONhbtgtHLGlmuaqgQTUKyw1HBff0B+6rkbE8n9p9vIOR8FtVjXi3VK?=
 =?us-ascii?Q?ti+mj3BrAx2le5w+Vzad0cy4+9aK5sYvenrAugWCWTmPMh2N6aIVTMEWh5nn?=
 =?us-ascii?Q?pn/KBMtEdeSgT2xtqirdDwgcKZXqHyeD6QHq8vEGO6BR24QrgC8B/Q1oqnwd?=
 =?us-ascii?Q?0eJKELYPKrzkasBGjjiWzXnqAHGaPN2oVHxSiuO9vTfJv2VkTx50GDTH3inY?=
 =?us-ascii?Q?Fx4aU3YgtufBh22LJRkSHSwVYWvy1wlifxKELyxtG83VuQ6sjORTYnaFKBJB?=
 =?us-ascii?Q?9l6hcdGvvn+Vj1j5pkX0UVP65paUegcfe8O6jvXLf3dXI2wRSKcQ3bsl7DgZ?=
 =?us-ascii?Q?DW6v8D3Lik/3mgEPiaF4rKTm3zAK8eXMf7ijmwZZqlvHzvdMUORwUOJgqi01?=
 =?us-ascii?Q?hzR1GEyZ4uLNQ0h8hIUNlVe+NHgc8rB2nfTJY+aZobY0aiPHut0VyvHGFvYo?=
 =?us-ascii?Q?yExmd/ubVe+1tTYkrxZq81hx5cgWy1A+9/qVh0JqudehtcOJ2xmCLT2v4p2S?=
 =?us-ascii?Q?IsMJPiLpDk2YVGq9PGiHncvDu9flQ1DIGBuvAKM2jd0XuwabQwiu7oLP95hA?=
 =?us-ascii?Q?WzYMGZzZlz+J69bWwbjz/SXCTXjLKawzNjvFMfdhv6LLq00FQhgZSJipIPr5?=
 =?us-ascii?Q?c94a6NTf92cgR6xBkIiX71oDoIVENhOJSZswnkYQ3WgdrzodoRoDwxqxqx0c?=
 =?us-ascii?Q?DpnX7tnYExZk/PIF8yaqtmkeIxPT1Vv+e8dso2DSyg4dL8B4iJ/P78ygO/yR?=
 =?us-ascii?Q?07PESXpNNEdV6Ik+2I36pRx4EJ+b/xmOljXbzPO0a1U8Bg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6942048E53E12C43B6E81CF2C2AC865E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d9104d-122d-4b54-75c3-08d8e7eb08b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 19:46:32.1111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YsydhTLPPAnXixS4pbm/mAXkcr5vEn0jfpV7fdF/DjAy/9l0YHgJloq9x0HO9wNA0YmFXMV6Hz+QCPKBqIavtErKMjNPwXA1o7q0dBnz168=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103150132
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103150132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 14, 2021, at 10:32 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote=
:
>=20
> Only half of the file is under include guard because terminating #endif
> is placed too early.
>=20
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>=20
> drivers/scsi/qla2xxx/qla_target.h |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -116,7 +116,6 @@
> 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
> 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
> #endif
> -#endif
>=20
> #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
> 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
> @@ -244,6 +243,7 @@ struct ctio_to_2xxx {
> #ifndef CTIO_RET_TYPE
> #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
> #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
> +#endif
>=20
> struct fcp_hdr {
> 	uint8_t  r_ctl;

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

