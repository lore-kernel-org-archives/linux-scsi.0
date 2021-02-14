Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A16DC433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Feb 2021 14:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1853D64E61
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Feb 2021 14:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBNOWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Feb 2021 09:22:13 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:3666 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhBNOWL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Feb 2021 09:22:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613312531; x=1644848531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L+Ty76Ij4ZnGxwdHclLP47sk1M2heWO2vWPP3Lrs05c=;
  b=Ylr7DoR3Q0E0kfGN88QpbfGU+DijCLrasLfmcB6G/fgDw3zkPJRBk3vk
   yfVYxzhDJMwBUDdHbU+3FXtVsL4uLC8EcRzOgL1n1uwtIiEPkozBb4NhT
   Ryl0kiGilzrMn9Bnv/bhrsBoohuKdJEAR7NurnehRX7K7TOjU6b3uUTQQ
   p+NO9xC6CgC+dGYJGCwWf9F6N1F89happozh2hjtnsTEEIrPEwGVcPyux
   Jf6nb7KV6mMPZUBMoEsNAyc76bLSmoaW1dFXWv8KiJzMvPsBZ5RIq2dJM
   d6hs9C+GIp8t2mr/eF55V7MrLqkS36ZCKJAe3YIMg/pNhF1D8D1taZQjV
   g==;
IronPort-SDR: I+uZuJaJPhUwEtGPHRHOIm9IjKyDuJWfxVKHB7i6q3Zu/0vGKgrbYg3/g/o1lZr0+/UW5CWpMO
 FXqi2JU/w/Pok8+GLPh6kR/DIuTClxehV6nwh3kF2NEopo2vfeLUyv9VxQI6lDk6FNkPkxOjKd
 Ig9eEAcpnQQGSsJRddwFRez4LzQnyuh/LLSBhJWL/WXIMU0s4hG8vtW8Jqw0/mO8Ag1ux182+Z
 MbOHcTFA1od+8eXbISm9vS8jm1Ij2PUIlXulyp7WlxM/+aDLAx9GMUXItJilrerByVphypJzc9
 Cpk=
X-IronPort-AV: E=Sophos;i="5.81,178,1610380800"; 
   d="scan'208";a="159925796"
Received: from mail-bl2nam02lp2050.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.50])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2021 22:21:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5OwAGpsJtgYhVKYUsv/vZMYrZ5kfYBhq70DlyK4cI88alxyDmiBiqU6cvKh6aGvBkosWrjBFlRv098e6sNiS3L072psYy8/P0h8/i2scEz3ASi9SNqPTCh5HHAxypkmbYh0M9tZx0oTcgcQAR1PSCIHcXsHSUqHUXvTOgvFQQDq2Snp8G5sqUZ/1y8MIyKwgEcTzcoBb0y11ujL/mc+BCgNr7nQUPZWrFXsWZraUJzJp9V4WIbGn80xf5zM2cR+sjBdXSlrPPAUCuSSuFEe4hGK6i/cjbDA2yLeAscJ+qjpZTzQMe3u4l6672q/2lYWMJpCQe1lm8OzZiJL0RhKXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZy+DrkC6V84wSrkL+VTy5dl5h9m42mhpGqCe5xaxlQ=;
 b=odkjZuIW2XtmWcKckjbakS3jgILQBaVjjYntVblro8AOHDCq2drhRi3a207vz7QRvXWR3vQ52v79fNjZ7piByGVJvXNBWGMcFuS/VQP6EE1tYs4J7DWozFVZv9KDXbdcu888uiIIashOQE+fIVV5RcUj0//ig+LBhlOMgg2y/aaKwqM1lZQ+565tKkBPtYr96YVS6CAk7gR5LLJqrQgxqBC4jM7Q5swJNFP1qqw9D6zH/kyTD/aDph1QaNqxeVOEnaHjzl+tsm82kwbEhqfXJrCbF4IfWVb1MEVsVFqrVlf2tecIsbxZYb66hDfXkKgknkXdr3AbILLeu1NDsRsRRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZy+DrkC6V84wSrkL+VTy5dl5h9m42mhpGqCe5xaxlQ=;
 b=kBVJoH1BH+648RS+G7IPAkA+r+oKSyOI31g9syr8pNDRaNFbTu2Ug0NOh/rnQy14Qu3atVJLbqsf+s61WZn7n0lYCYCdxwRNgkfUuArEMNwXy+GhrX5/keE1MS36sWMTYQ1XMdJcU9T5JHcZZt79PRsEclGnPBNRg3flIREcCrk=
