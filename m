Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBD7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 14:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB9461056
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 14:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238878AbhJFOcf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 10:32:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:37850 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhJFOce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 10:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633530642; x=1665066642;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jPHzSlj68BnpfDglCodUisnb0iw2DzOOSK7e4r2wGp4=;
  b=Fi0Ah1kEB1pGkXldtSCOJ5mOj4ZA/tiowEjFUqdoZN8sbT1OMedG//Sg
   DdIyALsQ7kF/sbPzANuYr6PGUaAOPmbdJoEYezvJsgSLEScJTLBaM4Ucx
   WYUzA0ck0ivl0EpNLpmbc7eG1qk88Es4aKnDdRp5p9Qes46dV+fAIBI8v
   2cmy1fxQCFLgBUG8WZAMLJOqTth8P8R9Um3sQIRJCVBJcFQQxqNMGF3Yo
   1TrOep//zV07t5AxPb5b0XNKeVBjzxRx451x5pZQeY+J27pkMzzKMqFBq
   qf05K8cXonYiLgPTLwoy18E34gzhFrBrJfsGB5gmGYQVJjsiEjGBkJ/9h
   g==;
IronPort-SDR: +0/A1O4pc9LZaAd29ZaYcM5GX54oVA1QVwey9jsEqq3itDDwrFxHTUw2haC0KNYBfUy9n0/wcu
 ioY8CGiWAQBj3mPLViyaO0lilMd0RPoOxT5E+RCX/S1ljKYnDBjurqSlBwtrbXVYBHMYEnN96E
 0pp21ylez/5CWtouWNNLyvsLjDe8CGKo/NdcifL2V+gf9ZcT0CGq/wgEwFeYeC/cNcIKIO/UJH
 eHiv8pZgtDUCENus6RlJXuXw1Sh70q96iNBFpmoSMSIzumV086rNz/kBGU0IwyapsQPVzjZvwn
 MqKbRRdaGfKQiIOrCMb8ACDq
X-IronPort-AV: E=Sophos;i="5.85,352,1624345200"; 
   d="scan'208";a="131931704"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Oct 2021 07:28:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 6 Oct 2021 07:28:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Wed, 6 Oct 2021 07:28:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGsh732OsxT/4APnNR0e8GdMMbh/1QMEbVp82EyfidD4acgd56fvE0tScYQAE1aDc+TiiW3xOW/5Jd+aJweMifVephup5LhVdwZ2mK05PQnuZz66q21FJDi6d5FdMs5hA7Q20LTXcSPbevC0LqDzNKevckJEC9hFUCLQ6ndtkdWYRDdKUUqalHXqAas4L4mRlihMpcloAMsXdeCaP5jOuTRQulwLOx8fT3bL5gyJefrm0hiKPL/UD9yzAVYc5yixkm6H7CY191dL33V0qU16UizKowiKzsY0NeOrN4h1HQry1XqO7VZXPuDl/5h2rn0EevQ9t7n3BNEfg2QIZTm4Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6vvA/NEeiIKhXWikP3ebCTs3r0SwYfqNiQSJtoCb+U=;
 b=fSm6kq8Gy9v+3lDdpZ2SpsREGFCOX74zOWEW5inEc1DL6OPQdV6WQ66D+Z7EoagUAhW1Nd6nUdCUWF72kziRnNfWHbwPBUI760jsx3TsYiW/rQ7A+l+vI3ugmoVggmapkDMyf9W4vJuKwhZinGHHX8rGOLWjICkRuNy4dbNQ7xm2Nda7N4jc4a1ULBaYIkyrmcmaOg2uPB6VqUNkxvuCg3q0/sBVD4IcPIc70ZtIPegwrJotU9fluX43X8Mj+s/aaNqjZuKJcJtBNQ0ofEBmY9KaMsyP7e3AQKR2dPoq/edevkHLwyISyIGn22s2W5hUVEK9EeazTfthwUsyZNaHkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6vvA/NEeiIKhXWikP3ebCTs3r0SwYfqNiQSJtoCb+U=;
 b=hDJk0O06vLIz285xHgtW45dAeadv+CACAfEbJBhdpXMg1+L+CQUSMJ9ZCi1XkVYrpJ7fXX6X42c/Ku7XjHdsc10B2vhW9uYlzN0vO8J4Sd+8GVNqxRvPGj47EGFTUAn68z75mdOytt3XTUp7dgWpWojjDP4Z7ZLQbFZdUd3Jj9s=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2669.namprd11.prod.outlook.com (2603:10b6:805:56::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Wed, 6 Oct
 2021 14:28:37 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::5858:b334:4b44:e7b1%7]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 14:28:37 +0000
