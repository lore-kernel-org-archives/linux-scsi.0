Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525D7C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D96F619F8
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 17:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCZRxu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 13:53:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44802 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhCZRxq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 13:53:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QHmvdZ107718;
        Fri, 26 Mar 2021 17:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qz8DrYJo1TzE+Sm1+wEAGIRBiFPKuuobS/93c2x2fqE=;
 b=MZhOUoKHHY3uUFaHJPKee+ixyNQvoqg6XcG6PUMj3Du/kCgMAypzD2ZPW3nRPxBpyMzL
 MDutMDYWbQBBISVpcYPzK1gY1VF8Se7Qo6glPIYJJ3CtWA7bSb7dDIpNOhsQDsCxl28Y
 MbrV++MKLEvyOoOX0xm0XodUBXJNeUuECHW4MtzrMFooMLFDWSi45wt+e+o8XfIk1+Ch
 FBd2QPRiT3GfC5l2CLgqbC/D2rRWcJjjHn+adGyz5HFn53KrSUpa4h838qZlOz9WA2Oz
 VdvRU8FjEtgGRAICMuM8MQE022RoGyCMU7/FZR74z0lyCWobSIp0yiYvvLyLF70HH6oP Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37h13htwsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 17:53:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QHkZdj083463;
        Fri, 26 Mar 2021 17:53:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 37h14ndrd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 17:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XE2hHYIHDXNzONpiYMedjDnrDmQ8nQKn4XB3oe9gsP5sZNk0xbo8NX21Yp7lxHIoxP8ztE4HhQ1AG7LwRMqKERQDuTz0gV6xLZC80mpzNMUrSGUS3EQL8Y1tmRHZ/Z3196t0KXC12vbm+ihV4G3OJDdq7NmqhrnUcaDXzXurFTSGRD7oX8tbeEZnT7zBe7cxGG/gblvJq0ULxDcMRCRw6614QWUIDtLECqAOjie82g09SzMqP/H9YL6vp40xjHQFH8RUdd2RIilRcHo7iEM5akpUk/xm0QUjI/1d/kSN+FvTE9RIiqlJlUtZziKbuA/PrDhmURFTAqoJs/8Khyxcfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz8DrYJo1TzE+Sm1+wEAGIRBiFPKuuobS/93c2x2fqE=;
 b=I3H2JLsvBeh4us7GrIEY+0lHXXw78pxtz8GWe3qA/S8dbA3SGu42AlujZKBjf2osDhStbj4j+NK8wxSYGWL9ntfx2XNYQSm6DUuZb5RvlM/rITbE2OzsAkALAhKy7lgOUjxV091PWgmlYglmZI9n40BKi4NP5D2x5zJpviaJyZV3+pNfrA556CgBNj8VRsV7JeksrIt1V1OxQ6MmoOHbJ9xlvK1/uZH9tfbcp6jBSp5400t5+7GPSnd1T17JHrjd8hqPZdz1otmoMUOfNtrYBgChZZlvsP3Gv4OqN8GLtdvVkV781jJM7EDLmE0Xp9ZTlZswIvPPngO5EWaucrRJ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz8DrYJo1TzE+Sm1+wEAGIRBiFPKuuobS/93c2x2fqE=;
 b=XuRkrJCDWfMs4YFE8z6wuUENCHewD5x4d/qX7buel2PdQsQoe0gIcPeQzWFqVs6zZZV07fLlgQYJB1pX4Ny79SeR9sGqi48j+DiyfhlxD/yPdGs8gBMix10NOQjxrupLS9FfFY9IwaqmEhiwJ+VvqTNBiRHTQ0AbCd4QA34eCQw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2462.namprd10.prod.outlook.com (2603:10b6:805:47::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 26 Mar
 2021 17:53:38 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 17:53:38 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Quinn Tran <qutran@marvell.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 03/11] qla2xxx: fix stuck session
Thread-Topic: [PATCH 03/11] qla2xxx: fix stuck session
Thread-Index: AQHXH59eHd5CtoHkrUakRJF4FqUzAqqRxLoAgAGHmoCAA0R0AIAAAd8A
Date:   Fri, 26 Mar 2021 17:53:38 +0000
Message-ID: <4788993C-2E43-4A60-8424-1E47A7CEBDF9@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-4-njavali@marvell.com>
 <bd9dd526-776b-87a4-9b81-634ce687e393@acm.org>
 <97BE89B8-9B44-4AAB-AF5F-62E7E3A6D622@oracle.com>
 <BY5PR18MB3345D49A244A704C3C70EE2CD5619@BY5PR18MB3345.namprd18.prod.outlook.com>
