Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E08C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7944965101
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbhCPQ2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:28:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48432 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238730AbhCPQ1h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:27:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGKwAL170999;
        Tue, 16 Mar 2021 16:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=95L0Fgn5IdZG4FCSiXqwyjve7ImZ9WULv10P6+fgHXU=;
 b=O7AszTd+IcYPQMxtC1K+v3oS6JBJapGyL1pzcrAvhBluMDJs5zAAtkfRG6r4+zmfRavV
 nR8XcmdagR1Jb/Icr6LkEbA3V3fd1olSD6jH/EIs7DQm9z6X21iPzrOgeEUMWxNdMl0f
 /Bj6GI9k2J7zf099BPaj/ZJNr0Ee4cjSQ4+TqS86p2e2eElhOzgpE1/VaWkrUBRKvW9Z
 x9XXOQwvhgTW6B9jRe2AkeY+OOiB2Y+T3iE/vt8wxtHsPj1gGPtvMtuUoHwNafe4X2AZ
 Y+hqtR47LOpcpxQpqp5C2n4zzE7C6iWmrhqHE9Q45XAoJSg+PMUaxhyq1Ql4BSThfvGC Hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37a4ekntqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:27:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGLbPp125688;
        Tue, 16 Mar 2021 16:27:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 37a4et5j3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:27:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuMRBxQe9C3HLcvKs/z3LjRcxJQjtKgO77EVR3CwXj3WNhQJPh7kK9LLpwPRtsA9HsZ4gBUdvLpPPgjz5QTNkAhUTz4VAhRELWHM1ld4t+QGn68+T0lxkLuMXZ4u6S4I6QwBj9QKZY/9tgWX2oFDcHtiCuT6N3VD8+TSpnwKbYtzHc24UOAARYb+OoHTlp4KwEETx6DrYYd28nWVZOn3pgRK5sKBu1z4MLPmpBKeen7EDj/9GMspHsuMmLl1dx2QZhV+UBK2EtDk0/dM9ool1qgsoSLvJvrMg4X9ljJFf1v/Kpthgf9ArkPbxlDZoyh3kEt1/4B5jf2xDugnhERcHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95L0Fgn5IdZG4FCSiXqwyjve7ImZ9WULv10P6+fgHXU=;
 b=j73+7kJUID9oawPAu6uPeP+qj5/DBtuAZh4AGgn6KnQBk6kGjHvXCAatKL7tn0iMxHg6WdM8LWwQX6otNyrxDcGJ5pHUxqCJjT4lZujZMWC8e52Km3pLVPmGZsV8cg10/MGpK6FviKlZx56idlwiTw4PLLz7CfDR+GZU9jqnBoxtrp/TpZb+MppxxpX1mimHlp9Qlo7tuCFAUkOC8RQjUBhhYBakqMpnn1k2fDaVsVRrIs/pDoblQ5ffvILJ6QgKGMGTb1+3+PAGv67siechbZvBxyX6FJ4AJkMkq7BcCHxoj9IZTYx5EdhNXeJPvTSJ8RtEs7ArNDh5RMMjHFvfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95L0Fgn5IdZG4FCSiXqwyjve7ImZ9WULv10P6+fgHXU=;
 b=SBx9MP0JV6Jqqj2/Jw0jpOMyWn4PfmSCLXHWZM/oQd7YYCL60MgH3VzVY2ac43nkpvNixSqlz9Uo4PNZ+5kdufepsLbJCJljCHMWvA2NA5ml8qDHEPOwCGhKN1Jf4zEChamtwekOGBCFLxkpRWAciFfH/3+OeVEOknBXVQviAYw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:27:25 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:27:25 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 4/7] qla2xxx: qla82xx_pinit_from_rom(): Initialize 'n'
 before using it
Thread-Topic: [PATCH 4/7] qla2xxx: qla82xx_pinit_from_rom(): Initialize 'n'
 before using it
