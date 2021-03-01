Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48935C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05C8764E40
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhCAHkp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:40:45 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24635 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbhCAHkg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 02:40:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614585033; x=1646121033;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=uDZ8d8ipfhy8+I0lBJraB9Y55i+BLFQPx1cXxZjdJog=;
  b=f+V8op08fTEOWAuxTM0AYghUSwhkJP3nUtWjuPfPlQfM+pJSBp7cku7X
   2Wugo7TaPmpDLiR7xlY+hDDWd4UXaVd+8fjYWqwLUVvUYAeD/pGWxMwFQ
   6mwGG6IPHj1W9ndrDFCJk+m2UPncyv96iYnPNm4GZH6m6BPMWRDzW40EG
   d0/XNOj+2BgSmvs7q0rNXy1NBwiVOC5fnFDUP86UrCEFggZl40L2UBpHB
   i2DMRNWHEZaPbTip5e6W4VPZAJ/QeTaaYxTRQhBjvyPVQiw8y5uxSIagH
   yeCsYHfDDOINzBAvHA3PUXQ31roAXQsBJRjYkMHrSyiNBqae0+jJGcv9g
   w==;
IronPort-SDR: RW27PVotLh6jl1sURIi9++Uvb55wnbsQKXN6qaCL8lf8NXvDNQA2j7yMju7IRs7b7RNf4fnods
 CatrN83NdOGsZYNOadmnLtSmmPBiyQk9hUfa44a83fwb0PQIBf24PlANUmd+CpqjtnlX55crxW
 sfjs92faiVpCnuKNjSkBdKl15jocV7WmmxRvCd+10uRB+1+F3JA5sF/QLAnpOymM9A4hVffI4L
 Xdj80+RzKEyEXH1mLqmHDv5n1OlNW9dWCAHm+YbTFbftcS0n0bm0rEtWIIZYph5s6HYEp+HosJ
 pe0=
