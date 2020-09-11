Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDFCC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 05:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135AA21D90
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 05:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="bUNKv3VV";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="qXLNapVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIKFmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 01:42:08 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:37627 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgIKFmD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 01:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599802921; x=1631338921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ukuzDAUSWcnF4prufpRdNutZ+FlaIj08UOWrBRWarU=;
  b=bUNKv3VVURlZ6xuG5gT/i6X6DHAojbmh/yIEtRn21a1e03hdDT5iKzdB
   28dHW4qf9h/gq5ExQBjt1+NI+P73TJ/t/HdL4CzG1/KxGNWyK0einq3zk
   Vy/Qib/z2zcSyzaihiLJ/d0mn/uGtymFVsDhRr0bZf+Wxw9XP0+D2apGd
   QcCHEmt0Ea/RAmjPjvL0r8lkJIgmGWOEQfj9AJmlrIkpkgs4TxUSK1Pc/
   SW23a5zCmxC8gHTw0tLETuhNeLXCqimoEaSKoZgb7n61qEXqVzCvnT51L
   5FCHejcH0C1x1pCkFkKq8UNHTLb0mBN2omcLKoxU69yb/QdIXpSkudkX/
   A==;
IronPort-SDR: gHnxlYtvxOtGw7V/8b0O0DbF1XHJ/IGnriQjM2qBKzpqlpJHidCql5K3kGCdc48q3D4SjXunq8
 Xi/h3L4gZLFKwN0nueCHPcNYZdzPungusL8FWumY9vj172kvtyY3m51WIePB2v+uB2Mg8F3Mj/
 9X7mndwxcGzTg5NmpbO7p4Zswb/Bbg6tgoKCa0SOiCXHhCaQNI1qbVkhD85xzZeFMHkQ8p0iJE
 Er8tkXbwqgVqBXdqknNp2N16OtJCTguK+A0k524D27ExeF0gjdqCo9sFkdxIAPTjO4SCUKcq28
 d6E=
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="88676071"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Sep 2020 22:41:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 22:41:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Sep 2020 22:41:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avF4VKJ4yvzBtuYqfUHTBFMqCDeHcg2ECj+NKgV5maX5+QvHqqTxnmycIcAbXJojFnQDjgQPQMB2bavsQh+RXwwvtBziS7eD9qvJhCVOGj5iRJrhsqnvqOSBU8up1hSOKRnLpxU5djT9jVkR0pQhW1DzKMDYs5MPI7DT8mpehnqX9amK7Hi4G3anNbasli/xI18WjKfgV0ytDxBqCN2y2vN9t2RP0OLW5NDpuRgyAWit0vCb47xoV2itEWLH20bURpce2LlH6Ehw0XU+Tx6y9F121D91LTX9VK92L+9fEdM19q39EYWmroCICsFp3zuI8lkDW3+ANVq7+2wq2qj9Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiVWFF9cNXc/iq64l3qMm4sZYu0VBnYk/r1W5ie1EU8=;
 b=Zci4OAPaCVF1hEcEBZAgnIo6zQvxgB+lMUnccHvLhTTmHFnTjki2P4h7hlXmFS8ggNYXrU2Fpchrr82fAYuAcFK/Qr6MN+X0LMO3hqnmolWDMG9Zs09B+iIHGxq5mHfV7Dx0gF2S1i0G5j6u/kX3dTfz3z30N6zsTUPNCz/eUSXhKRdi8LF1mjUZGJE1vIKyq4wnj6OBmPiINc4KSz64SUBK+lv5GLljIaE1rAMFmybu2go35Xk8S20wkpkGcTCfqwRYQucgVy6T247ByxsEaDjANUfHe9XqYJuIoo/JMkxtg2sH58N7xV95Febzog2EuAVlVi7aL2YR/jgsb0UaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiVWFF9cNXc/iq64l3qMm4sZYu0VBnYk/r1W5ie1EU8=;
 b=qXLNapVfh+a33Nhu4F42+VrGicLIoZQJCsk5FD5X/eR3h2pWD9dUsHUj+TWTA5KDAJCp7tS8RWagd36LMfdm3qaxTCR5qBqSnnWxIMOWqQMkFg9vt5n4uh/sCpW0PL9vmdS9QQbBUnCeRJUEv2qRuAYFC3a6+Xw03T/65QgwzxY=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB3248.namprd11.prod.outlook.com (2603:10b6:805:c4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 05:41:56 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6%6]) with mapi id 15.20.3326.025; Fri, 11 Sep 2020
 05:41:56 +0000