Thread-Index: AQHXGhhyE+xCZLGvPk2MOyalH70Q+qqGzk6A
Date:   Tue, 16 Mar 2021 16:27:25 +0000
Message-ID: <2F8BBF1F-16D2-4191-892A-3F15A9B43EF7@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-5-bvanassche@acm.org>
In-Reply-To: <20210316035655.2835-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea3c1cf3-89b2-4aef-f2c5-08d8e898627f
x-ms-traffictypediagnostic: SN6PR10MB2464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2464251E60356730AA73404DE66B9@SN6PR10MB2464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5RnCbiyEGg43FgPXwyIx7ELXGKJxK9smQIGfBqKZyeNT0KqYGBuqhshkEoAe5LTvvtc1+bQY1tSwtaNu84A7Nopq58PtM+9+9Cmx7o6DWqlysPOhTrkYX4KjL+e2uo63c3FaUo0KlHnOzYpePKeFP/kc+B5YVCXwbtDeCvcLh0v0a42lJTT8IQYGLBU8uP+ABrzu96WOxkFlN5humS01Uaz835Nbd5aok6bZHcWr8YadWWXcYyKhuMYT/bpP4+6tZHvIRqFVrG4QhA58VCfKOlwranmkyGWXvC+3x82TGcLaq4u5hfjAS4tKdPwS1DoLObsYNI2pxt0HSYEwacbxv69h4p82MtU60EaKT8cKk2SqvMXl50cAsgbh0SGF7HSx801qfoado9LI+pN4u5tUwq0nLtSDvkC/UtrlwM6qVqC6dmvTTbYOLncKk5wbU0xTOIVdseQrm0KMTn6uju7uBT79u0UtNXxI40t41kqkzwb2Rbpwnx1CbLEW9YWJ0M3s4clO4OV8l3qHjOGqXs7Rei3W4fnDT9ha1BW7/dQwT/XG/WTIY7vMzcHZikw3WTqtolEvJjLHF39lnsZefdnnhBBXB7o0kgeZ3KwwSwvXGfIs5PigaWmMbOGHDBPxNl3D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(66446008)(66476007)(36756003)(6486002)(66946007)(8676002)(6916009)(316002)(64756008)(66556008)(2906002)(53546011)(33656002)(71200400001)(6506007)(54906003)(5660300002)(478600001)(4326008)(2616005)(8936002)(26005)(4744005)(44832011)(76116006)(186003)(86362001)(83380400001)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vfSNdbxUKoNZB97oTfLwocN4QSRha3MaxtJ5uBqOfy+laOrrPJY0IzL+DQ3C?=
 =?us-ascii?Q?RsyrMXVAe9A5Ez5kd+vJbSlZ17m9BCBe1DELWdPwfTh+IU5v7clEkrlLzrhU?=
 =?us-ascii?Q?bHtBAHuMqX8Eaz47hMw7NhAQA4SWhyO8uBe/qkxnDgUMud5dPSwNqwHQttTH?=
 =?us-ascii?Q?rOVkIoOce6qjpfMWIpUt/rsJlOIyzUCOx+cHP4B8KV5n0GDq1RnUsoDZ598A?=
 =?us-ascii?Q?k9T2Do8y7QOScrNboRPSwBQTCC+1CfAL85F7iTAQh8KB543A1w2uKTudzjAC?=
 =?us-ascii?Q?B4ne8s5r8b1UzLPVuLMPS1y5k79LchO2L6UUGCk4zIQ1EPbhV3PEHAF4+hRM?=
 =?us-ascii?Q?fCQhQFmwFzJ80Geju2qbbtUpi814FheHi3X3JLRcnKphNRl8+3DujWk5xySz?=
 =?us-ascii?Q?E3VVWZu4dX54Lofom5z0/xo1BCnoW3z12hnCOstHV1siNcHGs6ISFVOj2zsq?=
 =?us-ascii?Q?FA3lW2v8Ql1Mj3ZeJfgXAtOqCHkvnfav97q+JgmK+s2wDjrirEE60SfRSMbt?=
 =?us-ascii?Q?Kt4Ae8gpSGz17HuTBLnOQZBEkdn0HcXX2CYjxRLcZyaDGGicJ1xgabAS+e/h?=
 =?us-ascii?Q?XqoD+bR6KVXvhUMvqOkAsK/hTDPdPqJbXxlQ4U9n0pP1MYxbMteg58mCp6xT?=
 =?us-ascii?Q?0yPg1JyXGx2l9Jt30m0ao8HTGjGFVLFmpDtHN/oQZb8LvHHYDzC3gK/h4/Tx?=
 =?us-ascii?Q?JQxs1y+QyIB494UQ2aFFuHnhErU0ZNbF30oy/ljbe/Xyz5F+jqHQOtJYRmVk?=
 =?us-ascii?Q?hcCSVgLxpPg6Z6gqKmQfaj8B0ejJY07x2Z3u8+9FeshAfJtMsBAdy/ZtMLJd?=
 =?us-ascii?Q?FcwQyMfNiEMsjBq2IlhDdGPa0FdJGT5RLXrQtgPHqnbGhz8p+3tfGacHxUhx?=
 =?us-ascii?Q?w8NqtyJZsNvOqL6ybIUTQTuJJmet5Z6ZfJfA5HeHV9hcxEDaKWzjX34I4bv/?=
 =?us-ascii?Q?wsc5PfXcCnpdromiCRjuxSRfdAvQ3jFlc6ywy28nYgjGtrhCCHuq5b3yBd1U?=
 =?us-ascii?Q?zKPj1mnbYMzZ4HBwon46RL6ajftOSOcVbx5bEySDIegiw/CEBoIPa21Yb3gt?=
 =?us-ascii?Q?T5zaregICatlnkpbZC/DiGZGr/F+6Xo3SttRgwhGDus8GQ+FzBgpnhbwzWxb?=
 =?us-ascii?Q?HC2qDhKITflTgcyhGrZJO905kcqZtgpefofhONiT/2s4bMf0PcK8IKi1ttEg?=
 =?us-ascii?Q?FS7I8zP47FCXsC2kDg6Q9tGdw7fl+aGaUKL0ppoKUAYMt9QHjAWjQCTm/3Il?=
 =?us-ascii?Q?0VS3ig6U7EHA3lqqf0r7fdkyOkLCYbQg0LlMovJ2INibEVfq6PJHDP0FmrS2?=
 =?us-ascii?Q?4WJ3BOBfUVmDQSFNqzlME86yZaz2ctwV5YjRX2BTvN76ZQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0692B441B06A1F489FA51E37E188FE7D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3c1cf3-89b2-4aef-f2c5-08d8e898627f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:27:25.6611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xw2ZQLhuplqnw0keLNJVD33QUIGklYnVKKSJpDjPPoHC9+mp+8KNj0WRfB4K9r94Yl4WYQ4V4BnP7o/ag6LSErXr3wmrxETTKyaMoJa1lVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 15, 2021, at 10:56 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This patch suppresses the following sparse warning:
>=20
> qla_nx.c:1218: qla82xx_pinit_from_rom() error: uninitialized symbol 'n'.
>=20
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_nx.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.=
c
> index 0677295957bc..5683126e0cbc 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1095,7 +1095,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
> 	int i ;
> 	struct crb_addr_pair *buf;
> 	unsigned long off;
> -	unsigned offset, n;
> +	unsigned offset, n =3D 0;
> 	struct qla_hw_data *ha =3D vha->hw;
>=20
> 	struct crb_addr_pair {

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

