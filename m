Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8229C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FAA761040
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhDTOg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:36:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53806 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhDTOg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 10:36:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KEUG02026953;
        Tue, 20 Apr 2021 14:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=APxRMZf3JBAB/7ur4klqeEl1ilWiGzNvFrmpzIY9mYY=;
 b=fNkViUPJcTatCKuKzDa/nEPSQN58gLtOa8jSLTpFiTQq1efiSTnpwFBFVkx1KotnGKh2
 Zeiav4Mr7Km7+xC6d37EJJ/ClueRH6MJkDXLGrSdmViPn/7JRQr4puzOVODKJrMKm+KI
 3jNDinJRr9P+gGbSQoHabupsSKl9YxJLbMFlbt10qcEEzPxxcYJo0R36RqihzQr54HLF
 XwD+CzsiozNu0ISiekboL8rXstsCaf4cOwefnmMdtl6fbyjMCTc/BsRdgYneDerW6TFC
 PRLCxBj8I5Ap9ZfvGIyfJrakzA/pspjLHzIY0FjHQQfhdxyBOhUGsbw6bM6dVYSQTLio rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37yveaf1xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 14:36:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KEUoCR049275;
        Tue, 20 Apr 2021 14:36:12 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2057.outbound.protection.outlook.com [104.47.44.57])
        by userp3030.oracle.com with ESMTP id 3809ky47b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 14:36:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPJkSx80WXifyBAjxszkTkdoG+9Ma7P9E1QEX21V780J63fqSmKV0/yLe0vMpUR0r60UDgAZUcxZIi/9jj/BikWfYvQ2e/1SY4IDDBnbr12BbnEU2mxDMAfB0S9VNiHXVnulLe7R+HcK+Od6mxHs+2mryK6WqzDipOliaDwkLOhHMUMAnhMBdA9JoCyu35d2j9qx86UaPCJKHQJYu7K6RcMg6RrJoa0rNirf7lVVzM1/jURhrFA1vkdZYcX/PgaGTngE2NRk4P0Xgc8kaTpe9uuUJSzP8K6i3tg4lolzk9yx7GrSV4w8Yh6hKIS+9pFHjuZIHZwlutvY1L3UxqH1kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APxRMZf3JBAB/7ur4klqeEl1ilWiGzNvFrmpzIY9mYY=;
 b=IJwo4fQI5nOp5kVWS3v+iEFAXHL64lY+tt9nyyWEOd9IYyeHVo5AmCgEw9MCniB6H63NKjnxyUKQ7xy/H32vLqikaypHmIXBNQX3rc5AgJkvDQ9AJjBYfyPObE9vuvyzuMS0OhBi+encjoLfr7CRnZkOBUE0Q0hhCls7FyaRy5aBXupaQ2CpWd3dCFmUGimiJIYeBJHBEogMZqsAzjHI65yzhbK077UaVUjUAymkybukrkVnyR9grnjs2Rc34U6yZhn+eoeSlY44+sFU3Qd6bZz5FACOG9yxknVm4ILgbkg5gAhEfEnA4xX3lWwjbRTY/yPsXhdMcfBhJvzFdJG/4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APxRMZf3JBAB/7ur4klqeEl1ilWiGzNvFrmpzIY9mYY=;
 b=wqjAkRtEo/yk2bYwwCGF1A5nBnZPxpOj0GS5856BpbZA82DltDopKWqUYvzsbqljy4XWMkZBgDe7RKKWRKM/aIIsLuYesWxAQ19iJ1u/basGwRyuCEFPewhl5eVVlu1hP3Fa4UCzv2ZFECn3BJ/cIoq8HopHvudzPsBGhXrUhno=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3462.namprd10.prod.outlook.com (2603:10b6:a03:121::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 20 Apr
 2021 14:36:10 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 14:36:10 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bruce Fields <bfields@fieldses.org>
Subject: Re: [PATCH 075/117] nfsd: Convert to the scsi_status union
Thread-Topic: [PATCH 075/117] nfsd: Convert to the scsi_status union
Thread-Index: AQHXNXo2BUl5yYjJDkWhk4L177onwqq9eg2A
Date:   Tue, 20 Apr 2021 14:36:10 +0000
Message-ID: <67BD8DEF-7C29-458A-9135-6602192594D4@oracle.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-76-bvanassche@acm.org>
In-Reply-To: <20210420000845.25873-76-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a24bba24-b0bc-46f5-297a-08d90409a42e
x-ms-traffictypediagnostic: BYAPR10MB3462:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB34626E391D43A1E7DDACC4F593489@BYAPR10MB3462.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wdOb5w7YZrDZ9Q0KZHwOhDNxveJadUGROs+lcmrP7spRL9/xdQfkxVJQXXI1KkgaGjH/MXDgfhh0TwIGjsnD5yJbhSQiWR/EqredhU/MbRQ6znlbvY3lDKqETl1dRcJ0EYBAzVJFmDlevmHtYS+uu9TWjdCcwooJaKk3ordMxFRSZ1Z4RkyxQpVgqwVCpvm8Sxu8g8tTTJBQQXOelvCXjiyLvXCxFHOFsFk5B5KxCVMY1iuoQ8vwtzI/fMWgK6oSxWFCKwk1LHyzxfGAwcB/kAeNbw/GwSQt3o7Zb/214RbAGHpcyHaBFAqDmVZhyup+UuynM/5UOIrk61mbtZKFzFNrRJimXfRRfzJiHuan7d8Y4E8PnctNUsD5aN0cJvuRasD3dPZ4xLkTdIY24lpIQizRyDt+3zjPgy+oeOHSGCdMbgKLs0QCM38tnr39cn12sJNYdIYRgWNpNOYWltGvDz03gkYsHpMzfd+Yx7kc0Nxs5eUoDpqHFiSeuBV8RqTJgnJ0oPViVpEw2OgN6XCdx229fHhnRCCnDLOw4Ht1PKLGlDPuQwmFLIhz+7O0bplpE2m9sMZP8HpXxHwKXz0x4FoXc2SwdNUud6p76ymRMoqHTPNEgQ8ZNC6eL7X2F3daMlNIz/UYD9askd+Oyr91yEUYabA9C3U+ikzftZChKX0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(346002)(136003)(4326008)(5660300002)(8676002)(54906003)(6916009)(478600001)(8936002)(66476007)(4744005)(66556008)(66446008)(64756008)(91956017)(6486002)(76116006)(71200400001)(6506007)(66946007)(53546011)(38100700002)(36756003)(26005)(86362001)(122000001)(33656002)(2906002)(316002)(186003)(2616005)(83380400001)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aWXDQeyj+rcfFQNaI+giymeoiG9qI1DW/kdSXSd4Edmla/Sq9GYoiFEK9YBy?=
 =?us-ascii?Q?I157wI7vB6PfiRbHBhIaW/jxb84ALd/Brc7BgQit3nw7m2rA3csxrPVcUMJq?=
 =?us-ascii?Q?IFMSZnOY7QAYASyP0HVFUTQ5g33yoZYZaFHV4/IXNL5ig//nP8vGCxzEYG/N?=
 =?us-ascii?Q?glHviKYVDbLQvEChrTP3F8qWQ0O0+vt+Vxu6HbkEsYd14zIK/uNivZ2K7kCS?=
 =?us-ascii?Q?J7zsMR7UFWjTe3YL9wOYq8SufIM2fdGz5kU5j1ZCCKewEmSzNd8clC2kxaIC?=
 =?us-ascii?Q?x/Uer7Ravn/ytsWkY4GlrVjMLdTICgziO5YKBqVvvnhjvyopHD1G7wrWyxGw?=
 =?us-ascii?Q?aJjXoGbCncTk5sP/tm+mQWDXjcPKw/+rdoZg2v7nsE7k1bYU7BcU32dAjrBk?=
 =?us-ascii?Q?ne/H1Vt7oJvfhZU8P0pmPcTot01KcFBL7lLqECDx5ra0sKkl8mubh0jLynbK?=
 =?us-ascii?Q?zEey/fQi1t70nd1OiM4wUJHsZPdl/Brs+4IbVFM3+6caYYfwd3FFtn2sHXmt?=
 =?us-ascii?Q?0bvWbUBjp0Omgfhogjt+3e5bbSaWtRa8T2IHzNf0yGiBTZ4dqljpdbjBtddP?=
 =?us-ascii?Q?5XunScbm1q9S+aC08jTuJdY8IWeeQ+yEfCvBzL3ftLB6AeWQXj2CPurWwJEr?=
 =?us-ascii?Q?FrTQ1TPoDavdAc0C4sI3uEasLGQL5sAVaOoOVIib2/W/Rwuvk34WfDtGiJg8?=
 =?us-ascii?Q?yHgMJ3E13+acGeAI8J2QrfggaI4JM0U93KhPvaXOQcttEBl+xxaGdBKGqe20?=
 =?us-ascii?Q?xv4shwB/82ugKlBOJyMsmRbn7jhpnIu3IZo/rVCBr0PMLB7VexwLUTJ5og+M?=
 =?us-ascii?Q?S+oAA3Iifw/jebpKZYqva9xaIcirdzzwTnZ9Sf7DroK4qnFEGkORLZuJaJVO?=
 =?us-ascii?Q?Ge4FeHVd9ztQmoY9NTBJAQlw2Op914dyqhU/rNhXTYGMvyYSDUB/9THK6KQ6?=
 =?us-ascii?Q?vCUmrc3gJt7eNBH1IietlR7a4IFE77Cd+hvedxlFlMc11ngmSiNM/O472vus?=
 =?us-ascii?Q?GajFGHiEx5ybGx+B62N8rWVDcaiuAzQlG/qtocm+Oqk5jwbQoheHWisjNnpA?=
 =?us-ascii?Q?wV6UdBM588CvFDY2pKKlPwNiYV499wSpb19GbfuhRLDPRexivUTm7e9R4I0N?=
 =?us-ascii?Q?iSiUKG91s7W+dl+2P5KwV4FX1kZqtsQnH9lfi8pcdvFf5anPrDW/Md9pKlUR?=
 =?us-ascii?Q?QHchuXa+AkHkoExykkMIRBa6RBd2TmX+veE275+eNavAQNPDeK6f8zVz5X+8?=
 =?us-ascii?Q?BeW0p/QgtIhjkeG23HA11fMQ633EvcVnYIWdlQSxy+vG379mEqvHML9goIJi?=
 =?us-ascii?Q?6032fylakbcFQztx57Y87om899IGAhvuS+DSXDJv2RFVgg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <415CCBECC890F4459FC65AF375C69479@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24bba24-b0bc-46f5-297a-08d90409a42e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 14:36:10.4823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z66avVbHJpYNt4z3yl+RamHDi+7U0/74OA9uSA3J3vGSCC8tZ4r0DSuzesdKerPQYhXyEaoO/cNvA8wlEe4Nsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3462
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200109
X-Proofpoint-GUID: 6YizgIII3_KByhfwlnngVdZBL2mXcm8s
X-Proofpoint-ORIG-GUID: 6YizgIII3_KByhfwlnngVdZBL2mXcm8s
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Apr 19, 2021, at 8:08 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> An explanation of the purpose of this patch is available in the patch
> "scsi: Introduce the scsi_status union".
>=20
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Hi Bart, I assume this is going into v5.13 via the SCSI tree?
Do you need an Acked-by: from the NFSD maintainers?


> ---
> fs/nfsd/blocklayout.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
> index 1058659a8d31..f10f559684a6 100644
> --- a/fs/nfsd/blocklayout.c
> +++ b/fs/nfsd/blocklayout.c
> @@ -255,9 +255,9 @@ static int nfsd4_scsi_identify_device(struct block_de=
vice *bdev,
> 	req->cmd_len =3D COMMAND_SIZE(INQUIRY);
>=20
> 	blk_execute_rq(NULL, rq, 1);
> -	if (req->result) {
> +	if (req->status.combined) {
> 		pr_err("pNFS: INQUIRY 0x83 failed with: %x\n",
> -			req->result);
> +			req->status.combined);
> 		error =3D -EIO;
> 		goto out_put_request;
> 	}

--
Chuck Lever