From:   <Viswas.G@microchip.com>
To:     <martin.petersen@oracle.com>, <Viswas.G@microchip.com.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Deepak.Ukey@microchip.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH v8 2/2] pm80xx : Staggered spin up support.
Thread-Topic: [PATCH v8 2/2] pm80xx : Staggered spin up support.
Thread-Index: AQHWdyGWFMJ2LWitWEWbukXdJDG1gKlUoF5sgA5p9LA=
Date:   Fri, 11 Sep 2020 05:41:56 +0000
Message-ID: <SN6PR11MB3488EA8136D36F11D93074919D240@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20200820185123.27354-1-Viswas.G@microchip.com.com>
        <20200820185123.27354-3-Viswas.G@microchip.com.com>
 <yq1k0xdf006.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1k0xdf006.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [43.229.88.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b6fbe86-cb77-4165-6e0a-08d85615651e
x-ms-traffictypediagnostic: SN6PR11MB3248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB32480A1C4AE38B041C6B57A49D240@SN6PR11MB3248.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BcDyndX155/DC8dfSBYthrq+NgmDoPHWpmOZRCICh5nJ8V1cZhepm0HkPT9OGRwj34Gw+wf9jd+b/SMh7C5lD64HLEGJ+3NbiANpQWODuNebKZiw2EWzWUNjJT5grmVVKmSjQ9oBiCxWG9MHrC2AHJ8S6p4pgW2Mn5Lz7IoKt15lEO+bMUHcX8pQHAzTICIyArcQKlwXvG3tOx+lYGgz05mYDyF4/WKiysjddNgBdLQiDTIelzl++8gKG7WnRNerj50KHVe1D/U1TE7QfPj4G2kUlVbT3DSql1CNa/3iaGeiWoSNru6GWCwS3iDmsxxN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(136003)(346002)(376002)(83380400001)(66946007)(33656002)(54906003)(53546011)(55236004)(2906002)(26005)(86362001)(7696005)(9686003)(76116006)(5660300002)(8676002)(110136005)(71200400001)(6506007)(66556008)(8936002)(316002)(52536014)(478600001)(66446008)(4326008)(186003)(66476007)(55016002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Y7JevPA03zzNJfxrwoImkvk7eNx+jeLGJlEK0acBs1jHosp5NtCQ0cy3vaVtmO1LbJVge5LFR1UwgybfzceUiR7lulQ8QDS7Mb4QshxBOxgye57qHiiCfgAO4qatGLQoc33qv9qKWAA6C94PWb2FHeWKnvLdG/SuOtM1N89fMvOtcQM86hfAWVJ5eDLgozyJoj3gGVpQX9bX6PtovRNWKfkx6G2oc8dSQGok68PpNC0RsVYt7397Vs6frD37YqBrCKDD0sloQbnrmluMS1xmdA9/DZtNpY9bLJDuTmaW0opGLAtnOahIQvbbso27ed4uyAfG1XynyHIXzFEx/s20R6c90/ZQxogxT3Hxb2QtqPdcex2d2DxSSsD+yfNMt5F/5UciRibShD7UO0aiow1Bmdu/nALeKKcqj2/p6BUUALdf064umO329Hyiq9cMSFt4CevC9JJeyXNJ/pdjlYH1WSmRcJ90hIf+UC43IrXvEcWIIc4tw7lj+T6SUCdWh34quet11por9xeFr11UivAcp1xoPYFLxi5c7oS5RW0Jn2OMfuG+uP3U+uOYNehtLoqafHp39vIYb16SuBvTQyimZB1ym9lwtB2GS5ETTqY1S+bQnKXV/uOkDSW92NW4RmSzZowQxHxDAUi6T6Pirs5NHQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6fbe86-cb77-4165-6e0a-08d85615651e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2020 05:41:56.2051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SbQuB9YJSgNp8Hd4mNxTgJ31xizlAtmOgrOTEiqaGXEhdZ35cLbqIRoL4a+XnvTY/k6iQHhv3yAW0CB5CFnJ+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3248
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,=20

All raid controllers, newer HBAs, and sas expanders do this operation in th=
e product firmware itself and there is no mass need to have it done in libs=
as. In that case, Will it be good to keep this in driver itself ?

Regards,
Viswas G

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Wednesday, September 2, 2020 6:51 AM
> To: Viswas G <Viswas.G@microchip.com.com>
> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664
> <Vasanthalakshmi.Tharmarajan@microchip.com>; Viswas G - I30667
> <Viswas.G@microchip.com>; Deepak Ukey - I31172
> <Deepak.Ukey@microchip.com>; martin.petersen@oracle.com;
> yuuzheng@google.com; auradkar@google.com; vishakhavc@google.com;
> bjashnani@google.com; radha@google.com; akshatzen@google.com
> Subject: Re: [PATCH v8 2/2] pm80xx : Staggered spin up support.
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know
> the content is safe
>=20
> Viswas,
>=20
> > As a part of drive discovery, driver will initaite the drive spin up.
> > If all drives do spin up together, it will result in large power
> > consumption. To reduce the power consumption, driver provide an option
> > to make a small group of drives (say 3 or 4 drives together) to do the
> > spin up. The delay between two spin up group and no of drives to spin
> > up (group) can be programmed by the customer in seeprom and driver
> > will use it to control the spinup.
>=20
> Please implement this in libsas as several people have suggested.
> Thanks!
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