In-Reply-To: <BY5PR18MB3345D49A244A704C3C70EE2CD5619@BY5PR18MB3345.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 347350a4-6580-4d99-a6a6-08d8f08015ba
x-ms-traffictypediagnostic: SN6PR10MB2462:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2462069EF8750B416D0EFFF6E6619@SN6PR10MB2462.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kz53GOamttrhYiquv++Kf123VPrk80RJbmXt3BkMu6requTgEAXEFuvICnC+lmCfiMzaLcPllLQjiKjs8Dw3zfOQ0b28yJw5ZjFNJEg8eqXXVdDVWA5gfDdxgVcpErEHfy0FzDLdfkiLd6ph4rr3zh6uCyWstFTzP0TbprQKLhg4KJ1f0cc+3wAzx0cdTOosj5BLw2LmYUNnxqYTmSk1PmPKvjtejE9WAiOWburHPsMqTIyPmOt2YSGrBXKRLGsuowOM+hiqp4MYMeNpRsU4mHoa31wMPU04eeO3cveDOytYwhMhUiK3CnBQezrKugT1BXMRuMN2oBZYEC1BVr2sl98NI964qaXYOcyiE/smZc2aL/PakYrkmZ9DhQkKdR8sQSNVwE6q6yGvfcHD0Qar+Nk9vzxwP7c8Bh5ykQfXIyqwdRj83ILgT728tCZzphIUbC34JCnDjNkjtcDXJSNXjOKII/FQbzKw7jS7EyagWnZ+TUPPjvAuBNAsncTerIOXBsp5af8zy+XBvA2EkKLcZvpxxvHTi3dEbU5t7ywPgJMEbTBUERDz7kvX69s0dcoukJ6txqxmK+rJt8JRGM1Eib3c8TaeGPlZtGNdZ3Ti80D5qFsJdYsaLF8Db7rLo42SjiRiblvS5JphgZO8OOf4K1WBcKWytcEXT2buaNcDCA5HVh0KyRY42UURYCp00uXX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(366004)(39860400002)(376002)(26005)(54906003)(2616005)(316002)(36756003)(6486002)(8936002)(8676002)(4326008)(2906002)(6916009)(86362001)(44832011)(64756008)(33656002)(66556008)(6512007)(66946007)(478600001)(38100700001)(6506007)(76116006)(186003)(71200400001)(66476007)(66446008)(53546011)(83380400001)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PErguRk3KwEwpr+66V5VjKoHtc4nUSQ8BYyQyDA1vqJbOPZlDgoJyjJgt57s?=
 =?us-ascii?Q?PXMY0fgM3Lk0yuEIj28W8KHjzLdOpzr01P8ryWpTFSuDWQ1uEGIpC5nsBD1e?=
 =?us-ascii?Q?3/C9a/i5qd294YZNrNV6ds0HhyBQ4+TjBL/kcPTIQy506+o0eg5S8R18IBjb?=
 =?us-ascii?Q?g+9Cv4JIma08Pk25ccPLFK5iuPbQVym0OKJ/iKCcyksolQcsfQolBhCA0c3r?=
 =?us-ascii?Q?3JJoUxsIGEiBeRnZKPoaoXJUC6wG2t/XRP6XtTY5n9ZlnHsiW+MkuaTw06Fx?=
 =?us-ascii?Q?KMwIRPOxjHCpG2Sy8Ld9V7zLd2yeQXKX8gP8uwGIAfwj4nmCauAy8Oxi9ACU?=
 =?us-ascii?Q?YOezGpN2xTJ7dHi9dYlSr1BSCunwZRbCz7Ku7QkJd97I6xltoMFKWny+t2LT?=
 =?us-ascii?Q?QKNNAh2S332KrK8qQYxfatzAb3FQrWF6tl8PbUTS0myE0dYy5cJiMYeBQ/yi?=
 =?us-ascii?Q?p53DD1kjrMnx9wJXfHo2x01S+lNWCeCU7HLPpgWM7jx19YhUKSSnXGgG4Jwo?=
 =?us-ascii?Q?myZK0o0CMu4c6XZThGS0fMti48jx+kUFbEEJlYJ6LvAr/52ieXA7J8Cl0oWs?=
 =?us-ascii?Q?YkxGwTEDfnuYhaO3eI/mvQagRdUYu0yQAP4zTEGXzP2Y7rJbb1dO71viFAnb?=
 =?us-ascii?Q?0SZMxJ7Cq5D8qSiI0x2xTPf43Zr7YCoP9pEUmMtmq9PTRXUGuAjYGGyKVzu9?=
 =?us-ascii?Q?FokZ5yRt/JB+88qg+MgC3CLf3wytCM50qBlvb5VSsKDKsC4rA/PI6ik2UK9B?=
 =?us-ascii?Q?j8Az0BgMbWBe5Zv34Jv5l+EjSsjzrPCr6N7Ylohpl/qvD7Rs/cHULgqOOmPx?=
 =?us-ascii?Q?Ce/n+4LHnBpHHNbQbNGdQj2TOJN1J6nyRz8ykmAr5Fj4BuDkxWxjoOrwnrWH?=
 =?us-ascii?Q?rdJyBgWDc940ExW+y2yiCdE5mAPqPIbpeQjyE1zQHgf6n78WEm+vBQRFbesm?=
 =?us-ascii?Q?X/zo3do+GRY7vZatrZUZJlLPl7rUXB2pAhrwJnq6lygLQi+uWQ1KfXvEJGdn?=
 =?us-ascii?Q?po7aKk1biKbF2gCUE30evuOZaFbugCYXsMWjEqRWQYjJ1rZx2Cnho9uwUZVl?=
 =?us-ascii?Q?PaYT37Bxo3h/KO+F7fyQeg567had9gu03rRKdQF4jHl9e25K7Q5nSGVHELLn?=
 =?us-ascii?Q?S+aM/IglOePnU7YQyOKZoCLlfDJTYm11uivmFr318sH+Fcvbz6BBJJ3QbATk?=
 =?us-ascii?Q?9vZ0yzMQh00bMw116XeMRM9dhfC0RffDPc4Uz/Z4BFIxgqGcdafP37t8Eu+4?=
 =?us-ascii?Q?9CfGfXkqkLbqTFPgOMLtm51QsJgTjJuQei6tYiD3MrPZjKKumRDOQDKkQ81i?=
 =?us-ascii?Q?AqZybIdHVItz8y2fQe2j9lOmeefPdjAD9ecNcPb7LnpqJw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63D97D562B0876418D8480FB545F3626@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 347350a4-6580-4d99-a6a6-08d8f08015ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 17:53:38.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2XubWncDZvSxNiXi0T2HaGpaJ7SaVQ+/gFJSiQzh5L+HEwOlWlOVyTrq3Vd/GABnKj/CeRx0xOyI+0/FT/C889FpAEaJlJ4kpQsnktBf298=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2462
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9935 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260132
X-Proofpoint-GUID: GxfW_4OApj9Npkad4DqQk1Ea-wTixGfk
X-Proofpoint-ORIG-GUID: GxfW_4OApj9Npkad4DqQk1Ea-wTixGfk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9935 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 26, 2021, at 12:46 PM, Quinn Tran <qutran@marvell.com> wrote:
>=20
>=20
>=20
>> On Mar 23, 2021, at 11:31 AM, Bart Van Assche <bvanassche@acm.org> wrote=
:
>>=20
>> On 3/22/21 9:42 PM, Nilesh Javali wrote:
>>> diff --git a/drivers/scsi/qla2xxx/qla_target.c=20
>>> b/drivers/scsi/qla2xxx/qla_target.c
>>> index c48daf52725d..fa8c4dae8dce 100644
>>> --- a/drivers/scsi/qla2xxx/qla_target.c
>>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>>> @@ -1029,7 +1029,7 @@ void qlt_free_session_done(struct work_struct *wo=
rk)
>>> 			}
>>> 			msleep(100);
>>> 			cnt++;
>>> -			if (cnt > 200)
>>> +			if (cnt > 230)
>>> 				break;
>>> 		}
>>=20
>> One magic constant is changed into another magic constant and that is=20
>> sufficient to fix a bug? Please add a comment that explains the=20
>> meaning of that constant.
>>=20
>=20
> Agree with Bart here.=20
>=20
> How did you come up with this new count value?  Some more details (either=
 in commit message or actual comment in code) would definitely help underst=
and. If you have some log message snippet or stack trace add that to commit=
 message.
>=20
> QT:  FW timeout is 20seconds (cnt=3D200).  Driver time out is set at 22 s=
econds (220) to monitor the logout (2 seconds pad for worst case).   Changi=
ng from 200 -> 230 to allow the logout thread to finish its sequence before=
 advancing the state.   Previous setting at 200/20s create a race condition=
 where driver was allow to advance to relogin, while the logout completion =
straddles behind and modifies fields that interfere with the relogin.  This=
 led to session being stuck.
>=20

Would you add this as a comment above the if() statement for the future wou=
ld be nice.

You can add my R-B to the patch =20
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