Received: from CY4PR04MB0632.namprd04.prod.outlook.com (2603:10b6:903:e1::13)
 by CY4PR04MB0392.namprd04.prod.outlook.com (2603:10b6:903:b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Sun, 14 Feb
 2021 14:21:02 +0000
Received: from CY4PR04MB0632.namprd04.prod.outlook.com
 ([fe80::6088:d16e:1b49:6c1a]) by CY4PR04MB0632.namprd04.prod.outlook.com
 ([fe80::6088:d16e:1b49:6c1a%3]) with mapi id 15.20.3846.031; Sun, 14 Feb 2021
 14:21:02 +0000
From:   Arthur Simchaev <Arthur.Simchaev@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH] scsi: ufs: sysfs: add is_ascii_output entry
Thread-Topic: [PATCH] scsi: ufs: sysfs: add is_ascii_output entry
Thread-Index: AQHW/5sHTsWV8bv5R0C33pPiphtkYqpSTqiAgAUgsQCAAEppMA==
Date:   Sun, 14 Feb 2021 14:21:01 +0000
Message-ID: <CY4PR04MB0632E76E54562E36707B4BA3ED899@CY4PR04MB0632.namprd04.prod.outlook.com>
References: <1612954425-6705-1-git-send-email-Arthur.Simchaev@sandisk.com>
 <4bba4245-df01-f23d-65ba-4ff133cae0bc@acm.org> <YCjzKOEV9fUPf3Ja@kroah.com>