X-IronPort-AV: E=Sophos;i="5.81,214,1610380800"; 
   d="scan'208";a="265309613"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 15:44:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ie2GG/ldR1FbebwoHQM/rSWDk82ohvzorcLm/UPjftdsjLlP6LtMVM7ooJHh03gOc7diKxCLvdRHOBy2NXQbqdCKPUKdQ8GxAP3YO6v6M3ODpV+hIqqliTJwGgCcycvT8M6aqYHBvw5xIZVvtR1xSHQGph7Ty1coHZ+kbf5xrW4J5VzCU+wOwQvwoAJhZVwzUoLyT/WsFTB60jzS59/jkBK5lsVG3YrE42OPtpIPGQRTP8Hh67xIJC7cXpeA1G2zROb8nAKc9kMoyO/8BOpllh/8JBB+jjPQo0ESr8opgacRFkTPRCJb31BewgdcIaMXZVCi++Lx6jY3OPsfhQzASA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqkfnDrk/wVZ/RRNn3/U6pZI+zU2n1Pe4+l8Kkj1bnc=;
 b=feqY3aShoT/QN/F4FY4J47c3zBeaIWDaBvM92gQ0IAr0i13YWKL7Pt0/6aefj9MGP9gSSau9t5uk2cFs2D/st98QXTj/yepD/pymWkUln9m273VGUUPeTW/TEpXa092sX1Q8M9PVaz9oINDpFQSOxF4JvPykGEfyXMWha3G2y7C4oPwlGkWCh8YOuTS1pV/ONFLRapDcep/S1k7bXflI/VJO+cXg7SeFlu8y3QQtWZqRkHB8ESLxOLBtSF+lw7JOmwre99GuIywx8jXYu2FBGI+WKae/IBzAK8ULGLDKoWgkDoPhMPtx/QV5ruoCVRjSWFaNAyqoDIj69Sjq1L7qcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqkfnDrk/wVZ/RRNn3/U6pZI+zU2n1Pe4+l8Kkj1bnc=;
 b=OCtdcljnFptFuJaXYo5o026JSjpaNLcG2s3TbVPg7YrpTCpRqa969vKnUcWvlRIdob5dJBDEjC5gSFHpeA4BLkW9edTXW2LP43BIK91gDTeiUz0/6nWsqQpS9CRhTr6acTXAqTkbNMvRvqAeoWIEyoZPmeJ3wQdSNdpXZX2g6jI=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by BL0PR04MB4530.namprd04.prod.outlook.com (2603:10b6:208:4d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 1 Mar
 2021 07:38:06 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 07:38:06 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Guido Trentalancia <guido@trentalancia.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command failures
 to keep using drives not supporting it
Thread-Topic: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
Thread-Index: AQHXDbGOoQvSctH05k2iblGBdDcQpA==
Date:   Mon, 1 Mar 2021 07:38:06 +0000
Message-ID: <BL0PR04MB65146856C07649917652E540E79A9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1614502908.6594.6.camel@trentalancia.com>
 <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
 <1614582394.13266.11.camel@trentalancia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: trentalancia.com; dkim=none (message not signed)
 header.d=none;trentalancia.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:347a:bb00:3286:307b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e7d574c-50df-453e-b984-08d8dc84f42d
x-ms-traffictypediagnostic: BL0PR04MB4530:
x-microsoft-antispam-prvs: <BL0PR04MB4530CC75AF40CE00DAA3DE4CE79A9@BL0PR04MB4530.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SJq7meeeE4cD4HQnLJUnXQt/Ms9mTQ+XRk4PZz08qNQ23/P7DgP6FU8DSPyRMenHoHO44RLP3YjECGc/fFeLBxmJMBoqne1btL76hIDbNboB2u1HBv0c3kuweUfpDeK7WdvXcocnA9u/YsPrdveYZS/ZBOdWek9FvGE/1JEDb5PohKo2LhnHPZElmLmJDqkBSPusXpG/vJs2MVuNqvzWpuV5BtcWEFtR6Kji6oUN5tyJMsrbilliNWJR9V8CkgAh9CN211a9vWxNTx20WvMzYVGvtp1PsEu+qQz9epelDIL6VEdQm1V8yysflNWBE8DkSflns+9Uyg7FATJP9QjOUukE7sRYIC6wX6gHk0mohMkkPrBJXhkWqYUGa5r6SWXg1VG/ykk/emqpyDRl6jh64PhcCLLsAlIESljJbYciEkQZ2n2Zmqoc5hB1Orwt/HmeiF9EX8wMzaO5vhV1iMzO5xtltjMNXAWfu2BS48yxusWa4pMHH2VqAiChmz/2WthNzvPwvKrCxHKhyrWMWnIRfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(8936002)(8676002)(478600001)(71200400001)(55016002)(110136005)(83380400001)(5660300002)(91956017)(7696005)(66476007)(66556008)(66446008)(64756008)(33656002)(6506007)(316002)(86362001)(186003)(52536014)(53546011)(66946007)(9686003)(76116006)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hNCWyz62TIJzm0G9Oy9LpwFM3Ev3Et1lWLEf2SKlHONyFzIyHIKhLhWWPIUC?=
 =?us-ascii?Q?eOfCzT3XFirLWZ7vZHpZ7kQIlvORLxeoeLDcpn+8YQxhiCnVaJg14E+I6kl6?=
 =?us-ascii?Q?C8KK1MavxSBhJP5xHPYY5XJV3Hshn6lmeqtHDJsk1Ajvth4QIuxHUTmRBL30?=
 =?us-ascii?Q?hx2w3+g8nmITuAaTK078w2OHFwyIfn9sQGyk+giVvnVBNJ0V01Xoe6praY1U?=
 =?us-ascii?Q?ZCt2Ur7rMrjtFxC9zXDS/8lc/Cb4k0WvjLf3w2pJv5MfGoWZVqCWwZLWmaKF?=
 =?us-ascii?Q?MqgdFRRhHaxPZP3QdQPDTp8ENVIZ33IZ4uSX+kOf/DKUnXNv7bzT8yhcLFzf?=
 =?us-ascii?Q?tWsHprQJ5+A0KeOlQpZyAO0azvwKKA+3TvGoMzKGGUPe+rM4mtZ3x9LO3XRG?=
 =?us-ascii?Q?+JjHamC9MUZrD4Jp3PZerCb+zqes2awN8Ui7O7XD5R8yVEFELAZGuPrH8/Ct?=
 =?us-ascii?Q?atZeTaddi9cDxdjckVGpel1TxJbD9tfWvviHq4M4dCxNl9xbFdWHYxw0MxJY?=
 =?us-ascii?Q?OvIpJymhnLJZQts9PeM9bR3N6PZv/fcvlb2ThBrB8po3D0JGCZR8dRO4xVaV?=
 =?us-ascii?Q?2I6uX4wjl+L8zwgVyThBnZeUCWzck2nYDmjgby5GQbBGQskL8/SPtDKwVBQK?=
 =?us-ascii?Q?ffjSmV7xdvBhPt1Dj49Cf5HVbI+y8zyu1OLcSWxCujZW6ZWT4QhY1bzCaZ5J?=
 =?us-ascii?Q?Z59goDaYBf7QhGAkA+/FcZggEoM1NHCjPg5NuPRyk6EPF54OZVJGfcXRQCYo?=
 =?us-ascii?Q?2iQ8ic1PVAheAU2qgpJUhEg4uDg3gz83jL3p43HKpD305TXbXi7QNyX6CJ3O?=
 =?us-ascii?Q?xT7oGxOxrorVTZ/m/LoGgEDutXo0OKo1IQ9I0MQdwcZNMri5o9zWu5hoJQPA?=
 =?us-ascii?Q?KOWo1cSc8+T+uuIuKCRtVUpEPSHkc0k1g/mHtnxZrGppuaJ8aC4P3IbYKEac?=
 =?us-ascii?Q?3iyI6qEPwykIdwZEN91onA30yc3MNyoG6astKOD0iBiLajzS0rrYhsr2UMDw?=
 =?us-ascii?Q?zLYrU0dMCz5VygNO2Fpy43KEsV4iJGgYpuTJH92Kg6AWWC6f6S6jbAW7/vzd?=
 =?us-ascii?Q?oz4TiJ/Bt9pMNSmgwF/iMUAHcsbe55npY+RERU5Ah9Jhj8W/WC9ic+JLYr5K?=
 =?us-ascii?Q?zikZEbv4Ye4TZcpGJdO+xhd1HxoY2rk5lvQk6Z6MLE4Qh4IpHrc+wxC5N2PG?=
 =?us-ascii?Q?zMuvlq9yEzF4O5Qodg9XcseH0wtsJcXwOLl+KwsOCnBZOxwXmRr1yndADsZx?=
 =?us-ascii?Q?OA155waua/sfuzL2hS6mHGmtcSRnLjaUg/bp4mX6DU7O5CT+mJq856a0W9ta?=
 =?us-ascii?Q?hiR18UbcTgxVJMybj4c5II9o2swYvD5omgAIOVDUdQeFVBFxfSEtAXKKY9Ua?=
 =?us-ascii?Q?ofxpekIekceJC7yiNMmAtiIXKMkDYbU79vaFJ4YkXWM3u1TATg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7d574c-50df-453e-b984-08d8dc84f42d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 07:38:06.1872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c9obs9iq9BZ3frMkLbn/oocQ0tIxVwth+IJ909k8gifImj2Ft7fVfaYObiSU9UbUeWAjIgSOW+zrcatgZspvFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4530
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/03/01 16:12, Guido Trentalancia wrote:=0A=
> Hi James,=0A=
> =0A=
> thanks for getting back on this issue.=0A=
> =0A=
> I have tested this patch for over a year and it works flawlessly=0A=
> without any data corruption !=0A=
> =0A=
> On such kind of drives the actual situation is just the opposite as you=
=0A=
> describe: data corruption occurs when not using this patch !=0A=
> =0A=
> I do not agree with you: if a drive does not support Synchronize Cache=0A=
> command, there is no point in treating the failure as critical and by=0A=
> all means the failure must be ignored, as there is nothing which can be=
=0A=
> done about it and it should not be treated as a failure !=0A=
=0A=
If the drive does not support synchronize cache, then the drive should *not=
*=0A=
report write caching either. If it does, then the kernel will issue synchro=
nize=0A=
cache commands and that command failing indicates the drive is broken/lying=
 =3D=3D=0A=
junk and should not be trusted.=0A=
=0A=
The user can trivially remedy to this situation by force disabling the writ=
e=0A=
cache: no more synchronize cache commands will be issued and no more failur=
es.=0A=
No need to patch the kernel for that. And if the drive does not allow disab=
ling=0A=
write caching, then I seriously recommend replacing it :)=0A=
=0A=
> =0A=
> However, if you are willing to propose an alternative patch, I'd be=0A=
> happy to test it and report back, as long as this bug is fixed in the=0A=
> shortest time possible.=0A=
> =0A=
> Guido=0A=
> =0A=
> On Sun, 28/02/2021 at 08.37 -0800, James Bottomley wrote:=0A=
>> On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:=0A=
>>> Many obsolete hard drives do not support the Synchronize Cache SCSI=0A=
>>> command. Such command is generally issued during fsync() calls=0A=
>>> which=0A=
>>> at the moment therefore fail with the ILLEGAL_REQUEST sense key.=0A=
>>=0A=
>> It should be that all drives that don't support sync cache also don't=0A=
>> have write back caches, which means we don't try to do a cache sync=0A=
>> on=0A=
>> them.  The only time you we ever try to sync the cache is if the=0A=
>> device=0A=
>> advertises a write back cache, in which case the sync cache command=0A=
>> is=0A=
>> mandatory.=0A=
>>=0A=
>> I'm sure some SATA manufacturers somewhere cut enough corners to=0A=
>> produce an illegally spec'd drive like this, but your proposed remedy=0A=
>> is unviable: you can't ignore a cache failure on flush barriers which=0A=
>> will cause data corruption.  You have to disable barriers on the=0A=
>> filesystem to get correct operation and be very careful about power=0A=
>> down.=0A=
>>=0A=
>> James=0A=
>>=0A=
>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