From:   <Don.Brace@microchip.com>
To:     <martin.petersen@oracle.com>
CC:     <pmenzel@molgen.mpg.de>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <Mike.McGowen@microchip.com>,
        <Murthy.Bhat@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device
 nodes for tape changers
Thread-Topic: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device
 nodes for tape changers
Thread-Index: AQHXtMRDyP+n2ZsizkKB3YupoAAg6qu90n0AgAcPpHCAAGrck4AAxf8A
Date:   Wed, 6 Oct 2021 14:28:37 +0000
Message-ID: <SN6PR11MB284889475EC08A5405F2CFA0E1B09@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
        <20210928235442.201875-10-don.brace@microchip.com>
        <1351a25f-5310-cae3-ae47-01c842e0a185@molgen.mpg.de>
        <SN6PR11MB2848E6A6F6824C55641FB6FEE1AF9@SN6PR11MB2848.namprd11.prod.outlook.com>
 <yq1y2763mr9.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1y2763mr9.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6d0c9ad-138f-43d9-7fc7-08d988d59606
x-ms-traffictypediagnostic: SN6PR11MB2669:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB26697A011510F8B7E9023F40E1B09@SN6PR11MB2669.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qbJjoN63UvsRmMyfSdqaB88fJ4YsicPSgTqSSo2DK6mNMJfgJNd9P8SVHuihy6hSuwKJKEF2Ot1RoIHOMnRIpXDUMD+V5qUSpvS+XehVOEIgNVhNXrJC4sIXknGPkHu7yDNumwF5hHzAfm1YGPmJzlufkZBTu3S6tV3xGQhkh2wPk9Oh6rJVpV6nz2gUPNym8qV35Bj8yCiKq7mWRpZIWwaqR6uXj7JtYJsPWlL1PxpdJle6e1uFOf3FXsyHbFUQUmqnQyRJDLO0FX/49YCsRryFpWArtuW/Qz6DL2/BpNKi/HAhcuWGf7u3c7IQDZOMJMUS7cGEwf2wUtS+7FWMDyHu+871+fpkicntEDPd3gbqJwai8+nLkwsrPDb/C5HsOA2tU1MCyeWsCpgZDMlbsw2WM1fqiHI8B6A3FypvkUWlTB/280IJvZ7K2M/XfOLH3yRaV2CmjjxMeHn6xJ5drUndRFAxpdv01ai61ZC/747ZehR+kQkNfbF3daGI2NSQGKm6xKpH7JQQyqJMyWxn3LTimUwM0XE4boG5mwqrPdCNHxOfaEhOFvDM/BhPT+QY0xLkY60qMsy/zIAWFEUhLT69iorKQpIlhfuuW4Ajc+ivItgKFpUD3kNUq7DrmR+S7iJ1MoZXNknWWj9Y92IoJz9sjfbGaZIHpNY8lI4/a/YAeIlLzDukaF9QoXur8w8gNSnitv2oSSmTqOA65Wop9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(186003)(66476007)(66556008)(38100700002)(38070700005)(86362001)(83380400001)(2906002)(8936002)(26005)(52536014)(76116006)(316002)(33656002)(5660300002)(55016002)(9686003)(8676002)(508600001)(64756008)(122000001)(71200400001)(66946007)(66446008)(6506007)(6916009)(7416002)(54906003)(7696005)(15650500001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z0nF3LKR/0S5hWzApTiqyCY/NYpzDOrrdx1nYW8k5LewRhiq75vnxCspntu5?=
 =?us-ascii?Q?AhXyYrTTH+AREWIMWz7YE2HdDij17nDL8AEa+K4WTcpC4d1vLVxDGSz1ZIhm?=
 =?us-ascii?Q?atZ7q+Eefm2r+r/HSOdQczJKUvkP4eOi+9RtJMVtelJpfGPfl5JXVkadTHb3?=
 =?us-ascii?Q?nPxU1XuE87/rzTEUJ5X4JNSj2Fmtv2ZakTQyGU5xPnOMJiTEVJmWGNPMTodv?=
 =?us-ascii?Q?jz24/Z7fsyVzmzWtMOkEBXoP4YksP+8NBgqXoLA2YECyJUDBxBK6P8TEwO2k?=
 =?us-ascii?Q?XDvg1ToNiAMMoOha5McH5uwciy+uyXJZaUDcAUM6UnF2WtiFSlTg6tZ2cIpA?=
 =?us-ascii?Q?e2qMlz6Syr+V+hZ0g8SZ5FV64K4VAeoU3pb+3K9/HXrs5VSgMHNGh9swYXcQ?=
 =?us-ascii?Q?KTuMmB5iSxQdVZZAkU5QSykpvI4R9UAwcf8Oxz5OSNBhZct6skLTWw/4xqny?=
 =?us-ascii?Q?mNKpze/yyBbF4QTZK0YmlnvPt+kVKC8PkgnpkFgp/EenNPPHfT4JnsAe6fpp?=
 =?us-ascii?Q?H2xYNezHDGQ7vQ70MAOcrF1Y0zIpwjuEGdHma0OfEJrDEn1SOAJOTrCeaVNV?=
 =?us-ascii?Q?m0qRTwPdskcoYy4kJMxTeog64f4eN9xAVHbhEN5nNtIvcHvyRZeJ2S088rYr?=
 =?us-ascii?Q?q8qBqHps49ftdQb7I0sHF9MDTsjg1RWkMHEyEK81lQOXYm/8iaWcQT8tv+53?=
 =?us-ascii?Q?EPF5nhp2TZhnF9l79vp6dNLRcSuRHcAckcP/ewhWNuspES/bXppY4UAWOdb6?=
 =?us-ascii?Q?KKq9DGhVCSnBLMZssjmcCqfE8Oj/qqbE/5DWwgu8GDafaaXSdym4Iw5vsWr3?=
 =?us-ascii?Q?4p3f1g1b5BuDiJr6nEjmaNcdUdjM9PC9U8zvbPhlCI1LWcyBOj3X6+pRmrJd?=
 =?us-ascii?Q?CHVWFZGqFgVC5JZKVRl3cmuQpK8QnCdW5FKN+lsJhJ2PLPpsjDJrpT2fyYg2?=
 =?us-ascii?Q?WH0blRckp4OjG0qFA0kIL2G4rVb041Qq6A9WMKXfzA9ke0kp89IQ9h8MmPpd?=
 =?us-ascii?Q?T4gSCOPEmYnZUVuLmXMoktN/D1pAtRpOeMG8WFjweOs4qgW2FfFljEWhRXvS?=
 =?us-ascii?Q?RmFkS2LqS8lRwcB3Tmp4Hq0pyRnQlZVzFX1QL1G4r/cCGiPpJiIDJhITGniC?=
 =?us-ascii?Q?2rtyNdpm1JibK8nFcQsrukB2uOnTeO9fe2xQq5zdgdnp8UGy/WE5qnAw0XEf?=
 =?us-ascii?Q?3dRwQrhNYcznhhH4ey+OXZDvuzU6JkGOE08K8fQm8zHlmM7qgloFY3LK/XqY?=
 =?us-ascii?Q?BdRqv8QEWHTwmnt7b2RcyskNaUzkyRpqUnIEvbIYmPpe6IGtFwC20WGf6Igh?=
 =?us-ascii?Q?Hhi34qR1aOt5zEOcb0ipTScO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d0c9ad-138f-43d9-7fc7-08d988d59606
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 14:28:37.5076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aLHyfAF+/kxbMVdc3PcJoZZ2czhrucBdpXK+8cxv0YRxHGiRTpHxh2dm8ocZiuDgZwsavVwWvSn057fwAC1tFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2669
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]=20
Subject: Re: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate devi=
ce nodes for tape changers

Don,

> DON: Done in V3, thanks for your review.

Just a heads up that I already staged this for zeroday testing yesterday. I=
f you post a v3 I'll drop what I have. But I would prefer an incremental pa=
tch.

Thanks!

--
Martin K. Petersen      Oracle Linux Engineering

DON: Incremental patch it is. I appreciate this.
Thanks,
Don