In-Reply-To: <YCjzKOEV9fUPf3Ja@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc5dabe9-5825-4452-56c8-08d8d0f3c1d4
x-ms-traffictypediagnostic: CY4PR04MB0392:
x-microsoft-antispam-prvs: <CY4PR04MB0392C73FD3B42D1DD4CE02FCED899@CY4PR04MB0392.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oWhOGuTy7MtievfjFHi9cf2WX1zSJeM1VkqeU/ZbgQ5YqYv1uMACXyfMKCpXUfx5ViaDBceF2kXLK406H/ov2gPv/NNs8zBEg7KyomOzw5JkJbbjoMgLH0C5GnBNWmg/Ic5wp4th1GBA48BFT+Um13vhs/wwUxW9LBzbvUDRPguBtohEuQR3VZA2DlFSKlrnYzZ7GKK6JllIxzmq6hWHbnxRDU4os4mLhkPv/Gt0qpxGuzj8FH7kh5ZU9aXOg3Gp3fpHkUfLYTOVgMeeUofZs+0nFOgcgN5ZAyyQErTwwOo5XTU5Ikqfq7XiBwc2Do8ebBRYhe0CyTzk2ELi0vIzPUYl6t6GtbIC3K5ovoMUp33bmnIojxhREuuKQ15VJH67nIkU4AB6tfMKqq+ASOK+JMYJrmhq8AipCU3eKvg8bmYIQ1KQGhhvVv17/Uh01yyXBLIBjiPrbB7lrnZ93kfDJ6x0Jf7PHPPj+Xx0vZnHaHCBTtTCqnzqqx+kxTu+MEr6rLyEVw3klqu+Y9DZWJBu5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB0632.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(66946007)(66556008)(9686003)(66476007)(55016002)(64756008)(66446008)(76116006)(8936002)(8676002)(110136005)(86362001)(6506007)(7696005)(71200400001)(54906003)(26005)(316002)(52536014)(5660300002)(4326008)(186003)(53546011)(2906002)(478600001)(33656002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uhcJmr/l83TqgdfA1lGfBKzilNOIcOnTMZ4m+iptXXS2Km3s/IH1vHaModF/?=
 =?us-ascii?Q?BbQ/wMGM6nQK6H1Obo5sSOWrbdAWWrBzNE7JdgORn+NJIZzsMSgSnED+8xR9?=
 =?us-ascii?Q?0/jIqlwoOx/WL4bgC9LzM1sIaDgTBQXSFP2TS2tm8/mRVHw53QQarvMV+JsL?=
 =?us-ascii?Q?hKiCGx+5u3uTgIWjM78jPHTEzL+xo4lLwDL9ExL1Fz2A0YFZnvqhoknBC+sw?=
 =?us-ascii?Q?cyN7wYdF5ce91FIT3JaPSsTfuvnn5btHQPz3xoEI/9fPiTg5U4qLps3dPi0W?=
 =?us-ascii?Q?y5UVGNifU5YA5OL/G+O+0LAVsrwDEuJAKoAFUkp02xCQF88G6DlQlYqsOkO8?=
 =?us-ascii?Q?FMw6YnbAFeqE9jWWMkfsn9uid6sRxgAeUPuSkaoQAv3wndLSitwduVwytBP5?=
 =?us-ascii?Q?RwU3wrUAJeZo5bRDf4af4aJBaZ3/a7v5OmB39NcPEKqIxQ35xKfF03kZzBCn?=
 =?us-ascii?Q?/eO1KBBOq8YjkuXZkamt9/YSvWpTDFwyQpj10y/2O0xkOubUgwQPj/jbAQZc?=
 =?us-ascii?Q?V9fYDuLiteWJeb3ZEtQ6CBybyZJRF/yK9rI45v3fyZOylwGBD86bLoDE3oRc?=
 =?us-ascii?Q?MBCg6uLpB+woOM6AHTH5+hIdrOpbNhwazQn6H0OjUYNGJFqTEUcGGNRPi0yk?=
 =?us-ascii?Q?jHBMnXCfRW5reLhxtYqYIY90gBTSYiZOpyWCFaf12BXtuzGljZdqD7+Lga2c?=
 =?us-ascii?Q?deGTYIdIx/P9Ui7BjWVD4DRfk/NLHWhvsOsh/Kkt2i7XirVY8bww52PLghvb?=
 =?us-ascii?Q?+QqQRcZapvPev6zczyWlLdHhEoW+7CeS1gDY7yI099TdFWE48hR9h2ObpJ/8?=
 =?us-ascii?Q?aKQzUTnCZmTggrhj8g4cl9FDykYybH4RRhErvLfJcmJQVUUB/N1xmXFQSyyN?=
 =?us-ascii?Q?ZzA11lSu/wENgP9FLVtueDvTuqwT+TzPY7+JkPqMxzPkTDMI9MuPjnSVQT+6?=
 =?us-ascii?Q?KHeaQGyUa/PH50aGZNgiuuktJkwJfanWJ7WikEeZNrTzfGSZKY+XEsh28fGX?=
 =?us-ascii?Q?20T1F2wSV10cHgLBUpK0ZKeC5FnA28hRQcAx3CGTCHFBaAhfkrAeH96a/FQC?=
 =?us-ascii?Q?38L0ZQN+Ql5xMj5kaEpadbVKC8Px1Zpm9SHicEOD5E0LHrEZoBGZBVYRw/Yd?=
 =?us-ascii?Q?ijwQMJWgb4vr7igoiCuYRZz286KBXYwb0CtqOzL9eeL+RiFeXzU0KoEMiyZw?=
 =?us-ascii?Q?7dCxAjP12gROzbxuERWH86s4sXN0T0w5VLmpgo6MHwpt15MLKvh2fUPVqxc2?=
 =?us-ascii?Q?/a5OImIFzDF9qlCcnzLffp5q+Sp8Mh4EGxa58Zk0TXtC3M8eYIVvnEMh6Q+V?=
 =?us-ascii?Q?SB43eiQUy/UQ+LpfstVvxPno?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB0632.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5dabe9-5825-4452-56c8-08d8d0f3c1d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2021 14:21:01.9344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3YQXF7VbDVN/kPC1kkthpcrKbY0K0QCFwJ6uxVdXVT3vkSz/V7uxdkqZKDeGeB6WxLOhqfmHKiwfzdx342SbgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0392
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Done.

Regards
Arthur

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Sunday, February 14, 2021 11:54 AM
> To: Bart Van Assche <bvanassche@acm.org>
> Cc: Arthur Simchaev <Arthur.Simchaev@wdc.com>; James E . J . Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K . Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; alim.akhtar@samsung.com; Bean Huo
> <beanhuo@micron.com>; Arthur Simchaev <Arthur.Simchaev@wdc.com>
> Subject: Re: [PATCH] scsi: ufs: sysfs: add is_ascii_output entry
>=20
> CAUTION: This email originated from outside of Western Digital. Do not cl=
ick
> on links or open attachments unless you recognize the sender and know tha=
t
> the content is safe.
>=20
>=20
> On Wed, Feb 10, 2021 at 07:35:25PM -0800, Bart Van Assche wrote:
> > On 2/10/21 2:53 AM, Arthur Simchaev wrote:
> > > +static bool is_ascii_output =3D true;
> >
> > [ ... ]
> >
> > >  static const char *ufschd_uic_link_state_to_string(
> > >                     enum uic_link_state state)
> > >  {
> > > @@ -693,7 +695,15 @@ static ssize_t _name##_show(struct device *dev,
> \
> > >                                   SD_ASCII_STD);                    \
> > >     if (ret < 0)                                                    \
> > >             goto out;                                               \
> > > -   ret =3D sysfs_emit(buf, "%s\n", desc_buf);                       =
 \
> > > +   if (is_ascii_output) {                                          \
> > > +           ret =3D sysfs_emit(buf, "%s\n", desc_buf);               =
 \
> > > +   } else {                                                        \
> > > +           int i;                                                  \
> > > +                                                                   \
> > > +           for (i =3D 0; i < desc_buf[0]; i++)                      =
 \
> > > +                   hex_byte_pack(buf + i * 2, desc_buf[i]);        \
> > > +           ret =3D sysfs_emit(buf, "%s\n", buf);                    =
 \
> > > +   }                                                               \
> > >  out:                                                                =
       \
> > >     pm_runtime_put_sync(hba->dev);                                  \
> > >     kfree(desc_buf);                                                \
> >
> > Please do not introduce a mode variable but instead introduce a new
> > attribute such that there is one attribute for the unicode output and
> > one attribute for the ASCII output. Mode variables are troublesome when
> > e.g. two scripts try to set the mode attribute concurrently.
>=20
> Agreed, just make a new sysfs file, please never change the output of an
> existing sysfs file, that way will guarantee confusion in userspace.
>=20
> thanks,
>=20
> greg k-h
